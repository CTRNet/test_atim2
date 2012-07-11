<?php
	if(isset($add_link_for_procure_forms)) {
		$final_options['links']['bottom']['add form'] = $add_link_for_procure_forms;
		unset($final_options['links']['bottom']['add']);
	}