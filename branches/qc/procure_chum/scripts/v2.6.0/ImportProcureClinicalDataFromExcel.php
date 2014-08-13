<?php

/*
 * Import PROCURE clinical data from Chantale file
 * To run after icm_to_procure_sardo_data_migration.php
 */



//==============================================================================================
// Variables
//==============================================================================================

$is_server = false;

$file_path = "C:\_Perso\Server\procure_chum\data\Donnees cliniques CHUM 20140805.3.xls";
//$file_path = "C:\_Perso\Server\procure_chum\data\celltest.xls";
if($is_server) $file_path = "/ch06chuma6134/Export_CRCHUM.XML";

global $import_summary;
$import_summary = array();

global $db_schema;

$is_server = true;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_charset		= "utf8";
$db_schema	= "procurechum";

if($is_server) {
	$db_ip			= "localhost";
	$db_port 		= "";
	$db_user 		= "root";
	$db_pwd			= "";
	$db_charset		= "utf8";
	$db_schema		= "procurechum";
}

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed 2");


//==============================================================================================
//TRUNCATE
//==============================================================================================

$truncate_queries = array(
	'TRUNCATE procure_ed_lab_diagnostic_information_worksheets;',
	'TRUNCATE procure_ed_lab_diagnostic_information_worksheets_revs;',
	'DELETE FROM event_masters WHERE event_control_id = 52;',
	'DELETE FROM event_masters_revs WHERE event_control_id = 52;');
foreach($truncate_queries as $query) mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

//==============================================================================================
//EXCEL FILE
//==============================================================================================

pr('Attention prostatectomie doublée: excemple patient ps1p0019');

require_once 'Excel/reader.php';
$XlsReader = new Spreadsheet_Excel_Reader();
$XlsReader->read($file_path);
foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;

$headers = array();
$line_counter = 0;
$participant_ids = array();
foreach($XlsReader->sheets[$sheets_nbr['Donnees cliniques CHUM']]['cells'] as $line => $new_line) {
	$line_counter++;
	if($line_counter == 6) {
		$headers = $new_line;
	} else if($line_counter > 6) {
		$new_line_data = formatNewLineData($headers, $new_line);
		$excel_code_barre = str_replace(array('non', 'NON', ' ', "\n"), array('', '', '', ''), $new_line_data['V01::Code du Patient']);
		$no_labo = $new_line_data['V01::Numéro Atim au CHUM'];
		if($excel_code_barre.$no_labo) {
			$patient_identification_msg = "See line $line_counter NoLabo : $no_labo".(empty($excel_code_barre)? '' : " & Code-Barre : $excel_code_barre");
			$query = "SELECT p.id, p.participant_identifier FROM participants p INNER JOIN misc_identifiers id ON id.participant_id = p.id AND id.deleted <> 1
				WHERE id.misc_identifier_control_id = 5 AND id.identifier_value = '$no_labo'";	
			$query_res = customQuery($query, __LINE__);
			if($query_res->num_rows) {				
				$res = mysqli_fetch_assoc($query_res);
				$participant_id = $res['id'];
				$atim_code_barre = $res['participant_identifier'];
				$formatted_excel_code_barre = str_replace('-', '', $excel_code_barre);
				if(preg_match('/^(P){0,1}S1[pP][0]*([1-9][0-9]*)$/',$formatted_excel_code_barre, $matches)) {
					$formatted_excel_code_barre = 'PS1P'.str_pad($matches[2], 4, "0", STR_PAD_LEFT);
				}
				if(in_array($participant_id, $participant_ids)) die('ERR 23876 28763287');
				$participant_ids[] = $participant_id;
				if(empty($formatted_excel_code_barre)) {
					$import_summary['WARNING']["Excel code-barre is missing. Match done based on nolabo only."][] = "ATiM code barre = $atim_code_barre. ".$patient_identification_msg;
					loadPatientData($participant_id, $new_line_data, $patient_identification_msg, $atim_code_barre);
				} else if($atim_code_barre == $formatted_excel_code_barre) {
					loadPatientData($participant_id, $new_line_data, $patient_identification_msg, $atim_code_barre);
				} else {
					$import_summary['ERROR']["Code-Barre error"][] = "$formatted_excel_code_barre (Excel) != $atim_code_barre (ATiM).".$patient_identification_msg;
				}
			} else {
				$import_summary['ERROR']["Unable to find participant in ATiM based on NoLabo (only)"][] = $patient_identification_msg;
			}
		}
	}
}

foreach(array('procure_ed_lab_diagnostic_information_worksheets' => 'biopsy_pre_surgery_date') as $tablename => $date_field) {
	$query = "UPDATE $tablename SET $date_field = NULL WHERE $date_field LIKE '%0000%';";
	$query_res = customQuery($query, __LINE__);
	$query = "UPDATE ".$tablename."_revs SET $date_field = NULL WHERE $date_field LIKE '%0000%';";
	$query_res = customQuery($query, __LINE__);
}

//=================================================================================================================================
// Data Management Functions
//=================================================================================================================================


function loadPatientData($participant_id, $new_line_data, $patient_identification_msg, $atim_code_barre) {
	$prostatectomy_date = getProstatectomyDate($participant_id, $new_line_data, $patient_identification_msg);
	$all_atim_aps = getAtimAps($participant_id, $new_line_data, $patient_identification_msg, $prostatectomy_date);
	$all_atim_biopsies = getAtimBiopsies($participant_id, $new_line_data, $patient_identification_msg, $prostatectomy_date);
		
	createDiagnosticInformationWorksheet($participant_id, $new_line_data, $patient_identification_msg, $atim_code_barre, $all_atim_aps, $all_atim_biopsies, $prostatectomy_date);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

function getProstatectomyDate($participant_id, $new_line_data, $patient_identification_msg) {
	global $import_summary;
	$query = "SELECT start_date, start_date_accuracy 
		FROM treatment_masters tm 
		INNER JOIN procure_txd_followup_worksheet_treatments td
		WHERE tm.id = td.treatment_master_id AND tm.deleted <> 1 AND tm.participant_id = $participant_id AND treatment_type = 'other treatment' AND type LIKE '%prostatectomie%' ORDER BY start_date ASC;";
	$query_res = customQuery($query, __LINE__);
	if($query_res->num_rows) {
		if($query_res->num_rows > 1) $import_summary['WARNING']["More than one prostatectomy in ATiM"][] = $patient_identification_msg;
		$res = mysqli_fetch_assoc($query_res);
		return array('start_date' => $res['start_date'], 'start_date_accuracy' => $res['start_date_accuracy']);		
	}
	return null;
}

function getAtimAps($participant_id, $new_line_data, $patient_identification_msg, $prostatectomy_date) {
	//procure_ed_clinical_followup_worksheet_aps event_control_id = 54
	$psa = array();
	$query = "SELECT em.id AS event_master_id, em.event_date, em.event_date_accuracy, ed.total_ngml
		FROM event_masters em
		INNER JOIN procure_ed_clinical_followup_worksheet_aps ed ON ed.event_master_id = em.id
		WHERE em.participant_id = $participant_id AND em.event_control_id = 54 AND em.deleted <> 1 
		ORDER BY em.event_date DESC";
	$query_res = customQuery($query, __LINE__);
	$psa_post_surgery_found = false;
	while($res = mysqli_fetch_assoc($query_res)) {
		$res['excel_event_date'] = fromatAtimDateToExcelDate($res['event_date'], $res['event_date_accuracy']);
		if(!$psa_post_surgery_found && $prostatectomy_date['start_date'] > $res['event_date']) {
			$psa_post_surgery_found = true;
			$psa['pre-prostatectomy'] = $res;
		} else {
			$psa[] = $res;
		}
	}
	return $psa;
}

function getAtimBiopsies($participant_id, $new_line_data, $patient_identification_msg, $prostatectomy_date) {
	global $import_summary;
	$biopsies = array();
	$atim_biopsies_dates = array();
	//procure_ed_clinical_followup_worksheet_clinical_events event_control_id = 55
	$query = "SELECT em.id AS event_master_id, em.event_date, em.event_date_accuracy, em.event_summary
		FROM event_masters em INNER JOIN procure_ed_clinical_followup_worksheet_clinical_events ed ON ed.event_master_id = em.id
		WHERE em.deleted <> 1 AND em.event_control_id = 55 AND em.participant_id = '$participant_id' AND ed.type = 'other' AND event_summary LIKE 'biopsie de la prostate%'
		ORDER BY em.event_date DESC";
	$query_res = customQuery($query, __LINE__);
	$biopsy_post_surgery_found = false;
	$key = 0;
	while($res = mysqli_fetch_assoc($query_res)) {
		$res['excel_event_date'] = fromatAtimDateToExcelDate($res['event_date'], $res['event_date_accuracy']);
		if(!$biopsy_post_surgery_found && $prostatectomy_date['start_date'] > $res['event_date']) {
			$biopsy_post_surgery_found = true;
			$biopsies['pre-prostatectomy'] = $res;
		} else {
			$biopsies[] = $res;
		}
		$atim_biopsies_dates[] = $res['excel_event_date'];
	}
	//Compare ATiM list to excel list
	if(preg_match_all('/[0-9]{2}\-[0-9]{2}\-[0-9]{4}/', $new_line_data['V0::Biopsie antérieure::Si oui; Date'], $excel_biopsies)) {
		foreach($excel_biopsies[0] as $new_biopsy_excel_date) {
			if(!in_array($new_biopsy_excel_date, $atim_biopsies_dates)) $import_summary['ERROR']["Missing Excel Biopsy in ATiM (sardo). To validate and create (if required) both in SARDO and ATiM manually"][] = "Biopsy on $new_biopsy_excel_date. ".$patient_identification_msg;
		}
	}
	return $biopsies;
}




function createDiagnosticInformationWorksheet($participant_id, $new_line_data, $patient_identification_msg, $atim_code_barre, &$all_atim_aps, &$all_atim_biopsies, $prostatectomy_date) {
	//event_control_id = 52 - procure_ed_diagnostic_information_worksheet
	global $import_summary;
	
	$event_master_data = array('procure_form_identification' => "$atim_code_barre V0 -FBP1", 'participant_id' => $participant_id, 'event_control_id' => 52);
	$event_detail_data = array();
	
	//PSA
	
	$excel_aps_pre_surgery_date = str_replace(array('ND','?'), array('',''), $new_line_data['V0::APS pré-chirurgie (ng/mL)::Date']);
	if(strlen($excel_aps_pre_surgery_date) && !preg_match('/^([0-9]{2}\-){0,2}[0-9]{4}$/', $excel_aps_pre_surgery_date)) {
		$import_summary['ERROR']["Excel 'APS pré-chirurgie' date format error"][] = "Value = [".$excel_aps_pre_surgery_date."]. ".$patient_identification_msg;
		$excel_aps_pre_surgery_date = '';
	}
	$excel_aps_pre_surgery_total_ng_ml = str_replace(array('ND','?',','), array('','','.'), $new_line_data['V0::APS pré-chirurgie (ng/mL)::Total APS']);
	if(strlen($excel_aps_pre_surgery_total_ng_ml) && !preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $excel_aps_pre_surgery_total_ng_ml)) {
		$import_summary['ERROR']["Excel 'APS pré-chirurgie total' date format error"][] = "Value = [".$excel_aps_pre_surgery_total_ng_ml."]. ".$patient_identification_msg;
		$excel_aps_pre_surgery_total_ng_ml = '';
	}
	$excel_aps_pre_surgery_free_ng_ml = str_replace(array('ND','?',','), array('','','.'), $new_line_data['V0::APS pré-chirurgie (ng/mL)::Libre']);
	if(strlen($excel_aps_pre_surgery_free_ng_ml) && !preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $excel_aps_pre_surgery_free_ng_ml)) {
		$import_summary['ERROR']["Excel 'APS pré-chirurgie libre' date format error"][] = "Value = [".$excel_aps_pre_surgery_free_ng_ml."]. ".$patient_identification_msg;
		$excel_aps_pre_surgery_free_ng_ml = '';
	}
	if($excel_aps_pre_surgery_date) {
		if(array_key_exists('pre-prostatectomy', $all_atim_aps)) {
			// Aps pre-prostactectomy defined in ATiM
			if($all_atim_aps['pre-prostatectomy']['excel_event_date'] == $excel_aps_pre_surgery_date) {
				if($all_atim_aps['pre-prostatectomy']['total_ngml'] == $excel_aps_pre_surgery_total_ng_ml) {
					//Exact match nothing to do	(ATiM APS preop defined + date & value both defined in atim and excel and equal)	
					$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
					$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
					$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
					$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
				} else {
					if(!strlen($excel_aps_pre_surgery_total_ng_ml)) {
						//ATiM APS preop defined + same date but no value in excel
						$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "No APS pre-surgery total defined into excel: Used atim (sardo) value (".$all_atim_aps['pre-prostatectomy']['total_ngml'].").";
						$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
						$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
						$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
						$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
					} else if((abs($excel_aps_pre_surgery_total_ng_ml-$all_atim_aps['pre-prostatectomy']['total_ngml'])) <= 0.201) {
						//ATiM APS preop defined + same date & value in excel - value in ATiM < 0.201
						$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "APS pre-surgery total are different in excel and atim (diff <=0.2): Used atim (sardo) value (".$all_atim_aps['pre-prostatectomy']['total_ngml'].").";
						$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
						$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
						$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
						$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
					} else {
						$import_summary['ERROR']['ATiM APS pre-prostatectomy value different than excel APS pre-prostatectomy value'][] = "ATiM APS = '".$all_atim_aps['pre-prostatectomy']['total_ngml']."' / Excel APS = '$excel_aps_pre_surgery_total_ng_ml'. No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
					}
				}
			} else {
				// Date different in ATiM and excel
				if($all_atim_aps['pre-prostatectomy']['total_ngml'] == $excel_aps_pre_surgery_total_ng_ml) { 
					$import_summary['ERROR']['ATiM APS-PreProstatectomy date different than excel APS-PreProstatectomy date but both values are identical'][] = "ATiM APS date = '".$all_atim_aps['pre-prostatectomy']['excel_event_date']."' / Excel APS date = '$excel_aps_pre_surgery_date'. No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
				} else {
					$import_summary['ERROR']['ATiM APS-PreProstatectomy date different than excel APS-PreProstatectomy date (and different values)'][] = "ATiM APS date = '".$all_atim_aps['pre-prostatectomy']['excel_event_date']."' / Excel APS date = '$excel_aps_pre_surgery_date' & ATiM APS = '".$all_atim_aps['pre-prostatectomy']['total_ngml']."' / Excel APS = '$excel_aps_pre_surgery_total_ng_ml'. No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
				}
			}
		} else {
			// Aps pre-prostactectomy not defined in ATiM
			$key_of_aps_preop = null;
			foreach($all_atim_aps as $key => $atim_aps) {
				if($atim_aps['excel_event_date'] == $excel_aps_pre_surgery_date) $key_of_aps_preop = $key;
				
			}	
			if($key_of_aps_preop) {
				if($all_atim_aps[$key_of_aps_preop]['total_ngml'] == $excel_aps_pre_surgery_total_ng_ml) { 
					if($prostatectomy_date) {
						die('Case to support 872979323. '.$patient_identification_msg);
					} else {
						// No prostatectomy defined into ATiM so no APS preop is defined but an aps in atim matches an aps in excel checking both both date and value
						$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "APS pre-surgery date from excel matched an APS of ATiM but this one was not flagged as 'pre-surgery' because no prostatectomy event has been created into ATiM (based on SARDO Data). Used this date as pre-surgery aps.";
						$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps[$key_of_aps_preop]['event_date'];
						$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps[$key_of_aps_preop]['event_date_accuracy'];
						$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps[$key_of_aps_preop]['total_ngml'];
						$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
					}
				} else {
					die('Case to support 872979327 : no atim aps pre-prostatectomy found in atim but atim aps matches excel aps (same date same but diff value). '.$patient_identification_msg);		
				}
			} else {
				$import_summary['ERROR']['Not enough information to create the APS pre-prostatectomy into ATiM (no sardo prostatectomy data + no match on aps date)'][] = "No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;	
			}	
		}		
	} else if($excel_aps_pre_surgery_total_ng_ml) {
		//Only excel aps value defined
		if(array_key_exists('pre-prostatectomy', $all_atim_aps)) {
			if($all_atim_aps['pre-prostatectomy']['total_ngml'] == $excel_aps_pre_surgery_total_ng_ml) {
				// ATiM APS preop defined, no aps date in excel but aps value in excel matches ATiM APS preop value
				$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "No APS pre-surgery date in excel. Used APS pre-surgery date defined into ATiM (sardo) (".$all_atim_aps['pre-prostatectomy']['event_date'].").";
				$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
				$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
				$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
				$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
			} else {
				$import_summary['ERROR']['ATiM APS pre-prostatectomy value different than excel APS pre-prostatectomy value (no excel date too)'][] = "ATiM APS value = '".$all_atim_aps['pre-prostatectomy']['total_ngml']."' / Excel APS value = '$excel_aps_pre_surgery_total_ng_ml'. No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
			}
		} else {
			$import_summary['ERROR']['Not enough information to create the APS pre-prostatectomy into ATiM (no sardo prostatectomy data + no match on aps data)'][] = "No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
		}
	} else if(array_key_exists('pre-prostatectomy', $all_atim_aps)) {
		// ATiM APS preop defined, no APS preop in excel
		$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "No APS pre-surgery defined in excel: Used atim (sardo) value (".$all_atim_aps['pre-prostatectomy']['total_ngml'].").";
		$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
		$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
		$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
		$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
	}
	
	// Biopsy
	
	if(preg_match_all('/[0-9]{2}\-[0-9]{2}\-[0-9]{4}/', $new_line_data['V0::Biopsie antérieure::Si oui; Date'], $excel_biopsies)) {
		//Note: biopsies missing in ATiM will be flagged in function getAtimBiopsies().
		$event_detail_data['biopsies_before'] = 'y';
	} else if($prostatectomy_date) {
		foreach($all_atim_biopsies as $key => $new_atim_biopsy) {
			if($key != 'pre-prostatectomy' && $new_atim_biopsy['event_date'] < $prostatectomy_date['start_date']) {
				$event_detail_data['biopsies_before'] = 'y';
				$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "Set flag 'Did the patient have biopsies before' (Diagnostic Information Worksheet) to 'yes' based on ATiM (SARDO) data.";
			}
		}
	}
	if($new_line_data['V0::Biopsie pré-chirurgie::Date']) {
		if(!preg_match('/^([0-9]{2}\-){0,2}[0-9]{4}$/', $new_line_data['V0::Biopsie pré-chirurgie::Date'])) {
			$import_summary['ERROR']["Excel 'Biopsy' date format error"][] = "Value = [".$new_line_data['V0::Biopsie pré-chirurgie::Date']."]. ".$patient_identification_msg;
		} else {
			if(array_key_exists('pre-prostatectomy', $all_atim_biopsies)) {
				if($all_atim_biopsies['pre-prostatectomy']['excel_event_date'] != $new_line_data['V0::Biopsie pré-chirurgie::Date']) {
					$import_summary['ERROR']['ATiM pre-prostatectomy biopsy date different than pre-prostatectomy biopsy date in excel'][] = "ATiM date = '".$all_atim_biopsies['pre-prostatectomy']['excel_event_date']."' / Excel date = '".$new_line_data['V0::Biopsie pré-chirurgie::Date']."'. No pre-biopsy date will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
				} else {
					$event_detail_data['biopsy_pre_surgery_date'] = $all_atim_biopsies['pre-prostatectomy']['event_date'];
					$event_detail_data['biopsy_pre_surgery_date_accuracy'] = $all_atim_biopsies['pre-prostatectomy']['event_date_accuracy'];
				}
			} else {
				if($prostatectomy_date) {
					die('Case to support 8729739324. '.$patient_identification_msg);
				} else if(empty($all_atim_biopsies)) {
					$import_summary['ERROR']["Missing Excel Biopsy in ATiM (sardo). To validate and create (if required) both in SARDO and ATiM manually"][] = "Biopsy on ".$new_line_data['V0::Biopsie pré-chirurgie::Date'].". ".$patient_identification_msg;
				} else {
					$match_done = false;
					foreach($all_atim_biopsies as $new_biopsy) {
						if($new_biopsy['excel_event_date'] == $new_line_data['V0::Biopsie pré-chirurgie::Date']) $match_done = true;
					}
					if($match_done) {
						$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "Biopsy pre-surgery date from excel matched a biopsy date of ATiM but this one was not flagged as 'pre-surgery' because no prostatectomy event has been created into ATiM (based on SARDO Data). Used this date as pre-surgery biopsy.";
						$event_detail_data['biopsy_pre_surgery_date'] = $new_line_data['V0::Biopsie pré-chirurgie::Date'];
						$event_detail_data['biopsy_pre_surgery_date_accuracy'] = 'c';
					} else {
						pr($all_atim_biopsies);
						pr($new_line_data['V0::Biopsie pré-chirurgie::Date']);
						die('Case to support 334222324. '.$patient_identification_msg);
					}
				}
			}
		}
	} else if(array_key_exists('pre-prostatectomy', $all_atim_biopsies)) {
		$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "No Biopsy pre-surgery defined in excel: Used atim (sardo) value (".$all_atim_biopsies['pre-prostatectomy']['event_date'].").";
		$event_detail_data['biopsy_pre_surgery_date'] = $all_atim_biopsies['pre-prostatectomy']['event_date'];
		$event_detail_data['biopsy_pre_surgery_date_accuracy'] = $all_atim_biopsies['pre-prostatectomy']['event_date_accuracy'];
	}
	
	// Cores
	
	$excel_field = 'V0::Biopsie pré-chirurgie::Nombre total de zones prélevées';
	$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier'), array('', '', '', '', ''), $new_line_data[$excel_field]);
	if(strlen($new_line_data[$excel_field])) {
		if(preg_match('/^[0-9]+$/', $new_line_data[$excel_field])) {
			$event_detail_data['collected_cores_nbr'] = $new_line_data[$excel_field];
		} else {
			$import_summary['ERROR']["Number of collected cores format error"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
		}
	}
	$excel_field = 'V0::Biopsie pré-chirurgie::Nombre de zones atteintes';
	$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier'), array('', '', '', '', ''), $new_line_data[$excel_field]);
	if(strlen($new_line_data[$excel_field])) {
		if(preg_match('/^[0-9]+$/', $new_line_data[$excel_field])) {
			$event_detail_data['nbr_of_cores_with_cancer'] = $new_line_data[$excel_field];
		} else {
			$import_summary['ERROR']["Number of cores with cancer format error"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
		}
	}
	$excel_field = 'V0::Biopsie pré-chirurgie::Localisation des zones atteintes (AG, AD, MG, MD, BG, BD, TG, TD, VG, VD, ND)';
	$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier'), array('', '', '', '', ''), $new_line_data[$excel_field]);
	$event_detail_data['affected_core_localisation'] = $new_line_data[$excel_field];

	// Histologic Grade
	
	$def = array(
		array('excel_field_1' => 'V0::Biopsie pré-chirurgie::Gleason le plus fréquent de la biopsie::primaire', 
			'excel_field_2' => 'V0::Biopsie pré-chirurgie::Gleason le plus élevé de la biopsie::primaire',
			'atim_field' => 'histologic_grade_primary_pattern', 
			'values' => array('1','2','3','4','5')),
		array('excel_field_1' => 'V0::Biopsie pré-chirurgie::Gleason le plus fréquent de la biopsie::secondaire', 
			'excel_field_2' => 'V0::Biopsie pré-chirurgie::Gleason le plus élevé de la biopsie::secondaire',
			'atim_field' => 'histologic_grade_secondary_pattern', 
			'values' => array('1','2','3','4','5')),
		array('excel_field_1' => 'V0::Biopsie pré-chirurgie::Gleason le plus fréquent de la biopsie::Total', 
			'excel_field_2' => 'V0::Biopsie pré-chirurgie::Gleason le plus élevé de la biopsie::Total',
			'atim_field' => 'histologic_grade_gleason_total', 
			'values' => array('6','7','8','9','10')));
	foreach($def as $field_def) {
		$excel_field = $field_def['excel_field_1'];
		$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier', ',00', '0', 'NA'), array('', '', '', '', '', '', '', ''), $new_line_data[$excel_field]);
		if(strlen($new_line_data[$excel_field])) {
			if(in_array($new_line_data[$excel_field], $field_def['values'])) {
				$event_detail_data[$field_def['atim_field']] = $new_line_data[$excel_field];
			} else {
				$import_summary['ERROR'][$field_def['atim_field']." format error"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
			}
		} else {
			$excel_field = $field_def['excel_field_2'];
			$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier'), array('', '', '', '', ''), $new_line_data[$excel_field]);
			if(strlen($new_line_data[$excel_field])) {
				if(in_array($new_line_data[$excel_field], $field_def['values'])) {
					$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "Used value of field [".str_replace('V0::Biopsie pré-chirurgie::', '', $field_def['excel_field_2'])."] instead [".str_replace('V0::Biopsie pré-chirurgie::', '', $field_def['excel_field_1'])."]. Last one was empty.";
					$event_detail_data[$field_def['atim_field']] = $new_line_data[$excel_field];
				} else {
					$import_summary['ERROR'][$field_def['atim_field']." format error"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
				}
			}
		}
	}
	$excel_field = 'V0::Biopsie pré-chirurgie::Gleason le plus élevé de la biopsie::Total';
	$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier'), array('', '', '', '', ''), $new_line_data[$excel_field]);
	if(strlen($new_line_data[$excel_field])) $event_detail_data['highest_gleason_score_observed'] = $new_line_data[$excel_field];
	$excel_field = "V0::Biopsie pré-chirurgie::% d'atteinte du Gleason le plus élevé parmi les prélèvements";
	$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier', '%'), array('', '', '', '', '', ''), $new_line_data[$excel_field]);
	if(strlen($new_line_data[$excel_field])) {
		if(preg_match('/^[0-9]+$/', $new_line_data[$excel_field])) {
			$event_detail_data['highest_gleason_score_percentage'] = $new_line_data[$excel_field];
		} else {
			$import_summary['ERROR']["Highest gleason score percentage format error"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
		}
	}
	
	// Data creation
	
	if($event_detail_data) {
		$event_master_id = customInsert($event_master_data, 'event_masters', __LINE__, false, true);
		$event_detail_data['event_master_id'] = $event_master_id;
		customInsert($event_detail_data, 'procure_ed_lab_diagnostic_information_worksheets', __LINE__, true, true);		
	} else {
		$import_summary['MESSAGE']["Patient $atim_code_barre"][] = "No Diagnostic Information Worksheet created.";
	}
}









// Import Summary
//$import_summary['Process']['Message']["Updated participants counter"][] = $updated_participants_counter;
//$import_summary['Process']['Message']["Date"][] = $import_date;
pr($import_summary);
/*foreach($import_summary as $data_type => $data_1) {
	foreach($data_1 as $message_type => $data_2) {
		foreach($data_2 as $message => $data_3) {
			foreach($data_3 as $details) {
				$data = array('data_type' => $data_type, 'message_type' => $message_type, 'message' => $message, 'details' => $details);
				foreach($data as $key => $value) if(strlen($value)) $data[$key] = "'".str_replace("'", "''", $value)."'";
				customQuery("INSERT INTO sardo_import_summary (".implode(", ", array_keys($data)).") VALUES (".implode(", ", array_values($data)).")", __LINE__, true);
			}
		}
	}
}*/

echo "Process Done";

//=================================================================================================================================
// System Functions
//=================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function formatNewLineData($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[utf8_encode($field)] = utf8_encode($data[$key]);
		} else {
			$line_data[utf8_encode($field)] = '';
		}
	}
	return $line_data;
}

function importDie($msg, $rollbak = true) {
	if($rollbak) {
		//TODO manage commit rollback
	}
	die($msg);
}

function customQuery($query, $line, $insert = false) {
	global $db_connection;
	$query_res = mysqli_query($db_connection, $query) or importDie("QUERY ERROR line $line [".mysqli_error($db_connection)."] : $query");
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}
	
function customInsert($data, $table_name, $line, $is_detail_table = false, $insert_into_revs = false) {
	global $import_date;
	global $import_by;
	
	$data_to_insert = array();
	foreach($data as $key => $value) {
		if(strlen(str_replace(array(' ', "\n"), array('', ''), $value))) $data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
	}
	// Insert into table
	$table_system_data = $is_detail_table? array() : array("created" => "'$import_date'", "created_by" => "'$import_by'", "modified" => "'$import_date'", "modified_by" => "'$import_by'");
	$insert_arr = array_merge($data_to_insert, $table_system_data);
	$record_id = customQuery("INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $line, true);
	// Insert into revs table
	if($insert_into_revs) {
		$revs_table_system_data = $is_detail_table? array('version_created' => "'$import_date'") : array('id' => "$record_id", 'version_created' => "'$import_date'");
		$insert_arr = array_merge($data_to_insert, $revs_table_system_data);
		customQuery("INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $line, true);
	}
	
	return $record_id;
}	

function fromatAtimDateToExcelDate($date, $accuracy) {
	if($date) {
		if(!preg_match('/^([0-9]{4})-([0-9]{2})-([0-9]{2})$/', $date, $res)) die('ERR 73772687628632 '.$date);
		switch($accuracy) {
			case 'y':
			case 'm':
				return $res[1];
			case 'd':
				return $res[2].'-'.$res[1];
			default:
				return $res[3].'-'.$res[2].'-'.$res[1];
		}
	}
	return '';	
}

?>