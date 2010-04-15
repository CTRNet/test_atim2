<?php

	// 1- QUALITY CONTROL DATA
		
	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete'=>'/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%/qualitycontrol/%%QualityCtrl.id%%/'
		),
		'bottom'=>array(
			'edit' => '/inventorymanagement/quality_ctrls/edit/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['QualityCtrl.id'].'/',
			'add tested aliquots'=>'/inventorymanagement/quality_ctrls/addTestedAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/',
			'delete' => '/inventorymanagement/quality_ctrls/delete/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['QualityCtrl.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('settings' => array('actions' => false), 'data' => $quality_ctrl_data);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
	// 2- TESTED ALIQUOTS DATA
		
	$final_atim_structure = $structure_for_tested_aliquots; 
	$final_options = array('type' => 'index', 'data' => $tested_aliquots_data, 'links' => $structure_links, 'settings' => array('header' => __('tested aliquots', null), 'separator' => true));
	
	// CUSTOM CODE
	$hook_link = $structures->hook('tested_aliquots');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>