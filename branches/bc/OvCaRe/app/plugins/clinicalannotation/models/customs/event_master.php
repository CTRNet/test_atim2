<?php

class EventMasterCustom extends EventMaster {
	var $name = 'EventMaster';
	var $useTable = 'event_masters';
	
	function beforeValidate($options) {
		if(isset($this->data['EventDetail']) && array_key_exists('result', $this->data['EventDetail'])) {
			if(!strlen(str_replace(' ','',$this->data['EventDetail']['result']))) {
				$this->validationErrors['result'] = 'experimental test result can not be empty';
			}			
		}
		
		return true;
	}
	
}
?>