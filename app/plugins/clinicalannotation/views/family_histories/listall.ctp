<?php
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/family_histories/detail/%%Participant.id%%/%%FamilyHistory.id%%'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/family_histories/add/%%Participant.id%%',
			'list'=>'clinicalannotation/family_histories/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>