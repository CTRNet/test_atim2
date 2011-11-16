<?php 

$structures->build($atim_structure, array(
	'type' => 'add', 
	'links' => array('top' => 'javascript:savePreset();'), 
	'settings' => array(
		'header' => __('save preset', true),
		'tabindex' => 100
	)
));
?>