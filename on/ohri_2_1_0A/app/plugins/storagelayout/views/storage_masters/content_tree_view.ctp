<?php
		
	// SETTINGS
	
	$structure_settings = array(
		'tree' => array(
			'StorageMaster' => 'StorageMaster',
			'AliquotMaster' => 'AliquotMaster',
			'TmaSlide' => 'TmaSlide'
		),
		'columns' => array(
			1	=> array('width' => '30%'),
			10	=> array('width' => '70%')
		)
	);
	
	// LINKS
	$bottom = array();
	if(isset($search)){
		$add_links = array();
		foreach ($storage_controls_list as $storage_control) {
			$add_links[__($storage_control['StorageControl']['storage_type'], true)] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'];
		}
		ksort($add_links);
		$bottom = array(
			'search' => '/storagelayout/storage_masters/index', 
			'add' => $add_links);
	}
	
	$structure_links = array(
		'tree'=>array(
			'StorageMaster' => array(
				'detail' => array(
					'link' => '/storagelayout/storage_masters/detail/%%StorageMaster.id%%/1',
					'icon' => 'storage'),
				'access to all data' => array(
					'link'=> '/storagelayout/storage_masters/detail/%%StorageMaster.id%%/',
					'icon' => 'access_to_data'
				)
			),
			'AliquotMaster' => array(
				'detail' => array(
					'link' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/0',
					'icon' => 'aliquot'),
				'access to all data' => array(
					'link'=> '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
					'icon' => 'access_to_data'
				)
			),
			'TmaSlide' => array(
				'detail' => array(
					'link' => '/storagelayout/tma_slides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/1',
					'icon' => 'slide'),
				'access to all data' => array(
					'link'=> '/storagelayout/tma_slides/detail/%%TmaSlide.tma_block_storage_master_id%%/%%TmaSlide.id%%/',
					'icon' => 'access_to_data'
				)
			)
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
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>
								
<script>
var loadingStr = "<?php echo(__("loading", null)); ?>";
</script>
<?php 
echo $javascript->link('treeViewControl')."\n";
?>