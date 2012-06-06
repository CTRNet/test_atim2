<?php 
	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/DiagnosisMasters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'delete'=>'/ClinicalAnnotation/DiagnosisMasters/delete/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
			'list'=>'/ClinicalAnnotation/DiagnosisMasters/listall/%%DiagnosisMaster.participant_id%%/',
			'redefine unknown primary' => '/underdevelopment/'
		)
	);
	if(in_array($this->data['DiagnosisControl']['category'], array('primary', 'secondary'))){
		$structure_links['bottom']['add'] = 'javascript:addPopup('.$this->data['DiagnosisMaster']['id'].', '.$this->data['DiagnosisControl']['id'].');';
	}
	
	if(isset($primary_ctrl_to_redefine_unknown) && !empty($primary_ctrl_to_redefine_unknown)) {
		$redefine_links = array();
		foreach ($primary_ctrl_to_redefine_unknown as $diagnosis_control){
			$redefine_links[__($diagnosis_control['DiagnosisControl']['controls_type'])] = '/ClinicalAnnotation/DiagnosisMasters/edit/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/'.$diagnosis_control['DiagnosisControl']['id'];
		}
		ksort($redefine_links);
		$structure_links['bottom']['redefine unknown primary'] = $redefine_links;	
	} else {
		unset($structure_links['bottom']['redefine unknown primary']);
	}
	
	// Set form structure and option 
	$final_atim_structure = $atim_structure; 
	$final_options = array(
		'links'		=> $structure_links,
		'settings'	=> array('actions' => $is_ajax)
	);
	
	// CUSTOM CODE
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
		
	// BUILD FORM
	$this->Structures->build( $final_atim_structure, $final_options );
	
	if(!$is_ajax){
		$final_atim_structure = array();
		$final_options['settings']['header'] = __('links to collections');
		$final_options['settings']['actions'] = true;
		$final_options['extras'] = $this->Structures->extraAjaxLink('ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/noActions:/filterModel:DiagnosisMaster/filterId:'.$atim_menu_variables['DiagnosisMaster.id']);
		
		$hook_link = $this->Structures->hook('ccl');
		if( $hook_link ) {
			require($hook_link);
		}
		
		$this->Structures->build(array(), $final_options);
		
		require('add_popup.php');
	}