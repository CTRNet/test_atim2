<?php

	// Set links and basic sample settings
	$structure_links = array();
	$sample_settings = array();
	
	// If a parent sample is defined then set the 'Show Parent' button
	$show_parent_link = null;
	if(!empty($parent_sample_master_id)) { 
		$show_parent_link = array(
			'link'=>'/InventoryManagement/SampleMasters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $parent_sample_master_id,
			'icon'=>'sample'); 
	}
	
	// Create array of derivative type that could be created from studied sample for the ADD button
	$add_derivatives = array();
	foreach($allowed_derivative_type as $sample_control) {
		$add_derivatives[__($sample_control['SampleControl']['sample_type'])] = '/InventoryManagement/SampleMasters/add/' . $atim_menu_variables['Collection.id'] . '/' . $sample_control['SampleControl']['id'] . '/' . $atim_menu_variables['SampleMaster.id'];
	}
	ksort($add_derivatives);
	
	// Create array of aliquot type that could be created for the studied sample for the ADD button 
	$add_aliquots = array();	
	foreach($allowed_aliquot_type as $aliquot_control) {
		$add_aliquots[__($aliquot_control['AliquotControl']['aliquot_type'])] = '/InventoryManagement/AliquotMasters/add/' . $atim_menu_variables['SampleMaster.id'] . '/' . $aliquot_control['AliquotControl']['id'];
	}
	ksort($add_aliquots);
	
	$structure_links['bottom'] = array(
		'edit' => '/InventoryManagement/SampleMasters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'], 
		'delete' => '/InventoryManagement/SampleMasters/delete/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'],
		'print barcodes' => array('link' => '/InventoryManagement/AliquotMasters/printBarcodes/model:SampleMaster/id:'.$atim_menu_variables['SampleMaster.id'], 'icon' => 'barcode'),
		'add derivative' => $add_derivatives,
		'add aliquot' => $add_aliquots,
		'see parent sample' => ($is_from_tree_view? null : $show_parent_link),
		'see lab book' => null
	);
	
	if(isset($lab_book_master_id)) {
		$structure_links['bottom']['see lab book'] = array(
			'link'=>'/labbook/LabBookMasters/detail/'.$lab_book_master_id,
			'icon'=>'lab_book');
	} else {
		unset($structure_links['bottom']['see lab book']);
	}
	
	// Clean up structure link
	foreach(array('add derivative', 'add aliquot', 'see parent sample') as $field){
		if(empty($structure_links['bottom'][$field])){
			unset($structure_links['bottom'][$field]);
		}
	}
			
	if($is_from_tree_view) {
		// Detail form displayed in tree view
		$sample_settings['header'] = __('sample', null);
	}

	// Set override
	$dropdown_options = array('SampleMaster.parent_id' => (isset($parent_sample_data_for_display) && (!empty($parent_sample_data_for_display)))? $parent_sample_data_for_display: array('' => ''));
	
	// ** 1 - SAMPLE DETAIL **
	
	$sample_settings['actions'] = $is_from_tree_view? true : false;
	
	$final_atim_structure = $atim_structure;
	$final_options = array(
		'dropdown_options' => $dropdown_options,
		'links' => $structure_links,
		'settings' => $sample_settings,
		'data' => $sample_master_data
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) {
		require($hook_link);
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	if(!$is_from_tree_view) {
		
		// ** 2 - ALIQUOTS LISTS **
		
		$hook_link = $this->Structures->hook('aliquots');
		
		if(!empty($aliquots_data)) {
			$structure_links['index'] = array(
				'detail' => '/InventoryManagement/AliquotMasters/detail/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%',
				'delete' => '/InventoryManagement/AliquotMasters/delete/%%Collection.id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%');
			
			$counter = 0;
			$nb_of_aliquots = sizeof($aliquots_data);
			foreach($aliquots_data as $aliquot_control_id => $aliquots){
				$counter++;
				$final_atim_structure = $aliquots_structures[$aliquot_control_id];
				$final_options = array(
					'type'				=> 'index', 
					'links'				=> $structure_links, 
					'dropdown_options'	=> $dropdown_options, 
					'data' 				=> $aliquots, 
					'settings' 			=> array(
						'language_heading'	=> __($aliquots[0]['AliquotControl']['aliquot_type']),
						'header'			=> ($counter == 1)? __('aliquots', null) : array(),
						'actions'			=> (empty($parent_sample_master_id) && ($counter == $nb_of_aliquots))? true : false,
						'pagination'		=> false,
						'batchset'			=> array('link' => '/InventoryManagement/SampleMasters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'], 'var' => 'aliquots_data', 'ctrl' => $aliquot_control_id)
					)
				);
				$is_first = false;
				
				// CUSTOM CODE
				if($hook_link){
					require($hook_link); 
				}
					
				// BUILD FORM
				$this->Structures->build( $final_atim_structure, $final_options );
			}
		
		} else {
			$final_atim_structure = $aliquot_masters_structure;
			$final_options = array(
				'type' => 'index', 
				'data' => array(),
				'links'=> $structure_links,
				'settings' => array(
					'header' => __('aliquots'),
					'pagination'	=> false, 
					'actions' => empty($parent_sample_master_id)? true : false
				)
			);
			
			if($hook_link) require($hook_link);
				
			// BUILD FORM
			$this->Structures->build( $final_atim_structure, $final_options );
		}

		// ** 3 - SOURCE ALIQUOTS **
						
		if(!empty($parent_sample_master_id)) {
			$final_atim_structure = $aliquot_source_struct;
			
			$structure_links['index'] = array(
				'source aliquot detail' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
				'edit link'	=> '/InventoryManagement/AliquotMasters/editSourceAliquot/%%SourceAliquot.sample_master_id%%/%%SourceAliquot.aliquot_master_id%%/',
				'delete link' => '/InventoryManagement/AliquotMasters/deleteSourceAliquot/%%SourceAliquot.sample_master_id%%/%%SourceAliquot.aliquot_master_id%%/'
			);
			
			$structure_links['bottom']['add source aliquots'] = '/InventoryManagement/AliquotMasters/addSourceAliquots/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/';
		
			$final_options = array(
				'type'		=> 'index',
				'links'		=> $structure_links, 
				'data'		=> $aliquot_source,
				'settings'	=> array(
					'header'		=> __('listall source aliquots'),
					'pagination'	=> false
				)
			);
			
			// CUSTOM CODE
			$hook_link = $this->Structures->hook('aliquot_source');
			if( $hook_link ) require($hook_link);
			
			// BUILD FORM
			$this->Structures->build( $final_atim_structure, $final_options );
		}
	}
	
	
?>