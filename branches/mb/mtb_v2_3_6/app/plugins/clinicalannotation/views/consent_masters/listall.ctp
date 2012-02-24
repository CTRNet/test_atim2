<?php
	$add_links = array();
	foreach ($consent_controls_list as $consent_control) {
		$add_links[__($consent_control['ConsentControl']['controls_type'], true)] = '/clinicalannotation/consent_masters/add/'.$atim_menu_variables['Participant.id'].'/'.$consent_control['ConsentControl']['id'].'/';
	}
	asort($add_links);
	
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/clinicalannotation/consent_masters/detail/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%',
		'bottom'=>array(
			'add'=> $add_links
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );	
?>