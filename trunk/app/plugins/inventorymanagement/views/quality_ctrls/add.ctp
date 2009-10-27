<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/quality_ctrls/add/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/quality_ctrls/listall/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/',
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>