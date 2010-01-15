<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/edit/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'],
		'bottom' => array('cancel' => '/inventorymanagement/sample_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id']
		)
	);
	
	$structure_override = array();
	
	$sops_list = array();
	foreach($arr_aliquot_sops as $sop_masters) { $sops_list[$sop_masters['SopMaster']['id']] = $sop_masters['SopMaster']['code']; }
	$structure_override['AliquotMaster.sop_master_id'] = $sops_list; 	
	
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['AliquotMaster.study_summary_id'] = $studies_list;	

	$blocks_list = array();
	foreach($arr_sample_blocks as $new_block) {
		$blocks_list[$new_block['AliquotMaster']['id']] = $new_block['AliquotMaster']['barcode'];
	}	
	$structure_override['AliquotDetail.block_aliquot_master_id'] = $blocks_list;	

	$gel_matrices_list = array();
	foreach($arr_sample_gel_matrices as $new_matrix) {
		$gel_matrices_list[$new_matrix['AliquotMaster']['id']] = $new_matrix['AliquotMaster']['barcode'];
	}	
	$structure_override['AliquotDetail.gel_matrix_aliquot_master_id'] = $gel_matrices_list;

	$translated_matching_storage_list = array();
	foreach ($arr_preselected_storages as $storage_id => $storage_data) {
		$translated_matching_storage_list[$storage_id] = $storage_data['StorageMaster']['selection_label'] . ' (' . __($storage_data['StorageMaster']['storage_type'], TRUE) . ': ' . $storage_data['StorageMaster']['code'] . ')';
	}
	$structure_override['AliquotMaster.storage_master_id'] = $translated_matching_storage_list;	
			
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>