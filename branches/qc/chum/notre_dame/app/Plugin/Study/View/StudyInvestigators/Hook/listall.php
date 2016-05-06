<?php
	
	$structure_links['index'] = array('delete' => '/Study/StudyInvestigators/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyInvestigator.id%%');
	unset($structure_links['bottom']);
	$final_options['links'] = $structure_links;
	
?>