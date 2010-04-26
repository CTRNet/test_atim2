<?php
	
	// --------------------------------------------------------------------------------
	// Add link 'Add/Access linked lab report
	// -------------------------------------------------------------------------------- 	
 	if(isset($linked_lab_report_link)) {
 		$final_options['links']['bottom'] = array_merge($linked_lab_report_link, $final_options['links']['bottom']);
 	}
 	
?>
