<?php 
	$structure_links = array(
		'top'=>'/administrate/banks/edit/%%Bank.id%%',
		'bottom'=>array(
			'delete'=>'/administrate/banks/delete/%%Bank.id%%',
			'cancel'=>'/administrate/banks/detail/%%Bank.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>