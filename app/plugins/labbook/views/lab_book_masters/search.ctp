<?php

	$add_links = array();
	
	foreach ($lab_book_controls_list as $control) {
		$add_links[__($control['LabBookControl']['group'], true) . ' - ' . __($control['LabBookControl']['book_type'], true)] = '/labbook/lab_book_masters/add/' . $control['LabBookControl']['id'];
	}
	ksort($add_links);
	
	$structure_links = array(
		'index' => array('detail' => '/labbook/lab_book_masters/detail/%%LabBookMaster.id%%'),
		'bottom' => array(
			'search' => '/labbook/lab_book_masters/index', 
			'add' => $add_links)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links' => $structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>