<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/quality_ctrls/edit/'
			.$atim_menu_variables['QualityCtrl.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/quality_ctrls/detail/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['QualityCtrl.id'].'/',
		)
	);
	

	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>