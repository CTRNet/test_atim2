<?php 
	$structure_links = array(
		'top'=>'/Administrate/announcements/edit/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/',
		'bottom'=>array(
			'cancel'=>'/Administrate/announcements/detail/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>
