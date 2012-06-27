<?php 

	// --------------------------------------------------------------------------------
	// Generate default sequence number based on collection visit label
	// -------------------------------------------------------------------------------- 
	if(isset($default_sequence_number)) {
		$final_options['override']['SpecimenDetail.sequence_number'] = $default_sequence_number;		
	}
	
?>
