<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/aliquot_masters/addAliquotUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'] . '/' . $use_defintion,
		'bottom' => array('cancel' => '/inventorymanagement/aliquot_masters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.initial_specimen_sample_id'].'/'.$atim_menu_variables['AliquotMaster.id'].'/'
		)
	);
	
	$structure_override = array();
	
	$structure_override['AliquotMaster.aliquot_volume_unit'] = $aliquot_volume_unit;	
	$structure_override['AliquotUse.use_definition'] = $use_defintion;
	
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['AliquotUse.study_summary_id'] = $studies_list;	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override, 'type' => 'add');
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );			
?>