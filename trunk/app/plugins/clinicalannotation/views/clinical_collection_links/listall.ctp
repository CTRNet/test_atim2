<?php
	$structure_links = array(
		'index'=>array('detail'=>'/clinicalannotation/clinical_collection_links/detail/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%/'),
		'bottom'=>array(
			'add'=>'/clinicalannotation/clinical_collection_links/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links);

	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>