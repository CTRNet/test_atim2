<?php

require_once 'subject_demographics.php';
require_once 'clinical_outcome.php';
require_once 'collections.php';
require_once 'samples_and_aliquots.php';

set_time_limit('3600');

//-- EXCEL FILE ---------------------------------------------------------------------------------------------------------------------------

$file_name = "FormatedFull_Data_Transfer_16Oct14_1433.xls";
$file_path = "C:\_Perso\Server\ovcare\data\MigrationDataOct15".'\\'.$file_name;
require_once 'Excel/reader.php';

$tmp_xls_reader = new Spreadsheet_Excel_Reader();
$tmp_xls_reader->read($file_path);
$sheets_keys = array();
foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_keys[$tmp['name']] = $key;

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "ovcare";
$db_charset		= "utf8";

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(empty($db_port)? '' : ":").$db_port,
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed");
mysqli_autocommit($db_connection, false);

//-- GLOBAL VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------

global $modified_by;
$modified_by = '9';

global $modified;
$query = "SELECT NOW() as modified FROM study_summaries;";
$modified_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}

global $summary_msg;
$summary_msg = array();


global $voas_to_ids;
$voas_to_ids = array();

global $drug_ids;
$drug_ids = array();

//===========================================================================================================================================================
//===========================================================================================================================================================

echo "<br><FONT COLOR=\"green\" >
=====================================================================<br>
DATA EXPORT PROCESS : OVCARE<br>
source_file = $file_name<br>
<br>=====================================================================</FONT><br><br>";

// **** START ********************************************************

truncateATiMInventory();
truncateATiMPatientsClinicalData();
$atim_controls = loadATiMControlData();

// **** EXCEL DATA EXTRACTION ****************************************

//Load clinical data

$voa_to_patient_id = checkVoaNbrAndPatientId($tmp_xls_reader->sheets[$sheets_keys['Patient Id To Voa Corrections']]['cells'], $tmp_xls_reader->sheets[$sheets_keys['Subject Demographics']]['cells']);
$clinical_outcome_data = loadClinicalOutcomeData($tmp_xls_reader->sheets[$sheets_keys['Clinical Outcome']]['cells'], 'Clinical Outcome', $voa_to_patient_id);
$voas_to_collection_data = loadAndRecordClinicalData($tmp_xls_reader->sheets, $sheets_keys, $voa_to_patient_id, $clinical_outcome_data, $atim_controls);

//Load Inventory

$voas_to_collection_ids = recordCollection($voas_to_collection_data);
loadSamplesAndAliquots($tmp_xls_reader->sheets, $sheets_keys, $voas_to_collection_ids, $atim_controls);

// **** END **********************************************************

// Migration Done

// COLLECTIONS COMPLETION

$queries = array();
$queries[] = "UPDATE collections SET treatment_master_id = NULL WHERE id NOT IN (SELECT collection_id FROM sample_masters WHERE sample_control_id = ".$atim_controls['sample_aliquot_controls']['tissue']['sample_control_id'].")";
$queries[] = "UPDATE collections_revs SET treatment_master_id = NULL WHERE id NOT IN (SELECT collection_id FROM sample_masters WHERE sample_control_id = ".$atim_controls['sample_aliquot_controls']['tissue']['sample_control_id'].")";
//$queries[] = "DELETE FROM txd_surgeries WHERE path_num IS NULL AND ovcare_residual_disease IS NULL AND ovcare_neoadjuvant_chemotherapy LIKE '' AND ovcare_adjuvant_radiation LIKE '' AND treatment_master_id NOT IN (SELECT treatment_master_id FROM collections WHERE treatment_master_id IS NOT NULL)";
//$queries[] = "DELETE FROM treatment_masters WHERE treatment_control_id = ".Config::$treatment_controls['procedure - surgery and biopsy']['treatment_control_id']."  AND id NOT IN (SELECT treatment_master_id FROM txd_surgeries)";
$queries[] = "UPDATE sample_masters SET initial_specimen_sample_id = id WHERE parent_id IS NULL";
$queries[] = "UPDATE sample_masters_revs SET initial_specimen_sample_id = id WHERE parent_id IS NULL";
$queries[] = "UPDATE sample_masters SET sample_code = id";
$queries[] = "UPDATE sample_masters_revs SET sample_code = id";
foreach($queries as $query)  mysqli_query($db_connection, $query) or die("Error [$query] ");
//empty collections
$query = "SELECT participant_id, collection_notes, collection_voa_nbr FROM collections WHERE id NOT IN (SELECT distinct collection_id FROM sample_masters);";
$results = mysqli_query($db_connection, $query) or die("Dx Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
$participants_notes_from_ids = array();
while($row = $results->fetch_assoc()) {
	$participant_id = $row['participant_id'];
	$collection_notes = $row['collection_notes'];
	$collection_voa_nbr = $row['collection_voa_nbr'];
	if($collection_notes) $participants_notes_from_ids[$participant_id][] = "Empty collection note for VOA# $collection_voa_nbr : $collection_notes";
	$voa_identifiers = array(
		'misc_identifier_control_id' => $atim_controls['misc_identifier_controls']['unassigned VOA#']['id'],
		'participant_id' => $participant_id,
		'flag_unique' => $atim_controls['misc_identifier_controls']['unassigned VOA#']['flag_unique'],
		'identifier_value' => $collection_voa_nbr);
 	customInsertRecord($voa_identifiers, 'misc_identifiers');		
}
foreach($participants_notes_from_ids as $participant_id => $notes) {
	$query = "UPDATE participants set notes = '".str_replace("'", "''", implode(' & ', $notes))."' WHERE id = $participant_id;";
 	mysqli_query($db_connection, $query) or die("Error [$query] ");
 	mysqli_query($db_connection, str_replace('participants', 'participants_revs', $query)) or die("Error [$query] ");
}
$query = "DELETE FROM collections WHERE id NOT IN (SELECT distinct collection_id FROM sample_masters);";
mysqli_query($db_connection, $query) or die("Error [$query] ");
mysqli_query($db_connection, str_replace('collections', 'collections_revs', $query)) or die("Error [$query] ");
	
//Follow-up clean up

$queries = array();
$queries[] = "UPDATE ed_all_clinical_followups SET vital_status = 'alive/unknown' WHERE vital_status = 'alive';";
$queries[] = "UPDATE ed_all_clinical_followups SET vital_status = 'dead/unknown' WHERE vital_status = 'deceased';";
$queries[] = "UPDATE ed_all_clinical_followups_revs SET vital_status = 'alive/unknown' WHERE vital_status = 'alive';";
$queries[] = "UPDATE ed_all_clinical_followups_revs SET vital_status = 'dead/unknown' WHERE vital_status = 'deceased';";
foreach($queries as $query)  mysqli_query($db_connection, $query) or die("Error [$query] ");

// Empty date clean up 

$date_times_to_check = array(
	'consent_masters.consent_signed_date',
	'event_masters.event_date',
	'treatment_masters.start_date',
	'treatment_masters.finish_date',
	'collections.collection_datetime',
	'specimen_details.reception_datetime',
	'derivative_details.creation_datetime',
	'aliquot_masters.storage_datetime'			
);
foreach($date_times_to_check as $table_field) {
	$names = explode(".", $table_field);
	$query = "UPDATE ".$names[0]." SET ".$names[1]." = null,".$names[1]."_accuracy = null WHERE ".$names[1]." LIKE '0000-00-00%'";
	mysqli_query($db_connection, $query) or die("Error [$query] ");
	$query = "UPDATE ".$names[0]."_revs SET ".$names[1]." = null,".$names[1]."_accuracy = null WHERE ".$names[1]." LIKE '0000-00-00%'";
	mysqli_query($db_connection, $query) or die("Error [$query] ");
}

$query = "UPDATE participants SET last_modification = null WHERE last_modification LIKE '0000-00-00%'";
mysqli_query($db_connection, $query) or die("Error [$query] ");
mysqli_query($db_connection, str_replace('participants', 'participants_revs', $query)) or die("Error [$query] ");

$query = "UPDATE versions SET permissions_regenerated = 0;";
mysqli_query($db_connection, $query) or die("Error [$query] ");

mysqli_commit($db_connection);
dislayErrorAndMessage();


echo "<br><FONT COLOR=\"green\" >
=====================================================================<br>
Migration Done<br>
<br>=====================================================================</FONT><br><br>";

//===========================================================================================================================================================
// START functions
//===========================================================================================================================================================

function truncateATiMInventory() {
	global $db_connection;
	$queries = array(
		'TRUNCATE ovcare_ar_tissue_blocks;',
		'DELETE FROM aliquot_review_masters;',
		'TRUNCATE ovcare_spr_tissue_reviews;',
		'DELETE FROM specimen_review_masters;',
			
		'TRUNCATE ovcare_ar_tissue_blocks_revs;',
		'DELETE FROM aliquot_review_masters_revs;',
		'TRUNCATE ovcare_spr_tissue_reviews_revs;',
		'DELETE FROM specimen_review_masters_revs;',			
			
		'TRUNCATE aliquot_internal_uses;',
		'TRUNCATE aliquot_internal_uses_revs;',
			
		'TRUNCATE ad_tubes;',
		'TRUNCATE ad_blocks;',
		'TRUNCATE ad_tissue_slides;',
		'TRUNCATE ad_cell_slides;',
		'DELETE FROM aliquot_masters;',
		
		'TRUNCATE sd_spe_ascites;',
		'TRUNCATE sd_der_ascite_cells;',
		'TRUNCATE sd_der_ascite_sups;',
		'TRUNCATE sd_der_blood_cells;',
		'TRUNCATE sd_spe_bloods;',
		'TRUNCATE sd_der_serums;',
		'TRUNCATE sd_der_plasmas;',
		'TRUNCATE sd_der_rnas;',
		'TRUNCATE sd_der_dnas;',
		'TRUNCATE sd_der_amp_rnas;',
		'TRUNCATE sd_der_cdnas;',
		'TRUNCATE sd_der_cell_cultures;',
		'TRUNCATE sd_spe_salivas;',
		'TRUNCATE sd_spe_tissues;',
		'TRUNCATE specimen_details;',
		'TRUNCATE derivative_details;',
		'UPDATE sample_masters SET parent_id = NULL, initial_specimen_sample_id = null;',
		'DELETE FROM sample_masters;',
		
		'TRUNCATE sd_spe_ascites_revs;',
		'TRUNCATE sd_der_ascite_cells_revs;',
		'TRUNCATE sd_der_ascite_sups_revs;',
		'TRUNCATE sd_der_blood_cells_revs;',
		'TRUNCATE sd_spe_bloods_revs;',
		'TRUNCATE sd_der_serums_revs;',
		'TRUNCATE sd_der_plasmas_revs;',
		'TRUNCATE sd_der_rnas_revs;',
		'TRUNCATE sd_der_dnas_revs;',
		'TRUNCATE sd_der_amp_rnas_revs;',
		'TRUNCATE sd_der_cdnas_revs;',
		'TRUNCATE sd_der_cell_cultures_revs;',
		'TRUNCATE sd_spe_salivas_revs;',
		'TRUNCATE sd_spe_tissues_revs;',
		'TRUNCATE specimen_details_revs;',
		'TRUNCATE derivative_details_revs;',
		'UPDATE sample_masters_revs SET parent_id = NULL, initial_specimen_sample_id = null;',
		'DELETE FROM sample_masters_revs;',		
		
		'TRUNCATE std_freezers;',
		'TRUNCATE std_shelfs;',
		'TRUNCATE std_racks;',
		'TRUNCATE std_boxs;',
		'UPDATE storage_masters SET parent_id = NULL;',
		'DELETE FROM storage_masters;',
		
		'TRUNCATE std_freezers_revs;',
		'TRUNCATE std_shelfs_revs;',
		'TRUNCATE std_racks_revs;',
		'TRUNCATE std_boxs_revs;',
		'UPDATE storage_masters SET parent_id = NULL;',
		'DELETE FROM storage_masters_revs;');
	foreach($queries as $query)	mysqli_query($db_connection, $query) or die("[$query]".__FUNCTION__." ".__LINE__);
}

function truncateATiMPatientsClinicalData() {
	global $db_connection;
	$queries = array(
		'DELETE FROM collections;',
		'DELETE FROM collections_revs;',
		
		'TRUNCATE ed_all_clinical_followups;',
		'TRUNCATE ovcare_ed_study_inclusions;',
		'TRUNCATE ovcare_ed_ca125s;',
		'TRUNCATE ovcare_ed_brcas;',
		'DELETE FROM event_masters;',
		
		'TRUNCATE ed_all_clinical_followups_revs;',
		'TRUNCATE ovcare_ed_study_inclusions_revs;',
		'TRUNCATE ovcare_ed_ca125s_revs;',
		'TRUNCATE ovcare_ed_brcas_revs;',
		'DELETE FROM event_masters_revs;',
		
		'TRUNCATE txe_chemos;',
		'TRUNCATE txe_surgeries;',
		'TRUNCATE ovcare_txe_biopsies;',
		'DELETE FROM treatment_extend_masters;',
		'TRUNCATE txd_chemos;',
		'TRUNCATE txd_radiations;',
		'TRUNCATE txd_surgeries;',
		'TRUNCATE ovcare_txd_biopsies;',
		'DELETE FROM treatment_masters;',
		
		'TRUNCATE txe_chemos_revs;',
		'TRUNCATE txe_surgeries_revs;',
		'TRUNCATE ovcare_txe_biopsies_revs;',
		'DELETE FROM treatment_extend_masters_revs;',
		'TRUNCATE txd_chemos_revs;',
		'TRUNCATE txd_radiations_revs;',
		'TRUNCATE txd_surgeries_revs;',
		'TRUNCATE ovcare_txd_biopsies_revs;',
		'DELETE FROM treatment_masters_revs;',
		
		'TRUNCATE dxd_primaries;',
		'TRUNCATE dxd_remissions;',
		'TRUNCATE dxd_progressions;',
		'TRUNCATE dxd_recurrences;',
		'TRUNCATE ovcare_dxd_ovaries_endometriums;',
		'TRUNCATE ovcare_dxd_others;',
		'TRUNCATE dxd_secondaries;',
		'UPDATE diagnosis_masters SET parent_id = null, primary_id = null;',
		'DELETE FROM diagnosis_masters;',
		
		'TRUNCATE dxd_primaries_revs;',
		'TRUNCATE dxd_remissions_revs;',
		'TRUNCATE dxd_progressions_revs;',
		'TRUNCATE dxd_recurrences_revs;',
		'TRUNCATE ovcare_dxd_ovaries_endometriums_revs;',
		'TRUNCATE ovcare_dxd_others_revs;',
		'TRUNCATE dxd_secondaries_revs;',
		'UPDATE diagnosis_masters_revs SET parent_id = null, primary_id = null;',
		'DELETE FROM diagnosis_masters_revs;',
		
		'TRUNCATE misc_identifiers;',
		'TRUNCATE misc_identifiers_revs;',
		
		'TRUNCATE cd_nationals;',
		'DELETE FROM consent_masters;',
		'TRUNCATE cd_nationals_revs;',
		'DELETE FROM consent_masters_revs;',
		
		'DELETE FROM participants;',
		'DELETE FROM participants_revs;',
			
		'DELETE FROM drugs;',
		'DELETE FROM drugs_revs;',
			
		"DELETE FROM structure_permissible_values_customs WHERE control_id IN  (SELECT id FROM structure_permissible_values_custom_controls WHERE name IN ('Ovarian Histology','Uterine Histology','Path Review Type','Surgery Type'));",
		"DELETE FROM structure_permissible_values_customs_revs WHERE control_id IN  (SELECT id FROM structure_permissible_values_custom_controls WHERE name IN ('Ovarian Histology','Uterine Histology','Path Review Type','Surgery Type'));"
	);
	foreach($queries as $query)	mysqli_query($db_connection, $query) or die("[$query]".__FUNCTION__." ".__LINE__);
}

function loadATiMControlData(){
	global $db_connection;
	$controls = array();
	// MiscIdentifier
	$query = "select id, misc_identifier_name, flag_unique FROM misc_identifier_controls WHERE flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['misc_identifier_controls'][$row['misc_identifier_name']] = array('id' => $row['id'], 'flag_unique' => $row['flag_unique']);
	}
	//consent table => cd_nationals
	$query = "SELECT id FROM consent_controls WHERE controls_type = 'OvCaRe' AND flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die("Consent Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$row = $results->fetch_assoc();
	if(empty($row)) {
		die("No consent contol id");
	}
	$controls['consent_control_id'] = $row['id'];
	//dx => table ovcare_dxd_ovaries_endometriums
	$query = "SELECT id, category, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die("Dx Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		$controls['diagnosis_control_ids'][$row['category']][$row['controls_type']] = array($row['id'], $row['detail_tablename']);
	}
	//event => tables ed_all_clinical_followups, ovcare_ed_study_inclusions, ovcare_ed_ca125s, ovcare_ed_brcas
	$query = "select id,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['event_controls'][$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	//trt => txd_surgeries ovcare_txd_biopsies
	$query = "select tc.id, tc.tx_method, tc.detail_tablename, te.id as te_id, te.detail_tablename as te_detail_tablename
		from treatment_controls tc
		LEFT JOIN treatment_extend_controls te ON tc.treatment_extend_control_id = te.id AND te.flag_active = '1'
		where tc.flag_active = '1' AND tc.tx_method IN ('procedure - surgery and biopsy','procedure - biopsy','chemotherapy');";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['treatment_controls'][$row['tx_method']] = array(
			'treatment_control_id' => $row['id'], 
			'detail_tablename' => $row['detail_tablename'],
       		'te_treatment_control_id' => $row['te_id'],
			'te_detail_tablename' => $row['te_detail_tablename'],
		);
	}
	//sample
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('ascite', 'tissue', 'blood', 'serum', 'plasma', 'blood cell','saliva')";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['sample_aliquot_controls'][$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}
	if(sizeof($controls['sample_aliquot_controls']) != 7) die("get sample controls failed");
	foreach($controls['sample_aliquot_controls'] as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			$controls['sample_aliquot_controls'][$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}
	}
	// Samples Review
	$query = "SELECT arc.id AS aliquot_review_control_id, arc.detail_tablename AS aliquot_review_detail_tablename,
		src.id AS specimen_review_control_id, src.detail_tablename AS specimen_review_detail_tablename
		FROM aliquot_review_controls arc
		INNER JOIN specimen_review_controls src ON src.aliquot_review_control_id = arc.id
		WHERE src.review_type = 'ovcare tissue review' AND src.flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die("[".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$row = $results->fetch_assoc();
	if(empty($row)) {
		die("e2dascsaasc");
	}
	$controls['reviews_controls'] = array(
		'specimen_review_control_id' => $row['specimen_review_control_id'],
		'specimen_review_detail_tablename' => $row['specimen_review_detail_tablename'],
		'aliquot_review_control_id' => $row['aliquot_review_control_id'],
		'aliquot_review_detail_tablename' => $row['aliquot_review_detail_tablename']
	);
	//storage
	$query = "SELECT id, storage_type, detail_tablename FROM storage_controls WHERE flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die("Dx Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		$controls['storage_control_ids'][$row['storage_type']] = array($row['id'], $row['detail_tablename']);
	}
	return $controls;
}

//===========================================================================================================================================================
// End functions
//===========================================================================================================================================================

//===========================================================================================================================================================
// Other functions
//===========================================================================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function customInsertRecord($data_arr, $table_name, $is_detail_table = false) {
	global $db_connection;
	global $modified_by;
	global $modified;
	
	$tmp_set_id_for_check = array_key_exists('id', $data_arr)? $data_arr['id'] : null;
	
	$created = $is_detail_table? array() : array(
		"created"		=> "'$modified'", 
		"created_by"	=> $modified_by, 
		"modified"		=> "'$modified'",
		"modified_by"	=> $modified_by
	);
	
	$data_to_insert = array();
	foreach($data_arr as $key => $value) {
		if(strlen($value)) {
			$data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
		}
	}
	
	$insert_arr = array_merge($data_to_insert, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	$record_id = mysqli_insert_id($db_connection);
	$additional_fields = $is_detail_table? array('version_created' => "NOW()") : array('id' => "$record_id", 'version_created' => "NOW()");
	$rev_insert_arr = array_merge($data_to_insert, $additional_fields);
	$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
	mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	if(!is_null($tmp_set_id_for_check) && $tmp_set_id_for_check != $record_id) die('ERR 2332872872');//Not really usefull
	
	return $record_id;	
}

function getDateAndAccuracy($data_type, $data, $worksheet, $field, $line) {
	global $summary_msg;
	if(!array_key_exists($field, $data)) {
		pr("getDateAndAccuracy: Missing field [$field]");
		pr($data);
		die('ERR36100833');
	}
	$date = $data[$field];
	if(empty($date) || (strtoupper($date) == 'N/A')) {
		return null;
	} else if(preg_match('/^([0-9]+)$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date - $xls_offset) * 86400));
		return array('date' => $date, 'accuracy' => 'c');	
	} else if(preg_match('/^(19|20)([0-9]{2})\-((0[1-9])|(1[0-2]))\-((0[1-9])|([12][0-9])|(3[0-1]))$/',$date,$matches)) {
		return array('date' => $date, 'accuracy' => 'c');
	} else if(preg_match('/^(19|20)([0-9]{2})\-((0[1-9])|(1[0-2]))$/',$date,$matches)) {
		return array('date' => $date.'-01', 'accuracy' => 'd');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^((0[1-9])|([12][0-9])|(3[0-1]))[\/\-]((0[1-9])|(1[0-2]))[\/\-](19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[8].$matches[9].'-'.$matches[5].'-'.$matches[1], 'accuracy' => 'c');
	} else {
		$summary_msg[$data_type]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [worksheet $worksheet - field '$field' - line: $line]";
		return null;
	}	
}

function customArrayCombineAndUtf8Encode($headers, $data) {
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

function dislayErrorAndMessage() {
	global $summary_msg;
	
	foreach($summary_msg as $data_type => $msg_arr) {

		echo "<br><br><FONT COLOR=\"blue\" >
		=====================================================================<br><br>
		PROCESS SUMMARY: $data_type
		<br><br>=====================================================================
		</FONT><br>";
			
		if(!empty($msg_arr['@@ERROR@@'])) {
			echo "<br><FONT COLOR=\"red\" ><b> ** Errors summary ** </b> </FONT><br>";
			foreach($msg_arr['@@ERROR@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"red\" >". utf8_decode($type) . "</FONT><br>";
				$counter = 0;
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
			}
		}
		unset($msg_arr['@@ERROR@@']);

		if(!empty($msg_arr['@@WARNING@@'])) {
			echo "<br><FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> </FONT><br>";
			foreach($msg_arr['@@WARNING@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"orange\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
			}
		}
		unset($msg_arr['@@WARNING@@']);

		if(!empty($msg_arr['@@MESSAGE@@'])) {
			echo "<br><FONT COLOR=\"green\" ><b> ** Message ** </b> </FONT><br>";
			foreach($msg_arr['@@MESSAGE@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
			}
		}
		unset($msg_arr['@@MESSAGE@@']);
		
		if(!empty($msg_arr)) {
			pr($msg_arr);die('ERR327327732');
		}
	}
}

?> 