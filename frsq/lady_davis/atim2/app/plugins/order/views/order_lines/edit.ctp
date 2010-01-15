<?php 
	$structure_links = array(
		'top'=>'/order/order_lines/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'],
		'bottom'=>array('cancel'=>'/order/order_lines/detail/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'])
	);
	
	$structure_override = array();
	
	// Generate product type list
	$sample_aliquot_controls = array();
	foreach($sample_aliquot_controls_list as $key => $new_product_type) {
		$sample_type = $new_product_type['sample_type'];
		$aliquot_type = $new_product_type['aliquot_type'];
		
		$sample_aliquot_controls[$key] = (empty($aliquot_type)? 
			__($sample_type, true) : 
			__($sample_type, true) . ' '. __($aliquot_type, true));
	}
	$structure_override['FunctionManagement.sample_aliquot_control_id'] = $sample_aliquot_controls;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>