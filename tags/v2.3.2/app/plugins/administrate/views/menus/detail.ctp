<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/administrate/menus/edit/%%Menu.id%%', 
			'list'=>'/administrate/menus/index'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>