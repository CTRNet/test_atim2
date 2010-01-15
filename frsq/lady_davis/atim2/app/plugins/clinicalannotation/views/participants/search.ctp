<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/participants/profile/%%Participant.id%%'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/participants/add/',
			'search'=>'/clinicalannotation/participants/index/'
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
