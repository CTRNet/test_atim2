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
		$add_links = array();
		
		$consent_model = AppModel::getInstance("ClinicalAnnotation", "ConsentControl", true);
		$consent_controls_list = $consent_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($consent_controls_list as $consent_control) {
			$add_links[__($consent_control['ConsentControl']['controls_type'])] = '/ClinicalAnnotation/ConsentMasters/add/'.$participant_id.'/'.$consent_control['ConsentControl']['id'].'/';
		}
		
		$event_model = AppModel::getInstance("ClinicalAnnotation", "EventControl", true);
		$event_controls_list = $event_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($event_controls_list as $event_ctrl) {
			$add_links[__($event_ctrl['EventControl']['event_type'])] = '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id'].'/';
		}	
		
		$tx_model = AppModel::getInstance("ClinicalAnnotation", "TreatmentControl", true);
		$tx_controls_list = $tx_model->find('all', array('conditions' => array('flag_active' => '1')));
		foreach ($tx_controls_list as $treatment_control) {
			$add_links[__($treatment_control['TreatmentControl']['tx_method'])] = '/ClinicalAnnotation/TreatmentMasters/add/'.$participant_id.'/'.$treatment_control['TreatmentControl']['id'].'/';
		}		

		ksort($add_links);	
		
		return $add_links;
	
	}
}

?>