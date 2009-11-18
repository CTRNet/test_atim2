<?php 
	$structure_links = array(
		'top'=>'/order/order_lines/add/'.$atim_menu_variables['Order.id'].'/',
		'bottom'=>array('cancel'=>'/order/order_lines/listall/'.$atim_menu_variables['Order.id'].'/')
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
	
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>