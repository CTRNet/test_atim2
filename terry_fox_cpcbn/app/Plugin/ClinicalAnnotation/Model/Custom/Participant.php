<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            $bankIdentfiers = CONFIDENTIAL_MARKER;
            if ($result['Participant']['qc_tf_bank_participant_identifier'] != CONFIDENTIAL_MARKER) {
                $bankModel = AppModel::getInstance('Administrate', 'Bank', true);
                $bank = $bankModel->find('first', array(
                    'conditions' => array(
                        'Bank.id' => $result['Participant']['qc_tf_bank_id']
                    )
                ));
                $bankIdentfiers = (empty($bank['Bank']['name']) ? '?' : $bank['Bank']['name']) . ' : ' . $result['Participant']['qc_tf_bank_participant_identifier'];
            }
            
            $label = $bankIdentfiers . ' [' . $result['Participant']['participant_identifier'] . ']';
            $return = array(
                'menu' => array(
                    null,
                    $label
                ),
                'title' => array(
                    null,
                    $label
                ),
                'structure alias' => 'participants',
                'data' => $result
            );
            
            $diagnosisModel = AppModel::getInstance("ClinicalAnnotation", "DiagnosisMaster", true);
            $treatmentModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
            $allParticipantDx = $diagnosisModel->find('all', array(
                'conditions' => array(
                    'DiagnosisMaster.participant_id' => $variables['Participant.id'],
                    'DiagnosisControl.category' => 'primary',
                    'DiagnosisControl.controls_type' => 'prostate'
                ),
                'recursive' => 0
            ));
            foreach ($allParticipantDx as $newDx) {
                $isBiopsyTurpDxMethod = in_array($newDx['DiagnosisDetail']['tool'], array(
                    'biopsy',
                    'TURP',
                    'TRUS-guided biopsy'
                )) ? true : false;
                $allLinkedDiagmosisesIds = $diagnosisModel->getAllTumorDiagnosesIds($newDx['DiagnosisMaster']['id']);
                // Get Biopsy 'dx Bx'
                $conditions = array(
                    'TreatmentMaster.diagnosis_master_id' => $allLinkedDiagmosisesIds,
                    'TreatmentDetail.type_specification' => 'Dx'
                );
                $joins = array(
                    array(
                        'table' => 'qc_tf_txd_biopsies_and_turps',
                        'alias' => 'TreatmentDetail',
                        'type' => 'INNER',
                        'conditions' => array(
                            'TreatmentMaster.id = TreatmentDetail.treatment_master_id'
                        )
                    )
                );
                $biopsyTurpAtDx = $treatmentModel->find('first', array(
                    'conditions' => $conditions,
                    'joins' => $joins
                ));
                // checks
                if (empty($biopsyTurpAtDx) && $isBiopsyTurpDxMethod) {
                    AppController::addWarningMsg(__('the biopsy or the turp used for the diagnosis is missing into the system'));
                } elseif (! empty($biopsyTurpAtDx) && ! $isBiopsyTurpDxMethod) {
                    AppController::addWarningMsg(__('a biopsy or a turp is defined as diagnosis method but the method of the diagnosis is set to something else'));
                } elseif ($biopsyTurpAtDx && $isBiopsyTurpDxMethod) {
                    if ($biopsyTurpAtDx['TreatmentMaster']['start_date'] != $newDx['DiagnosisMaster']['dx_date'] || $biopsyTurpAtDx['TreatmentMaster']['start_date_accuracy'] != $newDx['DiagnosisMaster']['dx_date_accuracy']) {
                        AppController::addWarningMsg(__('the date of the biopsy or turp used for diagnosis is different than the date of diagnosis'));
                    }
                    if (($newDx['DiagnosisDetail']['tool'] == 'biopsy' && $biopsyTurpAtDx['TreatmentDetail']['type'] != 'Bx')
                    || ($newDx['DiagnosisDetail']['tool'] == 'TURP' && $biopsyTurpAtDx['TreatmentDetail']['type'] != 'TURP')
                    || ($newDx['DiagnosisDetail']['tool'] == 'TRUS-guided biopsy' && $biopsyTurpAtDx['TreatmentDetail']['type'] != 'Bx TRUS-Guided')) {
                        AppController::addWarningMsg(__('the method of the diagnosis (biopsy, TRUS-guided biopsy or TURP) is different than the type set for the biopsy or a turp record'));
                    }
                }
            }
        }
        
        return $return;
    }

    public function validates($options = array())
    {
        $result = parent::validates($options);
        
        if (array_key_exists('qc_tf_bank_id', $this->data['Participant'])) {
            $conditions = array(
                'Participant.qc_tf_bank_id' => $this->data['Participant']['qc_tf_bank_id'],
                'Participant.qc_tf_bank_participant_identifier' => $this->data['Participant']['qc_tf_bank_participant_identifier']
            );
            if ($this->id)
                $conditions[] = 'Participant.id != ' . $this->id;
            
            $count = $this->find('count', array(
                'conditions' => $conditions
            ));
            if ($count) {
                $this->validationErrors['qc_tf_bank_participant_identifier'][] = 'this bank participant identifier has already been assigned to a patient of this bank';
                $result = false;
            }
        }
        
        return $result;
    }

    public function beforeFind($queryData)
    {
        if (($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions']) && AppModel::isFieldUsedAsCondition("Participant.qc_tf_bank_participant_identifier", $queryData['conditions'])) {
            AppController::addWarningMsg(__('your search will be limited to your bank'));
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = $groupData['Group']['bank_id'];
            $queryData['conditions'][] = array(
                "Participant.qc_tf_bank_id" => $userBankId
            );
        }
        return $queryData;
    }

    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results);
        if ($_SESSION['Auth']['User']['group_id'] != '1') {
            $GroupModel = AppModel::getInstance("", "Group", true);
            $groupData = $GroupModel->findById($_SESSION['Auth']['User']['group_id']);
            $userBankId = $groupData['Group']['bank_id'];
            if (isset($results[0]['Participant']['qc_tf_bank_id']) || isset($results[0]['Participant']['qc_tf_bank_participant_identifier'])) {
                foreach ($results as &$result) {
                    if ((! isset($result['Participant']['qc_tf_bank_id'])) || $result['Participant']['qc_tf_bank_id'] != $userBankId) {
                        $result['Participant']['qc_tf_bank_id'] = CONFIDENTIAL_MARKER;
                        $result['Participant']['qc_tf_bank_participant_identifier'] = CONFIDENTIAL_MARKER;
                    }
                }
            } elseif (isset($results['Participant'])) {
                pr('TODO afterFind participants');
                pr($results);
                exit();
            }
        }
        
        return $results;
    }
}