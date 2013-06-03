<?php 
	$structure_override = array();
	
	$dropdown = null;
	if(isset($is_ccl_ajax)){
		//forece participant collection
		foreach($atim_structure['Sfs'] as &$field){
			if($field['field'] == "collection_property"){
				$field['flag_search_readonly'] = true;
				break;
			}
		}
		$structure_override['ViewCollection.collection_property'] = "participant collection";
		$dropdown['ViewCollection.collection_property'] = array("participant collection" => __("participant collection"));
		$last_5 = "";
	}else{
		$settings = array();
		$final_atim_structure = $atim_structure;
		include('search_links_n_options.php');
		$final_options['settings']['return'] = true;
		$final_options['settings']['pagination'] = false;
		$final_options['settings']['actions'] = false;
		$last_5 = $this->Structures->build( $final_atim_structure, $final_options );
	}
	
	$settings = array(
			'header' => array('title' => __('search type', null).': '.__('collections', null), 'description' => __("more information about the types of samples and aliquots are available %s here", $help_url)),
			'actions' => false
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'type' => 'search', 
		'links' => array('top' => '/InventoryManagement/Collections/search/'.AppController::getNewSearchId()),
		'override' => $structure_override, 
		'settings' => $settings
	);
	if($dropdown !== null){
		$final_options['dropdown_options'] = $dropdown;
	}
	
	$final_atim_structure2 = $empty_structure;
	$final_options2 = array(
		'links' => isset($is_ccl_ajax) ? array() : array('bottom' => array(
			'add collection' => '/InventoryManagement/Collections/add'
		)),
		'extras'	=> '<div class="ajax_search_results"></div><div class="ajax_search_results_default">'.$last_5.'</div>'
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	if(!isset($is_ccl_ajax)){
		$this->Structures->build( $final_atim_structure2, $final_options2 );
	}
?>