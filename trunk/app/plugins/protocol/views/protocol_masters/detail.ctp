<?php 

	$structure_links = array(
		'bottom'=>array(
			'list'=>'/protocol/protocol_masters/search/',
			'search'=>'protocol/protocol_masters/index/',
			'edit'=>'/protocol/protocol_masters/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/',
			'delete'=>'/protocol/protocol_masters/delete/'.$atim_menu_variables['ProtocolMaster.id'].'/'
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