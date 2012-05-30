<?php 
	$structure_links = array(
		'top'=>'/drug/drugs/edit/'.$atim_menu_variables['Drug.id'].'/',
		'bottom'=>array(
			'cancel'=>'/drug/drugs/detail/'.$atim_menu_variables['Drug.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>