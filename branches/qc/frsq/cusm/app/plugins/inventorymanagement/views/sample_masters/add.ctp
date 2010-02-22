<?php 
	
	$parent_sample_master_id = (empty($parent_sample_data)? null : $parent_sample_data['SampleMaster']['id']);
	$structure_links = array(
		'top' => '/inventorymanagement/sample_masters/add/'. $atim_menu_variables['Collection.id'] . '/' . $sample_control_data['SampleControl']['id'] . '/' . $parent_sample_master_id,
		'bottom' => array('cancel' => '/inventorymanagement/sample_masters/contentTreeView/'.$atim_menu_variables['Collection.id']
		)
	);
	
	$structure_override = array();
		
	$structure_override['SampleMaster.sample_type'] = $sample_control_data['SampleControl']['sample_type'];	
	$structure_override['SampleMaster.sample_category'] = $sample_control_data['SampleControl']['sample_category'];		

	$sops_list = array();
	foreach($arr_sample_sops as $sop_masters) { $sops_list[$sop_masters['SopMaster']['id']] = $sop_masters['SopMaster']['code']; }
	$structure_override['SampleMaster.sop_master_id'] = $sops_list; 	
		
	$structure_override['SampleMaster.parent_id'] = (empty($parent_sample_data)? null : array($parent_sample_data['SampleMaster']['id'] => ($parent_sample_data['SampleMaster']['sample_code'] . ' (' . __($parent_sample_data['SampleMaster']['sample_type'], TRUE) . ')')));

	if(isset($arr_tissue_sources)) { $structure_override['SampleDetail.tissue_source'] = $arr_tissue_sources; }
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );		
?>