<?php 
	$structure_links = array(
		'top'=>'/protocol/protocol_extends/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/',
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_extends/detail/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		)
	);
	
	
	$structure_override = array('ProtocolExtend.drug_id'=>$drug_id_findall);
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>