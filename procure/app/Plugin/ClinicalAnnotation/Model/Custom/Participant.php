<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	
	var $participant_identifier_for_form_validation = null;
	
	function summary($variables=array()){
		$return = false;
	
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$tructure_alias = 'participants';
			if(Configure::read('procure_atim_version') == 'BANK') {
				$MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
				$identifiers = $MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.participant_id' => $result['Participant']['id'])));
				$result[0] = array('RAMQ' => '', 'hospital_number' => '');
				foreach($identifiers as $new_id) $result['0'][str_replace(' ', '_',$new_id['MiscIdentifierControl']['misc_identifier_name'])] = $new_id['MiscIdentifier']['identifier_value'];
				$tructure_alias = 'participants,procure_miscidentifiers_for_participant_summary';
			}
			
			$return = array(
					'menu'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'title'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'structure alias' 	=> $tructure_alias,
					'data'				=> $result
			);
			
			if($result['Participant']['procure_patient_withdrawn']) AppController::addWarningMsg(__('patient withdrawn'));
		}
	
		return $return;
	}
	
	function getBankParticipantIdentification() {
		return 'PS'.Configure::read('procure_bank_id').'P0';
	}
	
	function beforeValidate($options = Array()) {
		$result = parent::beforeValidate($options);	
		if(isset($this->data['Participant']['procure_transferred_participant'])) {
			if(empty($this->data['Participant']['procure_transferred_participant'])) {
				$result = false;
				$this->validationErrors['participant_identifier'][] = "the 'transferred participant' value has to be set";
			} else {
				if(isset($this->data['Participant']['participant_identifier'])) {
					$id_pattern = "/^".(($this->data['Participant']['procure_transferred_participant'] != 'y')? $this->getBankParticipantIdentification() : 'PS[1-4]P0' )."([0-9]{3})$/";
					if(!preg_match($id_pattern, $this->data['Participant']['participant_identifier'])) {
						$result = false;
						$this->validationErrors['participant_identifier'][] = "the identification format is wrong";
					}
				}
			}
		} else if(isset($this->data['Participant']['participant_identifier'])) {
			//Field 'procure_transferred_participant' has to be set
			AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		}
		if(isset($this->data['Participant']['procure_patient_withdrawn'])) {
			if(!$this->data['Participant']['procure_patient_withdrawn'] && (strlen($this->data['Participant']['procure_patient_withdrawn_date']) || strlen(trim($this->data['Participant']['procure_patient_withdrawn_reason'])))) {
				$result = false;
				$this->validationErrors['participant_identifier'][] = "please check the patient withdrawn checkbox if required";
			}
		}
		return $result;
	}
	
	function buildAddProcureFormsButton($participant_id) {
		$add_links = array();
		
		if(Configure::read('procure_atim_version') == 'BANK') {
			$add_links['add collection'] = array('link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$participant_id, 'icon' => 'collection');
			$add_links['update clinical record'] = false;
			
			$add_links['add procure clinical information'] = array();
			//Consent
			$consent_model = AppModel::getInstance("ClinicalAnnotation", "ConsentControl", true);
			$consent_controls_list = $consent_model->find('all', array('conditions' => array('flag_active' => '1')));
			$add_links_tmp = array();
			foreach ($consent_controls_list as $consent_control) {
				$add_links_tmp[__($consent_control['ConsentControl']['controls_type'])] = array(
					'link'=> '/ClinicalAnnotation/ConsentMasters/add/'.$participant_id.'/'.$consent_control['ConsentControl']['id'].'/', 
					'icon' => 'consents');
			}
			ksort($add_links_tmp);
			$add_links['add procure clinical information'] = array_merge($add_links['add procure clinical information'], $add_links_tmp);
			//Event
			$event_model = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
			$event_controls_list = $event_model->find('all', array('conditions' => array('flag_active' => '1')));
			$add_links_tmp = array();
			foreach ($event_controls_list as $event_ctrl) {
				$add_links_tmp[__($event_ctrl['EventControl']['event_type'])] = array(
					'link'=> '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id'].'/', 
					'icon' => 'annotation');
				if($event_ctrl['EventControl']['event_type'] == 'visit/contact')
					$add_links['update clinical record'] = array(
						'link'=> '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id'].'/launch_clinical_record_completion', 
						'icon' => 'duplicate');
			}
			ksort($add_links_tmp);
			$add_links['add procure clinical information'] = array_merge($add_links['add procure clinical information'], $add_links_tmp);	
			//Treatment
			$tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
			$tx_controls_list = $tx_model->find('all', array('conditions' => array('flag_active' => '1')));
			$add_links_tmp = array();
			foreach ($tx_controls_list as $treatment_control) {
				$add_links_tmp[__($treatment_control['TreatmentControl']['tx_method'])] = array(
					'link'=> '/ClinicalAnnotation/TreatmentMasters/add/'.$participant_id.'/'.$treatment_control['TreatmentControl']['id'].'/', 
					'icon' => 'treatments');
			}
			ksort($add_links_tmp);
			$add_links['add procure clinical information'] = array_merge($add_links['add procure clinical information'], $add_links_tmp);
		}
		
		return $add_links;
	}
	
	function setNextUrlToFlashForVisitDataEntry($participant_id, $current_control_model, $current_control_data, $passed_args) {
		$visit_data_entry_workflow_steps = array(
			array('EventControl', 'event_type', 'visit/contact'),
			array('TreatmentControl', 'tx_method', 'treatment'),
			array('EventControl', 'event_type', 'laboratory'),
			array('EventControl', 'event_type', 'clinical exam'),
			array('EventControl', 'event_type', 'clinical note'),
			array('EventControl', 'event_type', 'other tumor diagnosis')
		);
		
		$first_step_key = 0;
		if($current_control_model == $visit_data_entry_workflow_steps[$first_step_key][0] 
		&& $current_control_data[$visit_data_entry_workflow_steps[$first_step_key][1]] == $visit_data_entry_workflow_steps[$first_step_key][2]
		&& in_array('launch_clinical_record_completion', $passed_args)) {
			//First step detected: initiate workflow setting the next step url	
			$next_step_key = 1;
			$next_step_workflow_data = $visit_data_entry_workflow_steps[$next_step_key];
			list($next_step_control_model, $next_step_control_type_field, $next_step_control_type) = $next_step_workflow_data;
			$NextStepControlModel = AppModel::getInstance("ClinicalAnnotation", $next_step_control_model, true);
			$next_step_control_data = $NextStepControlModel->find('first', array('conditions' => array("$next_step_control_model.$next_step_control_type_field" => $next_step_control_type)));
			$_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry'] = array(
				'previous_url' => "/ClinicalAnnotation/".str_replace('Control', 'Masters', $current_control_model)."/add/$participant_id/".$current_control_data['id'],
				'next_url' => "/ClinicalAnnotation/".str_replace('Control', 'Masters', $next_step_control_model)."/add/$participant_id/".$next_step_control_data[$next_step_control_model]['id'],
				'next_url_title' => $next_step_control_type,				
				'step_key' => $next_step_key);
		} else {
			if(isset($_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry'])) {
				//Get the current url and the previous one
				$UserLog = AppModel::getInstance("", "UserLog", true);
				$last_user_logs = $UserLog->find('all', array('conditions' => array('UserLog.user_id' => $_SESSION['Auth']['User']['id']), 'order' => array('UserLog.id DESC'), 'limit' => '2'));
				$previous_user_log = $last_user_logs[1]['UserLog']['url'];
				$current_user_log = $last_user_logs[0]['UserLog']['url'];
				//Check urls matche the session data
				if(strpos($previous_user_log, $_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['previous_url']) !== false
				&& strpos($current_user_log, $_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['next_url']) !== false) {
					//Here is the good one... set the next step urls
					$_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['previous_url'] = $_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['next_url'];
					$_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['step_key']++;
					$next_step_key = $_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['step_key'];
					if(isset($visit_data_entry_workflow_steps[$next_step_key])) {
						$next_step_workflow_data = $visit_data_entry_workflow_steps[$next_step_key];
						list($next_step_control_model, $next_step_control_type_field, $next_step_control_type) = $next_step_workflow_data;
						$NextStepControlModel = AppModel::getInstance("ClinicalAnnotation", $next_step_control_model, true);
						$next_step_control_data = $NextStepControlModel->find('first', array('conditions' => array("$next_step_control_model.$next_step_control_type_field" => $next_step_control_type)));
						$_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['next_url'] = "/ClinicalAnnotation/".str_replace('Control', 'Masters', $next_step_control_model)."/add/$participant_id/".$next_step_control_data[$next_step_control_model]['id'];
						$_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['next_url_title'] = $next_step_control_type;			
					} else if($next_step_key == sizeof($visit_data_entry_workflow_steps)) {
						//End of the workflow
						$_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['next_url'] = "/ClinicalAnnotation/Participants/edit/$participant_id/end_of_clinical_record_update";
						$_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['next_url_title'] = 'profile';
					} else {
						unset($_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']);
					}
				} else {
					unset($_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']);
				}
			}
		}
	}
	
	function getNextUrlToFlashForVisitDataEntry() {
		if(isset($_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry'])) {
			//Get the current url 
			$UserLog = AppModel::getInstance("", "UserLog", true);
			$current_user_log = $UserLog->find('first', array('conditions' => array('UserLog.user_id' => $_SESSION['Auth']['User']['id']), 'order' => array('UserLog.id DESC'), 'limit' => '2'));
			$current_user_log = $current_user_log['UserLog']['url'];
			if(strpos($current_user_log, $_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['previous_url']) !== false) {
				AppController::addWarningMsg(__('clinical record update step'));
				return array('next_url' => $_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['next_url'], 'next_url_title' => $_SESSION['PROCURE.NextUrlToFlashForVisitDataEntry']['next_url_title']);
			}
		}
		return '';
	}
}

?>