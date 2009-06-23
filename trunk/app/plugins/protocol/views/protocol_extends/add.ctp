<?php 
	$structure_links = array(
		'top'=>'/protocol/protocol_extends/add/'.$atim_menu_variables['ProtocolMaster.id'],
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_extends/listall/'.$atim_menu_variables['ProtocolMaster.id']
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>