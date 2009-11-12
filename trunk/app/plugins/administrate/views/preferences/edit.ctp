<?php 
	$structure_links = array(
		'top'=>'/administrate/preferences/edit/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id'],
		'bottom'=>array(
			'cancel'=>'/administrate/preferences/index/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/'.$atim_menu_variables['User.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>