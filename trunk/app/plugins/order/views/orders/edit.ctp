<?php 
	$structure_links = array(
		'top'=>'/order/orders/edit/' . $atim_menu_variables['Order.id'],
		'bottom'=>array('cancel'=>'/order/orders/detail/' . $atim_menu_variables['Order.id'])
	);
	
	$structure_override = array();
	$structure_override['Order.study_summary_id'] = $studies_list;	
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
?>