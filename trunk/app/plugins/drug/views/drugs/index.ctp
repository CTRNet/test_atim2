<?php

	$structure_links = array(
		'top'=>array('search'=>'/drug/drugs/search/'.AppController::getNewSearchId()),
		'bottom'=>array(
			'add'=>'/drug/drugs/add/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'search','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );

?>