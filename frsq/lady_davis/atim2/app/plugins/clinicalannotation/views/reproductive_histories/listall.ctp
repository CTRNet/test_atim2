<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/reproductive_histories/detail/'.$atim_menu_variables['Participant.id'].'/%%ReproductiveHistory.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/reproductive_histories/add/'.$atim_menu_variables['Participant.id'].'/'
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