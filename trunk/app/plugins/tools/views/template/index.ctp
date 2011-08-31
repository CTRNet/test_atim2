<?php
$structures->build($atim_structure, array(
	'settings' => array('pagination' => false), 
	'links' => array(
		'index' => '/tools/Template/edit/%%Template.id%%',
		'bottom' => array(
			'add' => '/tools/Template/edit/0/'
		)
	)
));