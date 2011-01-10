<?php
 	
 	// --------------------------------------------------------------------------------
	// Presentation creation check
	// -------------------------------------------------------------------------------- 
	$event_type_title = $event_control_data['EventControl']['disease_site'].$event_control_data['EventControl']['event_group'].$event_control_data['EventControl']['event_type'];
	if(empty($this->data) && ($event_type_title == 'ohrilabmarkers')) {
		
		$existing_presentation = $this->EventMaster->find('first',array('conditions'=>array('EventMaster.event_control_id'=>$event_control_data['EventControl']['id'], 'EventMaster.participant_id'=>$participant_id)));
		if (!empty($existing_presentation)) { 
			$this->atimFlash( 'a markers report can only be created once per participant','/clinicalannotation/event_masters/listall/'.$event_group.'/'.$participant_id);
		}
	}
	
?>