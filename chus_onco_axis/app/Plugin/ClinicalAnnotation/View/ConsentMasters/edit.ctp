<?php 
	$structure_links = array(
		'top'=>'/ClinicalAnnotation/ConsentMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ConsentMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/ClinicalAnnotation/ConsentMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ConsentMaster.id'].'/'
		)
	);
	
	$structure_settings = array('header' => __($consent_type, null));
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'settings'=>$structure_settings);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>