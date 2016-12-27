<?php
	
	//Set skip button for visit data entry workflow
	if($next_url_to_flash_for_visit_data_entry) {
		unset($final_options['links']['bottom']['cancel']);
		$final_options['links']['bottom'][__('skip go to %s', __($next_url_to_flash_for_visit_data_entry['next_url_title']))] = array('link' => $next_url_to_flash_for_visit_data_entry['next_url'], 'icon' => 'procureskip');
	}
	
	//To hide the related diagnosis event section
	$final_options = array('links'	=> $final_options['links']);