<?php 

	unset($structure_links['tree']['DiagnosisMaster']['add']);
	unset($final_options['links']['tree']['DiagnosisMaster']['add']);
	$structure_links['bottom']['add'] = $structure_links['bottom']['add primary'];
	$final_options['links']['bottom']['add'] = $final_options['links']['bottom']['add primary'];
	unset($structure_links['bottom']['add primary']);
	unset($final_options['links']['bottom']['add primary']);
	