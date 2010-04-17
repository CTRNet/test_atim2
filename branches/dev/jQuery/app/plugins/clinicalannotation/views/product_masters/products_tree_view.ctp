<?php
	
	// SETTINGS
	
	$structure_settings = array(
		'tree'=>array(
			'Collection' => 'Collection',
			'SampleMaster' => 'SampleMaster',
			'AliquotMaster' => 'AliquotMaster'
		),		
		'columns' => array(
			1	=> array('width' => '30%'),
			10	=> array('width' => '70%')
		),
		'header' => __('filter', null) . ': '. $filter_value
	);
	
	// LINKS
	
	$specimen_type_filter_links = array();
	foreach ($specimen_type_list as $type => $sample_control_id) {
		$specimen_type_filter_links[$type] = '/clinicalannotation/product_masters/productsTreeView/'.$atim_menu_variables['Participant.id'].'/'.$sample_control_id;
	}
	$specimen_type_filter_links['no filter'] = '/clinicalannotation/product_masters/productsTreeView/'.$atim_menu_variables['Participant.id'];	
		
	$structure_links = array(
		'tree'=>array(
			'Collection' => array(
				'detail' => array(
					'link' => '/inventorymanagement/collections/detail/%%Collection.id%%/1/0',
					'icon' => 'collection'
				),
				'access to all data' => array(
					'link'=> '/inventorymanagement/collections/detail/%%Collection.id%%/',
					'icon' => 'access_to_data'
				)
			),
			'SampleMaster' => array(
				'detail' => array(
					'link' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/1/0',
					'icon' => 'flask'
				),
				'access to all data' => array(
					'link'=> '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/',
					'icon' => 'access_to_data'
				)
			),
			'AliquotMaster' => array(
				'detail' => array(
					'link'=> '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/1/0',
					'icon' => 'aliquot'
				),
				'access to all data' => array(
					'link'=> '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
					'icon' => 'access_to_data'
				)
			)
		),
		'bottom' => array(
			'filter' => $specimen_type_filter_links
		),
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
	
	$structure_override = array();
	$structure_override['Collection.bank_id'] = $bank_list;
	
	// BUILD
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'tree', 'settings'=>$structure_settings, 'links'=>$structure_links, 'extras'=>$structure_extras, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>
