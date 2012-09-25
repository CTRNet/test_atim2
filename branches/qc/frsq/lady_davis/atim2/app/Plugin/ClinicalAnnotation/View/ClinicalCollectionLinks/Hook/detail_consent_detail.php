<?php 

	$final_options['settings']['form_bottom'] = true;
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_top'] = false;

	$structure_bottom_links = array(
			'edit'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
			'delete'	=> '/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
			'list'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/',
			'details' => array('collection'=> '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id']),
			'copy for new collection'	=> array('link' => '/InventoryManagement/Collections/add/0/'.$atim_menu_variables['Collection.id'], 'icon' => 'copy')
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
	
