<?php 
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options ); 
	

	// ************** 2.2- #FRSQ **************

	$structure_links = array('bottom'=>array());
	
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false,
		'header' => __('#FRSQ', true)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure_miscidentifier_detail; 
	$final_options = array('type'=>'index', 'data'=>$miscidentifier_data, 'settings'=>$structure_settings, 'links'=>$structure_links, 'override' => $structure_override);
	
?>