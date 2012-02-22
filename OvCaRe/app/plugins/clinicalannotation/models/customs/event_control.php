<?php

class EventControlCustom extends EventControl {
	var $name = 'EventControl';
	var $useTable = 'event_controls';
	
	function buildAddLinks($event_ctrl_data, $participant_id, $event_group){
		$links = parent::buildAddLinks($event_ctrl_data, $participant_id, $event_group);
		
		$test_link_key = __('ovcare', true).' - '.__('experimental tests', true);
		if(($event_group == 'lab') && (isset($links[$test_link_key]))) {
			$links[$test_link_key] = '/clinicalannotation/event_masters/addExperimentalTestsInBatch/'.$participant_id;
			$links[$test_link_key .' - '.__('in batch', true)] = $links[$test_link_key].'/1';
		}
			
		return $links;
	}
	
}
?>