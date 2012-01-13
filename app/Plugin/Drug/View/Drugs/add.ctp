<?php 
	$structure_links = array(
		'top'=>'/Drug/Drugs/add/',
		'bottom'=>array(
			'cancel'=>'/Drug/Drugs/search/'
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