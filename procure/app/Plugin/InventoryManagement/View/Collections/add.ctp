<?php
	$structure_links = array(
		'top' => '/InventoryManagement/Collections/add/'.$atim_variables['Collection.id'].'/'.$copy_source,
		'bottom' => array('cancel' => 'javascript:history.go(-1)')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'links' => $structure_links
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>