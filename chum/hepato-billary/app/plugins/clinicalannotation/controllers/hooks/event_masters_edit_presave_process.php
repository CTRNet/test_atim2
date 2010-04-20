<?php

	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.presentation: Add BMI value
	// --------------------------------------------------------------------------------
	$this->data = $this->addBmiValue($this->data, $event_group, $event_master_data['EventControl']['disease_site'], $event_master_data['EventControl']['event_type']);
	
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.medical imaging *** - volumetry: Complete volumetry data
	// --------------------------------------------------------------------------------
	$this->data = $this->completeVolumetry($this->data);
	
?>
