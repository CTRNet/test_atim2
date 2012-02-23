<?php 

	$structure_links = array(
		'bottom'=>array(
			'edit'=>'/ClinicalAnnotation/TreatmentMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
			'delete'=>'/ClinicalAnnotation/TreatmentMasters/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
			'list'=>'/ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id'].'/',
			'add precision' => '/ClinicalAnnotation/TreatmentExtends/add/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'],
		)
	);
	
	// TRT DATA
	
	$structure_settings = array(
		'actions'=> $is_ajax, 
		
		'header' => __('treatment', null),
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

	if(isset($extend_form_alias)){
		$structure_settings = array(
			'pagination'	=> false,
			'actions'		=> false,
			'header'		=> __('precision')
		);
		
		if(isset($extended_data_import_process)){
			$structure_links['bottom']['import from associated protocol'] = '/ClinicalAnnotation/TreatmentExtends/'.$extended_data_import_process.'/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'];
		}
		
		$structure_links['index'] = array(
				'detail' => '/ClinicalAnnotation/TreatmentExtends/detail/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtend.id%%/'
		);
		
		$final_options = array('data' => $tx_extend_data, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
		$final_atim_structure = $extend_form_alias;
		
		$hook_link = $this->Structures->hook('tx_extend_list');
		if( $hook_link ) {
			require($hook_link);
		}
		
		$this->Structures->build( $final_atim_structure,  $final_options);
	}
	
	if(!$is_ajax){

		// DIAGNOSTICS
		
		$structure_settings = array(
			'form_inputs'=>false,
			'pagination'=>false,
			'actions'=>true,
			'form_bottom'	=> true,
			'header' => __('related diagnosis', null), 
			'form_top' => false
		);
		
		$structure_links['index'] = array(
			'detail' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%'
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