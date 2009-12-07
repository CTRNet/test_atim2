<?php 
	$structure_links = array(
		'index'=>array(
			'detail'=>'/inventorymanagement/quality_ctrls/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/%%QualityCtrl.id%%'
		),
		'bottom'=>array(
			'add'=>'/inventorymanagement/quality_ctrls/add/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'		
		),
	);
	
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
	
?>