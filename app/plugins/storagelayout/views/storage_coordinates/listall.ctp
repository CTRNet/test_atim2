<?php 
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/storagelayout/storage_coordinates/detail/'.$atim_menu_variables['StorageMaster.id'].'/%%StorageCoordinate.id%%',
		'bottom'=>array(
			'add'=>'/storagelayout/storage_coordinates/add/'.$atim_menu_variables['StorageMaster.id'].'/'
		)
	);	
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>