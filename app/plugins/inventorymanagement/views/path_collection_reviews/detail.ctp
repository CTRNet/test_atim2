<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/inventorymanagement/path_collection_reviews/listall/'.$atim_menu_variables['Collection.id'].'/',
			'edit'=>'/inventorymanagement/path_collection_reviews/edit/'.$atim_menu_variables['Collection.id'].'/%%PathCollectionReview.id%%/',
			'delete'=>'/inventorymanagement/path_collection_reviews/delete/'.$atim_menu_variables['Collection.id'].'/%%PathCollectionReview.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>