<?php
	
	$processed_event_data = $event_control_data['EventControl']['use_addgrid']? $this->request->data : array('0' => $this->request->data);
	foreach($processed_event_data as &$new_event_data ) {
		$new_event_data = $this->EventMaster->addBmiValue($new_event_data);
		$new_event_data = $this->EventMaster->setHospitalizationDuration($new_event_data);
		$new_event_data = $this->EventMaster->setIntensiveCareDuration($new_event_data);
		$new_event_data = $this->EventMaster->completeVolumetry($new_event_data, $submitted_data_validates);
		$new_event_data = $this->EventMaster->setScores($event_control_data['EventControl']['event_type'], $new_event_data, $submitted_data_validates);
	}
	$this->request->data = $event_control_data['EventControl']['use_addgrid']? $this->request->data : $processed_event_data['0'];
	
?>