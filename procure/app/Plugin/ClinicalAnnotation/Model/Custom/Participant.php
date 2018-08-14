<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = 'Participant';

    var $participant_identifier_for_form_validation = null;

    function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            $tructure_alias = 'participants';
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
                foreach ($identifiers as $new_id)
                    $result['0'][str_replace(' ', '_', $new_id['MiscIdentifierControl']['misc_identifier_name'])] = $new_id['MiscIdentifier']['identifier_value'];
                $tructure_alias = 'participants,procure_miscidentifiers_for_participant_summary';
                // Add warning on participant of another bank that is not transferred...
                if (strpos($result['Participant']['participant_identifier'], 'PS' . Configure::read('procure_bank_id')) === false && $result['Participant']['procure_transferred_participant'] == 'n') {
                    AppController::addWarningMsg(__('participant of another bank but not transferred - no data entry'));
                }
            }
            
            $return = array(
                'menu' => array(
                    NULL,
                    ($result['Participant']['participant_identifier'])
                ),
                'title' => array(
                    NULL,
                    ($result['Participant']['participant_identifier'])
                ),
                'structure alias' => $tructure_alias,
                'data' => $result
            );
            
            if ($result['Participant']['procure_patient_withdrawn'])
                AppController::addWarningMsg(__('patient withdrawn'));
        }
        
        return $return;
    }

    function getBankParticipantIdentification()
    {
        return 'PS' . Configure::read('procure_bank_id') . 'P0';
    }

    function beforeValidate($options = Array())
    {
        $result = parent::beforeValidate($options);
        if (isset($this->data['Participant']['procure_transferred_participant'])) {
            if (empty($this->data['Participant']['procure_transferred_participant'])) {
                $result = false;
                $this->validationErrors['participant_identifier'][] = "the 'transferred participant' value has to be set";
            } else {
                if (isset($this->data['Participant']['participant_identifier'])) {
                    $id_pattern = "/^" . (($this->data['Participant']['procure_transferred_participant'] != 'y') ? $this->getBankParticipantIdentification() : 'PS[1-4]P0') . "([0-9]{3})$/";
                    if (! preg_match($id_pattern, $this->data['Participant']['participant_identifier'])) {
                        $result = false;
                        $this->validationErrors['participant_identifier'][] = "the identification format is wrong";
                    }
                }
            }
        } else 
            if (isset($this->data['Participant']['participant_identifier'])) {
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

    function buildAddProcureFormsButton($participant_id)
    {
        $add_links = array();
        
        $add_links['add collection'] = array(
            'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $participant_id,
            'icon' => 'collection'
        );
        $tmp_url = $this->getClinicalFileUpdateProcessUrl($participant_id, '1');
        if ($tmp_url)
            $add_links['update clinical record'] = array(
                'link' => $tmp_url['url'],
                'icon' => 'duplicate'
            );
        $add_links['add procure clinical information'] = array();
        // Consent
        $consent_model = AppModel::getInstance("ClinicalAnnotation", "ConsentControl", true);
        $consent_controls_list = $consent_model->find('all', array(
            'conditions' => array(
                'flag_active' => '1'
            )
        ));
        $add_links_tmp = array();
        foreach ($consent_controls_list as $consent_control) {
            $add_links_tmp[__($consent_control['ConsentControl']['controls_type'])] = array(
                'link' => '/ClinicalAnnotation/ConsentMasters/add/' . $participant_id . '/' . $consent_control['ConsentControl']['id'] . '/',
                'icon' => 'consents'
            );
        }
        ksort($add_links_tmp);
        $add_links['add procure clinical information'] = array_merge($add_links['add procure clinical information'], $add_links_tmp);
        // Event
        $event_model = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
        $event_controls_list = $event_model->find('all', array(
            'conditions' => array(
                'flag_active' => '1'
            )
        ));
        $add_links_tmp = array();
        foreach ($event_controls_list as $event_ctrl) {
            $add_links_tmp[__($event_ctrl['EventControl']['event_type'])] = array(
                'link' => '/ClinicalAnnotation/EventMasters/add/' . $participant_id . '/' . $event_ctrl['EventControl']['id'] . '/',
                'icon' => 'annotation'
            );
        }
        ksort($add_links_tmp);
        $add_links['add procure clinical information'] = array_merge($add_links['add procure clinical information'], $add_links_tmp);
        // Treatment
        $tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
        $tx_controls_list = $tx_model->find('all', array(
            'conditions' => array(
                'flag_active' => '1'
            )
        ));
        $add_links_tmp = array();
        foreach ($tx_controls_list as $treatment_control) {
            $add_links_tmp[__($treatment_control['TreatmentControl']['tx_method'])] = array(
                'link' => '/ClinicalAnnotation/TreatmentMasters/add/' . $participant_id . '/' . $treatment_control['TreatmentControl']['id'] . '/',
                'icon' => 'treatments'
            );
        }
        ksort($add_links_tmp);
        $add_links['add procure clinical information'] = array_merge($add_links['add procure clinical information'], $add_links_tmp);
        
        return $add_links;
    }
    
    // -------------------------------------------------------------------------------------------------------------------------
    // Clinical file update functions
    // -------------------------------------------------------------------------------------------------------------------------
    var $visit_data_entry_workflow_steps = array(
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

    function getClinicalFileUpdateProcessUrl($participant_id, $step_nbr)
    {
        if (isset($this->visit_data_entry_workflow_steps[$step_nbr - 1])) {
            list ($control_model, $control_type_field, $control_type) = $this->visit_data_entry_workflow_steps[$step_nbr - 1];
            $ControlModel = AppModel::getInstance("ClinicalAnnotation", $control_model, true);
            $next_step_control_data = $ControlModel->find('first', array(
                'conditions' => array(
                    "$control_model.$control_type_field" => $control_type,
                    "$control_model.flag_active" => '1'
                )
            ));
            if ($next_step_control_data) {
                return array(
                    'title' => $control_type,
                    'url' => '/ClinicalAnnotation/' . str_replace('Control', 'Masters', $control_model) . '/add/' . $participant_id . '/' . $next_step_control_data[$control_model]['id'] . '/clinical_file_update_process_step' . $step_nbr
                );
            }
        } else 
            if ($step_nbr == (sizeof($this->visit_data_entry_workflow_steps) + 1)) {
                return array(
                    'title' => 'profile',
                    'url' => '/ClinicalAnnotation/Participants/edit/' . $participant_id . '/clinical_file_update_process_step' . $step_nbr
                );
            }
        return null;
    }

    function setNextUrlOfTheClinicalFileUpdateProcess($participant_id, $passed_args)
    {
        if (preg_match('/clinical_file_update_process_step([0-9]+)/', implode('/', $passed_args), $matches)) {
            // 1- Get Process Step Number
            
            $current_step_nbr = $matches[1];
            if (! $current_step_nbr || $current_step_nbr > (sizeof($this->visit_data_entry_workflow_steps) + 1)) {
                $this->generateClinicalFileUpdateProcessError();
                return;
            }
            
            // 2- Get last user logs and check current url matches the $visit_data_entry_workflow_steps data
            
            $UserLog = AppModel::getInstance("", "UserLog", true);
            $last_user_logs = $UserLog->find('first', array(
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
            $current_user_log = $last_user_logs['UserLog']['url'];
            $last_user_logs = $UserLog->find('first', array(
                'conditions' => array(
                    'UserLog.user_id' => $_SESSION['Auth']['User']['id'],
                    "UserLog.url <> '$current_user_log'"
                ),
                'fields' => array(
                    'UserLog.id, UserLog.url'
                ),
                'order' => array(
                    'UserLog.id DESC'
                ),
                'limit' => '1'
            ));
            $previous_user_log = $last_user_logs['UserLog']['url'];
            
            $step_url_defined = $this->getClinicalFileUpdateProcessUrl($participant_id, $current_step_nbr);
            if (strpos($current_user_log, $step_url_defined['url']) === false) {
                $this->generateClinicalFileUpdateProcessError();
                return;
            }
            
            // 3 - Set session data
            
            if ($current_step_nbr != 1) {
                // Check that url matches session data
                if (! isset($_SESSION['procure_clinical_file_update_process']) || ! strpos($current_user_log, $_SESSION['procure_clinical_file_update_process']['next_page_url']) !== false) {
                    $this->generateClinicalFileUpdateProcessError();
                    return;
                }
            }
            $next_url = $this->getClinicalFileUpdateProcessUrl($participant_id, ($current_step_nbr + 1));
            $_SESSION['procure_clinical_file_update_process'] = array(
                'current_page_url_suffix' => 'clinical_file_update_process_step' . $current_step_nbr,
                'current_page_step_nbr' => $current_step_nbr,
                'next_page_title' => $next_url ? $next_url['title'] : null,
                'next_page_url' => $next_url ? $next_url['url'] : null
            );
        } else {
            unset($_SESSION['procure_clinical_file_update_process']);
        }
    }

    function addClinicalFileUpdateProcessInfo()
    {
        if (isset($_SESSION['procure_clinical_file_update_process']['current_page_step_nbr'])) {
            foreach ($_SESSION['ctrapp_core']['info_msg'] as $msg => $count)
                if (strpos($msg, __('clinical record update step')) !== false)
                    unset($_SESSION['ctrapp_core']['info_msg'][$msg]); // To remove warning generated before previous data creation
            AppController::addInfoMsg(__('clinical record update step') . ': ' . $_SESSION['procure_clinical_file_update_process']['current_page_step_nbr'] . '/' . (sizeof($this->visit_data_entry_workflow_steps) + 1));
        }
    }

    function generateClinicalFileUpdateProcessError()
    {
        foreach ($_SESSION['ctrapp_core']['info_msg'] as $msg => $count)
            if (strpos($msg, __('clinical record update step')) !== false)
                unset($_SESSION['ctrapp_core']['info_msg'][$msg]); // To remove warning generated before previous data creation
        AppController::addWarningMsg(__('an error has been detected - the clinical file update process has been finished prematurely'));
        unset($_SESSION['procure_clinical_file_update_process']);
    }
}

?>