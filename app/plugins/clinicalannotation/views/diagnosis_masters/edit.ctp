<?php 
$structure_links = array(
	'top'=>'/clinicalannotation/diagnosis_masters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['DiagnosisMaster.id'].'/',
	'bottom'=>array(
		'cancel'=>'/clinicalannotation/diagnosis_masters/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['DiagnosisMaster.id'].'/'
	)
);
	
// 1- DIAGNOSTIC DATA

$structure_settings = array(
	'header' => __('edit diagnosis record', NULL)
);

$final_atim_structure = $atim_structure;
$final_options = array('links' => $structure_links, 'settings' => $structure_settings);

$hook_link = $structures->hook();
if( $hook_link ) { 
	require($hook_link); 
}

$structures->build( $final_atim_structure, $final_options );	
