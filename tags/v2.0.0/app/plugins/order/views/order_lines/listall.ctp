<?php 
	
	$structure_links = array(
		'index'=>array(
			'add order line item'=>'/order/order_items/add/%%Order.id%%/%%OrderLine.id%%/',		
			'detail'=>'/order/order_lines/detail/%%Order.id%%/%%OrderLine.id%%/'
		),
		'bottom'=>array(
			'add order line'=>'/order/order_lines/add/'.$atim_menu_variables['Order.id'].'/',
			'add shipment'=>'/order/shipments/add/' . $atim_menu_variables['Order.id'] . '/'
		)
	);
	
	$structure_override = array();

	$sample_types = array();
	foreach($sample_controls_list as $new_control) {
		$sample_types[$new_control['SampleControl']['id']] = __($new_control['SampleControl']['sample_type'], null);
	}
	$structure_override['OrderLine.sample_control_id'] = $sample_types;
	
	$aliquot_types = array();
	foreach($aliquot_controls_list as $new_control) {
		$aliquot_types[$new_control['AliquotControl']['id']] = __($new_control['AliquotControl']['aliquot_type'], null);
	}
	$structure_override['OrderLine.aliquot_control_id'] = $aliquot_types;

	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links,'override'=>$structure_override, 'data'=>$order_lines_data);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>