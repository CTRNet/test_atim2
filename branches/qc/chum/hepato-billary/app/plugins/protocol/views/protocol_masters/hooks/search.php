<?php

	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[__($protocol_control['ProtocolControl']['type'],true)] = '/protocol/protocol_masters/add/'.$protocol_control['ProtocolControl']['id'].'/';
	}
	$final_options2['links']['bottom']['add'] = $add_links;

?>