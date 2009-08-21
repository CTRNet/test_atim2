<?php
	
	$structure_links = array(
		'bottom' => array(
			'edit' => '/storagelayout/tma_slides/edit/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id'],
			'list' => '/storagelayout/tma_slides/listAll/' . $atim_menu_variables['StorageMaster.id'],
			'delete' => '/storagelayout/tma_slides/delete/' . $atim_menu_variables['StorageMaster.id'] . '/' . $atim_menu_variables['TmaSlide.id']
		)
	);
	
	$form_override = array();
	
	$structure_override['TmaSlide.sop_master_id'] = $arr_tma_slide_sops;
			
	$structures->build($atim_structure, array('links' => $structure_links, 'override' => $structure_override) );
	
?>