<?php 
	$structure_links = array(
		'top'=>'/Study/StudySummaries/stdQcReportAdd/'.$atim_menu_variables['StudySummary.id'].'/',
		'bottom'=>array(
			'cancel' => '/Study/StudySummaries/stdQcCriteriaDetail/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	
	// Set form structure and option
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'type' => 'add','settings' => array('header' => __('report', null)));
	
	$this->Structures->build( $final_atim_structure, $final_options );
?>

	
	

	

	