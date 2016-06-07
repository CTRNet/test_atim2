<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/',
			(__('add items to order').' : '.__('aliquot')) =>array('link'=>'/Order/OrderItems/add/%%Order.id%%/%%OrderLine.id%%/AliquotMaster','icon'=>'add_to_order'),
			(__('add items to order').' : '.__('tma slide')) =>array('link'=>'/Order/OrderItems/add/%%Order.id%%/%%OrderLine.id%%/TmaSlide','icon'=>'add_to_order'),
			'delete'=>'/Order/OrderLines/delete/%%Order.id%%/%%OrderLine.id%%/'
		),
		'bottom'=>array(
			'add order line'=>'/Order/OrderLines/add/'.$atim_menu_variables['Order.id'].'/',
			'add shipment'=>array('link'=>'/Order/Shipments/add/' . $atim_menu_variables['Order.id'] . '/','icon'=>'create_shipment')
		)
	);
	if(Configure::read('order_item_type_config') == '2') unset($structure_links['index'][__('add items to order').': '.__('tma slide')]);
	if(Configure::read('order_item_type_config') == '3') unset($structure_links['index'][__('add items to order').': '.__('aliquot')]);
		
	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
?>
