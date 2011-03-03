<?php 

	$add_links = array();
	
	foreach ($process_data_controls_list as $control) {
		$add_links[__($control['ProcessDataControl']['group'], true) . ' - ' . __($control['ProcessDataControl']['process_type'], true)] = '/processdata/process_data_masters/add/' . $control['ProcessDataControl']['id'];
	}
	ksort($add_links);

	$structure_links = array(
		'top' => array('search' =>'/storagelayout/storage_masters/search/'),
		'bottom' => array('add' => $add_links)
	);

	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'search', 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>