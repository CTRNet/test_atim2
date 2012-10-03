<?php

	if(isset($add_link_for_procure_forms)) {
		$final_options['links']['bottom']['add form'] = $add_link_for_procure_forms;
		$structure_links['bottom']['add form'] = $add_link_for_procure_forms;
	}
	
	
	if(isset($aps_structure)) {
		$this->Structures->build( $final_atim_structure, $final_options );
		
		// aps
		$structure_settings = array(
				'form_inputs'	=> false,
				'pagination'	=> false,
				'actions'		=> false,
				'form_bottom'	=> true,
				'language_heading' 		=> __('aps'),
				'form_top' 		=> false
		);
		
		$structure_links['index']['detail'] =  '/ClinicalAnnotation/EventMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%';
		$final_options = array('data' => $aps, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
		$final_atim_structure = $aps_structure;
		
		$this->Structures->build( $final_atim_structure, $final_options );
		
		// clinical event
		$structure_settings = array(
				'form_inputs'	=> false,
				'pagination'	=> false,
				'actions'		=> false,
				'form_bottom'	=> true,
				'language_heading' 		=> __('clinical events'),
				'form_top' 		=> false
		);
		
		$structure_links['index']['detail'] =  '/ClinicalAnnotation/EventMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%EventMaster.id%%';
		$final_options = array('data' => $clinical_events, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
		$final_atim_structure = $clinical_events_structure;
		
		$this->Structures->build( $final_atim_structure, $final_options );
		
		// treatment
		$structure_settings = array(
				'form_inputs'	=> false,
				'pagination'	=> false,
				'actions'		=> false,
				'form_bottom'	=> true,
				'language_heading' 		=> __('treatments'),
				'form_top' 		=> false
		);
		
		$structure_links['index']['detail'] =  '/ClinicalAnnotation/TreatmentMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%TreatmentMaster.id%%/';
		$final_options = array('data' => $treatments, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
		$final_atim_structure = $treatments_structure;
	}	
	
	$is_ajax = true;
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	