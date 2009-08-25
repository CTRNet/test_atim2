<?php 

	$structure_links = array(
		'top' => '/storagelayout/tma_slides/edit/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'],
		'bottom' => array('cancel' => '/storagelayout/tma_slides/detail/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'])
	);

	$structure_override = array();
	
	$structure_override['TmaSlide.sop_master_id'] = $arr_tma_slide_sops;

	$translated_matching_storage_list = array();
	foreach ($matching_storage_list as $storage_id => $storage_data) {
		$translated_matching_storage_list[$storage_id] = $storage_data['StorageMaster']['selection_label'] . ' (' . __($storage_data['StorageMaster']['storage_type'], TRUE) . ': ' . $storage_data['StorageMaster']['code'] . ')';
	}
	$structure_override['TmaSlide.storage_master_id'] = $translated_matching_storage_list;
	
	$structures->build($atim_structure, array('links'=>$structure_links, 'override'=>$structure_override));

?>
