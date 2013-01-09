<?php
	
	$structure_links['bottom']['add collection'] = array('link'=> '/ClinicalAnnotation/ClinicalCollectionLinks/add/'.$atim_menu_variables['Participant.id'], 'icon' => 'collection');
	unset($structure_links['bottom']['add']);
	$final_options['links'] = $structure_links;
	
?>