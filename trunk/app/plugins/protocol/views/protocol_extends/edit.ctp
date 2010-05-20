<?php 

	$structure_links = array(
		'top'=>'/protocol/protocol_extends/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/',
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_extends/detail/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>