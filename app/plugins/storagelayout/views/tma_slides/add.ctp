<?php 
	
	$structure_links = array(
		'top' => '/storagelayout/tma_slides/add/' . $atim_menu_variables['StorageMaster.id'],
		'bottom' => array('cancel' => '/storagelayout/tma_slides/listAll/' . $atim_menu_variables['StorageMaster.id'])
	);

	$structure_override = array();
		
	$sops_list = array();
	foreach($arr_tma_slide_sops as $sop_masters) { $sops_list[$sop_masters['SopMaster']['id']] = $sop_masters['SopMaster']['code']; }
	$structure_override['TmaSlide.sop_master_id'] = $sops_list; 
		
	$translated_matching_storage_list = array();
	foreach ($matching_storage_list as $storage_id => $storage_data) {
		$translated_matching_storage_list[$storage_id] = $storage_data['StorageMaster']['selection_label'] . ' (' . __($storage_data['StorageMaster']['storage_type'], TRUE) . ': ' . $storage_data['StorageMaster']['code'] . ')';
	}
	$structure_override['TmaSlide.storage_master_id'] = $translated_matching_storage_list;
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );			
?>