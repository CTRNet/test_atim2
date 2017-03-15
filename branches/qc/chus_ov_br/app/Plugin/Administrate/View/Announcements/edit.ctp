<?php 
	$structure_links = array(
		'top'=>'/Administrate/Announcements/edit/%%Announcement.id%%/',
		'bottom'=>array(
			'cancel'=>'/Administrate/Announcements/detail/%%Announcement.id%%/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>
