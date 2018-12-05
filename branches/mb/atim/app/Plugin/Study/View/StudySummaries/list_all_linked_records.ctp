<?php

	// ----- ALIQUOT -----
	
	$final_atim_structure = array(); 
	$final_options = array(
		'type' => 'detail',
		'links'	=> array(),
		'settings' => array(
			'header' => __('aliquots', null),
			'actions'	=> false), 
		'extras' => $link_permissions['aliquot']? array('end' => $this->Structures->ajaxIndex('Study/StudySummaries/listAllLinkedAliquots/'.$atim_menu_variables['StudySummary.id'])) : __('You are not authorized to access that location.')
	);
	
	$display_next_form = true; 
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('aliquots');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	if($display_next_form) $this->Structures->build( $final_atim_structure, $final_options );	

	// ----- ALIQUOT INTERNAL USES -----
	
	$final_atim_structure = array(); 
	$final_options = array(
		'type' => 'detail',
		'links'	=> array(),
		'settings' => array(
			'header' => __('aliquot uses', null),
			'actions'	=> false), 
		'extras' => $link_permissions['aliquot use']? array('end' => $this->Structures->ajaxIndex('Study/StudySummaries/listAllLinkedAliquotInternalUses/'.$atim_menu_variables['StudySummary.id'])) : __('You are not authorized to access that location.')
	);
	
	$display_next_form = true; 
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('aliquot_internal_uses');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	if($display_next_form) $this->Structures->build( $final_atim_structure, $final_options );		

	// ----- ORDERS -----
	
	$final_atim_structure = array(); 
	$final_options = array(
		'type' => 'detail',
		'links'	=> array(),
		'settings' => array(
			'header' => __('orders', null),
			'actions'	=> false),
		'extras' => $link_permissions['order']? array('end' => $this->Structures->ajaxIndex('Study/StudySummaries/listAllLinkedOrders/'.$atim_menu_variables['StudySummary.id'])) : __('You are not authorized to access that location.')
	);
	
	$display_next_form = true; 
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('orders');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	if($display_next_form) $this->Structures->build( $final_atim_structure, $final_options );	
 	
	// ----- ORDER LINES -----
	
	$final_atim_structure = array(); 
	$final_options = array(
		'type' => 'detail',
		'links'	=> array(),
		'settings' => array(
			'header' => __('order lines', null),
			'actions'	=> true), 
		'extras' => $link_permissions['order line']? array('end' => $this->Structures->ajaxIndex('Study/StudySummaries/listAllLinkedOrderLines/'.$atim_menu_variables['StudySummary.id'])) : __('You are not authorized to access that location.')
	);
	
	$display_next_form = true; 
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook('order_lines');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	if($display_next_form) $this->Structures->build( $final_atim_structure, $final_options );	

?>








