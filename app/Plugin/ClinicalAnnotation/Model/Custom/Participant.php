<?php
class ParticipantCustom extends Participant {
	var $name = 'Participant';
	var $useTable = 'participants';
	
	
	function getOne(){
		$data = $this->find('first');
		$data['Participant']['custom_value'] = "custom_test";
		return $data;
	}
}