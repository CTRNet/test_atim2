<?php
$structures->build($atim_structure, array(
	'type' => 'index', 
	'data' => array(array('PermissionsPreset' => array('name' => __('readonly', true), 'description' => __('atim_preset_readonly', true), 'link' => 'javascript:applyPreset("readonly");'))),
	'links' => array('index' => array('detail' => '%%PermissionsPreset.link%%')), 
	'settings' => array(
		'header' => __('atim presets', true), 
		'pagination' => false,
		'actions' => false,
		'form_bottom' => false)
	)
);

$structures->build($atim_structure, array(
	'type' => 'index', 
	'data' => $this->data, 
	'links' => array('index' => array('detail' => '%%PermissionsPreset.link%%', 'delete' => '%%PermissionsPreset.delete%%')), 
	'settings' => array(
		'header' => __('saved presets', true), 
		'pagination' => false)
	)
	//TODO: validate the delete link and the save link before using them
);