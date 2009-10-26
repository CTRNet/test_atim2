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
	
	$search_type_links = array();
	$search_type_links['collection'] = '/inventorymanagement/collections/index/';
	$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
	$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';

	$structure_links = array(
		'tree'=>array(
			'SampleMaster' => array(
				'detail' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1'
			),
			'AliquotMaster' => array(
				'detail' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/1'
			)
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
				)
			)
		)
	);
	
	// EXTRAS
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';	
	
	// BUILD
	
	$structures->build($atim_structure, array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras));
?>
								
<script>
	function set_at_state_in_tree_root(new_at_li) {
		var tree_root = document.getElementById("tree_root");
		var tree_root_lis = tree_root.getElementsByTagName("li");
		for (var i=0; i<tree_root_lis.length; i++) {
			tree_root_lis[i].className = false;
		}
		new_at_li.parentNode.className = "at";
	}
</script>