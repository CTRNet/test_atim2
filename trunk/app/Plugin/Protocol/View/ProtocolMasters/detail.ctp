<?php 

	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/Protocol/ProtocolMasters/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/',
			'delete'=>'/Protocol/ProtocolMasters/delete/'.$atim_menu_variables['ProtocolMaster.id'].'/'
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