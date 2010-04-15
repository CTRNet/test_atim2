<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/order/orders/detail/%%Order.id%%'),
		'bottom'=>array(
			'add'=>'/order/orders/add',
			'search'=>'/order/orders/index'
		)
	);
	
	$structure_override = array();
	$structure_override['Order.study_summary_id'] = $studies_list;	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>