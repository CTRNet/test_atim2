<?php
	
	// SETTINGS
	
	$structure_settings = array(
		'tree'=>array(
			'SampleMaster'		=> 'SampleMaster',
			'AliquotMaster'	=> 'AliquotMaster'
		),		
		'columns' => array(
			1	=> array('width' => '30%'),
			10	=> array('width' => '70%')
		)
	);
	
	// LINKS
	
	$specimen_type_filter_links = array();
	foreach ($specimen_type_list as $type => $sample_control_id) {
		$specimen_type_filter_links[$type] = '/inventorymanagement/sample_masters/contentTreeView/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control_id;
	}
	$specimen_type_filter_links['no filter'] = '/inventorymanagement/sample_masters/contentTreeView/' . $atim_menu_variables['Collection.id'] . '/-1';	
		
	$add_links = array();
	foreach ($specimen_sample_controls_list as $sample_control) {
		$add_links[$sample_control['SampleControl']['sample_type']] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
	}
//pr($specimen_sample_controls_list);	
	$search_type_links = array();
	$search_type_links['collection'] = '/inventorymanagement/collections/index/';
	$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';

	$structure_links = array(
		'tree'=>array(
			'SampleMaster' => array(
				'detail' => array(
					'link' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/' . true . '/' . true,
					'icon' => 'lungs'
				)
			),
			'AliquotMaster' => array(
				'plugin inventorymanagement aliquot detail' => array(
					'link' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/' . true . '/' . true,
					'icon' => 'aliquot')
			)
//		'AliquotMaster' => array(
//				'plugin inventorymanagement aliquot detail' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/' . true . '/' . true
//			)
		),
		'bottom' => array(
			'add' => $add_links,
			'filter' => $specimen_type_filter_links,
			'search' => $search_type_links
		),
		'ajax' => array(
			'index' => array(
				'detail' => array(
					'update' => 'frame',
					'before' => 'set_at_state_in_tree_root(this)'
				),
				'plugin inventorymanagement aliquot detail' => array(
					'update' => 'frame',
					'before' => 'set_at_state_in_tree_root(this)'
				)
			)
		)
	);
	
	// EXTRAS
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';	
	
	// BUILD
	
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}
	$structures->build($atim_structure, array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras));
?>
								
<script>
var loadingStr = "<?php echo(__("loading", null)); ?>";
</script>
<?php 
echo $javascript->link('treeViewControl')."\n";
?>