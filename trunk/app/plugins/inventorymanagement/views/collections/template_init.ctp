<?php
	ob_start();

	$structure_build_options = array(
		'type' => 'edit',
		'links' => array('top' => '/inventorymanagement/collections/templateInit/'.$collection_id.'/'.$template['Template']['id']),
		'settings' => empty($template_init_structure['Sfs'])? 
			array(): 
			array('header' => array('title' => __('default values', true)),
		)
	);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}	
		
	$structures->build($template_init_structure, $structure_build_options);
	
	$display = $shell->validationErrors().ob_get_contents();
	ob_end_clean();
	$display = ob_get_contents().$display;
	ob_clean();
	$shell->validationErrors = null;
	echo json_encode(array('goToNext' => isset($goToNext), 'display' => $display));
	