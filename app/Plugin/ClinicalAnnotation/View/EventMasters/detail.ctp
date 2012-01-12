<?php 

	$structure_links = array(
		'index' => array(
			'detail' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'
		),
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/EventMasters/edit/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'], 
			'delete'=>'/ClinicalAnnotation/EventMasters/delete/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['EventMaster.id'], 
			'list'=>'/ClinicalAnnotation/EventMasters/listall/'.$atim_menu_variables['EventMaster.event_group'].'/'.$atim_menu_variables['Participant.id']
		)
	);

	// 1- EVENT DATA
	
	$structure_settings = array(
		'actions'=> $is_ajax, 
		
		'header' => '1- ' . __('data', null),
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
			'form_inputs'=>false,
			'pagination'=>false,
			'actions'=>true,
			'form_bottom'	=> true,
			'header' => '2- ' . __('related diagnosis', null), 
			'form_top' => false
		);
		
		$final_options = array('data' => $diagnosis_data, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
		$final_atim_structure = $diagnosis_structure;
		
		$hook_link = $this->Structures->hook('dx_list');
		if( $hook_link ) { 
			require($hook_link); 
		}
		 
		$this->Structures->build( $final_atim_structure,  $final_options);
	}
?>