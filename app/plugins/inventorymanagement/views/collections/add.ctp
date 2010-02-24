<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/collections/add',
		'bottom' => array('cancel' => '/inventorymanagement/collections/index')
	);
	
	$structure_override = array();
	
	$structure_override['Collection.bank_id'] = $bank_list;
	$structure_override['Collection.sop_master_id'] = $sop_list; 
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links' => $structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>