<?php 
	$primary_can_add = false;
	foreach($diagnosis_controls_list as $dx_ctrl){
		if($dx_ctrl['DiagnosisControl']['category'] != 'primary'){
			$primary_can_add = true;
			break;
		}
	}	
	
	$structure_links = array(
		'tree'=>array(
			'DiagnosisMaster' => array(
				'see diagnosis summary' => array(
					'link' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
					'icon' => 'diagnosis'
				), 'access to all data' => array(
					'link' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
					'icon' => 'access_to_data'
 				), 'add' => AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/add/') && $primary_can_add ? 'javascript:addPopup(%%DiagnosisMaster.id%%);' : 'javascript:addPopup(0)'
			), 'TreatmentMaster' => array(
				'see treatment summary' => array(
					'link' => '/ClinicalAnnotation/TreatmentMasters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/1',
					'icon' => 'treatments'
				), 'access to all data' => array(
					'link' => '/ClinicalAnnotation/TreatmentMasters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/',
					'icon' => 'access_to_data'
 				)
			
			), 'EventMaster' => array(
				'see event summary' => array(
					'link' => '/ClinicalAnnotation/EventMasters/detail/%%EventMaster.participant_id%%/%%EventMaster.id%%/1',
					'icon' => 'annotation'
				), 'access to all data' => array(
					'link' => '/ClinicalAnnotation/EventMasters/detail/%%EventMaster.participant_id%%/%%EventMaster.id%%/',
					'icon' => 'access_to_data'
				)
			)
		),'ajax' => array(
			'index' => array(
				'see diagnosis summary' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				),
				'see treatment summary' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				),
				'see event summary' => array(
					'json' => array(
						'update' => 'frame',
						'callback' => 'set_at_state_in_tree_root'
					)
				)
			)
		),'tree_expand' => array(
			'DiagnosisMaster' => '/ClinicalAnnotation/DiagnosisMasters/listall/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/1',
		)
	);
	
	if(!$is_ajax){
		$add_links = array();
		foreach ($diagnosis_controls_list as $diagnosis_control){
			if($diagnosis_control['DiagnosisControl']['category'] == 'primary'){
				$add_links[__($diagnosis_control['DiagnosisControl']['controls_type'])] = '/ClinicalAnnotation/DiagnosisMasters/add/'.$atim_menu_variables['Participant.id'].'/'.$diagnosis_control['DiagnosisControl']['id'].'/0/';
			}
		}
		ksort($add_links);
		$structure_links['bottom'] = array('add primary' => $add_links);
	}
	
	$structure_extras = array();
	$structure_extras[10] = '<div id="frame"></div>';
	
	// Set form structure and option
	$final_atim_structure = $atim_structure;
	$final_options = array(
		'type' => 'tree',
		'links' => $structure_links,
		'extras' => $structure_extras,
		'settings' => array(
			'tree'=>array(
				'DiagnosisMaster' => 'DiagnosisMaster',
				'TreatmentMaster' => 'TreatmentMaster',
				'EventMaster' => 'EventMaster',
			), 'header' => array('title' => '', 'description' => __('information about the diagnosis module is available %s here', $help_url))
		)
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	if(!$is_ajax){
		require('add_popup.php');  
	}