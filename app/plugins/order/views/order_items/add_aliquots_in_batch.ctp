<?php

	// 1- ALIQUOTS LIST	
	
	$structure_override = array();
	$structure_override['ViewAliquot.bank_id'] = $bank_list;
			
	$final_atim_structure = $atim_structure_for_aliquots_list;
	$final_options = array(
		'type' => 'index', 
		'data' => $aliquots_data, 
		'settings' => array('actions' => false, 'header' => __('add aliquots to order: studied aliquots', null)), 
		'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('aliquots');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);

	
	//2- ORDER ITEMS DATA ENTRY
	
	$final_atim_structure = $atim_structure_orderitems_data;
	$final_options = array(
		'type' => 'add', 
		'links' => array('top' => 'coco'), 
		'settings' => array('actions' => false, 'header' => __('1- add order data', null), 'separator' => true, 'form_top' => true, 'form_bottom' => false));
	
	// CUSTOM CODE
	$hook_link = $structures->hook('order_item');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);
	echo("</form>");
	
	
	// 3- ORDER LINES SELECTION
	
	
	$structure_settings = array(
		'tree'=>array(
			'Order'		=> 'Order',
			'OrderLine'	=> 'OrderLine'
		),
		'header' => __('2- select order line', null), 
		'separator' => true
	);
	
	$structure_links = array(
		'tree'=>array(
			'OrderLine' => array(
				'add aliquots to order line' => '/order/order_items/addAliquotsInBatch/-1/%%OrderLine.order_id%%/%%OrderLine.id%%/true'
			),
		),
		'bottom' => array('cancel' => $url_to_cancel),
		'ajax' => array(
			'index' => array(
				'add aliquots to order line' => array(
					'update' => 'frame',
					'before' => 'customSubmit(this)'
				)
			)
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
	$final_options = array(
		'type' => 'tree', 
		'data' => $order_line_data_for_tree_view,
		'links'=>$structure_links, 
		'settings'=>$structure_settings, 
		'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
		
?>

<script type="text/javascript">
function customSubmit(data){
	$$("form")[0].writeAttribute("action", data.toString().substr(0, data.toString().length - 4));
	$$("form")[0].submit();
}
</script>