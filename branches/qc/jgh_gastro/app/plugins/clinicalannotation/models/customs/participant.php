<?php
class ParticipantCustom extends Participant{
	var $name = "Participant";
	var $useTable = "participants";
	
	function summary($variables=array()){
		$result = parent::summary($variables);
		$label = array(NULL, $result['data']['Participant']['participant_identifier']);
		$result['menu'] = $label;
		$result['title'] = $label;
		return $result;
	}
}