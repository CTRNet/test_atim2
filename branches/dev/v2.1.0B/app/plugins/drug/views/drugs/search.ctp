<?php

	$structure_links = array(
		'index'=>array('detail'=>'/drug/drugs/detail/%%Drug.id%%'),
		'bottom'=>array(
			'add'=>'/drug/drugs/add',
			'search'=>'/drug/drugs/index'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>