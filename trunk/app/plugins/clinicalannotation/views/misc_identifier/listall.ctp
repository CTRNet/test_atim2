<?php
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/misc_identifier/detail/%%Participant.id%%/%%MiscIdentifier.id%%'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/misc_identifier/add/%%Participant.id%%',
			'list'=>'clinicalannotation/misc_identifier/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>