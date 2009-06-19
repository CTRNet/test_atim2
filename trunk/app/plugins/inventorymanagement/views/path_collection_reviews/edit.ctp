<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/path_collection_reviews/edit/'.$atim_menu_variables['Collection.id'].'/%%PathCollectionReview.id%%/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/path_collection_reviews/detail/'.$atim_menu_variables['Collection.id'].'/%%PathCollectionReview.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>