<?
	$structure_links = array(
		'top'=>'/clinicalannotation/misc_identifier/edit/%%Participant.id%%/%%MiscIdentifier.id%%/',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/misc_identifier/delete/%%Participant.id%%/%%MiscIdentifier.id%%/',
			'cancel'=>'/clinicalannotation/misc_identifier/detail/%%Participant.id%%/%%MiscIdentifier.id%%'/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>