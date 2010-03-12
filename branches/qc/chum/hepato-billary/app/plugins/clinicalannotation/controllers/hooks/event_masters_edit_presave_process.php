<?php

	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.presentation: Add BMI value
	// --------------------------------------------------------------------------------
	$this->data = $this->addBmiValue($this->data, $event_group, $event_master_data['EventControl']['disease_site'], $event_master_data['EventControl']['event_type']);
	
	//computing dependent variables
	//TODO: failsafe check if value < 0 && value divided by zero
	$this->data['EventDetail']['remnant_liver_volume'] = $this->data['EventDetail']['total_liver_volume'] - $this->data['EventDetail']['resected_liver_volume'];
	$this->data['EventDetail']['remnant_liver_initial_percentage'] = ($this->data['EventDetail']['remnant_liver_volume'] / ($this->data['EventDetail']['total_liver_volume'] - $this->data['EventDetail']['tumoral_volume'])) * 100;
	$this->data['EventDetail']['remnant_liver_volume_post_pve'] = $this->data['EventDetail']['total_liver_volume_post_pve'] - $this->data['EventDetail']['resected_liver_volume_post_pve'];
	$this->data['EventDetail']['remnant_liver_initial_percentage_post_pve'] = ($this->data['EventDetail']['remnant_liver_volume_post_pve'] / ($this->data['EventDetail']['total_liver_volume_post_pve'] - $this->data['EventDetail']['tumoral_volume_post_pve'])) * 100;
?>
