<?php 
	$structure_links = array(
		'top'=>'/storagelayout/storage_masters/edit/'.$atim_menu_variables['StorageMaster.id'],
		'bottom'=>array(
			'cancel'=>'/storagelayout/storage_masters/detail/%%StorageMaster.id%%'
		)
	);

	$arr_generated_data 
		= array('Generated' => array(
			'coord_x_title' => $coord_x_title,
			'coord_x_type' => $coord_x_type,
			'coord_y_title' => $coord_y_title,
			'coord_y_type' => $coord_y_type));
	
	$structure_override = array();
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

	$modified_available_parent_code_from_id = array();
	foreach($available_parent_code_from_id as $storage_id => $storage_data) {
		$modified_available_parent_code_from_id[$storage_id]
			= $storage_data['selection_label'].
			' ('.__($storage_data['storage_type'], TRUE).': '.
			$storage_data['code'].')';
	}
	
	$structure_override['StorageMaster.parent_id'] 
		= (empty($modified_available_parent_code_from_id)?
			array('0' => ''):
			$modified_available_parent_code_from_id);
			
/*	TODO: TMA related
	if(isset($arr_tma_sop_title_from_id)){
    	$form_override['StorageDetail/sop_master_id'] = $arr_tma_sop_title_from_id;
    }
*/	
	$structures->build( $atim_structure, array('links'=>$structure_links, 'override'=>$structure_override) );
?>