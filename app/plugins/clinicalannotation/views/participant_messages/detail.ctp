<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/participant_messages/edit/%%Participant.id%%/%%ParticipantContact.id%%', 
			'list'=>'/clinicalannotation/participant_messages/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>