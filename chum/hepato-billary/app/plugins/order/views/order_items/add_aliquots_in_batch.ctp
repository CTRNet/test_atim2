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
		'links' => array('top' => '/order/order_items/addAliquotsInBatch/'), 
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
				'add aliquots to order line' => '/order/order_items/addAliquotsInBatch/-1/%%OrderLine.order_id%%_%%OrderLine.id%%'
			),
		),
		'bottom' => array('cancel' => $url_to_cancel),
		'top' => '/order/order_items/addAliquotsInBatch/'
	);
	
	$structure_override = array();
	$structure_override['OrderLine.sample_control_id'] = $sample_controls_list;
	$structure_override['OrderLine.aliquot_control_id'] = $aliquot_controls_list;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'tree', 
		'data' => $order_line_data_for_tree_view,
		'links'=>$structure_links, 
		'settings'=> $structure_settings, 
		'override'=>$structure_override,
		);
	$final_options['settings']['form_inputs'] = false;
	$final_options['settings']['form_top'] = false;
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>

<script type="text/javascript">
//TODO: validate link
$(function (){
	$("a.form.add").each(function(){
		var link = $(this).attr("href");
		$(this).replaceWith("<input type='radio' name='data[order_line_ids]' value='" + link.substr(link.lastIndexOf("/") + 1) + "'/>");
	});
});
</script>