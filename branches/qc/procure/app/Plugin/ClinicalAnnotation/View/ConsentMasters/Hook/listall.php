<?php
	if(isset($add_link_for_procure_forms)) {
		foreach($add_link_for_procure_forms as $button_title => $links) {
			$final_options['links']['bottom'][$button_title] = $links;
		}
		unset($final_options['links']['bottom']['add']);
	}