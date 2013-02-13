<?php

class EventControlCustom extends EventControl {
	var $name = "EventControl";
	var $useTable = "event_controls";
		
	function buildAddLinks($event_ctrl_data, $participant_id, $event_group){
		$links = array();
		foreach($event_ctrl_data as $event_ctrl){
//TODO 2013-02-13 temporary control before to hide all cap reports
			if(strpos($event_ctrl['EventControl']['event_type'], 'cap report') === false) {
				$links[] = array(
						'order' => $event_ctrl['EventControl']['display_order'],
						'label' => __($event_ctrl['EventControl']['event_type']),
						'link' => '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id']
				);
			}
		}
		AppController::buildBottomMenuOptions($links);
		return $links;
	}
	
}
