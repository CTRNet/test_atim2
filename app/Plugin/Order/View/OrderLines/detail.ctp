<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Order/OrderLines/edit/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'],
			'add order line item'=>'/Order/OrderItems/add/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/',
			'add shipment'=>array('link'=>'/Order/shipments/add/' . $atim_menu_variables['Order.id'] . '/','icon'=>'create_shipment'),
			'delete'=>'/Order/OrderLines/delete/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id']
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'settings' => array('actions' => false));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	

	
	
	$final_atim_structure = array(); 
	$final_options = array('links' => $structure_links, 'extras' => array('end' => $this->Structures->generateIndex('Order/OrderItems/listall/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['OrderLine.id'].'/')));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
