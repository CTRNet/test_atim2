<?php 

	$add_links = array();
	foreach ($storage_controls_list as $storage_control) {
		$add_links[$storage_control['StorageControl']['storage_type']] = '/storagelayout/storage_masters/add/' . $storage_control['StorageControl']['id'];
	}

	$structure_links = array(
		'top' => array('search' =>'/storagelayout/storage_masters/search/'),
		'bottom' => array('add' => $add_links)
	);

	$translated_storage_list = array();
	foreach ($storage_list as $storage_id => $storage_data) {
		$translated_storage_list[$storage_id] = $storage_data['StorageMaster']['selection_label'] . ' (' . __($storage_data['StorageMaster']['storage_type'], TRUE) . ': ' . $storage_data['StorageMaster']['code'] . ')';
	}	
	$structure_override = array('StorageMaster.parent_id' => $translated_storage_list);  

	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>