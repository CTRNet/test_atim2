<?php 
	$structure_links = array(
		'top'=>'/administrate/banks/add/',
		'bottom'=>array(
			'cancel'=>'/administrate/banks/index/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
