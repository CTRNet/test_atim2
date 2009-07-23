<?php 
	
	$structure_links = array(
		'top'=>'/storagelayout/storage_masters/add/'.$atim_menu_variables['SampleControl.id'],
		'bottom'=>array(
			'cancel'=>'/storagelayout/storage_masters/index/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
/*	
	$form_type = 'add';
	$form_model = isset($this->params['data']) ? 
		array($this->params['data']) : 
		array(array(
			'StorageMaster'=> array(
				'storage_type' => $storage_type),
			'Generated'=> array(
				'coord_x_title' => $coord_x_title,
				'coord_x_type' => $coord_x_type,
				'coord_y_title' => $coord_y_title,
				'coord_y_type' => $coord_y_type))); //Fields added to be displayed
	
	$form_field = $ctrapp_form;
	
	$form_link = array( 
		'add'=>'/storagelayout/storage_masters/add/', 
		'cancel'=>'/storagelayout/storage_masters/index/'); 
	$form_lang = $lang;

	$form_override = array();
	
	$modified_storage_infrastructures = array();
	foreach($storage_infrastructures as $storage_id => $storage_data) {
		$modified_storage_infrastructures[$storage_id]
			= $storage_data['selection_label'].
			' ('.$translations->t($storage_data['storage_type'], $lang, false).': '.
			$storage_data['code'].')';
	}
	
	$form_override['StorageMaster/parent_id'] 
		= (empty($modified_storage_infrastructures)?
			array('0' => ''):
			$modified_storage_infrastructures);
			
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

	$form_extras = $html->hiddenTag('StorageMaster/storage_control_id', $storage_control_id);
	*/
?>