<?php 

	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/diagnoses/detail/'.$atim_menu_variables['Participant.id'].'/%%Diagnosis.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/diagnoses/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );

?>
