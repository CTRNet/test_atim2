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
	$structures->build( $atim_datetime_input, array('type'=>'add', 'links'=>$structure_links, 'settings' => $structure_settings, 'data' => array()));
?>


