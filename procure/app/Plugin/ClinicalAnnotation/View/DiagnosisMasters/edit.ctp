<?php 
$structure_links = array(
	'top'=>'/ClinicalAnnotation/DiagnosisMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['DiagnosisMaster.id'].'/',
	'bottom'=>array(
		'cancel'=>'/ClinicalAnnotation/DiagnosisMasters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['DiagnosisMaster.id'].'/'
	)
);
	
// 1- DIAGNOSTIC DATA

$structure_settings = array(
	'header' => null
);

$final_atim_structure = $atim_structure;
$final_options = array('links' => $structure_links, 'settings' => $structure_settings);

$hook_link = $this->Structures->hook();
if( $hook_link ) { 
	require($hook_link); 
}

$this->Structures->build( $final_atim_structure, $final_options );	
