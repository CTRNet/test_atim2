<?php
	$consent_control_data = isset($collection_data['ConsentControl'])? $collection_data['ConsentControl'] : null;
	$diagnosis_control_data = isset($collection_data['DiagnosisControl'])? $collection_data['DiagnosisControl'] : null;
	$treatment_control_data = isset($collection_data['TreatmentControl'])? $collection_data['TreatmentControl'] : null;
	$event_control_data = isset($collection_data['EventControl'])? $collection_data['EventControl'] : null;
	
	$collection_data = $collection_data['Collection'];
	
	$no_data_available = '<div>'.__('core_no_data_available').'</div>';
	
	// ************** 1- COLLECTION **************
	$structure_settings = array(
		'actions'		=> false,
		'header'		=> __('collection')
	);
	
	$final_atim_structure = $empty_structure;
	$final_options = array(
		'type'		=> 'detail', 
		'data'		=> array(), 
		'settings'	=> $structure_settings,
		'extras'	=> $this->Structures->ajaxIndex('InventoryManagement/Collections/detail/'.$collection_data['id'].'/noActions:/noHeader:/')
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 
	

	// ************** 2- CONSENT **************
	$final_options['settings']['header'] = array('title' => __('consent'), 'description' => null);
	if(!is_null($consent_control_data)) $final_options['settings']['header']['description'] = __($consent_control_data['controls_type']);	
	$final_options['extras'] = $collection_data['consent_master_id'] ? $this->Structures->ajaxIndex('ClinicalAnnotation/ConsentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['consent_master_id'].'/noActions:/noHeader:/') : $no_data_available;

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('consent_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 


	// ************** 3- DIAGNOSIS **************
	$final_options['settings']['header'] = array('title' => __('diagnosis'), 'description' => null);
	if(!is_null($diagnosis_control_data)) $final_options['settings']['header']['description'] = __($diagnosis_control_data['category']). ' - '.__($diagnosis_control_data['controls_type']);	
	$final_options['extras'] = $collection_data['diagnosis_master_id'] ? $this->Structures->ajaxIndex('ClinicalAnnotation/DiagnosisMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['diagnosis_master_id'].'/noActions:/noHeader:/') : $no_data_available;
	
	$hook_link = $this->Structures->hook('diagnosis_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	 
	$this->Structures->build( $final_atim_structure,  $final_options);


	// ************** 4 - Tx **************
	$final_options['settings']['header'] = array('title' => __('treatment'), 'description' => null);
	if(!is_null($treatment_control_data)) $final_options['settings']['header']['description'] = __($treatment_control_data['tx_method']). ' - '.__($treatment_control_data['disease_site']);	
	$final_options['extras'] = $collection_data['treatment_master_id'] ? $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['treatment_master_id'].'/noActions:/noHeader:/') : $no_data_available;
	
	$hook_link = $this->Structures->hook('treatment_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$this->Structures->build( $final_atim_structure,  $final_options);


	// ************** 5 - Event **************
	$final_options['settings']['header'] = array('title' => __('annotation'), 'description' => null);
	if(!is_null($event_control_data)) $final_options['settings']['header']['description'] = __($event_control_data['event_group']). ' - '.__($event_control_data['disease_site']). ' - '.__($event_control_data['event_type']);	
	$final_options['settings']['actions'] = true;
	$final_options['extras'] = $collection_data['event_master_id'] ? $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['event_master_id'].'/noActions:/noHeader:/') : $no_data_available;
	
	$structure_bottom_links = array(
		'edit'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'delete'	=> '/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'list'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/',
		'details' => array('collection'=> '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id']),
		'copy for new collection'	=> array('link' => '/InventoryManagement/collections/add/0/'.$atim_menu_variables['Collection.id'], 'icon' => 'copy')
	);
	
	if($collection_data['consent_master_id']){
		$structure_bottom_links['details']['consent'] = '/ClinicalAnnotation/ConsentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['consent_master_id'].'/';
	}
	if($collection_data['diagnosis_master_id']){
		$structure_bottom_links['details']['diagnosis'] = '/ClinicalAnnotation/DiagnosisMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['diagnosis_master_id'].'/';
	}
	if($collection_data['treatment_master_id']){
		$structure_bottom_links['details']['treatment'] = '/ClinicalAnnotation/TreatmentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['treatment_master_id'].'/';
	}
	if($collection_data['event_master_id']){
		$structure_bottom_links['details']['event'] = '/ClinicalAnnotation/EventMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['event_master_id'].'/';
	}
	$final_options['links'] = array('bottom' => $structure_bottom_links);
	
	$hook_link = $this->Structures->hook('event_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	 
	$this->Structures->build( $final_atim_structure,  $final_options);

