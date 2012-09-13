<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/Administrate/AdminUsers/detail/'.$atim_menu_variables['Group.id'].'/%%User.id%%'),
		'bottom'=>array('add'=>'/Administrate/AdminUsers/add/'.$atim_menu_variables['Group.id'])
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links, 'type' => 'index') );
?>