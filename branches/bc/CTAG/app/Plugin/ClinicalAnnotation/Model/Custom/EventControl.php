<?php

class EventControlCustom extends EventControl {
	var $name = 'EventControl';
	var $useTable = 'event_controls';
	
	function buildAddLinks($event_ctrl_data, $participant_id, $event_group){
		$links = array();
		foreach($event_ctrl_data as $new_ctrl) { 
			if($event_group == 'lab' && $new_ctrl['EventControl']['event_type'] == 'experimental tests') {
				$links[__($new_ctrl['EventControl']['event_type'])] = "/ClinicalAnnotation/EventMasters/add/$participant_id/".$new_ctrl['EventControl']['id'];
				$links[__($new_ctrl['EventControl']['event_type']).' - '.__('in batch')] = "/ClinicalAnnotation/EventMasters/add/$participant_id/".$new_ctrl['EventControl']['id'].'/0/1';
			} else {
				$links[__($new_ctrl['EventControl']['event_type'])] = "/ClinicalAnnotation/EventMasters/add/$participant_id/".$new_ctrl['EventControl']['id'];
			}
		}
		ksort($links);
		return $links;
	}
	
}
?>