<?php

function loadClinicalAnnotation() {
	Config::$voas_to_ids = array();
	
	//-----------------------------------------------------------------
	// LOAD CLINICAL DATA
	//-----------------------------------------------------------------
	
	$histo_matches = array(
		'Adenocarcinoma' => 'histo_type_adenocarcinoma',
		'Adenofibroma' => 'histo_type_other',
		'Adenosarcoma' => 'histo_type_other',
		'Borderline Brenner' => 'histo_type_other',
		'Brenner Tumour' => 'histo_type_brenner_tumour',
		'Carcinoma' => 'histo_type_carcinoma',
		'Carcinosarcoma (MMMT)' => 'histo_type_carcinosarcoma_mmmt',
		'Cellular Fibroma' => 'histo_type_other',
		'Clear Cell' => 'histo_type_clear_cell',
		'Clear Cell adenofibroma' => 'histo_type_other',
		'colon' => 'histo_type_other',
		'Colonic' => 'histo_type_other',
		'Cystadenocarcinoma' => 'histo_type_cystadenocarcinoma',
		'Cystadenofibroma' => 'histo_type_other',
		'Cystadenoma' => 'histo_type_cystadenoma',
		'Cystic Follicle' => 'histo_type_other',
		'Dysgerminoma' => 'histo_type_other',
		'Endometrioid Borderline' => 'histo_type_endometrioid_borderline',
		'Endometrioid' => 'histo_type_endometrioid',
		'GIST' => 'histo_type_GIST',
		'Granulosa Cell Tumour' => 'histo_type_other',
		'Granulosa Cell Tumour (Adult)' => 'histo_type_granulosa_cell_tumour_adult',
		'Granulosa Cell Tumour (GCT)' => 'histo_type_other',
		'Granulosa Cell Tumour (Juvenile)' => 'histo_type_granulosa_cell_tumour_juvenile',
		'High Grade ' => 'histo_type_other',
		'High grade adenosquamous' => 'histo_type_other',
		'High Grade Epithelioid Malignancy' => 'histo_type_other',
		'High Grade Leiomyosarcoma' => 'histo_type_other',
		'High Grade Papillary Serous Adenocarcinoma' => 'histo_type_other',
		'High Grade Sarcoma' => 'histo_type_other',
		'High Grade Serous' => 'histo_type_other',
		'High-grade endometrial stromal sarcoma with YWHAE genetic rearrangement' => 'histo_type_other',
		'Immature Teratoma' => 'histo_type_other',
		'Leiomyoma' => 'histo_type_other',
		'Leiomyosarcoma' => 'histo_type_other',
		'Lobular' => 'histo_type_other',
		'Low Grade ' => 'histo_type_other',
		'Low Grade Serous' => 'histo_type_other',
		'Malignant Mesothelioma' => 'histo_type_other',
		'Mammary' => 'histo_type_other',
		'Mature Teratoma' => 'histo_type_other',
		'Metastatic' => 'histo_type_other',
		'Mixed' => 'histo_type_mixed',
		'Mixed Malignant Germ Cell Tumor' => 'histo_type_other',
		'Mucinous ' => 'histo_type_mucinous',
		'Mucinous adenofibroma' => 'histo_type_other',
		'mucinous benign' => 'histo_type_other',
		'Mucinous Borderline' => 'histo_type_other',
		'Mucinous borderline' => 'histo_type_mucinous_borderline',
		'Mucinous carcinoma' => 'histo_type_other',
		'Mullerian Adenosarcoma' => 'histo_type_other',
		'Neuroendocrine carcinoma ' => 'histo_type_other',
		'Ovarian Primary' => 'histo_type_other',
		'Papillary' => 'histo_type_other',
		'PEComa' => 'histo_type_other',
		'pleimorphic liposarcoma' => 'histo_type_other',
		'Renal Cell' => 'histo_type_other',
		'Sarcoma' => 'histo_type_other',
		'Serous' => 'histo_type_serous',
		'Serous borderline' => 'histo_type_serous_borderline',
		'Serous Borderline' => 'histo_type_serous_borderline',
		'Sertoli-Leydig Cell Tumor' => 'histo_type_other',
		'Signet Ring Cell' => 'histo_type_other',
		'signet-ring cell' => 'histo_type_other',
		'Small Cell' => 'histo_type_other',
		'Squamous Cell' => 'histo_type_other',
		'Squamous Cell Carcinoma' => 'histo_type_other',
		'Stromal Sarcoma' => 'histo_type_other',
		'Undifferentiated' => 'histo_type_undifferentiated');
	
	$patient_data_from_patient_id = array();
	$patient_identifiers_check = array(
		'MRN' => array('field' => 'Medical Record Number', 'patient_ids' => array()),
		'PHN' => array('field' => 'Personal Health Number', 'patient_ids' => array()),
		'BCCA' => array('field' => 'BCCA Number', 'patient_ids' => array()));
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	$sheets_keys = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_keys[$tmp['name']] = $key;
	
	// Link all VOA# to patient_id
	$tmp_fct_res = checkVoaNbrAndPatientId($tmp_xls_reader->sheets[$sheets_keys['VOA Control']]['cells']);
	$voa_to_patient_id = $tmp_fct_res['voa_to_patient_id'];
	$max_patient_id = $tmp_fct_res['max_patient_id'];
	
	foreach($tmp_xls_reader->sheets[$sheets_keys['Profile']]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			
			// ** 1 ** LOAD PROFILE & IDENTIFIERS
			
			//Get Patient id and VOA#
			$voa_nbr = $new_line_data['VOA Number'];
			if(!isset($voa_to_patient_id[$voa_nbr])) die("ERR 8839398299292 VOA# = $voa_nbr, line = $excel_line_counter");
			$file_patient_id = $new_line_data['Patient ID'];
			$voa_patient_id = $voa_to_patient_id[$voa_nbr];
			if($file_patient_id && $file_patient_id != $voa_patient_id) die("ERR 8763773728903 VOA# = $voa_nbr, line = $excel_line_counter ($file_patient_id != $voa_patient_id");
			//Record Profile
			if(!isset($patient_data_from_patient_id[$voa_patient_id])) {
				$date_field = 'Date of Birth';
				$date_of_birth_tmp = getDateAndAccuracy($new_line_data[$date_field], 'ClinicalAnnotation Patient', $date_field, $excel_line_counter);
				$participant_identifier = $voa_patient_id;
				if(!preg_match('/^[0-9]+$/', $participant_identifier)) {
					$max_patient_id++;
					$participant_identifier=$max_patient_id;
				}
				$patient_data_from_patient_id[$voa_patient_id] = array(
					'Participant' => array(
						'participant_identifier' => $participant_identifier, 
						'first_name' => $new_line_data['Patient First Name'],
						'last_name' => $new_line_data['Patient Surname'],
						'date_of_birth' => $date_of_birth_tmp['date'],
						'date_of_birth_accuracy' => $date_of_birth_tmp['accuracy']),
					'MiscIdentifier' => array(),
					'Consent' => array(),
					'Diagnosis' => array(),
					'Event' => array(),
					'Treatment' => array());
			} else if(strlen($new_line_data['Patient First Name'].$new_line_data['Patient Surname'].$new_line_data['Date of Birth'])) {
				if(strlen($new_line_data['Patient First Name'])) {
					if(!strlen($patient_data_from_patient_id[$voa_patient_id]['Participant']['first_name'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Participant']['first_name'] = $new_line_data['Patient First Name'];
					} else if($patient_data_from_patient_id[$voa_patient_id]['Participant']['first_name'] != $new_line_data['Patient First Name']) {
						Config::$summary_msg['ClinicalAnnotation Patient']['@@ERROR@@']["2 values for field ".'Patient First Name'][] = "Patient [Patient ID $voa_patient_id / VOA# $voa_nbr] is linked to 2 different value ".$new_line_data['Patient First Name']." & ".$patient_data_from_patient_id[$voa_patient_id]['Participant']['first_name']." [line: $excel_line_counter]";
					}
				}
				if(strlen($new_line_data['Patient Surname'])) {
					if(!strlen($patient_data_from_patient_id[$voa_patient_id]['Participant']['last_name'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Participant']['last_name'] = $new_line_data['Patient Surname'];
					} else if($patient_data_from_patient_id[$voa_patient_id]['Participant']['last_name'] != $new_line_data['Patient Surname']) {
						Config::$summary_msg['ClinicalAnnotation Patient']['@@ERROR@@']["2 values for field ".'Patient Surname'][] = "Patient [Patient ID $voa_patient_id / VOA# $voa_nbr] is linked to 2 different value ".$new_line_data['Patient Surname']." & ".$patient_data_from_patient_id[$voa_patient_id]['Participant']['last_name']." [line: $excel_line_counter]";
					}
				}
				if(strlen($new_line_data['Date of Birth'])) {
					$date_field = 'Date of Birth';
					$date_of_birth_tmp = getDateAndAccuracy($new_line_data[$date_field], 'ClinicalAnnotation Patient', $date_field, $excel_line_counter);
					if(!strlen($patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth'] = $date_of_birth_tmp['date'];
						$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth_accuracy'] = $date_of_birth_tmp['accuracy'];
					} else if($date_of_birth_tmp['date'].$date_of_birth_tmp['accuracy'] != $patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth'].$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth_accuracy']) {
						Config::$summary_msg['ClinicalAnnotation Patient']['@@ERROR@@']["2 values for field ".'Date of Birth'][] = "Patient [Patient ID $voa_patient_id / VOA# $voa_nbr] is linked to 2 different value ".$date_of_birth_tmp['date']." & ".$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth']." [line: $excel_line_counter]";
					}
				}				
			}
			$date_of_birth = '';
			$date_of_birth_accuracy = '';
			//Record Identifier
			foreach($patient_identifiers_check as $identifier_abreviation => &$identifier_data) {
				$identifier_value = $new_line_data[$identifier_data['field']];
				if(!empty($identifier_value)) {
					if(!empty($patient_data_from_patient_id[$voa_patient_id]['MiscIdentifier'][$identifier_abreviation])) {
						if($patient_data_from_patient_id[$voa_patient_id]['MiscIdentifier'][$identifier_abreviation] != $identifier_value)
							Config::$summary_msg['ClinicalAnnotation Identifiers']['@@ERROR@@']["2 ".$identifier_abreviation."s for a same patient"][] = "Patient [Patient ID $voa_patient_id / VOA# $voa_nbr] is linked to 2 different $identifier_abreviation identifier : ".$patient_data_from_patient_id[$voa_patient_id]['MiscIdentifier'][$identifier_abreviation]." & ".$identifier_value.". [line: $excel_line_counter]";
					} else {
						$patient_data_from_patient_id[$voa_patient_id]['MiscIdentifier'][$identifier_abreviation] = $identifier_value;
					}
					$identifier_data['patient_ids'][$identifier_value][$voa_patient_id] = $voa_patient_id;
				}
			}
			
			// ** 2 ** LOAD CONSENT
			
			Config::$voas_to_ids[$voa_nbr]['consent_key'] = null;
			Config::$voas_to_ids[$voa_nbr]['consent_master_id'] = null;
			if($new_line_data['Date of Consent']) {
				$date_cst_field = 'Date of Consent';
				$date_consent_tmp = getDateAndAccuracy($new_line_data[$date_cst_field], 'ClinicalAnnotation Consents', $date_cst_field, $excel_line_counter);
				$date_withdrawn_field = 'Date Consent Withdrawn';
				$date_withdrawn_tmp = getDateAndAccuracy($new_line_data[$date_withdrawn_field], 'ClinicalAnnotation Consents', $date_withdrawn_field, $excel_line_counter);
				$status = '';
				if($new_line_data['Date Consent Withdrawn']) {
					$status = 'withdrawn';
				} else {
					switch($new_line_data['Consent Status']) {
						case '';
							$status = 'obtained';
							Config::$summary_msg['ClinicalAnnotation Consents']['@@WARNING@@']["No consent status"][] = "No status defined for consent '".$date_consent_tmp['date']."' assigned to Patient ID $voa_patient_id. Set to obtained. [line: $excel_line_counter]";
							break;
						case 'Complete':
							$status = 'obtained';
							break;
						case 'Incomplete':
							$status = 'pending';
							break;
						case 'Not Consented':
							$status = 'denied';
							break;
						default:
							die('ERR Consent 83892387328328 '.$new_line_data['Consent Status']);
					}
				}	
				if(!isset($patient_data_from_patient_id[$voa_patient_id]['Consent'][$date_consent_tmp['date']])) {
					//New Consent to create
					$patient_data_from_patient_id[$voa_patient_id]['Consent'][$date_consent_tmp['date']] = array(
						'ConsentMaster' => array(
							'participant_id' => null,
							'consent_control_id' => Config::$consent_control_id,
							'consent_status' => $status,
							'consent_signed_date' => $date_consent_tmp['date'],
							'consent_signed_date_accuracy' => $date_consent_tmp['accuracy'],
							'ovcare_withdrawn_date' => $date_withdrawn_tmp['date'],
							'ovcare_withdrawn_date_accuracy' => $date_withdrawn_tmp['accuracy']),
						'ConsentDetail' => array(),
						'detail_tablename' => 'cd_nationals');
					Config::$voas_to_ids[$voa_nbr]['consent_key'] = $date_consent_tmp['date'];
				} else {
					// Get previous consent data and line data to compare
					$previous_consent_data = $patient_data_from_patient_id[$voa_patient_id]['Consent'][$date_consent_tmp['date']];
					if($previous_consent_data['ConsentMaster']['consent_status'] != $status) {
						Config::$summary_msg['ClinicalAnnotation Consents']['@@WARNING@@']["Same consent date & Different statuses"][] = "Consent of Patient ID $voa_patient_id and defined as signed on ".$date_consent_tmp['date']." is parsed twice with 2 different statuses: [$status] & [".$previous_consent_data['ConsentMaster']['consent_status']."]. [line: $excel_line_counter]";
					}
					if($previous_consent_data['ConsentMaster']['ovcare_withdrawn_date'].$previous_consent_data['ConsentMaster']['ovcare_withdrawn_date_accuracy'] != $date_withdrawn_tmp['date'].$date_withdrawn_tmp['accuracy']) {
						Config::$summary_msg['ClinicalAnnotation Consents']['@@WARNING@@']["Same consent date & Different withdrawn dates"][] = "Consent of Patient ID $voa_patient_id and defined as signed on ".$date_consent_tmp['date']." is parsed twice with 2 different withdrawn dates ".$date_withdrawn_tmp['date']." & ".$previous_consent_data['ConsentMaster']['ovcare_withdrawn_date'].". [line: $excel_line_counter]";
					}					
				}				
			} else {
				if($new_line_data['Consent Status']&& $new_line_data['Consent Status'] != 'Not Consented')
					Config::$summary_msg['ClinicalAnnotation Consents'][(($new_line_data['Consent Status'] == 'Incomplete')? '@@MESSAGE@@' : '@@WARNING@@')]["No consent date & status"][] = "No consent has been created (no consent date) but a status ".$new_line_data['Consent Status']." has been defined. See Patient ID $voa_patient_id. [line: $excel_line_counter]";
				if($new_line_data['Date Consent Withdrawn'])
					Config::$summary_msg['ClinicalAnnotation Consents']['@@WARNING@@']["No consent date & withdrawn date"][] = "No consent has been created  (no consent date) but a withdrawn date ".$date_withdrawn_tmp['date']." has been defined. See Patient ID $voa_patient_id. [line: $excel_line_counter]";
			}

			// ** 3 ** LOAD DIAGNOSIS
			
			Config::$voas_to_ids[$voa_nbr]['diagnosis_key'] = null;
			Config::$voas_to_ids[$voa_nbr]['diagnosis_master_id'] = null;
			if(strlen($new_line_data['Clinical Diagnosis'].$new_line_data['Clinical History'].$new_line_data['Histological Type'])) {
				$dx_data = array(
					'DiagnosisMaster' => array(
						'participant_id' => null,
						'diagnosis_control_id' => Config::$diagnosis_control_id,
						'ovcare_tumor_site' => 'female genital-ovary',
						'ovcare_clinical_diagnosis' => $new_line_data['Clinical Diagnosis'],
						'ovcare_clinical_history' => $new_line_data['Clinical History']),
					'DiagnosisDetail' => array(),
					'detail_tablename' => 'ovcare_dxd_ovaries');
				$histo_values = explode("\n", $new_line_data['Histological Type']);
				$hito_other_details = array();
				foreach($histo_values as $histo_val) {
					if(!empty($histo_val)) {
						if(!isset($histo_matches[$histo_val])) die('ERR 994849499494994 '.$histo_val);
						$histo_field = $histo_matches[$histo_val];
						if($histo_field == 'histo_type_other') {
							$hito_other_details[] = $histo_val;
						} else {
							$dx_data['DiagnosisDetail'][$histo_field] = 'y';
						}
						if(preg_match('/[hH]igh.[gG]rade/', $histo_val)) {
							if(isset($dx_data['DiagnosisDetail']['2_3_grading_system']) && $dx_data['DiagnosisDetail']['2_3_grading_system'] != 'high grade') die('ERR 88389333889 line: '.$excel_line_counter);
							$dx_data['DiagnosisDetail']['2_3_grading_system'] = 'high grade';
						} else if(preg_match('/[Ll]ow.[gG]rade/', $histo_val)) {
							if(isset($dx_data['DiagnosisDetail']['2_3_grading_system']) && $dx_data['DiagnosisDetail']['2_3_grading_system'] != 'low grade') die('ERR 8832111133889 line: '.$excel_line_counter);
							$dx_data['DiagnosisDetail']['2_3_grading_system'] = 'low grade';
						}
					}
				}
				if($hito_other_details) {
					$dx_data['DiagnosisDetail']['hito_other'] = 'y';
					$dx_data['DiagnosisDetail']['hito_other_details'] = implode(' & ', $hito_other_details);
					if(strlen($dx_data['DiagnosisDetail']['hito_other_details']) > 150) die('ERR 676748844444');
				}
				Config::$voas_to_ids[$voa_nbr]['diagnosis_key'] = $voa_nbr;
				$patient_data_from_patient_id[$voa_patient_id]['Diagnosis'][$voa_nbr] = $dx_data;
				//GET VOA 125
				if(preg_match('/CA125\ {0,1}=\ {0,1}([0-9]{1,7})/', $new_line_data['Clinical History'], $matches)) {
					$ev_data = array(
						'EventMaster' => array(
							'participant_id' => null,
							'event_control_id' => Config::$event_controls['ca125']['event_control_id']),
						'EventDetail' => array('ca125' => $matches[1]),
						'detail_tablename' => Config::$event_controls['ca125']['detail_tablename'],
						'diagnosis_key' => array($voa_nbr));
					$patient_data_from_patient_id[$voa_patient_id]['Event'][] = $ev_data;
				}
			}

			// ** 4 ** LOAD BRCA
			
			if(strlen($new_line_data['BRCA1 Variant'].$new_line_data['BRCA2 Variant'])) die('ERR 63322224');
			if(strlen($new_line_data['BRCA Mutation Status'])) {
				$brca_detail = array('brca1_plus' => '0','brca2_plus' => '0');
				$brca_values = explode("\n", $new_line_data['BRCA Mutation Status']);
				$brca_to_record = false;
				foreach($brca_values as $brca) {
					if(strlen($brca)) {
						$done = true;
						if(preg_match('/^BRCA([12])\ \+$/', $brca, $matches)) {
							$brca_detail['brca'.$matches[1].'_plus'] = '1';
						} else {							
							die("ERR 934938393993 [$brca] line $excel_line_counter");
						}
					}
				}
				if($brca_to_record) {
					if(!isset($patient_data_from_patient_id[$voa_patient_id]['Event']['brca'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Event']['brca'] = array(
							'EventMaster' => array(
								'participant_id' => null,
								'event_control_id' => Config::$event_controls['brca']['event_control_id']),
							'EventDetail' => $brca_detail,
							'detail_tablename' => Config::$event_controls['brca']['detail_tablename'],
							'diagnosis_key' => null);
					} else if(array_diff_assoc($patient_data_from_patient_id[$voa_patient_id]['Event']['brca']['EventDetail'], $brca_detail)) {
						die("ERR 911122223 [$brca] line $excel_line_counter");
					}
				}
			}
			
			// **5 ** LOAD STUDY
			
			if(strlen($new_line_data['Study Inclusion'])) {
				$studies = explode("\n", strtolower($new_line_data['Study Inclusion']));
				foreach($studies as $study) {
					if($study) {
						$study = str_replace('tfri couer','tfri coeur', $study);
						if(isset(Config::$recorded_studies[$study])) {
							$patient_data_from_patient_id[$voa_patient_id]['Event'][$study] = array(
								'EventMaster' => array(
									'participant_id' => null,
									'event_control_id' => Config::$event_controls['study inclusion']['event_control_id']),
								'EventDetail' => array(
									'study_summary_id' => Config::$recorded_studies[$study]),
								'detail_tablename' => Config::$event_controls['study inclusion']['detail_tablename'],
								'diagnosis_key' => null);
						} else {
							die("ERR 99122938774 [$study] line: $excel_line_counter");
						}
					}	
				}			
			}
			
			// ** 6 ** LOAD Tx
			
			Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'] = null;
			Config::$voas_to_ids[$voa_nbr]['treatment_master_id'] = null;
			if(strlen($new_line_data['Neoadjuvant Chemotherpay Given'].$new_line_data['Adjuvant Radiation'].$new_line_data['Date of Procedure'])) {
				$tx_detail = array();
				if($new_line_data['Neoadjuvant Chemotherpay Given']) {
					if(!in_array($new_line_data['Neoadjuvant Chemotherpay Given'], array('Yes','No', 'Unknown'))) die('ERR 884884882 '.$excel_line_counter);
					$tx_detail['ovcare_neoadjuvant_chemotherapy'] = str_replace(array('Yes','No', 'Unknown'), array('y','n', ''), $new_line_data['Neoadjuvant Chemotherpay Given']);
				}
				if($new_line_data['Adjuvant Radiation']) {
					if(!in_array($new_line_data['Adjuvant Radiation'], array('Yes','No', 'Unknown'))) die('ERR 884884882 '.$excel_line_counter);
					$tx_detail['ovcare_adjuvant_radiation'] = str_replace(array('Yes','No', 'Unknown'), array('y','n', ''), $new_line_data['Adjuvant Radiation']);
				}
				if($new_line_data['Surgical Pathology Number']) {
					if(strlen($new_line_data['Surgical Pathology Number']) > 50) die('ERR 872224882 '.$excel_line_counter);
					$tx_detail['path_num'] = $new_line_data['Surgical Pathology Number'];
				}
				$date_txt_field = 'Date of Procedure';
				$date_tx_tmp = getDateAndAccuracy($new_line_data[$date_txt_field], 'ClinicalAnnotation Treatment', $date_txt_field, $excel_line_counter);
				$procedure_date = $date_tx_tmp['date'];
				$procedure_date_accuracy = $date_tx_tmp['accuracy'];
				$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth'];
				$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth_accuracy'];
				$ovcare_age_at_surgery = '';
				$ovcare_age_at_surgery_precision = 'missing information';
				if($date_of_birth && $procedure_date) {
					$DateOfBirthObj = new DateTime($date_of_birth);
					$ProcedureDateObj = new DateTime($procedure_date);
					$interval = $DateOfBirthObj->diff($ProcedureDateObj);
					$ovcare_age_at_surgery = $interval->format('%r%y');
					if($ovcare_age_at_surgery < 0) {
						$ovcare_age_at_surgery = '';
						$ovcare_age_at_surgery_precision = "date error";
						Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Brith Date & Surgery Date error"][] = "Surgery Date [$procedure_date] < Brith Date [$date_of_birth]. Age at surgery can not be generated. See Patient ID $voa_patient_id. [line: $excel_line_counter]";
					} else if(!(in_array($procedure_date_accuracy, array('c')) && in_array($date_of_birth_accuracy, array('c')))) {
						$ovcare_age_at_surgery_precision = "approximate";
					} else {
						$ovcare_age_at_surgery_precision = "exact";
					}
				}
				$tx_detail['ovcare_age_at_surgery'] = $ovcare_age_at_surgery;
				$tx_detail['ovcare_age_at_surgery_precision'] = $ovcare_age_at_surgery_precision;
				if(empty($procedure_date)) {
					$next_id = sizeof($patient_data_from_patient_id[$voa_patient_id]['Treatment']) + 1;
					$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$next_id] = array(
						'TreatmentMaster' => array(
							'participant_id' => null,
							'treatment_control_id' => Config::$treatment_controls['procedure - surgery']['treatment_control_id'],
							'start_date' => $procedure_date,
							'start_date_accuracy' => $procedure_date_accuracy),
						'TreatmentDetail' => $tx_detail,
						'detail_tablename' => Config::$treatment_controls['procedure - surgery']['detail_tablename'],
						'diagnosis_key' => array($voa_nbr));
					Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'] = $next_id;
					Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["No Surgery Date"][] = "No surgery (Procedure date) Date has been defined. See Patient ID $voa_patient_id. [line: $excel_line_counter]";
				} else if(!isset($patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date])) {
					$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date] = array(
						'TreatmentMaster' => array(
							'participant_id' => null,
							'treatment_control_id' => Config::$treatment_controls['procedure - surgery']['treatment_control_id'],
							'start_date' => $procedure_date,
							'start_date_accuracy' => $procedure_date_accuracy),
						'TreatmentDetail' => $tx_detail,
						'detail_tablename' => Config::$treatment_controls['procedure - surgery']['detail_tablename'],
						'diagnosis_key' => array($voa_nbr));
					Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'] = $procedure_date;
				} else {
					$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['diagnosis_key'][] = $voa_nbr;
					Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'] = $procedure_date;
					//Compare data
					$previous_treatment_details = $patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail'];
					$diff_found = false;
					if(isset($tx_detail['ovcare_neoadjuvant_chemotherapy'])) {
						if(!isset($previous_treatment_details['ovcare_neoadjuvant_chemotherapy'])) {
							$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['ovcare_neoadjuvant_chemotherapy'] = $tx_detail['ovcare_neoadjuvant_chemotherapy'];
						} else {
							$diff_found = true;
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Same Surgery Date & different neoadjuvant chemotherapy"][] = "A surgery on ($procedure_date) is defined as same by migration process but Neoadjuvant Chemo defintions are different. See Patient ID $voa_patient_id VOA#s [".implode(', ',$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['diagnosis_key'])."]. [line: $excel_line_counter]";
						}
					}
					if(isset($tx_detail['ovcare_adjuvant_radiation'])) {
						if(!isset($previous_treatment_details['ovcare_adjuvant_radiation'])) {
							$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['ovcare_adjuvant_radiation'] = $tx_detail['ovcare_adjuvant_radiation'];
						} else {
							$diff_found = true;
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Same Surgery Date & different adjuvant radiation"][] = "A surgery on ($procedure_date) is defined as same by migration process but Adjuvant Radiation defintions are different. See Patient ID $voa_patient_id VOA#s [".implode(', ',$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['diagnosis_key'])."]. [line: $excel_line_counter]";
						}
					}
					if(isset($tx_detail['path_num'])) {
						if(!isset($previous_treatment_details['path_num'])) {
							$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['path_num'] = $tx_detail['path_num'];
						} else {
							$diff_found = true;
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Same Surgery Date & different patho number"][] = "A surgery on ($procedure_date) is defined as same by migration process but PAtho Numbers are different. See Patient ID $voa_patient_id VOA#s [".implode(', ',$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['diagnosis_key'])."]. [line: $excel_line_counter]";
						}
					}
					if($tx_detail['ovcare_age_at_surgery'] != $tx_detail['ovcare_age_at_surgery'] || $tx_detail['ovcare_age_at_surgery_precision'] != $tx_detail['ovcare_age_at_surgery_precision']) die('ERR 883737 883838 3');
					if(!$diff_found) Config::$summary_msg['ClinicalAnnotation Treatment']['@@MESSAGE@@']["Same Surgery Date so same surgery"][] = "A surgery on ($procedure_date) is defined as same by migration process. See Patient ID $voa_patient_id VOA#s [".implode(', ',$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['diagnosis_key'])."]. [line: $excel_line_counter]";
				}
			}
		}
	}
	
	// Check identifiers assigned to different participants
	foreach($patient_identifiers_check as $identifier_abreviation => $identifier_data) {
		foreach($identifier_data['patient_ids'] as $identifier_value => $voa_patient_ids) {
			if(sizeof($voa_patient_ids) > 1) {
				Config::$summary_msg['ClinicalAnnotation Identifiers']['@@ERROR@@']["1 ".$identifier_abreviation." assigned to many patients"][] = "$identifier_abreviation value $identifier_value is assigned to many patients [Patient IDs ".implode(', ',$voa_patient_ids)."]";
			}
		}
	}
	unset($patient_identifiers_check);
	
	foreach($tmp_xls_reader->sheets[$sheets_keys['ClinicalOutcome']]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);

			//Get Patient id and VOA#
			$voa_nbr = $new_line_data['VOA Number'];
			if(!isset($voa_to_patient_id[$voa_nbr])) die("ERR 8839398299292 VOA# = $voa_nbr, line = $excel_line_counter");
			$voa_patient_id = $voa_to_patient_id[$voa_nbr];
			
			// ** A ** SURGERY UPDATE
			
			if(strlen($new_line_data['Clinical Outcome::Residual Disease'])) {
				if(!isset(Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'])) die('ERR 83955q1 '.$voa_nbr);
				$surgery_treatment_key = Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'];
				if(!isset($patient_data_from_patient_id[$voa_patient_id]['Treatment'][$surgery_treatment_key])) die('ERR 99473663');
				$ovcare_residual_disease = '';
				switch(strtolower($new_line_data['Clinical Outcome::Residual Disease'])) {
					case 'suboptimal':
						$ovcare_residual_disease = 'suboptimal';
						break;
					case '<1cm':
						$ovcare_residual_disease = '<1cm';
						break;
					case '>2cm':
						$ovcare_residual_disease = '>2cm';
						break;
					case '1-2cm':
						$ovcare_residual_disease = '1-2cm';
						break;
					case 'miliary':
						$ovcare_residual_disease = 'miliary';
						break;
					case 'no':
					case 'None':
						$ovcare_residual_disease = 'none';
						break;
					case 'unknown':
						$ovcare_residual_disease = 'unknown';
						break;
					case 'yes unknown':
					case 'yes':
						$ovcare_residual_disease = 'yes unknown';
						break;
					default:
						Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Unknown residual disease value"][] = "Surgery residual disease value ".$new_line_data['Clinical Outcome::Residual Disease']." is unknown. See Patient ID $voa_patient_id & VOA# $voa_nbr. [line: $excel_line_counter]";
				}
				if($ovcare_residual_disease) {
					$previous_treatment_details = $patient_data_from_patient_id[$voa_patient_id]['Treatment'][$surgery_treatment_key]['TreatmentDetail'];
					$procedure_date = $patient_data_from_patient_id[$voa_patient_id]['Treatment'][$surgery_treatment_key]['TreatmentMaster']['StartDate'];
					if(!isset($previous_treatment_details['ovcare_residual_disease'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['ovcare_residual_disease'] = $ovcare_residual_disease;
					} else if($ovcare_residual_disease != $previous_treatment_details['ovcare_residual_disease']) {
						Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Same Surgery Date & different residual disease values"][] = "A surgery on ($procedure_date) is defined as same by migration process but Residual Disease values are different. See Patient ID $voa_patient_id VOA#s [".implode(', ',$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$surgery_treatment_key]['diagnosis_key'])."]. [line: $excel_line_counter]";
					}
				}
			}
			
			// ** B ** CHEMO THERAPY CREATION
					
			if(strlen($new_line_data['Clinical Outcome::Chemo Drugs'].$new_line_data['Clinical Outcome::Chemo End'].$new_line_data['Clinical Outcome::Chemo Start'])) {
				die('ERR 72986765812');
			}

			// ** C ** CHEMO THERAPY CREATION
	/*		
			if(strlen($new_line_data['Clinical Outcome::Date of Last Follow Up'].$new_line_data['Clinical Outcome::Status at Last Follow Up'])) {
				
				
				
				
				
				
				
				
				$brca_detail = array('brca1_plus' => '0','brca2_plus' => '0');
				$brca_values = explode("\n", $new_line_data['BRCA Mutation Status']);
				$brca_to_record = false;
				foreach($brca_values as $brca) {
					if(strlen($brca)) {
						$done = true;
						if(preg_match('/^BRCA([12])\ \+$/', $brca, $matches)) {
							$brca_detail['brca'.$matches[1].'_plus'] = '1';
						} else {
							die("ERR 934938393993 [$brca] line $excel_line_counter");
						}
					}
				}
				if($brca_to_record) {
					if(!isset($patient_data_from_patient_id[$voa_patient_id]['Event']['brca'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Event']['brca'] = array(
								'EventMaster' => array(
										'participant_id' => null,
										'event_control_id' => Config::$event_controls['brca']['event_control_id']),
								'EventDetail' => $brca_detail,
								'detail_tablename' => Config::$event_controls['brca']['detail_tablename'],
								'diagnosis_key' => null);
					} else if(array_diff_assoc($patient_data_from_patient_id[$voa_patient_id]['Event']['brca']['EventDetail'], $brca_detail)) {
						die("ERR 911122223 [$brca] line $excel_line_counter");
					}
				}
			}
			
			follow up
			*/
			
				

			//Follow up + profile status
// 			Clinical Outcome::Date of Last Follow Up	
// 			Clinical Outcome::Status at Last Follow Up	
	
			//TODO Profile status
// 			Clinical Outcome::Overall Censor	a comparer avec status at last followup

			// Dx
// 			Clinical Outcome::Survival Years a calculer
// 			Clinical Outcome::FIGO Stage	
// 			Clinical Outcome::Disease Secific Censor verifier que patient pas mort de deux maladie (Est ce utile?)

			//Dx Recurrence
// 			Clinical Outcome::Recurrence Date
				
		}
	}			
	
	//-----------------------------------------------------------------
	// RECORD CLINICAL DATA
	//-----------------------------------------------------------------
	
	foreach($patient_data_from_patient_id as $new_patient) {
		pr($new_patient);
		exit;
		
		//Check sur les statut vitaux
		//Warning si colleciton et pas consenti
		
		
	}
	
	
	
	exit;
}

function checkVoaNbrAndPatientId(&$wroksheetcells) {
	$headers = array();
	$voa_to_patient_id = array();
	$linked_voas_to_patient_id = array();
	$tmp_patient_id_counter = 1;
	$studied_patient_id = null;
	$max_patient_id = 0;
	foreach($wroksheetcells as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_id = $new_line_data['Patient ID'];
			$voa = $new_line_data['VOA Number'];
			$dup_voa = $new_line_data['Duplicate Patients::VOA Number'];
			if(!((!empty($patient_id) && !empty($voa) && !empty($dup_voa)) ||
				(empty($patient_id) && empty($voa) && !empty($dup_voa)) ||
				(empty($patient_id) && !empty($voa) && !empty($dup_voa))||
				(!empty($patient_id) && !empty($voa) && empty($dup_voa)))) die('ERR checkVoaNbrAndPatientId 001 line '.$excel_line_counter);
			//define $studied_patient_id
			if(!empty($voa)) {
				if(!empty($patient_id)) {
					$studied_patient_id = $patient_id;
					if($max_patient_id < $patient_id) $max_patient_id = $patient_id;
				} else if(isset($voa_to_patient_id[$voa])) {
					$studied_patient_id = $voa_to_patient_id[$voa];
				} else {
					$studied_patient_id = 'tmp'.$tmp_patient_id_counter;
					$tmp_patient_id_counter++;
				}
			}
			if(is_null($studied_patient_id)) die('ERR8388393');
			// Manage voa
			if(!empty($voa)) {
				if(!isset($voa_to_patient_id[$voa])) {
					$voa_to_patient_id[$voa] = $studied_patient_id;
					if(isset($linked_voas_to_patient_id[$studied_patient_id])) {
						if(in_array($voa,  array('2712','2760'))) {
							Config::$summary_msg['VOA - Patient ID Control']['@@ERROR@@']['VOA# not previously added to a VOA group'][] = "VOA# $voa was not previously added to VOA group linked to Patient ID $studied_patient_id and gathering following VOA#s (".implode(',',array_keys($linked_voas_to_patient_id[$studied_patient_id]))."). Will be done. [line: $excel_line_counter]";
						} else {
							die('ERR checkVoaNbrAndPatientId 003 line '.$excel_line_counter .' / $studied_patient_id = '.$studied_patient_id);
						}
					}
					$linked_voas_to_patient_id[$studied_patient_id][$voa] = '1';
					if(!empty($dup_voa) && $voa != $dup_voa) {
						if(!isset($voa_to_patient_id[$dup_voa])) {
							$linked_voas_to_patient_id[$studied_patient_id][$dup_voa] = '0';
							$voa_to_patient_id[$dup_voa] = $studied_patient_id;
						} else if($voa_to_patient_id[$dup_voa] != $studied_patient_id) {
							Config::$summary_msg['VOA - Patient ID Control']['@@ERROR@@']['VOA# assigned to 2 different Patient IDs'][] = "VOA# $voa is linked to Patient IDs $studied_patient_id and ".$voa_to_patient_id[$dup_voa].". Will keep it assigned ot Patient ID ".$voa_to_patient_id[$dup_voa].". [line: $excel_line_counter]";
						}
					}
				} else {
					if($voa_to_patient_id[$voa] != $studied_patient_id) die('ERR checkVoaNbrAndPatientId 004 line '.$excel_line_counter);
					if(!isset($linked_voas_to_patient_id[$studied_patient_id][$voa])) die('ERR checkVoaNbrAndPatientId 006 line '.$excel_line_counter);
					if($linked_voas_to_patient_id[$studied_patient_id][$voa] == '1') die('ERR checkVoaNbrAndPatientId 007 line '.$excel_line_counter);
					$linked_voas_to_patient_id[$studied_patient_id][$voa] = '1';
					if(!empty($dup_voa) && !isset($linked_voas_to_patient_id[$studied_patient_id][$dup_voa])) die('ERR checkVoaNbrAndPatientId 006 line '.$excel_line_counter);
					if(!empty($dup_voa) && !isset($voa_to_patient_id[$dup_voa])) die('ERR checkVoaNbrAndPatientId 2226 line '.$excel_line_counter);
				}
			} else {
				if(empty($dup_voa)) die('ERR checkVoaNbrAndPatientId 327 line '.$excel_line_counter);
				if(!isset($voa_to_patient_id[$dup_voa])) {
					$voa_to_patient_id[$dup_voa] = $studied_patient_id;
					if(!isset($linked_voas_to_patient_id[$studied_patient_id])) die('ERR checkVoaNbrAndPatientId 3343 line '.$excel_line_counter);
					if(isset($linked_voas_to_patient_id[$studied_patient_id][$dup_voa])) die('ERR checkVoaNbrAndPatientId 319 line '.$excel_line_counter);
					$linked_voas_to_patient_id[$studied_patient_id][$dup_voa] = '0';
				} else {
					if($voa_to_patient_id[$dup_voa] != $studied_patient_id) die('ERR checkVoaNbrAndPatientId 837 line '.$excel_line_counter);
					if(!isset($linked_voas_to_patient_id[$studied_patient_id][$dup_voa])) die('ERR checkVoaNbrAndPatientId 006 line '.$excel_line_counter);
				}
			}
		}
	}

	foreach($linked_voas_to_patient_id as $patient_id => $voas) {
		foreach($voas as $voa => $found) {
			if(!$found) Config::$summary_msg['VOA - Patient ID Control']['@@WARNING@@']['Duplicate Patients::VOA Number not found'][] = "VOA# $voa was defined into column 'Duplicate Patients::VOA Number not found' but has never been found into column 'VOA Number'";
		}
	}
	return array('voa_to_patient_id' => $voa_to_patient_id, 'max_patient_id' => $max_patient_id);
}

?>