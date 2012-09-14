<?php 
	$add_links = array();
	foreach ( $sop_controls as $sop_control ) {
		$add_links[__($sop_control['SopControl']['sop_group'])] = '/Sop/SopMasters/add/'.$sop_control['SopControl']['id'].'/';
	}
	
	
	$final_options['links']['bottom']['add'] = $add_links;
