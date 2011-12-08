<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/order/orders/detail/%%Order.id%%'),
		'bottom'=>array(
			'new search' => OrderAppController::$search_links,
			'add'=>'/order/orders/add'
		)
	);
	
	$settings = array('return' => true);
	if(isset($is_ajax)){
		$settings['actions'] = false;
	}else{
		$settings['header'] = __('search type', null).': '.__('order', null);
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type'=>'index',
		'links'=> $structure_links,
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
		echo json_encode(array('page' => $shell->validationHtml().$form, 'new_search_id' => AppController::getNewSearchId()));
	}else{
		echo $form;
	}
?>