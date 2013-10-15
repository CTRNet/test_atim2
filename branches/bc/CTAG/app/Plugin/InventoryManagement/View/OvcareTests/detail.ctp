<?php

	// 1- OVCARE TEST DATA
		
	$structure_links = array(
		'index'=>array(
			'detail'=>'/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete'=>'/InventoryManagement/OvcareTests/deleteTestedAliquot/'.$atim_menu_variables['OvcareTest.id'].'/%%AliquotMaster.id%%/ovcare_tests_details/'
		),
		'bottom'=>array(
			'list' => '/InventoryManagement/OvcareTests/listAll/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/',
			'used aliquot' => '/InventoryManagement/AliquotMasters/detail/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$ovcare_test_data['OvcareTest']['aliquot_master_id'],
			'edit' => '/InventoryManagement/OvcareTests/edit/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['OvcareTest.id'].'/',
			'delete' => '/InventoryManagement/OvcareTests/delete/'
				.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['OvcareTest.id'].'/'
		)
	);
	if(empty($ovcare_test_data['OvcareTest']['aliquot_master_id'])) unset($structure_links['bottom']['used aliquot']) ;	

	$final_atim_structure = $atim_structure; 
	$final_options = array('data' => $ovcare_test_data, 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>