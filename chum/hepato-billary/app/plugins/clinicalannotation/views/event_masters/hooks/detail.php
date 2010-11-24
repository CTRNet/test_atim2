<?php

	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.*** medical past history: 
	//   Build Medical Past History precisions list
	// --------------------------------------------------------------------------------
	if(isset($medical_past_history_precisions)) {
		$final_options['override' ]['EventDetail.disease_precision'] = $medical_past_history_precisions;
	}
	
	// --------------------------------------------------------------------------------
	// hepatobiliary-lab-biology : 
	//   Set participant surgeries list for hepatobiliary-lab-biology.
	// --------------------------------------------------------------------------------
	if(isset($surgeries_for_lab_report)) {
		$final_options['override' ]['EventDetail.surgery_tx_master_id'] = $surgeries_for_lab_report;
	}
	
	// --------------------------------------------------------------------------------
	// clinical.hepatobiliary.medical imaging *** : 
	//   Set Imaging Structure (other +/- pancreas +/- Semgments +/- etc)
	// --------------------------------------------------------------------------------
	if(isset($qc_hb_dateNSummary_for_imaging)){
		$imaging_structure_options = array(
			'settings' => array(
				'form_top' => false, 
				'form_bottom' => false, 
				'actions' => false, 
				'header' => null, 
				'separator' => false), 
			'links' => $structure_links);
		
		
		// 1- Date and Summary	
		if($last_imaging_structure == 'qc_hb_dateNSummary_for_imaging') {
			// Date and summary will be the unique structure
			$final_atim_structure = $qc_hb_dateNSummary_for_imaging;
		} else {
			// More than date and summary structure has to be displayed
			$structures->build( $qc_hb_dateNSummary_for_imaging,  $final_options );
		}
		
		// 2- Segments
		if(isset($qc_hb_segment)) {
			$imaging_structure_options['settings']['header'] = __('liver segments', true);
			if($last_imaging_structure === 'qc_hb_segment') {
				$final_options = $imaging_structure_options;
				$final_atim_structure = $qc_hb_segment;
			} else {
				$structures->build( $qc_hb_segment, $imaging_structure_options);
			}
		}
		
			
		// 3- Other
		if(isset($qc_hb_other_localisations)) {
			$imaging_structure_options['settings']['header'] = __('other localisations', true);
			if($last_imaging_structure === 'qc_hb_other_localisations') {
				$final_options = $imaging_structure_options;
				$final_atim_structure = $qc_hb_other_localisations;
			} else {
				$structures->build( $qc_hb_other_localisations, $imaging_structure_options);
			}
		}
		
		// 4- Pancreas
		if(isset($qc_hb_pancreas)) {
			$imaging_structure_options['settings']['header'] = __('pancreas (tumoral invasion)', true);
			if($last_imaging_structure === 'qc_hb_pancreas') {
				$final_options = $imaging_structure_options;
				$final_atim_structure = $qc_hb_pancreas;
			} else {
				$structures->build( $qc_hb_pancreas,  $imaging_structure_options);
			}
		}

		// 5- Volumetry
		if(isset($qc_hb_volumetry)){
			if($last_imaging_structure !== 'qc_hb_volumetry') { $this->redirect( '/pages/err_clin_system_error', NULL, TRUE );}
			$imaging_structure_options['settings']['header'] = __('volumetry', true);
			$final_options = $imaging_structure_options;
			$final_atim_structure = $qc_hb_volumetry;
		}
	}

?>
