<?
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_contacts/add/%%Participant.id%%',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/participant_contacts/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>