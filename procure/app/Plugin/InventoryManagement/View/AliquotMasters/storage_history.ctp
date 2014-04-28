<?php
$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'settings'	=> array(
		'pagination'	=> false,
		'actions'		=> false
	)
);

$hook_link = $this->Structures->hook();
if($hook_link){
	require($hook_link);
}

$this->Structures->build($atim_structure, $final_options);