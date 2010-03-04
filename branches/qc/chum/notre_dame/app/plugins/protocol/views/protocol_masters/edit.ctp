<?php 
	$structure_links = array(
		'top'=>'/protocol/protocol_masters/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_masters/detail/%%ProtocolMaster.id%%/'
		)
	);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>