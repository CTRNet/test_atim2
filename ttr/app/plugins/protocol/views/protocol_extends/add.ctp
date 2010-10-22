<?php 

	$structure_links = array(
		'top'=>'/protocol/protocol_extends/add/'.$atim_menu_variables['ProtocolMaster.id'],
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_extends/listall/'.$atim_menu_variables['ProtocolMaster.id']
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