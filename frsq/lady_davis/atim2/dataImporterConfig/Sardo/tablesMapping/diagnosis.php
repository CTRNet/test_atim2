<?php

function loadDxCodes(&$tmp_xls_reader, $sheets_keys) {
	Config::$topos = array();
	Config::$morphos = array();
	
	$worksheet_name = 'TopoMorphoCode';
	if(!isset($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]])) die('ERR 838838383');
	$summary_msg_title = 'Topo & Morpho codes - Worksheet '.$worksheet_name;
	$headers = array();
	$excel_line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $new_line) {
		$excel_line_counter++;
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			switch($new_line_data['Type']) {
				case 'Topographie':
					Config::$topos[$new_line_data['Description']] = $new_line_data['Code'];
					break;
				case 'Morphologie';
					Config::$morphos[$new_line_data['Description']] = $new_line_data['Code'];
					break;
				default:
					die('ERR 3838393939 : '.$excel_line_counter);
			}
		}
	}
	$query = "SELECT * FROM coding_icd10_who WHERE id IN ('".implode("','", Config::$topos)."')";
	$res = mysqli_query(Config::$db_connection, $query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$query."]");
	if($res->num_rows != sizeof(Config::$topos)) die('ERR 38383287268268');
	$query = "SELECT * FROM coding_icd_o_3_morphology_custom WHERE id IN ('".implode("','", Config::$morphos)."')";
	$res = mysqli_query(Config::$db_connection, $query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$query."]");
	if($res->num_rows != sizeof(Config::$morphos)) die('ERR 38383287268263');
}

function loadDiagnosis(&$tmp_xls_reader, $sheets_keys) {
	Config::$participants = array();
	
	$worksheet_name = 'Sardo Dx';
	if(!isset($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]])) die('ERR 838838383');
	$summary_msg_title = 'Diagnosis - Worksheet '.$worksheet_name;
	$summary_msg_title_participant = 'Participant - Worksheet '.$worksheet_name;
	$headers = array();
	$excel_line_counter = 0;
	$diagnosis_master_id = 0;
	foreach($tmp_xls_reader->sheets[$sheets_keys[$worksheet_name]]['cells'] as $new_line) {
		$excel_line_counter++;
		if($excel_line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);		
			$jgh_nbr = $new_line_data['No de dossier'];
			if(!isset(Config::$participants[$jgh_nbr])) {
				//Get participant data
				$query = "SELECT p.id AS participant_id, i.identifier_value, p.first_name, p.last_name, p.vital_status, p.date_of_death, p.date_of_death_accuracy
					FROM misc_identifiers i
					INNER JOIN participants p ON p.id = i.participant_id
					WHERE i.deleted != 1 AND i.misc_identifier_control_id = 6 AND i.identifier_value = '$jgh_nbr'";
				$res = mysqli_query(Config::$db_connection, $query) or die("SQL_ERROR: ".__FUNCTION__." line:".__LINE__." [".$query."]");
				if($res->num_rows > 1) {
					Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Same JGH# For Different Participant'][] = "See JGH# $jgh_nbr line $excel_line_counter";
					Config::$participants[$jgh_nbr] = array('participant_id' => null);
				} else if(!$res->num_rows){
					Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Missing Participant'][] = "See JGH# $jgh_nbr line $excel_line_counter : Patient does not exist into ATIM";
					Config::$participants[$jgh_nbr] = array('participant_id' => null);
				} else {
					$row = $res->fetch_assoc();
					Config::$participants[$jgh_nbr] = array(
						'participant_id' => $row['participant_id'],
						'first_name' => $row['first_name'],
						'last_name' => $row['last_name'],
						'db_vital_status' => $row['vital_status'],
						'db_date_of_death' => $row['date_of_death'],
						'db_date_of_death_accuracy' => $row['date_of_death_accuracy'],
						'dx_worksheet_patient_data' =>array(
							'last_name' => $new_line_data['Nom'], 
//							'city' => $new_line_data['Région du Québec'],
							'date_of_death' => $new_line_data['Date du décès'], 
							'vital_status' => ($new_line_data['Censure (0 = vivant, 1 = mort)']? 'deceased' : '')),
						'tx_worksheet_patient_data' =>array(),
						'rec_worksheet_patient_data' =>array(),
						'diagnoses_data' => array());
//						'participant_db_data_to_update' => array());
				}
			} else {
				if(Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['last_name'] != $new_line_data['Nom']) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Nom'][] = "See JGH# $jgh_nbr line $excel_line_counter";
				if(Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['date_of_death'] != $new_line_data['Date du décès']) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Date Deces'][] = "See JGH# $jgh_nbr line $excel_line_counter";
				if(Config::$participants[$jgh_nbr]['dx_worksheet_patient_data']['vital_status'] != ($new_line_data['Censure (0 = vivant, 1 = mort)']? 'deceased' : '')) Config::$summary_msg[$summary_msg_title_participant]['@@ERROR@@']['Patient Worksheet Data not Consistent : Field Censure'][] = "See JGH# $jgh_nbr line $excel_line_counter";
			}
			$participant_id = Config::$participants[$jgh_nbr]['participant_id'];
			if($participant_id) {
				//Note: Work on names will be done in receptor
				//Work on vital status
				if(!array_key_exists('participant_db_data_to_update' , Config::$participants[$jgh_nbr])) {
					$file_vital_status = $new_line_data['Censure (0 = vivant, 1 = mort)']? 'deceased' : '';
					$file_date_of_death = '';
					$file_date_of_death_accuracy = '';
					if(preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $new_line_data['Date du décès'])) {
						$file_date_of_death = $new_line_data['Date du décès'];
						$file_date_of_death_accuracy = 'c';
						if($file_vital_status != 'deceased') die('ERR 39236265323 '. $excel_line_counter);
					} else if('AAAA-MM-JJ' != $new_line_data['Date du décès']) {
						die('ERR 8383823827823 '.$new_line_data['Date du décès']);
					}
					$db_vital_status = Config::$participants[$jgh_nbr]['db_vital_status'];
					$db_date_of_death = Config::$participants[$jgh_nbr]['db_date_of_death'];
					$db_date_of_death_accuracy = Config::$participants[$jgh_nbr]['db_date_of_death_accuracy'];
					$participant_data_to_update  =array();
					if(empty($db_vital_status)) {
						if($file_vital_status) {
							$participant_data_to_update['vital_status'] = "vital_status = '$file_vital_status'";
							$participant_data_to_update['date_of_death'] = "date_of_death = '$file_date_of_death'";
							$participant_data_to_update['date_of_death_accuracy'] = "date_of_death_accuracy = '$file_date_of_death_accuracy'";
						}
					} else if($db_vital_status == $file_vital_status && $db_vital_status == 'deceased') {
						if(empty($db_date_of_death) && !empty($file_date_of_death)) {
							$participant_data_to_update['date_of_death'] = "date_of_death = '$file_date_of_death'";
							$participant_data_to_update['date_of_death_accuracy'] = "date_of_death_accuracy = '$file_date_of_death_accuracy'";
						} else if(!empty($db_date_of_death) && empty($file_date_of_death)) {
							Config::$summary_msg[$summary_msg_title_participant]['@@MESSAGE@@']['Date of death just defined in db'][] = "See JGH# $jgh_nbr line $excel_line_counter";
						} else if($db_date_of_death != $file_date_of_death || $db_date_of_death_accuracy != $file_date_of_death_accuracy) {
							Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Dates of death are different in db and file'][] = "See JGH# $jgh_nbr line $excel_line_counter [$file_date_of_death($file_date_of_death_accuracy) != $db_date_of_death($db_date_of_death_accuracy)]";
						}
					} else {
						Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Vital status are different in db and file'][] = "See JGH# $jgh_nbr line $excel_line_counter [(ATiM) $db_vital_status != (file) ".(empty($file_vital_status)? 'No value' : $file_vital_status)."]";
					}
					Config::$participants[$jgh_nbr]['participant_db_data_to_update'] = $participant_data_to_update;
				}
				//Work On Diagnosis
				if(!isset(Config::$topos[$new_line_data['Topographie']])) { pr(Config::$topos); die('ERR 83883832323 : '.$new_line_data['Topographie']); }
				if(!isset(Config::$morphos[$new_line_data['Morphologie']]))  { pr(Config::$morphos); die('ERR 838838323232 : '.$new_line_data['Morphologie']); }
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
				$laterality = '';
				switch($new_line_data['Latéralité']) {
					case 'Droite':
						$laterality = 'right';
						break;
					case 'Gauche':
						$laterality = 'left';
						break;
					case 'N/S':
					case '':
						break;
					default:
						die('ERR 3283 8628763 8726 832 : '.$new_line_data['Latéralité'].' line : '.$excel_line_counter);
				}
				$diagnosis_master_id++;
				$dx_data = array(
					'diagnosis_masters' => array(
						'id' => $diagnosis_master_id,
						'diagnosis_control_id' => '20',
						'participant_id' => $participant_id,
						'primary_id' => $diagnosis_master_id,
//						'parent_id' => '**TODO**',
						'dx_date' => $dx_date,
						'dx_date_accuracy' => $dx_date_accuracy,
						'age_at_dx' => '**TODO**',							
						'icd10_code' => $icd10_code,
						'morphology' => $morphology,
						'clinical_stage_summary' => '',
						'qc_lady_clinical_stage_summary_at_dx' => '',
						'survival_time_months' => '**TODO**'),
					'qc_lady_dxd_breasts' => array(
						'diagnosis_master_id' => $diagnosis_master_id,
						'laterality' => $laterality));
				if(isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'])) Config::$summary_msg[$summary_msg_title]['@@WARNING@@']['Bilateral tumor to confirm'][] = "2 different diagnoses will be created, check if just one bilateral has to be created. See JGH# $jgh_nbr line $excel_line_counter";
				if(isset(Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$laterality])) echo('ERR 276 287362876 328 : line : '.$excel_line_counter.'<br>');
				Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$laterality] = $dx_data;
				if(!in_array($new_line_data['Grade CIM-O'], array('1','2','3',''))) {
					Config::$summary_msg[$summary_msg_title]['@@ERROR@@']['Grade'][] = "See JGH# $jgh_nbr line. Grade ".$new_line_data['Grade CIM-O']." is not supported.";
				} else {
					Config::$participants[$jgh_nbr]['diagnoses_data'][$new_line_data['Date du diagnostic']][$icd10_code.$morphology]['Diagnosis'][$laterality]['tmp_grade'] = $new_line_data['Grade CIM-O'];
				}
			}
		}
	} 
}

