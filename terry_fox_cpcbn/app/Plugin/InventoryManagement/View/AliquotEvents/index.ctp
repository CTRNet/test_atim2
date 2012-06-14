<?php
$base_link = '/InventoryManagement/AliquotEvents/%s/'.$atim_menu_variables['Collection.id'].'/'.$atim_menu_variables['SampleMaster.id'].'/'.$atim_menu_variables['AliquotMaster.id'];

$final_atim_structure = $atim_structure;
$final_options = array(
	'links'	=> array(
		'index' => array(
			'edit' => sprintf($base_link, 'edit').'/%%AliquotEvent.id%%',
			'delete' => sprintf($base_link, 'edit').'/%%AliquotEvent.id%%' 		
		)		
	),
	'settings' => array('pagination' => false, 'actions' => false)
);

$hook_link = $this->Structures->hook();
if($hook_link){
	require($hook_link);
}

$this->Structures->build($final_atim_structure, $final_options);