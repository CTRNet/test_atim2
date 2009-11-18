<?php
	
	// SETTINGS
	
	$structure_settings = array(
		'tree'=>array(
			//'SampleMaster'		=> 'SampleMaster',
			//'AliquotMaster'	=> 'AliquotMaster',
			//'ClinicalCollectionLink' => 'ClinicalCollectionLink',
			'Collection' => 'Collection',
			'SampleMaster' => 'SampleMaster',
			'AliquotMaster' => 'AliquotMaster'
		),		
		'columns' => array(
			1	=> array('width' => '30%'),
			10	=> array('width' => '70%')
		)
	);
	
	// LINKS
	$filter_links = array();
	foreach($filters as $key => $value){
		$filter_links[__($key, true)] = '/clinicalannotation/product_masters/listall/'.$atim_menu_variables['Participant.id'].'/'.$key.'/';
	}
	ksort($filter_links);
	if(isset($none_filter)){
		$filter_links["--".__('no filter', true)."--"] = '/clinicalannotation/product_masters/listall/'.$atim_menu_variables['Participant.id'].'/';
	}
	
	$structure_links = array(
		'tree'=>array(
			'Collection' => array(
				'detail' => '/inventorymanagement/collections/detail/%%Collection.id%%/' . true . '/' . false
			),
			'SampleMaster' => array(
				'detail' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/' . true . '/' . false
			),
			'AliquotMaster' => array(
				'detail' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/' . true . '/' . false
			)

			
		),
//		'bottom' => array(
//			'add' => $add_links,
//			'filter' => $specimen_type_filter_links,
//			'search' => $search_type_links
//		),
		'bottom' => array(
			'filter' => $filter_links
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
		document.getElementById("frame").innerHTML = "<?php echo(__('loading', true)); ?>...";
		var tree_root = document.getElementById("tree_root");
		var tree_root_lis = tree_root.getElementsByTagName("li");
		for (var i=0; i<tree_root_lis.length; i++) {
			tree_root_lis[i].className = false;
		}
		new_at_li.parentNode.className = "at";
	}
</script>
