<?php 
	
	$structure_links = array(
		'top' => '/labbook/lab_book_masters/add/' . $atim_menu_variables['LabBookControl.id'],
		'bottom' => array('cancel' => '/labbook/lab_book_masters/index/')
	);

	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
		
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>