<?php

/*
 * Import all SARDO data from ATiM - Oncology Axis to ATiM - PROCURE
 * Executed on v263 - 20140808.
*/

set_time_limit('3600');

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------


global $db_icm_schema;
global $db_procure_schema;

$is_server = false;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_charset		= "utf8";

$db_icm_schema	= "icm";
$db_procure_schema	= "procurechum";

if($is_server) {
	$db_ip			= "localhost";
	$db_port 		= "";
	$db_user 		= "root";
	$db_pwd			= "";
	$db_charset		= "utf8";

	$db_icm_schema		= "icmtmp";
	$db_procure_schema		= "procuretmp";
}

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_icm_schema) or die("db selection failed 1");
@mysqli_select_db($db_connection, $db_procure_schema) or die("db selection failed 2");

//--------------------------------------------------------------------------------------------------------------------------------------------

global $processed_by;
global $process_date;

$processed_by = '9';

$query = "SELECT NOW() as modified FROM $db_procure_schema.study_summaries;";
$modified_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$process_date = mysqli_fetch_assoc($modified_res);
if($process_date) {
	$process_date = $process_date['modified'];
} else {
	die('ERR 9993999399');
}

//=========================================================================================================================================================
// Build list of participant id
//=========================================================================================================================================================

$query = "SELECT p.id AS participant_id, mid.identifier_value
	FROM $db_procure_schema.participants p
	LEFT JOIN $db_procure_schema.misc_identifiers mid ON mid.participant_id = p.id AND mid.deleted <> 1 AND mid.misc_identifier_control_id = (SELECT id FROM $db_procure_schema.misc_identifier_controls mc WHERE mc.misc_identifier_name = 'prostate bank no lab')
	WHERE p.deleted <> 1";
$query_res_procure = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$validated_participant_ids = array();
While($res_procure = mysqli_fetch_assoc($query_res_procure)) {
	$participant_id = $res_procure['participant_id'];
	$no_labo = $res_procure['identifier_value'];
	if($no_labo) {
		$query = "SELECT p.id
			FROM $db_icm_schema.participants p
			INNER JOIN $db_icm_schema.misc_identifiers mid ON mid.participant_id = p.id
			WHERE p.deleted <> 1 AND mid.deleted <> 1 AND mid.misc_identifier_control_id = (SELECT id FROM $db_icm_schema.misc_identifier_controls mc WHERE mc.misc_identifier_name = 'prostate bank no lab')
			AND p.id = $participant_id
			AND mid.identifier_value = '$no_labo';";
		$query_res_icm = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
		if(!$query_res_icm->num_rows) {
			echo "ATiM PROCURE Participant (id = $participant_id) with NoLabo $no_labo does not match an ATiM ICM participant: No ATiM ICM data will be imported!<br>";
		} else if($query_res_icm->num_rows == 1) {
			$validated_participant_ids[$participant_id] = $participant_id;
		} else {
			die('ERR 23876 287632 '.$participant_id.$no_labo);
		}
	} else {
		echo "ATiM PROCURE Participant (id = $participant_id) has no NoLabo: No ATiM ICM data will be imported!<br>";
	}
}
$validated_participant_ids = implode(',', $validated_participant_ids);

//=========================================================================================================================================================
// Event procure follow-up worksheet - aps
//=========================================================================================================================================================

// Get control ids

$query = "SELECT id FROM $db_icm_schema.event_controls WHERE event_type = 'psa' AND flag_active = 1";
$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$icm_event_control_id = $res['id'];
$query = "SELECT id FROM $db_procure_schema.event_controls WHERE event_type = 'procure follow-up worksheet - aps' AND flag_active = 1";
$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$procure_event_control_id = $res['id'];

// Delete data from tables

$cleanup_queries = array(
	"TRUNCATE $db_procure_schema.procure_ed_clinical_followup_worksheet_aps;",
	"TRUNCATE $db_procure_schema.procure_ed_clinical_followup_worksheet_aps_revs;",
	"DELETE FROM $db_procure_schema.event_masters WHERE event_control_id = $procure_event_control_id;",
	"DELETE FROM $db_procure_schema.event_masters_revs WHERE event_control_id = $procure_event_control_id;");
foreach($cleanup_queries as $query)  mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

// Import data

$query = "ALTER TABLE $db_procure_schema.event_masters ADD COLUMN tmp_total_ngml decimal(10,2);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
// Master
$query  = "INSERT INTO $db_procure_schema.event_masters
	(participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, tmp_total_ngml, created, created_by, modified, modified_by)
	(SELECT em.participant_id, $procure_event_control_id, 'n/a', em.event_date, em.event_date_accuracy, em.event_summary, ed.value, '$process_date', $processed_by, '$process_date', $processed_by
	FROM $db_icm_schema.event_masters em
	INNER JOIN $db_icm_schema.qc_nd_ed_psas ed ON ed.event_master_id = em.id
	WHERE em.deleted <> 1 AND em.event_control_id = $icm_event_control_id AND em.participant_id IN ($validated_participant_ids));";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query  = "INSERT INTO $db_procure_schema.event_masters_revs
	(participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, id, version_created, modified_by)
	(SELECT participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, id, created, modified_by FROM $db_procure_schema.event_masters WHERE event_control_id = $procure_event_control_id)";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
//Detail
$query  = "INSERT INTO $db_procure_schema.procure_ed_clinical_followup_worksheet_aps (event_master_id, total_ngml) (SELECT id, tmp_total_ngml FROM event_masters WHERE event_control_id = $procure_event_control_id);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query  = "INSERT INTO $db_procure_schema.procure_ed_clinical_followup_worksheet_aps_revs (event_master_id, total_ngml, version_created) (SELECT event_master_id, total_ngml, '$process_date' FROM procure_ed_clinical_followup_worksheet_aps);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
//Drop
$query = "ALTER TABLE $db_procure_schema.event_masters DROP COLUMN tmp_total_ngml;";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

//=========================================================================================================================================================
// Event procure follow-up worksheet - clinical event
//=========================================================================================================================================================

$query = "SELECT id FROM $db_procure_schema.event_controls WHERE event_type = 'procure follow-up worksheet - clinical event' AND flag_active = 1";
$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$procure_event_control_id = $res['id'];

$cleanup_queries = array(
	"TRUNCATE $db_procure_schema.procure_ed_clinical_followup_worksheet_clinical_events;",
	"TRUNCATE $db_procure_schema.procure_ed_clinical_followup_worksheet_clinical_events_revs;",
	"DELETE FROM $db_procure_schema.event_masters WHERE event_control_id = $procure_event_control_id;",
	"DELETE FROM $db_procure_schema.event_masters_revs WHERE event_control_id = $procure_event_control_id;");
foreach($cleanup_queries as $query)  mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

$query = "ALTER TABLE $db_procure_schema.event_masters ADD COLUMN tmp_type varchar(50);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

/* SARDO : IMAGE Treatments
+---------------------------+------------------------------------------------------------------------+
| name                      | value                                                                  |
+---------------------------+------------------------------------------------------------------------+
-- classé
| SARDO : IMAGE Treatments  | irm abdominale                                                         |
| SARDO : IMAGE Treatments  | irm de la colonne vertebrale                                           |
| SARDO : IMAGE Treatments  | irm de la tete                                                         |
| SARDO : IMAGE Treatments  | irm des sinus                                                          |
| SARDO : IMAGE Treatments  | irm du bassin                                                          |
| SARDO : IMAGE Treatments  | irm du cerveau                                                         |
| SARDO : IMAGE Treatments  | irm du cou                                                             |
| SARDO : IMAGE Treatments  | irm du foie                                                            |
| SARDO : IMAGE Treatments  | irm du plexus brachial                                                 |
| SARDO : IMAGE Treatments  | irm du rachis dorsal                                                   |
| SARDO : IMAGE Treatments  | irm du rachis lombaire                                                 |
| SARDO : IMAGE Treatments  | irm du sein                                                            |
| SARDO : IMAGE Treatments  | irm osseuse                                                            |
| SARDO : IMAGE Treatments  | irm pelvienne                                                          | 
| SARDO : IMAGE Treatments  | scintigraphie osseuse                                                  |
| SARDO : IMAGE Treatments  | tomodensitometrie abdominale                                           |
| SARDO : IMAGE Treatments  | tomodensitometrie abdominale et pelvienne                              |
| SARDO : IMAGE Treatments  | tomodensitometrie abdominale et thoracique                             |
| SARDO : IMAGE Treatments  | tomodensitometrie abdominale, thoracique et pelvienne                  |
| SARDO : IMAGE Treatments  | tomodensitometrie cervicale, thoracique et abdominale                  |
| SARDO : IMAGE Treatments  | tomodensitometrie cervicale, thoracique, abdominale et pelvienne       |
| SARDO : IMAGE Treatments  | tomodensitometrie cranienne                                            |
| SARDO : IMAGE Treatments  | tomodensitometrie de la colonne vertebrale                             |
| SARDO : IMAGE Treatments  | tomodensitometrie des membres inferieurs                               |
| SARDO : IMAGE Treatments  | tomodensitometrie des orbites                                          |
| SARDO : IMAGE Treatments  | tomodensitometrie du cerveau                                           |
| SARDO : IMAGE Treatments  | tomodensitometrie du cou                                               |
| SARDO : IMAGE Treatments  | tomodensitometrie du cou et du thorax                                  |
| SARDO : IMAGE Treatments  | tomodensitometrie du rachis cervival                                   |
| SARDO : IMAGE Treatments  | tomodensitometrie du rachis dorsal                                     |
| SARDO : IMAGE Treatments  | tomodensitometrie du rachis lombaire                                   |
| SARDO : IMAGE Treatments  | tomodensitometrie osteo-articulaire                                    |
| SARDO : IMAGE Treatments  | tomodensitometrie pelvienne                                            |
| SARDO : IMAGE Treatments  | tomodensitometrie thoracique                                           |
| SARDO : IMAGE Treatments  | tomographie d'emission par positron de la region cervicale et du tronc |
| SARDO : IMAGE Treatments  | tomographie d'emission par positron du cerveau                         |
| SARDO : IMAGE Treatments  | tomographie d'emission par positron du corps entier                    |
-- autre
| SARDO : IMAGE Treatments  | angioscan                                                              |
| SARDO : IMAGE Treatments  | bronchoscopie                                                          |
| SARDO : IMAGE Treatments  | coloscopie                                                             |
| SARDO : IMAGE Treatments  | cystoscopie                                                            |
| SARDO : IMAGE Treatments  | echoendoscopie                                                         |
| SARDO : IMAGE Treatments  | echographie abdominale                                                 |
| SARDO : IMAGE Treatments  | echographie abdominale et pelvienne                                    |
| SARDO : IMAGE Treatments  | echographie cervicale                                                  |
| SARDO : IMAGE Treatments  | echographie de l'aisselle                                              |
| SARDO : IMAGE Treatments  | echographie de la thyroide                                             |
| SARDO : IMAGE Treatments  | echographie des seins                                                  |
| SARDO : IMAGE Treatments  | echographie des testicules                                             |
| SARDO : IMAGE Treatments  | echographie endo-rectale de la loge prostatique                        |
| SARDO : IMAGE Treatments  | echographie endo-rectale de la prostate                                |
| SARDO : IMAGE Treatments  | echographie pelvienne                                                  |
| SARDO : IMAGE Treatments  | echographie pelvienne endo-rectale                                     |
| SARDO : IMAGE Treatments  | echographie pelvienne endo-vaginale                                    |
| SARDO : IMAGE Treatments  | echographie pelvienne sus-pubienne                                     |
| SARDO : IMAGE Treatments  | gastroscopie                                                           |
| SARDO : IMAGE Treatments  | gorgee barytee                                                         |
| SARDO : IMAGE Treatments  | hysteroscopie                                                          |
| SARDO : IMAGE Treatments  | laryngoscopie                                                          |
| SARDO : IMAGE Treatments  | lavement baryte                                                        |
| SARDO : IMAGE Treatments  | mammographie                                                           |
| SARDO : IMAGE Treatments  | pyelogramme intraveineux                                               |
| SARDO : IMAGE Treatments  | radiographie abdominale                                                |
| SARDO : IMAGE Treatments  | radiographie osseuse                                                   |
| SARDO : IMAGE Treatments  | radiographie thoracique                                                |
| SARDO : IMAGE Treatments  | rhino-pharyngo-laryngoscopie                                           |
| SARDO : IMAGE Treatments  | scintigraphie cerebrale                                                |
| SARDO : IMAGE Treatments  | scintigraphie hepatosplenique                                          |
| SARDO : IMAGE Treatments  | scintigraphie pancorporelle                                            |
| SARDO : IMAGE Treatments  | scintigraphie renale                                                   |
| SARDO : IMAGE Treatments  | scintigraphie thyroidienne                                             |
| SARDO : IMAGE Treatments  | serie metastatique                                                     |
| SARDO : IMAGE Treatments  | uroscan                                                                |

*/

$query = "SELECT id FROM $db_icm_schema.treatment_controls WHERE tx_method = 'sardo treatment - image' AND flag_active = 1";
$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$icm_treatment_control_id = $res['id'];

$clinical_events_definitions = array(
	'bone scintigraphy' => "treatment LIKE 'scintigraphie osseuse'",
	'MRI' => "treatment LIKE 'irm %'",
	'CT-scan' => "treatment LIKE 'tomodensitometrie %'",
	'PET-scan' => "treatment LIKE 'tomographie %'");
$tmp_other_definitions = array();
foreach($clinical_events_definitions as $tmp_condition) $tmp_other_definitions[] = str_replace(' LIKE ', ' NOT LIKE ', $tmp_condition);
$clinical_events_definitions['other imaging'] = implode(' AND ', $tmp_other_definitions);
foreach($clinical_events_definitions as $clinical_event_type => $conditions) {
	$query  = "INSERT INTO $db_procure_schema.event_masters
		(participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, created, created_by, modified, modified_by, tmp_type)
		(SELECT participant_id, $procure_event_control_id, 'n/a', start_date, start_date_accuracy, IFNULL(CONCAT(treatment,' : ', results), treatment), '$process_date', $processed_by, '$process_date', $processed_by, '$clinical_event_type'
		FROM $db_icm_schema.treatment_masters tm
		INNER JOIN $db_icm_schema.qc_nd_txd_sardos td ON tm.id = td.treatment_master_id
		INNER JOIN $db_icm_schema.treatment_extend_masters tem ON tem.treatment_master_id = tm.id AND tem.deleted <> 1
		INNER JOIN $db_icm_schema.qc_nd_txe_sardos ted ON ted.treatment_extend_master_id = tem.id
		WHERE tm.deleted <> 1 AND treatment_control_id = $icm_treatment_control_id AND $conditions AND participant_id IN ($validated_participant_ids));";
	mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");	
}

/*
 * SARDO : BIOP Treatments
 * SARDO : EXAM Treatments
 * SARDO : CYTO Treatments
 * SARDO : BILAN Treatments
 * SARDO : REVISION Treatments (NON)
 * SARDO : OBS Treatments
 * SARDO : VISITE Treatments
 * SARDO : SYMPT Treatments
 * SARDO : RESUME Treatments (NON)
 */ 

$other_sardo_exams = array(
	'sardo treatment - biop',
	'sardo treatment - exam',
	'sardo treatment - cyto',
	'sardo treatment - bilan',
	'sardo treatment - obs',
	'sardo treatment - visite',
	'sardo treatment - sympt');
foreach($other_sardo_exams as $tx_method) {
	$query = "SELECT id FROM $db_icm_schema.treatment_controls WHERE tx_method = '$tx_method' AND flag_active = 1";
	$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
	$res = mysqli_fetch_assoc($query_res);
	$icm_treatment_control_id = $res['id'];
	$query  = "INSERT INTO $db_procure_schema.event_masters
		(participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, created, created_by, modified, modified_by, tmp_type)
		(SELECT participant_id, $procure_event_control_id, 'n/a', start_date, start_date_accuracy, IFNULL(CONCAT(treatment,' : ', results), treatment), '$process_date', $processed_by, '$process_date', $processed_by, 'other'
		FROM $db_icm_schema.treatment_masters tm
		INNER JOIN $db_icm_schema.qc_nd_txd_sardos td ON tm.id = td.treatment_master_id
		INNER JOIN $db_icm_schema.treatment_extend_masters tem ON tem.treatment_master_id = tm.id AND tem.deleted <> 1
		INNER JOIN $db_icm_schema.qc_nd_txe_sardos ted ON ted.treatment_extend_master_id = tem.id
		WHERE tm.deleted <> 1 AND treatment_control_id = $icm_treatment_control_id AND participant_id IN ($validated_participant_ids));";
	mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
}

/*
 * End of the procure follow-up worksheet - clinical event creation
 */

$query  = "INSERT INTO $db_procure_schema.procure_ed_clinical_followup_worksheet_clinical_events (event_master_id, type) (SELECT id, tmp_type FROM event_masters WHERE event_control_id = $procure_event_control_id);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query = "ALTER TABLE $db_procure_schema.event_masters DROP COLUMN tmp_type;";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

// Revs tables
$query  = "INSERT INTO $db_procure_schema.event_masters_revs
	(participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, id, version_created, modified_by)
	(SELECT participant_id, event_control_id, procure_form_identification, event_date, event_date_accuracy, event_summary, id, created, modified_by FROM $db_procure_schema.event_masters WHERE event_control_id = $procure_event_control_id)";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query  = "INSERT INTO $db_procure_schema.procure_ed_clinical_followup_worksheet_clinical_events_revs (event_master_id, type, version_created) (SELECT event_master_id, type, '$process_date' FROM procure_ed_clinical_followup_worksheet_clinical_events);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

//=========================================================================================================================================================
// Treatment procure follow-up worksheet - treatment
//=========================================================================================================================================================

$query = "SELECT id FROM $db_procure_schema.treatment_controls WHERE tx_method = 'procure follow-up worksheet - treatment' AND flag_active = 1";
$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$procure_treatment_control_id = $res['id'];

$cleanup_queries = array(
	"TRUNCATE $db_procure_schema.procure_txd_followup_worksheet_treatments;",
	"TRUNCATE $db_procure_schema.procure_txd_followup_worksheet_treatments_revs;",
	"DELETE FROM $db_procure_schema.treatment_masters WHERE treatment_control_id = $procure_treatment_control_id;",
	"DELETE FROM $db_procure_schema.treatment_masters_revs WHERE treatment_control_id = $procure_treatment_control_id;");
foreach($cleanup_queries as $query)  mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

$query = "ALTER TABLE $db_procure_schema.treatment_masters ADD COLUMN tmp_treatment_type varchar(50), ADD COLUMN tmp_type varchar(250);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

/* SARDO : RADIO Treatments
 * SARDO : HORM Treatments
 * SARDO : CHIMIO Treatments
 * 
 * SARDO : CHIR Treatments
 * SARDO : IMMUNO Treatments
 * SARDO : AUTRE Treatments
 * SARDO : MEDIC Treatments
 * SARDO : PAL Treatments
 * SARDO : PROTOC Treatments
 */

$treatment_definitions = array(
	'sardo treatment - radio' => 'radiotherapy',
	'sardo treatment - horm' => 'hormonotherapy',
	'sardo treatment - chimio' => 'chemotherapy',
	'sardo treatment - chir' => 'other treatment',
	'sardo treatment - immuno' => 'other treatment',
	'sardo treatment - autre' => 'other treatment',
	'sardo treatment - medic' => 'other treatment',
	'sardo treatment - pal' => 'other treatment',
	'sardo treatment - protoc' => 'other treatment');
foreach($treatment_definitions as $tx_method => $treatment_type) {
	$query = "SELECT id FROM $db_icm_schema.treatment_controls WHERE tx_method = '$tx_method' AND flag_active = 1";
	$query_res = mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
	$res = mysqli_fetch_assoc($query_res);
	$icm_treatment_control_id = $res['id'];
	$query  = "INSERT INTO $db_procure_schema.treatment_masters
		(participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, created, created_by, modified, modified_by, tmp_treatment_type, tmp_type)
		(SELECT participant_id, $procure_treatment_control_id, 'n/a', start_date, start_date_accuracy, finish_date, finish_date_accuracy, results, '$process_date', $processed_by, '$process_date', $processed_by, '$treatment_type', treatment 
		FROM $db_icm_schema.treatment_masters tm
		INNER JOIN $db_icm_schema.qc_nd_txd_sardos td ON tm.id = td.treatment_master_id
		INNER JOIN $db_icm_schema.treatment_extend_masters tem ON tem.treatment_master_id = tm.id AND tem.deleted <> 1
		INNER JOIN $db_icm_schema.qc_nd_txe_sardos ted ON ted.treatment_extend_master_id = tem.id
		WHERE tm.deleted <> 1 AND treatment_control_id = $icm_treatment_control_id AND participant_id IN ($validated_participant_ids));";
	mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
}
$query  = "UPDATE $db_procure_schema.treatment_masters SET tmp_treatment_type = 'experimental treatment' WHERE tmp_type LIKE 'etude %';";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query  = "INSERT INTO $db_procure_schema.procure_txd_followup_worksheet_treatments (treatment_master_id, treatment_type, type) (SELECT id, tmp_treatment_type, tmp_type FROM treatment_masters WHERE treatment_control_id = $procure_treatment_control_id);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query = "ALTER TABLE $db_procure_schema.treatment_masters DROP COLUMN tmp_treatment_type, DROP COLUMN tmp_type;";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

// Revs tables
$query  = "INSERT INTO $db_procure_schema.treatment_masters_revs
	(participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, id, version_created, modified_by)
	(SELECT participant_id, treatment_control_id, procure_form_identification, start_date, start_date_accuracy, finish_date, finish_date_accuracy, notes, id, created, modified_by FROM $db_procure_schema.treatment_masters WHERE treatment_control_id = $procure_treatment_control_id)";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");
$query  = "INSERT INTO $db_procure_schema.procure_txd_followup_worksheet_treatments_revs (treatment_master_id, treatment_type, type, version_created) (SELECT treatment_master_id, treatment_type, type, '$process_date' FROM procure_txd_followup_worksheet_treatments);";
mysqli_query($db_connection, $query) or die("query failed [".$query."] (line:".__LINE__.") : " . mysqli_error($db_connection)."]");

//====================================================================================================================================================
//====================================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}
