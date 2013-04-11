<?php

class EventControlCustom extends EventControl {
	var $name = 'EventControl';
	var $useTable = 'event_controls';
	
	function buildAddLinks($event_ctrl_data, $participant_id, $event_group){
		$links = array();
		$experimental_test_found = false;
		foreach($event_ctrl_data as $new_ctrl) { 
			if($event_group == 'lab' && $new_ctrl['EventControl']['event_type'] == 'experimental tests') {
				$links[__($new_ctrl['EventControl']['event_type'])] = "/ClinicalAnnotation/EventMasters/addExperimentalTestsInBatch/$participant_id/".$new_ctrl['EventControl']['id'].'/0';
				$links[__($new_ctrl['EventControl']['event_type']).' - '.__('in batch')] = "/ClinicalAnnotation/EventMasters/addExperimentalTestsInBatch/$participant_id/".$new_ctrl['EventControl']['id'].'/1';
			} else {
				$links[__($new_ctrl['EventControl']['event_type'])] = "/ClinicalAnnotation/EventMasters/add/$participant_id/".$new_ctrl['EventControl']['id'];
			}
		}
		return $links;
	}
	
}
?>