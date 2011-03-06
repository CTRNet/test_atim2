<?php 
	
	$bottom_buttons = array();
	if(isset($url_to_skip)) $bottom_buttons['skip lab book creation'] = $url_to_skip;
	$bottom_buttons['cancel'] = $url_to_cancel;
	$structure_links = array(
		'top' => '/labbook/lab_book_masters/add/' . $atim_menu_variables['LabBookControl.id'],
		'bottom' => $bottom_buttons
	);
	
	$settings = array();
	if(isset($lab_book_header)) $settings['header'] = $lab_book_header;

	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
		
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>