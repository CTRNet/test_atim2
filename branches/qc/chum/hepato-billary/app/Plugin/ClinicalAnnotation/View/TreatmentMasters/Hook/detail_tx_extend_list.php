<?php 
	if($add_chemo_complication) {
		//Display precision
		$this->Structures->build( $final_atim_structure, $final_options);
		
		//Display complication
		$structure_settings = array(
				'pagination'	=> false,
				'actions'		=> $is_ajax,
				($is_ajax? 'language_heading' : 'header')		=> __('complications')
		);
		$structure_links['index'] = array(
			'edit'=>'/ClinicalAnnotation/TreatmentExtendMasters/edit/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtendMaster.id%%',
			'delete'=>'/ClinicalAnnotation/TreatmentExtendMasters/delete/'.$atim_menu_variables['Participant.id'].'/'.$atim_menu_variables['TreatmentMaster.id'].'/%%TreatmentExtendMaster.id%%'
		);
		$final_options = array('data' => $tx_extend_data_2, 'type' => 'index', 'settings' => $structure_settings, 'links' => $structure_links);
		$final_atim_structure = $extend_form_alias_2;
		
		$structure_links['bottom']['add precision'] = array(
			'chemotherapy drugs' => $structure_links['bottom']['add precision'],
			'chemotherapy complications' => $structure_links['bottom']['add precision'].'/chemo_complications');
	}
?>