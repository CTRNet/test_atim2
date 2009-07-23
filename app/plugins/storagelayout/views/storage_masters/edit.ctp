<?php 
	$structure_links = array(
		'top'=>'/storagelayout/storage_masters/edit/'.$atim_menu_variables['StorageMaster.id'],
		'bottom'=>array(
			'cancel'=>'/storagelayout/storage_masters/detail/%%StorageMaster.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
/*
	$form_type = 'edit';
	
	$arr_generated_data 
		= array('Generated' => array(
			'coord_x_title' => $coord_x_title,
			'coord_x_type' => $coord_x_type,
			'coord_y_title' => $coord_y_title,
			'coord_y_type' => $coord_y_type));
			
	$form_model = isset($this->params['data']) ? 
		array($this->params['data']) : 
		array(array_merge($data, $arr_generated_data));	
	
	$form_field = $ctrapp_form;
	
	$form_link = array(
		'edit' => '/storagelayout/storage_masters/edit/', 
		'cancel' => '/storagelayout/storage_masters/detail/');
	$form_lang = $lang;

	$form_override = array();
	$form_override['Generated/coord_x_size'] 
		= (strcmp($coord_x_size, 'n/a')==0)? 
			$translations->t($coord_x_size, $lang, false):
			$coord_x_size;
	$form_override['Generated/coord_y_size'] 
		= (strcmp($coord_y_size, 'n/a')==0)? 
			$translations->t($coord_y_size, $lang, false):
			$coord_y_size;
	
    if(isset($arr_tma_sop_title_from_id)){
    	$form_override['StorageDetail/sop_master_id'] = $arr_tma_sop_title_from_id;
    }
			
	$modified_available_parent_code_from_id = array();
	foreach($available_parent_code_from_id as $storage_id => $storage_data) {
		$modified_available_parent_code_from_id[$storage_id]
			= $storage_data['selection_label'].
			' ('.$translations->t($storage_data['storage_type'], $lang, false).': '.
			$storage_data['code'].')';
	}
	
	$form_override['StorageMaster/parent_id'] 
		= (empty($modified_available_parent_code_from_id)?
			array('0' => ''):
			$modified_available_parent_code_from_id);
	
*/
?>