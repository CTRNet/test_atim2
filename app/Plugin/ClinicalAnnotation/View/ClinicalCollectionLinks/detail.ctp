<?php

	// ************** 1- COLLECTION **************
	
	$structure_links = array('bottom'=>array());
	
	$structure_settings = array(
		'form_bottom'	=> false, 
		'form_inputs'	=> false,
		'actions'		=> false,
		'pagination'	=> false,
		'header'		=> __('collection')
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure_collection_detail;
	$final_options = array(
		'type'		=> 'index', 
		'data'		=> array($collection_data), 
		'settings'	=> $structure_settings,
		'links'		=> $structure_links, 
		'override'	=> $structure_override
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 
	

	// ************** 2- CONSENT **************

	$structure_links = array('bottom'=>array());
	
	$structure_settings = array(
		'form_bottom'	=>false, 
		'form_inputs'	=>false,
		'actions'		=>false,
		'pagination'	=>false,
		'header' 		=> __('consent')
	);
	
	$structure_override = array();
	
	$final_atim_structure = $atim_structure_consent_detail; 
	$final_options = array(
		'type'		=>'index',
		'data'		=> array($collection_data),
		'settings'	=>$structure_settings,
		'links'		=>$structure_links,
		'override'	=> $structure_override
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('consent_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 


	// ************** 3- DIAGNOSIS **************
	
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'], 
			'delete'=>'/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
			'list'=>'/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/'
		)
	);
		
	$structure_settings = array(
		'form_inputs'	=>false,
		'pagination'	=>false,
		'actions'		=>true,
		'form_bottom'	=> true,
		'header'		=> __('diagnosis', null), 
		'form_top'		=> false
	);
	
	$final_options = array(
		'data' 		=> $diagnosis_data, 
		'type' 		=> 'index', 
		'settings'	=> $structure_settings, 
		'links' 	=> $structure_links
	);
	$final_atim_structure = $atim_structure_diagnosis_detail;
	
	$hook_link = $this->Structures->hook('diagnosis_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	 
	$this->Structures->build( $final_atim_structure,  $final_options);

?>