<?php

	// --------------------------------------------------------------------------------
	// Generate buttons 'add medical history summary' & 'add medical imaging summary'	
	// --------------------------------------------------------------------------------
	if(!$event_control_id) {
		$event_controls_for_add_links = array();
		$summary_event_button = array();
		foreach($event_controls as $id => $new_control) {
			if(in_array($new_control['EventControl']['detail_tablename'], array('qc_hb_ed_hepatobiliary_med_hist_record_summaries', 'qc_hb_ed_medical_imaging_record_summaries', 'qc_hb_ed_score_fongs', 'qc_hb_ed_score_child_pughs'))) {
				$summary_event_button[] = array(
					'title' => __($new_control['EventControl']['event_type']).(empty($new_control['EventControl']['disease_site'])? '' : ' - '.__($new_control['EventControl']['disease_site'])), 
					'link' => '/ClinicalAnnotation/EventMasters/add/'.$participant_id.'/'.$new_control['EventControl']['id']);
			} else {
				$event_controls_for_add_links[$id] = $new_control;
			}	
		}
		if(sizeof($event_controls) != sizeof($event_controls_for_add_links)) {
			$add_links = $this->EventControl->buildAddLinks($event_controls_for_add_links, $participant_id, $event_group);
			$this->set('add_links', $add_links);
		}
		if(!empty($summary_event_button)) $this->set('summary_event_button', $summary_event_button);
	}
		
?>