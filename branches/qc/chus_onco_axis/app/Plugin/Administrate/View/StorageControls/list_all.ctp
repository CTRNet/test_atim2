<?php 
	
	$structure_links = array(
		'index'=>array(
			'edit' => '/Administrate/StorageControls/edit/%%StorageCtrl.id%%/',
			'copy' => '/Administrate/StorageControls/add/0/%%StorageCtrl.id%%/',
			'change active status' => array('link' => '/Administrate/StorageControls/changeActiveStatus/%%StorageCtrl.id%%/', 'icon' => 'confirm'),
			'see layout' => array('link' => '/Administrate/StorageControls/seeStorageLayout/%%StorageCtrl.id%%/', 'icon' => 'grid')
		),
		'bottom'=>array('add' => array(
			'no coordinate' => '/Administrate/StorageControls/add/no_d/0/', 
			'1 coordinate' => '/Administrate/StorageControls/add/1d/0/', 
			'2 coordinates' => '/Administrate/StorageControls/add/2d/0/', 
			'TMA block' => '/Administrate/StorageControls/add/tma/0/')
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type' => 'index', 'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
