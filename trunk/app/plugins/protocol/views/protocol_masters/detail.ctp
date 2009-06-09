<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/protocol/protocol_masters/listall/',
			'edit'=>'/protocol/protocol_masters/edit/%%ProtocolMaster.id%%/',
			'delete'=>'/protocol/protocol_masters/delete/%%ProtocolMaster.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>