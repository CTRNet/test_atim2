<?php 
	
	$structure_links = array(
		'index' => '/storagelayout/tma_slides/detail/' . $atim_menu_variables['StorageMaster.id'] . '/%%TmaSlide.id%%',
		'bottom' => array('add' => '/storagelayout/tma_slides/add/' . $atim_menu_variables['StorageMaster.id'] . '/')
	);	
	
	$structures->build($atim_structure, array('type' => 'index', 'links' => $structure_links));
	
?>
