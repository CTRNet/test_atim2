<?php 
	
	$parent_sample_master_id = (empty($parent_sample_data)? null : $parent_sample_data['SampleMaster']['id']);
	$structure_links = array(
		'top' => '/inventorymanagement/sample_masters/add/'. $atim_menu_variables['Collection.id'] . '/' . $sample_control_data['SampleControl']['id'] . '/' . $parent_sample_master_id,
		'bottom' => array('cancel' => '/underdevelopment/'
		)
	);
	
	$structure_override = array();
		
	$structure_override['SampleMaster.sample_type'] = $sample_control_data['SampleControl']['sample_type'];	
	$structure_override['SampleMaster.sample_category'] = $sample_control_data['SampleControl']['sample_category'];		
	$structure_override['SampleMaster.sop_master_id'] = $arr_sample_sops;	
	$structure_override['SampleMaster.parent_id'] = (empty($parent_sample_data)? null : array($parent_sample_data['SampleMaster']['id'] => ($parent_sample_data['SampleMaster']['sample_code'] . ' (' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ')')));
pr('problem in SampleMaster.parent_id disply');		
	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override));
	
?>