<?php 
	$structure_links = array(
		'top'=>'/administrate/banks/edit/%%Bank.id%%',
		'bottom'=>array(
			'cancel'=>'/administrate/banks/detail/%%Bank.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>