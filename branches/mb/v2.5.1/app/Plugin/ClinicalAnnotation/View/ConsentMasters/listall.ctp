<?php
	$add_links = array();
	foreach ($consent_controls_list as $consent_control) {
		$add_links[__($consent_control['ConsentControl']['controls_type'])] = '/ClinicalAnnotation/ConsentMasters/add/'.$atim_menu_variables['Participant.id'].'/'.$consent_control['ConsentControl']['id'].'/';
	}
	asort($add_links);
	
	$structure_links = array(
		'top'=>NULL,
		'index'=>'/ClinicalAnnotation/ConsentMasters/detail/'.$atim_menu_variables['Participant.id'].'/%%ConsentMaster.id%%',
		'bottom'=>array(
			'add'=> $add_links
		)
	);
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );	
?>