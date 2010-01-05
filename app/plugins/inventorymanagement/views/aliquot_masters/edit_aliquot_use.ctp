<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/editAliquotUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'] . '/' . $atim_menu_variables['AliquotUse.id'],
		'bottom' => array('cancel' => '/inventorymanagement/aliquot_masters/detail/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id']
		)
	);
	
	$structure_override = array();
	
	$structure_override['AliquotMaster.aliquot_volume_unit'] = $aliquot_volume_unit;
		
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['AliquotUse.study_summary_id'] = $studies_list;	
	
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}
	
	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override, 'type' => 'edit'));
	
	$final_atim_structure = ; 
	$final_options = ;
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
?>