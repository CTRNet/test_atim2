<?php

$final_atim_structure = $atim_structure;
$final_options = array(
	'links' => array(
		'top' => array('/InventoryManagement/AliquotEvents/add/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id']),
		'bottom'=> array('cancel' => '/InventoryManagement/AliquotMasters/detail/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'])
	)
);

$hook_link = $this->Structures->hook();
if($hook_link){
	require($hook_link);
}

$this->Structures->build($final_atim_structure, $final_options);