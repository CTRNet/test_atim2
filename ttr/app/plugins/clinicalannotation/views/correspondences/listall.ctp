<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/correspondences/detail/'.$atim_menu_variables['Participant.id'].'/%%Correspondence.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/correspondences/add/'.$atim_menu_variables['Participant.id'].'/'
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