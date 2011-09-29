<?php
	
	// SETTINGS
	
	$structure_settings = array(
		'tree'=>array(
			'SampleMaster'		=> 'SampleMaster',
			'AliquotMaster'	=> 'AliquotMaster'
		)
	);
	
	// LINKS
	$bottom = array();
	if(!$is_ajax){
		
		$add_links = array();
		foreach ($specimen_sample_controls_list as $sample_control) {
			$add_links[__($sample_control['SampleControl']['sample_type'],true)] = '/inventorymanagement/sample_masters/add/' . $collection_id . '/' . $sample_control['SampleControl']['id'];
		}
		ksort($add_links);
	
		$bottom = array();
		$bottom['add specimen'] = $add_links;		
		if(!empty($templates)){
			$bottom['add from template'] = array();
			foreach($templates as $template){
				$bottom['add from template'][$template['Template']['name']] = array(
					'icon' => ($template['Template']['name'] == 'day collection template')? 'add' : 'template',
					'link' => '/inventorymanagement/collections/template/'.$atim_menu_variables['Collection.id'].'/'.$template['Template']['id']
				);
			}
		}
		$bottom['new search'] = InventorymanagementAppController::$search_links;
	}

	$structure_links = array(
		'tree'=>array(
			'SampleMaster' => array(
				'detail' => array(
					'link' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/',
					'icon' => 'flask'
				),
				'access to all data' => array(
					'link'=> '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/',
					'icon' => 'access_to_data'
 				)
			),
			'AliquotMaster' => array(
				'detail' => array(
					'link' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/',
					'icon' => 'aliquot'
				),
				'access to all data' => array(
					'link'=> '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/' ,
					'icon' => 'access_to_data'
				)
			)
		),
		'tree_expand' => array(
			'SampleMaster' => '/inventorymanagement/sample_masters/contentTreeView/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/',
			'AliquotMaster' => '/inventorymanagement/aliquot_masters/contentTreeView/%%AliquotMaster.collection_id%%/%%AliquotMaster.id%%/1/',
		),
		'bottom' => $bottom,
		'ajax' => array(
			'index' => array(
				'detail' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				)
			)
		)
	);
	
	// EXTRAS
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';	
	
	// BUILD
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
	if(!$is_ajax){
		?>
		<script>
		var loadingStr = "<?php echo(__("loading", null)); ?>";
		var ajaxTreeView = true;
		</script>
		<?php 
		
	}

?>