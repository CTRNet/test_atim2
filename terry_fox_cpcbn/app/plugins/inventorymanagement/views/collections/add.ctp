<?php 
	
	$structure_links = array(
		'top' => '/inventorymanagement/collections/add/'.$atim_variables['ClinicalCollectionLink.id'].'/'.$copy_source,
		'bottom' => array('cancel' => '/inventorymanagement/collections/search')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'links' => $structure_links
	);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>