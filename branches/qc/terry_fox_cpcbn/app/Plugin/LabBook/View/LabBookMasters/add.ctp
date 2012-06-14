<?php 
	
	$bottom_buttons = array();
	$settings = array();

	if($is_ajax){ 
		$settings['header'] = array('title' => __('add lab book'), 'description' => $book_type);
	}else{
		$bottom_buttons['cancel'] = '/labbook/LabBookMasters/index/';
	}
	
	$structure_links = array(
		'top' => '/labbook/LabBookMasters/add/' . $atim_menu_variables['LabBookControl.id'].'/'.$is_ajax,
		'bottom' => $bottom_buttons
	);

	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
		
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>