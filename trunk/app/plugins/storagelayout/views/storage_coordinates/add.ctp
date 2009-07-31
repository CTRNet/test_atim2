<?php 
	$structure_links = array(
		'top'=>'/storagelayout/storage_coordinates/add/'.$atim_menu_variables['StorageMaster.id'],
		'bottom'=>array(
			'cancel'=>'/storagelayout/storage_coordinates/listall/'.$atim_menu_variables['StorageMaster.id']
		)
	);
	
	$structure_override = array();
	$structure_override['StorageCoordinate.dimension'] = $dimension;
	
	$structures->build($atim_structure, array('links'=>$structure_links, 'override'=>$structure_override));
/*	
	$form_extras .= $html->hiddenTag('StorageCoordinate/dimension', $dimension);
*/	
?>