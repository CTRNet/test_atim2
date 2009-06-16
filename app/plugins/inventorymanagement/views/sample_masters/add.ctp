<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/sample_masters/add/'.$atim_menu_variables['Collection.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/sample_masters/listall/'.$atim_menu_variables['Collection.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>