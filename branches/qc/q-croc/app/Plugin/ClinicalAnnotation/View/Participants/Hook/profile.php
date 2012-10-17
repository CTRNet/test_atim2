<?php
	$is_ajax = true;
	$final_options['settings']['actions'] = true;
	unset($final_options['links']['bottom']['add identifier']);
	
	if(isset($add_link_for_qcroc_forms)) {
		$final_options['links']['bottom']['add'] = $add_link_for_qcroc_forms;
		$structure_links['bottom']['add'] = $add_link_for_qcroc_forms;
	}
	