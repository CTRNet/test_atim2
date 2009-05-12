<?php
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/clinical_collection_links/detail/%%Participant.id%%/%%ClinicalCollectionLinks.id%%'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/clinical_collection_links/add/%%Participant.id%%',
			'list'=>'clinicalannotation/clinical_collection_links/listall/%%Participant.id%%'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>