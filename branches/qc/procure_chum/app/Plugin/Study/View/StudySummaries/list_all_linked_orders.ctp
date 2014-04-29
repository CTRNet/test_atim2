<?php

$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'links' => array(
		'index' => array(
			'detail' => '/Order/Orders/detail/%%Order.id%%')),
	'settings'	=> array('pagination' => true, 'actions' => false),
	'override'=> array()
);

$hook_link = $this->Structures->hook();
if($hook_link){
	require($hook_link);
}

$this->Structures->build($final_atim_structure, $final_options);

?>
