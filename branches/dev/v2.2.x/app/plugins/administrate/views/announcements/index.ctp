<?php
	$structure_links = array(
		'index'=>array('detail'=>'/administrate/announcements/detail/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/'),
		'bottom'=>array(
			'add'=>'/administrate/announcements/add/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>