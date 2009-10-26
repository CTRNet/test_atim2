<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/diagnosis_masters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'delete'=>'/clinicalannotation/diagnosis_masters/delete/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'list'=>'/clinicalannotation/diagnosis_masters/listall/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'
		)
	);
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>