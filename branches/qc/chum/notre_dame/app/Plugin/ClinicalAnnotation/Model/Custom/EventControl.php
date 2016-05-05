<?php

class EventControlCustom extends EventControl {
	var $useTable = 'event_controls';
	var $name = "EventControl";
	
	var $modifiable_event_types = array('ca125', 'psa', 'prostate pathology review', 'prostate nodule review');
	
	function buildAddLinks($event_ctrl_data, $participant_id, $event_group){
		$links = array();
		foreach($event_ctrl_data as $event_ctrl){
			if(in_array($event_ctrl['EventControl']['event_type'], $this->modifiable_event_types)) {
				$links[] = array(
					'order' => $event_ctrl['EventControl']['display_order'],
					'label' => __($event_ctrl['EventControl']['event_type']).(empty($event_ctrl['EventControl']['disease_site'])? '' : ' - '.__($event_ctrl['EventControl']['disease_site'])),
					'link' => '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$event_ctrl['EventControl']['id']
				);
			}
		}
		AppController::buildBottomMenuOptions($links);
		return $links;
	}
}
