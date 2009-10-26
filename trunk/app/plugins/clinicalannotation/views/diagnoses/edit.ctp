<?php 
	$structure_links = array(
		'top'=>'/clinicalannotation/diagnosis_masters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
		'bottom'=>array(
			'cancel'=>'/clinicalannotation/diagnosis_masters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>
