<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	var $bank_identification = 'PS1P0';
	
	function beforeValidate($options) {
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
			$add_function = (in_array($event_ctrl['EventControl']['event_type'], array('procure follow-up worksheet - aps', 'procure follow-up worksheet - clinical event')))? 'addInBatch' : 'add';
			$add_links[__($event_ctrl['EventControl']['event_type'])] = array('link'=> '/ClinicalAnnotation/EventMasters/'.$add_function.'/'.$participant_id.'/'.$event_ctrl['EventControl']['id'].'/', 'icon' => 'participant');
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