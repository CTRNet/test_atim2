<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/protocol/protocol_extends/detail/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		),
		'bottom'=>array('add' => '/protocol/protocol_extends/add/'.$atim_menu_variables['ProtocolMaster.id'])
	);
	
	$structure_override = array('ProtocolExtend.drug_id'=>$drug_list);
	
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>
