<?php

class ParticipantCustom extends Participant {
	var $useTable = 'participants';
	var $name = 'Participant';
	
	function beforeSave($options = array()){
		$ret_val = parent::beforeSave();
		if(isset($this->data['Participant']['chum_transplant_initials'])) $this->data['Participant']['chum_transplant_initials'] = strtoupper($this->data['Participant']['chum_transplant_initials']);
		return $ret_val;
	}
}

?>