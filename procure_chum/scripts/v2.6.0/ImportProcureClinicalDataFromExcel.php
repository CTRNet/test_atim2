<?php

/*
 * Import PROCURE clinical data from Chantale file
 * To run after icm_to_procure_sardo_data_migration.php
 */

//==============================================================================================
// Variables
//==============================================================================================

$is_server = true;

$file_name = 'Donnees cliniques CHUM version vers ATIM final formatted_20140822.xls';
$file_path = 'C:\\_Perso\\Server\\procure_chum\\data\\'.$file_name;
if($is_server) $file_path = '/ATiM/atim-procure/MigrationProcureExcel/'.$file_name;
		
global $import_summary;
$import_summary = array();

global $db_schema;

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
	$db_schema		= "atimprocureprod";
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
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed 2 $db_user $db_schema ");

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE username = 'Migration';", __LINE__);
if($query_res->num_rows != 1) importDie('ERR : No user Migration!');
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));


echo "<br><br><FONT COLOR=\"blue\" >
=====================================================================<br>
PROCURE - Clinical Data : Excel ($file_name) to ATiM<br>
$import_date<br>
=====================================================================</FONT><br>";

//==============================================================================================
//TRUNCATE
//==============================================================================================

$truncate_queries = array(
	'TRUNCATE procure_ed_lab_diagnostic_information_worksheets;',
	'TRUNCATE procure_ed_lab_diagnostic_information_worksheets_revs;',
	'DELETE FROM event_masters WHERE event_control_id = 52;',
	'DELETE FROM event_masters_revs WHERE event_control_id = 52;',
		
	'TRUNCATE procure_ed_lab_pathologies;',
	'TRUNCATE procure_ed_lab_pathologies_revs;',
	'DELETE FROM event_masters WHERE event_control_id = 51;',
	'DELETE FROM event_masters_revs WHERE event_control_id = 51;',

	"UPDATE event_masters SET procure_form_identification = 'n/a' WHERE event_control_id = 54;",	//APS
	"UPDATE event_masters_revs SET procure_form_identification = 'n/a' WHERE event_control_id = 54;",	//APS
	"UPDATE procure_ed_clinical_followup_worksheet_aps SET followup_event_master_id = null;",
	"UPDATE procure_ed_clinical_followup_worksheet_aps_revs SET followup_event_master_id = null;",
	
	"UPDATE event_masters SET procure_form_identification = 'n/a' WHERE event_control_id = 55;",	//Clinical Event
	"UPDATE event_masters_revs SET procure_form_identification = 'n/a' WHERE event_control_id = 55;",	//Clinical Event
	"UPDATE procure_ed_clinical_followup_worksheet_clinical_events SET followup_event_master_id = null;",
	"UPDATE procure_ed_clinical_followup_worksheet_clinical_events_revs SET followup_event_master_id = null;",
	
	"DELETE FROM procure_ed_clinical_followup_worksheet_aps WHERE event_master_id IN (SELECT id FROM event_masters WHERE event_control_id = 54 AND event_summary LIKE '%Created from excel file on%' AND created_by = $import_by);",
	"DELETE FROM procure_ed_clinical_followup_worksheet_aps_revs WHERE event_master_id IN (SELECT id FROM event_masters WHERE event_control_id = 54 AND event_summary LIKE '%Created from excel file on%' AND created_by = $import_by);",
	"DELETE FROM event_masters_revs WHERE id IN (SELECT id FROM event_masters WHERE event_control_id = 54 AND event_summary LIKE '%Created from excel file on%' AND created_by = $import_by);",
	"DELETE FROM event_masters WHERE event_control_id = 54 AND event_summary LIKE '%Created from excel file on%' AND created_by = $import_by;",
	
	"UPDATE treatment_masters SET procure_form_identification = 'n/a' WHERE treatment_control_id = 6;",
	"UPDATE treatment_masters_revs SET procure_form_identification = 'n/a' WHERE treatment_control_id = 6;",
	"UPDATE procure_txd_followup_worksheet_treatments SET followup_event_master_id = null;",
	"UPDATE procure_txd_followup_worksheet_treatments SET followup_event_master_id = null;",
	'UPDATE procure_txd_followup_worksheet_treatments SET dosage = null;',
	'UPDATE procure_txd_followup_worksheet_treatments_revs SET dosage = null;',

	"DELETE FROM procure_txd_followup_worksheet_treatments WHERE treatment_type IN ('curietherapy', 'aborted prostatectomy');",
	"DELETE FROM procure_txd_followup_worksheet_treatments_revs WHERE treatment_type IN ('curietherapy', 'aborted prostatectomy');",
	"DELETE FROM treatment_masters WHERE id NOT IN (SELECT treatment_master_id FROM procure_txd_followup_worksheet_treatments) AND treatment_control_id = 6;",
	"DELETE FROM treatment_masters_revs WHERE id NOT IN (SELECT treatment_master_id FROM procure_txd_followup_worksheet_treatments) AND treatment_control_id = 6;",
		
	'TRUNCATE procure_ed_clinical_followup_worksheets;',
	'TRUNCATE procure_ed_clinical_followup_worksheets_revs;',
	'DELETE FROM event_masters WHERE event_control_id = 53;',
	'DELETE FROM event_masters_revs WHERE event_control_id = 53;',
	
	'TRUNCATE procure_txe_medications;',
	'TRUNCATE procure_txe_medications_revs;',
	'DELETE FROM treatment_extend_masters WHERE treatment_extend_control_id = 3;',
	'DELETE FROM treatment_extend_masters_revs WHERE treatment_extend_control_id = 3;',
	'TRUNCATE procure_txd_medications;',
	'TRUNCATE procure_txd_medications_revs;',
	'DELETE FROM treatment_masters WHERE treatment_control_id = 5;',
	'DELETE FROM treatment_masters_revs WHERE treatment_control_id = 5;'
);
for($i=2; $i<10; $i++) {
	$truncate_queries[] = "UPDATE event_masters SET event_summary = REPLACE(event_summary, 'Attached to the visit V0$i by the migration process. ','');";
	$truncate_queries[] = "UPDATE event_masters_revs SET event_summary = REPLACE(event_summary, 'Attached to the visit V0$i by the migration process. ','');";
	$truncate_queries[] = "UPDATE treatment_masters SET notes = REPLACE(notes, 'Attached to the visit V0$i by the migration process','');";
	$truncate_queries[] = "UPDATE treatment_masters_revs SET notes = REPLACE(notes, 'Attached to the visit V0$i by the migration process','');";
}
foreach($truncate_queries as $query) customQuery($query, __LINE__);

//==============================================================================================
//MAIN
//==============================================================================================

global $atim_drugs;
$atim_drugs = getATiMDrugs();

require_once 'Excel/reader.php';
$XlsReader = new Spreadsheet_Excel_Reader();
$XlsReader->read($file_path);
foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;

//TODO set to empty
$tmp_studied_lines = array();

// MAIN DATA
$headers = array();
$line_counter = 0;
$participant_ids = array();
$no_labos_to_participants_session_data = array();
foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Données cliniques CHUM V0 V01')]]['cells'] as $line => $new_line) {
	$line_counter++;
	if($line_counter == 6) {
		$headers = $new_line;
	} else if($line_counter > 6) {
		if(empty($tmp_studied_lines) || in_array($line_counter, $tmp_studied_lines)) {
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
					if(in_array($no_labo, $no_labos_to_participants_session_data)) die('ERR 23876 28763288');
					$no_labos_to_participants_session_data[$no_labo] = array(
							'participant_id' => $participant_id,
							'atim_code_barre' => $atim_code_barre,
							'patient_identification_msg' => $patient_identification_msg,
							'all_atim_aps' => array(),
							'visits_limits' => array(),
							'atim_clinical_events' => null,
							'atim_treatments' => null
					);
					if(empty($formatted_excel_code_barre)) {
						$import_summary['Participant Detection']['WARNING']["Excel code-barre is missing. Match done based on nolabo only."][] = "ATiM code barre = $atim_code_barre. ".$patient_identification_msg;
						loadV0V01PatientData($no_labos_to_participants_session_data[$no_labo], $new_line_data);
					} else if($atim_code_barre == $formatted_excel_code_barre) {
						loadV0V01PatientData($no_labos_to_participants_session_data[$no_labo], $new_line_data);
					} else {
						$import_summary['Participant Detection']['ERROR']["Code-Barre error"][] = "$formatted_excel_code_barre (Excel) != $atim_code_barre (ATiM).".$patient_identification_msg;
					}
				} else {
					$import_summary['Participant Detection']['ERROR']["Unable to find participant in ATiM based on NoLabo (only)"][] = $patient_identification_msg;
				}
			}
		}
	}
}

// FOLLOW-UP

for($i=2; $i<10; $i++) {
	$visit = "V0$i";
	$headers = array();
	$line_counter = 0;
	foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('Données cliniques CHUM '.$visit)]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 6) {
			$headers = $new_line;
		} else if($line_counter > 6) {
			if(empty($tmp_studied_lines) || in_array($line_counter, $tmp_studied_lines)) {
				$new_line_data = formatNewLineData($headers, $new_line);
				$no_labo = $new_line_data['NoLabo'];
				if($no_labo) {
					if(!array_key_exists($no_labo, $no_labos_to_participants_session_data)) die('ERR 238763287632');
					createFollowupWorksheet($no_labos_to_participants_session_data[$no_labo], $visit, $new_line_data);
					createVnMedicationWorksheet($no_labos_to_participants_session_data[$no_labo], $visit, $new_line_data);
				}
			}
		}
	}
}

// Add ATiM event/trt unlinked to visit based on visit limits
foreach($no_labos_to_participants_session_data as $participant_session_data) {
	$queries_to_link_event_and_treatment = array();
	$visit_dates_limits = $participant_session_data['visits_limits'];
	foreach(array_keys($visit_dates_limits) as $visit) {
		if(!preg_match('/^V0([0-9])$/', $visit, $match)) die('ERR2376287632');
		$previous_visit = 'V0'.((int)$match[1]-1);
		if($visit_dates_limits[$visit]['followup_event_master_id']) {
			if(($visit == 'V02' && $visit_dates_limits[$visit]['start'] && ($visit_dates_limits[$visit]['finish'] || $visit_dates_limits[$visit]['visit_date'])) ||
			($visit != 'V02' && ($visit_dates_limits[$visit]['start'] || $visit_dates_limits[$previous_visit]['visit_date']) && ($visit_dates_limits[$visit]['finish'] || $visit_dates_limits[$visit]['visit_date']))) {
				$start_date = null;
				if($visit == 'V02') {
					$start_date = $visit_dates_limits[$visit]['start'];
				} else {
					if(!$visit_dates_limits[$visit]['start']) {
						$start_date = $visit_dates_limits[$previous_visit]['visit_date'];
					} else if(!$visit_dates_limits[$previous_visit]['visit_date']) {
						$start_date = $visit_dates_limits[$visit]['start'];
					} else if($visit_dates_limits[$previous_visit]['visit_date'] < $visit_dates_limits[$visit]['start']) {
						$start_date = $visit_dates_limits[$previous_visit]['visit_date'];
					} else {
						$start_date = $visit_dates_limits[$visit]['start'];
					}
				}
				$end_date = null;
				if(!$visit_dates_limits[$visit]['finish']) {
					$end_date = $visit_dates_limits[$visit]['visit_date'];
				} else if(!$visit_dates_limits[$visit]['visit_date']) {
					$end_date = $visit_dates_limits[$visit]['finish'];
				} else if($visit_dates_limits[$visit]['visit_date'] < $visit_dates_limits[$visit]['finish']) {
					$end_date = $visit_dates_limits[$visit]['finish'];
				} else {
					$end_date = $visit_dates_limits[$visit]['visit_date'];
				}
				if(!$start_date || !$end_date) die('ERR 23762876 3322222');
				//event
				$query = "SELECT id FROM event_masters WHERE deleted <> 1 AND event_date IS NOT NULL AND event_date >= '$start_date' AND event_date <= '$end_date' AND event_control_id IN (55,54) AND participant_id = $participant_id AND procure_form_identification = 'n/a';";
				$query_res = customQuery($query, __LINE__);
				$event_master_ids_to_update = array();
				while($res = mysqli_fetch_assoc($query_res)) {
					$event_master_ids_to_update[] = $res['id'];
				}
				if($event_master_ids_to_update) {
					$queries_to_link_event_and_treatment[] = "UPDATE event_masters SET event_summary = IFNULL(CONCAT('Attached to the visit $visit by the migration process. ', event_summary), 'Attached to the visit $visit by the migration process'), procure_form_identification = '".$visit_dates_limits[$visit]['procure_form_identification']."' WHERE event_control_id IN (54,55) AND id IN (".implode(',',$event_master_ids_to_update).");";
					$queries_to_link_event_and_treatment[] = "UPDATE event_masters_revs SET event_summary = IFNULL(CONCAT('Attached to the visit $visit by the migration process. ', event_summary), 'Attached to the visit $visit by the migration process'), procure_form_identification = '".$visit_dates_limits[$visit]['procure_form_identification']."' WHERE event_control_id IN (54,55) AND id IN (".implode(',',$event_master_ids_to_update).");";
					$queries_to_link_event_and_treatment[] = "UPDATE procure_ed_clinical_followup_worksheet_aps SET followup_event_master_id = ".$visit_dates_limits[$visit]['followup_event_master_id']." WHERE event_master_id IN (".implode(',',$event_master_ids_to_update).");";
					$queries_to_link_event_and_treatment[] = "UPDATE procure_ed_clinical_followup_worksheet_aps_revs SET followup_event_master_id = ".$visit_dates_limits[$visit]['followup_event_master_id']." WHERE event_master_id IN (".implode(',',$event_master_ids_to_update).");";
					$queries_to_link_event_and_treatment[] = "UPDATE procure_ed_clinical_followup_worksheet_clinical_events SET followup_event_master_id = ".$visit_dates_limits[$visit]['followup_event_master_id']." WHERE event_master_id IN (".implode(',',$event_master_ids_to_update).");";
					$queries_to_link_event_and_treatment[] = "UPDATE procure_ed_clinical_followup_worksheet_clinical_events_revs SET followup_event_master_id = ".$visit_dates_limits[$visit]['followup_event_master_id']." WHERE event_master_id IN (".implode(',',$event_master_ids_to_update).");";
				}
				//treatment
				$query = "SELECT id FROM treatment_masters WHERE deleted <> 1 AND start_date IS NOT NULL AND start_date >= '$start_date' AND start_date <= '$end_date' AND treatment_control_id = 6 AND participant_id = $participant_id AND procure_form_identification = 'n/a';";
				$query_res = customQuery($query, __LINE__);
				$treatment_master_ids_to_update = array();
				while($res = mysqli_fetch_assoc($query_res)) {
					$treatment_master_ids_to_update[] = $res['id'];
				}
				if($treatment_master_ids_to_update) {
					$queries_to_link_event_and_treatment[] = "UPDATE treatment_masters SET notes = IFNULL(CONCAT('Attached to the visit $visit by the migration process. ', notes),'Attached to the visit $visit by the migration process'), procure_form_identification = '".$visit_dates_limits[$visit]['procure_form_identification']."' WHERE treatment_control_id = 6 AND id IN (".implode(',',$treatment_master_ids_to_update).");";
					$queries_to_link_event_and_treatment[] = "UPDATE treatment_masters_revs SET notes = IFNULL(CONCAT('Attached to the visit $visit by the migration process. ', notes),'Attached to the visit $visit by the migration process'), procure_form_identification = '".$visit_dates_limits[$visit]['procure_form_identification']."' WHERE treatment_control_id = 6 AND id IN (".implode(',',$treatment_master_ids_to_update).");";
					$queries_to_link_event_and_treatment[] = "UPDATE procure_txd_followup_worksheet_treatments SET followup_event_master_id = ".$visit_dates_limits[$visit]['followup_event_master_id']."  WHERE treatment_master_id IN (".implode(',',$treatment_master_ids_to_update).");";
					$queries_to_link_event_and_treatment[] = "UPDATE procure_txd_followup_worksheet_treatments_revs SET followup_event_master_id = ".$visit_dates_limits[$visit]['followup_event_master_id']."  WHERE treatment_master_id IN (".implode(',',$treatment_master_ids_to_update).");";
				}
			}
		}	
	}
	foreach($queries_to_link_event_and_treatment as $query)	customQuery($query, __LINE__);
}

$tmp = array('aliquot_internal_uses' => 'use_datetime',
	'aliquot_masters' => 'storage_datetime',
	'derivative_details' => 'creation_datetime',
	'participant_contacts' => 'effective_date',
	'participant_contacts' => 'expiry_date',
	'participant_messages' => 'expiry_date',
	'participants' => 'last_chart_checked_date',
	'procure_cd_sigantures' => 'qc_nd_stop_followup_date',
	'procure_cd_sigantures' => 'qc_nd_stop_questionnaire_date',
	'quality_ctrls' => 'date',
	'sd_spe_tissues' => 'pathology_reception_datetime',
	'procure_ed_lab_diagnostic_information_worksheets' => 'biopsy_pre_surgery_date'
);
foreach($tmp as $tablename => $date_field) {
	$query = "UPDATE $tablename SET $date_field = NULL WHERE $date_field LIKE '%0000%';";
	$query_res = customQuery($query, __LINE__);
	$query = "UPDATE ".$tablename."_revs SET $date_field = NULL WHERE $date_field LIKE '%0000%';";
	$query_res = customQuery($query, __LINE__);
}

dislayErrorAndMessage($import_summary);

//=================================================================================================================================
// Data Management Functions
//=================================================================================================================================

function loadV0V01PatientData(&$participant_session_data, $new_line_data) {
	global $import_summary;
	$report = 'Other Treatment';
	$participant_id = $participant_session_data['participant_id'];
	$atim_code_barre = $participant_session_data['atim_code_barre'];
	$patient_identification_msg = $participant_session_data['patient_identification_msg'];
	$prostatectomy_date = getProstatectomyDate($participant_id, $new_line_data, $patient_identification_msg);
	createDiagnosticInformationWorksheet($participant_session_data, $new_line_data, $prostatectomy_date);
	createPathologyReport($participant_session_data, $new_line_data, $prostatectomy_date);
	createV01MedicationWorksheet($participant_session_data, $new_line_data);
	$new_treatment_type = '';
	//Add aborted prostatectomy
	if($new_line_data["Questions pour la réunion annuelle 2014 ProCure Banque du CHUM::Métastases à l'opération"] == '1') {
		$treatment_master_data = array('procure_form_identification' => "n/a", 'participant_id' => $participant_id, 'treatment_control_id' => 6);
		$treatment_detail_data = array();
		$treatment_master_id = customInsert($treatment_master_data, 'treatment_masters', __LINE__, false, true);
		$treatment_detail_data['treatment_master_id'] = $treatment_master_id;
		$treatment_detail_data['treatment_type'] = 'aborted prostatectomy';
		customInsert($treatment_detail_data, 'procure_txd_followup_worksheet_treatments', __LINE__, true, true);
		$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "Created 'aborted prostatectomy'.".$patient_identification_msg;
	}
	//Add curitherapy
	if($new_line_data['Questions pour la réunion annuelle 2014 ProCure Banque du CHUM::Curithérapie'] == '1') {
		$treatment_master_data = array('procure_form_identification' => "n/a", 'participant_id' => $participant_id, 'treatment_control_id' => 6);
		$treatment_detail_data = array();
		$treatment_master_id = customInsert($treatment_master_data, 'treatment_masters', __LINE__, false, true);
		$treatment_detail_data['treatment_master_id'] = $treatment_master_id;
		$treatment_detail_data['treatment_type'] = 'curietherapy';
		customInsert($treatment_detail_data, 'procure_txd_followup_worksheet_treatments', __LINE__, true, true);
		$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "Created 'curietherapy'.".$patient_identification_msg;
	}
}

function getProstatectomyDate($participant_id, $new_line_data, $patient_identification_msg) {
	global $import_summary;
	$report = 'Prostatectomy Date Selection';
	$query = "SELECT start_date, start_date_accuracy 
		FROM treatment_masters tm 
		INNER JOIN procure_txd_followup_worksheet_treatments td
		WHERE tm.id = td.treatment_master_id AND tm.deleted <> 1 AND tm.participant_id = $participant_id AND treatment_type = 'prostatectomy' AND type LIKE '%prostatectomie%' ORDER BY start_date ASC;";
	$query_res = customQuery($query, __LINE__);
	if($query_res->num_rows) {
		if($query_res->num_rows > 1) $import_summary[$report]['WARNING']["More than one prostatectomy in ATiM"][] = $patient_identification_msg;
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
		$res['excel_event_date'] = formatAtimDateToExcelDate($res['event_date'], $res['event_date_accuracy']);
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
	$report = 'List ATiM Biopsies';
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
		$res['excel_event_date'] = formatAtimDateToExcelDate($res['event_date'], $res['event_date_accuracy']);
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
			if(!in_array($new_biopsy_excel_date, $atim_biopsies_dates)) $import_summary[$report]['ERROR']["Missing Excel Biopsy in ATiM (sardo). To validate and create (if required) both in SARDO and ATiM manually"][] = "Biopsy on $new_biopsy_excel_date. ".$patient_identification_msg;
		}
	}
	return $biopsies;
}

function createDiagnosticInformationWorksheet(&$participant_session_data, $new_line_data, $prostatectomy_date) {
	//event_control_id = 52 - procure_ed_diagnostic_information_worksheet
	global $import_summary;
	$report = 'Diagnostic Information Worksheet';
	
	$participant_id = $participant_session_data['participant_id'];
	$atim_code_barre = $participant_session_data['atim_code_barre'];
	$patient_identification_msg = $participant_session_data['patient_identification_msg'];	
	
	$event_master_data = array('procure_form_identification' => "$atim_code_barre V0 -FBP1", 'participant_id' => $participant_id, 'event_control_id' => 52);
	$event_detail_data = array();
	
	//PSA
	
	$all_atim_aps = getAtimAps($participant_id, $new_line_data, $patient_identification_msg, $prostatectomy_date);
	$participant_session_data['all_atim_aps'] = $all_atim_aps;
	$excel_aps_pre_surgery_date = str_replace(array('ND','?'), array('',''), $new_line_data['V0::APS pré-chirurgie (ng/mL)::Date']);
	if(strlen($excel_aps_pre_surgery_date) && !preg_match('/^([0-9]{2}\-){0,2}[0-9]{4}$/', $excel_aps_pre_surgery_date)) {
		$import_summary[$report]['ERROR']["Excel 'APS pré-chirurgie date' format error (set to null)"][] = "Value = [".$excel_aps_pre_surgery_date."]. ".$patient_identification_msg;
		$excel_aps_pre_surgery_date = '';
	}
	$excel_aps_pre_surgery_total_ng_ml = str_replace(array('ND','?',','), array('','','.'), $new_line_data['V0::APS pré-chirurgie (ng/mL)::Total APS']);
	if(strlen($excel_aps_pre_surgery_total_ng_ml) && !preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $excel_aps_pre_surgery_total_ng_ml)) {
		$import_summary[$report]['ERROR']["Excel 'APS pré-chirurgie total' format error (set to null)"][] = "Value = [".$excel_aps_pre_surgery_total_ng_ml."]. ".$patient_identification_msg;
		$excel_aps_pre_surgery_total_ng_ml = '';
	}
	$excel_aps_pre_surgery_free_ng_ml = str_replace(array('ND','?',','), array('','','.'), $new_line_data['V0::APS pré-chirurgie (ng/mL)::Libre']);
	if(strlen($excel_aps_pre_surgery_free_ng_ml) && !preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $excel_aps_pre_surgery_free_ng_ml)) {
		$import_summary[$report]['ERROR']["Excel 'APS pré-chirurgie libre' format error (set to null)"][] = "Value = [".$excel_aps_pre_surgery_free_ng_ml."]. ".$patient_identification_msg;
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
						$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "No APS pre-surgery total defined into excel: Used atim (sardo) value (".$all_atim_aps['pre-prostatectomy']['total_ngml'].").".$patient_identification_msg;
						$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
						$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
						$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
						$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
					} else if((abs($excel_aps_pre_surgery_total_ng_ml-$all_atim_aps['pre-prostatectomy']['total_ngml'])) <= 0.201) {
						//ATiM APS preop defined + same date & value in excel - value in ATiM < 0.201
						$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "APS pre-surgery total are different in excel and atim (diff <=0.2): Used atim (sardo) value (".$all_atim_aps['pre-prostatectomy']['total_ngml'].").".$patient_identification_msg;
						$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
						$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
						$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
						$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
					} else {
						$import_summary[$report]['ERROR']['ATiM APS pre-prostatectomy value different than excel APS pre-prostatectomy value'][] = "ATiM APS = '".$all_atim_aps['pre-prostatectomy']['total_ngml']."' / Excel APS = '$excel_aps_pre_surgery_total_ng_ml'. No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
					}
				}
			} else {
				// Date different in ATiM and excel
				if($all_atim_aps['pre-prostatectomy']['total_ngml'] == $excel_aps_pre_surgery_total_ng_ml) { 
					$import_summary[$report]['ERROR']['ATiM APS-PreProstatectomy date different than excel APS-PreProstatectomy date but both values are identical'][] = "ATiM APS date = '".$all_atim_aps['pre-prostatectomy']['excel_event_date']."' / Excel APS date = '$excel_aps_pre_surgery_date'. No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
				} else {
					$import_summary[$report]['ERROR']['ATiM APS-PreProstatectomy date different than excel APS-PreProstatectomy date (and different values)'][] = "ATiM APS date = '".$all_atim_aps['pre-prostatectomy']['excel_event_date']."' / Excel APS date = '$excel_aps_pre_surgery_date' & ATiM APS = '".$all_atim_aps['pre-prostatectomy']['total_ngml']."' / Excel APS = '$excel_aps_pre_surgery_total_ng_ml'. No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
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
						$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "APS pre-surgery date from excel matched an APS of ATiM but this one was not flagged as 'pre-surgery' because no prostatectomy event has been created into ATiM (based on SARDO Data). Used this date as pre-surgery aps.".$patient_identification_msg;
						$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps[$key_of_aps_preop]['event_date'];
						$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps[$key_of_aps_preop]['event_date_accuracy'];
						$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps[$key_of_aps_preop]['total_ngml'];
						$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
					}
				} else {
					$import_summary[$report]['ERROR']['No ATiM APS-PreProstatectomy is defined but an ATiM APS date matches the excel APS-PreProstatectomy date (but values are different)'][] = "No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
				}
			} else {
				$import_summary[$report]['ERROR']['Not enough information to create the APS pre-prostatectomy into ATiM (no sardo prostatectomy data + no match on aps date)'][] = "No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;	
			}	
		}		
	} else if($excel_aps_pre_surgery_total_ng_ml) {
		//Only excel aps value defined
		if(array_key_exists('pre-prostatectomy', $all_atim_aps)) {
			if($all_atim_aps['pre-prostatectomy']['total_ngml'] == $excel_aps_pre_surgery_total_ng_ml) {
				// ATiM APS preop defined, no aps date in excel but aps value in excel matches ATiM APS preop value
				$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "No APS pre-surgery date in excel. Used APS pre-surgery date defined into ATiM (sardo) (".$all_atim_aps['pre-prostatectomy']['event_date'].").".$patient_identification_msg;
				$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
				$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
				$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
				$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
			} else {
				$import_summary[$report]['ERROR']['ATiM APS pre-prostatectomy value different than excel APS pre-prostatectomy value (no excel date too)'][] = "ATiM APS value = '".$all_atim_aps['pre-prostatectomy']['total_ngml']."' / Excel APS value = '$excel_aps_pre_surgery_total_ng_ml'. No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
			}
		} else {
			$import_summary[$report]['ERROR']['Not enough information to create the APS pre-prostatectomy into ATiM (no sardo prostatectomy data + no match on aps data)'][] = "No APS-PrePreprostatecotmy data will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
		}
	} else if(array_key_exists('pre-prostatectomy', $all_atim_aps)) {
		// ATiM APS preop defined, no APS preop in excel
		$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "No APS pre-surgery defined in excel: Used atim (sardo) value (".$all_atim_aps['pre-prostatectomy']['total_ngml'].").".$patient_identification_msg;
		$event_detail_data['aps_pre_surgery_date'] = $all_atim_aps['pre-prostatectomy']['event_date'];
		$event_detail_data['aps_pre_surgery_date_accuracy'] = $all_atim_aps['pre-prostatectomy']['event_date_accuracy'];
		$event_detail_data['aps_pre_surgery_total_ng_ml'] = $all_atim_aps['pre-prostatectomy']['total_ngml'];
		$event_detail_data['aps_pre_surgery_free_ng_ml'] = $excel_aps_pre_surgery_free_ng_ml;
	}
	
	// Biopsy

	$all_atim_biopsies = getAtimBiopsies($participant_id, $new_line_data, $patient_identification_msg, $prostatectomy_date);
	if(preg_match_all('/[0-9]{2}\-[0-9]{2}\-[0-9]{4}/', $new_line_data['V0::Biopsie antérieure::Si oui; Date'], $excel_biopsies)) {
		//Note: biopsies missing in ATiM will be flagged in function getAtimBiopsies().
		$event_detail_data['biopsies_before'] = 'y';
	} else if($prostatectomy_date) {
		foreach($all_atim_biopsies as $key => $new_atim_biopsy) {
			if($key != 'pre-prostatectomy' && $new_atim_biopsy['event_date'] < $prostatectomy_date['start_date']) {
				$event_detail_data['biopsies_before'] = 'y';
				$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "Set flag 'Did the patient have biopsies before' (Diagnostic Information Worksheet) to 'yes' based on ATiM (SARDO) data.".$patient_identification_msg;
			}
		}
	}
	if($new_line_data['V0::Biopsie pré-chirurgie::Date']) {
		if(!preg_match('/^([0-9]{2}\-){0,2}[0-9]{4}$/', $new_line_data['V0::Biopsie pré-chirurgie::Date'])) {
			$import_summary[$report]['ERROR']["Excel 'Biopsy' date format error - not imported"][] = "Value = [".$new_line_data['V0::Biopsie pré-chirurgie::Date']."]. ".$patient_identification_msg;
		} else {
			if(array_key_exists('pre-prostatectomy', $all_atim_biopsies)) {
				if($all_atim_biopsies['pre-prostatectomy']['excel_event_date'] != $new_line_data['V0::Biopsie pré-chirurgie::Date']) {
					$import_summary[$report]['ERROR']['ATiM pre-prostatectomy biopsy date different than pre-prostatectomy biopsy date in excel'][] = "ATiM date = '".$all_atim_biopsies['pre-prostatectomy']['excel_event_date']."' / Excel date = '".$new_line_data['V0::Biopsie pré-chirurgie::Date']."'. No pre-biopsy date will be added to 'Diagnostic Information Worksheet'. ". $patient_identification_msg;
				} else {
					$event_detail_data['biopsy_pre_surgery_date'] = $all_atim_biopsies['pre-prostatectomy']['event_date'];
					$event_detail_data['biopsy_pre_surgery_date_accuracy'] = $all_atim_biopsies['pre-prostatectomy']['event_date_accuracy'];
				}
			} else {
				if($prostatectomy_date) {
					die('Case to support 8729739324. '.$patient_identification_msg);
				} else if(empty($all_atim_biopsies)) {
					$import_summary[$report]['ERROR']["Missing Excel Biopsy in ATiM (sardo). To validate and create (if required) both in SARDO and ATiM manually"][] = "Biopsy on ".$new_line_data['V0::Biopsie pré-chirurgie::Date'].". ".$patient_identification_msg;
				} else {
					$match_done = false;
					foreach($all_atim_biopsies as $new_biopsy) {
						if($new_biopsy['excel_event_date'] == $new_line_data['V0::Biopsie pré-chirurgie::Date']) $match_done = true;
					}
					if($match_done) {
						$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "Biopsy pre-surgery date from excel matched a biopsy date of ATiM but this one was not flagged as 'pre-surgery' because no prostatectomy event has been created into ATiM (based on SARDO Data). Used this date as pre-surgery biopsy.".$patient_identification_msg;
						$event_detail_data['biopsy_pre_surgery_date'] = $new_line_data['V0::Biopsie pré-chirurgie::Date'];
						$event_detail_data['biopsy_pre_surgery_date_accuracy'] = 'c';
					} else {
						$import_summary[$report]['ERROR']["Unable to match the Excel Biopsy with an ATiM Biopsy (sardo) based on date. To validate and create (if required) both in SARDO and ATiM manually. Biopsy pre-surgery date won't be set"][] = "Biopsy on ".$new_line_data['V0::Biopsie pré-chirurgie::Date'].". ".$patient_identification_msg;
					}
				}
			}
		}
	} else if(array_key_exists('pre-prostatectomy', $all_atim_biopsies)) {
		$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "No Biopsy pre-surgery defined in excel: Used atim (sardo) value (".$all_atim_biopsies['pre-prostatectomy']['event_date'].").".$patient_identification_msg;
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
			$import_summary[$report]['ERROR']["Number of collected cores format error (not imported)"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
		}
	}
	$excel_field = 'V0::Biopsie pré-chirurgie::Nombre de zones atteintes';
	$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier'), array('', '', '', '', ''), $new_line_data[$excel_field]);
	if(strlen($new_line_data[$excel_field])) {
		if(preg_match('/^[0-9]+$/', $new_line_data[$excel_field])) {
			$event_detail_data['nbr_of_cores_with_cancer'] = $new_line_data[$excel_field];
		} else {
			$import_summary[$report]['ERROR']["Number of cores with cancer format error (not imported)"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
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
// 		if(strlen($new_line_data[$excel_field])) {
// 			if(in_array($new_line_data[$excel_field], $field_def['values'])) {
// 				$event_detail_data[$field_def['atim_field']] = $new_line_data[$excel_field];
// 			} else {
// 				$import_summary[$report]['ERROR'][$field_def['atim_field']." format error (not imported)"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
// 			}
// 		} else {
			$excel_field = $field_def['excel_field_2'];
			$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier', ',00', '0', 'NA'), array('', '', '', '', '', '', '', ''), $new_line_data[$excel_field]);
			if(strlen($new_line_data[$excel_field])) {
				if(in_array($new_line_data[$excel_field], $field_def['values'])) {
//					$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "Used value of field [".str_replace('V0::Biopsie pré-chirurgie::', '', $field_def['excel_field_2'])."] instead [".str_replace('V0::Biopsie pré-chirurgie::', '', $field_def['excel_field_1'])."]. Last one was empty.";
					$event_detail_data[$field_def['atim_field']] = $new_line_data[$excel_field];
				} else {
					$import_summary[$report]['ERROR'][$field_def['atim_field']." format error (not imported)"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
				}
			}
//		}
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
			$import_summary[$report]['ERROR']["Highest gleason score percentage format error (not imported)"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
		}
	}
	
	// Data creation
	
	if($event_detail_data) {
		$event_master_id = customInsert($event_master_data, 'event_masters', __LINE__, false, true);
		$event_detail_data['event_master_id'] = $event_master_id;
		customInsert($event_detail_data, 'procure_ed_lab_diagnostic_information_worksheets', __LINE__, true, true);		
	} else {
		$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "No Diagnostic Information Worksheet created.".$patient_identification_msg;
	}
}

function createPathologyReport(&$participant_session_data, $new_line_data, $prostatectomy_date) {
	//procure_ed_lab_pathologies event_conrol_id = 51
	global $import_summary;
	$report = 'Pathology Report';
		
	$participant_id = $participant_session_data['participant_id'];
	$atim_code_barre = $participant_session_data['atim_code_barre'];
	$patient_identification_msg = $participant_session_data['patient_identification_msg'];
	
	if($new_line_data['V01::Chirurgie::Date de la chirurgie']) {
		$new_line_data['V01::Chirurgie::Date de la chirurgie'] = str_replace(array(' ', '/'), array('','-'), $new_line_data['V01::Chirurgie::Date de la chirurgie']);
		if($prostatectomy_date) {
			$atim_prostatectomy_date = formatAtimDateToExcelDate($prostatectomy_date['start_date'], $prostatectomy_date['start_date_accuracy']);
			if($atim_prostatectomy_date != $new_line_data['V01::Chirurgie::Date de la chirurgie']) {
				$import_summary[$report]['ERROR']["V01 'Date de la chirurgie'(excel) different than atim date"][] = "(atim) $atim_prostatectomy_date != (excel) ". $new_line_data['V01::Chirurgie::Date de la chirurgie'].'. '.$patient_identification_msg;
			}
		} else {
			$import_summary[$report]['ERROR']["Missing Excel Biopsy in ATiM (sardo). To validate and create (if required) both in SARDO and ATiM manually"][] = "Biopsy on ".$new_line_data['V01::Chirurgie::Date de la chirurgie'].". ".$patient_identification_msg;
		}		
	}	
	
	$event_master_data = array('procure_form_identification' => "$atim_code_barre V0 -PST1", 'participant_id' => $participant_id, 'event_control_id' => 51);
	$event_detail_data = array();
	
	if(!preg_match('/^(\ )+$/', $new_line_data['V01::Chirurgie::Nom du pathologiste'])) $event_detail_data['pathologist_name'] = $new_line_data['V01::Chirurgie::Nom du pathologiste'];
	if(!preg_match('/^(\ )+$/', $new_line_data['V01::Chirurgie::Chirurgien'])) $event_detail_data['qc_nd_surgeon'] = $new_line_data['V01::Chirurgie::Chirurgien'];
		
	// Measurements
	
	$def = array(
		"V01::Chirurgie::Dimensions::Prostate::poids (g)" => "prostate_weight_gr",
		"V01::Chirurgie::Dimensions::Prostate::longueur (cm) Apex/Base (supéro-inf)" => "prostate_length_cm",
		"V01::Chirurgie::Dimensions::Prostate::largeur (cm) latérale/latérale ( tranverse)" => "prostate_width_cm",	
		"V01::Chirurgie::Dimensions::Prostate::épaisseur (cm) antéro-postérieur" => "prostate_thickness_cm",	
		"V01::Chirurgie::Dimensions::Vésicule séminale droite::longueur (cm)" => "right_seminal_vesicle_length_cm",
		"V01::Chirurgie::Dimensions::Vésicule séminale droite::largeur (cm)" => "right_seminal_vesicle_width_cm",
		"V01::Chirurgie::Dimensions::Vésicule séminale droite::épaisseur (cm)" => "right_seminal_vesicle_thickness_cm",	
		"V01::Chirurgie::Dimensions::Vésicule séminale gauche::Longueur (cm)" => "left_seminal_vesicle_length_cm",	
		"V01::Chirurgie::Dimensions::Vésicule séminale gauche::Largeur (cm)" => "left_seminal_vesicle_width_cm",	
		"V01::Chirurgie::Dimensions::Vésicule séminale gauche::épaisseur (cm)" => "left_seminal_vesicle_thickness_cm");
	foreach($def as $excel_field => $db_field) {
		$val = str_replace(
			array(',','ND', 'NA', "''", '"', 'N/A', ' ', '−', '(partielle)', '(part.)'), 
			array('.', '', '','', '','', '', '', '', ''), 
			$new_line_data[$excel_field]);
		$excel_field = str_replace('V01::Chirurgie::Dimensions::', '', $excel_field);
		if(strlen($val)) {
			 if(!preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $val)) {
				$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!= decimal / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			} else {
				$event_detail_data[$db_field] = $val;
			}
		}
	}
	
	// Histology
	
	$tmp = array(
		"V01::Chirurgie::Histologie::Adénocarcinome::acinaire ou du type usuel" => "acinar adenocarcinoma/usual type",
		"V01::Chirurgie::Histologie::Adénocarcinome::canalaire" => "prostatic ductal adenocarcinoma",
		"V01::Chirurgie::Histologie::Adénocarcinome::mucineux" => "mucinous adenocarcinoma",
		"V01::Chirurgie::Histologie::Carcinome::à cellules indépendantes (cellules en bague)" => "signet-ring cell carcinoma",
		"V01::Chirurgie::Histologie::Carcinome::adénosquameux" => "adenosquamous carcinoma",
		"V01::Chirurgie::Histologie::Carcinome::à petites cellules" => "small cell carcinoma",
		"V01::Chirurgie::Histologie::Carcinome::sarcomatoïde" => "sarcomatoid carcinoma");
	$histology = array();
	$histology_other_precision = array();
	foreach($tmp as $excel_field => $histo_value) {
		$val = str_replace(array(',','ND', 'NA'), array('','',''), $new_line_data[$excel_field]);
		if(strlen($val)) {
			if($val == '1') {
				$histology[] = $histo_value;
			} else if($val != '0') {
				$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!= {0,1} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			}
		}
	}
	if($histology) {
		if(sizeof($histology) > 1) $import_summary[$report]['ERROR']["Histology defined more than once (will take first value)"][] = "Values = [".implode(' && ', $histology).']. Recorded : '.$histology[0].'. '.$patient_identification_msg;
		$histology = $histology[0];
	} else {
		$histology = '';
	}
	$val = $new_line_data['V01::Chirurgie::Histologie::Autre::Précisez'];
	if(strlen($val)) {
		if(!$histology) $histology = 'other specify';
		$histology_other_precision[] = $val;
	}
	$old_histo = '';
	if($new_line_data['V01::Chirurgie::Histologie::Adénocarcinome::Bien différencié'] == '1' && $new_line_data['V01::Chirurgie::Histologie::Adénocarcinome::Peu différencié'] == '1') die('ERR 6373 '.$patient_identification_msg);
	if($new_line_data['V01::Chirurgie::Histologie::Adénocarcinome::Bien différencié'] == '1') {
		$old_histo = 'Adénocarcinome bien différencié';
	} else if($new_line_data['V01::Chirurgie::Histologie::Adénocarcinome::Peu différencié'] == '1') {
		$old_histo = 'Adénocarcinome peu différencié';
	} else if($new_line_data['V01::Chirurgie::Histologie::Adénocarcinome::Adénocarcinome'] == '1') {
		if(!preg_match('/adenocarcinoma/', $histology)) $old_histo = 'Adénocarcinome';
	}
	if($old_histo && !$histology) $histology = 'other specify';
	if($old_histo) $histology_other_precision[] = $old_histo;
	$histology_other_precision = implode(' && ',$histology_other_precision);
	if($histology) $event_detail_data['histology'] = $histology;
	if($histology_other_precision) $event_detail_data['histology_other_precision'] = $histology_other_precision;
		
	// Tumour location
	
	$tmp = array(
		"V01::Chirurgie::Localisation des foyers tumoraux::Antérieur Droit" => 'tumour_location_right_anterior', 	
		"V01::Chirurgie::Localisation des foyers tumoraux::Antérieur Gauche" => 'tumour_location_left_anterior', 	
		"V01::Chirurgie::Localisation des foyers tumoraux::Postérieur Droit" => 'tumour_location_right_posterior', 		
		"V01::Chirurgie::Localisation des foyers tumoraux::Postérieur Gauche" => 'tumour_location_left_posterior', 	
		"V01::Chirurgie::Localisation des foyers tumoraux::Apex" => 'tumour_location_apex', 	
		"V01::Chirurgie::Localisation des foyers tumoraux::Base" => 'tumour_location_base', 
		"V01::Chirurgie::Localisation des foyers tumoraux::Col vésical" => 'tumour_location_bladder_neck');
	foreach($tmp as $excel_field => $db_field) {
		$val = str_replace(array(',','ND', 'NA'), array('','',''), $new_line_data[$excel_field]);
		if(strlen($val)) {
			if($val == '1') {
				$event_detail_data[$db_field] = '1';
			} else if($val != '0') {
				$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={0,1} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			}
		}
	}
	
	// Tumour volume
	
	$tmp = array(
		"V01::Chirurgie::Volume tumoral total::Atteinte légère (<30%)" => 1,
		"V01::Chirurgie::Volume tumoral total::Atteinte modérée (30-60%)" => 2,
		"V01::Chirurgie::Volume tumoral total::Atteinte extensive (>60%)" => 3);
	$tmp_res = 0;
	foreach($tmp as $excel_field => $tmp_val) {
		$val = str_replace(array(',','ND', 'NA'), array('','',''), $new_line_data[$excel_field]);
		/*if(preg_match('/^1[\ ]{0,1}\(/', $val)) {
			$import_summary[$report]['WARNING']["Excel '$excel_field' format like '1 (...' then (!={0,1} / set to 1)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			$val = '1';
		}*/
		if(strlen($val)) {
			if($val == '1') {
				$tmp_res += $tmp_val;
			} else if($val != '0') {
				$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={0,1} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			}
		}
	}	
	if($tmp_res) {
		switch($tmp_res) {
			case '1':
				$event_detail_data['tumour_volume'] = 'low';
				break;
			case '2':
				$event_detail_data['tumour_volume'] = 'moderate';
				break;
			case '3':
				$event_detail_data['tumour_volume'] = 'high';
				break;
			default:
				die('ERR 2387 6287 632 '.$patient_identification_msg);
		}
	}
	
	// Histologic grade
	
	$def = array(
		array('excel_field' => 'V01::Chirurgie::Patron histologique::primaire (2 à 5)',
			'atim_field' => 'histologic_grade_primary_pattern',
			'values' => array('2','3','4','5')),
		array('excel_field' => 'V01::Chirurgie::Patron histologique::secondaire (2 à 5)',
			'atim_field' => 'histologic_grade_secondary_pattern',
			'values' => array('2','3','4','5')),
		array('excel_field' => 'V01::Chirurgie::Patron histologique::Tertiaire (aucun; 2 à 5)',
			'atim_field' => 'histologic_grade_tertiary_pattern',
			'values' => array('2','3','4','5')));
	foreach($def as $field_def) {
		$excel_field = $field_def['excel_field'];
		$new_line_data[$excel_field] = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier', ',00', '0', 'NA'), array('', '', '', '', '', '', '', ''), $new_line_data[$excel_field]);
		if(strlen($new_line_data[$excel_field])) {
			if(in_array($new_line_data[$excel_field], $field_def['values'])) {
				$event_detail_data[$field_def['atim_field']] = $new_line_data[$excel_field];
			} else {
				$import_summary[$report]['ERROR'][$field_def['atim_field']." format error (!={".implode(',',$field_def['values'])."} / not imported)"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
			}
		}
	}
	$excel_field = 'V01::Chirurgie::Patron histologique::Score de Gleason';
	$val = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier', ',00', '0', 'NA'), array('', '', '', '', '', '', '', ''), $new_line_data[$excel_field]);
	if($val) $event_detail_data['histologic_grade_gleason_score'] = $val;
	
	// Margins (check what applies)
	
	$not_be_assessed = false;
	if($new_line_data['V01::Chirurgie::Marges chirurgicales::Ne peuvent être évaluées']) {
		if($new_line_data['V01::Chirurgie::Marges chirurgicales::Ne peuvent être évaluées'] != '1') die('ERR 23762 87623786');
		$not_be_assessed = true;
		$event_detail_data['margins'] = 'cannot be assessed';
	}
	$excel_field = 'V01::Chirurgie::Marges chirurgicales::Présent';
	$val = str_replace(array('non-identifié', 'non identifié', 'nd', 'n/d', 'na', ' '), array('non', 'non', '', '', '', ''), strtolower($new_line_data[$excel_field]));
	if(strlen($val)) {
		if(preg_match('/^oui[\ ]{0,1}\(/', $val)) {
			$import_summary[$report]['WARNING']["$excel_field format like 'Oui (...' then !={oui,non} / set to oui)"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
			$val = 'oui';
		}		
		switch($val) {
			case 'oui':
				if($not_be_assessed) die('ERR 23 8728768732 6');
				$event_detail_data['margins'] = 'positive';
				break;
			case 'non':
				if($not_be_assessed) die('ERR 3763883383');
				$event_detail_data['margins'] = 'negative';
				break;
			default:
				$import_summary[$report]['ERROR']["$excel_field format error (!={oui,non} / not imported)"][] = "Value = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
		}
	}
	$excel_field_focale = 'V01::Chirurgie::Marges chirurgicales::Positives (cancer envahissant)::( Unifocal) Focale (encre d 3mm/une seule lame)';
	$val_focale = str_replace(array('ND', 'N/D', 'NA', 'N/A'), array('', '', '', '', ''), $new_line_data[$excel_field_focale]);
	if(preg_match('/^1[\ ]{0,1}\(/', $val_focale)) {
		$import_summary[$report]['WARNING']["$excel_field_focale format like '1...' then !={0,1} / set to 1)"][] = "Value = [".$new_line_data[$excel_field_focale]."]. ".$patient_identification_msg;
		$val_focale = '1';
	}
	if(strlen($val_focale) && !in_array($val_focale, array('1','0'))) {
		$import_summary[$report]['ERROR']["$excel_field_focale format error (!={0,1} / not imported)"][] = "Value = [".$new_line_data[$excel_field_focale]."]. ".$patient_identification_msg;
		$val_focale = '';
	}
	$excel_field_extensive = 'V01::Chirurgie::Marges chirurgicales::Positives (cancer envahissant)::(Multifocal) Extensive (cochez)';
	$val_extensive = str_replace(array('ND', 'N/D', 'NA', 'N/A'), array('', '', '', '', ''), $new_line_data[$excel_field_extensive]);
	if(strlen($val_extensive) && !in_array($val_extensive, array('1','0'))) {
		$import_summary[$report]['ERROR']["$excel_field_extensive format error (!={0,1} / not imported)"][] = "Value = [".$new_line_data[$excel_field_extensive]."]. ".$patient_identification_msg;
		$val_extensive = '';
	}
	if($val_focale && $val_extensive) die('ERR 2387 62876 2');
	if($val_focale) $event_detail_data['margins_focal_or_extensive'] = 'focal';
	if($val_extensive) $event_detail_data['margins_focal_or_extensive'] = 'extensive';
	$tmp = array("V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Antérieure Droit" => 'margins_extensive_anterior_right',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Antérieure Gauche" => 'margins_extensive_anterior_left',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Postérieure Droit" => 'margins_extensive_posterior_right',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Postérieure Gauche" => 'margins_extensive_posterior_left',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Apex" => "qc_nd_margins_extensive_apex",
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Apicale antérieure gauche" => 'margins_extensive_apical_anterior_left',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Apicale antérieure droite" => 'margins_extensive_apical_anterior_right',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Apicale postérieure gauche" => 'margins_extensive_apical_posterior_left',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Apicale postérieure droite" => 'margins_extensive_apical_posterior_right',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Base" => 'margins_extensive_base',
		"V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Col vésical" => 'margins_extensive_bladder_neck');
	$set_apex = false;
	foreach($tmp as $excel_field => $db_field) {
		$val = str_replace(array(',','ND', 'NA', 'N/A'), array('','','',''), $new_line_data[$excel_field]);
		if(strlen($val)) {
			if($val == '1') {
				$event_detail_data[$db_field] = '1';
				if(preg_match('/^margins_extensive_apical_/', $db_field)) $set_apex = true;
			} else if($val != '0') {
				$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={0,1} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			}
		}
	}
	if($set_apex) $event_detail_data['qc_nd_margins_extensive_apex'] = '1';
	$excel_field = 'V01::Chirurgie::Marges chirurgicales::Si extensive, localisation::Score de Gleason aux marges';
	$val = str_replace(array('ND', 'N/D', 'pas Bx', 'dossier ? ', 'dossier', ',00', '0', 'NA'), array('', '', '', '', '', '', '', ''), $new_line_data[$excel_field]);
	if($val) $event_detail_data['margins_gleason_score'] = $val;
	
	// Extra-prostatic extension
	
	$excel_field = 'V01::Chirurgie::Extension extraprostatique::Présente';
	$val = str_replace(array('non-identifié', 'non identifié', 'nd', 'n/d', 'na'), array('non', 'non', '', '', ''), strtolower($new_line_data[$excel_field]));
	switch($val){
		case '':
			break;
		case 'oui':
			$event_detail_data['extra_prostatic_extension'] = 'present';
			break;
		case 'non':
			$event_detail_data['extra_prostatic_extension'] = 'absent';
			break;
		default:
			$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={oui,non} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
	}
	$excel_field = 'V01::Chirurgie::Extension extraprostatique::Présente::Focale (surface < 40x un champ/une seule lame)';
	$val_focal = str_replace(array('ND', 'N/D', 'NA', '0', 'N/A', ' '), array('', '', '', '', '', ''), $new_line_data[$excel_field]);
	if(preg_match('/^1[\ ]{0,1}\(/', $val_focal)) {
		$import_summary[$report]['WARNING']["Excel '$excel_field' like '1 (...' then != than {0,1} / set to 1)"][] = "Value = [".$val_focal."]. ".$patient_identification_msg;
		$val_focal = '1';
	}	
	if(strlen($val_focal) && $val_focal != '1') {
		if($val_focal != '1') {
			$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={0,1} / set to null)"][] = "Value = [".$val_focal."]. ".$patient_identification_msg;
			$val_focal = '';
		}
	}
	$excel_field = 'V01::Chirurgie::Extension extraprostatique::Présente::Établie';
	$val_established = str_replace(array('ND', 'N/D', 'NA', '0', 'N/A'), array('', '', '', '', ''), $new_line_data[$excel_field]);
	if(strlen($val_established) && $val_established != '1') {
		$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={0,1} / set to null)"][] = "Value = [".$val_established."]. ".$patient_identification_msg;
		$val_established = '';
	}
	if($val_established && $val_focal) die('ERR 2387 62876 32');
	if($val_focal) $event_detail_data['extra_prostatic_extension_precision'] = 'focal';
	if($val_established) $event_detail_data['extra_prostatic_extension_precision'] = 'established';
	$tmp = array(
		"V01::Chirurgie::Extension extraprostatique::Localisation::Antérieur Droit" => 'extra_prostatic_extension_right_anterior',
		"V01::Chirurgie::Extension extraprostatique::Localisation::Antérieur Gauche" => 'extra_prostatic_extension_left_anterior',	
		"V01::Chirurgie::Extension extraprostatique::Localisation::Postérieur Droit" => 'extra_prostatic_extension_right_posterior',	
		"V01::Chirurgie::Extension extraprostatique::Localisation::Postérieur Gauche" => 'extra_prostatic_extension_left_posterior',
		"V01::Chirurgie::Extension extraprostatique::Localisation::Apex" => 'extra_prostatic_extension_apex',	
		"V01::Chirurgie::Extension extraprostatique::Localisation::Base" => 'extra_prostatic_extension_base',	
		"V01::Chirurgie::Extension extraprostatique::Localisation::Col vésical" => 'extra_prostatic_extension_bladder_neck');
	foreach($tmp as $excel_field => $db_field) {
		$val = str_replace(array(',','ND', 'NA', 'N/A'), array('','','',''), $new_line_data[$excel_field]);
		if(strlen($val)) {
			if($val == '1') {
				$event_detail_data[$db_field] = '1';
			} else if($val != '0') {
				$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={0,1} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			}
		}
	}
	$event_detail_data['extra_prostatic_extension_seminal_vesicles'] = '';
	$excel_field = 'V01::Chirurgie::Invasion des Vésicules Séminales::Présente';
	$val = str_replace(array('non-identifié', 'non identifié', 'nd', 'n/d', 'na', 'n/a'), array('non', 'non', '', '', ''), strtolower($new_line_data[$excel_field]));
	switch($val) {
		case '';
			break;
		case 'oui':
			$event_detail_data['extra_prostatic_extension_seminal_vesicles'] = 'present';
			break;
		case 'non':
			$event_detail_data['extra_prostatic_extension_seminal_vesicles'] = 'absent';
			break;
		default;
			$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={oui,non} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
	}
	$unilateral = false;
	$excel_field = 'V01::Chirurgie::Invasion des Vésicules Séminales::Présente::Unilatérale';
	$val = str_replace(array('nd', 'n/d', 'na', 'n/a'), array('', '', '', ''), strtolower($new_line_data[$excel_field]));
	if(strlen($val)) {
		if(preg_match('/^1[\ ]{1}/', $val)) {
			$import_summary[$report]['ERROR']["Excel '$excel_field' format like '1...' then !={0,1} / set to 1)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			$val = '1';
		}
		if($val == '1') {
			$unilateral = true;
		} else if(preg_match('/^1/', $val)) {	
			
		} else if($val != '0') {
			$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={0,1} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
		}
	}
	$bilateral = false;
	$excel_field = 'V01::Chirurgie::Invasion des Vésicules Séminales::Présente::Bilatérale';
	$val = str_replace(array('nd', 'n/d', 'na', 'n/a'), array('', '', '', ''), strtolower($new_line_data[$excel_field]));
	if(strlen($val)) {
		if($val == '1') {
			$bilateral = true;
		} else if($val != '0') {
			$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={0,1} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
		}
	}
	if($event_detail_data['extra_prostatic_extension_seminal_vesicles'] == 'absent' && ($unilateral || $bilateral)) {
		$import_summary[$report]['ERROR']["Extension to seminal vesicles set to absent but specification is set (unilateral/bilateral): set to null"][] = $patient_identification_msg;
		$unilateral = false;
		$bilateral = false;
	}
	if($unilateral && $bilateral) {
		$import_summary[$report]['ERROR']["Extension to seminal vesicles set both to unilateral & bilateral: set to null"][] = $patient_identification_msg;
		$unilateral = false;
		$bilateral = false;
		$event_detail_data['extra_prostatic_extension_seminal_vesicles'] = '';
	}
	if($bilateral) $event_detail_data['extra_prostatic_extension_seminal_vesicles'] = 'bilateral';
	if($unilateral) $event_detail_data['extra_prostatic_extension_seminal_vesicles'] = 'unilateral';
	if($event_detail_data['extra_prostatic_extension_seminal_vesicles'] == 'present') {
		$event_detail_data['extra_prostatic_extension_seminal_vesicles'] = '';
		$import_summary[$report]['WARNING']["Extension to seminal vesicles set to present but no specification (unilateral/bilateral): set to null"][] = $patient_identification_msg;
	}
		
	// Pathologic staging
	
	$collected = false;
	$event_detail_data['pathologic_staging_version'] = $new_line_data['V01::Chirurgie::Stade pathologique (pTNM)::Définition de TNM (Version)'];
	$excel_field = 'V01::Chirurgie::Stade pathologique (pTNM)::Tumeur primaire::pT';
	$val = str_replace(array('ND', 'N/D', 'NA', 'N/A', 'PT', 'Pt', '*'), array('', '', '', '', 'pT', 'pT', ''), $new_line_data[$excel_field]);
	$expected_val = array("pTx","pT2","pT2a","pT2b","pT2c","pT2+","pT3a","pT3b","pT4");
	if(strlen($val)) {
		if(!in_array($val, $expected_val)) {
			$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!={".implode(',',$expected_val)."} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
		} else if(strlen($val)) {
			$event_detail_data['pathologic_staging_pt'] = $val;
		}
	}
	$excel_field = 'V01::Chirurgie::Stade pathologique (pTNM)::Ganglions lymphatiques / Adénopathies régionales::récoltés, nombre examinés';
	$val = str_replace(array('ND', 'N/D', 'NA', 'N/A', 'non applicable'), array('', '', '', '', ''), $new_line_data[$excel_field]);
	if(strlen($val)) {
		if(preg_match('/^[0-9]+$/', $val)) {
			$collected = true;
			$event_detail_data['pathologic_staging_pn_lymph_node_examined'] = $val;
		} else {
			$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!=integer / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
		}
	}
	$excel_field = 'V01::Chirurgie::Stade pathologique (pTNM)::Ganglions lymphatiques / Adénopathies régionales::Nombre atteints';
	$val = str_replace(array('ND', 'N/D', 'NA', 'N/A', 'non applicable'), array('', '', '', '', ''), $new_line_data[$excel_field]);
	if(strlen($val)) {
		if(preg_match('/^[0-9]+$/', $val)) {
			$collected = true;
			$event_detail_data['pathologic_staging_pn_lymph_node_involved'] = $val;
		} else {
			$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!=integer / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
		}
	}
	$pathologic_staging_pn = array();
	$tmp = array(
			"V01::Chirurgie::Stade pathologique (pTNM)::Ganglions lymphatiques / Adénopathies régionales::récoltés, mais renseignements insuffisants (pNx)" => array('excel_values' => array('NX','Nx','pNx'), 'db_val' => 'pNx'),
			"V01::Chirurgie::Stade pathologique (pTNM)::Ganglions lymphatiques / Adénopathies régionales::récoltés, pas d'atteinte (pN0)" => array('excel_values' => array('N0','pN0', 'No', 'n0'), 'db_val' => 'pn0'),
			"V01::Chirurgie::Stade pathologique (pTNM)::Ganglions lymphatiques / Adénopathies régionales::récoltés et positifs (pN1)" => array('excel_values' => array('N1','pN1'), 'db_val' => 'pN1'));
	foreach($tmp as $excel_field => $tmp_def) {
		$val = str_replace(array('ND', 'N/D', 'NA', 'N/A', 'non applicable',' '), array('', '', '', '', '', ''), $new_line_data[$excel_field]);
		if(strlen($val)) {
			if(in_array($val, $tmp_def['excel_values'])) {
				$collected = true;
				$pathologic_staging_pn[] = $tmp_def['db_val'];
			} else {
				$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!= {".implode(',', $tmp_def['excel_values'])."} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			}
		}
	}
	if(sizeof($pathologic_staging_pn) > 1) die('ERR 328762387 687326 2 '.$patient_identification_msg);
	if($pathologic_staging_pn) $event_detail_data['pathologic_staging_pn']  = $pathologic_staging_pn[0];
	if($collected) {
		$event_detail_data['pathologic_staging_pn_collected'] = 'y';
	}
	$pathologic_staging_ptnm = array();
	$tmp = array(
		"V01::Chirurgie::Stade pathologique (pTNM)::Métastases à distance::Renseignements insuffisants (pMx)" => array('excel_values' => array('pMx','Mx', 'MX'), 'db_val' => 'pMx'),
		"V01::Chirurgie::Stade pathologique (pTNM)::Métastases à distance::Aucune (pM0)" => array('excel_values' => array('pM0','M0', 'Mo'), 'db_val' => 'pM0'),
		"V01::Chirurgie::Stade pathologique (pTNM)::Métastases à distance::Présentes (pM1)" => array('excel_values' => array('pM1','M1'), 'db_val' => 'pm1'),
		"V01::Chirurgie::Stade pathologique (pTNM)::Métastases à distance::Ganglions lymphatiques non régionaux (pM1a)" => array('excel_values' => array('pM1a','M1a'), 'db_val' => 'pM1a'),	
		"V01::Chirurgie::Stade pathologique (pTNM)::Métastases à distance::Os (pM1b)" => array('excel_values' => array('pM1b','M1b'), 'db_val' => 'pM1b'),	
		"V01::Chirurgie::Stade pathologique (pTNM)::Métastases à distance::Autres sites (pM1c)" => array('excel_values' => array('pM1c','M1c'), 'db_val' => 'pM1c'));
	foreach($tmp as $excel_field => $tmp_def) {
		$val = str_replace(array('ND', 'N/D', 'NA', 'N/A', 'non applicable'), array('', '', '', '', ''), $new_line_data[$excel_field]);
		if(strlen($val)) {
			if(in_array($val, $tmp_def['excel_values'])) {
				$pathologic_staging_ptnm[] = $tmp_def['db_val'];
			} else {
				$import_summary[$report]['ERROR']["Excel '$excel_field' format error (!= {".implode(',', $tmp_def['excel_values'])."} / set to null)"][] = "Value = [".$val."]. ".$patient_identification_msg;
			}
		}
	}
	if(sizeof($pathologic_staging_ptnm) > 1) {
		$import_summary[$report]['ERROR']["Two values set for fields Distant metastasis"][] = "Value = [".implode(' && ',$pathologic_staging_ptnm)."]. ".$patient_identification_msg;
		$pathologic_staging_ptnm = array();
	}
	if($pathologic_staging_ptnm) $event_detail_data['pathologic_staging_pm']  = $pathologic_staging_ptnm[0];
	
	// Data creation
	
	if($event_detail_data) {
		$event_master_id = customInsert($event_master_data, 'event_masters', __LINE__, false, true);
		$event_detail_data['event_master_id'] = $event_master_id;
		customInsert($event_detail_data, 'procure_ed_lab_pathologies', __LINE__, true, true);
	} else {
		$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "No Pathology Report created.".$patient_identification_msg;
	}
}

function getATiMDrugs() {
	$query = "SELECT id, generic_name, type FROM drugs;";
	$query_res = customQuery($query, __LINE__);
	$drugs = array();
	while($res = mysqli_fetch_assoc($query_res)) {
		$drugs['all'][strtolower($res['generic_name'])] = $res;
		$drugs[$res['type']][strtolower($res['generic_name'])] = $res;
	}
	return 	$drugs;
}

function createV01MedicationWorksheet($participant_session_data, $new_line_data) {
	// treatment_control_id = 5 - procure_txd_medications
	// treatment_extend_control_id = 3 - procure_txe_medications
	global $import_summary;
	global $atim_drugs;
	$report = 'Medication';
	
	$participant_id = $participant_session_data['participant_id'];
	$atim_code_barre = $participant_session_data['atim_code_barre'];
	$patient_identification_msg = $participant_session_data['patient_identification_msg'];
	
	$drugs_to_create = array();
	$treatment_notes = array();
	
	$tmp = array("V01::Médication::pour la prostate::Inhibiteurs de 5a-Réductase (Avodart, Proscar)" => array('avodart','proscar'),
		"V01::Médication::pour la prostate::Rx BPH (Flomax, Xatral)" => array('flomax','xatral'),
		"V01::Médication::pour la prostate::Antibiotiques (Cipro)" => array('cipro'));
	foreach($tmp as $excel_field => $associated_atim_drugs) {
		$new_line_data[$excel_field] = preg_replace('/(\ )+/', ' ', str_replace(array("\n"), array(' '), $new_line_data[$excel_field]));
		$excel_drug = strtolower($new_line_data[$excel_field]);
		if(strlen($excel_drug)) {
			if(in_array($excel_drug, array('Non','non'))) {
				$drug_type = explode('::', $excel_field);
				$id = sizeof($drug_type)-1;
				$drug_type = $drug_type[$id];
				$treatment_notes[] = "$drug_type : Non";
			} else if (!in_array(strtolower($excel_drug), array('nd','0'))){
				$match_done = false;
				foreach($associated_atim_drugs as $drug) {
					if(preg_match("/$drug/", $excel_drug)) {
						if(!isset($atim_drugs['all'][$drug])) die('ERR 23876287 632 '.$drug);
						$drugs_to_create[] = array('duration' => $new_line_data[$excel_field], 'drug_id' => $atim_drugs['all'][$drug]['id']);
						$match_done = true;
					}			
				}
				if(!$match_done) {
					$drug_type = explode('::', $excel_field);
					$id = sizeof($drug_type)-1;
					$drug_type = $drug_type[$id];
					$treatment_notes[] = "$drug_type : ".$new_line_data[$excel_field];
					$import_summary[$report]['ERROR']["Unable to find [".implode(' or ', $associated_atim_drugs)."] in '$drug_type'. Drug added to notes."][] = "Val = [".$new_line_data[$excel_field]."]. ".$patient_identification_msg;
				}
			}
		}		
	}
	
	$tmp = array("V01::Médication::Médicaments pour autres problèmes de santé (prescrits et en vente libre) (nom et posologie)", 
		"V01::Médication::pour la prostate::Chirurgie (RTUP)",
		"V01::Médication::Produits naturels");
	foreach($tmp as $excel_field) {
		$new_line_data[$excel_field] = preg_replace('/(\ )+/', ' ', $new_line_data[$excel_field]);
		$excel_drug = strtolower($new_line_data[$excel_field]);
		if(strlen($excel_drug) && !in_array(strtolower($excel_drug), array('nd','0'))) {
			$drug_type = explode('::', $excel_field);
			$id = sizeof($drug_type)-1;
			$drug_type = $drug_type[$id];
			$treatment_notes[] = "$drug_type : ".$new_line_data[$excel_field];
		}
	}
	
	if($treatment_notes || $drugs_to_create) {
		// Treatment
		$treatment_master_data = array('procure_form_identification' => "$atim_code_barre V0 -MED1", 'participant_id' => $participant_id, 'treatment_control_id' => 5);
		$treatment_master_data['notes'] = implode("\n",$treatment_notes);
		$treatment_detail_data = array();
		$treatment_master_id = customInsert($treatment_master_data, 'treatment_masters', __LINE__, false, true);
		$treatment_detail_data['treatment_master_id'] = $treatment_master_id;
		customInsert($treatment_detail_data, 'procure_txd_medications', __LINE__, true, true);		
		//TreatmentExtend
		foreach($drugs_to_create as $treatment_extend_detail_data) {
			$treatment_extend_master_data = array('treatment_master_id' => $treatment_master_id, 'treatment_extend_control_id' => 3);
			$treatment_extend_master_id = customInsert($treatment_extend_master_data, 'treatment_extend_masters', __LINE__, false, true);
			$treatment_extend_detail_data['treatment_extend_master_id'] = $treatment_extend_master_id;
			customInsert($treatment_extend_detail_data, 'procure_txe_medications', __LINE__, true, true);
		}
	}
}

function createVnMedicationWorksheet($participant_session_data, $visit, $new_line_data) {
	// treatment_control_id = 5 - procure_txd_medications
	// treatment_extend_control_id = 3 - procure_txe_medications
	global $import_summary;
	global $atim_drugs;
	$report = 'Medication';
	
	$participant_id = $participant_session_data['participant_id'];
	$atim_code_barre = $participant_session_data['atim_code_barre'];
	$patient_identification_msg = $participant_session_data['patient_identification_msg'];
	
	$treatment_notes = array();
	foreach(array("Médication ( mise à jour si changements p/r à la V01 ) Prescrits par le medecin", "Medecine en vente libre dans les pharmacies") as $excel_field) {
		$new_line_data[$excel_field] = preg_replace('/(\ )+/', ' ', $new_line_data[$excel_field]);
		$excel_drug = strtolower($new_line_data[$excel_field]);
		if(strlen($excel_drug) && !in_array(strtolower($excel_drug), array('nd','0'))) {
			$treatment_notes[] = "$excel_field : ".$new_line_data[$excel_field];
		}
	}
	
	if($treatment_notes) {
		// Treatment
		$treatment_master_data = array('procure_form_identification' => "$atim_code_barre $visit -MED1", 'participant_id' => $participant_id, 'treatment_control_id' => 5);
		$treatment_master_data['notes'] = implode("\n",$treatment_notes);	
		$treatment_detail_data = array();
		$treatment_master_id = customInsert($treatment_master_data, 'treatment_masters', __LINE__, false, true);
		$treatment_detail_data['treatment_master_id'] = $treatment_master_id;
		customInsert($treatment_detail_data, 'procure_txd_medications', __LINE__, true, true);		
	}
}

function createFollowupWorksheet(&$participant_session_data, $visit, $new_line_data) {
	//event_control_id = 53 - procure_ed_clinical_followup_worksheets
	global $import_summary;
	global $import_date;
	$report = "Followup $visit Worksheet";
		
	$participant_id = $participant_session_data['participant_id'];
	$atim_code_barre = $participant_session_data['atim_code_barre'];
	$patient_identification_msg = $participant_session_data['patient_identification_msg'];
	$all_atim_aps = $participant_session_data['all_atim_aps'];
	
	// Get clinical event then treatments
	if(is_null($participant_session_data['atim_clinical_events'])) {
		$atim_clinical_events = array();
		$query = "SELECT em.id AS event_master_id, em.event_date, em.event_date_accuracy, ed.type, em.event_summary
			FROM event_masters em INNER JOIN procure_ed_clinical_followup_worksheet_clinical_events ed ON ed.event_master_id = em.id
			WHERE em.deleted <> 1 AND em.event_control_id = 55 AND em.participant_id = '$participant_id' ORDER BY em.event_date DESC";
		$query_res = customQuery($query, __LINE__);
		while($res = mysqli_fetch_assoc($query_res)) {
			$excel_event_date = formatAtimDateToExcelDate($res['event_date'], $res['event_date_accuracy']);
			$atim_clinical_events[$excel_event_date][$res['type']][] = $res;
		}
		$participant_session_data['atim_clinical_events'] = $atim_clinical_events;
	}
	$atim_clinical_events = $participant_session_data['atim_clinical_events'];
	if(is_null($participant_session_data['atim_treatments'])) {
		$atim_treatments = array();
		$query = "SELECT tm.id AS treatment_master_id, tm.start_date, tm.start_date_accuracy, tm.finish_date, tm.finish_date_accuracy, td.treatment_type, td.type
			FROM treatment_masters tm INNER JOIN procure_txd_followup_worksheet_treatments td ON td.treatment_master_id = tm.id
			WHERE tm.deleted <> 1 AND tm.treatment_control_id = 6 AND tm.participant_id = '$participant_id' ORDER BY tm.start_date DESC";
		$query_res = customQuery($query, __LINE__);
		while($res = mysqli_fetch_assoc($query_res)) {
			$excel_treatment_start_date = formatAtimDateToExcelDate($res['start_date'], $res['start_date_accuracy']);
			$atim_treatments[$excel_treatment_start_date][$res['treatment_type']][] = $res;
		}
		$participant_session_data['atim_treatments'] = $atim_treatments;
	}
	$atim_treatments = $participant_session_data['atim_treatments'];
	$visit_dates_limits = array('visit_date' => null, 'start' => null, 'finish' => null, 'followup_event_master_id' => null, 'procure_form_identification' => null);
	
	// Main Followup Worksheet
	
	$create_followup_worksheet = false;
	$event_notes = array();
	$event_master_data = array('procure_form_identification' => "$atim_code_barre $visit -FSP1", 'participant_id' => $participant_id, 'event_control_id' => 53);
	$event_detail_data = array();
	
	$field = "Date de la visite";
	if($new_line_data[$field]) {
		$date = formatExcelDateToAtimDate($new_line_data[$field], $report, $field, $patient_identification_msg);
		$event_master_data['event_date'] = $date['date'];
		$event_master_data['event_date_accuracy'] = $date['accuracy'];
		$create_followup_worksheet = true;
		$visit_dates_limits['visit_date'] = $date['date'];
	}

	$field = "Récidive biochimique (e 0.2 ng/mL)   (Pas nécessairement deux dosages successifs au CHUM)";
	if(strlen($new_line_data[$field])) {
		if($new_line_data[$field] == '1') {
			$event_detail_data['biochemical_recurrence'] = 'y';
			$create_followup_worksheet = true;
		} else {
			$import_summary[$report]['ERROR']["Unsupported '$visit - Récidive biochimique' value !={1} (set to null)"][] = "Val = [".$new_line_data[$field]."]. ".$patient_identification_msg;	
		}
	}
	$field = "Récidive clinique::Non";
	$clinical_recurrence_set_to_no = false;
	if(strlen($new_line_data[$field])) {
		if($new_line_data[$field] == '1') {
			$event_detail_data['clinical_recurrence'] = 'n';
			$clinical_recurrence_set_to_no = true;
			$create_followup_worksheet = true;
		} else {
			$import_summary[$report]['ERROR']["Unsupported '$visit - Récidive clinique Non' value !={1} (set to null)"][] = "Val = [".$new_line_data[$field]."]. ".$patient_identification_msg;
		}
	}
	
	$field = "Récidive clinique::Oui::locale (ganglions dans la région chirurgicale ou pelvienne)";
	if(strlen($new_line_data[$field])) {
		if($new_line_data[$field] == 'oui') {
			$event_detail_data['clinical_recurrence'] = 'y';
			$create_followup_worksheet = true;
		} else if($new_line_data[$field] === '26-08-2009') {
			$event_detail_data['clinical_recurrence'] = 'y';
			$event_notes[] = 'Clinical Recurrence: 26-08-2009';
			$create_followup_worksheet = true;
		} else {
			$import_summary[$report]['ERROR']["Unsupported '$visit - Récidive clinique Oui Locale' value !={oui} (set to null)"][] = "Val = [".$new_line_data[$field]."]. ".$patient_identification_msg;
		}
	}
	
	$field = "Récidive clinique::Oui::à distance (ganglions non pelviens ou métastases à d'autres organes: foie poumons, os, autres)";
	if(strlen($new_line_data[$field])) {
		if($new_line_data[$field] == 'os') {
			$event_detail_data['clinical_recurrence'] = 'y';
			$event_detail_data['clinical_recurrence_site'] = 'bones';
			$create_followup_worksheet = true;
		} else if($new_line_data[$field] === '06-11-2009 Épiploon') {
			$event_detail_data['clinical_recurrence'] = 'y';
			$event_detail_data['clinical_recurrence_site'] = 'others';
			$event_notes[] = 'Clinical Recurrence: '.$new_line_data[$field];
			$create_followup_worksheet = true;
		} else {
			$import_summary[$report]['ERROR']["Unsupported '$visit - Récidive clinique à distance' value (set to null)"][] = "Val = [".$new_line_data[$field]."]. ".$patient_identification_msg;
		}
	}
	if($clinical_recurrence_set_to_no && $event_detail_data['clinical_recurrence'] == 'y') {
		$import_summary[$report]['ERROR']["Clinical Recurrence defined both negatif and positif (site defined)"][] = $patient_identification_msg;
	}
	
	// APS 

	$excel_visit_aps = array();
	$atim_aps_event_master_ids_to_link_to_visit = array();
	for($id=1; $id<7; $id++) {
		$date = str_replace(' ', '', $new_line_data["Date".$id]);
		$aps = str_replace(array(',',' '),array('.',''),$new_line_data["APS".$id]);
		if(strlen($date.$aps) && $aps != 'ND') {
			if(!strlen($date)) {
				$import_summary[$report]['ERROR']["Excel 'APS' date unknown (won't be imported)"][] = "Value = [$aps]. ".$patient_identification_msg;
			} else {
				if(preg_match('/^([0-9]+)(\.([0-9]+)){0,1}$/', $aps, $match)) {
					$excel_visit_aps[$date] = array('val' => $aps, 'note' => array());
				} else {
					$excel_visit_aps[$date] = array('val' => '-1', 'note' => array($aps));
					$import_summary[$report]['ERROR']["Excel 'APS' format error (will just work on date)"][] = "Value = [$aps] on ".$date.". ".$patient_identification_msg;
				}
			}
		}
	}
	foreach($all_atim_aps as $new_atim_aps) {
		if(isset($excel_visit_aps[$new_atim_aps['excel_event_date']])) {
			if($excel_visit_aps[$new_atim_aps['excel_event_date']]['val'] != '-1' && $excel_visit_aps[$new_atim_aps['excel_event_date']]['val'] != $new_atim_aps['total_ngml']) {
				if((abs($excel_visit_aps[$new_atim_aps['excel_event_date']]['val']  - $new_atim_aps['total_ngml'])) <= 0.201) {
					$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "APS total are different in excel and atim (diff <=0.2) on ".$new_atim_aps['excel_event_date']." : Won't change atim (sardo) value (ATiM ".$new_atim_aps['total_ngml']." / Excel : ".$excel_visit_aps[$new_atim_aps['excel_event_date']]['val'].").".$patient_identification_msg;
				} else {
					$import_summary[$report]['ERROR']['ATiM APS value different in excel and ATiM'][] = "ATiM APS = '".$new_atim_aps['total_ngml']."' / Excel APS = '".$excel_visit_aps[$new_atim_aps['excel_event_date']]['val'] ." on ".$new_atim_aps['excel_event_date'].". ATiM APS will be linked to follow-up worksheet but values have to be verified. ". $patient_identification_msg;
				}
			}
			$atim_aps_event_master_ids_to_link_to_visit[] = $new_atim_aps['event_master_id'];
			unset($excel_visit_aps[$new_atim_aps['excel_event_date']]);
		} 		
	}
	if($excel_visit_aps) {
		foreach($excel_visit_aps as $date => $new_aps_to_create) {
			$new_aps_to_create['note'][] = "Created from excel file on ".substr($import_date, 0, strpos($import_date, ' '));
			$aps_event_master_data = array('participant_id' => $participant_id, 'event_control_id' => 54, 'event_summary' => implode("\n", $new_aps_to_create['note']));			
			$ar_date = formatExcelDateToAtimDate($date, $report, 'APS', $patient_identification_msg);
			if($ar_date) {
				$aps_event_master_data['event_date'] = $ar_date['date'];
				$aps_event_master_data['event_date_accuracy'] = $ar_date['accuracy'];
			}
			$aps_event_master_id = customInsert($aps_event_master_data, 'event_masters', __LINE__, false, true);
			$aps_event_detail_data = array('event_master_id' => $aps_event_master_id, 'total_ngml' => $new_aps_to_create['val']);	
			customInsert($aps_event_detail_data, 'procure_ed_clinical_followup_worksheet_aps', __LINE__, true, true);
			$atim_aps_event_master_ids_to_link_to_visit[] = $aps_event_master_id;
			$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "Created missing APS (date = '$date', total = ".$new_aps_to_create['val'].") in ATiM.".$patient_identification_msg;
			$import_summary[$report]['WARNING']["Missing PSA created into ATiM (to crate in SARDO)"][] = "Created missing APS (date = '$date', total = ".$new_aps_to_create['val'].") in ATiM. ".$patient_identification_msg;
		}
	}

	// Clinical Event

	//Specific Clinical Exam
	$atim_clinical_event_master_ids_to_link_to_visit = array();
	$tmp_def = array(
		'Scintigraphie osseuse' => 'bone scintigraphy',
		'CT-Scan' => 'CT-scan',
		'TEP-Scan' => 'PET-scan',
		'IRM' => 'IRM'
	);
	foreach($tmp_def as $excel_field => $atim_event_type) {
		$date_field = "Examens::$excel_field::Date";
		$date = str_replace(' ', '', $new_line_data[$date_field]);
		$res = $new_line_data["Examens::$excel_field::Interprétation"];
		if(strlen($date) && !in_array($date, array('ND'))) {
			if(!preg_match('/([0-9]{2}\-){0,2}[0-9]{4}/', $date)) {
				$import_summary[$report]['ERROR']["Clinical Event Date unknown (field ".$date_field.")"][] = "Val = [$date]. This event won't be studied. $patient_identification_msg";
			} else {
				if(isset($atim_clinical_events[$date][$atim_event_type])) {
					if(sizeof($atim_clinical_events[$date][$atim_event_type]) != 1) {
						$import_summary[$report]['WARNING']["More than one $atim_event_type exists into ATiM for the same date"][] = "Date = [$date]. Both will be linked to follow-up worksheet. $patient_identification_msg";
					} 
					foreach($atim_clinical_events[$date][$atim_event_type] as $clinical_event) $atim_clinical_event_master_ids_to_link_to_visit[] = $clinical_event['event_master_id'];
				} else if(isset($atim_clinical_events[$date])) {
					$other_atim_events_same_date = array();
					foreach($atim_clinical_events[$date] as $other_atim_event_type => $other_atim_events) {
						foreach($other_atim_events as $other_atim_event) {
							$other_atim_events_same_date[] = "Event=[$other_atim_event_type-".$other_atim_event['type']."] - Res=[".$other_atim_event['event_summary']."]";
						}
					}
					$import_summary[$report]['ERROR']["Unable to find Excel Clinical Event into ATiM but other ATiM events exists for the same date"][] = "Excel {Date=[$date] - Event=[$excel_field] - Res=[$res]}. ATiM {".implode(' && ', $other_atim_events_same_date)."}. Check this one has to be created both in ATiM and SARDO. $patient_identification_msg";
				} else {
					$import_summary[$report]['ERROR']["Unable to find Excel Clinical Event into ATiM"][] = "Date=[$date] - Event=[$excel_field] - Res=[$res]. Check this one has to be created both in ATiM and SARDO. $patient_identification_msg";
				}
			}
		}
	}
	//Other Clinical Exam
	for($id=1;$id<4;$id++) {
		$excel_clinical_event_type = str_replace(array('É', 'é'), array('e','e'),strtolower($new_line_data["Examens::Examen additonnel::Préciser l'examen$id"]));	
		$date_field = "Examens::Examen additonnel::Date$id";
		$excel_clinical_event_date = str_replace(' ', '', $new_line_data[$date_field]);
		$excel_clinical_event_res = (isset($new_line_data["Examens::Examen additonnel::Interprétation$id"])? $new_line_data["Examens::Examen additonnel::Interprétation$id"] : '');
		if(strlen($excel_clinical_event_date) && !in_array($excel_clinical_event_date, array('ND'))) {
			if(!preg_match('/([0-9]{2}\-){0,2}[0-9]{4}/', $excel_clinical_event_date)) {
				$import_summary[$report]['ERROR']["Clinical Event Date unknown (field ".$date_field.")"][] = "Val = [$excel_clinical_event_date]. This event won't be studied. $patient_identification_msg";
			} else {
				if(isset($atim_clinical_events[$excel_clinical_event_date])) {
					$event_match_done = false;
					foreach($atim_clinical_events[$excel_clinical_event_date] as $atim_clinical_events_same_date) {
						foreach($atim_clinical_events_same_date as $atim_clinical_event_same_date) {
							if(preg_match("/^$excel_clinical_event_type/", $atim_clinical_event_same_date['event_summary'])) {
								$event_match_done = true;
								$atim_clinical_event_master_ids_to_link_to_visit[] = $atim_clinical_event_same_date['event_master_id'];
							}								
						}
					}
					if(!$event_match_done) {
						$other_atim_events_same_date = array();
						foreach($atim_clinical_events[$excel_clinical_event_date] as $other_atim_event_type => $other_atim_events) {
							foreach($other_atim_events as $other_atim_event) {
								$other_atim_events_same_date[] = "Event=[$other_atim_event_type-".$other_atim_event['type']."] - Res=[".$other_atim_event['event_summary']."]";
							}
						}
						$import_summary[$report]['ERROR']["Unable to find Excel Clinical Event into ATiM but other ATiM events exists for the same date"][] = "Excel {Date=[$excel_clinical_event_date] - Event=[$excel_clinical_event_type] - Res=[$excel_clinical_event_res]}. ATiM {".implode(' && ', $other_atim_events_same_date)."}. Check this one has to be created both in ATiM and SARDO. $patient_identification_msg";
					}
				} else {
					$import_summary[$report]['ERROR']["Unable to find Excel Clinical Event into ATiM"][] = "Date=[$excel_clinical_event_date] - Event=[$excel_clinical_event_type] - Res=[$excel_clinical_event_res]. Check this one has to be created both in ATiM and SARDO. $patient_identification_msg";			
				}
			}
		}
	}

	// Treatment
	
	$atim_treatment_master_ids_to_link_to_visit = array();
	$tmp_fields_def = array(
		"Traitement::Radiothérapie seule::Date début" => array('atim_treatment_type' => 'radiotherapy', 'dosage_field' => "Traitement::Radiothérapie seule::Dose (Gray)"),
		"Traitement::Radiothérapie + Hormonothérapie::Date début (radio)" => array('atim_treatment_type' => 'radiotherapy', 'dosage_field' => "Traitement::Radiothérapie + Hormonothérapie::Dose (Gray)"),
		"Traitement::Radiothérapie + Hormonothérapie::Date début (hormono) MÉDICAMENT # 1" => array('atim_treatment_type' => 'hormonotherapy', 'dosage_field' => "Traitement::Radiothérapie + Hormonothérapie::Médicament # 1 et dose"),
		"Traitement::Radiothérapie + Hormonothérapie::Date début (hormono) MÉDICAMENT # 2" => array('atim_treatment_type' => 'hormonotherapy', 'dosage_field' => "Traitement::Radiothérapie + Hormonothérapie::Médicament # 2 et dose"),
		"Traitement::Hormonothérapie seule::Date début" => array('atim_treatment_type' => 'hormonotherapy', 'dosage_field' => "Traitement::Hormonothérapie seule::Médicament et dose"),
		"Traitement::Radiothérapie antalgique::Date début" => array('atim_treatment_type' => 'antalgic radiotherapy', 'dosage_field' => "Traitement::Radiothérapie antalgique::Dose (Gray)"),
		"Traitement::Hormonothérapie (2e ligne)::Date début" => array('atim_treatment_type' => 'hormonotherapy', 'dosage_field' => "Traitement::Hormonothérapie (2e ligne)::Médicament et dose"),
		"Traitement::Chimiothérapie::Date début" => array('atim_treatment_type' => 'radiotherapy', 'dosage_field' => "Traitement::Chimiothérapie::Médicament et dose"),
		"Traitement::Chimiothérapie (2e ligne)::Date début" => array('atim_treatment_type' => 'chemotherapy', 'dosage_field' => "Traitement::Chimiothérapie (2e ligne)::Posologie"),
		"Traitement::Autre traitement::Date début" => array('atim_treatment_type' => 'other treatment', 'dosage_field' => "Traitement::Autre traitement::Posologie (Dose)"),
		"Traitement::Traitement expérimental::Date début" => array('atim_treatment_type' => 'experimental treatment', 'dosage_field' => "Traitement::Traitement expérimental::Posologie (dose)"));
	foreach($tmp_fields_def as $date_field => $new_excel_field_def) {
		$excel_treatment_date = str_replace(' ', '', $new_line_data[$date_field]);
		$excel_treatment_dosage = empty($new_excel_field_def["dosage_field"])? '' : $new_line_data[$new_excel_field_def["dosage_field"]];
		if(strlen($excel_treatment_date) && !in_array($excel_treatment_date, array('ND'))) {
			if(!preg_match('/([0-9]{2}\-){0,2}[0-9]{4}/', $excel_treatment_date)) {
				$import_summary[$report]['ERROR']["Treatment Date unknown (field ".$date_field.")"][] = "Val = [$excel_treatment_date]. This event won't be studied. $patient_identification_msg";
			} else {					
				$atim_treatment_type = $new_excel_field_def["atim_treatment_type"];
				$excel_treatment_type = explode('::', $date_field);
				$excel_treatment_type = $excel_treatment_type[2];
				if(isset($atim_treatments[$excel_treatment_date][$atim_treatment_type])) {
					if(sizeof($atim_treatments[$excel_treatment_date][$atim_treatment_type]) != 1) {
						$import_summary[$report]['WARNING']["More than one $atim_treatment_type exists into ATiM for the same date"][] = "Date = [$excel_treatment_date]. Both will be linked to follow-up worksheet. $patient_identification_msg";
					}
					$tmp_treatment_master_ids = array();
					foreach($atim_treatments[$excel_treatment_date][$atim_treatment_type] as $treatment){
						$atim_treatment_master_ids_to_link_to_visit[] = $treatment['treatment_master_id'];
						$tmp_treatment_master_ids[] = $treatment['treatment_master_id'];
					}
					if(strlen($excel_treatment_dosage) && !in_array($excel_treatment_dosage, array('ND'))) {
						$excel_treatment_dosage = str_replace("'", "''", $excel_treatment_dosage);
						$query = "UPDATE procure_txd_followup_worksheet_treatments SET dosage = IFNULL(CONCAT('$excel_treatment_dosage. ', dosage), '$excel_treatment_dosage') WHERE treatment_master_id IN (".implode(',',$tmp_treatment_master_ids).");";
						customQuery($query, __LINE__);
						customQuery(str_replace('procure_txd_followup_worksheet_treatments', 'procure_txd_followup_worksheet_treatments_revs', $query), __LINE__);
						$import_summary[$report]['MESSAGE']["Patient $atim_code_barre"][] = "Added dosage ($excel_treatment_dosage) to $atim_treatment_type administarted on date $excel_treatment_date. ".$patient_identification_msg;
					}
				} else if(isset($atim_treatments[$excel_treatment_date])) {
					$other_atim_treatments_same_date = array();
					foreach($atim_treatments[$excel_treatment_date] as $other_atim_treatment_type => $other_atim_treatments) {
						foreach($other_atim_treatments as $other_atim_treatment) {
							$other_atim_treatments_same_date[] = "Treatment=[".$other_atim_treatment['treatment_type']."-".$other_atim_treatment['type']."]";
						}
					}
					$import_summary[$report]['ERROR']["Unable to find Excel Treatment into ATiM but other ATiM treatment exist for the same date"][] = "Excel {Date=[$excel_treatment_date] - Treatment=[$excel_treatment_type".(empty($excel_treatment_dosage)? '' : " - $excel_treatment_dosage")."]}. ATiM {".implode(' && ', $other_atim_treatments_same_date)."}. Check this one has to be created both in ATiM and SARDO. $patient_identification_msg";
				} else {
					$import_summary[$report]['ERROR']["Unable to find Excel Treatment into ATiM"][] = "Date=[$excel_treatment_date] - Treatment=[$excel_treatment_type".(empty($excel_treatment_dosage)? '' : " - $excel_treatment_dosage")."]. Check this one has to be created both in ATiM and SARDO. $patient_identification_msg";
				}
			}
		} else if(strlen($excel_treatment_dosage) && !in_array($excel_treatment_dosage, array('ND'))) {
			$excel_treatment_type = explode('::', $date_field);
			$excel_treatment_type = $excel_treatment_type[2];
			$import_summary[$report]['ERROR']["Treatment dose with no treatment date"][] = "Dose = [$excel_treatment_dosage] for treatment=[$excel_treatment_type]}. This treatment won't be studied. $patient_identification_msg";
		}
	}	

	// Create Main Followup Worksheet
	
	if($event_notes) {
		$event_master_data['event_summary'] = implode("\n", $event_notes);
		$create_followup_worksheet = true;
	}
	if($atim_aps_event_master_ids_to_link_to_visit) $create_followup_worksheet = true;
	if($atim_clinical_event_master_ids_to_link_to_visit) $create_followup_worksheet = true;
	if($atim_treatment_master_ids_to_link_to_visit) $create_followup_worksheet = true;
	if($create_followup_worksheet) {
		$event_master_id = customInsert($event_master_data, 'event_masters', __LINE__, false, true);
		$event_detail_data['event_master_id'] = $event_master_id;
		customInsert($event_detail_data, 'procure_ed_clinical_followup_worksheets', __LINE__, true, true);
		$queries_to_link_event_and_treatment = array();
		if($atim_aps_event_master_ids_to_link_to_visit) {
			$queries_to_link_event_and_treatment[] = "UPDATE event_masters SET procure_form_identification = '".$event_master_data['procure_form_identification']."' WHERE event_control_id = 54 AND id IN (".implode(',',$atim_aps_event_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE event_masters_revs SET procure_form_identification = '".$event_master_data['procure_form_identification']."' WHERE event_control_id = 54 AND id IN (".implode(',',$atim_aps_event_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE procure_ed_clinical_followup_worksheet_aps SET followup_event_master_id = $event_master_id WHERE event_master_id IN (".implode(',',$atim_aps_event_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE procure_ed_clinical_followup_worksheet_aps_revs SET followup_event_master_id = $event_master_id WHERE event_master_id IN (".implode(',',$atim_aps_event_master_ids_to_link_to_visit).");";				
		}
		if($atim_clinical_event_master_ids_to_link_to_visit) {
			$queries_to_link_event_and_treatment[] = "UPDATE event_masters SET procure_form_identification = '".$event_master_data['procure_form_identification']."' WHERE event_control_id = 55 AND id IN (".implode(',',$atim_clinical_event_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE event_masters_revs SET procure_form_identification = '".$event_master_data['procure_form_identification']."' WHERE event_control_id = 55 AND id IN (".implode(',',$atim_clinical_event_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE procure_ed_clinical_followup_worksheet_clinical_events SET followup_event_master_id = $event_master_id WHERE event_master_id IN (".implode(',',$atim_clinical_event_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE procure_ed_clinical_followup_worksheet_clinical_events_revs SET followup_event_master_id = $event_master_id WHERE event_master_id IN (".implode(',',$atim_clinical_event_master_ids_to_link_to_visit).");";
		}
		if($atim_treatment_master_ids_to_link_to_visit) {
			$queries_to_link_event_and_treatment[] = "UPDATE treatment_masters SET procure_form_identification = '".$event_master_data['procure_form_identification']."' WHERE treatment_control_id = 6 AND id IN (".implode(',',$atim_treatment_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE treatment_masters SET procure_form_identification = '".$event_master_data['procure_form_identification']."' WHERE treatment_control_id = 6 AND id IN (".implode(',',$atim_treatment_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE procure_txd_followup_worksheet_treatments SET followup_event_master_id = $event_master_id WHERE treatment_master_id IN (".implode(',',$atim_treatment_master_ids_to_link_to_visit).");";
			$queries_to_link_event_and_treatment[] = "UPDATE procure_txd_followup_worksheet_treatments_revs SET followup_event_master_id = $event_master_id WHERE treatment_master_id IN (".implode(',',$atim_treatment_master_ids_to_link_to_visit).");";
		}
		foreach($queries_to_link_event_and_treatment as $query)	customQuery($query, __LINE__);
		// Get dates limits
		$query = "
			SELECT MIN(event_date) as date, 'min' as date_type FROM event_masters WHERE event_date IS NOT NULL AND event_control_id IN (55,54) AND participant_id = $participant_id AND procure_form_identification = '".$event_master_data['procure_form_identification']."'
			UNION ALL
			SELECT MAX(event_date) as date, 'max' as date_type FROM event_masters WHERE event_date IS NOT NULL AND event_control_id IN (55,54) AND participant_id = $participant_id AND procure_form_identification = '".$event_master_data['procure_form_identification']."'
			UNION ALL
			SELECT MIN(start_date) as date, 'min' as date_type FROM treatment_masters WHERE start_date IS NOT NULL AND treatment_control_id = 6 AND participant_id = $participant_id AND procure_form_identification = '".$event_master_data['procure_form_identification']."'
			UNION ALL
			SELECT MAX(start_date) as date, 'max' as date_type FROM treatment_masters WHERE start_date IS NOT NULL AND treatment_control_id = 6 AND participant_id = $participant_id AND procure_form_identification = '".$event_master_data['procure_form_identification']."';";
		$query_res = customQuery($query, __LINE__);
		while($res = mysqli_fetch_assoc($query_res)) {

			if($res['date']) {
				if($res['date_type'] == 'min') {
					if(!$visit_dates_limits['start']) {
						$visit_dates_limits['start'] = $res['date'];
					} else if($res['date'] < $visit_dates_limits['start']) {
						$visit_dates_limits['start'] = $res['date'];
					}
				} else {
					if(!$visit_dates_limits['finish']) {
						$visit_dates_limits['finish'] = $res['date'];
					} else if($res['date'] > $visit_dates_limits['finish']) {
						$visit_dates_limits['finish'] = $res['date'];
					}
				}
			}
		}
		$visit_dates_limits['followup_event_master_id'] = $event_master_id;
		$visit_dates_limits['procure_form_identification'] = $event_master_data['procure_form_identification'];
	}	
	
	//Record visit infos
	$participant_session_data['visits_limits'][$visit] = $visit_dates_limits;	
}

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

function formatAtimDateToExcelDate($date, $accuracy) {
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

function formatExcelDateToAtimDate($date, $report, $field, $patient_identification_msg) {
	global $import_summary;
	$date = str_replace(' ', '', $date);
	if(preg_match('/^(0[1-9]|[12][0-9]|30|31)-(0[1-9]|10|11|12)-((19|20)[0-9]{2})$/', $date, $match)) {
		return array('date' => $match[3].'-'.$match[2].'-'.$match[1], 'accuracy' => 'c');
	} else if(preg_match('/^(0[1-9]|10|11|12)-((19|20)[0-9]{2})$/', $date, $match)) {
		return array('date' => $match[2].'-'.$match[1].'-01', 'accuracy' => 'd');
	} else if(preg_match('/^((19|20)[0-9]{2})$/', $date, $match)) {
		return array('date' => $match[1].'-06-01', 'accuracy' => 'm');
	} else if(strlen($date)) {
		$import_summary[$report]['ERROR']["Wrong date format"][] = "Date = [$date] for field [$field]. ".$patient_identification_msg;
	}
	return false;
}

function dislayErrorAndMessage($import_summary) {
	$import_summary_per_participant = array();
	$err_counter = 0;
	foreach($import_summary as $worksheet => $data1) {
		echo "<br><br><FONT COLOR=\"blue\" >
			=====================================================================<br>
			$worksheet<br>
			=====================================================================</FONT><br>";
		foreach($data1 as $message_type => $data2) {
			$color = 'black';
			$diff_than_message = true;
			switch($message_type) {
				case 'ERROR':
					$color = 'red';
					break;
				case 'WARNING':
					$color = 'orange';
					break;
				case 'MESSAGE':
					$color = 'green';
					$diff_than_message = false;
					break;
				default:
					echo '<br><br><br>UNSUPORTED message_type : '.$message_type.'<br><br><br>';
			}
			foreach($data2 as $error => $details) {
				$err_counter++;
				$error = str_replace("\n", ' ', utf8_decode("[ER#$err_counter] $error"));
				if($diff_than_message) echo "<br><br><FONT COLOR=\"$color\" ><b>$error</b></FONT><br>";
				foreach($details as $detail) {
					$detail = str_replace("\n", ' ', $detail);
					if($diff_than_message) echo ' - '.utf8_decode($detail)."<br>";	
					//Set $import_summary_per_participant
					if(preg_match('/^(.*)(See\ line\ [0-9]+\ NoLabo\ :\ .*)$/', $detail, $match)) {
						$patient_identification_msg = $match[2];
						$msg = str_replace($patient_identification_msg, '', $detail);
						$import_summary_per_participant[$patient_identification_msg][] = ($diff_than_message? "<FONT COLOR=\"$color\" ><b>$error</b></FONT> ": '')."$msg [<i>$worksheet</i>]";
					} else {
						pr($import_summary);
						pr("WARNING 23876 287632 8 : $error - $detail");
						die();
					}
				}
			}
		}
	}
	echo "<br><br><FONT COLOR=\"blue\" >
	=====================================================================<br>
	INFORMATION SORTED PER PARTICIPANT<br>
	=====================================================================</FONT><br>";
	foreach($import_summary_per_participant as $patient_identification_msg => $messages) {
		echo "<br><br><b>$patient_identification_msg</b><br>";
		foreach($messages as $msg) {
			echo ' - '.utf8_decode($msg)."<br>";
		}
	}	
}


?>