<?php
	$structure_links = array(
		'top'=>array('search'=>'/order/orders/search/'),
		'bottom'=>array('add'=>'/order/orders/add/')
	);
	
	$structure_override = array();
	
	$studies_list = array();
	foreach($arr_studies as $new_study) {
		$studies_list[$new_study['StudySummary']['id']] = $new_study['StudySummary']['title'];
	}	
	$structure_override['Order.study_summary_id'] = $studies_list;	
	
	$structures->build($atim_structure, array('type'=>'search', 'links'=>$structure_links, 'override'=>$structure_override));
?>