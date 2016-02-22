<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/Menus/edit/%%Menu.id%%', 
			'list'=>'/Administrate/Menus/index'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>