<?php 
	if($_SESSION['Auth']['User']['id'] == $atim_menu_variables['User.id']){
		$structure_links = array(
			'bottom'=>array(
				'edit'=>'/Administrate/users/edit/'.$atim_menu_variables['Group.id'].'/%%User.id%%', 
				'list'=>'/Administrate/users/listall/'.$atim_menu_variables['Group.id'])
		);
	}else{
		$structure_links = array(
			'bottom'=>array(
				'edit'=>'/Administrate/users/edit/'.$atim_menu_variables['Group.id'].'/%%User.id%%', 
				'delete'=>'/Administrate/users/delete/'.$atim_menu_variables['Group.id'].'/%%User.id%%', 
				'list'=>'/Administrate/users/listall/'.$atim_menu_variables['Group.id'])
		);
	}
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>