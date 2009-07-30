<?php 
	
	$structure_links = array(
		'top'=>'/storagelayout/storage_masters/add/'.$atim_menu_variables['StorageControl.id'],
		'bottom'=>array(
			'cancel'=>'/storagelayout/storage_masters/index/'
		)
	);

	$structure_override = array();
	
	$modified_storage_infrastructures = array();
	foreach($storage_infrastructures as $storage_id => $storage_data) {
		$modified_storage_infrastructures[$storage_id]
			= $storage_data['selection_label'].
			' ('.__($storage_data['storage_type'], TRUE).': '.
			$storage_data['code'].')';
	}
	$structure_override['StorageMaster.parent_id'] 
		= (empty($modified_storage_infrastructures)?
			array('0' => ''):
			$modified_storage_infrastructures);
	
	$structure_override['StorageMaster.storage_type'] = $storage_type;
	$structure_override['StorageMaster.coord_x_title'] = __($coord_x_title, TRUE);
	$structure_override['StorageMaster.coord_x_type'] = __($coord_x_type, TRUE);
	$structure_override['StorageMaster.coord_y_title'] = __($coord_y_title, TRUE);
	$structure_override['StorageMaster.coord_y_type'] = __($coord_y_type, TRUE);

	$structure_override['StorageMaster.coord_x_size'] 
		= (strcmp($coord_x_size, 'n/a')==0)? 
			__($coord_x_size, TRUE):
			$coord_x_size;
	$structure_override['StorageMaster.coord_y_size'] 
		= (strcmp($coord_y_size, 'n/a')==0)? 
			__($coord_y_size, TRUE):
			$coord_y_size;	

/*  TODO: TMA Related
    if(isset($arr_tma_sop_title_from_id)){
    	$form_override['StorageDetail/sop_master_id'] = $arr_tma_sop_title_from_id;
    }
*/
	$structures->build( $atim_structure, array('links'=>$structure_links, 'override'=>$structure_override) );
?>