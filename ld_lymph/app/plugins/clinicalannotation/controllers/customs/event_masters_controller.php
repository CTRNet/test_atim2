<?php

class EventMastersControllerCustom extends EventMastersController {
	
	function getPeAndImagingScore($data, $event_control_data) {
		if(($event_control_data['disease_site'] != 'ld lymph.') || ($event_control_data['event_type'] != 'p/e and imaging')) 
			$this->redirect( '/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true );

		$score = 0;
		foreach($data['EventDetail'] as $key => $value) { 
			if((strpos($key, 'lymph_node_for_petsuv_') === 0) && ($value == 'y')) $score++; 
		}
		
		return $score;		
	}
	
	
	
	
	
	
}

?>