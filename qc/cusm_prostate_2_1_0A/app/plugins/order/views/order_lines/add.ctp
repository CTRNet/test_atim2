<?php 
	$structure_links = array(
		'top'=>'/order/order_lines/add/'.$atim_menu_variables['Order.id'].'/',
		'bottom'=>array('cancel'=>'/order/order_lines/listall/'.$atim_menu_variables['Order.id'].'/')
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>