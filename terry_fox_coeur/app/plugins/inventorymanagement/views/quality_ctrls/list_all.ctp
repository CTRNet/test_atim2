<?php 
	
	$structure_links = array(
		'index'=>array('detail'=>'/inventorymanagement/quality_ctrls/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/%%QualityCtrl.id%%'),
		'bottom'=>array('add'=>'/inventorymanagement/quality_ctrls/add/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
		
?>