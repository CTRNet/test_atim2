<?php
class ParticipantCustom extends Participant{
	var $name 		= "Participant";
	var $tableName	= "participants";
	
	function summary($variables=array()){
		$result = parent::summary($variables);
		
		$mi_model = AppModel::getInstance("clinicalannotation", "MiscIdentifier", true);
		$mi_data = $mi_model->find('first', array('conditions' => array('misc_identifier_control_id' => 9, 'participant_id' => $variables['Participant.id']), 'recursive' => -1));
		
		$label = array(NULL, empty($mi_data) ? "No id" : $mi_data['MiscIdentifier']['identifier_value']);
		$result['menu'] = $label;
		$result['title'] = $label;
		return $result;
	}
	
	function beforeSave($options = array()) {
		$val = parent::BeforeSave($options);
		
		if($this->id != null && isset($this->data['Participant']['qc_lady_has_family_history']) && $this->data['Participant']['qc_lady_has_family_history'] != 'y'){
			$fam_hist_model = AppModel::getInstance('Clinicalannotation', 'FamilyHistory', true);
			$fam_hist = $fam_hist_model->find('first', array('conditions' => array('FamilyHistory.participant_id' => $this->id)));
			if($fam_hist){
				unset($this->data['Participant']['qc_lady_has_family_history']);
				AppController::addWarningMsg('Family history exists.');
			}
		}
		
		return $val;
	}
}