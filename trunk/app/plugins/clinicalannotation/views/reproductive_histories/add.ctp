<?
	$structure_links = array(
		'top'=>'/clinicalannotation/reproductive_histories/add/%%Participant.id%%',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/reproductive_histories/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>