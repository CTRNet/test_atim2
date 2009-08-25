<?php 
	
	$structure_links = array(
		'top' => '/storagelayout/storage_coordinates/add/' . $atim_menu_variables['StorageMaster.id'],
		'bottom' => array('cancel' => '/storagelayout/storage_coordinates/listall/' . $atim_menu_variables['StorageMaster.id'])
	);
	
	$structures->build($atim_structure, array('links' => $structure_links));
	
?>