<?php
	
	// --------------------------------------------------------------------------------
	// Save Participant Identifier
	// -------------------------------------------------------------------------------- 
	$this->data['Participant']['participant_identifier'] = 'ATIMp-'.$this->Participant->id;
	$this->Participant->set($this->data);
	$this->Participant->save();
	
?>