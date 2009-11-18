<?php 
	$structure_links = array(
		'top'=>'/order/orders/add/',
		'bottom'=>array('cancel'=>'/order/orders/index/')
	);
	
	$structure_override = array();
	
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['Order.study_summary_id'] = $studies_list;	
	
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>