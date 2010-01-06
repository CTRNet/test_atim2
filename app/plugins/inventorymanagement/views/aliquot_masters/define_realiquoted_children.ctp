<?php 	
	
	$structure_links = array(
		'top'=>'/inventorymanagement/aliquot_masters/defineRealiquotedChildren/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['AliquotMaster.id'].'/');
	
	$structure_settings = array(
		'form_bottom'=>false, 
		'actions'=>false,
		'pagination'=>false
	);
	
	$final_atim_structure = $atim_structure_aliquot; 
	$final_options =  array('type'=>'datagrid', 'links'=>$structure_links, 'settings' => $structure_settings);
	
	// CUSTOM CODE
	$hook_link = $structures->hook('aliquot');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	

	
	$structure_links = array(
		'top'=>'/inventorymanagement/aliquot_masters/defineRealiquotedChildren/'
			.$atim_menu_variables['Collection.id'].'/'
			.$atim_menu_variables['SampleMaster.id'].'/'
				.$atim_menu_variables['AliquotMaster.id'].'/',
		'bottom'=>array(
			'cancel' => '/inventorymanagement/aliquot_masters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.initial_specimen_sample_id'].'/'.$atim_menu_variables['AliquotMaster.id'].'/'
		),
	);
	$structure_settings = array(
		'form_bottom'=>true, 
	);
	
	$final_atim_structure = $atim_datetime_input; 
	$final_options =  array('type'=>'add', 'links'=>$structure_links, 'settings' => $structure_settings, 'data' => array());
	
	// CUSTOM CODE
	$hook_link = $structures->hook('datetime');
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	


?>


