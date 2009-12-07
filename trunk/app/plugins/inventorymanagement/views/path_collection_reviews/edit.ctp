<?php 
	$structure_links = array(
		'top' => '/inventorymanagement/path_collection_reviews/edit/' . $atim_menu_variables['Collection.id'] . '/%%PathCollectionReview.id%%/',
		'bottom'=>array(
			'cancel' => '/inventorymanagement/path_collection_reviews/detail/' . $atim_menu_variables['Collection.id'] . '/%%PathCollectionReview.id%%/'
		)
	);
	
	$structure_override = array('PathCollectionReview.aliquot_master_id'=>$aliquot_master_id_findall);
	
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}
	
	$structures->build($atim_structure, array('links'=>$structure_links,'override'=>$structure_override));
?>