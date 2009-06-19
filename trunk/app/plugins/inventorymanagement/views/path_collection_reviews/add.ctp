<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/path_collection_reviews/add/'.$atim_menu_variables['Collection.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/path_collection_reviews/listall/'.$atim_menu_variables['Collection.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>