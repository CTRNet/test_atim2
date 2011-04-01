<?php
class ParticipantCustom extends Participant{
	var $name = "Participant";
	var $useTable = "participants";
	
	function summary($variables=array()){
		$result = parent::summary($variables);
		$label = array(NULL, $result['data']['Participant']['id']." - ".$result['data']['Participant']['last_name'].", ".$result['data']['Participant']['first_name']);
		$result['menu'] = $label;
		$result['title'] = $label;
		return $result;
	}
}