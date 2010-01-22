<?php 

	// 1- ORDER DETAIL	
	
	$structure_links = array(
		'index'=>array(),
		'bottom'=>array(
			'edit'=>'/order/orders/edit/' . $atim_menu_variables['Order.id'] . '/',
			'add order line'=>'/order/order_lines/add/' . $atim_menu_variables['Order.id'] . '/',
			'add shipment'=>'/order/shipments/add/' . $atim_menu_variables['Order.id'] . '/',
			'delete'=>'/order/orders/delete/' . $atim_menu_variables['Order.id'] . '/',
			'search'=>'/order/orders/index'
		)
	);
	
	$structure_override = array();
	
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['Order.study_summary_id'] = $studies_list;	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('override'=>$structure_override, 'settings' => array('actions' => false), 'data' => $order_data);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	
	// 2- ORDER LINES
	
	$structure_links['index'] = array('detail'=>'/order/order_lines/detail/%%Order.id%%/%%OrderLine.id%%/');
	
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

	$final_atim_structure = $orderlines_listall_structure; 
	$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $order_lines_data, 'settings' => array('header' => __('order_order lines', null), 'separator' => true));
		
	// CUSTOM CODE
	$hook_link = $structures->hook('order_lines');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>