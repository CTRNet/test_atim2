<?php
	$structure_links = array(
		'index'=>array(
			'detail'=>'/clinicalannotation/clinical_collection_links/detail/'.$atim_menu_variables['Participant.id'].'/%%ClinicalCollectionLink.id%%/',
			'collection' => array(
				'link' => '/inventorymanagement/collections/detail/%%Collection.id%%/',
				'icon' => 'collection'
			)
		),
		'bottom'=>array(
			'add'=>'/clinicalannotation/clinical_collection_links/add/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure; 
	$final_options = array('type'=>'index','links'=>$structure_links, 'override' => $structure_override);
	
	// CUSTOM CODE
	$hook_link = $structures->hook();
	if( $hook_link ) { require($hook_link); }
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options );
	
?>