<?php 
	
	unset($final_options['links']['bottom']['print barcode']);
	unset($structure_links['bottom']['print barcode']);
	
	$aliquot_use_event_link = $structure_links['bottom']['add uses/events'];
	$structure_links['bottom']['add uses/events'] = array();
	$structure_links['bottom']['add uses/events']['use/event'] = $aliquot_use_event_link;
	$structure_links['bottom']['add uses/events']['transfer'] = $aliquot_use_event_link;
	$structure_links['bottom']['add uses/events']['transfer']['link'] .= '/1';
	$final_options['links']['bottom']['add uses/events'] = $structure_links['bottom']['add uses/events'];
	
?>
