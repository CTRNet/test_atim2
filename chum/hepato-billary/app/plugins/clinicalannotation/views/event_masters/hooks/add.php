<?php

	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.*** medical past history: 
	//   Build Medical Past History precisions list
	// --------------------------------------------------------------------------------
	if(isset($medical_past_history_precisions)) {
		$final_options['override' ]['EventDetail.disease_precision'] = $medical_past_history_precisions;
	}
	
	// --------------------------------------------------------------------------------
	// lab.hepatobiliary.biology: 
	//   Add date and summary if required
	// --------------------------------------------------------------------------------	
	if(isset($qc_hb_dateNSummary)){
		$header = $final_options['settings']['header'];
		unset($final_options['settings']['header']);		
		$structures->build( $qc_hb_dateNSummary,  array('settings' => array('form_top' => false, 'form_bottom' => false, 'actions' => false, 'header' => $header), 'links' => $structure_links));
	}
	
	if(isset($qc_hb_segment)){
		pr('qc_hb_segment');
		$structures->build( $qc_hb_segment,  array('settings' => array('form_top' => false, 'form_bottom' => false, 'actions' => false, 'header' => __('segments', true), 'separator' => true), 'links' => $structure_links));
	}
	if(isset($qc_hb_other_localisations)){
		pr('qc_hb_other_localisations');
		$structures->build( $qc_hb_other_localisations,  array('settings' => array('form_top' => false, 'form_bottom' => false, 'actions' => false, 'header' => __('other localisations', true), 'separator' => true), 'links' => $structure_links));
	}
	if(isset($qc_hb_volumetry)){
		pr('qc_hb_volumetry');
		$structures->build( $qc_hb_volumetry,  array('settings' => array('form_top' => false, 'form_bottom' => false, 'actions' => false, 'header' => __('volumetry', true), 'separator' => true), 'links' => $structure_links));
	}
	if(isset($last_header)){
		$final_options['settings']['header'] = $last_header;
	}
	
?>
