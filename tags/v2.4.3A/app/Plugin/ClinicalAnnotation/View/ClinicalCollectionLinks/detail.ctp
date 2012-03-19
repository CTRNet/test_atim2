<?php
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
		'extras'	=> $this->Structures->extraAjaxLink('InventoryManagement/Collections/detail/'.$collection_data['id'].'/noActions:/noHeader:/')
	);

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('collection_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 
	

	// ************** 2- CONSENT **************
	$final_options['settings']['header'] = __('consent');
	$final_options['extras'] = $collection_data['consent_master_id'] ? $this->Structures->extraAjaxLink('ClinicalAnnotation/ConsentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['consent_master_id'].'/noActions:/noHeader:/') : $no_data_available;

	// CUSTOM CODE
	$hook_link = $this->Structures->hook('consent_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options ); 


	// ************** 3- DIAGNOSIS **************
	$final_options['settings']['header'] = __('diagnosis');
	$final_options['extras'] = $collection_data['diagnosis_master_id'] ? $this->Structures->extraAjaxLink('ClinicalAnnotation/DiagnosisMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['diagnosis_master_id'].'/noActions:/noHeader:/') : $no_data_available;
	
	$hook_link = $this->Structures->hook('diagnosis_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	 
	$this->Structures->build( $final_atim_structure,  $final_options);


	// ************** 4 - Tx/Event **************
	$final_options['settings']['header'] = __('treatment').' / '.__('annotation'); 
	$final_options['settings']['language_heading'] = __('treatment');
	$final_options['extras'] = $collection_data['treatment_master_id'] ? $this->Structures->extraAjaxLink('ClinicalAnnotation/TreatmentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['treatment_master_id'].'/noActions:/noHeader:/') : $no_data_available;
	
	$hook_link = $this->Structures->hook('treatment_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	$this->Structures->build( $final_atim_structure,  $final_options);


	$final_options['settings']['language_heading'] = __('annotation');
	$final_options['settings']['actions'] = true;
	$final_options['extras'] = $collection_data['event_master_id'] ? $this->Structures->extraAjaxLink('ClinicalAnnotation/EventMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['event_master_id'].'/noActions:/noHeader:/') : $no_data_available;
	unset($final_options['settings']['header']);
	
	$structure_bottom_links = array(
		'edit'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'delete'	=> '/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'list'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/',
		'collection'=> '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id']
	);
	
	if($collection_data['consent_master_id']){
		$structure_bottom_links['consent'] = '/ClinicalAnnotation/ConsentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['consent_master_id'].'/';
	}
	if($collection_data['diagnosis_master_id']){
		$structure_bottom_links['diagnosis'] = '/ClinicalAnnotation/DiagnosisMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['diagnosis_master_id'].'/';
	}
	if($collection_data['treatment_master_id']){
		$structure_bottom_links['treatment'] = '/ClinicalAnnotation/TreatmentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['treatment_master_id'].'/';
	}
	if($collection_data['event_master_id']){
		$structure_bottom_links['event'] = '/ClinicalAnnotation/EventMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['event_master_id'].'/';
	}
	$final_options['links'] = array('bottom' => $structure_bottom_links);
	
	$hook_link = $this->Structures->hook('event_detail');
	if( $hook_link ) { 
		require($hook_link); 
	}
	 
	$this->Structures->build( $final_atim_structure,  $final_options);

