<?php
	
	$structure_links = array(
		"top" => '/labbook/lab_book_masters/editSynchOptions/' . $atim_menu_variables['LabBookMaster.id'],
		'bottom' => array('cancel' => '/labbook/lab_book_masters/detail/' . $atim_menu_variables['LabBookMaster.id']));
	
	// DERIVATIVE DETAILS
		
	$structure_override = array();
	$settings =  array(
		'header' => __('derivative', null), 
		'actions' => false, 
		"form_bottom" => false, 
		'pagination'=>false, 
		'name_prefix' => 'derivative');
	
	$final_atim_structure = $lab_book_derivatives_summary; 
	$final_options = array('type'=>'editgrid', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $this->data['derivative'], 'settings' => $settings);
	
	$hook_link = $structures->hook('derivatives');
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $final_atim_structure, $final_options );
	
	// REALIQUOTING
	
	$structure_override = array();
	$settings =  array('header' => __('realiquoting', null), 'pagination'=>false, 'name_prefix' => 'realiquoting');
	
	$final_atim_structure = $lab_book_realiquotings_summary; 
	$final_options = array('type'=>'editgrid', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $this->data['realiquoting'], 'settings' => $settings);
	
	$hook_link = $structures->hook('derivatives');
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $final_atim_structure, $final_options );
	
?>
