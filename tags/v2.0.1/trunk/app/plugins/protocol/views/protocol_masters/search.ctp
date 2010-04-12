<?php
	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[$protocol_control['ProtocolControl']['tumour_group'].' - '.$protocol_control['ProtocolControl']['type']] = '/protocol/protocol_masters/add/'.$protocol_control['ProtocolControl']['id'].'/';
	}

	$structure_links = array(
		'index'=>array('detail'=>'/protocol/protocol_masters/detail/%%ProtocolMaster.id%%'),
		'bottom'=>array(
			'add'=>$add_links,
			'search'=>'/protocol/protocol_masters/index'
		)
	);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>