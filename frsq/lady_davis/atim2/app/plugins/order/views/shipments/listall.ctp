<?php
	$structure_links = array(
		'top'=>null,
		'index'=>'/order/shipments/detail/'.$atim_menu_variables['Order.id'].'/%%Shipment.id%%',
		'bottom'=>array(
			'add'=>'/order/shipments/add/'.$atim_menu_variables['Order.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>