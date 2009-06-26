<?php 
	$structure_links = array(
		'top'=>'/protocol/protocol_masters/add/'.$atim_menu_variables['ProtocolControl.id'],
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_masters/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>