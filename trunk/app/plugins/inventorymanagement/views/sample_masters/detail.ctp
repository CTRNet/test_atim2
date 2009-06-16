<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/inventorymanagement/sample_masters/listall/'.$atim_menu_variables['Collection.id'].'/',
			'edit'=>'/inventorymanagement/sample_masters/edit/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%/',
			'delete'=>'/inventorymanagement/sample_masters/delete/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>