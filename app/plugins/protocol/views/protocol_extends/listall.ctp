<?php 
	
	$structure_links = array(
		'index'=>array(
			'detail'=>'/protocol/protocol_extends/detail/'.$atim_menu_variables['ProtocolMaster.id'].'/%%ProtocolExtend.id%%/'
		),
		'bottom'=>array('add' => '/protocol/protocol_extends/add/'.$atim_menu_variables['ProtocolMaster.id'])
	);
	
	$structure_override = array('ProtocolExtend.drug_id'=>$drug_id_findall);
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>
