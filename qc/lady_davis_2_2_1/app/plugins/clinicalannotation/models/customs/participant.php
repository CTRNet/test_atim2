<?php
class ParticipantCustom extends Participant{
	var $name 		= "Participant";
	var $tableName	= "participants";
	
	function summary($variables=array()){
		$result = parent::summary($variables);
		
		$mi_model = AppModel::atimNew("clinicalannotation", "MiscIdentifier", true);
		$mi_data = $mi_model->find('first', array('conditions' => array('misc_identifier_control_id' => 9, 'participant_id' => $variables['Participant.id']), 'recursive' => -1));
		
		$label = array(NULL, empty($mi_data) ? "No id" : $mi_data['MiscIdentifier']['identifier_value']);
		$result['menu'] = $label;
		$result['title'] = $label;
		return $result;
	}
}