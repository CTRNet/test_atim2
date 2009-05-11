<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/participant_contacts/edit/%%Participant.id%%/%%ParticipantContact.id%%', 
			'list'=>'/clinicalannotation/participant_contacts/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>