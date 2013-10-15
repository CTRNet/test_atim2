<?php 

$this->Structures->build($atim_structure, array(
	'type' => 'add', 
	'links' => array('top' => 'javascript:savePreset();'), 
	'settings' => array(
		'header' => __('save preset'),
		'tabindex' => 100
	)
));
?>