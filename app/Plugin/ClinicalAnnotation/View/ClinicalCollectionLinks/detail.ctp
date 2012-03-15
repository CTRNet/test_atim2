<?php
	$collection_data = array($collection_data);

	// ************** 1- COLLECTION **************
	$structure_settings = array(
		'actions'		=> false,
		'pagination'	=> false,
		'header'		=> __('collection')
	);
	
	$final_atim_structure = $atim_structure_collection_detail;
	$final_options = array(
		'type'		=> 'index', 
		'data'		=> $collection_data, 
		'settings'	=> $structure_settings,
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 
	

	// ************** 2- CONSENT **************
	$structure_settings['header'] = __('consent');
	
	$final_atim_structure = $atim_structure_consent_detail; 
	$final_options = array(
		'type'		=>'index',
		'data'		=> $collection_data,
		'settings'	=>$structure_settings,
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('consent_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 


	// ************** 3- DIAGNOSIS **************
	$structure_settings['header'] = __('diagnosis'); 
	
	$final_options = array(
		'data' 		=> $diagnosis_data, 
		'type' 		=> 'index', 
		'settings'	=> $structure_settings, 
	);
	$final_atim_structure = $atim_structure_diagnosis_detail;
	
	$hook_link = $this->Structures->hook('diagnosis_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	 
	$this->Structures->build( $final_atim_structure,  $final_options);


	// ************** 4 - Tx/Event **************
	$structure_settings['header'] = __('treatment').' / '.__('annotation'); 
	$structure_settings['language_heading'] = __('treatment');
	$structure_settings['stretch'] = true;
 	$final_options = array(
		'data' 		=> isset($collection_data[0]['TreatmentMaster']['TreatmentMaster']['id']) ? array($collection_data[0]['TreatmentMaster']) : array(), 
		'type' 		=> 'index', 
		'settings'	=> $structure_settings, 
	);
	$final_atim_structure = $atim_structure_tx;
	
	$hook_link = $this->Structures->hook('treatment_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$this->Structures->build( $final_atim_structure,  $final_options);


	$structure_settings['language_heading'] = __('annotation');
	$structure_settings['actions'] = true;
	unset($structure_settings['header']);
	
	$structure_bottom_links = array(
		'edit'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'delete'	=> '/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'list'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/',
		'collection'=> '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id']
	);
	
	$collection = $collection_data[0]['Collection'];
	if($collection['consent_master_id']){
		$structure_bottom_links['consent'] = '/ClinicalAnnotation/ConsentMasters/detail/'.$collection['participant_id'].'/'.$collection['consent_master_id'].'/';
	}
	if($collection['diagnosis_master_id']){
		$structure_bottom_links['diagnosis'] = '/ClinicalAnnotation/DiagnosisMasters/detail/'.$collection['participant_id'].'/'.$collection['diagnosis_master_id'].'/';
	}
	if($collection['treatment_master_id']){
		$structure_bottom_links['treatment'] = '/ClinicalAnnotation/TreatmentMasters/detail/'.$collection['participant_id'].'/'.$collection['treatment_master_id'].'/';
	}
	if($collection['event_master_id']){
		$structure_bottom_links['event'] = '/ClinicalAnnotation/EventMasters/detail/'.$collection_data[0]['EventMaster']['EventControl']['event_group'].'/'.$collection['participant_id'].'/'.$collection['event_master_id'].'/';
	}
	$final_options = array(
		'data' 		=> isset($collection_data[0]['EventMaster']['EventMaster']['id']) ? array($collection_data[0]['EventMaster']) : array(),
		'type' 		=> 'index', 
		'settings'	=> $structure_settings, 
		'links' 	=> array('bottom' => $structure_bottom_links)
	);
	$final_atim_structure = $atim_structure_event;
	
	$hook_link = $this->Structures->hook('event_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	 
	$this->Structures->build( $final_atim_structure,  $final_options);

