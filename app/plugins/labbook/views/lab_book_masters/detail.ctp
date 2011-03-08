<?php
	
	$structure_links = array('bottom' => array(
		'edit' => '/labbook/lab_book_masters/edit/' . $atim_menu_variables['LabBookMaster.id'],
		'delete' => '/labbook/lab_book_masters/delete/' . $atim_menu_variables['LabBookMaster.id'])
	);	
	$structure_override = array();
	$settings = $full_detail_screen? array('actions' => false): array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'settings' => $settings);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	$structures->build( $final_atim_structure, $final_options );
	
	if($full_detail_screen) {
		
		// DERIVATIVE DETAILS
		
		$structure_links['index'] = array(
//			'parent sample'=> array(
//				'link' => '/inventorymanagement/sample_masters/detail/%%GeneratedParentSample.collection_id%%/%%GeneratedParentSample.id%%',
//				'icon' => 'flask'),
			'sample'=> array(
				'link' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%',
				'icon' => 'flask')
			);
		$structure_override = array();
		$settings =  array('header' => __('derivative', null), 'actions' => false, 'pagination'=>false);
		
		$final_atim_structure = $lab_book_derivatives_summary; 
		$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $derivatives_list, 'settings' => $settings);
		
		$hook_link = $structures->hook('derivatives');
		if( $hook_link ) { require($hook_link); }
			
		$structures->build( $final_atim_structure, $final_options );
		
		// REALIQUOTING
		
		$structure_links['index'] = array(
			'sample'=> array(
				'link' => '/inventorymanagement/sample_masters/detail/%%SampleMaster.collection_id%%/%%SampleMaster.id%%',
				'icon' => 'flask'),
			'parent aliquot'=> array(
				'link' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
				'icon' => 'aliquot')
		);
		
		$structure_override = array();
		$settings =  array('header' => __('realiquoting', null), 'pagination'=>false);
		
		$final_atim_structure = $lab_book_realiquotings_summary; 
		$final_options = array('type'=>'index', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $realiquotings_list, 'settings' => $settings);
			
		$hook_link = $structures->hook('derivatives');
		if( $hook_link ) { require($hook_link); }
			
		$structures->build( $final_atim_structure, $final_options );		
		
	}	
	
?>