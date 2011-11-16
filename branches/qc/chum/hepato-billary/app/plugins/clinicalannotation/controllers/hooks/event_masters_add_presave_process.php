<?php

	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.presentation: Add BMI value
	// --------------------------------------------------------------------------------
	$this->data = $this->EventMaster->addBmiValue($this->data, $event_group, $event_control_data['EventControl']['disease_site'], $event_control_data['EventControl']['event_type']);

	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.medical imaging *** - volumetry: Complete volumetry data
	// --------------------------------------------------------------------------------
	$this->data = $this->EventMaster->completeVolumetry($this->data);
	
	$this->data = $this->EventMaster->setHospitalizationDuration($this->data);
	
	$this->data = $this->EventMaster->setIntensiveCareDuration($this->data);
	
	$this->EventMaster->setScores($event_control_data['EventControl']['event_type']);
    
?>