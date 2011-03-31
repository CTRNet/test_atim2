<?php
	
	$structure_links = array(
	'index' => array(
		'detail' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
		'delete' => '/inventorymanagement/aliquot_masters/deleteRealiquotingData/%%AliquotMaster.id%%/%%AliquotMasterChildren.id%%/child/'
	));
	
	if($display_lab_book_url) {
		$structure_links['index']['see lab book'] = array('link' => '/labbook/lab_book_masters/detail/%%Realiquoting.generated_lab_book_master_id%%', 'icon' => 'lab_book');
	}

	$final_atim_structure = $atim_structure; 
	$final_options =  array('type'=>'index', 'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>