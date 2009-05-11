<?
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_messages/edit/%%Participant.id%%/%%ParticipantMessage.id%%/',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/participant_messages/delete/%%Participant.id%%/%%ParticipantMessage.id%%/',
			'cancel'=>'/clinicalannotation/participant_messages/detail/%%Participant.id%%/%%ParticipantMessage.id%%'/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>