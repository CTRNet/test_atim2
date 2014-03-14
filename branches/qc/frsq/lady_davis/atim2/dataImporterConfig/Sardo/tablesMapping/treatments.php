<?php

function loadTreatments(&$tmp_xls_reader, $sheets_keys) {
	$worksheet_name = 'Sardo Tx';
	if(!isset($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]])) die('ERR 838838382');
	$summary_msg_title = 'Treatment - Worksheet '.$worksheet_name;
	$summary_msg_title_participant = 'Participant - Worksheet '.$worksheet_name;
	$excel_line_counter = 0;
	$headers = array();
	$treatment_master_id = 0;
	$treatment_extend_master_id = 0;
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $new_line) {
		$excel_line_counter++;
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);	
			$jgh_nbr = $new_line_data['No de dossier'];
			if(!isset(Config::$participants[$jgh_nbr])) die('ERR 837623876287632732 : '.$jgh_nbr);
			$participant_id = Config::$participants[$jgh_nbr]['participant_id'];
			if(!$participant_id) {
				Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient not defined into Dx worksheet'][] = "See JGH# $jgh_nbr line $excel_line_counter";
			} else {
				//Check Patient Data
				if(empty(Config::$participants[$jgh_nbr]['tx_worksheet_patient_data'])) {
					Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name'] = $new_line_data['Nom'];
					Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['vital_status'] = ($new_line_data['Censure (0 = vivant, 1 = mort)']? 'deceased' : '');
					if(Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['last_name']!= Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name']) {
						Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Last Names Are Different (Dx Vs Tx)'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter : (tx worksheet) ".Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name']." != (dx worksheet) ".Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['last_name'];
					}
					if(Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['vital_status']!= Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name']) {
						Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Vital Status Are Different (Dx Vs Tx)'][] = "See JGH# ".$new_line_data['No de dossier']." line $excel_line_counter : (tx worksheet) ".Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['vital_status']." != (dx worksheet) ".Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['vital_status'];
					}
				} else {
					if(Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['last_name'] != $new_line_data['Nom']) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Date Nom'][] = "See JGH# $jgh_nbr line $excel_line_counter";
					if(Config::$participants[$jgh_nbr]['tx_worksheet_patient_data']['vital_status'] != ($new_line_data['Censure (0 = vivant, 1 = mort)']? 'deceased' : '')) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Censure'][] = "See JGH# $jgh_nbr line $excel_line_counter";
				}
				//New Treatment
				if(!isset(Config::$topos[$new_line_data['Topographie']])) { pr(Config::$topos); die('ERR 83833283832323 : '.$new_line_data['Topographie']); }
				if(!isset(Config::$morphos[$new_line_data['Morphologie']]))  { pr(Config::$morphos); die('ERR 8388434338323232 : '.$new_line_data['Morphologie']); }
				$icd10_code = Config::$topos[$new_line_data['Topographie']];
				$morphology = Config::$morphos[$new_line_data['Morphologie']];
				$dx_date = $new_line_data['Date du diagnostic'];
				$dx_date_accuracy = 'c';
				if(preg_match('/^([0-9]{4})\-MM\-JJ$/', $dx_date, $matches)) {
					$dx_date = $matches[1].'-01-01';
					$dx_date_accuracy = 'm';
				} else if(preg_match('/^([0-9]{4}\-[0-9]{2})\-JJ$/', $dx_date, $matches)) {
					$dx_date = $matches[1].'-01';
					$dx_date_accuracy = 'd';
				} else if(!preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $dx_date)) die('ERR 383287632876287326 8 : '.$dx_date);
				$treatment_control_id = '';
				switch($new_line_data['Type traitement']) {
					case 'CHIR':
						$treatment_control_id = '6';
						break;
					case 'BIOP':
						$treatment_control_id = '7';
						break;
					case 'CHIMIO':
					case 'PROTOC':
						$treatment_control_id = '1';
						break;
					default: 
						Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Following treatment types have not been imported'][$new_line_data['Type traitement']] = $new_line_data['Type traitement'];
/*
|  1 | chemotherapy              | txd_chemos                   |
|  2 | radiation                 | txd_radiations               |
|  3 | surgery                   | txd_surgeries                |
|  4 | surgery without extension | txd_surgeries                |
|  5 | hormonotherapy            | qc_lady_txd_hormonos         |
|  6 | surgery                   | qc_lady_txd_biopsy_surgeries |
|  7 | biopsy                    | qc_lady_txd_biopsy_surgeries |
 */
				}
				
				if($treatment_control_id) {
					$diagnosis_master_id = '';
					$qc_lady_laterality = '';
					$histological_grade = '';
					//Link trt to a dx
					if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology])) {
						die('ERR 32 2638 26387 62 : '.$excel_line_counter);
					} else if(sizeof(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis']) != 1) {
						Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Unable to link treatment do a diagnosis'][] = "See JGH# $jgh_nbr line $excel_line_counter. Note histological grade won't be imported + Clinical Stage.";
						foreach(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'] as &$tmp_dx_data) unset($tmp_dx_data['tmp_grade']);
					} else {
						//Found a dx...
						$tmp = array_keys(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis']);
						$qc_lady_laterality = $tmp[0];
						$diagnosis_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['id'];
						if(isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['tmp_grade'])) {
							$histological_grade = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['tmp_grade'];
//							unset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['tmp_grade']);
						}
						if(strlen(str_replace(' ', '', $new_line_data['TNM clinique']))) {
							if(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['clinical_stage_summary'] 
							&& Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['clinical_stage_summary'] != $new_line_data['TNM clinique']) die('ERR 3289 82938 932832 line : '.$excel_line_counter);
							Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['clinical_stage_summary'] = $new_line_data['TNM clinique'];
							Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$qc_lady_laterality]['diagnosis_masters']['qc_lady_clinical_stage_summary_at_dx'] = $new_line_data['TNM clinique'];
						}
					}
					//Get date
					$start_date = $new_line_data['Date début traitement'];
					$start_date_accuracy = 'c';
					if(preg_match('/^([0-9]{4})\-MM\-JJ$/', $start_date, $matches)) {
						$start_date = $matches[1].'-01-01';
						$start_date_accuracy = 'm';
					} else if(preg_match('/^([0-9]{4}\-[0-9]{2})\-JJ$/', $start_date, $matches)) {
						$start_date = $matches[1].'-01';
						$start_date_accuracy = 'd';
					} else if($start_date == 'AAAA-MM-JJ') {
						$start_date = '';
						$start_date_accuracy = '';
					} else if(!preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $start_date)) die('ERR 33829798237293 : '.$start_date);
					//Record data
					$trt_key = '';
					switch($new_line_data['Type traitement']) {
						case 'CHIR':
							//Surgery
							$trt_key = 'CHIR-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
							$trt_treatment_master_id = '';
							if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
								$treatment_master_id++;
								Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
									'treatment_masters' => array(
										'id' => $treatment_master_id,
										'treatment_control_id' => $treatment_control_id,
										'diagnosis_master_id' => $diagnosis_master_id,
										'start_date' => $start_date,
										'start_date_accuracy' => $start_date_accuracy,
										'qc_lady_laterality' => $qc_lady_laterality,
										'participant_id' => $participant_id) ,
									'qc_lady_txd_biopsy_surgeries'	=> array(
										'treatment_master_id' => $treatment_master_id,
										'patho_nbr' => $new_line_data['No rapport traitement'],
										'histological_grade' => $histological_grade,
										'path_stage_summary' => $new_line_data['TNM pathologique']),
									'treatment_extends' => array());
								$trt_treatment_master_id = $treatment_master_id;
								
							} else {
								$trt_treatment_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_masters']['id'];
								//diff
								if($new_line_data['No rapport traitement'] && $new_line_data['No rapport traitement'] != Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['patho_nbr']) {
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Date No rapport traitement'][] = "See JGH# $jgh_nbr line $excel_line_counter";
								}
								if($new_line_data['TNM pathologique'] && $new_line_data['TNM pathologique'] != Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['path_stage_summary']) {
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field TNM pathologique'][] = "See JGH# $jgh_nbr line $excel_line_counter";
								}
							}
							if($new_line_data['Traitement']) {
								$procedure = $new_line_data['Traitement'];
								if(strlen($procedure) > 100) die('ERR 2376 876287683276 2 '.$procedure);
								Config::$surgical_procedures[strtolower($procedure)] = $procedure;
								if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure])) {
									$treatment_extend_master_id ++;
									Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure] = 
										array(
											'treatment_extend_masters' => array(
												'id' => $treatment_extend_master_id,
												'treatment_extend_control_id' => 2,
												'treatment_master_id' => $trt_treatment_master_id),
											'txe_surgeries' => array(
												'surgical_procedure' => strtolower($procedure),
												'treatment_extend_master_id' => $treatment_extend_master_id));
								}
							}
							break;
							
						case 'BIOP':
							//Biopsy
							$trt_key = 'BIOP-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
							$trt_treatment_master_id = '';
							if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
								$treatment_master_id++;
								Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
									'treatment_masters' => array(
										'id' => $treatment_master_id,
										'treatment_control_id' => $treatment_control_id,
										'diagnosis_master_id' => $diagnosis_master_id,
										'start_date' => $start_date,
										'start_date_accuracy' => $start_date_accuracy,
										'qc_lady_laterality' => $qc_lady_laterality,
										'participant_id' => $participant_id) ,
									'qc_lady_txd_biopsy_surgeries'	=> array(
										'treatment_master_id' => $treatment_master_id,
										'patho_nbr' => $new_line_data['No rapport traitement'],
										'histological_grade' => $histological_grade,
										'path_stage_summary' => $new_line_data['TNM pathologique']),
										'treatment_extends' => array());
								$trt_treatment_master_id = $treatment_master_id;
							
							} else {
								$trt_treatment_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_masters']['id'];
								//diff
								if($new_line_data['No rapport traitement'] && $new_line_data['No rapport traitement'] != Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['patho_nbr']) {
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Date No rapport traitement'][] = "See JGH# $jgh_nbr line $excel_line_counter";
								}
								if($new_line_data['TNM pathologique'] && $new_line_data['TNM pathologique'] != Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['qc_lady_txd_biopsy_surgeries']['path_stage_summary']) {
									Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field TNM pathologique'][] = "See JGH# $jgh_nbr line $excel_line_counter";
								}
							}
							if($new_line_data['Traitement']) {
								$procedure = $new_line_data['Traitement'];
								if(strlen($procedure) > 100) die('ERR 2376 876287683276 2 '.$procedure);
								Config::$biopsy_procedures[strtolower($procedure)] = $procedure;
								if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure])) {
									$treatment_extend_master_id ++;
									Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$procedure] =
										array(
											'treatment_extend_masters' => array(
												'id' => $treatment_extend_master_id,
												'treatment_extend_control_id' => 4,
												'treatment_master_id' => $trt_treatment_master_id),
											'qc_lady_txe_biopsies' => array(
												'biopsy_procedure' => strtolower($procedure),
												'treatment_extend_master_id' => $treatment_extend_master_id));
								}
							}
							break;
							
						case 'CHIMIO':
							$trt_key = 'CHIMIO-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
							$trt_treatment_master_id = '';
							if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
								$treatment_master_id++;
								Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
									'treatment_masters' => array(
										'id' => $treatment_master_id,
										'treatment_control_id' => $treatment_control_id,
										'diagnosis_master_id' => $diagnosis_master_id,
										'start_date' => $start_date,
										'start_date_accuracy' => $start_date_accuracy,
										'participant_id' => $participant_id) ,
									'txd_chemos'	=> array(
										'treatment_master_id' => $treatment_master_id),
									'treatment_extends' => array());
								$trt_treatment_master_id = $treatment_master_id;
							
							} else {
								$trt_treatment_master_id = Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_masters']['id'];
							}
							if($new_line_data['Traitement']) {
								$drug_id = null;
								if(!isset(Config::$drugs[$new_line_data['Traitement']])) {
									$drug_id = customInsertRecord(array('generic_name' => $new_line_data['Traitement'], 'type' => 'chemotherapy'), 'drugs');
									Config::$drugs[$new_line_data['Traitement']] = $drug_id;
								} else {
									$drug_id = Config::$drugs[$new_line_data['Traitement']];
								}
								if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$drug_id])) {
									$treatment_extend_master_id ++;
									Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key]['treatment_extends'][$drug_id] =
										array(
											'treatment_extend_masters' => array(
												'id' => $treatment_extend_master_id,
												'treatment_extend_control_id' => 1,
												'treatment_master_id' => $trt_treatment_master_id),
											'txe_chemos' => array(
												'drug_id' => $drug_id,
												'treatment_extend_master_id' => $treatment_extend_master_id));
								}
							}
							break;	
							
						case 'PROTOC':
							$trt_key = 'PROTOC-'.(empty($start_date)? ($treatment_master_id + 1) : $start_date);
							$protocol_master_id = null;
							if($new_line_data['Traitement']) {
								if(!isset(Config::$protocols[$new_line_data['Traitement']])) {
									$protocol_master_id = customInsertRecord(array('code' => $new_line_data['Traitement'], 'protocol_control_id' => '1'), 'protocol_masters');
									customInsertRecord(array('protocol_master_id' => $protocol_master_id), 'pd_chemos', true);
									Config::$protocols[$new_line_data['Traitement']] = $protocol_master_id;
								} else {
									$protocol_master_id = Config::$protocols[$new_line_data['Traitement']];
								}
							}
							if(!$protocol_master_id) die('ERR 32762837632876 line : '.$excel_line_counter);
							if(!isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key])) {
								$treatment_master_id++;
								Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Treatment'][$trt_key] = array(
									'treatment_masters' => array(
										'id' => $treatment_master_id,
										'treatment_control_id' => $treatment_control_id,
										'diagnosis_master_id' => $diagnosis_master_id,
										'protocol_master_id' => $protocol_master_id,
										'start_date' => $start_date,
										'start_date_accuracy' => $start_date_accuracy,
										'participant_id' => $participant_id) ,
									'txd_chemos'	=> array(
										'treatment_master_id' => $treatment_master_id),
									'treatment_extends' => array());
							} else {
								//diff
								Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Duplicated PROTOC'][] = "Protocole ".$new_line_data['Traitement']." has been assigned twice to the same patient for the same date. See JGH# $jgh_nbr line $excel_line_counter";
							}
							break;		
					}
				}				
			}
		}
	} 
}

