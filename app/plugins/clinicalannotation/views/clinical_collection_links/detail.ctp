<?
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/clinical_collection_links/edit/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%', 
			'list'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structures->build( $atim_structure, array('links'=>$structure_links) );
?>