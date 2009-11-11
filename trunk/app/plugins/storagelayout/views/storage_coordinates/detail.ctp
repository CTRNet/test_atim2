<?php
	
	$structure_links = array(
		'bottom' => array(
			'list' => '/storagelayout/storage_coordinates/listAll/' . $atim_menu_variables['StorageMaster.id'],
			'delete' => '/storagelayout/storage_coordinates/delete/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['StorageCoordinate.id']
		)
	);
	
	$structures->build($atim_structure, array('links' => $structure_links));
	
?>