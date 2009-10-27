<?php
$structure_links = array(
		'bottom'=>array(
			'edit' => '/inventorymanagement/quality_ctrls/edit/'
				.$atim_menu_variables['QualityCtrl.id'].'/',
			'delete' => '/inventorymanagement/quality_ctrls/delete/'
				.$atim_menu_variables['QualityCtrl.id'].'/',
			'list' => '/inventorymanagement/quality_ctrls/listall/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>