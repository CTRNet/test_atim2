<?
	$structure_links = array(
		'top'=>'/clinicalannotation/reproductive_histories/edit/%%Participant.id%%/%%ReproductiveHistory.id%%/',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/reproductive_histories/delete/%%Participant.id%%/%%ReproductiveHistory.id%%/',
			'cancel'=>'/clinicalannotation/reproductive_histories/detail/%%Participant.id%%/%%ReproductiveHistory.id%%'/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>