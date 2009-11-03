<?php
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/clinical_collection_links/detail/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/clinical_collection_links/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('type'=>'index','links'=>$structure_links) );
?>