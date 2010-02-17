<?php

	// --------------------------------------------------------------------------------
	// hepatobiliary-clinical-medical_past_history : 
	//    Add Event Extend to add deases precisions
	// --------------------------------------------------------------------------------
	if(isset($medical_history_detail_structure)) {
		// End of previous sub form
		$final_options['settings']['actions']= false;
		$final_options['settings']['form_bottom']= false;
	
		$structures->build( $final_atim_structure, $final_options );
		
		// 3- MEDICAL PAST HISTORY DETAIL
		
		// links
		
		$add_links = array();
		foreach ($allowed_disease_types_list as $type => $translated_type) {
			$add_links[$translated_type] = '/clinicalannotation/event_masters/addMedicalHistDetail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'].'/'.$type;
		}	
				
		$new_structure_links = array(
			'index' => array(
				'edit' => '/clinicalannotation/event_masters/editMedicalHistDetail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'].'/%%EventExtend.id%%',
				'delete' => '/clinicalannotation/event_masters/deleteMedicalHistDetail/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'].'/%%EventExtend.id%%'
			),
			'bottom'=>array(
				'edit summary'=>$structure_links['bottom']['edit'], 
				'add detail'=>$add_links, 
				'delete'=>$structure_links['bottom']['delete'], 
				'list'=>$structure_links['bottom']['list']
			)		
		);
		
		$structure_links = $new_structure_links;

		// settings
		
		$structure_settings = array(
			'header' => __('medical past history details', null));
			
		// override
		
		$structure_override = array();
		
		$structure_override['EventExtend.disease_type'] = $allowed_disease_types_list;	
		$structure_override['EventExtend.disease_precision'] = $allowed_disease_precisions_list;	
			
		$final_atim_structure = $medical_history_detail_structure;
		$final_options = array('links'=>$structure_links, 'override' => $structure_override, 'type' => 'index', 'settings'=>$structure_settings, 'data' => $medical_history_details);
	}

?>
