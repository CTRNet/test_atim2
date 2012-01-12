<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail' => '/InventoryManagement/AliquotMasters/detail/%%AliquotMaster.collection_id%%/%%AliquotMaster.sample_master_id%%/%%AliquotMaster.id%%',
			'delete' => '/InventoryManagement/AliquotMasters/deleteSourceAliquot/%%SourceAliquot.sample_master_id%%/%%SourceAliquot.aliquot_master_id%%/sample_derivative/'
		),
		'bottom'=>array('add'=>'/InventoryManagement/AliquotMasters/addSourceAliquots/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/')
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'settings' => array('pagination' => false));
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
	
?>