<?php

	// --------------------------------------------------------------------------------
	// *.surgery : Add Durations (Intensive care, hospitatlisation, etc)
	// --------------------------------------------------------------------------------
	$this->data = $this->addSurgeryDurations($this->data, $tx_control_data);
	
	// --------------------------------------------------------------------------------
	// *.surgery : Add survival time
	// --------------------------------------------------------------------------------
	$this->data = $this->addSurvivalTime($participant_data, $this->data, $tx_control_data);

?>

