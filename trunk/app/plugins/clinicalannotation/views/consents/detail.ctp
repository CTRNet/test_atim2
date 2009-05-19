<?php 
	$structure_links = array(
		'bottom'=>array(
			'list'=>'/clinicalannotation/consents/listall/%%Participant.id%%/',
			'edit'=>'/clinicalannotation/consents/edit/%%Participant.id%%/%%Consent.id%%/',
			'delete'=>'/clinicalannotation/consents/delete/%%Participant.id%%/%%Consent.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>