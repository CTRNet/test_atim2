<?php 
	
	$structure_links = array(
		'top'=>'/Administrate/StorageControls/add/'.$storage_category.'/0/',
		'bottom'=>array('cancel'=>'/Administrate/StorageControls/listAll/')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'settings' => array('header' => __('storage layout description', null).' : '.__(str_replace(array('no_d','tma','2d','1d'), array('no coordinate','1 coordinate','2 coordinates','tma block'), $storage_category))),
		'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>