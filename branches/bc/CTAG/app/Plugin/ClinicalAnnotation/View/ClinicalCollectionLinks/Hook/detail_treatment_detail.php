<?php 
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	$final_options['links']['bottom'] = array(
		'edit'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'delete collection link'	=> '/ClinicalAnnotation/ClinicalCollectionLinks/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['Collection.id'],
		'list'		=> '/ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/',
		'details' => array('collection'=> '/InventoryManagement/Collections/detail/'.$atim_menu_variables['Collection.id']),
		'copy for new collection'	=> array('link' => '/InventoryManagement/collections/add/0/'.$atim_menu_variables['Collection.id'], 'icon' => 'copy')
	);
	if(!is_null($treatment_control_data)) $final_options['settings']['header']['description'] = __($treatment_control_data['tx_method']);
	if($collection_data['treatment_master_id']){
		$final_options['links']['bottom']['details']['treatment'] = '/ClinicalAnnotation/TreatmentMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['treatment_master_id'].'/';
	}
	if($collection_data['diagnosis_master_id']){
		$structure_bottom_links['details']['diagnosis'] = '/ClinicalAnnotation/DiagnosisMasters/detail/'.$collection_data['participant_id'].'/'.$collection_data['diagnosis_master_id'].'/';
	}
	