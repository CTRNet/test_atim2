<?php

$structures->build($atim_structure, array(
	'type'		=> 'add', 
	'links' 	=> array('top' => '/inventorymanagement/aliquot_masters/batchAdd/'),
	'settings'	=> array('header' => __('select a type of aliquots', true))));