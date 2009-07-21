<?php
	$structure_links = array(
		'top'=>array('search'=>'/protocol/protocol_masters/search/'),
		'bottom'=>array(
			'add'=>'/protocol/protocol_masters/add/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'search','links'=>$structure_links) );
?>