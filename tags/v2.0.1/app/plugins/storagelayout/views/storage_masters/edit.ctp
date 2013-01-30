<?php 

	$structure_links = array(
		'top' => '/storagelayout/storage_masters/edit/' . $atim_menu_variables['StorageMaster.id'],
		'bottom' => array('cancel' => '/storagelayout/storage_masters/detail/' . $atim_menu_variables['StorageMaster.id'])
	);

	$structure_override = array();
	
	$structure_override['Generated.coord_x_title'] = $coord_x_title;
	$structure_override['Generated.coord_x_type'] = $coord_x_type;
	$structure_override['Generated.coord_x_size'] = (strcmp($coord_x_size, 'n/a')==0)? __($coord_x_size, TRUE): $coord_x_size;
	
	$structure_override['Generated.coord_y_title'] = $coord_y_title;
	$structure_override['Generated.coord_y_type'] = $coord_y_type;
	$structure_override['Generated.coord_y_size'] = (strcmp($coord_y_size, 'n/a')==0)? __($coord_y_size, TRUE): $coord_y_size;	
	
	$structure_override['StorageMaster.parent_id'] = $available_parent_storage_list;
	if(isset($arr_tma_sops)){ $structure_override['StorageDetail.sop_master_id'] = $arr_tma_sops; }
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>