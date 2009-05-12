<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/reproductive_histories/edit/%%Participant.id%%/%%ReproductiveHistory.id%%', 
			'list'=>'/clinicalannotation/reproductive_histories/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>