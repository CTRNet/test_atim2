<?php

	$this->request->data = $this->EventMaster->addBmiValue($this->request->data);
	$this->request->data = $this->EventMaster->setHospitalizationDuration($this->request->data);	
	$this->request->data = $this->EventMaster->setIntensiveCareDuration($this->request->data);
	$this->request->data = $this->EventMaster->completeVolumetry($this->request->data, $submitted_data_validates);
	$this->request->data = $this->EventMaster->setScores($event_control_data['EventControl']['event_type'], $this->request->data, $submitted_data_validates);

?>