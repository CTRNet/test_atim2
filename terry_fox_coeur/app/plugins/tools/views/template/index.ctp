<?php
$structures->build($atim_structure, array(
	'settings' => array('pagination' => false), 
	'links' => array(
		'index' => array(
			'edit' => '/tools/Template/edit/%%Template.id%%',
			'delete' => '/tools/Template/delete/%%Template.id%%'
			
		), 'bottom' => array(
			'add' 		=> '/tools/Template/edit/0/'
		)
	)
));