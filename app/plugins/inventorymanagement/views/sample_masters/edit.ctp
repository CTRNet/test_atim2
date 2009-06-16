<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/sample_masters/edit/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/ssmple_masters/detail/'.$atim_menu_variables['Collection.id'].'/%%SampleMaster.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>