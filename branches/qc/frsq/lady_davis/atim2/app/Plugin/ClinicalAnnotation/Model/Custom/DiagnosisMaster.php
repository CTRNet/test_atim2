<?php

class DiagnosisMasterCustom extends DiagnosisMaster
{

    var $useTable = 'diagnosis_masters';

    var $name = 'DiagnosisMaster';

    public function updateAgeAtDxAndSurvival($model, $primaryKeyId)
    {
        $criteria = array(
            'DiagnosisControl.category' => 'primary',
            'DiagnosisControl.controls_type' => array(
                'breast',
                'other'
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
            // Age At Dx
            $previousAgeAtDx = $newDx['DiagnosisMaster']['age_at_dx'];
            $newAgeAtDx = '';
            if ($newDx['DiagnosisMaster']['dx_date'] && $newDx['Participant']['date_of_birth']) {
                if (($newDx['DiagnosisMaster']['dx_date_accuracy'] != 'c') || ($newDx['Participant']['date_of_birth_accuracy'] != 'c'))
                    $warnings[1] = __('age at diagnosis has been calculated with at least one unaccuracy date');
                $startDate = new DateTime($newDx['Participant']['date_of_birth']);
                $endDate = new DateTime($newDx['DiagnosisMaster']['dx_date']);
                $interval = $startDate->diff($endDate);
                if ($interval->invert) {
                    $warnings[2] = __('unable to calculate age at diagnosis') . ': ' . __('error in the date definitions');
                } else {
                    $newAgeAtDx = $interval->y;
                    $newAgeAtDx = empty($newAgeAtDx) ? '0' : $newAgeAtDx;
                }
            } else {
                $warnings[3] = __('unable to calculate age at diagnosis') . ': ' . __('missing date');
            }
            if ($newAgeAtDx != $previousAgeAtDx) {
                $dxToUpdate[$dxId] = array(
                    'DiagnosisMaster' => array(
                        'id' => $dxId,
                        'age_at_dx' => $newAgeAtDx
                    )
                );
            }
            // Survival
            $previousSurvivalTimeMonths = $newDx['DiagnosisMaster']['survival_time_months'];
            $newSurvivalTimeMonths = '';
            if ($newDx['DiagnosisMaster']['dx_date'] && ($newDx['Participant']['date_of_death'] || $newDx['Participant']['qc_lady_last_contact_date'])) {
                $survivalEndDate = '';
                $survivalEndDateAccuracy = '';
                if ($newDx['Participant']['date_of_death_accuracy']) {
                    $survivalEndDate = $newDx['Participant']['date_of_death'];
                    $survivalEndDateAccuracy = $newDx['Participant']['date_of_death_accuracy'];
                } elseif ($newDx['Participant']['qc_lady_last_contact_date']) {
                    $survivalEndDate = $newDx['Participant']['qc_lady_last_contact_date'];
                    $survivalEndDateAccuracy = 'c';
                } else {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
                if (($newDx['DiagnosisMaster']['dx_date_accuracy'] != 'c') || ($survivalEndDateAccuracy != 'c'))
                    $warnings[1] = __('survival has been calculated with at least one unaccuracy date');
                $startDate = new DateTime($newDx['DiagnosisMaster']['dx_date']);
                $endDate = new DateTime($survivalEndDate);
                $interval = $startDate->diff($endDate);
                if ($interval->invert) {
                    $warnings[2] = __('unable to calculate survival') . ': ' . __('error in the date definitions');
                } else {
                    $newSurvivalTimeMonths = $interval->y * 12 + $interval->m;
                    $newSurvivalTimeMonths = empty($newSurvivalTimeMonths) ? '0' : $newSurvivalTimeMonths;
                }
            } else {
                $warnings[3] = __('unable to calculate survival') . ': ' . __('missing date');
            }
            if ($newSurvivalTimeMonths != $previousSurvivalTimeMonths) {
                if (isset($dxToUpdate[$dxId])) {
                    $dxToUpdate[$dxId]['DiagnosisMaster']['survival_time_months'] = $newSurvivalTimeMonths;
                } else {
                    $dxToUpdate[$dxId] = array(
                        'DiagnosisMaster' => array(
                            'id' => $dxId,
                            'survival_time_months' => $newSurvivalTimeMonths
                        )
                    );
                }
            }
        }
        foreach ($warnings as $newWarning)
            AppController::getInstance()->addWarningMsg($newWarning);
        
        $this->addWritableField(array(
            'age_at_dx',
            'survival_time_months'
        ));
        foreach ($dxToUpdate as $dxData) {
            $this->data = array();
            $this->id = $dxData['DiagnosisMaster']['id'];
            if (! $this->save($dxData, false))
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
    }

    public function afterSave($created, $options = Array())
    {
        if (isset($this->data['DiagnosisDetail']['laterality'])) {
            $this->validateLaterality($this->id);
        }
        parent::afterSave($created);
    }

    public function validateLaterality($diagnosisMasterId)
    {
        $this->unbindModel(array(
            'hasMany' => array(
                'Collection'
            )
        ));
        $this->bindModel(array(
            'hasMany' => array(
                'TreatmentMaster' => array(
                    'className' => 'ClinicalAnnotation.TreatmentMaster',
                    'foreignKey' => 'diagnosis_master_id'
                ),
                'EventMaster' => array(
                    'className' => 'ClinicalAnnotation.EventMaster',
                    'foreignKey' => 'diagnosis_master_id'
                )
            )
        ));
        $res = $this->find('first', array(
            'conditions' => array(
                'DiagnosisMaster.id' => $diagnosisMasterId,
                'DiagnosisControl.category' => 'primary',
                'DiagnosisControl.controls_type' => 'breast'
            )
        ));
        if ($res && in_array($res['DiagnosisDetail']['laterality'], array(
            'left',
            'right'
        ))) {
            $wrongLaterality = $res['DiagnosisDetail']['laterality'] == 'left' ? 'right' : 'left';
            $warning = false;
            foreach ($res['EventMaster'] as $newEvent)
                if ($newEvent['qc_lady_clinic_imaging_laterality'] == $wrongLaterality)
                    $warning = true;
            foreach ($res['TreatmentMaster'] as $newTrt)
                if ($newTrt['qc_lady_laterality'] == $wrongLaterality)
                    $warning = true;
            if ($warning)
                AppController::addWarningMsg(__('diagnosis, treatments and/or events lateralities mismatch'));
        }
    }

    /**
     *
     * @param mixed $results            
     * @param bool $primary            
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        $results = parent::afterFind($results, $primary);
        foreach ($results as &$newRdx) {
            if (isset($newRdx['DiagnosisControl']['controls_type']) && $newRdx['DiagnosisControl']['controls_type'] == 'breast' && isset($newRdx['DiagnosisDetail'])) {
                $newRdx['DiagnosisDetail']['qc_lady_tumor_site'] = 'breast-breast';
            }
        }
        return $results;
    }

    function getParticipantDiagnosisList($participantId = null)
    {
        if ($participantId) {
            $participantDiagnosis = $this->find('all', array(
                'conditions' => array(
                    'DiagnosisMaster.participant_id' => $participantId
                ),
                'order' => array(
                    'DiagnosisMaster.id ASC'
                )
            ));
            $structurePermissibleValuesCustom = AppModel::getInstance("", "StructurePermissibleValuesCustom", true);
            $qcLadyTumorSite = $structurePermissibleValuesCustom->getCustomDropdown(array(
                'Tumor Sites'
            ));
            $qcLadyTumorSite = array_merge($qcLadyTumorSite['defined'], $qcLadyTumorSite['previously_defined']);
            $participantDiagnosisList = array();
            $rowToDisplay = '';
            foreach ($participantDiagnosis as $newDx) {
                if (empty($newDx['DiagnosisMaster']['parent_id'])) {
                    $rowToDisplay = '';
                } else {
                    if (! isset($participantDiagnosisList[$newDx['DiagnosisMaster']['parent_id']])) {
                        $rowToDisplay = '? ';
                    } else {
                        if ($newDx['DiagnosisMaster']['parent_id'] == $newDx['DiagnosisMaster']['primary_id']) {
                            $rowToDisplay = '... ';
                        } else {
                            $rowToDisplay = '...... ';
                        }
                    }
                }
                $category = __($newDx['DiagnosisControl']['category']);
                $controlsType = ($newDx['DiagnosisControl']['controls_type'] != 'undetailed') ? __($newDx['DiagnosisControl']['controls_type']) : '';
                $date = $newDx['DiagnosisMaster']['dx_date'];
                $accuracy = $newDx['DiagnosisMaster']['dx_date_accuracy'];
                if ($accuracy == 'd') {
                    $date = substr($date, 0, 7);
                } elseif ($accuracy == 'm') {
                    $date = substr($date, 0, 4);
                } elseif ($accuracy == 'y') {
                    $date = '±' . substr($date, 0, 4);
                }
                $date = empty($date) ? '?' : $date;
                $precision = '';
                if (isset($newDx['DiagnosisDetail']['qc_lady_tumor_site']) && $newDx['DiagnosisDetail']['qc_lady_tumor_site']) {
                    $precision = ' : ' . $qcLadyTumorSite[$newDx['DiagnosisDetail']['qc_lady_tumor_site']];
                }
                $participantDiagnosisList[$newDx['DiagnosisMaster']['id']] = "$rowToDisplay$category-$controlsType ($date)$precision";
            }
            return $participantDiagnosisList;
        }
        return array();
    }
}