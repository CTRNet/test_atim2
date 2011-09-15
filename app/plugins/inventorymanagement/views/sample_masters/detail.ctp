<?php

	// Set links and basic sample settings
	$structure_links = array();
	$sample_settings = array();
	
	// If a parent sample is defined then set the 'Show Parent' button
	$show_parent_link = null;
	if(!empty($parent_sample_master_id)) { 
		$show_parent_link = array(
			'link'=>'/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $parent_sample_master_id,
			'icon'=>'sample'); 
	}
	
	// Create array of derivative type that could be created from studied sample for the ADD button
	$add_derivatives = array();
	foreach($allowed_derivative_type as $sample_control) {
		$add_derivatives[__($sample_control['SampleControl']['sample_type'],true)] = '/inventorymanagement/sample_masters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	}
	ksort($add_derivatives);
	
	// Create array of aliquot type that could be created for the studied sample for the ADD button 
	$add_aliquots = array();	
	foreach($allowed_aliquot_type as $aliquot_control) {
		$add_aliquots[__($aliquot_control['AliquotControl']['aliquot_type'],true)] = '/inventorymanagement/aliquot_masters/add/' . $atim_menu_variables['SampleMaster.id'] . '/' . $aliquot_control['AliquotControl']['id'];
	}
	ksort($add_aliquots);
	
	$structure_links['bottom'] = array(
		'edit' => '/inventorymanagement/sample_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
		'add derivative' => $add_derivatives,
		'add aliquot' => $add_aliquots,
		'see parent sample' => ($is_from_tree_view? null : $show_parent_link),
		'see lab book' => null,
		'delete' => '/inventorymanagement/sample_masters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id']
	);
	if(isset($lab_book_master_id)) {
		$structure_links['bottom']['see lab book'] = array(
			'link'=>'/labbook/lab_book_masters/detail/'.$lab_book_master_id,
			'icon'=>'lab_book');
	} else {
		unset($structure_links['bottom']['see lab book']);
	}
	
	// Clean up structure link
	if(empty($structure_links['bottom']['add derivative'])) unset($structure_links['bottom']['add derivative']);
	if(empty($structure_links['bottom']['add aliquot'])) unset($structure_links['bottom']['add aliquot']);
	if(empty($structure_links['bottom']['see parent sample'])) unset($structure_links['bottom']['see parent sample']);
			
	if($is_from_tree_view) {
		// Detail form displayed in tree view
		$sample_settings['header'] = __('sample', null);
		
	} else {
		// General detail form display
		$search_type_links = array();
		$search_type_links['collections'] = array('link'=> '/inventorymanagement/collections/index/', 'icon' => 'search');
		$search_type_links['samples'] = array('link'=> '/inventorymanagement/sample_masters/index/', 'icon' => 'search');
		$search_type_links['aliquots'] = array('link'=> '/inventorymanagement/aliquot_masters/index/', 'icon' => 'search');
	
		$structure_links['bottom']['new search'] = $search_type_links;
	}

	// Set override
	$dropdown_options = array('SampleMaster.parent_id' => (isset($parent_sample_data_for_display) && (!empty($parent_sample_data_for_display)))? $parent_sample_data_for_display: array('' => ''));
	
	// BUILD FORM

	if(!isset($aliquots_data)){
		// DISPLAY ONLY SAMPLE DETAIL FORM
		// 1- SAMPLE DETAIL	
		$final_atim_structure = $atim_structure; 
		$final_options = array(
			'dropdown_options' => $dropdown_options, 
			'links' => $structure_links, 
			'settings' => $sample_settings, 
			'data' => $sample_master_data
		);
		
		// CUSTOM CODE
		$hook_link = $structures->hook();
		if($hook_link){
			require($hook_link); 
		}
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );
		
	}else{ 
		// DISPLAY BOTH SAMPLE DETAIL FORM AND SAMPLE ALIQUOTS LIST
		// 1- SAMPLE DETAIL	
		$sample_settings['actions'] = empty($aliquots_data);
		
		$final_atim_structure = $atim_structure; 
		$final_options = array(
			'dropdown_options' => $dropdown_options, 
			'settings' => $sample_settings, 
			'data' => $sample_master_data
		);
		
		// CUSTOM CODE
		$hook_link = $structures->hook();
		if( $hook_link ) { 
			require($hook_link); 
		}
			
		// BUILD FORM
		$structures->build( $final_atim_structure, $final_options );

		// 2- ALIQUOTS LISTS
		
		$structure_links['index']['detail'] = '/inventorymanagement/aliquot_masters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%';
		$hook_link = $structures->hook('aliquots');
		
		$arr_size = count($aliquots_data);
		$i = 0;
		foreach($aliquots_data as $aliquot_control_id => $aliquots){
			$final_atim_structure = $aliquots_structures[$aliquot_control_id];
			$final_options = array(
				'type'				=> 'index', 
				'links'				=> $structure_links, 
				'dropdown_options'	=> $dropdown_options, 
				'data' 				=> $aliquots, 
				'settings' 			=> array(
					'header'			=> __('aliquots', null) .' > '.__($aliquots[0]['AliquotControl']['aliquot_type'], true),
					'actions'			=> ++ $i == $arr_size,
					'pagination'		=> false
				)
			);
			
			// CUSTOM CODE
			if($hook_link){ 
				require($hook_link); 
			}
				
			// BUILD FORM
			$structures->build( $final_atim_structure, $final_options );
		}
	}
	
?>