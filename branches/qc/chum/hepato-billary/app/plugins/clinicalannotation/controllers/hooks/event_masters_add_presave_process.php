<?php

	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.presentation: Add BMI value
	// --------------------------------------------------------------------------------
	$this->data = $this->addBmiValue($this->data, $event_group, $event_control_data['EventControl']['disease_site'], $event_control_data['EventControl']['event_type']);
?>
