<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/menus/edit/%%Menu.id%%', 
			'list'=>'/Administrate/menus/index'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>