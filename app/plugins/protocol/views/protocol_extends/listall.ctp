<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/protocol/protocol_extends/detail/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		),
		'bottom'=>array('add' => '/protocol/protocol_extends/add/'.$atim_menu_variables['ProtocolMaster.id'])
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>
