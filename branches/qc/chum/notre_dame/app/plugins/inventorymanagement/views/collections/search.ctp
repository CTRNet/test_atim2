<?php
 	$settings = array('return' => true);
	if(isset($is_ccl_ajax)){
		$structure_links = array('radiolist' => array("ClinicalCollectionLink.collection_id" => "%%ViewCollection.collection_id%%"));
		$final_options = array(
			'type' => 'index', 
			'data' => $this->data, 
			'links' => $structure_links, 
			'settings' => array('pagination' => false, 'actions' => false, 'return' => true)
		);
		if(isset($overflow)){
			?>
			<ul class="error">
				<li><?php echo(__("the query returned too many results", true).". ".__("try refining the search parameters", true)); ?>.</li>
			</ul>
			<?php 
		}
		
	}else{
		if(isset($is_ajax)){
			$settings['actions'] = false;
		}else{
			$settings['header'] = array(
				'title' => __('search type', null).': '.__('collections', null),
				'description' => sprintf(__("more information about the types of samples and aliquots are available %s here", true), $help_url)
			);
		}
		$structure_links = array(
			'index' => array(
				'detail' => '/inventorymanagement/collections/detail/%%ViewCollection.collection_id%%',
				'copy for new collection' => array('link' => '/inventorymanagement/collections/add/0/%%ViewCollection.collection_id%%', 'icon' => 'copy')
			), 'bottom' => array(
				'new search' => InventorymanagementAppController::$search_links,
				'add collection' => '/inventorymanagement/collections/add'
			)
		);
		$final_options = array(
			'type' => 'index', 
			'data' => $this->data, 
			'links' => $structure_links, 
			'settings' => $settings
		);
	}
	
	$final_atim_structure = $atim_structure;
	
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	$form = $structures->build( $final_atim_structure, $final_options );
	if(isset($is_ajax) && !isset($is_ccl_ajax)){
		echo json_encode(array('page' => $form, 'new_search_id' => AppController::getNewSearchId()));
	}else{
		echo $form;
	}
				
?>
