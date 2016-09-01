<?php

class EventMasterCustom extends EventMaster {
	var $useTable = 'event_masters';
	var $name = "EventMaster";
	
	function validates($options = array()){
		$result = parent::validates($options);
		if(isset($this->data['EventDetail'])) {
			if(array_key_exists('ongoing_currently_yes_no', $this->data['EventDetail']) && empty($this->data['EventDetail']['ongoing_currently_yes_no'])) {
				$this->validationErrors['ongoing_currently_yes_no'][] = __("this field is required").' ('.__('ongoing/currently').')';
				$result = false;
			}
		}
		
		return $result;
	}
	
}
