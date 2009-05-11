<?
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_messages/edit/%%Participant.id%%/%%ParticipantContact.id%%/',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/participant_messages/delete/%%Participant.id%%/%%ParticipantContact.id%%/',
			'cancel'=>'/clinicalannotation/participant_messages/detail/%%Participant.id%%/%%ParticipantContact.id%%'/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>