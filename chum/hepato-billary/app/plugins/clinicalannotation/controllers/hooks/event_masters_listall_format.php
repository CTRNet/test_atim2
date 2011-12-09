<?php

//NL Revised

	// --------------------------------------------------------------------------------
	// Override Menu For 'clinical' event_group. Generate both list of :
	//  - disease types for medical history to build 'add medical history' button	
	//  - medical imaging type to build 'add medical imaging' button	
	// --------------------------------------------------------------------------------
	
	if($event_group == 'clinical') {
		$is_clinical_group = true;
		
		// 1- MEDICAL PAST HISTORY & MEDICAL IMAGING
		
		// Build list of medical past history event controls
		$medical_past_history_event_control_ids = array();
		$medical_imaging_event_control_ids = array();
		foreach($event_controls as $id => $new_control) {
			
			$med_past_hist_pattern = '/^.*_medical_past_history?/';
			$imaging_pattern = '/^eventmasters,qc_hb_imaging.*?/';
			
			if(preg_match($med_past_hist_pattern, $new_control['EventControl']['form_alias'])) { 
				$medical_past_history_event_control_ids[] = $new_control['EventControl']['id'];
			} else if(preg_match($imaging_pattern, $new_control['EventControl']['form_alias'])) { 
				$medical_imaging_event_control_ids[] = $new_control['EventControl']['id'];
			}			
		}
		
		$medical_past_history_add_links = array();
		$medical_imaging_add_links = array();
		foreach($add_links as $title => $link) {
			$control_id_pattern = '/^.*\/'.$participant_id.'\/([0-9]*)?/';
			if(!preg_match($control_id_pattern, $link, $matches)) $this->redirect('/pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
			if(in_array($matches[1], $medical_past_history_event_control_ids)) {
				
				$medical_past_history_add_links[$title] = $link;
				unset($add_links[$title]);
			} else if(in_array($matches[1], $medical_imaging_event_control_ids)) {
				$medical_imaging_add_links[$title] = $link;
				unset($add_links[$title]);			
			}
		}
		
		$this->set('medical_past_history_add_links', $medical_past_history_add_links);
		$this->set('medical_imaging_add_links', $medical_imaging_add_links);
		$this->set('add_links', $add_links);
	}
		
?>