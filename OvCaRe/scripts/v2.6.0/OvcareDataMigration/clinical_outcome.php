<?php

function loadClinicalOutcomeData(&$wroksheetcells, $worksheetname, $voa_to_patient_id) {
	global $summary_msg;
	$clinical_outcome_data = array();
	foreach($wroksheetcells as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$voa_nbr = $new_line_data['Clinical Outcome::VOA Number'];
			if(!empty($voa_nbr)) {
				if(!array_key_exists($voa_nbr, $voa_to_patient_id)) die("ERR 8839398299292 VOA# = $voa_nbr, line = $excel_line_counter");
				$voa_patient_id = $voa_to_patient_id[$voa_nbr];
				$new_clinical_outcome_data = array();
				//Residual Disease
				$new_clinical_outcome_data['ovcare_residual_disease'] = '';
				switch(trim(strtolower($new_line_data['Clinical Outcome::Residual Disease']))) {
					case '':
						break;
					case 'suboptimal':
						$new_clinical_outcome_data['ovcare_residual_disease'] = 'suboptimal';
						break;
					case '<1cm':
						$new_clinical_outcome_data['ovcare_residual_disease'] = '<1cm';
						break;
					case '>2cm':
						$new_clinical_outcome_data['ovcare_residual_disease'] = '>2cm';
						break;
					case '1-2cm':
						$new_clinical_outcome_data['ovcare_residual_disease'] = '1-2cm';
						break;
					case 'millary':
					case 'miliary':
						$new_clinical_outcome_data['ovcare_residual_disease'] = 'miliary';
						break;
					case 'no':
					case 'none':
						$new_clinical_outcome_data['ovcare_residual_disease'] = 'none';
						break;
					case 'unknown':
						$new_clinical_outcome_data['ovcare_residual_disease'] = 'unknown';
						break;
					case 'yes unknown':
					case 'yes':
						$new_clinical_outcome_data['ovcare_residual_disease'] = 'yes unknown';
						break;
					default:
						$summary_msg[$worksheetname]['@@ERROR@@']["Unknown residual disease value"][] = "Surgery residual disease value [".$new_line_data['Clinical Outcome::Residual Disease']."] is not supported. See Patient ID $voa_patient_id & VOA#s $voa_nbr. [Worksheet Clinical Outcome /line: $excel_line_counter]";
				}
				//Date of Last Follow Up
				$new_clinical_outcome_data['last_followup_date'] = '';
				$new_clinical_outcome_data['last_followup_date_accuracy'] = '';
				$date_of_followup_tmp = getDateAndAccuracy($worksheetname, $new_line_data, $worksheetname, 'Clinical Outcome::Date of Last Follow Up', $excel_line_counter);
				if($date_of_followup_tmp['date']) {
					$new_clinical_outcome_data['last_followup_date'] = $date_of_followup_tmp['date'];
					$new_clinical_outcome_data['last_followup_date_accuracy'] = $date_of_followup_tmp['accuracy'];
				}
				//Status at Last Follow Up
				$new_clinical_outcome_data['last_followup_vital_status'] = '';
				$vital_status_at_followup = str_replace(array("\n", ' '), array('',''), strtolower($new_line_data['Clinical Outcome::Status at Last Follow Up']));
				if($vital_status_at_followup && !in_array($vital_status_at_followup, array('dead', 'dead/disease','alive','alive/well','dead/other','alive/disease','alive/unknown','dead/unknown','lost to follow-up'))) {
					$summary_msg[$worksheetname]['@@WARNING@@']["Unknown vital status"][] = "Vital status [$vital_status_at_followup] is not supported. Value won't be imported. See Patient [Patient ID $voa_patient_id / VOA#(s) $voa_nbr]. [Worksheet Clinical Outcome / line: $excel_line_counter]";
					$vital_status_at_followup = '';
				} else if($vital_status_at_followup) {
					if(preg_match('/dead/', $vital_status_at_followup)) {
						$new_clinical_outcome_data['last_followup_vital_status'] = 'deceased';
					} else if(preg_match('/alive/', $vital_status_at_followup)) {
						$new_clinical_outcome_data['last_followup_vital_status'] = 'alive';
					} else {
						$summary_msg[$worksheetname]['@@WARNING@@']["Un-migrated vital status"][] = "Vital status [$vital_status_at_followup] won't be migrated. See Patient [Patient ID $voa_patient_id / VOA#(s) $voa_nbr]. [Worksheet Clinical Outcome / line: $excel_line_counter]";	
					}
				}
				// Figo
				$new_clinical_outcome_data['figo'] = '';
				$file_figo = strtolower($new_line_data['Clinical Outcome::FIGO Stage']);
				if(strlen($file_figo)) {
					if(preg_match('/unknown/', $file_figo)) $file_figo = 'unknown';
					$file_figo = str_replace(array('1','2','3','4','i'), array('I','II','III','IV','I'), trim($file_figo));
					if(in_array($file_figo, array('I','Ia','Ib','Ic','II','IIa','IIb','IIc','III','IIIa','IIIb','IIIc','IV','unknown'))) {
						$new_clinical_outcome_data['figo'] = $file_figo;
					} else {
						$summary_msg[$worksheetname]['@@WARNING@@']['Unknown Figo values'][] = "Figo [".$new_line_data['Clinical Outcome::FIGO Stage']."] is not supported. See Patient ID $voa_patient_id VOA#s $voa_nbr. [Worksheet Clinical Outcome /line: $excel_line_counter]";
					}
				}
				//Disease Secific Censor
				$new_clinical_outcome_data['disease_censor'] = '';
				switch($new_line_data['Clinical Outcome::Disease Secific Censor']) {
					case '';
						break;
					case '0':
						$new_clinical_outcome_data['disease_censor'] = 'y';
						break;
					case '1':
						$new_clinical_outcome_data['disease_censor'] = 'n';
						break;
					default:
						$summary_msg[$worksheetname]['@@WARNING@@']['Unknown Disease Secific Censor values'][] = "Disease Secific Censor [".$new_line_data['Clinical Outcome::Disease Secific Censor']."] is not supported. See Patient ID $voa_patient_id VOA#s $voa_nbr. [Worksheet Clinical Outcome /line: $excel_line_counter]";
				}
				//Overall Censor
				$new_clinical_outcome_data['vital_status'] = '';
				switch($new_line_data['Clinical Outcome::Overall Censor']) {
					case '';
						break;
					case '0':
						$new_clinical_outcome_data['vital_status'] = 'deceased';
						break;
					case '1':
						$new_clinical_outcome_data['vital_status'] = 'alive';
						break;
					default:
						$summary_msg[$worksheetname]['@@WARNING@@']['Unknown Disease Overall Censor values'][] = "Disease Overall Censor [".$new_line_data['Clinical Outcome::Overall Censor']."] is not supported. See Patient ID $voa_patient_id VOA#s $voa_nbr. [Worksheet Clinical Outcome /line: $excel_line_counter]";
				}
				//Recurrence Date
				if(strlen($new_line_data['Clinical Outcome::Recurrence Date'])) die('ERR 7239811165812');
				//ChemoTherapy
				$new_clinical_outcome_data['chemos'] = array();
				if($new_line_data['Clinical Outcome::Chemo Drugs'].$new_line_data['Clinical Outcome::Chemo End'].$new_line_data['Clinical Outcome::Chemo Start']) {
					$date_tmp = getDateAndAccuracy($worksheetname, $new_line_data, $worksheetname, 'Clinical Outcome::Chemo Start', $excel_line_counter);	
					$start_date = '';
					$start_date_accuracy = '';
					if($date_tmp['date']) {
						$start_date = $date_tmp['date'];
						$start_date_accuracy = $date_tmp['accuracy'];
					} else {
						$summary_msg[$worksheetname]['@@WARNING@@']['No chemotherapy start date'][] = "Chemotherapy will be created with no date. See Patient ID $voa_patient_id VOA#s $voa_nbr. [Worksheet Clinical Outcome /line: $excel_line_counter]";
					}
					$date_tmp = getDateAndAccuracy($worksheetname, $new_line_data, $worksheetname, 'Clinical Outcome::Chemo End', $excel_line_counter);		
					$end_date = '';
					$end_date_accuracy = '';
					if($date_tmp['date']) {
						$end_date = $date_tmp['date'];
						$end_date_accuracy = $date_tmp['accuracy'];
					}				
					$chemo_key = $start_date.$start_date_accuracy.'-'.$end_date.$end_date_accuracy;
					$new_clinical_outcome_data['chemos'][$chemo_key] = array(
						'start_date' => $start_date, 
						'start_date_accuracy' => $start_date_accuracy, 
						'end_date' => $end_date, 
						'end_date_accuracy' => $end_date_accuracy, 
						'drugs' => array());
					foreach(explode("\n",$new_line_data['Clinical Outcome::Chemo Drugs']) as $new_drug) {
						$new_drug = trim($new_drug);
						if(strlen($new_drug)) $new_clinical_outcome_data['chemos'][$chemo_key]['drugs'][$new_drug] = $new_drug;
					}
				}
				//Data record
				$data_set = false;
				foreach($new_clinical_outcome_data as $data) {
					if(is_array($data)) {
						if(!empty($data)) $data_set = true;
					} else if(strlen($data)) {
						$data_set = true;
					}
				}			
				if($data_set) {
					if(!array_key_exists($voa_nbr, $clinical_outcome_data)) {				
						$clinical_outcome_data[$voa_nbr] = $new_clinical_outcome_data;
					} else {			
						foreach(array('ovcare_residual_disease','last_followup_date','last_followup_date_accuracy','last_followup_vital_status','figo','disease_censor','vital_status') as $field) {
							if(strlen($new_clinical_outcome_data[$field])) {
								if(!strlen($clinical_outcome_data[$voa_nbr][$field])) {
									$clinical_outcome_data[$voa_nbr][$field] = $new_clinical_outcome_data[$field];
								} else if($clinical_outcome_data[$voa_nbr][$field] != $new_clinical_outcome_data[$field]) {
									$summary_msg[$worksheetname]['@@ERROR@@']["2 different values for field '$field'"][] = "Value [".$clinical_outcome_data[$voa_nbr][$field]."] != [".$new_clinical_outcome_data[$field]."]. See Patient ID $voa_patient_id VOA#s $voa_nbr. [Worksheet Clinical Outcome /line: $excel_line_counter]";
								}
							}
						}					
						foreach($new_clinical_outcome_data['chemos'] as $chemo_key => $chemo_data) {
							if(array_key_exists($chemo_key, $clinical_outcome_data[$voa_nbr]['chemos'])) {
								foreach($chemo_data['drugs'] as $drug) {
									$clinical_outcome_data[$voa_nbr]['chemos'][$chemo_key]['drugs'][$drug] = $drug;
								}
							} else {
								$clinical_outcome_data[$voa_nbr]['chemos'][$chemo_key] = $chemo_data;
							}
						}					
					}
				}
			}
		}
	}
	return $clinical_outcome_data;
}

?>