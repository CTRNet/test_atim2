<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/announcements/edit/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/',
			'delete'=>'/Administrate/announcements/delete/'.'/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/',
			'list'=>'/Administrate/announcements/index/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id']
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>