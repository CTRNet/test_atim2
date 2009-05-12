<?
	$structure_links = array(
		'top'=>'/clinicalannotation/mics_identifier/add/%%Participant.id%%',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/misc_identifier/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>