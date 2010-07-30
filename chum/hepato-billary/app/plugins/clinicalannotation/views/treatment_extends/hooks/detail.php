<?php

	// --------------------------------------------------------------------------------
	// *.surgery: 
	//   Add surgery complication treatment
	// --------------------------------------------------------------------------------
	if(isset($complication_trts) && isset($surgery_complication_treatment_structure)) {
		$final_options['override' ]['EventDetail.disease_precision'] = $medical_past_history_precisions;
		
		// Display extend detail
		
		$final_options['settings']= array(
			'form_top' => false, 
			'form_bottom' => false, 
			'actions' => false, 
			'header' => null, 
			'separator' => false);
		$structures->build( $final_atim_structure, $final_options );
		
		// Set data to display complication treatment
		
		$final_atim_structure = $surgery_complication_treatment_structure;
		$final_options['settings']= array(
			'form_top' => false, 
			'form_bottom' => true, 
			'actions' => true, 
			'header' => __('surgery complication treatment', true), 
			'separator' => true);
		$final_options['data'] = $complication_trts;
		$final_options['type'] = 'index';
		$tmp_bottom_links = $final_options['links']['bottom'];
		$final_options['links']['bottom']= array('add treatment' => '/clinicalannotation/treatment_extends/addComplicationTreatment/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%'); 
		foreach($tmp_bottom_links as $button => $link) { $final_options['links']['bottom'][$button] = $link; }
				
		$final_options['links']['index'] = array('delete'=>'/clinicalannotation/treatment_extends/deleteComplicationTreatment/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id'].'/%%SurgeryComplicationTreatment.id%%/');
	}

?>
