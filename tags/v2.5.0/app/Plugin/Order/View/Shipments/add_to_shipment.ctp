<?php
	
	$structure_links = array(
		'top'	=>'/Order/shipments/addToShipment/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/',
		'bottom'=>array('cancel' => '/Order/shipments/detail/'.$atim_menu_variables['Order.id'].'/'.$atim_menu_variables['Shipment.id'].'/'),
		'checklist' => array('OrderItem.id][' => '%%OrderItem.id%%')
	);
	
	$structure_settings = array('pagination' => false, 'header' => __('add items to shipment', null), 'actions' => false, 'form_inputs' => false, 'form_bottom' => false);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'		=> 'index', 
		'links'		=> $structure_links, 
		'settings'	=> $structure_settings, 
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
		
	// BUILD FORM
	while($data = array_shift($this->request->data)){

		if(empty($this->request->data)){
			$final_options['settings']['actions'] = true;
			$final_options['settings']['form_bottom'] = true;
		}
		$final_options['settings']['language_heading'] = __('line').': '.$data['name'];
		$final_options['data'] = $data['data'];
		if( $hook_link ) {
			require($hook_link);
		}
		$this->Structures->build( $final_atim_structure, $final_options );
		
		$final_options['settings']['header'] = array();
	}
	
?>
