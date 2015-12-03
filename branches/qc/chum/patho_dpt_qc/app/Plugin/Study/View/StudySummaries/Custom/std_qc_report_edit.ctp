<?php 
	$structure_links = array(
		'top'=>'/Study/StudySummaries/stdQcReportEdit/'.$atim_menu_variables['StudyQualityControlReport.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Study/StudySummaries/stdQcCriteriaDetail/'.$atim_menu_variables['StudySummary.id'].'/'
		)
	);
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'type' => 'edit','settings' => array('header' => __('report', null)));
	$this->Structures->build( $final_atim_structure, $final_options );
?>