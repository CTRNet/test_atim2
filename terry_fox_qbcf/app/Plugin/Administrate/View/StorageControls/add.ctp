<?php 

	$structure_links = array(
		'top'=>'/Administrate/StorageControls/add/'.$storage_category.'/0/',
		'bottom'=>array('cancel'=>'/Administrate/StorageControls/listAll/')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>