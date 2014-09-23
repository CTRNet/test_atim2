<?php

class EventMasterCustom extends EventMaster {
	var $name = 'EventMaster';
	var $useTable = 'event_masters';
	
	function validates($options = array()) {
		parent::validates($options);
	
		if(isset($this->data['EventDetail']) && array_key_exists('vital_status', $this->data['EventDetail'])) {
			if(empty($this->data['EventMaster']['event_date'])){ 
				$this->validationErrors['result'][] = 'follow-up date can not be empty';
			}
		}
	
		return empty($this->validationErrors);
	}
	
}
?>