<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/administrate/users/detail/'.$atim_menu_variables['Group.id'].'/%%User.id%%'),
		'bottom'=>array('add'=>'/administrate/users/add/'.$atim_menu_variables['Group.id'])
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>