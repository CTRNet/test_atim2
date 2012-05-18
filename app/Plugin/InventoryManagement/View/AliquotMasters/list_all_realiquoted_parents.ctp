<?php
	
	$structure_links = array(
	'index' => array(
		'parent aliquot detail' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
		'edit link'	=> '/InventoryManagement/AliquotMasters/editRealiquoting/%%Realiquoting.id%%/',
		'delete link' => '/InventoryManagement/AliquotMasters/deleteRealiquotingData/%%AliquotMaster.id%%/%%AliquotMasterChildren.id%%/child/'
	));
	
	if($display_lab_book_url) {
		$structure_links['index']['see lab book'] = array('link' => '/labbook/LabBookMasters/detail/%%Realiquoting.generated_lab_book_master_id%%', 'icon' => 'lab_book');
	}

	$final_atim_structure = $atim_structure; 
	$final_options =  array(
		'type'		=> 'index', 
		'links'		=> $structure_links,
		'settings'	=> array('actions' => false, 'pagination' => false)
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
