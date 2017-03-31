<?php
	
	if(empty($this->request->data)
	&& $event_control_data['EventControl']['event_type'] == 'brca' 
	&& $this->EventMaster->find('count', array('conditions' => array('EventMaster.participant_id'=>$participant_id, 'EventControl.event_type' => 'brca')))) {
		AppController::addWarningMsg(__('brca report can not be created twice for one patient'));
	}
	
	//***********************************************************************************************************************
	//TODO Ying Request To Validate
	//***********************************************************************************************************************
	// We tried to link either collections or aliquots or aliquot uses to a study instead to use the Event Study reocrds.
	// This Event Study Record was created to track study to participant link created from file maker pro.
	//***********************************************************************************************************************
// 	if($event_control_data['EventControl']['event_type'] == 'study inclusion based on filemaker')
// 		$this->flash(__('no new data supposed to be created'), 'javascript:history.back()');
	//***********************************************************************************************************************
	//TODO End Ying Request To Validate
	//***********************************************************************************************************************
	
?>