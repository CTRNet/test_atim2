<?php
	
	// --------------------------------------------------------------------------------
	// Create Temporary Participant Identifier
	// -------------------------------------------------------------------------------- 
	$this->data['Participant']['participant_identifier'] = $_SESSION['Auth']['User']['id']."-".microtime()."-".rand(0,100000);
	
?>