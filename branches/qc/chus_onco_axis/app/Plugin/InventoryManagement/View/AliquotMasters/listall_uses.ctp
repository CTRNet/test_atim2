<?php
$final_atim_structure = $atim_structure;
$final_options = array(
	'type' => 'index',
	'links' => array(
		'index'	=> array('detail' => '%%ViewAliquotUse.detail_url%%')
	),'settings'	=> array(
		'pagination'	=> false,
		'actions'		=> false
	)
);

if($is_from_tree_view)  $final_options['settings']['header'] =  __('aliquot') . ': '. __('uses and events');

$hook_link = $this->Structures->hook();
if($hook_link){
	require($hook_link);
}

$this->Structures->build($final_atim_structure, $final_options);