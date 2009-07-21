<?php
	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[$protocol_control['ProtocolControl']['tumour_group'].' - '.$protocol_control['ProtocolControl']['type']] = '/protocol/protocol_masters/add/'.$protocol_control['ProtocolControl']['id'].'/';
	}

	$structure_links = array(
		'top'=>array('search'=>'/protocol/protocol_masters/search/'),
		'bottom'=>array(
			'add'=>$add_links
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );
?>