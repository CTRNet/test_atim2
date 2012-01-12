<?php 

	$structure_links = array(
		'bottom'=>array(
			'list'=>'/ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id'].'/',
			'edit'=>'/ClinicalAnnotation/TreatmentMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
			'delete'=>'/ClinicalAnnotation/TreatmentMasters/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id']
		),
		'index' => array(
			'detail' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'
		)
	);
	
	// 1- TRT DATA
	
	$structure_settings = array(
		'actions'=> $is_ajax, 
		
		'header' => '1- ' . __('data', null),
		'form_bottom'=> !$is_ajax 
	);
	
	$structure_override = array();
	
	$final_options = array('links'=>$structure_links,'settings'=>$structure_settings,'override'=>$structure_override);
	$final_atim_structure = $atim_structure; 
	
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