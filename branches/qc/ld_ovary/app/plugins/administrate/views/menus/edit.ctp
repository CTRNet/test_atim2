<?php 
	$structure_links = array(
		'top'=>'/administrate/menus/edit/%%Menu.id%%',
		'bottom'=>array(
			'delete'=>'/administrate/menus/delete/%%Menu.id%%',
			'cancel'=>'/administrate/menus/detail/%%Menu.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>