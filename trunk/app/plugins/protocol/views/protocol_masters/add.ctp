<?php 
	$structure_links = array(
		'top'=>'/protocol/protocol_masters/add/',
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_masters/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>