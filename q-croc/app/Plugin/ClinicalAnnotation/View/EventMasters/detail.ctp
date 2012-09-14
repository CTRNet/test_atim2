<?php 

	$structure_links = array(
		'index' => array(
			'detail' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'
		),
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/EventMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'], 
			'delete'=>'/ClinicalAnnotation/EventMasters/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'], 
			'list'=>array('link' => '/ClinicalAnnotation/EventMasters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'], 'icon' => 'list')
		)
	);

	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'=> $is_ajax, 
		'form_bottom'=> !$is_ajax 
	);
		
	$final_atim_structure = $atim_structure;
	$final_options = array('links'=>$structure_links, 'settings'=>$structure_settings);
	
	$hook_link = $this->Structures->hook();
	if( $hook_link ) { 
		require($hook_link); 
	}
	
	$this->Structures->build( $final_atim_structure, $final_options );	
	
	
	if(!$is_ajax){

		// 2- DIAGNOSTICS
		
		$structure_settings = array(
			'form_inputs'	=> false,
			'pagination'	=> false,
			'actions'		=> false,
			'form_bottom'	=> true,
			'header' 		=> __('related diagnosis'), 
			'form_top' 		=> false
		);
		
		$final_options = array('data' => $diagnosis_data, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
		$final_atim_structure = $diagnosis_structure;
		
		if(!AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/listall')){
			$final_options['type'] = 'detail';
			$final_atim_structure = array();
			$final_options['extras'] = '<div>'.__('You are not authorized to access that location.').'</div>';
		}
		
		$display_next_sub_form = true;
		
		$hook_link = $this->Structures->hook('dx_list');
		if( $hook_link ) { 
			require($hook_link); 
		}
		 
		if($display_next_sub_form) $this->Structures->build( $final_atim_structure,  $final_options);
		
		$final_atim_structure = array();
		$final_options['type'] = 'detail';
		$final_options['settings']['header'] = __('links to collections');
		$final_options['settings']['actions'] = true;
		$final_options['extras'] = $this->Structures->ajaxIndex('ClinicalAnnotation/ClinicalCollectionLinks/listall/'.$atim_menu_variables['Participant.id'].'/noActions:/filterModel:EventMaster/filterId:'.$atim_menu_variables['EventMaster.id']);
		
		$display_next_sub_form = true;
		
		$hook_link = $this->Structures->hook('ccl');
		if( $hook_link ) {
			require($hook_link);
		}
		
		if($display_next_sub_form) $this->Structures->build(array(), $final_options);
	}
?>