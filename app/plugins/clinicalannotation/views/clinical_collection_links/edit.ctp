<?
	$structure_links = array(
		'top'=>'/clinicalannotation/clinical_collection_links/edit/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%/',
		'bottom'=>array(
			'delete'=>'/clinicalannotation/clinical_collection_links/delete/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%/',
			'cancel'=>'/clinicalannotation/clinical_collection_links/detail/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%'/
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>