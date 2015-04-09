<?php

	if(isset($add_link_for_procure_forms)) {
		$final_options['links']['bottom']['add form'] = $add_link_for_procure_forms;
		$structure_links['bottom']['add form'] = $add_link_for_procure_forms;
	}
	
	if(isset($linked_events_control_data)) {  
		//Display clinical events and treatments lists of a follow-up worksheet
		$this->Structures->build( $final_atim_structure, $final_options );
		//------------------------------------------------------------------------------
		// Prostate Diagnosis - Clinical Data
		//------------------------------------------------------------------------------
		$main_header = 'prostate diagnosis - clinical data';
		// linked clinical events
		foreach($linked_events_control_data as $new_event_control) {
			$final_atim_structure = array();
			$event_control_id = $new_event_control['EventControl']['id'];
			$event_type = str_replace(
				array('procure follow-up worksheet - ', 'clinical event', 'clinical note'), 
				array('', 'clinical events', 'clinical notes'), 
				$new_event_control['EventControl']['event_type']);
			$final_options = array(
					'type' => 'detail',
					'links'	=> $structure_links,
					'settings' => array(
						'header' => __($main_header, null),
						'language_heading' => __($event_type, null),
						'actions'	=> false),
					'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/listallBasedOnControlId/'.$atim_menu_variables['Participant.id']."/$event_control_id/$interval_start_date/$interval_start_date_accuracy/$interval_finish_date/$interval_finish_date_accuracy")
			);		
			$this->Structures->build( $final_atim_structure, $final_options );
			$main_header = null;
		}
		// linked treatments
		foreach($linked_tx_control_data as $new_tx_control) {
			$treatment_control_id = $new_tx_control['TreatmentControl']['id'];
			$final_atim_structure = array();
			$final_options = array(
				'type' => 'detail',
				'links'	=> $structure_links,
				'settings' => array(
					'header' => __($main_header, null),
					'language_heading' => __('treatments', null),
					'actions'	=> false),
				'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/listallBasedOnControlId/'.$atim_menu_variables['Participant.id']."/$treatment_control_id/$interval_start_date/$interval_start_date_accuracy/$interval_finish_date/$interval_finish_date_accuracy")
			);
			$this->Structures->build( $final_atim_structure, $final_options );
			$main_header = null;
		}
		//------------------------------------------------------------------------------
		// Other Diagnosis - Clinical Data
		//------------------------------------------------------------------------------
		$main_header = 'other diagnoses - clinical data';
		// linked clinical events
		foreach($other_dx_events_control_data as $new_event_control) {
			$final_atim_structure = array();
			$event_control_id = $new_event_control['EventControl']['id'];
			$event_type = str_replace(
					array('procure follow-up worksheet - ', 'other tumor dx'),
					array('', 'diagnosis'),
					$new_event_control['EventControl']['event_type']);
			$final_options = array(
				'type' => 'detail',
				'links'	=> $structure_links,
				'settings' => array(
					'header' => __($main_header, null),
					'language_heading' => __($event_type, null),
					'actions'	=> false),
				'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/EventMasters/listallBasedOnControlId/'.$atim_menu_variables['Participant.id']."/$event_control_id/$interval_start_date/$interval_start_date_accuracy/$interval_finish_date/$interval_finish_date_accuracy")
			);
			$this->Structures->build( $final_atim_structure, $final_options );
			$main_header = null;
		}
		// linked treatments
		foreach($other_dx_tx_control_data as $new_tx_control) {
			$treatment_control_id = $new_tx_control['TreatmentControl']['id'];
			$final_atim_structure = array();
			$final_options = array(
				'type' => 'detail',
				'links'	=> $structure_links,
				'settings' => array(
					'header' => __($main_header, null),
					'language_heading' => __('treatments', null),
					'actions'	=> false),
				'extras' => $this->Structures->ajaxIndex('ClinicalAnnotation/TreatmentMasters/listallBasedOnControlId/'.$atim_menu_variables['Participant.id']."/$treatment_control_id/$interval_start_date/$interval_start_date_accuracy/$interval_finish_date/$interval_finish_date_accuracy")
			);
		}
	}
	
	//To not display Related Diagnosis Event and Linked Collections
	$is_ajax = true;
	$final_options['settings']['actions'] = true;
	$final_options['settings']['form_bottom'] = true;
	