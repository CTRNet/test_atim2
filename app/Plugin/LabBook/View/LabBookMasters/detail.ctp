<?php
	
	$structure_links = array('bottom' => array(
		'edit' => '/labbook/LabBookMasters/edit/' . $atim_menu_variables['LabBookMaster.id'],
		'delete' => '/labbook/LabBookMasters/delete/' . $atim_menu_variables['LabBookMaster.id'])
	);	
	$structure_override = array();
	$settings = array();
	
	if($full_detail_screen) {
		$settings['actions'] = false;
		$structure_links['bottom'] = array_merge(
			array(
				'edit synchronization option' => '/labbook/LabBookMasters/editSynchOptions/' . $atim_menu_variables['LabBookMaster.id']
			), $structure_links['bottom']
		);
	}
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	$this->Structures->build( $final_atim_structure, $final_options );
	
	if($full_detail_screen) {
		
		// DERIVATIVE DETAILS
		
		$structure_links['index'] = array(
			'sample'=> array(
				'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%',
				'icon' => 'flask')
			);
		$structure_override = array();
		$settings =  array('header' => __('derivative', null), 'actions' => false, 'pagination'=>false);
		
		$final_atim_structure = $lab_book_derivatives_summary; 
		$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $derivatives_list, 'settings' => $settings);
		
		$hook_link = $this->Structures->hook('derivatives');
		if( $hook_link ) { require($hook_link); }
			
		$this->Structures->build( $final_atim_structure, $final_options );
		
		// REALIQUOTING
		
		$structure_links['index'] = array(
			'sample'=> array(
				'link' => '/InventoryManagement/SampleMasters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%',
				'icon' => 'flask'),
			'parent aliquot'=> array(
				'link' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
				'icon' => 'aliquot')
		);
		
		$structure_override = array();
		$settings =  array('header' => __('realiquoting', null), 'pagination'=>false);
		
		$final_atim_structure = $lab_book_realiquotings_summary; 
		$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $realiquotings_list, 'settings' => $settings);
			
		$hook_link = $this->Structures->hook('derivatives');
		if( $hook_link ) { require($hook_link); }
			
		$this->Structures->build( $final_atim_structure, $final_options );		
		
	}	
	
?>