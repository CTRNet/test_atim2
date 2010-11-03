<?php

	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/clinical_collection_links/edit/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%', 
			'delete'=>'/clinicalannotation/clinical_collection_links/delete/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%',
			'list'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $atim_structure, $final_options );
	
?>