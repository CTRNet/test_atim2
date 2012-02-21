<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/provider/providers/listall/',
			'search'=>'provider/providers/index/',
			'edit'=>'/provider/providers/edit/%%Provider.id%%/',
			'delete'=>'/provider/providers/delete/%%Provider.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>