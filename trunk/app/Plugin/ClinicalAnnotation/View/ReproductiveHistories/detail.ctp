<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/ClinicalAnnotation/reproductive_histories/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/ClinicalAnnotation/reproductive_histories/edit/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/',
			'delete'=>'/ClinicalAnnotation/reproductive_histories/delete/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>