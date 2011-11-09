<?php

class EventMasterCustom extends EventMaster {
	
	var $useTable = 'event_masters';	
	var $name = 'EventMaster';	
	
	function beforeSave($options) {
		if(array_key_exists('lymph_node_for_petsuv_waldeyers_ring', $this->data['EventDetail'])) {
			$score = 0;
			foreach($this->data['EventDetail'] as $key => $value) { 
				if((strpos($key, 'lymph_node_for_petsuv_') === 0) && ($value == 'y')) $score++; 
			}
			$this->data['EventDetail']['initial_pet_suv_max'] = $score;
		}
		
		return true;
	}
	
}

?>