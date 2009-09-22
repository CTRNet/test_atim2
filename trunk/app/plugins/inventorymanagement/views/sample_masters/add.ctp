<?php 

	$structure_links = array(
		'top' => '/inventorymanagement/sample_masters/add/'. $atim_menu_variables['Collection.id'] . '/',
		'bottom' => array('cancel' => '/inventorymanagement/sample_masters/listall/' . $atim_menu_variables['Collection.id'] . '/'
		)
	);
	
	$structure_override = array();
	
	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override));
	
?>