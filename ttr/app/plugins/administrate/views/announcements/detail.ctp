<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/administrate/announcements/edit/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/',
			'delete'=>'/administrate/announcements/delete/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/%%Announcement.id%%/',
			'list'=>'/administrate/announcements/index/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>