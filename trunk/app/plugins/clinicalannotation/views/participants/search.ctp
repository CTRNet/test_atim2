<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/participants/profile/%%Participant.id%%'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/participants/add/',
			'search'=>'/clinicalannotation/participants/index/',
			'list'=>'/clinicalannotation/participants/listall/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
