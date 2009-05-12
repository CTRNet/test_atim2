<?
	$structure_links = array(
		'top'=>'/clinicalannotation/clinical_collection_links/edit/%%Participant.id%%/%%ClinicalCollectionLink.id%%/',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/clinical_collection_links/delete/%%Participant.id%%/%%ClinicalCollectionLink.id%%/',
			'cancel'=>'/clinicalannotation/clinical_collection_links/detail/%%Participant.id%%/%%ClinicalCollectionLink.id%%'/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>