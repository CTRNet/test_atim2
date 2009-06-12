<?php 
	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[$protocol_control['ProtocolControl']['tumour_group'].' - '.$protocol_control['ProtocolControl']['type']] = '/protocol/protocol_masters/add/';
	}
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/protocol/protocol_masters/detail/%%ProtocolMaster.id%%/'
		),
		'bottom'=>array('add' => $add_links)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>
