<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/protocol/protocol_extends/listall/'.$atim_menu_variables['ProtocolMaster.id'],
			'edit'=>'/protocol/protocol_extends/edit/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/',
			'delete'=>'/protocol/protocol_extends/delete/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		)
	);
	
	$structure_override = array('ProtocolExtend.drug_id'=>$drug_list);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>