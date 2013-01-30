<?php 
	$structure_links = array(
		'top'=>'/protocol/protocol_extends/add/'.$atim_menu_variables['ProtocolMaster.id'],
		'bottom'=>array(
			'cancel'=>'/protocol/protocol_extends/listall/'.$atim_menu_variables['ProtocolMaster.id']
		)
	);
	
	$structure_override = array('ProtocolExtend.drug_id'=>$drug_list);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $atim_structure, array('links'=>$structure_links,'override'=>$structure_override) );
?>