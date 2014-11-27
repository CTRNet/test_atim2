<?php

	if(isset($add_link_for_procure_forms)) {
		$final_options['links']['bottom']['add form'] = $add_link_for_procure_forms;
		$structure_links['bottom']['add form'] = $add_link_for_procure_forms;
	}
	
	if(isset($psa_event_control_id)) {  
		//Display clinical events and treatments lists of a follow-up worksheet
		$this->Structures->build( $final_atim_structure, $final_options );
		// clinical events & psa
		foreach(array($psa_event_control_id => 'aps', $clinical_event_control_id => 'clinical events') as $event_control_id => $event_type) {
			$final_atim_structure = array();
			$final_options = array(
					'type' => 'detail',
					'links'	=> $structure_links,
					'settings' => array(
						'language_heading' => __($event_type, null),
						'actions'	=> false),
					'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/listallBasedOnControlId/'.$atim_menu_variables['Participant.id']."/$event_control_id/$event_type/$interval_start_date/$interval_start_date_accuracy/$interval_finish_date/$interval_finish_date_accuracy")
			);		
			$this->Structures->build( $final_atim_structure, $final_options );
		}
		// treatment
		$final_atim_structure = array();
		$final_options = array(
			'type' => 'detail',
			'links'	=> $structure_links,
			'settings' => array(
				'language_heading' => __('treatments', null),
				'actions'	=> false),
			'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/listall/'.$atim_menu_variables['Participant.id']."/$treatment_control_id/$interval_start_date/$interval_start_date_accuracy/$interval_finish_date/$interval_finish_date_accuracy")
		);
	}	
	
	//To not display Related Diagnosis Event and Linked Collections
	$is_ajax = true;
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	