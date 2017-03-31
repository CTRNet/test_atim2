<?php
class EventMastersControllerCustom extends EventMastersController{
	
	//***********************************************************************************************************************
	//TODO Ying Request To Validate
	//***********************************************************************************************************************
	// Function use to list all pathology report linked to a diagnosis when the diagnosis detail page is displayed
	//***********************************************************************************************************************
		
// 	function listall( $event_group, $participant_id, $event_control_id=null, $diagnosis_master_id = null ){		
// 		if(!$diagnosis_master_id) {
// 			parent::listall( $event_group, $participant_id, $event_control_id);
// 		} else {
// 			$participant_data = $this->Participant->getOrRedirect($participant_id);
// 			// Search criteria
// 			$search_criteria = array();
// 			$search_criteria['EventMaster.participant_id'] = $participant_id;
// 			$search_criteria['EventMaster.diagnosis_master_id'] = $diagnosis_master_id;
// 			$search_criteria['EventControl.id'] = $event_control_id;
// 			// Set structure
// 			$control_data = $this->EventControl->getOrRedirect($event_control_id);
// 			$this->Structures->set($control_data['EventControl']['form_alias']);
// 			self::buildDetailBinding($this->EventMaster,
// 					$search_criteria, $control_data['EventControl']['form_alias']);
// 			$this->set( 'atim_menu_variables', array('EventMaster.event_group'=>$event_group,'Participant.id'=>$participant_id));
// 			// Manage data
// 			$this->request->data = $this->paginate($this->EventMaster, $search_criteria);
// 		}
// 	}
	
	//***********************************************************************************************************************
	//TODO End Ying Request To Validate
	//***********************************************************************************************************************
	
	
}