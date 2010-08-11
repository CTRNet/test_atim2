<?php 

	$structure_links = array(
		'top'=>'/clinicalannotation/treatment_extends/addComplicationTreatment/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id'],
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/treatment_extends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/'.$atim_menu_variables['TreatmentExtend.id']
		)
	);

			
	// Set form structure and option 
	$settings = array('header' => __('surgery complication treatment', true));
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings' => $settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>