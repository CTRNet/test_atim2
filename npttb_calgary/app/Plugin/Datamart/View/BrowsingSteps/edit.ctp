<?php
$this->Structures->build($atim_structure, array(
	'type' => 'edit', 
	'links' => array(
		'top' => '/Datamart/BrowsingSteps/edit/'.$atim_menu_variables['SavedBrowsingIndex.id'],
		'bottom' => array('cancel' => '/Datamart/BrowsingSteps/listall/', 'reset' => array('link' => '/Datamart/BrowsingSteps/edit/'.$atim_menu_variables['SavedBrowsingIndex.id'], 'icon' => 'redo')))
));