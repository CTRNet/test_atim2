<?php 

	$structure_links = array(
		'bottom'=>array(
			'list'=>'/protocol/protocol_extends/listall/'.$atim_menu_variables['ProtocolMaster.id'],
			'edit'=>'/protocol/protocol_extends/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/',
			'delete'=>'/protocol/protocol_extends/delete/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
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