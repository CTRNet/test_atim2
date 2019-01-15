<?php

class DiagnosisMasterCustom extends DiagnosisMaster
{

    var $useTable = 'diagnosis_masters';

    var $name = 'DiagnosisMaster';

    public function beforeSave($options = array())
    {
        if (array_key_exists('DiagnosisMaster', $this->data) && array_key_exists('dx_date', $this->data['DiagnosisMaster'])) {
            // Get Participant Id
            $participantId = null;
            if (isset($this->data['DiagnosisMaster']['participant_id'])) {
                $participantId = $this->data['DiagnosisMaster']['participant_id'];
            } elseif (isset($this->id)) {
                $dxData = $this->find('first', array(
                    'conditions' => array(
                        'DiagnosisMaster.id' => $this->id
                    ),
                    'fields' => array(
                        'DiagnosisMaster.participant_id'
                    )
                ));
                $participantId = $dxData['DiagnosisMaster']['participant_id'];
            } else {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            if (! $participantId) {
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
            
            // Get Participant Data
            $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
            $participantData = $participantModel->getOrRedirect($participantId);
            
            // Calculate age at dx
            $startDate = $participantData['Participant']['date_of_birth'];
            $startDateAccuracy = $participantData['Participant']['date_of_birth_accuracy'];
            $startDateOb = new DateTime($startDate);
            $endDate = $this->data['DiagnosisMaster']['dx_date'];
            $endDateAccuracy = $this->data['DiagnosisMaster']['dx_date_accuracy'];
            $endDateOb = new DateTime($endDate);
            $ageAtDx = '';
            if ($startDate && $endDate) {
                $interval = $startDateOb->diff($endDateOb);
                if ($interval->invert) {
                    AppController::addWarningMsg(__("'age at dx' cannot be calculated because dates are not chronological"));
                } else {
                    $ageAtDx = $interval->y;
                }
                if ($ageAtDx && ($startDateAccuracy . $endDateAccuracy) != 'cc') {
                    AppController::addWarningMsg(__("'age at dx' has been calculated with at least one inaccurate date"));
                }
            }
            $this->data['DiagnosisMaster']['age_at_dx'] = $ageAtDx;
            $this->addWritableField(array(
                'age_at_dx'
            ));
        }
        return parent::beforeSave($options);
    }

    public function updateAgeAtDx($participantId)
    {
        // Get Participant Data
        $participantModel = AppModel::getInstance("ClinicalAnnotation", "Participant", true);
        $participantData = $participantModel->getOrRedirect($participantId);
        $startDate = $participantData['Participant']['date_of_birth'];
        $startDateAccuracy = $participantData['Participant']['date_of_birth_accuracy'];
        $startDateOb = new DateTime($startDate);
        
        // Calculate age at dx for all dx
        $allDxData = $this->find('all', array(
            'conditions' => array(
                'DiagnosisMaster.participant_id' => $participantId
            )
        ));
        foreach ($allDxData as $newParticipantDx) {
            $endDate = $newParticipantDx['DiagnosisMaster']['dx_date'];
            $endDateAccuracy = $newParticipantDx['DiagnosisMaster']['dx_date_accuracy'];
            $endDateOb = new DateTime($endDate);
            $ageAtDx = '';
            if ($startDate && $endDate) {
                $interval = $startDateOb->diff($endDateOb);
                if ($interval->invert) {
                    AppController::addWarningMsg(__("'age at dx' cannot be calculated because dates are not chronological"));
                } else {
                    $ageAtDx = $interval->y;
                }
                if ($ageAtDx && ($startDateAccuracy . $endDateAccuracy) != 'cc') {
                    AppController::addWarningMsg(__("'age at dx' has been calculated with at least one inaccurate date"));
                }
            }
            if ($newParticipantDx['DiagnosisMaster']['age_at_dx'] != $ageAtDx) {
                $this->data = array();
                $this->id = $newParticipantDx['DiagnosisMaster']['id'];
                $this->addWritableField(array(
                    'age_at_dx'
                ));
                if (! $this->save(array(
                    'DiagnosisMaster' => array(
                        'id' => $this->id,
                        'age_at_dx' => $ageAtDx
                    )
                ), false)) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                }
            }
        }
    }
}