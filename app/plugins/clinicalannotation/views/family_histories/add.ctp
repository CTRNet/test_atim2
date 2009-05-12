<?
	$structure_links = array(
		'top'=>'/clinicalannotation/family_histories/add/%%Participant.id%%',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/family_histories/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>