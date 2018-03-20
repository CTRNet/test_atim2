<?php

class DiagnosisMasterCustom extends DiagnosisMaster
{

    var $useTable = 'diagnosis_masters';

    var $name = 'DiagnosisMaster';

    public function validates($options = array())
    {
        $result = parent::validates($options);
        
        if (array_key_exists('first_biochemical_recurrence', $this->data['DiagnosisDetail']) && $this->data['DiagnosisDetail']['first_biochemical_recurrence']) {
            // Get all diagnoses linked to the same primary
            $dxIdForSearch = array_key_exists('primary_id', $this->data['DiagnosisMaster']) ? $this->data['DiagnosisMaster']['primary_id'] : $this->id;
            if (empty($dxIdForSearch))
                AppController::getInstance()->redirect('/Pages/err_plugin_no_data?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $allLinkedDiagmosisesIds = $this->getAllTumorDiagnosesIds($dxIdForSearch);
            
            // Search existing BCR linked to this cancer already flagged as first_biochemical_recurrence
            $conditions = array(
                'DiagnosisMaster.id' => $allLinkedDiagmosisesIds,
                'DiagnosisDetail.first_biochemical_recurrence' => '1'
            );
            if ($this->id)
                $conditions[] = 'DiagnosisMaster.id != ' . $this->id;
            $joins = array(
                array(
                    'table' => 'qc_tf_dxd_recurrence_bio',
                    'alias' => 'DiagnosisDetail',
                    'type' => 'INNER',
                    'conditions' => array(
                        'DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id'
                    )
                )
            );
            $count = $this->find('count', array(
                'conditions' => $conditions,
                'joins' => $joins
            ));
            if ($count) {
                $this->validationErrors['first_biochemical_recurrence'][] = "a bcr has already been defined as first bcr for this cancer";
                $result = false;
            }
        }
        
        return $result;
    }

    public function calculateSurvivalAndBcr($studiedDiagnosisId)
    {
        if (empty($studiedDiagnosisId))
            return;
        
        $allLinkedDiagnosesIds = $this->getAllTumorDiagnosesIds($studiedDiagnosisId);
        $conditions = array(
            'DiagnosisMaster.id' => $allLinkedDiagnosesIds,
            'DiagnosisMaster.deleted != 1',
            'DiagnosisControl.category' => 'primary',
            'DiagnosisControl.controls_type' => 'prostate'
        );
        $prostateDx = $this->find('first', array(
            'conditions' => $conditions
        ));
        
        if (! empty($prostateDx)) {
            $participantId = $prostateDx['DiagnosisMaster']['participant_id'];
            $primaryId = $prostateDx['DiagnosisMaster']['id'];
            $primaryDiagnosisControlId = $prostateDx['DiagnosisMaster']['diagnosis_control_id'];
            
            $previousSurvival = $prostateDx['DiagnosisDetail']['survival_in_months'];
            $previousBcr = $prostateDx['DiagnosisDetail']['bcr_in_months'];
            
            // Get 1st BCR
            
            $conditions = array(
                'DiagnosisMaster.primary_id' => $primaryId,
                'DiagnosisMaster.deleted != 1',
                'DiagnosisDetail.first_biochemical_recurrence' => '1'
            );
            $joins = array(
                array(
                    'table' => 'qc_tf_dxd_recurrence_bio',
                    'alias' => 'DiagnosisDetail',
                    'type' => 'INNER',
                    'conditions' => array(
                        'DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id'
                    )
                )
            );
            $bcr = $this->find('first', array(
                'conditions' => $conditions,
                'joins' => $joins
            ));
            
            $bcrDate = empty($bcr) ? '' : $bcr['DiagnosisMaster']['dx_date'];
            $bcrAccuracy = empty($bcr) ? '' : $bcr['DiagnosisMaster']['dx_date_accuracy'];
            
            // Get 1st DFS
            
            $treatmentMasterModel = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster', true);
            $conditions = array(
                'TreatmentMaster.diagnosis_master_id' => $allLinkedDiagnosesIds,
                'TreatmentMaster.deleted != 1',
                'TreatmentMaster.qc_tf_disease_free_survival_start_events' => '1'
            );
            $dfs = $treatmentMasterModel->find('first', array(
                'conditions' => $conditions
            ));
            
            $dfsDate = empty($dfs) ? '' : $dfs['TreatmentMaster']['start_date'];
            $dfsAccuracy = empty($dfs) ? '' : $dfs['TreatmentMaster']['start_date_accuracy'];
            
            // Get survival end date
            
            $participantModel = AppModel::getInstance('ClinicalAnnotation', 'Participant', true);
            $participant = $participantModel->find('first', array(
                'conditions' => array(
                    'Participant.id' => $participantId
                )
            ));
            
            $survivalEndDate = '';
            $survivalEndDateAccuracy = '';
            if (! empty($participant['Participant']['date_of_death'])) {
                $survivalEndDate = $participant['Participant']['date_of_death'];
                $survivalEndDateAccuracy = $participant['Participant']['date_of_death_accuracy'];
            } elseif (! empty($participant['Participant']['qc_tf_last_contact'])) {
                $survivalEndDate = $participant['Participant']['qc_tf_last_contact'];
                $survivalEndDateAccuracy = $participant['Participant']['qc_tf_last_contact_accuracy'];
            }
            
            // Calculate Survival
            
            $newSurvival = '';
            if (! empty($dfsDate) && ! empty($survivalEndDate)) {
                if (in_array($survivalEndDateAccuracy . $dfsAccuracy, array(
                    'cc',
                    'cd',
                    'dc'
                ))) {
                    if ($survivalEndDateAccuracy . $dfsAccuracy != 'cc') {
                        AppController::getInstance()->addWarningMsg(__('survival has been calculated with at least one unaccuracy date'));
                    }
                    $dfsDateOb = new DateTime($dfsDate);
                    $survivalEndDateOb = new DateTime($survivalEndDate);
                    $interval = $dfsDateOb->diff($survivalEndDateOb);
                    if ($interval->invert) {
                        AppController::getInstance()->addWarningMsg(__('survival cannot be calculated because dates are not chronological'));
                    } else {
                        $newSurvival = $interval->y * 12 + $interval->m;
                    }
                } else {
                    AppController::getInstance()->addWarningMsg(__('survival cannot be calculated on inaccurate dates'));
                }
            }
            
            // Calculate bcr
            
            $newBcr = '';
            if (! empty($dfsDate) && ! empty($bcrDate)) {
                if (in_array($dfsAccuracy . $bcrAccuracy, array(
                    'cc',
                    'cd',
                    'dc'
                ))) {
                    if ($dfsAccuracy . $bcrAccuracy != 'cc') {
                        AppController::getInstance()->addWarningMsg(__('bcr has been calculated with at least one unaccuracy date'));
                    }
                    $dfsDateOb = new DateTime($dfsDate);
                    $bcrDateOb = new DateTime($bcrDate);
                    $interval = $dfsDateOb->diff($bcrDateOb);
                    if ($interval->invert) {
                        AppController::getInstance()->addWarningMsg(__('bcr cannot be calculated because dates are not chronological'));
                    } else {
                        $newBcr = $interval->y * 12 + $interval->m;
                    }
                } else {
                    AppController::getInstance()->addWarningMsg(__('bcr cannot be calculated on inaccurate dates'));
                }
            } else {
                $newBcr = $newSurvival;
            }
            
            // Data to update
            
            $dataToUpdate = array(
                'DiagnosisMaster' => array(
                    'diagnosis_control_id' => $primaryDiagnosisControlId
                )
            );
            if ($newBcr != $previousBcr)
                $dataToUpdate['DiagnosisDetail']['bcr_in_months'] = $newBcr;
            if ($newSurvival != $previousSurvival)
                $dataToUpdate['DiagnosisDetail']['survival_in_months'] = $newSurvival;
            if (sizeof($dataToUpdate) != 1) {
                $this->data = array();
                $this->id = $primaryId;
                if (! $this->save($dataToUpdate))
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
    }

    public function getAllTumorDiagnosesIds($diagnosisMasterId)
    {
        $allLinkedDiagmosisesIds = array();
        $studiedDiagnosisData = $this->find('first', array(
            'conditions' => array(
                'DiagnosisMaster.id' => $diagnosisMasterId
            ),
            'recursive' => -1
        ));
        if (! empty($studiedDiagnosisData)) {
            $allLinkedDiagmosises = $this->find('all', array(
                'conditions' => array(
                    'DiagnosisMaster.primary_id' => $studiedDiagnosisData['DiagnosisMaster']['primary_id']
                ),
                'fields' => array(
                    'DiagnosisMaster.id'
                ),
                'recursive' => -1
            ));
            $allLinkedDiagmosisesIds = array();
            foreach ($allLinkedDiagmosises as $newDx)
                $allLinkedDiagmosisesIds[] = $newDx['DiagnosisMaster']['id'];
        }
        return $allLinkedDiagmosisesIds;
    }

    public function atimDelete($diagnosisMasterId, $cascade = true)
    {
        $deletedDiagnosisMasterData = $this->find('first', array(
            'conditions' => array(
                'DiagnosisMaster.id' => $diagnosisMasterId
            )
        ));
        $result = parent::atimDelete($diagnosisMasterId);
        if ($result && array_key_exists('first_biochemical_recurrence', $deletedDiagnosisMasterData['DiagnosisDetail']) && $deletedDiagnosisMasterData['DiagnosisDetail']['first_biochemical_recurrence']) {
            $this->calculateSurvivalAndBcr($deletedDiagnosisMasterData['DiagnosisMaster']['primary_id']);
        }
        return $result;
    }

    public function updateAgeAtDx($model, $primaryKeyId)
    {
        $criteria = array(
            'DiagnosisControl.category' => 'primary',
            'DiagnosisControl.controls_type' => array(
                'other',
                'prostate'
            ),
            'DiagnosisMaster.deleted <> 1',
            $model . '.id' => $primaryKeyId
        );
        $joins = array(
            array(
                'table' => 'participants',
                'alias' => 'Participant',
                'type' => 'INNER',
                'conditions' => array(
                    'Participant.id = DiagnosisMaster.participant_id'
                )
            )
        );
        $dxToCheck = $this->find('all', array(
            'conditions' => $criteria,
            'joins' => $joins,
            'recursive' => 0,
            'fields' => array(
                'Participant.*, DiagnosisMaster.*'
            )
        ));
        
        $dxToUpdate = array();
        $warnings = array();
        foreach ($dxToCheck as $newDx) {
            $dxId = $newDx['DiagnosisMaster']['id'];
            $previousAgeAtDx = $newDx['DiagnosisMaster']['age_at_dx'];
            if ($newDx['DiagnosisMaster']['dx_date'] && $newDx['Participant']['date_of_birth']) {
                if (($newDx['DiagnosisMaster']['dx_date_accuracy'] != 'c') || ($newDx['Participant']['date_of_birth_accuracy'] != 'c'))
                    $warnings[- 1] = __('age at diagnosis has been calculated with at least one unaccuracy date');
                $arrSpentTime = $this->getSpentTime($newDx['Participant']['date_of_birth'] . ' 00:00:00', $newDx['DiagnosisMaster']['dx_date'] . ' 00:00:00');
                if ($arrSpentTime['message']) {
                    $warnings[$arrSpentTime['message']] = __('unable to calculate age at diagnosis') . ': ' . __($arrSpentTime['message']);
                    $dxToUpdate[] = array(
                        'DiagnosisMaster' => array(
                            'id' => $dxId,
                            'age_at_dx' => ''
                        )
                    );
                } elseif ($arrSpentTime['years'] != $previousAgeAtDx) {
                    $dxToUpdate[] = array(
                        'DiagnosisMaster' => array(
                            'id' => $dxId,
                            'age_at_dx' => $arrSpentTime['years']
                        )
                    );
                }
            } else {
                $warnings['missing date'] = __('unable to calculate age at diagnosis') . ': ' . __('missing date');
                $dxToUpdate[] = array(
                    'DiagnosisMaster' => array(
                        'id' => $dxId,
                        'age_at_dx' => ''
                    )
                );
            }
        }
        foreach ($warnings as $newWarning)
            AppController::getInstance()->addWarningMsg($newWarning);
        
        $this->addWritableField(array(
            'age_at_dx'
        ));
        foreach ($dxToUpdate as $dxData) {
            $this->data = array();
            $this->id = $dxData['DiagnosisMaster']['id'];
            if (! $this->save($dxData, false))
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
    }
}