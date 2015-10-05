<?php
	
	$structure_links = array(
		"top" => '/labbook/LabBookMasters/editSynchOptions/' . $atim_menu_variables['LabBookMaster.id'],
		'bottom' => array('cancel' => '/labbook/LabBookMasters/detail/' . $atim_menu_variables['LabBookMaster.id']));
	
	// DERIVATIVE DETAILS
		
	$structure_override = array();
	$settings =  array(
		'header' => __('derivative', null), 
		'actions' => false, 
		"form_bottom" => false, 
		'pagination'=>false, 
		'name_prefix' => 'derivative');
	
	$final_atim_structure = $lab_book_derivatives_summary; 
	$final_options = array('type'=>'editgrid', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $this->request->data['derivative'], 'settings' => $settings);
	
	$hook_link = $this->Structures->hook('derivatives');
	if( $hook_link ) { require($hook_link); }
	
	$this->Structures->build( $final_atim_structure, $final_options );
	
	// REALIQUOTING
	
	$structure_override = array();
	$settings =  array('header' => __('realiquoting', null), 'pagination'=>false, 'name_prefix' => 'realiquoting');
	
	$final_atim_structure = $lab_book_realiquotings_summary; 
	$final_options = array('type'=>'editgrid', 'links'=>$structure_links, 'override'=>$structure_override, 'data' => $this->request->data['realiquoting'], 'settings' => $settings);
	
	$hook_link = $this->Structures->hook('derivatives');
	if( $hook_link ) { require($hook_link); }
	
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>
