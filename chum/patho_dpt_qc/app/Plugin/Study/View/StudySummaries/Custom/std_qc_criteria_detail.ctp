<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit' => '/Study/StudySummaries/stdQcCriteriaEdit/%%StudySummary.id%%',
			'delete' => '/Study/StudySummaries/stdQcCriteriaEdit/%%StudySummary.id%%/delete',
			'add report' => array('link' => '/Study/StudySummaries/stdQcReportAdd/%%StudySummary.id%%', 'icon' => 'add')
		)
	);
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'links'=>$structure_links, 
		'type' => 'detail', 
		'settings' => array('actions' => false));
	$this->Structures->build( $final_atim_structure, $final_options );
	
	
	$final_atim_structure = array();
	$final_options = array(
		'links' => $structure_links,
		'type' => 'detail',
		'settings' => array('header' => __('reports', null), 'actions' => true),
		'extras' => array('end' => $this->Structures->ajaxIndex('Study/StudySummaries/stdQcReportListall/' . $atim_menu_variables['StudySummary.id'].'/')));
	$this->Structures->build( $final_atim_structure, $final_options );
?>