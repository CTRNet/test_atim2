<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/protocol/protocol_masters/listall/',
			'search'=>'protocol/protocol_masters/index/',
			'edit'=>'/protocol/protocol_masters/edit/%%ProtocolMaster.id%%/',
			'delete'=>'/protocol/protocol_masters/delete/%%ProtocolMaster.id%%/'
		)
	);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>