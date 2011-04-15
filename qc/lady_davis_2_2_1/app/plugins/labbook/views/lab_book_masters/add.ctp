<?php 
	
	$bottom_buttons = array();
	$settings = array();
	$structure_links = array(
		'top' => '/labbook/lab_book_masters/add/' . $atim_menu_variables['LabBookControl.id'].'/'.$is_ajax,
		'bottom' => $bottom_buttons
	);
	
	
	if($is_ajax){ 
		$settings['header'] = array('title' => __('add lab book', true), 'description' => $book_type);
	}else{
		$bottom_buttons['cancel'] = '/labbook/lab_book_masters/index/';
	}

	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
		
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>