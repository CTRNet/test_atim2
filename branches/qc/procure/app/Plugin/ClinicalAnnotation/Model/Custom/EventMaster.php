<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = 'EventMaster';
	
	function beforeValidate($options) {
		$result = parent::beforeValidate($options);	
		
		if(!preg_match("/^(PS[0-9]P0[0-9]+ V[0-9]+ -PST[0-9]+)$/", $this->data['EventDetail']['form_identification'], $matches)) {
			$result = false;
			$this->validationErrors['form_identification'][] = "the identification format is wrong";
		}
		return $result;
	}
}

?>