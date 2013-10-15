<?php

	if($event_control_data['EventControl']['event_type'] == 'brca' 
	&& $this->EventMaster->find('count', array('conditions' => array('EventMaster.participant_id'=>$participant_id, 'EventControl.event_type' => 'brca')))) {
		$this->EventMaster->validationErrors[''][] = 'brca report can not be created twice for one patient';
		$submitted_data_validates = false;
	}
	
?>