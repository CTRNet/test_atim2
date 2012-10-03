<?php 
	$structure_links = array(
		'top'=>'/Administrate/Announcements/add/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Administrate/Announcements/index/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'].'/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>
