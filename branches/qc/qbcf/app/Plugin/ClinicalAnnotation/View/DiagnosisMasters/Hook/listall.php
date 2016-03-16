<?php 
	unset($final_options['settings']['header']);
	unset($final_options['links']['tree']['DiagnosisMaster']['add']);
	if(isset($final_options['links']['bottom']['add primary'])) {
		$final_options['links']['bottom']['add'] = $final_options['links']['bottom']['add primary'];
		unset($final_options['links']['bottom']['add primary']);
	}