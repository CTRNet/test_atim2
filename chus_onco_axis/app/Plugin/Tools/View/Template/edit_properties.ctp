<?php 

	$structure_links = array(
		'top'=>'/Tools/Template/editProperties/'.$atim_menu_variables['Template.id'].'/',
		'bottom'=>array(
			'cancel'=>'/Tools/Template/edit/'.$atim_menu_variables['Template.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links, 'type' => 'edit');
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
?>