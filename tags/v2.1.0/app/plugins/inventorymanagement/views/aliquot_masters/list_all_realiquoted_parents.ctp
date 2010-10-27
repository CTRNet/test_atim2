<?php
	
	$structure_links = array(
	'index' => array(
		   'detail' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/',
			'delete' => '/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%/realiquoting/%%AliquotMasterChildren.id%%/'
		));
	
	$final_atim_structure = $atim_structure; 
	$final_options =  array('type'=>'index', 'links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
	
?>