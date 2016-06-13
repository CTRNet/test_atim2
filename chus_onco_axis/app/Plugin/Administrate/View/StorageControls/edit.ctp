<?php 
	$structure_links = array(
		'top'=>'/Administrate/StorageControls/edit/'.$atim_menu_variables['StorageCtrl.id'].'/',
		'bottom'=>array('cancel'=>'/Administrate/StorageControls/listAll/')
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>