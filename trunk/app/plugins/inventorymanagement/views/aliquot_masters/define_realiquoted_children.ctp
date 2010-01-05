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
	
	$hook_link = $structures->hook('aliquot');
	if($hook_link){
		require($hook_link); 
	}
	$structures->build( $atim_structure_aliquot, array('type'=>'datagrid', 'links'=>$structure_links, 'settings' => $structure_settings) );
	
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
	
	$hook_link = $structures->hook('datetime');
	if($hook_link){
		require($hook_link); 
	}
	$structures->build( $atim_datetime_input, array('type'=>'add', 'links'=>$structure_links, 'settings' => $structure_settings, 'data' => array()));

	$final_atim_structure = ; 
	$final_options = ;
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	


?>


