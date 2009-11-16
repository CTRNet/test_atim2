<?php 

	//	Manage action button
	$action_links = array();
	$action_links['add internal use'] = '/inventorymanagement/aliquot_masters/addAliquotUse/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'] . '/internal use';
	$action_links['define realiquoted children'] = '/inventorymanagement/aliquot_masters/defineRealiquotedChildren/' . $atim_menu_variables['Collection.id'] . '/' . $atim_menu_variables['SampleMaster.id'] . '/' . $atim_menu_variables['AliquotMaster.id'];
	
	$structure_links = array(
		'index' => array(
		   'edit' => '/inventorymanagement/aliquot_masters/editAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%',
			'delete' => '/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%'
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