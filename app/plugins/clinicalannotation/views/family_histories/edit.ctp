<?
	$structure_links = array(
		'top'=>'/clinicalannotation/family_histories/edit/%%Participant.id%%/%%FamilyHistory.id%%/',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/family_histories/delete/%%Participant.id%%/%%FamilyHistory.id%%/',
			'cancel'=>'/clinicalannotation/family_histories/detail/%%Participant.id%%/%%FamilyHistory.id%%'/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>