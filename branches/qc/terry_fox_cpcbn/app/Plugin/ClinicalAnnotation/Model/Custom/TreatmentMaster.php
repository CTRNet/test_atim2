<?php

class TreatmentMasterCustom extends TreatmentMaster
{

    var $useTable = 'treatment_masters';

    var $name = 'TreatmentMaster';

    public function validates($options = array())
    {
        $result = parent::validates($options);
        $treatmentControl = null;
        $allLinkedDiagmosisesIds = null;
        
        // check qc_tf_disease_free_survival_start_events can be set to 1
        if (array_key_exists('qc_tf_disease_free_survival_start_events', $this->data['TreatmentMaster']) && $this->data['TreatmentMaster']['qc_tf_disease_free_survival_start_events']) {
            $treatmentControl = $this->getTreatmentControlData();
            if (! in_array($treatmentControl['TreatmentControl']['tx_method'], array(
                'hormonotherapy',
                'RP',
                'radiation',
                'chemotherapy'
            ))) {
                $this->validationErrors['qc_tf_disease_free_survival_start_events'][] = "this treatment can not be defined as the 'disease free survival start event'";
                $result = false;
            } elseif ($this->data['TreatmentMaster']['diagnosis_master_id']) {
                // Get all diagnoses linked to the same primary
                $diagnosisModel = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
                $allLinkedDiagmosisesIds = $diagnosisModel->getAllTumorDiagnosesIds($this->data['TreatmentMaster']['diagnosis_master_id']);
                // Search existing trt linked to this cancer and already flagged as qc_tf_disease_free_survival_start_events
                $conditions = array(
                    'TreatmentMaster.diagnosis_master_id' => $allLinkedDiagmosisesIds,
                    'TreatmentMaster.qc_tf_disease_free_survival_start_events' => '1'
                );
                if ($this->id)
                    $conditions[] = 'TreatmentMaster.id != ' . $this->id;
                $count = $this->find('count', array(
                    'conditions' => $conditions
                ));
                if ($count) {
                    $this->validationErrors['qc_tf_disease_free_survival_start_events'][] = "a treatment or biopsy has already been defined as the 'disease free survival start event' for this cancer";
                    $result = false;
                }
            }
        }
        
        // check Dx Bx can only be created once per dx
        if (isset($this->data['TreatmentDetail']) && array_key_exists('type_specification', $this->data['TreatmentDetail']) && $this->data['TreatmentDetail']['type_specification'] == 'Dx' && $this->data['TreatmentMaster']['diagnosis_master_id']) {
            if (! $treatmentControl)
                $treatmentControl = $this->getTreatmentControlData();
            if ($treatmentControl['TreatmentControl']['tx_method'] == 'biopsy and turp') {
                // Get all diagnoses linked to the same primary
                $diagnosisModel = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
                if (! $allLinkedDiagmosisesIds)
                    $allLinkedDiagmosisesIds = $diagnosisModel->getAllTumorDiagnosesIds($this->data['TreatmentMaster']['diagnosis_master_id']);
                    // Search existing biopsies linked to this cancer and already flagged as Dx Bx
                $conditions = array(
                    'TreatmentMaster.diagnosis_master_id' => $allLinkedDiagmosisesIds,
                    'TreatmentDetail.type_specification' => 'Dx'
                );
                if ($this->id)
                    $conditions['NOT'] = array(
                        'TreatmentMaster.id' => $this->id
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
                $count = $this->find('count', array(
                    'conditions' => $conditions,
                    'joins' => $joins
                ));
                if ($count) {
                    $this->validationErrors['type'][] = "a biopsy or a turp has already been defined as the diagnosis method for this cancer";
                    $result = false;
                }
            }
        }
        
        return $result;
    }

    private function getTreatmentControlData()
    {
        $treatmentControlId = null;
        if (isset($this->data['TreatmentMaster']['treatment_control_id'])) {
            $treatmentControlId = $this->data['TreatmentMaster']['treatment_control_id'];
        } else {
            $tx = $this->find('first', array(
                'conditions' => array(
                    'TreatmentMaster.id' => $this->id
                ),
                'recursive' => -1
            ));
            $treatmentControlId = $tx['TreatmentMaster']['treatment_control_id'];
        }
        $treatmentControlModel = AppModel::getInstance('ClinicalAnnotation', 'TreatmentControl', true);
        $treatmentControl = $treatmentControlModel->find('first', array(
            'conditions' => array(
                'TreatmentControl.id' => $treatmentControlId
            )
        ));
        return $treatmentControl;
    }

    public function atimDelete($txMasterId, $cascade = true)
    {
        $deletedTxData = $this->find('first', array(
            'conditions' => array(
                'TreatmentMaster.id' => $txMasterId
            )
        ));
        $result = parent::atimDelete($txMasterId);
        if ($result && array_key_exists('qc_tf_disease_free_survival_start_events', $deletedTxData['TreatmentMaster']) && $deletedTxData['TreatmentMaster']['qc_tf_disease_free_survival_start_events'] && $deletedTxData['TreatmentMaster']['diagnosis_master_id']) {
            $diagnosisModel = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
            $diagnosisModel->calculateSurvivalAndBcr($deletedTxData['TreatmentMaster']['diagnosis_master_id']);
        }
        return $result;
    }

    public function afterSave($created, $options = Array())
    {
        parent::afterSave($created, $options);
        
        if ($this->name == 'TreatmentMaster') {
            $tx = $this->find('first', array(
                'conditions' => array(
                    'TreatmentMaster.id' => $this->id,
                    'deleted' => array(
                        '0',
                        '1'
                    )
                ),
                'recursive' => 0
            ));
            if ($tx['TreatmentControl']['tx_method'] == 'biopsy and turp' || $tx['TreatmentControl']['tx_method'] == 'RP') {
                $participantId = $tx['TreatmentMaster']['participant_id'];
                $diagnosisModel = AppModel::getInstance('ClinicalAnnotation', 'DiagnosisMaster', true);
                $prostateDxs = $diagnosisModel->find('all', array(
                    'conditions' => array(
                        'DiagnosisMaster.participant_id' => $participantId,
                        'DiagnosisControl.category' => 'primary',
                        'DiagnosisControl.controls_type' => 'prostate'
                    )
                ));
                foreach ($prostateDxs as $participantProstateDx) {
                    $diagnosisDetailDataTuUpdate = array();
                    $allLinkedDiagmosisesIds = $diagnosisModel->getAllTumorDiagnosesIds($participantProstateDx['DiagnosisMaster']['id']);
                    // Biopsy/TURP gleason
                    $dxGleasonScoreBiopsyTurp = $participantProstateDx['DiagnosisDetail']['gleason_score_biopsy_turp'];
                    $txGleasonScoreBiopsyTurp = '';
                    $conditions = array(
                        'TreatmentMaster.diagnosis_master_id' => $allLinkedDiagmosisesIds,
                        'TreatmentDetail.type_specification' => 'Dx',
                        'TreatmentControl.tx_method' => array(
                            'biopsy and turp'
                        )
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
                    $turpBiopsyDx = $this->find('first', array(
                        'conditions' => $conditions,
                        'joins' => $joins
                    ));
                    if ($turpBiopsyDx)
                        $txGleasonScoreBiopsyTurp = $turpBiopsyDx['TreatmentDetail']['gleason_score'];
                    if ($dxGleasonScoreBiopsyTurp != $txGleasonScoreBiopsyTurp)
                        $diagnosisDetailDataTuUpdate['gleason_score_biopsy_turp'] = $txGleasonScoreBiopsyTurp;
                        // Biopsy/TURP ctnm
                    $dxCtnmBiopsyTurp = $participantProstateDx['DiagnosisDetail']['ctnm'];
                    $txCtnmBiopsyTurp = '';
                    if ($turpBiopsyDx)
                        $txCtnmBiopsyTurp = $turpBiopsyDx['TreatmentDetail']['ctnm'];
                    if ($dxCtnmBiopsyTurp != $txCtnmBiopsyTurp)
                        $diagnosisDetailDataTuUpdate['ctnm'] = $txCtnmBiopsyTurp;
                        // RP gleason
                    $dxGleasonScoreRp = $participantProstateDx['DiagnosisDetail']['gleason_score_rp'];
                    $txGleasonScoreRp = '';
                    $conditions = array(
                        'TreatmentMaster.diagnosis_master_id' => $allLinkedDiagmosisesIds,
                        'TreatmentControl.tx_method' => array(
                            'RP'
                        )
                    );
                    $joins = array(
                        array(
                            'table' => 'txd_surgeries',
                            'alias' => 'TreatmentDetail',
                            'type' => 'INNER',
                            'conditions' => array(
                                'TreatmentMaster.id = TreatmentDetail.treatment_master_id'
                            )
                        )
                    );
                    $rp = $this->find('first', array(
                        'conditions' => $conditions,
                        'joins' => $joins
                    ));
                    if ($rp)
                        $txGleasonScoreRp = $rp['TreatmentDetail']['qc_tf_gleason_score'];
                    if ($dxGleasonScoreRp != $txGleasonScoreRp)
                        $diagnosisDetailDataTuUpdate['gleason_score_rp'] = $txGleasonScoreRp;
                        // Dx Update
                    if ($diagnosisDetailDataTuUpdate) {
                        $diagnosisData = array(
                            'DiagnosisMaster' => array(),
                            'DiagnosisDetail' => $diagnosisDetailDataTuUpdate
                        );
                        $diagnosisModel->id = $participantProstateDx['DiagnosisMaster']['id'];
                        $diagnosisModel->data = null;
                        $diagnosisModel->addWritableField(array(
                            'gleason_score_rp',
                            ''
                        ));
                        $diagnosisModel->save($diagnosisData, false);
                    }
                }
            }
        }
    }
}