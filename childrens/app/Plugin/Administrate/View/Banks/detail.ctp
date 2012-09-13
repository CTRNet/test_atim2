<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/banks/edit/%%Bank.id%%', 
			'delete'=>'/Administrate/banks/delete/%%Bank.id%%/',
			'list'=>'/Administrate/banks/index'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>