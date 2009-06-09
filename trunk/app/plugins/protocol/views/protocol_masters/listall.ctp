<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/protocol/protocol_masters/detail/%%ProtocolMaster.id%%/'),
		'bottom'=>array(
			'add'=>'/protocol/protocol_masters/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>