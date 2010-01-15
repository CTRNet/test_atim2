<?php

	$add_links = array();
	foreach ($storage_controls_list as $storage_control) {
		$add_links[$storage_control['StorageControl']['storage_type']] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'];
	}
	
	$structure_links = array(
		'index' => array('detail' => '/storagelayout/storage_masters/detail/%%StorageMaster.id%%'),
		'bottom' => array('search' => '/storagelayout/storage_masters/index', 'add' => $add_links)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>