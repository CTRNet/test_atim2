<?php 
	$structure_links = array(
		'top'=>'/Administrate/menus/edit/%%Menu.id%%',
		'bottom'=>array(
			'delete'=>'/Administrate/menus/delete/%%Menu.id%%',
			'cancel'=>'/Administrate/menus/detail/%%Menu.id%%'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>