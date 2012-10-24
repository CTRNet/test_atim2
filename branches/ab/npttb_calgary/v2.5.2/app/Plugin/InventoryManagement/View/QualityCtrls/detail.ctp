<?php

	// 1- QUALITY CONTROL DATA
		
	$structure_links = array(
		'index'=>array(
			'detail'=>'/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete'=>'/InventoryManagement/QualityCtrls/deleteTestedAliquot/'.$atim_menu_variables['QualityCtrl.id'].'/%%AliquotMaster.id%%/quality_controls_details/'
		),
		'bottom'=>array(
			'list' => '/InventoryManagement/QualityCtrls/listAll/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/',
			'used aliquot' => '/InventoryManagement/AliquotMasters/detail/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$quality_ctrl_data['QualityCtrl']['aliquot_master_id'],
			'edit' => '/InventoryManagement/QualityCtrls/edit/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['QualityCtrl.id'].'/',
			'delete' => '/InventoryManagement/QualityCtrls/delete/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['QualityCtrl.id'].'/'
		)
	);
	if(empty($quality_ctrl_data['QualityCtrl']['aliquot_master_id'])) unset($structure_links['bottom']['used aliquot']) ;	

	$final_atim_structure = $atim_structure; 
	$final_options = array('data' => $quality_ctrl_data, 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>