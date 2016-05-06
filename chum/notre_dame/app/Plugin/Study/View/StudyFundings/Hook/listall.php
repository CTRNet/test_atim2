<?php
	
	$structure_links['index'] = array('delete' => '/Study/StudyFundings/delete/'.$atim_menu_variables['StudySummary.id'].'/%%StudyFunding.id%%');
	unset($structure_links['bottom']);
	$final_options['links'] = $structure_links;
	
?>