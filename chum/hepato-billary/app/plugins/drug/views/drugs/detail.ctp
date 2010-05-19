<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/drug/drugs/index/',
			'edit'=>'/drug/drugs/edit/'.$atim_menu_variables['Drug.id'].'/',
			'delete'=>'/drug/drugs/delete/'.$atim_menu_variables['Drug.id'].'/'
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