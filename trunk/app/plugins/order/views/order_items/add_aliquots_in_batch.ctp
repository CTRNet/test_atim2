<?php

	// 1- ALIQUOTS LIST	
	
	$structure_override = array();
			
	$final_atim_structure = $atim_structure_for_aliquots_list;
	$final_options = array('override' => $structure_override,  'type' => 'index', 'settings' => array('actions' => false, 'header' => __('add aliquots to order', null)), 'data' => $aliquots_data);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('aliquots');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);

	
	//2- Detail data
	$final_atim_structure = $add_aliquots_in_batch_info;
	$final_options = array(
		'type' => 'add', 
		'links' => array('top' => 'coco'), 
		'settings' => array('actions' => false, 'header' => __('order', null), 'separator' => true, 'form_top' => true, 'form_bottom' => false),
		);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('data');
	if($hook_link){
		require($hook_link);
	}

	// BUILD FORM
	$structures->build($final_atim_structure, $final_options);
	echo("</form>");
	
	// 3- ORDER LINES

	$structure_settings = array(
		'tree'=>array(
			'Order'		=> 'Order',
			'OrderLine'	=> 'OrderLine'
		),
		'header' => __('select order line', null), 
		'separator' => true
	);
	
	$structure_links = array(
		'tree'=>array(
			'OrderLine' => array(
				'add' => '/order/order_items/addAliquotsInBatch/-1/%%OrderLine.order_id%%/%%OrderLine.id%%/true'
			),
		),
		'bottom' => array('cancel' => $url_to_cancel),
		'ajax' => array(
			'index' => array(
				'add' => array(
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
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'override'=>$structure_override);
	
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