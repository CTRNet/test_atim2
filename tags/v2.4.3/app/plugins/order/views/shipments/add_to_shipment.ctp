<?php
	
	$structure_links = array(
		'top'=>'/order/shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
		'bottom'=>array('cancel' => '/order/shipments/detail/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/')
	);
	
	$structure_settings = array('pagination' => false, 'header' => __('add items to shipment', null));
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'		=> 'editgrid', 
		'links'		=> $structure_links, 
		'settings'	=> $structure_settings, 
		'override'	=> $structure_override,
		'extras' => "<a href='#' class='checkAll'>".__('check all', true)."</a> | <a href='#' class='uncheckAll'>".__('uncheck all', true)."</a>"
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>
