<?php 
	$structure_links = array(
		'top'=>'/Administrate/banks/edit/%%Bank.id%%',
		'bottom'=>array(
			'cancel'=>'/Administrate/banks/detail/%%Bank.id%%'
		)
	);
	
	$this->Structures->build( $atim_structure, array('links'=>$structure_links) );
?>