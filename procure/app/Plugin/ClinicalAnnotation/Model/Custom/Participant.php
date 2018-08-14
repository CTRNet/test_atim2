<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    var $participantIdentifierForFormValidation = null;

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            $tructureAlias = 'participants';
            if (Configure::read('procure_atim_version') == 'BANK') {
                // Add RAMQ and hospital number to the summary the sumamry
                $MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
                $identifiers = $MiscIdentifier->find('all', array(
                    'conditions' => array(
                        'MiscIdentifier.participant_id' => $result['Participant']['id']
                    )
                ));
                $result[0] = array(
                    'RAMQ' => '',
                    'hospital_number' => ''
                );
                foreach ($identifiers as $newId)
                    $result['0'][str_replace(' ', '_', $newId['MiscIdentifierControl']['misc_identifier_name'])] = $newId['MiscIdentifier']['identifier_value'];
                $tructureAlias = 'participants,procure_miscidentifiers_for_participant_summary';
                // Add warning on participant of another bank that is not transferred...
                if (strpos($result['Participant']['participant_identifier'], 'PS' . Configure::read('procure_bank_id')) === false && $result['Participant']['procure_transferred_participant'] == 'n') {
                    AppController::addWarningMsg(__('participant of another bank but not transferred - no data entry'));
                }
            }
            
            $return = array(
                'menu' => array(
                    null,
                    ($result['Participant']['participant_identifier'])
                ),
                'title' => array(
                    null,
                    ($result['Participant']['participant_identifier'])
                ),
                'structure alias' => $tructureAlias,
                'data' => $result
            );
            
            if ($result['Participant']['procure_patient_withdrawn'])
                AppController::addWarningMsg(__('patient withdrawn'));
        }
        
        return $return;
    }

    public function getBankParticipantIdentification()
    {
        return 'PS' . Configure::read('procure_bank_id') . 'P0';
    }

    public function beforeValidate($options = Array())
    {
        $result = parent::beforeValidate($options);
        if (isset($this->data['Participant']['procure_transferred_participant'])) {
            if (empty($this->data['Participant']['procure_transferred_participant'])) {
                $result = false;
                $this->validationErrors['participant_identifier'][] = "the 'transferred participant' value has to be set";
            } else {
                if (isset($this->data['Participant']['participant_identifier'])) {
                    $idPattern = "/^" . (($this->data['Participant']['procure_transferred_participant'] != 'y') ? $this->getBankParticipantIdentification() : 'PS[1-4]P0') . "([0-9]{3})$/";
                    if (! preg_match($idPattern, $this->data['Participant']['participant_identifier'])) {
                        $result = false;
                        $this->validationErrors['participant_identifier'][] = "the identification format is wrong";
                    }
                }
            }
        } elseif (isset($this->data['Participant']['participant_identifier'])) {
            // Field 'procure_transferred_participant' has to be set
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        if (array_key_exists('date_of_death', $this->data['Participant'])) {
            if (($this->data['Participant']['date_of_death'] || $this->data['Participant']['procure_cause_of_death']) && $this->data['Participant']['vital_status'] != 'deceased') {
                $this->data['Participant']['vital_status'] = 'deceased';
                AppController::addWarningMsg(__('changed vital status to deceased'));
            }
        }
        
        return $result;
    }

    public function buildAddProcureFormsButton($participantId)
    {
        $addLinks = array();
        
        $addLinks['add collection'] = array(
            'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $participantId,
            'icon' => 'collection'
        );
        $tmpUrl = $this->getClinicalFileUpdateProcessUrl($participantId, '1');
        if ($tmpUrl)
            $addLinks['update clinical record'] = array(
                'link' => $tmpUrl['url'],
                'icon' => 'duplicate'
            );
        $addLinks['add procure clinical information'] = array();
        // Consent
        $consentModel = AppModel::getInstance("ClinicalAnnotation", "ConsentControl", true);
        $consentControlsList = $consentModel->find('all', array(
            'conditions' => array(
                'flag_active' => '1'
            )
        ));
        $addLinksTmp = array();
        foreach ($consentControlsList as $consentControl) {
            $addLinksTmp[__($consentControl['ConsentControl']['controls_type'])] = array(
                'link' => '/ClinicalAnnotation/ConsentMasters/add/' . $participantId . '/' . $consentControl['ConsentControl']['id'] . '/',
                'icon' => 'consents'
            );
        }
        ksort($addLinksTmp);
        $addLinks['add procure clinical information'] = array_merge($addLinks['add procure clinical information'], $addLinksTmp);
        // Event
        $eventModel = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
        $eventControlsList = $eventModel->find('all', array(
            'conditions' => array(
                'flag_active' => '1'
            )
        ));
        $addLinksTmp = array();
        foreach ($eventControlsList as $eventCtrl) {
            $addLinksTmp[__($eventCtrl['EventControl']['event_type'])] = array(
                'link' => '/ClinicalAnnotation/EventMasters/add/' . $participantId . '/' . $eventCtrl['EventControl']['id'] . '/',
                'icon' => 'annotation'
            );
        }
        ksort($addLinksTmp);
        $addLinks['add procure clinical information'] = array_merge($addLinks['add procure clinical information'], $addLinksTmp);
        // Treatment
        $txModel = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
        $txControlsList = $txModel->find('all', array(
            'conditions' => array(
                'flag_active' => '1'
            )
        ));
        $addLinksTmp = array();
        foreach ($txControlsList as $treatmentControl) {
            $addLinksTmp[__($treatmentControl['TreatmentControl']['tx_method'])] = array(
                'link' => '/ClinicalAnnotation/TreatmentMasters/add/' . $participantId . '/' . $treatmentControl['TreatmentControl']['id'] . '/',
                'icon' => 'treatments'
            );
        }
        ksort($addLinksTmp);
        $addLinks['add procure clinical information'] = array_merge($addLinks['add procure clinical information'], $addLinksTmp);
        
        return $addLinks;
    }
    
    // -------------------------------------------------------------------------------------------------------------------------
    // Clinical file update functions
    // -------------------------------------------------------------------------------------------------------------------------
    var $visitDataEntryWorkflowSteps = array(
        array(
            'EventControl',
            'event_type',
            'visit/contact'
        ),
        array(
            'TreatmentControl',
            'tx_method',
            'treatment'
        ),
        array(
            'EventControl',
            'event_type',
            'laboratory'
        ),
        array(
            'EventControl',
            'event_type',
            'clinical exam'
        ),
        array(
            'EventControl',
            'event_type',
            'clinical note'
        ),
        array(
            'EventControl',
            'event_type',
            'other tumor diagnosis'
        )
    );

    public function getClinicalFileUpdateProcessUrl($participantId, $stepNbr)
    {
        if (isset($this->visitDataEntryWorkflowSteps[$stepNbr - 1])) {
            list ($controlModel, $controlTypeField, $controlType) = $this->visitDataEntryWorkflowSteps[$stepNbr - 1];
            $ControlModel = AppModel::getInstance("ClinicalAnnotation", $controlModel, true);
            $nextStepControlData = $ControlModel->find('first', array(
                'conditions' => array(
                    "$controlModel.$controlTypeField" => $controlType,
                    "$controlModel.flag_active" => '1'
                )
            ));
            if ($nextStepControlData) {
                return array(
                    'title' => $controlType,
                    'url' => '/ClinicalAnnotation/' . str_replace('Control', 'Masters', $controlModel) . '/add/' . $participantId . '/' . $nextStepControlData[$controlModel]['id'] . '/clinical_file_update_process_step' . $stepNbr
                );
            }
        } elseif ($stepNbr == (sizeof($this->visitDataEntryWorkflowSteps) + 1)) {
            return array(
                'title' => 'profile',
                'url' => '/ClinicalAnnotation/Participants/edit/' . $participantId . '/clinical_file_update_process_step' . $stepNbr
            );
        }
        return null;
    }

    public function setNextUrlOfTheClinicalFileUpdateProcess($participantId, $passedArgs)
    {
        if (preg_match('/clinical_file_update_process_step([0-9]+)/', implode('/', $passedArgs), $matches)) {
            // 1- Get Process Step Number
            
            $currentStepNbr = $matches[1];
            if (! $currentStepNbr || $currentStepNbr > (sizeof($this->visitDataEntryWorkflowSteps) + 1)) {
                $this->generateClinicalFileUpdateProcessError();
                return;
            }
            
            // 2- Get last user logs and check current url matches the $visitDataEntryWorkflowSteps data
            
            $UserLog = AppModel::getInstance("", "UserLog", true);
            $lastUserLogs = $UserLog->find('first', array(
                'conditions' => array(
                    'UserLog.user_id' => $_SESSION['Auth']['User']['id']
                ),
                'fields' => array(
                    'UserLog.id, UserLog.url'
                ),
                'order' => array(
                    'UserLog.id DESC'
                ),
                'limit' => '1'
            ));
            $currentUserLog = $lastUserLogs['UserLog']['url'];
            $lastUserLogs = $UserLog->find('first', array(
                'conditions' => array(
                    'UserLog.user_id' => $_SESSION['Auth']['User']['id'],
                    "UserLog.url <> '$currentUserLog'"
                ),
                'fields' => array(
                    'UserLog.id, UserLog.url'
                ),
                'order' => array(
                    'UserLog.id DESC'
                ),
                'limit' => '1'
            ));
            $previousUserLog = $lastUserLogs['UserLog']['url'];
            
            $stepUrlDefined = $this->getClinicalFileUpdateProcessUrl($participantId, $currentStepNbr);
            if (strpos($currentUserLog, $stepUrlDefined['url']) === false) {
                $this->generateClinicalFileUpdateProcessError();
                return;
            }
            
            // 3 - Set session data
            
            if ($currentStepNbr != 1) {
                // Check that url matches session data
                if (! isset($_SESSION['procure_clinical_file_update_process']) || ! strpos($currentUserLog, $_SESSION['procure_clinical_file_update_process']['next_page_url']) !== false) {
                    $this->generateClinicalFileUpdateProcessError();
                    return;
                }
            }
            $nextUrl = $this->getClinicalFileUpdateProcessUrl($participantId, ($currentStepNbr + 1));
            $_SESSION['procure_clinical_file_update_process'] = array(
                'current_page_url_suffix' => 'clinical_file_update_process_step' . $currentStepNbr,
                'current_page_step_nbr' => $currentStepNbr,
                'next_page_title' => $nextUrl ? $nextUrl['title'] : null,
                'next_page_url' => $nextUrl ? $nextUrl['url'] : null
            );
        } else {
            unset($_SESSION['procure_clinical_file_update_process']);
        }
    }

    public function addClinicalFileUpdateProcessInfo()
    {
        if (isset($_SESSION['procure_clinical_file_update_process']['current_page_step_nbr'])) {
            foreach ($_SESSION['ctrapp_core']['info_msg'] as $msg => $count)
                if (strpos($msg, __('clinical record update step')) !== false)
                    unset($_SESSION['ctrapp_core']['info_msg'][$msg]); // To remove warning generated before previous data creation
            AppController::addInfoMsg(__('clinical record update step') . ': ' . $_SESSION['procure_clinical_file_update_process']['current_page_step_nbr'] . '/' . (sizeof($this->visitDataEntryWorkflowSteps) + 1));
        }
    }

    public function generateClinicalFileUpdateProcessError()
    {
        foreach ($_SESSION['ctrapp_core']['info_msg'] as $msg => $count)
            if (strpos($msg, __('clinical record update step')) !== false)
                unset($_SESSION['ctrapp_core']['info_msg'][$msg]); // To remove warning generated before previous data creation
        AppController::addWarningMsg(__('an error has been detected - the clinical file update process has been finished prematurely'));
        unset($_SESSION['procure_clinical_file_update_process']);
    }
}