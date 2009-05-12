<?php
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/reproductive_histories/detail/%%Participant.id%%/%%ReproductiveHistory.id%%'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/reproductive_histories/add/%%Participant.id%%',
			'list'=>'clinicalannotation/reproductive_histories/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>