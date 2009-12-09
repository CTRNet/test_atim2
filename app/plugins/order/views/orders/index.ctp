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
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'search', 'links'=>$structure_links, 'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>