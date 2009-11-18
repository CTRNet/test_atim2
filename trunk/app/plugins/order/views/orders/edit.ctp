<?php 
	$structure_links = array(
		'top'=>'/order/orders/edit/' . $atim_menu_variables['Order.id'],
		'bottom'=>array('cancel'=>'/order/orders/detail/' . $atim_menu_variables['Order.id'])
	);
	
	$structure_override = array();
	
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['Order.study_summary_id'] = $studies_list;	
	
	$structures->build( $atim_structure, array('links'=>$structure_links, 'override'=>$structure_override) );
?>