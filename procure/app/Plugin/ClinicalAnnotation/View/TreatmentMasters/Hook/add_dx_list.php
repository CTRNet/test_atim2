<?php
	
	//Set skip button for visit data entry workflow
	if($next_url_to_flash_for_visit_data_entry) {
		$final_options['links']['bottom']['visit data entry done'] = array('link' => $final_options['links']['bottom']['cancel'], 'icon' => 'cancel');
		unset($final_options['links']['bottom']['cancel']);
		$final_options['links']['bottom']['skip visit data entry step'] = array('link' => $next_url_to_flash_for_visit_data_entry, 'icon' => 'procureskip');
	}
	
	//To hide the related diagnosis event section
	$final_options = array('links'	=> $final_options['links']);
	