<?php

	$add_links = array();
	foreach ($storage_controls_list as $storage_control) {
		$add_links[__($storage_control['StorageControl']['storage_type'], true)] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'];
	}
	ksort($add_links);
	
	$settings = array('return' => true);
	
	if(isset($is_ajax) && !$from_layout_page){
		$settings['actions'] = false;
	}
	
	$structure_links = array(
		'index' => array('detail' => '/storagelayout/storage_masters/detail/%%StorageMaster.id%%'),
		'bottom' => array(
			'add' => $add_links,
			'tree view' => '/storagelayout/storage_masters/contentTreeView'
		) 
	);
	
	if($from_layout_page){
		unset($structure_links['bottom']);
		$structure_links['bottom'] = array('cancel' => 'javascript:searchBack();');
		$settings['pagination'] = false;
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links, 'settings' => $settings);
	
	if(isset($overflow)){
		$shell->validationHtml();//clear validations
		$final_atim_structure = $empty_structure;
	}
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$form = $structures->build( $final_atim_structure, $final_options );
	
	if(isset($overflow)){
		$form = '<ul class="error">
				<li>'.__("the query returned too many results", true).'. '.__("try refining the search parameters", true).'</li>
			</ul>'.$form;
	}
	if(isset($is_ajax)){
		echo json_encode(array(
			'page' => $shell->validationHtml().$form, 
			'new_search_id' => AppController::getNewSearchId()
		));
	}else{
		echo $form;
	}
	
?>