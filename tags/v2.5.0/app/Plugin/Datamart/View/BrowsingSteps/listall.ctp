<?php
$this->Structures->build($atim_structure, array(
	'type' => 'index', 
	'links' => array('index' => array('edit' => '/Datamart/BrowsingSteps/edit/%%SavedBrowsingIndex.id%%', 'delete' => '/Datamart/BrowsingSteps/delete/%%SavedBrowsingIndex.id%%')),
	'settings' => array(
		'pagination' => false)));
