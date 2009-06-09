<?php 
	$structure_links = array(
		'top'=>'/protocol/protocol_masters/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/',
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_masters/detail/%%ProtocolMaster.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>