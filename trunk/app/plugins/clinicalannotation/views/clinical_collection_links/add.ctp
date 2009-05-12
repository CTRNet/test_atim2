<?
	$structure_links = array(
		'top'=>'/clinicalannotation/clinical_collection_links/add/%%Participant.id%%',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/clinical_collection_links/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>