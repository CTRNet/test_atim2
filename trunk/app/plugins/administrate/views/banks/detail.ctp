<?php 
	$structure_links = array(
		'bottom'=>array('edit'=>'/administrate/banks/edit/%%Bank.id%%', 'list'=>'/administrate/banks/index')
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>