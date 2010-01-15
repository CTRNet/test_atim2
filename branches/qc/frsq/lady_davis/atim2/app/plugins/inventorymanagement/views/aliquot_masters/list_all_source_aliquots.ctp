<?php 
	$structure_links = array(
		'index'=>array(
			'detail' => '/inventorymanagement/aliquot_masters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			//TODO: reaches the proper function, but the data is not flagged as deleted
			'delete' => '/inventorymanagement/aliquot_masters/deleteAliquotUse/%%SampleMaster.collection_id%%/%%SampleMaster.id%%/%%AliquotMaster.id%%/%%AliquotUse.id%%/2/'
		),
		'bottom'=>array(
			'add'=>'/inventorymanagement/aliquot_masters/addSourceAliquots/'
				.$atim_menu_variables['Collection.id'].'/'
				.$atim_menu_variables['SampleMaster.id'].'/'
		),
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
?>