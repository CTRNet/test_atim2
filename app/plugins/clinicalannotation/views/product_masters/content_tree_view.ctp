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
	
//	$specimen_type_filter_links = array();
//	foreach ($specimen_type_list as $type => $sample_control_id) {
//		$specimen_type_filter_links[$type] = '/inventorymanagement/sample_masters/contentTreeView/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control_id;
//	}
//	$specimen_type_filter_links['no filter'] = '/inventorymanagement/sample_masters/contentTreeView/' . $atim_menu_variables['Collection.id'] . '/-1';	
//		
//	$add_links = array();
//	foreach ($specimen_sample_controls_list as $sample_control) {
//		$add_links[$sample_control['SampleControl']['sample_type']] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'];
//	}
//	
//	$search_type_links = array();
//	$search_type_links['collection'] = '/inventorymanagement/collections/index/';
//	$search_type_links['sample'] = '/inventorymanagement/sample_masters/index/';
//	$search_type_links['aliquot'] = '/inventorymanagement/aliquot_masters/index/';
	
	$filter_links = array();
	$filter_links['filter1'] = '/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$diagnosis_control['DiagnosisControl']['id'].'/';
	$filter_links['filter2'] = '/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$diagnosis_control['DiagnosisControl']['id'].'/';
	
	
	$structure_links = array(
		'tree'=>array(
			'Collection' => array(
				'detail' => '/inventorymanagement/collections/detail/%%Collection.id%%/true/'
			),
			'SampleMaster' => array(
				'detail' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/true'
			),
			'AliquotMaster' => array(
				'detail' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/1/true'
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
	
	
//	$add_links = array();
//	foreach ($diagnosis_controls_list as $diagnosis_control) {
//		$add_links[$diagnosis_control['DiagnosisControl']['controls_type']] = '/clinicalannotation/diagnosis_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$diagnosis_control['DiagnosisControl']['id'].'/';
//	}
//
//	$structure_links = array(
//		'index'=>array('detail'=>'/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'),
//		'bottom'=>array(
//			'add' => $add_links
//		)
//	);
	
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
