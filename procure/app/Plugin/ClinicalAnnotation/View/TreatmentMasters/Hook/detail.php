<?php

	if(isset($add_link_for_procure_forms)) {
		$final_options['links']['bottom']['add form'] = $add_link_for_procure_forms;
		$structure_links['bottom']['add form'] = $add_link_for_procure_forms;
	}
	
	if(!isset($extend_form_alias)) {
		$is_ajax = true;
		$final_options['settings']['actions'] = true;
		$final_options['settings']['form_bottom'] = true;
		unset($final_options['links']['bottom']['add precision']);		
	}
