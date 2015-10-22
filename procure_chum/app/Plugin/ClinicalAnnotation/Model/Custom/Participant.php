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
			
			//*** PROCURE CHUM ******************************************************************************************
			$consent_model = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
			$consent_data = $consent_model->find('first', array(
					'fields' => array(),
					'conditions' => array('ConsentMaster.participant_id' => $variables['Participant.id']),
					'order' => array('ConsentMaster.consent_signed_date DESC'),
					'recursive' => 0)
			);
			if($consent_data) {
				if($consent_data['ConsentDetail']['qc_nd_urine_blood_use_for_followup'] != 'y') {
					AppController::addWarningMsg(__('participant does not allow followup'));
				} else if($consent_data['ConsentDetail']['qc_nd_stop_followup'] == 'y') {
					AppController::addWarningMsg(__('participant stopped the followup'));
				} else if($consent_data['ConsentDetail']['qc_nd_stop_followup'] == 'y-pho.acc.') {
					AppController::addWarningMsg(__('participant stopped the followup but accept to be contacted'));
				}
			} else {
				AppController::addWarningMsg(__('no consent is linked to the current participant'));
			}
			//*** END PROCURE CHUM ******************************************************************************************
			
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
			$add_links = array(__('quick procure collection creation button') => array('link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$participant_id, 'icon' => 'collection'));
			//Consent
			$consent_model = AppModel::getInstance("ClinicalAnnotation", "ConsentControl", true);
			$consent_controls_list = $consent_model->find('all', array('conditions' => array('flag_active' => '1')));
			foreach ($consent_controls_list as $consent_control) {
				$add_links[__($consent_control['ConsentControl']['controls_type'])] = array('link'=> '/ClinicalAnnotation/ConsentMasters/add/'.$participant_id.'/'.$consent_control['ConsentControl']['id'].'/', 'icon' => 'participant');
			}
			//Event
			$event_model = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
			$event_controls_list = $event_model->find('all', array('conditions' => array('flag_active' => '1')));
			foreach ($event_controls_list as $event_ctrl) {
				$add_links[__($event_ctrl['EventControl']['event_type'])] = array('link'=> '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id'].'/', 'icon' => 'participant');
			}	
			//Treatment
			$tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
			$tx_controls_list = $tx_model->find('all', array('conditions' => array('flag_active' => '1')));
			foreach ($tx_controls_list as $treatment_control) {
				$add_links[__($treatment_control['TreatmentControl']['tx_method'])] = array('link'=> '/ClinicalAnnotation/TreatmentMasters/add/'.$participant_id.'/'.$treatment_control['TreatmentControl']['id'].'/', 'icon' => 'participant');
			}		
			ksort($add_links);	
		}
		
		return $add_links;
	}
	
	function setParticipantIdentifierForFormValidation($participant_id) {
		$participant_identifier = $this->find('first', array('conditions' => array('Participant.id' => $participant_id), 'fields' => array('Participant.participant_identifier'), 'recursvie' => '0'));
		if(!$participant_identifier) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		$this->participant_identifier_for_form_validation = $participant_identifier['Participant']['participant_identifier'];
	}
	
	function validateFormIdentification($procure_form_identification, $model, $id, $control_id = null) {
		if(!$this->participant_identifier_for_form_validation) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
		
		$pattern_suffix = null;
		$main_worksheet = true;
		switch($model) {
			case 'ConsentMaster':
				$pattern_suffix = "CSF";
				break;
				
			case 'EventMaster':
				if($id) {
					$EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
					$studied_event = $EventMaster->find('first', array('conditions' => array('EventMaster.id' => $id), 'recursive' => '0'));
					$event_type = $studied_event['EventControl']['event_type'];
				} else if($control_id) {
					$EventControl = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
					$studied_event_control = $EventControl->find('first', array('conditions' => array('id' => $control_id), 'recursive' => '0'));
					$event_type = $studied_event_control['EventControl']['event_type'];
				}
				$pattern_suffix_suffix = '';
				switch($event_type) {
					case 'procure pathology report':
						$pattern_suffix = "PST";
						break;
					case 'procure diagnostic information worksheet':
						$pattern_suffix = "FBP";
						break;
					case 'procure questionnaire administration worksheet':
						$pattern_suffix = "QUE";
						break;
					case 'procure follow-up worksheet':
						$pattern_suffix = "FSP";
						break;
					case 'procure follow-up worksheet - aps':
					case 'procure follow-up worksheet - clinical event':
					case 'procure follow-up worksheet - other tumor dx':
					case 'procure follow-up worksheet - clinical note':
						$pattern_suffix = "FSP";
						$main_worksheet = false;
						break;
					default:
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				break;
				
			case 'TreatmentMaster':
				if($id) {
					$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
					$studied_treatment = $TreatmentMaster->find('first', array('conditions' => array('TreatmentMaster.id' => $id), 'recursive' => '0'));
					$tx_method = $studied_treatment['TreatmentControl']['tx_method'];
				} else if($control_id) {
					$TreatmentControl = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
					$studied_treatment_control = $TreatmentControl->find('first', array('conditions' => array('id' => $control_id), 'recursive' => '0'));
					$tx_method = $studied_treatment_control['TreatmentControl']['tx_method'];
				} else {
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
				}
				switch($tx_method) {
					case 'procure medication worksheet':
						$pattern_suffix = "MED";
						break;
					case 'procure follow-up worksheet - treatment':
					case 'procure follow-up worksheet - other tumor tx': 
						$pattern_suffix = "FSP";
						$main_worksheet = false;
						break;
					case 'procure medication worksheet - drug':
						$pattern_suffix = "MED";
						$main_worksheet = false;
						break;
					default:
						AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);		
				}
		}
		if(empty($pattern_suffix)) AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);		
		//Check Format
		if($main_worksheet) {
			if(!preg_match("/^".$this->participant_identifier_for_form_validation." V((0[1-9])|(1[0-9])) -".$pattern_suffix."[0-9]+$/", $procure_form_identification)) return __("the identification format is wrong")." (".$this->participant_identifier_for_form_validation." V00 -".$pattern_suffix."0)";
		} else {
			if(!preg_match("/^".$this->participant_identifier_for_form_validation." Vx -".$pattern_suffix."x$/", $procure_form_identification)) return __("the identification format is wrong")." (".$this->participant_identifier_for_form_validation." Vx -".$pattern_suffix."x)";
		}
		//Check Unique
		if($main_worksheet) {
			switch($model) {
				case 'EventMaster':
					$EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
					$conditions = array('EventMaster.procure_form_identification' => $procure_form_identification);
					if($id && $model == 'EventMaster') $conditions[] = 'EventMaster.id != '. $id;
					$dup = $EventMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
					if($dup) return __("the identification value should be unique");;
					break;
				case 'ConsentMaster':
					$ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
					$conditions = array('ConsentMaster.procure_form_identification' => $procure_form_identification);
					if($id && $model == 'ConsentMaster') $conditions[] = 'ConsentMaster.id != '. $id;
					$dup = $ConsentMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
					if($dup) return __("the identification value should be unique");
					break;
				case 'TreatmentMaster':
					$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
					$conditions = array('TreatmentMaster.procure_form_identification' => $procure_form_identification);
					if($id && $model == 'TreatmentMaster') $conditions[] = 'TreatmentMaster.id != '. $id;
					$dup = $TreatmentMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
					if($dup) return __("the identification value should be unique");;
					break;
				default:
					AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			}
		}
		//All is ok
		return false;
	}
}

?>