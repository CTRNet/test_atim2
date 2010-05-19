<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/protocol/protocol_extends/detail/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		),
		'bottom'=>array('add' => '/protocol/protocol_extends/add/'.$atim_menu_variables['ProtocolMaster.id'])
	);
	
	$structure_override = array('ProtocolExtend.drug_id'=>$drug_list);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('links'=>$structure_links,'override'=>$structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>
