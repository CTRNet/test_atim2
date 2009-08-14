<?php 
	
	$structure_links = array(
		'top' => '/storagelayout/storage_masters/add/' . $atim_menu_variables['StorageControl.id'],
		'bottom' => array('cancel' => '/storagelayout/storage_masters/index/')
	);

	$structure_override = array();
	
	$structure_override['StorageMaster.storage_type'] = $storage_type;
	
	$structure_override['Generated.coord_x_title'] = $coord_x_title;
	$structure_override['Generated.coord_x_type'] = $coord_x_type;
	$structure_override['Generated.coord_x_size'] = (strcmp($coord_x_size, 'n/a')==0)? __($coord_x_size, TRUE): $coord_x_size;
	
	$structure_override['Generated.coord_y_title'] = $coord_y_title;
	$structure_override['Generated.coord_y_type'] = $coord_y_type;
	$structure_override['Generated.coord_y_size'] = (strcmp($coord_y_size, 'n/a')==0)? __($coord_y_size, TRUE): $coord_y_size;	
	
	$translated_available_parent_storage_list = array();
	foreach ($available_parent_storage_list as $storage_id => $storage_data) {
		$translated_available_parent_storage_list[$storage_id] = $storage_data['StorageMaster']['selection_label'] . ' (' . __($storage_data['StorageMaster']['storage_type'], TRUE) . ': ' . $storage_data['StorageMaster']['code'] . ')';
	}
	$structure_override['StorageMaster.parent_id'] = $translated_available_parent_storage_list;
	
/*  TODO: TMA Related
    if(isset($arr_tma_sop_title_from_id)){
    	$form_override['StorageDetail/sop_master_id'] = $arr_tma_sop_title_from_id;
    }
*/
pr($atim_structure);
	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override));

?>