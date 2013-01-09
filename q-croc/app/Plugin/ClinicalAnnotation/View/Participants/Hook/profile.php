<?php
	$is_ajax = true;
	$final_options['settings']['actions'] = true;
	unset($final_options['links']['bottom']['add identifier']);
	
	$final_options['links']['bottom']['add collection'] = array('link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'], 'icon' => 'collection');
	$structure_links['bottom']['add collection'] = array('link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'], 'icon' => 'collection');
