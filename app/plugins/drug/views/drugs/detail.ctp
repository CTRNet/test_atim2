<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/drug/drugs/listall/',
			'search'=>'drug/drugs/index/',
			'edit'=>'/drug/drugs/edit/%%Drug.id%%/',
			'delete'=>'/drug/drugs/delete/%%Drug.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>