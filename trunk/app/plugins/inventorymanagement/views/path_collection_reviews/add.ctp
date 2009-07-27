<?php 
	$structure_links = array(
		'top'=>'/inventorymanagement/path_collection_reviews/add/'.$atim_menu_variables['Collection.id'].'/',
		'bottom'=>array(
			'cancel'=>'/inventorymanagement/path_collection_reviews/listall/'.$atim_menu_variables['Collection.id'].'/'
		)
	);
	
	$structure_override = array('PathCollectionReview.aliquot_master_id'=>$aliquot_master_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>