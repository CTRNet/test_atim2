<?php 
	
	$structure_links = array(
		'index' => array(
			'detail' => '/StorageLayout/TmaSlides/detail/' . $atim_menu_variables['StorageMaster.id'] . '/%%TmaSlide.id%%',
			'delete' => '/StorageLayout/TmaSlides/delete/' . $atim_menu_variables['StorageMaster.id'] . '/%%TmaSlide.id%%'),
		'bottom' => array('add' => '/StorageLayout/TmaSlides/add/' . $atim_menu_variables['StorageMaster.id'] . '/')
	);	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );			
?>