<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/participants/profile/%%Participant.id%%'),
		'bottom'=>array(
			'search'=>'/clinicalannotation/participants/index',
			'add'=>'/clinicalannotation/participants/add'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
