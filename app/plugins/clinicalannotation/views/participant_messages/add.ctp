<?
	$structure_links = array(
		'top'=>'/clinicalannotation/participant_messages/add/%%Participant.id%%',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/participant_messages/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>