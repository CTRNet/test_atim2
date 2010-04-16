<?php

	// --------------------------------------------------------------------------------
	// Duplicate Add Button for clinical annotation to split add options to:
	//		- medical history
	//		- medical imaging
	//		- other
	// --------------------------------------------------------------------------------
	
	if($is_clinical_group) {
		$medcial_past_history_add_links = array();
		foreach ( $medical_past_history_event_controls as $event_control ) {
			// Build Medical History Add Button
			$medcial_past_history_add_links[ __($event_control['EventControl']['disease_site'],true).' - '.__($event_control['EventControl']['event_type'],true) ] = '/clinicalannotation/event_masters/add/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
			// Buil Filter Button
			$final_options['links']['bottom']['filter'][ __($event_control['EventControl']['disease_site'],true).' - '.__($event_control['EventControl']['event_type'],true) ] = '/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
		}
				
		
		$medcial_imaging_add_links = array();
		foreach ( $medical_imaging_event_controls as $event_control ) {
			// imaging button
			$medcial_imaging_add_links[ __($event_control['EventControl']['disease_site'],true).' - '.__(substr($event_control['EventControl']['event_type'], 16), true) ] = '/clinicalannotation/event_masters/add/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
			// Add data to filter button
			$final_options['links']['bottom']['filter'][ __($event_control['EventControl']['disease_site'],true).' - '.__(substr($event_control['EventControl']['event_type'], 16), true) ] = '/clinicalannotation/event_masters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$event_control['EventControl']['id'];
		}
		
		// Rebuild links
		$final_options['links']['bottom']['add medical history'] = $medcial_past_history_add_links;
		$final_options['links']['bottom']['add medical imaging'] = $medcial_imaging_add_links;
		$final_options['links']['bottom']['add other clinical event'] = $final_options['links']['bottom']['add'];
		unset($final_options['links']['bottom']['add']);		
	}

	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.*** medical past history: 
	//   Build Medical Past History precisions list
	// --------------------------------------------------------------------------------
	if(isset($medical_past_history_precisions)) {
		$final_options['override' ]['EventDetail.disease_precision'] = $medical_past_history_precisions;
	}
		
?>
