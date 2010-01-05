<?php
	$structure_links = array(
	'index' => array(
		   'edit' => '/inventorymanagement/aliquot_masters/editAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMasterParent.id%%/%%AliquotUse.id%%',
			'delete' => '/inventorymanagement/aliquot_masters/deleteAliquotUse/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMasterParent.id%%/%%AliquotUse.id%%/1/'
		));
	$hook_link = $structures->hook();
	if($hook_link){
		require($hook_link); 
	}
	
	$structures->build( $atim_structure, array('type'=>'index', 'links'=>$structure_links) );
	
	$final_atim_structure = ; 
	$final_options = ;
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
?>