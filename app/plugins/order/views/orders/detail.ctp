<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/order/orders/edit/%%Order.id%%/',
			'delete'=>'/order/orders/delete/%%Order.id%%/',
			'search'=>'/order/orders/index'
		)
	);
	
	$structure_override = array();
	
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['Order.study_summary_id'] = $studies_list;	
	
	$structures->build( $atim_structure, array('links'=>$structure_links, 'override'=>$structure_override) );
?>