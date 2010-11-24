<?php

	// --------------------------------------------------------------------------------
	// *.surgery : Add Durations (Intensive care, hospitatlisation, etc)
	// --------------------------------------------------------------------------------
	$this->data = $this->addSurgeryDurations($this->data, $treatment_master_data);
	
	// --------------------------------------------------------------------------------
	// *.surgery : Add survival time
	// --------------------------------------------------------------------------------
	$participant_data = $this->Participant->find('first', array('conditions'=>array('Participant.id'=>$participant_id), 'recursive' => '-1'));
	if(empty($participant_data)) { $this->redirect( '/pages/err_clin_no_data', null, true ); }
	$this->data = $this->addSurvivalTime($participant_data, $this->data, $treatment_master_data);

?>