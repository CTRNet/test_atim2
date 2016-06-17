<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = "EventMaster";
	
	function validates($options = array()){
		$result = parent::validates($options);
	
		if(isset($this->data['EventDetail'])) {
			if(array_key_exists('yes_no', $this->data['EventDetail']) && empty($this->data['EventDetail']['yes_no'])) {
				$this->validationErrors['yes_no'][] = __("this field is required").' ('.__('diagnosed').')';
				$result = false;
			}
		}
		
		return $result;
	}
	
}
