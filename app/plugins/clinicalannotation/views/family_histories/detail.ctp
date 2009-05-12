<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/family_histories/edit/%%Participant.id%%/%%FamilyHistory.id%%', 
			'list'=>'/clinicalannotation/family_histories/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>