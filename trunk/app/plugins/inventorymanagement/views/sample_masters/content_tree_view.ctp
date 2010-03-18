<?php
	
	// SETTINGS
	
	$structure_settings = array(
		'header' => __('filter', true) . ': ' . __($filter_value, true),
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
		
	$search_type_links = array();
	$search_type_links['collections'] = '/inventorymanagement/collections/index/';
	$search_type_links['samples'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquots'] = '/inventorymanagement/aliquot_masters/index/';

	$structure_links = array(
		'tree'=>array(
			'SampleMaster' => array(
				'detail' => array(
					'link' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/' . true . '/' . true,
					'icon' => 'flask'
				),
				'access to all data' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/' 
			),
			'AliquotMaster' => array(
				'detail' => array(
					'link' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/' . true . '/' . true,
					'icon' => 'aliquot'
				),
				'access to all data' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/' 
			)
		),
		'bottom' => array(
			'add' => $add_links,
			'filter' => $specimen_type_filter_links,
			'new search type' => $search_type_links
		),
		'ajax' => array(
			'index' => array(
				'detail' => array(
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