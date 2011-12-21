<?php
	
	unset($final_options['links']['bottom']['filter']);

	// --------------------------------------------------------------------------------
	// Duplicate Add Button for clinical annotation to split add options to:
	//		- medical history
	//		- medical imaging
	//		- other
	// --------------------------------------------------------------------------------

	if(isset($medical_past_history_add_links) && isset($medical_imaging_add_links)) {
		$final_options['links']['bottom']['add medical history'] = $medical_past_history_add_links;
		$final_options['links']['bottom']['add medical imaging'] = $medical_imaging_add_links;
		$final_options['links']['bottom']['add other clinical event'] = $final_options['links']['bottom']['add'];
		unset($final_options['links']['bottom']['add']);		
	}

//TODO keep?	
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.*** medical past history: 
	//   Build Medical Past History precisions list
	// --------------------------------------------------------------------------------
	if(isset($medical_past_history_precisions)) {
		$final_options['override' ]['EventDetail.disease_precision'] = $medical_past_history_precisions;
	}
		
?>
