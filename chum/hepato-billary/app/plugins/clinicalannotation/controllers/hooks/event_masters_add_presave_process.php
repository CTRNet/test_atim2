<?php

	$this->data = $this->EventMaster->addBmiValue($this->data);
	$this->data = $this->EventMaster->setHospitalizationDuration($this->data);	
	$this->data = $this->EventMaster->setIntensiveCareDuration($this->data);
	$this->data = $this->EventMaster->completeVolumetry($this->data);
	
	$this->EventMaster->set($this->data);
	$this->EventMaster->setScores($event_control_data['EventControl']['event_type']);
    
?>