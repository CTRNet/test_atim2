<?php 
	$structure_links = array(
		'top'=>'/administrate/announcements/edit/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/',
		'bottom'=>array(
			'cancel'=>'/administrate/announcements/detail/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
