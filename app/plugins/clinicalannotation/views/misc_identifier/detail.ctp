<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/misc_identifier/edit/%%Participant.id%%/%%MiscIdentifier.id%%', 
			'list'=>'/clinicalannotation/misc_identifier/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>