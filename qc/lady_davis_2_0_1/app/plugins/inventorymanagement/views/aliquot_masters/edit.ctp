<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'],
		'bottom' => array('cancel' => '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id']
		)
	);
	
	$structure_override = array();
	
	$structure_override['AliquotMaster.sop_master_id'] = $arr_aliquot_sops_for_display;
	$structure_override['AliquotMaster.study_summary_id'] = $arr_studies_for_display;	
	$structure_override['AliquotMaster.storage_master_id'] = $arr_preselected_storages_for_display;	
				
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>