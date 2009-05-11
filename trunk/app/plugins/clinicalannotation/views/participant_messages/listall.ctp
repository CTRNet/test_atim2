<?php
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/participant_messages/detail/%%Participant.id%%/%%ParticipantContact.id%%'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/participant_messages/add/%%Participant.id%%',
			'list'=>'clinicalannotation/participant_messages/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>