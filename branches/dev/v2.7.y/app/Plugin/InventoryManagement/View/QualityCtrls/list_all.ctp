<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/InventoryManagement/QualityCtrls/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/%%QualityCtrl.id%%',
			'edit'=>'/InventoryManagement/QualityCtrls/edit/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/%%QualityCtrl.id%%',
			'delete'=>'/InventoryManagement/QualityCtrls/delete/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/%%QualityCtrl.id%%'),
		'bottom'=>array('add'=>'/InventoryManagement/QualityCtrls/addInit/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
		
?>