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
			'High Grade ' => 'high_grade',
			'High grade adenosquamous' => 'high_grade',
			'High Grade Epithelioid Malignancy' => 'high_grade',
			'High Grade Leiomyosarcoma' => 'high_grade',
			'High Grade Papillary Serous Adenocarcinoma' => 'high_grade',
			'High Grade Sarcoma' => 'high_grade',
			'High Grade Serous' => 'high_grade',
			'High-grade endometrial stromal sarcoma with YWHAE genetic rearrangement' => 'high_grade',
		'Immature Teratoma' => 'histo_type_other',
		'Leiomyoma' => 'histo_type_other',
		'Leiomyosarcoma' => 'histo_type_other',
		'Lobular' => 'histo_type_other',
			'Low Grade ' => 'low_grade',
			'Low Grade Serous' => 'low_grade',
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
	
	$figo_matches = array(
		"1" => "I",
		"1a" => "Ia",
		"1b" => "Ib",
		"1c" => "Ic",
		"2" => "II",
		"2a" => "IIa",
		"2b" => "IIb",
		"2c" => "IIc",
		"3" => "III",
		"3a" => "IIIa",
		"3b" => "IIIb",
		"3c" => "IIIc",
		"4" => "IV",
		'unknown' => 'unknown');
	
	$patient_data_from_patient_id = array();
	$patient_identifiers_check = array(
		'medical record number' => array('field' => 'Medical Record Number', 'patient_ids' => array()),
		'personal health number' => array('field' => 'Personal Health Number', 'patient_ids' => array()),
		'bcca number' => array('field' => 'BCCA Number', 'patient_ids' => array()));
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	$sheets_keys = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_keys[$tmp['name']] = $key;
	
	// Link all VOA# to patient_id
	$tmp_fct_res = checkVoaNbrAndPatientId($tmp_xls_reader->sheets[$sheets_keys['VOA Control']]['cells']);
	$voa_to_patient_id = $tmp_fct_res['voa_to_patient_id'];
	$max_patient_id = $tmp_fct_res['max_patient_id'];
	
	//===============================================================================================================
	// PARSE WORKSHEET : Profile
	//===============================================================================================================
	
	$worksheet_name = 'Profile';
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_voa_nbrs_for_msg = '';
			
			// ** 1 ** LOAD PROFILE & IDENTIFIERS
			
			//Get Patient id and VOA#
			$voa_nbr = $new_line_data['VOA Number'];
			if(!isset($voa_to_patient_id[$voa_nbr])) die("ERR 8839398299292 VOA# = $voa_nbr, line = $excel_line_counter");
			$file_patient_id = $new_line_data['Patient ID'];
			$voa_patient_id = $voa_to_patient_id[$voa_nbr];
//TODO Remove
if(!in_array($voa_patient_id, array(422,614,562,3,8,6,3,1,503, 546, 1102, 1963, 1184, 1189, 'tmp11', 2096, 1440, 'tmp60'))) continue;	
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
						'date_of_birth_accuracy' => $date_of_birth_tmp['accuracy'],
						'ovcare_last_followup_date' => null,
						'ovcare_last_followup_date_accuracy' => null),
					'MiscIdentifier' => array(),
					'Consent' => array(),
					'Diagnosis' => array(),
					'Event' => array(),
					'Treatment' => array(),
					'VOA#s' => array($voa_nbr),
					'vital_status_summary' => array('profile' => null, 'Diagnosis' => null, 'Followup' => array())
				);
				$patient_voa_nbrs_for_msg = $voa_nbr;
			} else if(strlen($new_line_data['Patient First Name'].$new_line_data['Patient Surname'].$new_line_data['Date of Birth'])) {			
				$patient_data_from_patient_id[$voa_patient_id]['VOA#s'][] = $voa_nbr;
				$patient_voa_nbrs_for_msg = implode(', ', $patient_data_from_patient_id[$voa_patient_id]['VOA#s']);
				if(strlen($new_line_data['Patient First Name'])) {
					if(!strlen($patient_data_from_patient_id[$voa_patient_id]['Participant']['first_name'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Participant']['first_name'] = $new_line_data['Patient First Name'];
					} else if($patient_data_from_patient_id[$voa_patient_id]['Participant']['first_name'] != $new_line_data['Patient First Name']) {
						Config::$summary_msg['ClinicalAnnotation Patient']['@@ERROR@@']["2 values for field ".'Patient First Name'][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different value ".$new_line_data['Patient First Name']." & ".$patient_data_from_patient_id[$voa_patient_id]['Participant']['first_name']." [Worksheet $worksheet_name / line: $excel_line_counter]";
					}
				}
				if(strlen($new_line_data['Patient Surname'])) {
					if(!strlen($patient_data_from_patient_id[$voa_patient_id]['Participant']['last_name'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Participant']['last_name'] = $new_line_data['Patient Surname'];
					} else if($patient_data_from_patient_id[$voa_patient_id]['Participant']['last_name'] != $new_line_data['Patient Surname']) {
						Config::$summary_msg['ClinicalAnnotation Patient']['@@ERROR@@']["2 values for field ".'Patient Surname'][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different value ".$new_line_data['Patient Surname']." & ".$patient_data_from_patient_id[$voa_patient_id]['Participant']['last_name']." [Worksheet $worksheet_name / line: $excel_line_counter]";
					}
				}
				if(strlen($new_line_data['Date of Birth'])) {
					$date_field = 'Date of Birth';
					$date_of_birth_tmp = getDateAndAccuracy($new_line_data[$date_field], 'ClinicalAnnotation Patient', $date_field, $excel_line_counter);
					if(!strlen($patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth'])) {
						$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth'] = $date_of_birth_tmp['date'];
						$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth_accuracy'] = $date_of_birth_tmp['accuracy'];
					} else if($date_of_birth_tmp['date'].$date_of_birth_tmp['accuracy'] != $patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth'].$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth_accuracy']) {
						Config::$summary_msg['ClinicalAnnotation Patient']['@@ERROR@@']["2 values for field ".'Date of Birth'][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different value ".$date_of_birth_tmp['date']." & ".$patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth']." [Worksheet $worksheet_name / line: $excel_line_counter]";
					}
				}	
			} else {
				$patient_data_from_patient_id[$voa_patient_id]['VOA#s'][] = $voa_nbr;
				$patient_voa_nbrs_for_msg = implode(', ', $patient_data_from_patient_id[$voa_patient_id]['VOA#s']);
			}
			$date_of_birth = '';
			$date_of_birth_accuracy = '';
			//Record Identifier
			foreach($patient_identifiers_check as $misc_identifier_name => &$identifier_data) {
				$identifier_value = $new_line_data[$identifier_data['field']];
				if(!empty($identifier_value)) {
					if(!empty($patient_data_from_patient_id[$voa_patient_id]['MiscIdentifier'][$misc_identifier_name])) {
						if($patient_data_from_patient_id[$voa_patient_id]['MiscIdentifier'][$misc_identifier_name] != $identifier_value)
							Config::$summary_msg['ClinicalAnnotation Identifiers']['@@ERROR@@']["2 ".$misc_identifier_name."s for a same patient"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to 2 different $misc_identifier_name identifier : ".$patient_data_from_patient_id[$voa_patient_id]['MiscIdentifier'][$misc_identifier_name]." & ".$identifier_value.". Second one won't be created. [Worksheet $worksheet_name / line: $excel_line_counter]";
					} else if (isset($identifier_data['patient_ids'][$identifier_value])) {
						Config::$summary_msg['ClinicalAnnotation Identifiers']['@@ERROR@@']["1 ".$misc_identifier_name." assigned to many patients"][] = "$misc_identifier_name value $identifier_value is assigned to many patients [Patient IDs ".implode(', ',$identifier_data['patient_ids'][$identifier_value])."]. Only one patient willbe assigned to this one. See worksheet $worksheet_name.";
					} else {
						$patient_data_from_patient_id[$voa_patient_id]['MiscIdentifier'][$misc_identifier_name] = $identifier_value;
					}
					$identifier_data['patient_ids'][$identifier_value][$voa_patient_id] = $voa_patient_id;
				}
			}
			
			// ** 2 ** LOAD CONSENT
			
			if(isset(Config::$voas_to_ids[$voa_nbr])) die('ERR 993824652823 '.$voa_nbr);
			Config::$voas_to_ids[$voa_nbr]['consent_key'] = null;
			Config::$voas_to_ids[$voa_nbr]['consent_master_id'] = null;
			if($new_line_data['Date of Consent']) {
				$date_cst_field = 'Date of Consent';
				$date_consent_tmp = getDateAndAccuracy($new_line_data[$date_cst_field], 'ClinicalAnnotation Consents', $date_cst_field, $excel_line_counter);
				updateOvcareLastFollowUpDate($patient_data_from_patient_id[$voa_patient_id]['Participant'], $date_consent_tmp);
				$date_withdrawn_field = 'Date Consent Withdrawn';
				$date_withdrawn_tmp = getDateAndAccuracy($new_line_data[$date_withdrawn_field], 'ClinicalAnnotation Consents', $date_withdrawn_field, $excel_line_counter);
				updateOvcareLastFollowUpDate($patient_data_from_patient_id[$voa_patient_id]['Participant'], $date_withdrawn_tmp);
				$status = '';
				if($new_line_data['Date Consent Withdrawn']) {
					$status = 'withdrawn';
				} else {
					switch($new_line_data['Consent Status']) {
						case '';
							$status = 'obtained';
							Config::$summary_msg['ClinicalAnnotation Consents']['@@WARNING@@']["No consent status"][] = "No status defined for consent '".$date_consent_tmp['date']."' assigned to Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. Set to obtained. [Worksheet $worksheet_name / line: $excel_line_counter]";
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
				} else {
					// Get previous consent data and line data to compare
					$previous_consent_data = $patient_data_from_patient_id[$voa_patient_id]['Consent'][$date_consent_tmp['date']];
					if($previous_consent_data['ConsentMaster']['consent_status'] != $status) Config::$summary_msg['ClinicalAnnotation Consents']['@@WARNING@@']["Same consent date & Different statuses"][] = "Consent of Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] and defined as signed on ".$date_consent_tmp['date']." is parsed twice with 2 different statuses: [$status] & [".$previous_consent_data['ConsentMaster']['consent_status']."]. [Worksheet $worksheet_name / line: $excel_line_counter]";
					if($previous_consent_data['ConsentMaster']['ovcare_withdrawn_date'].$previous_consent_data['ConsentMaster']['ovcare_withdrawn_date_accuracy'] != $date_withdrawn_tmp['date'].$date_withdrawn_tmp['accuracy']) Config::$summary_msg['ClinicalAnnotation Consents']['@@WARNING@@']["Same consent date & Different withdrawn dates"][] = "Consent of Patient ID [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] and defined as signed on ".$date_consent_tmp['date']." is parsed twice with 2 different withdrawn dates ".$date_withdrawn_tmp['date']." & ".$previous_consent_data['ConsentMaster']['ovcare_withdrawn_date'].". [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
				Config::$voas_to_ids[$voa_nbr]['consent_key'] = $date_consent_tmp['date'];
			} else {
				if($new_line_data['Consent Status']&& $new_line_data['Consent Status'] != 'Not Consented') Config::$summary_msg['ClinicalAnnotation Consents'][(($new_line_data['Consent Status'] == 'Incomplete')? '@@MESSAGE@@' : '@@WARNING@@')]["No consent date & status"][] = "No consent has been created (no consent date) but a status ".$new_line_data['Consent Status']." has been defined. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
				if($new_line_data['Date Consent Withdrawn']) Config::$summary_msg['ClinicalAnnotation Consents']['@@WARNING@@']["No consent date & withdrawn date"][] = "No consent has been created  (no consent date) but a withdrawn date ".$date_withdrawn_tmp['date']." has been defined. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
			}

			// ** 3 ** LOAD DIAGNOSIS
			
			Config::$voas_to_ids[$voa_nbr]['diagnosis_key'] = null;
			Config::$voas_to_ids[$voa_nbr]['diagnosis_master_id'] = null;
			$tmp_empty_strg_test = str_replace(array('unknown', 'n/a'), array('', ''), strtolower($new_line_data['Clinical Diagnosis']));
			if(!$tmp_empty_strg_test) $new_line_data['Clinical Diagnosis'] = '';
			$tmp_empty_strg_test = str_replace(array("\n", 'none given', 'none provided',  'not given', 'not provided', 'not Specified', 'unknown', 'n/a'), array("", '', '',  '', '', '', '', ''), strtolower($new_line_data['Clinical History']));
			if(!$tmp_empty_strg_test) $new_line_data['Clinical History'] = '';
			$dx_md5_code = null;
			if(strlen($new_line_data['Clinical Diagnosis'].$new_line_data['Clinical History'].$new_line_data['Histological Type'])) {
				$dx_md5_code = md5($new_line_data['Clinical Diagnosis'].$new_line_data['Clinical History'].$new_line_data['Histological Type']);
				if(!isset($patient_data_from_patient_id[$voa_patient_id]['Diagnosis'][$dx_md5_code])) {
					$dx_data = array(
						'DiagnosisMaster' => array(
							'participant_id' => null,
							'diagnosis_control_id' => Config::$diagnosis_control_id,
							'ovcare_tumor_site' => 'female genital-ovary',
							'ovcare_clinical_diagnosis' => str_replace("'", "''", $new_line_data['Clinical Diagnosis']),
							'ovcare_clinical_history' => str_replace("'", "''", $new_line_data['Clinical History'])),
						'DiagnosisDetail' => array(),
						'detail_tablename' => 'ovcare_dxd_ovaries');
					$histo_values = explode("\n", $new_line_data['Histological Type']);
					$histo_other_details = array();
					foreach($histo_values as $histo_val) {
						if(!empty($histo_val)) {
							if(!isset($histo_matches[$histo_val])) die('ERR 994849499494994 '.$histo_val);
							$histo_field = $histo_matches[$histo_val];
							if($histo_field == 'high_grade') {
								if(isset($dx_data['DiagnosisDetail']['2_3_grading_system']) && $dx_data['DiagnosisDetail']['2_3_grading_system'] != 'high grade') die('ERR 88389333889 line: '.$excel_line_counter);
								$dx_data['DiagnosisDetail']['2_3_grading_system'] = 'high grade';
								if(preg_match('/^[hH]igh.[gG]rade\ (.+)$/', $histo_val, $matches_histo)) {
									switch($matches_histo[1]) {
										case 'Serous':
											$dx_data['DiagnosisDetail'][$histo_matches['Serous']] = '1';
											break;
										case 'Papillary Serous Adenocarcinoma':
											$histo_other_details[] = 'Papillary';
											$dx_data['DiagnosisDetail'][$histo_matches['Serous']] = '1';
											$dx_data['DiagnosisDetail'][$histo_matches['Adenocarcinoma']] = '1';
											break;
										default:
											$histo_other_details[] = $matches_histo[1];
									}
								}
							} else if($histo_field == 'low_grade') {
								if(isset($dx_data['DiagnosisDetail']['2_3_grading_system']) && $dx_data['DiagnosisDetail']['2_3_grading_system'] != 'low grade') die('ERR 8832111133889 line: '.$excel_line_counter);
								$dx_data['DiagnosisDetail']['2_3_grading_system'] = 'low grade';
								if(preg_match('/^[Ll]ow.[gG]rade\ (.+)$/', $histo_val, $matches_histo)) {
									switch($matches_histo[1]) {
										case 'Serous':
											$dx_data['DiagnosisDetail'][$histo_matches['Serous']] = '1';
											break;
										default:
											$histo_other_details[] = $matches_histo[1];
									}
								}
							} else if($histo_field == 'histo_type_other') {
								$histo_other_details[] = $histo_val;
							} else {
								$dx_data['DiagnosisDetail'][$histo_field] = '1';
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
					if($histo_other_details) {
						$dx_data['DiagnosisDetail']['histo_type_other'] = '1';
						$dx_data['DiagnosisDetail']['histological_other_specification'] = implode(' & ', $histo_other_details);
						if(strlen($dx_data['DiagnosisDetail']['histological_other_specification']) > 150) die('ERR 676748844444');
					}
					$patient_data_from_patient_id[$voa_patient_id]['Diagnosis'][$dx_md5_code] = $dx_data;
					//GET VOA 125
					if(preg_match('/CA125\ {0,1}=\ {0,1}([0-9]{1,7})/', $new_line_data['Clinical History'], $matches)) {
						$ev_data = array(
							'EventMaster' => array(
								'participant_id' => null,
								'event_control_id' => Config::$event_controls['ca125']['event_control_id']),
							'EventDetail' => array('ca125' => $matches[1]),
							'detail_tablename' => Config::$event_controls['ca125']['detail_tablename'],
							'diagnosis_key' => $dx_md5_code);
						$patient_data_from_patient_id[$voa_patient_id]['Event'][] = $ev_data;
					}
				} else {
					Config::$summary_msg['ClinicalAnnotation Diagnosis']['@@MESSAGE@@']["Same diagnosis detected"][] = "Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg] is linked to many VOA#s with the same diagnosis. One diagnosis will be created. [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
				Config::$voas_to_ids[$voa_nbr]['diagnosis_key'] = $dx_md5_code;	
			}

			// ** 4 ** LOAD BRCA
			
			if(strlen($new_line_data['BRCA1 Variant'].$new_line_data['BRCA2 Variant'])) die('ERR 63322224');
			if(strlen($new_line_data['BRCA Mutation Status'])) {
				$brca_detail = array('brca1_plus' => '0','brca2_plus' => '0');
				$brca_values = explode("\n", $new_line_data['BRCA Mutation Status']);
				$brca_to_record = false;
				foreach($brca_values as $brca) {
					if(strlen($brca)) {
						$brca_to_record = true;
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
			Config::$voas_to_ids[$voa_nbr]['surgery_treatment_master_id'] = null;
			if(strlen($new_line_data['Neoadjuvant Chemotherpay Given'].$new_line_data['Adjuvant Radiation'].$new_line_data['Date of Procedure'].$new_line_data['Surgical Pathology Number'])) {
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
				updateOvcareLastFollowUpDate($patient_data_from_patient_id[$voa_patient_id]['Participant'], $date_tx_tmp);
				$procedure_date = $date_tx_tmp['date'];
				$procedure_date_accuracy = $date_tx_tmp['accuracy'];
				$date_of_birth = $patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth'];
				$date_of_birth_accuracy = $patient_data_from_patient_id[$voa_patient_id]['Participant']['date_of_birth_accuracy'];
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
						Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Birth Date & Surgery Date error"][] = "Surgery Date [$procedure_date] < Brith Date [$date_of_birth]. Age at surgery can not be generated. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
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
						'diagnosis_key' => $dx_md5_code);
					Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'] = $next_id;
					Config::$summary_msg['ClinicalAnnotation Treatment']['@@WARNING@@']["No Surgery Date"][] = "No surgery date (Procedure date) has been defined. Sugery will be created with no treatment date. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
				} else if(!isset($patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date])) {
					$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date] = array(
						'TreatmentMaster' => array(
							'participant_id' => null,
							'treatment_control_id' => Config::$treatment_controls['procedure - surgery']['treatment_control_id'],
							'start_date' => $procedure_date,
							'start_date_accuracy' => $procedure_date_accuracy),
						'TreatmentDetail' => $tx_detail,
						'detail_tablename' => Config::$treatment_controls['procedure - surgery']['detail_tablename'],
						'diagnosis_key' => $dx_md5_code);
					Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'] = $procedure_date;
				} else {
					Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'] = $procedure_date;
					//Compare data
					$previous_treatment_details = $patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail'];
					$diff_found = false;
					if($dx_md5_code) {
						if(!$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['diagnosis_key']) {
							$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['diagnosis_key'] = $dx_md5_code;
						} else if($dx_md5_code != $patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['diagnosis_key']) {
							$diff_found = true;
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Same Surgery & different diagnoses"][] = "A surgery on $procedure_date is defined as linked to 2 different diagnoses. Will link surgery to the first diagnosis. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
						}
					}
					if(isset($tx_detail['ovcare_neoadjuvant_chemotherapy'])) {
						if(!isset($previous_treatment_details['ovcare_neoadjuvant_chemotherapy'])) {
							$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['ovcare_neoadjuvant_chemotherapy'] = $tx_detail['ovcare_neoadjuvant_chemotherapy'];
						} else if($previous_treatment_details['ovcare_neoadjuvant_chemotherapy'] != $tx_detail['ovcare_neoadjuvant_chemotherapy']) {
							$diff_found = true;
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@WARNING@@']["Same Surgery Date & different neoadjuvant chemotherapy"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process but Neoadjuvant Chemo defintions are different (".$previous_treatment_details['ovcare_neoadjuvant_chemotherapy']." != ".$tx_detail['ovcare_neoadjuvant_chemotherapy']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
						}
					}
					if(isset($tx_detail['ovcare_adjuvant_radiation'])) {
						if(!isset($previous_treatment_details['ovcare_adjuvant_radiation'])) {
							$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['ovcare_adjuvant_radiation'] = $tx_detail['ovcare_adjuvant_radiation'];
						} else if($previous_treatment_details['ovcare_adjuvant_radiation'] != $tx_detail['ovcare_adjuvant_radiation']) {
							$diff_found = true;
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Same Surgery Date & different adjuvant radiation"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process but Adjuvant Radiation definitions are different (".$previous_treatment_details['ovcare_adjuvant_radiation']." != ".$tx_detail['ovcare_adjuvant_radiation']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
						}
					}
					if(isset($tx_detail['path_num'])) {
						if(!isset($previous_treatment_details['path_num'])) {
							$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$procedure_date]['TreatmentDetail']['path_num'] = $tx_detail['path_num'];
						} else if($previous_treatment_details['path_num'] != $tx_detail['path_num']) {
							$diff_found = true;
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Same Surgery Date & different patho number"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process but Patho Numbers are different (".$previous_treatment_details['path_num']." != ".$tx_detail['path_num']."). See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
						}
					}
					if($tx_detail['ovcare_age_at_surgery'] != $tx_detail['ovcare_age_at_surgery'] || $tx_detail['ovcare_age_at_surgery_precision'] != $tx_detail['ovcare_age_at_surgery_precision']) die('ERR 883737 883838 3');
					if(!$diff_found) Config::$summary_msg['ClinicalAnnotation Treatment']['@@MESSAGE@@']["Same Surgery Date so same surgery"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
			}
		}
	}
	unset($patient_identifiers_check);
	
	//===============================================================================================================
	// PARSE WORKSHEET : ClinicalOutcome
	//===============================================================================================================
	
	$worksheet_name = 'ClinicalOutcome';
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			
			//Get Patient id and VOA#
			$voa_nbr = $new_line_data['VOA Number'];	
			if(!isset($voa_to_patient_id[$voa_nbr])) die("ERR 8839398299292 VOA# = $voa_nbr, line = $excel_line_counter");
			$voa_patient_id = $voa_to_patient_id[$voa_nbr];
//TODO Remove
if(!in_array($voa_patient_id, array(422,614,562,3,8,6,3,1,503, 546, 1102, 1963, 1184, 1189, 'tmp11', 2096, 1440, 'tmp60'))) continue;	
			$patient_voa_nbrs_for_msg = implode(', ', $patient_data_from_patient_id[$voa_patient_id]['VOA#s']);
			
			// ** A ** SURGERY UPDATE
				
			if(strlen($new_line_data['Clinical Outcome::Residual Disease'])) {
				if(!isset(Config::$voas_to_ids[$voa_nbr]['surgery_treatment_key'])) {
					Config::$summary_msg['ClinicalAnnotation Treatment']['@@WARNING@@']["No Treatment & Residual Disease"][] = "No surgery has been defined in Profile but a residual disease value ".$new_line_data['Clinical Outcome::Residual Disease']." exists. Won't be migrated. See Patient ID $voa_patient_id & VOA#s $patient_voa_nbrs_for_msg. [Worksheet $worksheet_name /line: $excel_line_counter]";
				} else {
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
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Unknown residual disease value"][] = "Surgery residual disease value ".$new_line_data['Clinical Outcome::Residual Disease']." is not supported. See Patient ID $voa_patient_id & VOA#s $patient_voa_nbrs_for_msg. [Worksheet $worksheet_name /line: $excel_line_counter]";
					}			
					if($ovcare_residual_disease) {
						$previous_treatment_details = $patient_data_from_patient_id[$voa_patient_id]['Treatment'][$surgery_treatment_key]['TreatmentDetail'];
						$procedure_date = $patient_data_from_patient_id[$voa_patient_id]['Treatment'][$surgery_treatment_key]['TreatmentMaster']['start_date'];
						if(!isset($previous_treatment_details['ovcare_residual_disease'])) {
							$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$surgery_treatment_key]['TreatmentDetail']['ovcare_residual_disease'] = $ovcare_residual_disease;
						} else if($ovcare_residual_disease != $previous_treatment_details['ovcare_residual_disease']) {
							Config::$summary_msg['ClinicalAnnotation Treatment']['@@ERROR@@']["Same Surgery Date & different residual disease values"][] = "2 surgeries on $procedure_date are defined as same (same date) by migration process but Residual Disease values are different [".$ovcare_residual_disease." != ".$previous_treatment_details['ovcare_residual_disease'].". See Patient ID $voa_patient_id VOA#s $patient_voa_nbrs_for_msg. [Worksheet $worksheet_name /line: $excel_line_counter]";
						}
					}
				}
			}
			
			// ** B ** CHEMO THERAPY CREATION
					
			if(strlen($new_line_data['Clinical Outcome::Chemo Drugs'].$new_line_data['Clinical Outcome::Chemo End'].$new_line_data['Clinical Outcome::Chemo Start'])) {
				die('ERR 72986765812');
			}
			
			// ** C ** DX RECURRENCE
				
			if(strlen($new_line_data['Clinical Outcome::Recurrence Date'])) {
				die('ERR 7239811165812');
			}
			
			// ** D ** DX UPDATE
			
			if(strlen($new_line_data['Clinical Outcome::FIGO Stage'].$new_line_data['Clinical Outcome::Disease Secific Censor'])) {
				if(!isset(Config::$voas_to_ids[$voa_nbr]['diagnosis_key'])) die('ERR99383883 '.$voa_nbr);
				$dx_key = Config::$voas_to_ids[$voa_nbr]['diagnosis_key'];
				if(!isset($patient_data_from_patient_id[$voa_patient_id]['Diagnosis'][$dx_key])) die('ERR 99478721783663');
				$new_dx_details = array();
				// Figo
				$file_figo = strtolower($new_line_data['Clinical Outcome::FIGO Stage']);
				if(preg_match('/unknown/', $file_figo)) $file_figo = 'unknown';
				if(strlen($file_figo)) {
					if(isset($figo_matches[$file_figo])) {
						$new_dx_details['figo'] = $figo_matches[$file_figo];
					} else {
						Config::$summary_msg['ClinicalAnnotation Diagnosis']['@@WARNING@@']['Unknown Figo vaues'][] = "Figo [$file_figo] is not supported. See Patient ID $voa_patient_id VOA#s $patient_voa_nbrs_for_msg. [Worksheet $worksheet_name /line: $excel_line_counter]";
					}
				}
				if(strlen($new_line_data['Clinical Outcome::Disease Secific Censor'])) {
					switch($new_line_data['Clinical Outcome::Disease Secific Censor']) {
						case '0':
							$new_dx_details['censor'] = 'n';
							break;
						case '1':
							$new_dx_details['censor'] = 'y';
							$patient_data_from_patient_id[$voa_patient_id]['vital_status_summary']['Diagnosis'] = 'deceased';
							break;
						default:
							Config::$summary_msg['ClinicalAnnotation Diagnosis']['@@WARNING@@']['Unknown Disease Secific Censor vaues'] = "Disease Secific Censor [".$new_line_data['Clinical Outcome::Disease Secific Censor']."] is not supported. See Patient ID $voa_patient_id VOA#s [".implode(', ',$patient_data_from_patient_id[$voa_patient_id]['Treatment'][$surgery_treatment_key]['diagnosis_key'])."]. [Worksheet $worksheet_name /line: $excel_line_counter]";
					}
				}
				if($new_dx_details) {
					if(isset($patient_data_from_patient_id[$voa_patient_id]['Diagnosis'][$dx_key]['DiagnosisDetail']['figo']) || isset($patient_data_from_patient_id[$voa_patient_id]['Diagnosis'][$dx_key]['DiagnosisDetail']['censor'])) die('ERR 453829293 '.$voa_nbr);
					$patient_data_from_patient_id[$voa_patient_id]['Diagnosis'][$dx_key]['DiagnosisDetail'] = array_merge(
						$patient_data_from_patient_id[$voa_patient_id]['Diagnosis'][$dx_key]['DiagnosisDetail'],
						$new_dx_details);
				}
			}
						
			// ** E ** FOLLOW-UP
	
			if(strlen($new_line_data['Clinical Outcome::Date of Last Follow Up'].$new_line_data['Clinical Outcome::Status at Last Follow Up'])) {
				$date_field = 'Clinical Outcome::Date of Last Follow Up';
				$date_of_followup_tmp = getDateAndAccuracy($new_line_data[$date_field], 'ClinicalAnnotation Follow-up', $date_field, $excel_line_counter);
				updateOvcareLastFollowUpDate($patient_data_from_patient_id[$voa_patient_id]['Participant'], $date_of_followup_tmp);
				$vital_status_at_followup = str_replace("\n", '', strtolower($new_line_data['Clinical Outcome::Status at Last Follow Up']));
				if($vital_status_at_followup && !in_array($vital_status_at_followup, array('dead/disease','alive/well','dead/other','alive/disease','alive/unknown','dead/unknown','lost to follow-up'))) {
					Config::$summary_msg['ClinicalAnnotation Follow-up']['@@WARNING@@']["Unknown vital status"][] = "Vital status $vital_status_at_followup is not supported. Value won't be imported. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
					$vital_status_at_followup = '';
				} else {
					if(preg_match('/dead/', $vital_status_at_followup)) {
						$patient_data_from_patient_id[$voa_patient_id]['vital_status_summary']['Followup'][$date_of_followup_tmp['date']] = 'deceased';
					} else if(preg_match('/alive/', $vital_status_at_followup)) {
						$patient_data_from_patient_id[$voa_patient_id]['vital_status_summary']['Followup'][$date_of_followup_tmp['date']] = 'alive';
					}
				}
				if($vital_status_at_followup.$date_of_followup_tmp['date']) {
					$ev_data = array(
						'EventMaster' => array(
							'participant_id' => null,
							'event_control_id' => Config::$event_controls['follow up']['event_control_id'],
							'event_date' => $date_of_followup_tmp['date'],
							'event_date_accuracy' => $date_of_followup_tmp['accuracy']),
						'EventDetail' => array('vital_status' => $vital_status_at_followup),
						'detail_tablename' => Config::$event_controls['follow up']['detail_tablename'],
						'diagnosis_key' => null);
					$patient_data_from_patient_id[$voa_patient_id]['Event'][] = $ev_data;
				}
			}
			
			// ** E ** Vital Status
			
			if(strlen($new_line_data['Clinical Outcome::Overall Censor'])) {
				$vital_status = '';
				switch($new_line_data['Clinical Outcome::Overall Censor']) {
					case '0':
						$vital_status = 'alive';
						$patient_data_from_patient_id[$voa_patient_id]['vital_status_summary']['profile'] = 'alive';
						break;
					case '1':
						$vital_status = 'deceased';
						$patient_data_from_patient_id[$voa_patient_id]['vital_status_summary']['profile'] = 'deceased';
						break;
					default:
						die('ERR 83893938 8393 8393 '.$excel_line_counter);
				}
				if(isset($patient_data_from_patient_id[$voa_patient_id]['Participant']['vital_status']) && $patient_data_from_patient_id[$voa_patient_id]['Participant']['vital_status'] != $vital_status) {
					Config::$summary_msg['ClinicalAnnotation Patient']['@@WARNING@@']["Vital Status MisMatch"][] = "Vital statuses are different for a same patient ".$patient_data_from_patient_id[$voa_patient_id]['Participant']['vital_status']." != $vital_status. See Patient [Patient ID $voa_patient_id / VOA#(s) $patient_voa_nbrs_for_msg]. [Worksheet $worksheet_name / line: $excel_line_counter]";
				}
				$patient_data_from_patient_id[$voa_patient_id]['Participant']['vital_status'] = $vital_status;
			}	
		}
	}		
	
	//===============================================================================================================
	// RECORD CLINICAL ANNOTATION DATA
	//===============================================================================================================
	
	foreach($patient_data_from_patient_id as $patient_id => $clinical_annotation_data) {
pr("RECORD patient $patient_id => ".implode(',',$clinical_annotation_data['VOA#s']));

		// Vital Statuses Control
		$follow_up_vital_status = null;
		if($clinical_annotation_data['vital_status_summary']['Followup']) {
			ksort($clinical_annotation_data['vital_status_summary']['Followup']);
			foreach($clinical_annotation_data['vital_status_summary']['Followup'] as $date => $new_status) {
				if(!$follow_up_vital_status) {
					$follow_up_vital_status = $new_status;
				} else if($follow_up_vital_status == 'alive' && $new_status == 'deceased') {
					$follow_up_vital_status == 'deceased';
					Config::$summary_msg['ClinicalAnnotation Follow-up']['@@ERROR@@']["Status Mis-Match"][] = "Vital status was intialy set to 'alive' based on last follow-up date and then  'deceased' based on an oldest follow-up. See Patient [Patient ID $patient_id / VOA#(s) ".implode(',',$clinical_annotation_data['VOA#s'])."].";
				}			
			}
		}
		if($follow_up_vital_status == 'deceased' || $clinical_annotation_data['vital_status_summary']['Diagnosis'] == 'deceased') {
			
			if(isset($clinical_annotation_data['Participant']['vital_status']) && $clinical_annotation_data['Participant']['vital_status'] == 'alive') {
				Config::$summary_msg['ClinicalAnnotation Patient']['@@ERROR@@']["Vital Status MisMatch"][] = "Vital status was set to 'alive' but patients was defined as deceased based on diagnosis or follow up data. Will set vital status to 'descased'. See Patient [Patient ID $patient_id / VOA#(s) ".implode(',',$clinical_annotation_data['VOA#s'])."].";
				$clinical_annotation_data['Participant']['vital_status'] = 'deceased';
			} else if(!isset($clinical_annotation_data['Participant']['vital_status']) || !$clinical_annotation_data['Participant']['vital_status']) {
				Config::$summary_msg['ClinicalAnnotation Patient']['@@MESSAGE@@']["Vital Status Completion"][] = "Vital status was set to 'decaesed' based on diagnosis or follow up data. Will set vital status to 'descased'. See Patient [Patient ID $patient_id / VOA#(s) ".implode(',',$clinical_annotation_data['VOA#s'])."].";
				$clinical_annotation_data['Participant']['vital_status'] = 'deceased';
			} 
		}
		
		// PARTICIPANT
		$participant_id = customInsertRecord($clinical_annotation_data['Participant'], 'participants', false);
			
		// MISC IDENTIFIER
		
		foreach($clinical_annotation_data['MiscIdentifier'] as $misc_identifier_name => $identifier_value) {		
			if(!isset(Config::$misc_identifier_controls[$misc_identifier_name])) die('ERR 838721782647623482');
			$tmp_data = array('misc_identifier_control_id' => Config::$misc_identifier_controls[$misc_identifier_name]['id'], 
				'participant_id' => $participant_id, 
				'flag_unique' => Config::$misc_identifier_controls[$misc_identifier_name]['flag_unique'], 
				'identifier_value' => $identifier_value
			);			
			customInsertRecord($tmp_data, 'misc_identifiers', false);
		}
		
		// CONSENT
		
		foreach($clinical_annotation_data['Consent'] as &$consent_data) {
			// Master
			$consent_data['ConsentMaster']['participant_id'] = $participant_id;
			$consent_master_id = customInsertRecord($consent_data['ConsentMaster'], 'consent_masters', false);
			$consent_data['ConsentMaster']['id'] = $consent_master_id;
			// Detail
			$consent_data['ConsentDetail']['consent_master_id'] = $consent_master_id;
			customInsertRecord($consent_data['ConsentDetail'], $consent_data['detail_tablename'], true);
		}
		
		// DIAGNOSIS
		
		$tmp_diagnosis_keys = array();  
		foreach($clinical_annotation_data['Diagnosis'] as $diagnosis_key => &$diagnosis_data) {
			// Master
			$diagnosis_data['DiagnosisMaster']['participant_id'] = $participant_id;
			$diagnosis_master_id = customInsertRecord($diagnosis_data['DiagnosisMaster'], 'diagnosis_masters', false);
			$diagnosis_data['DiagnosisMaster']['id'] = $diagnosis_master_id;
			$tmp_diagnosis_keys[$diagnosis_key] = $diagnosis_master_id;
			// Detail
			$diagnosis_data['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
			customInsertRecord($diagnosis_data['DiagnosisDetail'], $diagnosis_data['detail_tablename'], true);
		}
		
		// EVENT
		
		foreach($clinical_annotation_data['Event'] as &$event_data) {
			// Master
			$event_data['EventMaster']['participant_id'] = $participant_id;
			$event_master_id = customInsertRecord($event_data['EventMaster'], 'event_masters', false);
			// Detail
			$event_data['EventDetail']['event_master_id'] = $event_master_id;
			customInsertRecord($event_data['EventDetail'], $event_data['detail_tablename'], true);
		}	
		
		// TREATMENT
		
		foreach($clinical_annotation_data['Treatment'] as &$treatment_data) {
			// Master
			$treatment_data['TreatmentMaster']['participant_id'] = $participant_id;
			if($treatment_data['diagnosis_key']) {
				if(!isset($tmp_diagnosis_keys[$treatment_data['diagnosis_key']])) die('ERR 9988473743438');
				$treatment_data['TreatmentMaster']['diagnosis_master_id'] = $tmp_diagnosis_keys[$treatment_data['diagnosis_key']];
			}
			$treatment_master_id = customInsertRecord($treatment_data['TreatmentMaster'], 'treatment_masters', false);
			$treatment_data['TreatmentMaster']['id'] = $treatment_master_id;
			// Detail
			$treatment_data['TreatmentDetail']['treatment_master_id'] = $treatment_master_id;
			customInsertRecord($treatment_data['TreatmentDetail'], $treatment_data['detail_tablename'], true);
		}		
		
		// UPDATE $voas_to_ids consent
		
		foreach($clinical_annotation_data['VOA#s'] as $voa) {
			if(!isset(Config::$voas_to_ids[$voa])) die('ERR 883738388383 '.$voa);
			Config::$voas_to_ids[$voa]['participant_id'] = $participant_id;
			// consent_master_id
			if(Config::$voas_to_ids[$voa]['consent_key']) {
				if(isset(Config::$voas_to_ids[$voa]['consent_master_id'])) die('ERR 83823 723 82');
				if(!isset($clinical_annotation_data['Consent'][Config::$voas_to_ids[$voa]['consent_key']])) die('ERR 83823 723 82.2');
				Config::$voas_to_ids[$voa]['consent_master_id'] = $clinical_annotation_data['Consent'][Config::$voas_to_ids[$voa]['consent_key']]['ConsentMaster']['id'];
			}
			// diagnosis_master_id
			if(Config::$voas_to_ids[$voa]['diagnosis_key']) {
				if(isset(Config::$voas_to_ids[$voa]['diagnosis_master_id'])) die('ERR 83823 723 83');
				if(!isset($clinical_annotation_data['Diagnosis'][Config::$voas_to_ids[$voa]['diagnosis_key']])) die('ERR 83823 723 83.2');
				Config::$voas_to_ids[$voa]['diagnosis_master_id'] = $clinical_annotation_data['Diagnosis'][Config::$voas_to_ids[$voa]['diagnosis_key']]['DiagnosisMaster']['id'];
			}
			// treatment_master_id
			if(Config::$voas_to_ids[$voa]['surgery_treatment_key']) {
				if(isset(Config::$voas_to_ids[$voa]['surgery_treatment_master_id'])) die('ERR 83823 723 83');
				if(!isset($clinical_annotation_data['Treatment'][Config::$voas_to_ids[$voa]['surgery_treatment_key']])) die('ERR 83823 723 83.2');
				Config::$voas_to_ids[$voa]['surgery_treatment_master_id'] = $clinical_annotation_data['Treatment'][Config::$voas_to_ids[$voa]['surgery_treatment_key']]['TreatmentMaster']['id'];
			}
		}
		unset($patient_data_from_patient_id[$patient_id]);
	}
	if(!empty($patient_data_from_patient_id)) {
		pr($patient_data_from_patient_id);
		die('ERR 372372388232');
	}
	unset($patient_data_from_patient_id);

	//===============================================================================================================
	// UPDATE Last Follow-Up Date & Initial Surgery Date & Survival Time in Months 
	//===============================================================================================================
	
	$query = "SELECT Participant.participant_identifier,
			Participant.id AS participant_id, 
			DiagnosisMaster.id AS diagnosis_master_id, 
			TreatmentMaster.id AS treatment_master_id,
			Participant.ovcare_last_followup_date, 
			Participant.ovcare_last_followup_date_accuracy, 
			TreatmentMaster.start_date, 
			TreatmentMaster.start_date_accuracy
		FROM participants Participant
		INNER JOIN diagnosis_masters DiagnosisMaster ON Participant.id = DiagnosisMaster.participant_id 
		INNER JOIN treatment_masters TreatmentMaster ON TreatmentMaster.diagnosis_master_id = DiagnosisMaster.id
		WHERE DiagnosisMaster.diagnosis_control_id = ".Config::$diagnosis_control_id." AND TreatmentMaster.treatment_control_id = ".Config::$treatment_controls['procedure - surgery']['treatment_control_id']." ORDER BY Participant.id ASC, TreatmentMaster.start_date ASC;";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
	$participant_data_to_update = array();
	while($row = $results->fetch_assoc()){	
		$participant_id = $row['participant_id'];
		$diagnosis_master_id = $row['diagnosis_master_id'];
		if($row['ovcare_last_followup_date']) {
			$participant_data_to_update[$participant_id]['participant_identifier'] = $row['participant_identifier'];
			$participant_data_to_update[$participant_id]['ovcare_last_followup_date'] = $row['ovcare_last_followup_date'];
			$participant_data_to_update[$participant_id]['ovcare_last_followup_date_accuracy'] = $row['ovcare_last_followup_date_accuracy'];
			if(!isset($participant_data_to_update[$participant_id][$diagnosis_master_id])) {
				$participant_data_to_update[$participant_id][$diagnosis_master_id] = array('existing_empty_surgery_date' => false, 'initial_surgery_date' => null, 'initial_surgery_date_accuracy' => null);
			}
			if(empty($row['start_date'])) {
				$participant_data_to_update[$participant_id][$diagnosis_master_id]['existing_empty_surgery_date'] = true;
			} else if(!isset($participant_data_to_update[$participant_id][$diagnosis_master_id]['initial_surgery_date'])) {
				$participant_data_to_update[$participant_id][$diagnosis_master_id]['initial_surgery_date'] = $row['start_date'];
				$participant_data_to_update[$participant_id][$diagnosis_master_id]['initial_surgery_date_accuracy'] = $row['start_date_accuracy'];
			}
		}
	}
	// UPDATE participant
	foreach($participant_data_to_update as $participant_id => $part_data) {
		$query = "UPDATE participants SET ovcare_last_followup_date = '".$part_data['ovcare_last_followup_date']."', ovcare_last_followup_date_accuracy = '".$part_data['ovcare_last_followup_date_accuracy']."' WHERE id = $participant_id;";
		mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
		if(Config::$insert_revs) {
			$query = str_replace('participants', 'participants_revs', $query);
			mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
		}
		$lastFollDateObj = new DateTime($part_data['ovcare_last_followup_date']);
		foreach($part_data as $diagnosis_master_id => $dx_data) {
			if(is_numeric($diagnosis_master_id)) {
				if($dx_data['initial_surgery_date']) {
					$initialSurgeryDateObj = new DateTime($dx_data['initial_surgery_date']);
					$interval = $initialSurgeryDateObj->diff($lastFollDateObj);
					$survival_time_months = $interval->format('%r%y')*12 + $interval->format('%r%m');
					$survival_time_months_precision = "";
					if($survival_time_months < 0) {
						$survival_time_months = '';
						$survival_time_months_precision = "date error";
						Config::$summary_msg['ClinicalAnnotation Diagnosis']['@@WARNING@@']['Survival time'][] = "Error in the date definition : surgery date = '".$dx_data['initial_surgery_date']."' AND last follow-up date = '".$part_data['ovcare_last_followup_date']."'. See patient id ".$part_data['participant_identifier'];
					} else if(!(in_array($dx_data['initial_surgery_date_accuracy'], array('c')) && in_array($part_data['ovcare_last_followup_date_accuracy'], array('c')))) {
						$survival_time_months_precision = "approximate";
					} else if($dx_data['existing_empty_surgery_date']) {
						$survival_time_months_precision = "some surgery dates empty";
					} else {
						$survival_time_months_precision = "exact";
					}
					$query = "UPDATE diagnosis_masters SET survival_time_months = '$survival_time_months', survival_time_months_precision = '$survival_time_months_precision' WHERE id = $diagnosis_master_id;";
					mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
					if(Config::$insert_revs) {
						$query = str_replace('diagnosis_masters', 'diagnosis_masters_revs', $query);
						mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
					}
					$query = "UPDATE ovcare_dxd_ovaries SET initial_surgery_date = '".$dx_data['initial_surgery_date']."', initial_surgery_date_accuracy = '".$dx_data['initial_surgery_date_accuracy']."' WHERE diagnosis_master_id = $diagnosis_master_id;";
					mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
					if(Config::$insert_revs) {
						$query = str_replace('ovcare_dxd_ovaries', 'ovcare_dxd_ovaries_revs', $query);
						mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [$query] ".__LINE__);
					}
				}
			}
		}		
	}
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
							Config::$summary_msg['VOA - Patient ID Control']['@@ERROR@@']['VOA# not previously added to a VOA group'][] = "VOA# $voa was not previously added to VOA group linked to Patient ID $studied_patient_id and gathering following VOA#s (".implode(',',array_keys($linked_voas_to_patient_id[$studied_patient_id]))."). Will be done. [Worksheet 'VOA Control' / line: $excel_line_counter]";
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
							Config::$summary_msg['VOA - Patient ID Control']['@@ERROR@@']['VOA# assigned to 2 different Patient IDs'][] = "VOA# $voa is linked to Patient IDs $studied_patient_id and ".$voa_to_patient_id[$dup_voa].". Will keep it assigned ot Patient ID ".$voa_to_patient_id[$dup_voa].". [Worksheet 'VOA Control' / line: $excel_line_counter]";
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
			if(!$found) Config::$summary_msg['VOA - Patient ID Control']['@@WARNING@@']['Duplicate Patients::VOA Number not found'][] = "VOA# $voa was defined into column 'Duplicate Patients::VOA Number not found' but has never been found into column 'VOA Number'. See worksheet 'VOA Control'.";
		}
	}
	return array('voa_to_patient_id' => $voa_to_patient_id, 'max_patient_id' => $max_patient_id);
}

function updateOvcareLastFollowUpDate(&$participant_data, $new_date_res) {
	if(!empty($new_date_res['date'])) {
		if(!$participant_data['ovcare_last_followup_date']) {
			$participant_data['ovcare_last_followup_date'] = $new_date_res['date'];
			$participant_data['ovcare_last_followup_date_accuracy'] = $new_date_res['accuracy'];
		} else {
			$new = str_replace('-', '', $new_date_res['date']);
			$previous = str_replace('-', '', $participant_data['ovcare_last_followup_date']);
			if($new > $previous) {
				$participant_data['ovcare_last_followup_date'] = $new_date_res['date'];
				$participant_data['ovcare_last_followup_date_accuracy'] = $new_date_res['accuracy'];
			}
		}
	}
}




?>