<?php
	
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.*** medical past history: 
	//   Set Medical Past History precisions list
	// --------------------------------------------------------------------------------
	$this->setMedicalPastHistoryPrecisions(array('EventControl' => $this->data['EventControl']));
	
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.medical imaging *** : 
	//   Set Imaging Structure (other +/- pancreas +/- Semgments +/- etc)
	// --------------------------------------------------------------------------------
	$event_control_data = array('EventControl' => $this->data['EventControl']);
	$this->setMedicalImaginStructures($event_control_data);

?>
