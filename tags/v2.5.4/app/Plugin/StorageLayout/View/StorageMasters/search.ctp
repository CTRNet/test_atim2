<?php

	$add_links = array();
	foreach ($storage_controls_list as $storage_control) {
		$add_links[__($storage_control['StorageControl']['storage_type'])] = '/StorageLayout/StorageMasters/add/' . $storage_control['StorageControl']['id'];
	}
	ksort($add_links);
	
	$settings = array('return' => true);
	
	if(isset($is_ajax) && !$from_layout_page){
		$settings['actions'] = false;
	}
	
	$structure_links = array(
		'index' => array('detail' => '/StorageLayout/StorageMasters/detail/%%StorageMaster.id%%'),
		'bottom' => array(
			'add' => $add_links,
			'tree view' => '/StorageLayout/StorageMasters/contentTreeView'
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
		$this->Shell->validationHtml();//clear validations
		$final_atim_structure = $empty_structure;
	}
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$form = $this->Structures->build( $final_atim_structure, $final_options );
	
	if(isset($overflow)){
		$form = '<ul class="error">
				<li>'.__("the query returned too many results").'. '.__("try refining the search parameters").'</li>
			</ul>'.$form;
	}
	if(isset($is_ajax)){
		$this->layout = 'json';
		$this->json = array(
			'page' => $form, 
			'new_search_id' => AppController::getNewSearchId()
		);
	}else{
		echo $form;
	}
	
?>