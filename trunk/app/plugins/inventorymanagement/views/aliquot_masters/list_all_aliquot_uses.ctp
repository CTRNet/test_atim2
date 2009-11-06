<?php 

	//	Manage action button
	$action_links = array();
	$action_links['add internal use'] = '/inventorymanagement/aliquot_masters/addAliquotUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'] . '/internal_use';
	$action_links['define realiquoted child'] = '/underdevelopment/';
	
	$structure_links = array(
		'index' => array(
			//'detail' => '/underdevelopment/'
			//'edit'
			//'delete'
		),
		'bottom' => array(
			'actions' =>  $action_links
		)
	);

	$structure_override = array();
	
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['AliquotUse.study_summary_id'] = $studies_list;
	
	$structures->build($atim_structure, array('type' => 'index', 'links' => $structure_links, 'override' => $structure_override));	

?>