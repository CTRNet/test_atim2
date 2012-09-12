<?php 
	$structure_links = array(
		'top'=>'/Administrate/preferences/edit/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'],
		'bottom'=>array(
			'cancel'=>'/Administrate/preferences/index/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id']
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>