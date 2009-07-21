<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/administrate/banks/index',
			'edit'=>'/administrate/banks/edit/%%Bank.id%%', 
			'delete'=>'/administrate/banks/delete/%%Bank.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>