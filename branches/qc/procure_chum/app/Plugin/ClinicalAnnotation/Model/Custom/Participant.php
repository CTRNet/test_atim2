<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	var $bank_identification = 'PS1P0';
	
	function summary($variables=array()){
		$return = false;
	
		if ( isset($variables['Participant.id']) ) {
			$result = $this->find('first', array('conditions'=>array('Participant.id'=>$variables['Participant.id'])));
			
			$MiscIdentifier = AppModel::getInstance("ClinicalAnnotation", "MiscIdentifier", true);
			$identifiers = $MiscIdentifier->find('all', array('conditions' => array('MiscIdentifier.participant_id' => $result['Participant']['id'])));
			$result[0] = array('RAMQ' => '', 'hospital_number' => '');
			foreach($identifiers as $new_id) $result['0'][str_replace(' ', '_',$new_id['MiscIdentifierControl']['misc_identifier_name'])] = $new_id['MiscIdentifier']['identifier_value'];
			
			$return = array(
					'menu'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'title'				=>	array( NULL, ($result['Participant']['participant_identifier']) ),
					'structure alias' 	=> 'participants,procure_miscidentifiers_for_participant_summary',
					'data'				=> $result
			);
			
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
				}
			} else {
				AppController::addWarningMsg(__('no consent is linked to the current participant'));
			}
		}
	
		return $return;
	}
	
	function beforeValidate($options = Array()) {
		$result = parent::beforeValidate($options);	
		if(isset($this->data['Participant']['participant_identifier']) && !preg_match("/^($this->bank_identification)([0-9]+)$/", $this->data['Participant']['participant_identifier'], $matches)) {
			$result = false;
			$this->validationErrors['participant_identifier'][] = "the identification format is wrong";
		}
		return $result;
	}
	
	function buildAddProcureFormsButton($participant_id) {
		$add_links = array(__('quick procure collection creation button') => array('link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$participant_id, 'icon' => 'collection'));
		
		$consent_model = AppModel::getInstance("ClinicalAnnotation", "ConsentControl", true);
		$consent_controls_list = $consent_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($consent_controls_list as $consent_control) {
			$add_links[__($consent_control['ConsentControl']['controls_type'])] = array('link'=> '/ClinicalAnnotation/ConsentMasters/add/'.$participant_id.'/'.$consent_control['ConsentControl']['id'].'/', 'icon' => 'participant');
		}
		
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
		$event_controls_list = $event_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($event_controls_list as $event_ctrl) {
			$add_links[__($event_ctrl['EventControl']['event_type'])] = array('link'=> '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id'].'/', 'icon' => 'participant');
		}	
		
		$tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
		$tx_controls_list = $tx_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($tx_controls_list as $treatment_control) {
			$add_function = ($treatment_control['TreatmentControl']['tx_method'] == 'procure follow-up worksheet - treatment')? 'addInBatch' : 'add';			
			$add_links[__($treatment_control['TreatmentControl']['tx_method'])] = array('link'=> '/ClinicalAnnotation/TreatmentMasters/'.$add_function.'/'.$participant_id.'/'.$treatment_control['TreatmentControl']['id'].'/', 'icon' => 'participant');
		}		

		ksort($add_links);	
		
		return $add_links;
	}
	
	function validateFormIdentification($procure_form_identification, $model, $id) {
		
		if(!preg_match("/^(PS[0-9]P0[0-9]+ V[0-9]+ -(CSF|FBP|PST|FSP|MED|QUE)[0-9]+)$/", $procure_form_identification)) {
			//Format
			return "the identification format is wrong";
		
		} else {
			//Unique
			$EventMaster = AppModel::getInstance("ClinicalAnnotation", "EventMaster", true);
			$conditions = array('EventMaster.procure_form_identification' => $procure_form_identification, "EventControl.event_type NOT IN ('procure follow-up worksheet - aps','procure follow-up worksheet - clinical event')");
			if($id && $model == 'EventMaster') $conditions[] = 'EventMaster.id != '. $id;
			$dup = $EventMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
			if($dup) return "the identification value should be unique";
			
			$ConsentMaster = AppModel::getInstance("ClinicalAnnotation", "ConsentMaster", true);
			$conditions = array('ConsentMaster.procure_form_identification' => $procure_form_identification);
			if($id && $model == 'ConsentMaster') $conditions[] = 'ConsentMaster.id != '. $id;
			$dup = $ConsentMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
			if($dup) return "the identification value should be unique";			
			
			$TreatmentMaster = AppModel::getInstance("ClinicalAnnotation", "TreatmentMaster", true);
			$conditions = array('TreatmentMaster.procure_form_identification' => $procure_form_identification, "TreatmentControl.tx_method != 'procure follow-up worksheet - treatment'");
			if($id && $model == 'TreatmentMaster') $conditions[] = 'TreatmentMaster.id != '. $id;
			$dup = $TreatmentMaster->find('count', array('conditions' => $conditions, 'recursive' => '0'));
			if($dup) return "the identification value should be unique";
		}
		
		return false;
	}
}

?>