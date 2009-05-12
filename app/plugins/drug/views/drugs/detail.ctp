<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/drug/drugs/edit/',
			'delete'=>'/drug/drugs/delete/',
			'list'=>'/drug/drugs/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>