<?php

	if(isset($add_link_for_procure_forms)) {
		$final_options['links']['bottom']['add form'] = $add_link_for_procure_forms;
		$structure_links['bottom']['add form'] = $add_link_for_procure_forms;
	}
	
	if(isset($drug_tx_control_id)) {
		//Display drugs list of a medication worksheet
		$final_options['settings']['actions'] = false;
		$this->Structures->build( $final_atim_structure, $final_options );
		//Drugs
		$final_atim_structure = array(); 
		$final_options = array(
			'type' => 'detail', 
			'links'	=> $structure_links,
			'settings' => array(
				'language_heading' => __('drugs', null),
				'actions'	=> true), 
			'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id']."/$drug_tx_control_id/$interval_start_date/$interval_start_date_accuracy/$interval_finish_date/$interval_finish_date_accuracy")		
		);	
	}
	
	//To not display Related Diagnosis Event and Linked Collections
	$is_ajax = true;
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	unset($final_options['links']['bottom']['add precision']);		

