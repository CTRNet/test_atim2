<?php 
	$structure_links = array(
		'index' => array('detail' => '/order/order_items/listall/%%OrderLine.order_id%%/%%OrderLine.id%%/'),
		'bottom' => array(
			'new search' => OrderAppController::$search_links,
			'add order' => '/order/orders/add/'
		)
	);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}else{
		$settings['header'] = __('search type', null).': '.__('order item', null);
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'index', 
		'links' => $structure_links, 
		'settings' => $settings
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$form = $structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax)){
		echo json_encode(array('page' => $form, 'new_search_id' => AppController::getNewSearchId()));
	}else{
		echo $form;
	}
?>
