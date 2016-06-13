<?php 
	$structure_links = array(
		'top'=>'/Administrate/Menus/edit/%%Menu.id%%',
		'bottom'=>array(
			'delete'=>'/Administrate/Menus/delete/%%Menu.id%%',
			'cancel'=>'/Administrate/Menus/detail/%%Menu.id%%'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>