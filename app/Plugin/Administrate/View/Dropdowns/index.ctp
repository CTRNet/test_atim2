<?php
	
	// --------- Lists with values ----------------------------------------------------------------------------------------------
	
	$final_atim_structure = array(); 
	$final_options = array(
		'type' => 'detail', 
		'links'	=> array(),
		'settings' => array(
			'header' => __('used lists', null),
			'actions'	=> false), 
		'extras' => $this->Structures->ajaxIndex('/Administrate/Dropdowns/subIndex/not_empty')
	);
	
	$display_next_form = true; 
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('not_empty');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	if($display_next_form) $this->Structures->build( $final_atim_structure, $final_options );	
	
	// --------- Empty lists ----------------------------------------------------------------------------------------------
	
	$final_atim_structure = array(); 
	$final_options = array(
		'type' => 'detail', 
		'links'	=> array(),
		'settings' => array(
			'header' => __('empty lists', null),
			'actions'	=> true), 
		'extras' => $this->Structures->ajaxIndex('/Administrate/Dropdowns/subIndex/empty')
	);
	
	$display_next_form = true; 
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('empty');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	if($display_next_form) $this->Structures->build( $final_atim_structure, $final_options );	
	