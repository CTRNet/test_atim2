<?php
	$delete_link = '/underdevelopment/';
	if($bool_allow_deletion){
		$delete_link = '/storagelayout/storage_coordinates/delete/'.$atim_menu_variables['StorageCoordinate.id'];
	}	
	
	$structure_links = array(
		'bottom'=>array(
			'list' => '/storagelayout/storage_coordinates/listall/',
			'delete' => $delete_link
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>