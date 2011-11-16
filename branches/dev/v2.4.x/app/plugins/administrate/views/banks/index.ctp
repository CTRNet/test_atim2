<?php 
	$structure_links = array(
		'index'=>array('detail'=>'/administrate/banks/detail/%%Bank.id%%'),
		'bottom'=>array(
			'add'=>'/administrate/banks/add'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>