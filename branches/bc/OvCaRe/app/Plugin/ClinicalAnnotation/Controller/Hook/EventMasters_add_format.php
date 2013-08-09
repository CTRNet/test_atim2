<?php
	
	$this->set('ev_header', __($event_control_data['EventControl']['event_type']));
	
	if(empty($this->request->data)
	&& $event_control_data['EventControl']['event_type'] = 'brca' 
	&& $this->EventMaster->find('count', array('conditions' => array('EventMaster.participant_id'=>$participant_id, 'EventControl.event_type' => 'brca')))) {
		AppController::addWarningMsg(__('brca report can not be created twice for one patient'));
	}
	
?>