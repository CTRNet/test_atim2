<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/Announcements/edit/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/',
			'delete'=>'/Administrate/Announcements/delete/'.'/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/',
			'list'=>'/Administrate/Announcements/index/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id']
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>