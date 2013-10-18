<?php

	$add_links = array();
	foreach ( $protocol_controls as $protocol_control ) {
		$add_links[__($protocol_control['ProtocolControl']['type'])] = '/Protocol/ProtocolMasters/add/'.$protocol_control['ProtocolControl']['id'].'/';
	}
	ksort($add_links);
	$final_options2['links']['bottom']['add'] = $add_links;
