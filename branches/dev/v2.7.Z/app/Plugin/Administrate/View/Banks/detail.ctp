<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Administrate/Banks/edit/%%Bank.id%%', 
			'delete'=>'/Administrate/Banks/delete/%%Bank.id%%/'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>