<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/administrate/users/edit/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/%%User.id%%', 'delete'=>'/administrate/users/delete/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'].'/%%User.id%%', 'list'=>'/administrate/users/listall/'.$atim_menu_variables['Bank.id'].'/'.$atim_menu_variables['Group.id'])
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>