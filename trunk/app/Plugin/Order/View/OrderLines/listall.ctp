<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/Order/OrderLines/detail/%%Order.id%%/%%OrderLine.id%%/',
			'add order line item'=>array('link'=>'/Order/OrderItems/add/%%Order.id%%/%%OrderLine.id%%/','icon'=>'add_to_order'),
			'delete'=>'/Order/OrderLines/delete/%%Order.id%%/%%OrderLine.id%%/'
		),
		'bottom'=>array(
			'add order line'=>'/Order/OrderLines/add/'.$atim_menu_variables['Order.id'].'/',
			'add shipment'=>array('link'=>'/Order/shipments/add/' . $atim_menu_variables['Order.id'] . '/','icon'=>'create_shipment')
		)
	);
	
	$structure_override = array();

	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
?>
