<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/reproductive_histories/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ReproductiveHistory.id'].'/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/reproductive_histories/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ReproductiveHistory.id'].'/'
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>
