<?php
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/inventorymanagement/path_collection_reviews/detail/'.$atim_menu_variables['Collection.id'].'/%%PathCollectionReview.id%%',
		'bottom'=>array(
			'add'=>'/inventorymanagement/path_collection_reviews/add/'.$atim_menu_variables['Collection.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>