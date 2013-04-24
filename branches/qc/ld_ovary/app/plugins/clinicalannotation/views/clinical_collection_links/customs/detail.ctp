<?php

	// ************** 1- COLLECTION **************
	
	$structure_links = array('bottom'=>array());
	
	$structure_settings = array(
		'form_bottom'=>false, 
		'form_inputs'=>false,
		'actions'=>false,
		'pagination'=>false,
		'header' => __('collection', true)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure_collection_detail; 
	$final_options = array('type'=>'index', 'data'=>$collection_data, 'settings'=>$structure_settings, 'links'=>$structure_links, 'override' => $structure_override);

	// CUSTOM CODE
	$hook_link = $structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options ); 
	

	// ************** 2- CONSENT **************

	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/clinicalannotation/clinical_collection_links/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ClinicalCollectionLink.id'], 
			'delete'=>'/clinicalannotation/clinical_collection_links/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['ClinicalCollectionLink.id'],
			'list'=>'/clinicalannotation/clinical_collection_links/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
	
	$structure_settings = array(
		'form_bottom'=>true, 
		'form_inputs'=>false,
		'actions'=>true,
		'pagination'=>false,
		'header' => __('consent', true)
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure_consent_detail; 
	$final_options = array('type'=>'index', 'data'=>$consent_data, 'settings'=>$structure_settings, 'links'=>$structure_links, 'override' => $structure_override);

	// CUSTOM CODE
	$hook_link = $structures->hook('consent_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$structures->build( $final_atim_structure, $final_options ); 

?>