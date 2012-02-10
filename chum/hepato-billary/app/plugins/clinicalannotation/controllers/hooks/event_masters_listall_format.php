<?php

	// --------------------------------------------------------------------------------
	// Generate buttons 'add medical history summary' & 'add medical imaging summary'	
	// --------------------------------------------------------------------------------
	
	foreach($event_controls as $id => $new_control) {
		if(in_array($new_control['EventControl']['detail_tablename'], array('qc_hb_ed_hepatobiliary_med_hist_record_summaries', 'qc_hb_ed_medical_imaging_record_summaries'))) {
			$title = __($new_control['EventControl']['disease_site'],true).' - '.__($new_control['EventControl']['event_type'],true);
			$this->set('summary_event_button', array(
				'title' => $new_control['EventControl']['event_type'], 
				'link' => $add_links[$title]));
			unset($add_links[$title]);
		}	
	}
	$this->set('add_links',$add_links);
		
?>