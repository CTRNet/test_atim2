<?php 
	
	$structure_links = array(
		'index' => array('delete' => '/StorageLayout/StorageCoordinates/delete/' . $atim_menu_variables['StorageMaster.id'] . '/%%StorageCoordinate.id%%'),
		'bottom' => array('add' => '/StorageLayout/StorageCoordinates/add/' . $atim_menu_variables['StorageMaster.id'] . '/')
	);	
	
	if(isset($storage_controls_list)) {
		$add_links = array();
		foreach ($storage_controls_list as $storage_control) {
			$add_links[__($storage_control['StorageControl']['storage_type'])] = '/StorageLayout/StorageMasters/add/' . $storage_control['StorageControl']['id'] . '/' . $atim_menu_variables['StorageMaster.id'];
		}
		ksort($add_links);
		$structure_links['bottom']['add to storage'] = (empty($add_links)? '/underdevelopment/': $add_links);
	}

	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );		
?>