<?php
$this->Structures->build($atim_structure, array(
	'settings' => array('pagination' => false), 
	'links' => array(
		'index' => array(
			'edit' => '/Tools/Template/edit/%%Template.id%%'
			
		), 'bottom' => array(
			'add' 		=> '/Tools/Template/add/'
		)
	)
));