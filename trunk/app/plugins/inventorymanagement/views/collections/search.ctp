<?php 

	$search_type_links = array();
	$search_type_links['collections'] = array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search');
	$search_type_links['samples'] = array('link'=> '/inventorymanagement/sample_masters/index/', 'icon' => 'search');
	$search_type_links['aliquots'] = array('link'=> '/inventorymanagement/aliquot_masters/index/', 'icon' => 'search');
	
	$structure_override = array();
	if(isset($is_ccl_ajax)){
		$structure_links = array('radiolist' => array("ClinicalCollectionLink.collection_id" => "%%ViewCollection.collection_id%%"));
		$final_options = array('type' => 'radiolist', 'data' => $collections_data, 'links' => $structure_links, 'override' => $structure_override, 'settings' => array('pagination' => false, 'actions' => false));
		if(isset($overflow)){
			?>
			<ul class="error">
				<li><?php echo(__("the query returned too many results", true).". ".__("try refining the search parameters", true)); ?>.</li>
			</ul>
			<?php 
		}
	}else{
		$structure_links = array(
		'index' => array('detail' => '/inventorymanagement/collections/detail/%%ViewCollection.collection_id%%'),
		'bottom' => array(
			'add collection' => '/inventorymanagement/collections/add', 
			'new search' => $search_type_links)
		);
		$final_options = array('type' => 'index', 'data' => $collections_data, 'links' => $structure_links, 'override' => $structure_override, 'settings' => array('header' => __('search type', null).': '.__('collections', null)));
	}
	
	$final_atim_structure = $atim_structure;
	
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
				
?>
