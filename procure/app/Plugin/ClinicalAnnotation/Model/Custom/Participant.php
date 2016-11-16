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
			$add_links = array(__('collection') => array(
				'link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$participant_id, 
				'icon' => 'collection'));
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
			$add_links = array_merge($add_links, $add_links_tmp);
			//Event
			$event_model = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
			$event_controls_list = $event_model->find('all', array('conditions' => array('flag_active' => '1')));
			$add_links_tmp = array();
			foreach ($event_controls_list as $event_ctrl) {
				$add_links_tmp[__($event_ctrl['EventControl']['event_type'])] = array(
					'link'=> '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id'].'/', 
					'icon' => 'annotation');
			}
			ksort($add_links_tmp);
			$add_links = array_merge($add_links, $add_links_tmp);	
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
			$add_links = array_merge($add_links, $add_links_tmp);
		}
		
		return $add_links;
	}
}

?>