<?php 
	$structure_links = array(
		'top'=>'/protocol/protocol_masters/add/'.$atim_menu_variables['ProtocolControl.id'],
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_masters/listall/'
		)
	);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>