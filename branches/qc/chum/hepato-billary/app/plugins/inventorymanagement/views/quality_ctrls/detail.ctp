<?php

	// 1- QUALITY CONTROL DATA
		
	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete'=>'/inventorymanagement/quality_ctrls/deleteTestedAliquot/'.$atim_menu_variables['QualityCtrl.id'].'/%%AliquotMaster.id%%/quality_controls_details/'
		),
		'bottom'=>array(
			'list' => '/inventorymanagement/quality_ctrls/listAll/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/',
			'edit' => '/inventorymanagement/quality_ctrls/edit/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['QualityCtrl.id'].'/',
			'delete' => '/inventorymanagement/quality_ctrls/delete/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['QualityCtrl.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('data' => $quality_ctrl_data, 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>