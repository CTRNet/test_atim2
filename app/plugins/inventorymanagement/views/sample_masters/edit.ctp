<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/sample_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'],
		'bottom'=>array(
			'cancel' => '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id']
		)
	);
	
	$structure_override = array();
	
	$structure_override['SampleMaster.sop_master_id'] = $arr_sample_sops;		
	$structure_override['SampleMaster.parent_id'] = (empty($parent_sample_data)? null : array($parent_sample_data['SampleMaster']['id'] => ($parent_sample_data['SampleMaster']['sample_code'] . ' (' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ')')));
			
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>