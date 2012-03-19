<?php
$structure_links = array(
	'top'	=> '/InventoryManagement/AliquotMasters/editRealiquoting/'.$realiquoting_id,
	'bottom'=> array('cancel' => '/InventoryManagement/AliquotMasters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'])	
);

$final_atim_structure = $atim_structure; 
$final_options =  array(
	'type'		=> 'edit', 
	'links'		=> $structure_links,
);

// CUSTOM CODE
$hook_link = $this->Structures->hook();
if( $hook_link ) { 
	require($hook_link); 
}
	
// BUILD FORM
$this->Structures->build( $final_atim_structure, $final_options );	
