<?php 
	$structure_links = array(
		'bottom'=>array(
			'search'=>'/Drug/Drugs/search/',
			'edit'=>'/Drug/Drugs/edit/'.$atim_menu_variables['Drug.id'].'/',
			'delete'=>'/Drug/Drugs/delete/'.$atim_menu_variables['Drug.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
?>