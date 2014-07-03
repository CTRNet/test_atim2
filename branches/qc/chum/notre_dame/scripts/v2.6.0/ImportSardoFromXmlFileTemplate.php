<?php

//==============================================================================================
// Variables
//==============================================================================================

//TODO set to false after first import
$is_initial_import = true;
$is_server = true;

$file_path = "C:/_Perso/Server/icm/data/Export_CRCHUM_deno_20140626.XML";
$file_path = "C:/_Perso/Server/icm/data/Export_CRCHUM_short.XML";
if($is_server) $file_path = "/ch06chuma6134/Export_CRCHUM.XML";
if(!file_exists($file_path)) importDie("ERR_XML00001 : The file $file_path does not exist!");
Sortir avec un message dans atim import....

global $import_summary;
$import_summary = array();

//==============================================================================================
//Database Connection
//==============================================================================================

global $db_connection;

$db_ip			= "127.0.0.1";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "icm";
$db_charset		= "utf8";

if($is_server) {
	$db_ip			= "localhost";
	$db_user 		= "root";
	$db_pwd			= "";
	$db_schema		= "icmtmp";
}

$db_connection = @mysqli_connect(
	$db_ip.(!empty($db_port)? ":".$db_port : ''),
	$db_user,
	$db_pwd
) or importDie("Could not connect to MySQL", false);
if(!mysqli_set_charset($db_connection, $db_charset)){
	importDie("Invalid charset", false);
}
@mysqli_select_db($db_connection, $db_schema) or importDie("db selection failed", false);

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE username = 'SardoMigration';", __LINE__);
if($query_res->num_rows != 1) importDie('ERR : No user SardoMigration!');
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

//TODO manage commit rollback
//TODO fair un dump base de données avant chaque process

//==============================================================================================
// Table Clean Up and get controls data
//==============================================================================================

// Treatment

global $treatment_controls;
$treatment_controls = array();
$query_res = customQuery("SELECT tc.id as treatment_control_id, tc.detail_tablename as treatment_detail_tablename, tc.tx_method, tc.treatment_extend_control_id, tec.detail_tablename treatment_extend_detail_tablename
		FROM treatment_controls tc LEFT JOIN treatment_extend_controls tec ON tec.id = tc.treatment_extend_control_id  
		WHERE tc.flag_active = 1;", __LINE__);
while($res =  mysqli_fetch_assoc($query_res)) {
	$treatment_controls[$res['tx_method']] = $res;
	if($res['treatment_detail_tablename'] != 'qc_nd_txd_sardos') importDie("ERR_TX00002 : Treatment deail table error!");
	if($res['treatment_extend_detail_tablename'] != 'qc_nd_txe_sardos') importDie("ERR_TX00003 : Treatment extend deail table error!");
}
customQuery("DELETE FROM qc_nd_txe_sardos;", __LINE__);
customQuery("DELETE FROM treatment_extend_masters;", __LINE__);
customQuery("DELETE FROM qc_nd_txe_sardos_revs;", __LINE__);
customQuery("DELETE FROM treatment_extend_masters_revs;", __LINE__);
customQuery("DELETE FROM qc_nd_txd_sardos;", __LINE__);
customQuery("DELETE FROM treatment_masters;", __LINE__);
customQuery("DELETE FROM qc_nd_txd_sardos_revs;", __LINE__);
customQuery("DELETE FROM treatment_masters_revs;", __LINE__);

// Event (rapport)

global $rapport_event_controls;
$rapport_event_controls = array();
$query_res = customQuery("SELECT id, detail_tablename, event_type FROM event_controls WHERE event_type IN ('estrogen receptor report (RE)', 'progestin receptor report (RP)', 'her2/neu') AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 3) importDie('ERR_LAB00002 : Rapports unknown!');
while($res =  mysqli_fetch_assoc($query_res)) {
	$rapport_event_controls[$res['event_type']] = $res;
	customQuery("DELETE FROM ".$res['detail_tablename'].";", __LINE__);
	customQuery("DELETE FROM event_masters WHERE event_control_id = ".$res['id'].";", __LINE__);
	customQuery("DELETE FROM ".$res['detail_tablename']."_revs;", __LINE__);
	customQuery("DELETE FROM event_masters_revs WHERE event_control_id = ".$res['id'].";", __LINE__);
}

// Event (PSA/CA125)

global $ca125_psa_event_controls;
$ca125_psa_event_controls = array();
if($is_initial_import) {
	$query_res = customQuery("SELECT id, detail_tablename, event_type FROM event_controls WHERE event_type IN ('ca125', 'psa') AND flag_active = 1;", __LINE__);
	if($query_res->num_rows != 2) importDie('ERR_LAB00001 : CA125 and PAS Lab unknown!');
	while($res =  mysqli_fetch_assoc($query_res)) {
		$ca125_psa_event_controls[$res['event_type']] = $res;
		customQuery("DELETE FROM ".$res['detail_tablename'].";", __LINE__);
		customQuery("DELETE FROM event_masters WHERE event_control_id = ".$res['id'].";", __LINE__);
		customQuery("DELETE FROM ".$res['detail_tablename']."_revs;", __LINE__);
		customQuery("DELETE FROM event_masters_revs WHERE event_control_id = ".$res['id'].";", __LINE__);
	}
}

// Diagnosis

global $diagnosis_controls;
$query_res = customQuery("SELECT id, detail_tablename FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'sardo' AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 1) importDie('ERR_DX00002 : SARDO Primary diagnosis unknown!');
$diagnosis_controls = mysqli_fetch_assoc($query_res);
customQuery("DELETE FROM ".$diagnosis_controls['detail_tablename'].";", __LINE__);
customQuery("UPDATE diagnosis_masters SET parent_id = null, primary_id = null WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
customQuery("DELETE FROM diagnosis_masters WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
customQuery("DELETE FROM ".$diagnosis_controls['detail_tablename']."_revs;", __LINE__);
customQuery("UPDATE diagnosis_masters_revs SET parent_id = null, primary_id = null WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
customQuery("DELETE FROM diagnosis_masters_revs WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);

// Participant

if($is_initial_import)  {
	$query = "UPDATE participants SET 
		qc_nd_sardo_rec_number = '',
		qc_nd_sardo_last_import = null,
		qc_nd_sardo_cause_of_death = '',
		qc_nd_sardo_diff_first_name = '',
		qc_nd_sardo_diff_last_name = '',
		qc_nd_sardo_diff_date_of_birth = '',
		qc_nd_sardo_diff_sex = '',
		qc_nd_sardo_diff_ramq = '',
		qc_nd_sardo_diff_hospital_nbr = '',
		qc_nd_sardo_diff_date_of_death = '',
		qc_nd_sardo_diff_vital_status = '',
		qc_nd_sardo_diff_reproductive_history = '';";
	customQuery($query, __LINE__);
	$query = "UPDATE participants_revs SET
		qc_nd_sardo_rec_number = '',
		qc_nd_sardo_last_import = null,
		qc_nd_sardo_cause_of_death = '',
		qc_nd_sardo_diff_first_name = '',
		qc_nd_sardo_diff_last_name = '',
		qc_nd_sardo_diff_date_of_birth = '',
		qc_nd_sardo_diff_sex = '',
		qc_nd_sardo_diff_ramq = '',
		qc_nd_sardo_diff_hospital_nbr = '',
		qc_nd_sardo_diff_date_of_death = '',
		qc_nd_sardo_diff_vital_status = '',
		qc_nd_sardo_diff_reproductive_history = '';";
	customQuery($query, __LINE__);
}

// Identifiers

global $misc_identifier_control_ids_to_names;
$misc_identifier_control_ids_to_names = array();
$query_res = customQuery("SELECT id, misc_identifier_name FROM misc_identifier_controls WHERE misc_identifier_name IN ('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr', 'ramq nbr') AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 4) importDie('ERR_PAT00001 : Misc identifier controls error!');
while($res =  mysqli_fetch_assoc($query_res)) {
	$misc_identifier_control_ids_to_names[$res['id']] = $res['misc_identifier_name'];
}

//==============================================================================================
// Load XML file data in DB
//==============================================================================================

$reader = new XMLReader();
$reader->open($file_path);

$sql_sardo_tables_creations = array(
	"DROP TABLE IF EXISTS sardo_rapport;",
	"DROP TABLE IF EXISTS sardo_traitement;",
	"DROP TABLE IF EXISTS sardo_labo;",
	"DROP TABLE IF EXISTS sardo_diagnostic;",
	"DROP TABLE IF EXISTS sardo_patient;",
	"CREATE TABLE sardo_patient (
		RecNumber varchar(20),
		Nom varchar(255) DEFAULT NULL,
		Prenom varchar(255) DEFAULT NULL,
		NoDossier varchar(255) DEFAULT NULL,
		RAMQ varchar(255) DEFAULT NULL,
		Sexe varchar(255) DEFAULT NULL,
		DateNaissance date DEFAULT NULL,
		DateNaissance_accuracy char(1) NOT NULL DEFAULT '',
		DateDeces date DEFAULT NULL,
		DateDeces_accuracy char(1) NOT NULL DEFAULT '',
		CauseDeces varchar(255) DEFAULT NULL,
		AnneeMenopause varchar(255) DEFAULT NULL,
		KEY (RecNumber));",
	"CREATE TABLE sardo_diagnostic (
		RecNumber varchar(20),
		ParentRecNumber varchar(20),
		NoBANQUE varchar(40) DEFAULT NULL,
		DateDiagnostic date DEFAULT NULL,
		DateDiagnostic_accuracy char(1) NOT NULL DEFAULT '',
		CodeICDOTopo varchar(255) DEFAULT NULL,
		DescICDOTopo varchar(255) DEFAULT NULL,
		CodeICDOMorpho varchar(255) DEFAULT NULL,
		DescICDOMorpho varchar(255) DEFAULT NULL,
		Lateralite varchar(255) DEFAULT NULL,
		CodeTNMcT varchar(255) DEFAULT NULL,
		CodeTNMcN varchar(255) DEFAULT NULL,
		CodeTNMcM varchar(255) DEFAULT NULL,
		StadeTNMc varchar(255) DEFAULT NULL,
		CodeTNMpT varchar(255) DEFAULT NULL,
		CodeTNMpN varchar(255) DEFAULT NULL,
		CodeTNMpM varchar(255) DEFAULT NULL,
		StadeTNMp varchar(255) DEFAULT NULL,
		FIGO varchar(255) DEFAULT NULL,
		CodeTNMG varchar(255) DEFAULT NULL,
		GradeICDO varchar(255) DEFAULT NULL,
		DateDerniereVisite date DEFAULT NULL,
		DateDerniereVisite_accuracy char(1) NOT NULL DEFAULT '',
		Duree varchar(255) DEFAULT NULL,
		Censure varchar(255) DEFAULT NULL,
		KEY (RecNumber),
		KEY(NoBANQUE));",
	"ALTER TABLE sardo_diagnostic
		ADD CONSTRAINT sardo_diagnostic_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_patient(RecNumber);",
	"CREATE TABLE sardo_traitement (
		RecNumber varchar(20),
		ParentRecNumber varchar(20),
		TypeTX varchar(255) DEFAULT NULL,
		Traitement varchar(255) DEFAULT NULL,
		DateDebutTraitement date DEFAULT NULL,
		DateDebutTraitement_accuracy char(1) NOT NULL DEFAULT '',
		DateFinTraitement date DEFAULT NULL,
		DateFinTraitement_accuracy char(1) NOT NULL DEFAULT '',
		NoPatho varchar(255) DEFAULT NULL,
		Resultat_Alpha varchar(255) DEFAULT NULL,
		ObjectifTX varchar(255) DEFAULT NULL,
		KEY (RecNumber));",
	"ALTER TABLE sardo_traitement
		ADD CONSTRAINT sardo_traitement_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_diagnostic(RecNumber);",
	"CREATE TABLE sardo_rapport (
		RecNumber varchar(20),
		ParentRecNumber varchar(20),
		ElementRapport varchar(255) DEFAULT NULL,
		Resultat varchar(255) DEFAULT NULL,
		KEY (RecNumber));",
	"ALTER TABLE sardo_rapport
		ADD CONSTRAINT sardo_rapport_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_traitement(RecNumber);",
	"CREATE TABLE sardo_labo (
		RecNumber varchar(20),
		ParentRecNumber varchar(20),
		NomLabo varchar(255) DEFAULT NULL,
		Date date DEFAULT NULL,
		Date_accuracy char(1) NOT NULL DEFAULT '',
		Resultat varchar(255) DEFAULT NULL,
		KEY (RecNumber));",
	"ALTER TABLE sardo_labo
		ADD CONSTRAINT sardo_labo_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_diagnostic(RecNumber);");
foreach($sql_sardo_tables_creations as $new_query) customQuery($new_query, __LINE__);

$data = null;
$field = null;
$data_types = array("Patient","Rapport","Diagnostic","Traitement","Labo");
$element_level = 0;
while( $reader->read() ) {
	if ($reader->nodeType == XMLReader::ELEMENT) {
		$element_level++;	
		if($element_level == 2 && in_array($reader->localName, $data_types)) {
			$data = array('type' => $reader->localName, 'values' => array());
		} else if($element_level == 3) {
			$field = $reader->localName;	
		}
	} else if ($element_level == 3 && $reader->nodeType == XMLReader::TEXT) {		
		$value = preg_replace(array("/\n$/","/\n/"), array('', ' '), $reader->value);		
		if(preg_match('/^Date/', $field)) {
			$date_values = getDateFromXml($value, $field, $data['type']);		
			if($date_values) list($data['values'][$field], $data['values'][$field."_accuracy"]) = $date_values;
		} else if(strlen($value)) {
			$data['values'][$field] = str_replace("'", "''", $value);
		}
	} else if ($reader->nodeType == XMLReader::END_ELEMENT) {
		if($element_level == 2 && in_array($reader->localName, $data_types)) {	
			$insert_record = true;
			if($data['type'] == 'Labo' && isset($data['values']['NomLabo']) && !in_array($data['values']['NomLabo'], array('APS pré-op', 'APS', 'CA-125'))) {
				$insert_record = false;
			}
			if($insert_record) {
				$query = "INSERT INTO sardo_".strtolower($data['type'])." (".implode(',',array_keys($data['values'])).") VALUES ('".implode("','", $data['values'])."');";			
				customQuery($query, __LINE__);
			}
			$data = null;
		}
		$element_level--;	
	}
}

function getDateFromXml($value, $field, $data_type, $no_labos = null) {
	$date = '';
	$date_accuracy = '';
	if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))99/', $value, $matches)) {
		$date = $matches[1].'-01-01';
		$date_accuracy = 'm';
	}  else if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))((0[1-9])|(1[0-2]))99$/', $value, $matches)) {
		$date = $matches[1].'-'.$matches[4].'-01';
		$date_accuracy = 'd';
	} else if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[01]))$/', $value, $matches)) {
		$date = $matches[1].'-'.$matches[4].'-'.$matches[7];
		$date_accuracy = 'c';
	}  else if($value != '99999999' && !empty($value) && !preg_match('/^9999/', $value)){
		$import_summary[$data_type]['ERROR']["Date Format Error"][] = "Date '$value' is not supported for field [$field]!".(is_null($no_labos)? '' : "See NoLabos: $no_labos");
	}
	return empty($date)? null : array($date, $date_accuracy);
}

$reader->close();

//==============================================================================================
// Function to manage SARDO Custom Lists
//==============================================================================================

global $structure_permissible_values_custom_controls;
$structure_permissible_values_custom_controls = array();
$query_res = customQuery("SELECT id, name, flag_active, values_max_length, category, values_used_as_input_counter, values_counter FROM structure_permissible_values_custom_controls WHERE name LIKE 'SARDO%';", __LINE__);
While($res = mysqli_fetch_assoc($query_res)) {
	$structure_permissible_values_custom_controls[$res['name']] = array_merge($res, array('new_values' => array()));
}

function addValuesToCustomList($control_name, $value) {
	global $structure_permissible_values_custom_controls;
	if(!strlen($value)) return '';
	if(!isset($structure_permissible_values_custom_controls[$control_name])) importDie("ERR_CUSTOMLIST00001 : The custom list $control_name does not exist!");
	$fr_value = $value;
	$arr_matches = array('á'=>'a','à'=>'a','â'=>'a','ä'=>'a','ã'=>'a','å'=>'a','ç'=>'c','é'=>'e','è'=>'e','ê'=>'e','ë'=>'e','í'=>'i','ì'=>'i','î'=>'i','ï'=>'i','ñ'=>'n','ó'=>'o','ò'=>'o','ô'=>'o','ö'=>'o','õ'=>'o','ú'=>'u','ù'=>'u','û'=>'u','ü'=>'u','ý'=>'y','ÿ'=>'y');
	$value = str_replace(array_keys($arr_matches), $arr_matches, strtolower($value));
	$values_max_length = $structure_permissible_values_custom_controls[$control_name]['values_max_length'];
	if(strlen($value) > $values_max_length) {
		$import_summary['Custom List']['WARNING']["Value(s) for '$control_name' custom list is too long (> $values_max_length characters)!"][] = $value;
		$value = substr($value, 0, $values_max_length);
	}
	$structure_permissible_values_custom_controls[$control_name]['new_values'][$value] = $fr_value;
	return $value;
}

function loadCustomLists() {
	global $structure_permissible_values_custom_controls;
	foreach($structure_permissible_values_custom_controls as $new_custom_list) {
		$control_id = $new_custom_list['id'];
		customQuery("DELETE FROM structure_permissible_values_customs WHERE control_id = $control_id;", __LINE__);
		customQuery("DELETE FROM structure_permissible_values_customs_revs WHERE control_id = $control_id;", __LINE__);		
		foreach($new_custom_list['new_values'] as $new_value => $fr_value) {
			customInsert(array('value' => $new_value, 'fr' => $fr_value, 'control_id' => $control_id, 'use_as_input' => '1'), 'structure_permissible_values_customs', __LINE__);
		}
		customQuery("UPDATE structure_permissible_values_custom_controls SET values_counter = ".sizeof($new_custom_list['new_values']).", values_used_as_input_counter = ".sizeof($new_custom_list['new_values'])." WHERE id = $control_id;", __LINE__);
	}
}

//==============================================================================================
// Manage Data Import
//==============================================================================================

global $participant_ids_already_synchronized;
$participant_ids_already_synchronized = array();
$updated_participants_counter = 0;

$query = "SELECT ParentRecNumber, NoBANQUE, Censure, DateDerniereVisite, DateDerniereVisite_accuracy FROM sardo_diagnostic ORDER BY ParentRecNumber;";
$query_res = customQuery($query, __LINE__);
$sardo_patient_data = array('patient_RecNumber' => null, 'no_labos' => array(), 'censure' => 0, 'last_visite_date' => null, 'last_visite_date_accuracy' => null);
while($res = mysqli_fetch_assoc($query_res)) {
	if($sardo_patient_data['patient_RecNumber'] && $sardo_patient_data['patient_RecNumber'] != $res['ParentRecNumber']) {
		if(manageSardoNewPatient($sardo_patient_data)) $updated_participants_counter++;
		$sardo_patient_data = array('patient_RecNumber' => null, 'no_labos' => array(), 'censure' => 0, 'last_visite_date' => null, 'last_visite_date_accuracy' => null);
	}
	$sardo_patient_data['patient_RecNumber'] = $res['ParentRecNumber'];
	if($res['NoBANQUE']) $sardo_patient_data['no_labos'][$res['NoBANQUE']] = $res['NoBANQUE'];
	if($res['Censure']) $sardo_patient_data['censure'] = 1;
	if($res['DateDerniereVisite']) {
		if(is_null($sardo_patient_data['last_visite_date']) || $res['DateDerniereVisite'] > $sardo_patient_data['last_visite_date']) {
			$sardo_patient_data['last_visite_date'] = $res['DateDerniereVisite'];
			$sardo_patient_data['last_visite_date_accuracy'] = $res['DateDerniereVisite_accuracy'];	
		}
	}
}
manageSardoNewPatient($sardo_patient_data);

function manageSardoNewPatient($sardo_patient_data) {
	global $participant_ids_already_synchronized;
	global $import_summary;
	
	if($sardo_patient_data && $sardo_patient_data['no_labos']) {
		$no_labos_string = "'".implode("','",$sardo_patient_data['no_labos'])."'";
		$query = "SELECT mi.participant_id, mi.identifier_value 
			FROM misc_identifier_controls mic INNER JOIN misc_identifiers mi ON mi.misc_identifier_control_id = mic.id
			WHERE mic.misc_identifier_name LIKE '%bank no lab' AND mic.misc_identifier_name != 'old bank no lab' AND mic.flag_active = 1
			AND mi.identifier_value IN ($no_labos_string) AND mi.deleted <> 1;";
		$query_res = customQuery($query, __LINE__);
		if($query_res->num_rows == 0) {
			$import_summary['Diagnosis']['ERROR']["SARDO patient(s) not linked to ATiM patients - Patient SARDO data won't be migrated"][] = "See NoLabos : $no_labos_string";
		} else if($query_res->num_rows != sizeof($sardo_patient_data['no_labos'])) {
			$import_summary['Diagnosis']['ERROR']["SARDO diagnosis NoLabo does not exist into ATiM (at least one) - Patient SARDO data won't be migrated"][] = "See NoLabos : $no_labos_string";
		} else {
			$participant_ids = array();
			while($res = mysqli_fetch_assoc($query_res)) {
				$participant_ids[$res['participant_id']] = $res['participant_id'];
			}			
			if(sizeof($participant_ids) != 1) {
				$import_summary['Diagnosis']['ERROR']["SARDO patient(s) linked to more than one ATiM patients - Patient SARDO data won't be migrated"][] = "See NoLabos : $no_labos_string";
			} else {
				$pariticpant_id = array_shift($participant_ids);
				if(isset($participant_ids_already_synchronized[$pariticpant_id])) {
					$import_summary['Diagnosis']['ERROR']["ATiM patient(s) linked to more than one SARDO patients - Part of patient SARDO data won't be migrated"][] = "See NoLabos: $no_labos_string, ".$participant_ids_already_synchronized[$pariticpant_id];
				} else {
					$participant_ids_already_synchronized[$pariticpant_id] = $no_labos_string;
					if(updatePatientData($pariticpant_id, $sardo_patient_data, $no_labos_string)) {
						importDiagnosisData($pariticpant_id, $sardo_patient_data['patient_RecNumber'], $no_labos_string);
						return true;
					}					
				}
			}
		} 
	}
	return false;
}

//Finalize import

finalizePatientUpdate($db_schema);
finalizeDiagnosisCreation();
loadCustomLists();
foreach($sql_sardo_tables_creations as $new_query) if(preg_match('/^DROP TABLE/', $new_query)) customQuery($new_query, __LINE__);

//TODO manage commit rollback

// Import Summary
$import_summary['Process']['Message']["Updated participants counter"][] = $updated_participants_counter;
$import_summary['Process']['Message']["Date"][] = $import_date;
foreach($import_summary as $data_type => $data_1) {
	foreach($data_1 as $message_type => $data_2) {
		foreach($data_2 as $message => $data_3) {
			foreach($data_3 as $details) {
				$data = array('data_type' => $data_type, 'message_type' => $message_type, 'message' => $message, 'details' => $details);
				foreach($data as $key => $value) if(strlen($value)) $data[$key] = "'".str_replace("'", "''", $value)."'";
				customQuery("INSERT INTO sardo_import_summary (".implode(", ", array_keys($data)).") VALUES (".implode(", ", array_values($data)).")", __LINE__, true);
			}
		}
	}
}

echo "Process Done";

// *** Patient *********************************************************************************

function updatePatientData($participant_id, $sardo_patient_data, $no_labos_string) {
	global $import_summary;
	global $misc_identifier_control_ids_to_names;
	global $import_date;
	global $import_by;
	
	$misc_identifier_control_names_to_ids = array_flip($misc_identifier_control_ids_to_names);

	$atim_patient_data_to_update = array(
			'qc_nd_sardo_rec_number' => $sardo_patient_data['patient_RecNumber'],
			'qc_nd_sardo_last_import' => $import_date,
			'modified' => $import_date,
			'modified_by' => $import_by);
	$atim_patient_data_creation_update_summary = array();
	
	// Get ATiM patient data
	
	$query_res = customQuery("SELECT first_name, last_name, date_of_birth, date_of_birth_accuracy, sex, vital_status, date_of_death, date_of_death_accuracy, qc_nd_last_contact, qc_nd_last_contact_accuracy, reproductive_histories.id AS reproductive_history_id, lnmp_date, lnmp_date_accuracy, menopause_status
			FROM participants
			LEFT JOIN reproductive_histories ON reproductive_histories.participant_id = participants.id AND reproductive_histories.deleted <> 1
			WHERE participants.id = $participant_id AND participants.deleted <> 1;", __LINE__);
	if(!$query_res->num_rows) importDie("ERR_PAT00002 : Patient does not exist (participant id = $participant_id)!");
	$atim_patient_data =  mysqli_fetch_assoc($query_res);
	
	$atim_patient_identifiers = array();
	$query = "SELECT misc_identifier_control_id, identifier_value FROM misc_identifiers WHERE deleted <> 1 AND participant_id = $participant_id AND misc_identifier_control_id IN (".implode(',', $misc_identifier_control_names_to_ids).");";
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) $atim_patient_identifiers[$misc_identifier_control_ids_to_names[$res['misc_identifier_control_id']]] = $res['identifier_value'];
	$atim_patient_identifiers_to_create = array();
	
	// Get SARDO patient data
	
	$query_res = customQuery("SELECT * FROM sardo_patient WHERE RecNumber = '".$sardo_patient_data['patient_RecNumber']."';", __LINE__);
	if(!$query_res->num_rows) importDie("ERR_PAT00003 : SARDO Patient does not exist (RecNumber = ".$sardo_patient_data['patient_RecNumber'].")!");
	$sardo_patient_data =  array_merge(mysqli_fetch_assoc($query_res), $sardo_patient_data);

	// Validate selected patient based on RAMQ, etc and set SARDO data to update
	
	$is_patient_identifier_validated = false;	// One match will validate patient
	
	//   --> RAMQ 
	$sardo_ramq = $sardo_patient_data['RAMQ'];
	if($sardo_ramq) {
		if(isset($atim_patient_identifiers['ramq nbr'])) {
			if($atim_patient_identifiers['ramq nbr'] != $sardo_ramq) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_ramq'] = 'y';
			} else {
				$is_patient_identifier_validated = true;
			}
		} else {
			$atim_patient_identifiers_to_create[] = array('participant_id' => $participant_id, 'misc_identifier_control_id' => $misc_identifier_control_names_to_ids['ramq nbr'], 'identifier_value' => $sardo_ramq);
			$atim_patient_data_creation_update_summary[] = "RAMQ = $sardo_ramq";
		}	
	}
	
	//   --> Hospital number
	$hospital_nbr = $sardo_patient_data['NoDossier'];
	if($hospital_nbr) {
		if(preg_match('/^([HSN])[0-9]+/', $hospital_nbr, $matches)) {
			$misc_identifier_control_name = str_replace(array('H', 'S', 'N'), array('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr'), $matches[1]);
			if(isset($atim_patient_identifiers[$misc_identifier_control_name])) {
				if($atim_patient_identifiers[$misc_identifier_control_name] != $hospital_nbr) {
					$atim_patient_data_to_update['qc_nd_sardo_diff_hospital_nbr'] = 'y';
				} else {
					$is_patient_identifier_validated = true;
				}
			} else {
				$atim_patient_identifiers_to_create[] = array('participant_id' => $participant_id, 'misc_identifier_control_id' => $misc_identifier_control_names_to_ids[$misc_identifier_control_name], 'identifier_value' => $hospital_nbr);
				$atim_patient_data_creation_update_summary[] = "$misc_identifier_control_name = $hospital_nbr";
			}
		} else {
			$import_summary['Patient']['WARNING']["Wrong SARDO hopsital number format"][] = "See [$hospital_nbr] for patient with NoLabo(s) : $no_labos_string";
		}		
	}
	
	//   --> first name
	$is_first_name_validated = false;
	$sardo_first_name = $sardo_patient_data['Prenom'];
	if($sardo_first_name) {
		if(empty($atim_patient_data['first_name'])) {
			$atim_patient_data_to_update['first_name'] = $sardo_first_name;
			$atim_patient_data_creation_update_summary[] = "first_name = $sardo_first_name";
		} else if(strtolower($sardo_first_name) != strtolower($atim_patient_data['first_name'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_first_name'] = 'y';
		} else {
			$is_first_name_validated = true;
		}
	} else if(!empty($atim_patient_data['first_name'])) {
		$atim_patient_data_to_update['qc_nd_sardo_diff_first_name'] = 'y';
	}
	
	//   --> last name
	$is_last_name_validated = false;
	$sardo_last_name = $sardo_patient_data['Nom'];
	if($sardo_last_name) {
		if(empty($atim_patient_data['last_name'])) {
			$atim_patient_data_to_update['last_name'] = $sardo_last_name;
			$atim_patient_data_creation_update_summary[] = "last_name = $sardo_last_name";
		} else if(strtolower($sardo_last_name) != strtolower($atim_patient_data['last_name'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_last_name'] = 'y';
		} else {
			$is_last_name_validated = true;
		}
	} else if(!empty($atim_patient_data['last_name'])) {
		$atim_patient_data_to_update['qc_nd_sardo_diff_last_name'] = 'y';
	}
		
	if(($is_last_name_validated && $is_first_name_validated) || $is_patient_identifier_validated ) {
		//Patient has been validated : update can go ahead
		
		//   --> sex
		$sardo_sex = '';
		switch($sardo_patient_data['Sexe']) {
			case '';
				break;
			case 'F':
				$sardo_sex = 'f';
				break;
			case 'M':
				$sardo_sex = 'm';
				break;
			default;
				$sardo_sex = 'other';
				break;
		}
		if($sardo_sex) {
			if(empty($atim_patient_data['sex'])) {
				$atim_patient_data_to_update['sex'] = $sardo_sex;
				$atim_patient_data_creation_update_summary[] = "sex = $sardo_sex";
			} else if($sardo_sex != $atim_patient_data['sex']) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_sex'] = 'y';
			}
		} else if(!empty($atim_patient_data['sex'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_sex'] = 'y';
		}
		
		//   --> date of birth
		$sardo_date_of_birth = $sardo_patient_data['DateNaissance'];
		$sardo_date_of_birth_accuracy = $sardo_patient_data['DateNaissance_accuracy'];
		if($sardo_date_of_birth) {
			if(empty($atim_patient_data['date_of_birth'])) {
				$atim_patient_data_to_update['date_of_birth'] = $sardo_date_of_birth;
				$atim_patient_data_to_update['date_of_birth_accuracy'] = $sardo_date_of_birth_accuracy;
				$atim_patient_data_creation_update_summary[] = "date_of_birth = $sardo_date_of_birth";
			} else if($sardo_date_of_birth != $atim_patient_data['date_of_birth'] || $sardo_date_of_birth_accuracy != $atim_patient_data['date_of_birth_accuracy']) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_date_of_birth'] = 'y';
			}
		} else if(!empty($atim_patient_data['date_of_birth'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_date_of_birth'] = 'y';
		}
		
		//   --> death	
		$atim_patient_data_to_update['qc_nd_sardo_cause_of_death'] = addValuesToCustomList("SARDO : Cause of death", $sardo_patient_data['CauseDeces']);
		$sardo_date_of_death = $sardo_patient_data['DateDeces'];
		$sardo_date_of_death_accuracy = $sardo_patient_data['DateDeces_accuracy'];
		$sardo_vital_status = ($sardo_patient_data['censure'] != '1' && (strlen(str_replace(' ', '', $atim_patient_data_to_update['qc_nd_sardo_cause_of_death'])) == 0) && $sardo_date_of_death == '')? '' : 'deceased';
		if($sardo_vital_status) {
			if(empty($atim_patient_data['vital_status']) || ($atim_patient_data['vital_status'] == 'unknown')) {
				$atim_patient_data_to_update['vital_status'] = $sardo_vital_status;
				$atim_patient_data_creation_update_summary[] = "vital_status = $sardo_vital_status";
			} else if($atim_patient_data['vital_status'] == 'alive') {
				$atim_patient_data_to_update['vital_status'] = $sardo_vital_status;
				$atim_patient_data_creation_update_summary[] = "vital_status = $sardo_vital_status";
				$import_summary['Patient']['WARNING']["Vital status changed from 'alive' to 'deceased'"][] = "See NoLabo(s) : $no_labos_string";
			} else  if($sardo_vital_status != $atim_patient_data['vital_status']) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_vital_status'] = 'y';
				//Not sure this case can exist.... :-)
			}
		} else if($atim_patient_data['vital_status'] == 'deceased') {
			$atim_patient_data_to_update['qc_nd_sardo_diff_vital_status'] = 'y';
		}
		if($sardo_date_of_death) {
			if(empty($atim_patient_data['date_of_death'])) {
				$atim_patient_data_to_update['date_of_death'] = $sardo_date_of_death;
				$atim_patient_data_to_update['date_of_death_accuracy'] = $sardo_date_of_death_accuracy;
				$atim_patient_data_creation_update_summary[] = "date_of_death = $sardo_date_of_death";
			} else if($sardo_date_of_death != $atim_patient_data['date_of_death'] || $sardo_date_of_death_accuracy != $atim_patient_data['date_of_death_accuracy']) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_date_of_death'] = 'y';
			}
		} else if(!empty($atim_patient_data['date_of_death'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_date_of_death'] = 'y';
		}
		
		//   --> last Contact
		if($sardo_patient_data['last_visite_date']) {
			if(empty($atim_patient_data['qc_nd_last_contact']) || $atim_patient_data['qc_nd_last_contact'] < $sardo_patient_data['last_visite_date']) {
				$atim_patient_data_to_update['qc_nd_last_contact'] = $sardo_patient_data['last_visite_date'];
				$atim_patient_data_to_update['qc_nd_last_contact_accuracy'] = $sardo_patient_data['last_visite_date_accuracy'];
				$atim_patient_data_creation_update_summary[] = "qc_nd_last_contact = ".$sardo_patient_data['last_visite_date'];
			}
		}
		
		//   --> Reporductive History
		$sardo_lnmp = str_replace('9999', '', $sardo_patient_data['AnneeMenopause']);
		if($sardo_lnmp) {
			if(!$atim_patient_data['reproductive_history_id']) {
				//Create a new reproductive history
				customInsert(array('participant_id' => $participant_id, 'lnmp_date' => $sardo_lnmp.'-01-01', 'lnmp_date_accuracy' => 'm', 'menopause_status' => 'post'), 'reproductive_histories', __LINE__);
				$atim_patient_data_creation_update_summary[] = "Created reproductive history";
			} else {
				$atim_reporductive_history_data_to_update = array();
				//   -> (menopause_status)
				if(empty($atim_patient_data['menopause_status'])) {
					$atim_reporductive_history_data_to_update['menopause_status'] = 'post';
				} else if($atim_patient_data['menopause_status'] != 'post') {
					$atim_patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'y';
				}
				//   -> (menopause date)
				if(empty($atim_patient_data['lnmp_date'])) {
					$atim_reporductive_history_data_to_update['lnmp_date'] = $sardo_lnmp.'-01-01';
					$atim_reporductive_history_data_to_update['lnmp_date_accuracy'] = 'm';
				} else if($sardo_lnmp != substr($atim_patient_data['lnmp_date'], 0, 4)) {
					$atim_patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'y';
				}
				if($atim_reporductive_history_data_to_update) {
					$atim_reporductive_history_data_to_update = array_merge($atim_reporductive_history_data_to_update, array('modified' => $import_date, 'modified_by' => $import_by));
					//Update Reproductive History
					$query = "UPDATE reproductive_histories SET ";
					$coma = '';
					foreach($atim_reporductive_history_data_to_update as $field => $value ) {
						if(strlen($value)) $query .= $coma." $field = '".str_replace("'", "''", $value)."'";
						$coma = ', ';
					}
					$query .= " WHERE id = ".$atim_patient_data['reproductive_history_id'].";";
					customQuery($query, __LINE__);
					$atim_patient_data_creation_update_summary[] = "Updated reproductive history";
				}
			}
		}

		// Update participant data
		$query = "UPDATE participants SET ";
		$coma = '';
		foreach($atim_patient_data_to_update as $field => $value ) {
			if(strlen($value)) $query .= $coma." $field = '".str_replace("'", "''", $value)."'";
			$coma = ', ';
		}
		$query .= " WHERE id = $participant_id;";
		customQuery($query, __LINE__);
		
		// Add missing identifiers
		foreach($atim_patient_identifiers_to_create as $new_ids) customInsert($new_ids, 'misc_identifiers', __LINE__, false, true);
		
		// Add patient creation/update summary
		if($atim_patient_data_creation_update_summary) $import_summary['Patient']['MESSAGE']["Creation/Update summary"][] = "NoLabo(s) : $no_labos_string => ".implode(', ',$atim_patient_data_creation_update_summary);
		
		return true;

	} else {
		$import_summary['Patient']['WARNING']["Patient selection can not be validated based on identifiers (RAMQ, hospital Nbr) or names - No SARDO data will be imported"][] = "See NoLabo(s) : $no_labos_string";
		return false;
	}
}

function finalizePatientUpdate($db_schema) {
	global $import_date;
	global $import_by;
		
	// Revs table update
	foreach(array('participants', 'reproductive_histories') as $tablename) {
		$query = "SELECT COLUMN_NAME 
			FROM information_schema.COLUMNS
			WHERE TABLE_SCHEMA='$db_schema' AND COLUMN_NAME NOT IN('created','created_by','modified','modified_by','deleted') AND TABLE_NAME LIKE '$tablename'";
		$query_res = customQuery($query, __LINE__);
		$table_fields = array();
		while($res =  mysqli_fetch_assoc($query_res)) $table_fields[] = $res['COLUMN_NAME'];
		$table_fields = implode(',',$table_fields);
		customQuery("INSERT INTO ".$tablename."_revs ($table_fields, modified_by, version_created) (SELECT $table_fields, modified_by, modified FROM $tablename WHERE modified_by = $import_by AND modified = '$import_date');", __LINE__);
	}
	
	// Tracks patients matching SARDO patient in th epast but matching no sardo patient anymore
	$query = "SELECT id, qc_nd_sardo_rec_number FROM participants WHERE deleted <> 1 AND (qc_nd_sardo_rec_number IS NOT NULL AND qc_nd_sardo_rec_number NOT LIKE '') AND qc_nd_sardo_last_import != '".substr($import_date, 0, 10)."';";
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) {
		$import_summary['Patient']['WARNING']['SARDO patient (previously synchronized) and not synchronized anymore'][] = "See patient RecNumber (of ATiM Profile form) ".$res['qc_nd_sardo_rec_number'];
	}
	
	// Check identifiers
	$query = "
		SELECT * FROM (
			SELECT count(*) as nbr, mic.misc_identifier_name, mi.identifier_value
			FROM misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mic.id = mi.misc_identifier_control_id
			WHERE mi.deleted <> 1 AND mic.misc_identifier_name IN ('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr', 'ramq nbr')
			GROUP BY mic.misc_identifier_name, mi.identifier_value
		) res WHERE res.nbr > 1;";
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) {
		$import_summary['Patient']['ERROR']['Duplicated RAMQ or Hopsital Number'][] = "See ".$res['misc_identifier_name']." ".$res['identifier_value'];
	}
}

// *** Diagnosis *******************************************************************************

function importDiagnosisData($pariticpant_id, $patient_rec_number, $no_labos_string) {	
	global $diagnosis_controls;
	$diagnosis_rec_nbrs_to_ids = array();
	
	$query_res = customQuery("SELECT * FROM sardo_diagnostic WHERE ParentRecNumber = '$patient_rec_number';", __LINE__);
	while($sardo_diagnosis_data = mysqli_fetch_assoc($query_res)) {
		//Create diagnosis data set
		$atim_diagnosis_data_to_create = array(
			'DiagnosisMaster' => array(
				'diagnosis_control_id' => $diagnosis_controls['id'], 
				'participant_id' => $pariticpant_id, 
				'dx_date' => $sardo_diagnosis_data['DateDiagnostic'],
				'dx_date_accuracy' => $sardo_diagnosis_data['DateDiagnostic_accuracy'],
				'qc_nd_sardo_id' => $sardo_diagnosis_data['RecNumber']), 
			'DiagnosisDetail' => array());
		$tmp_array= array(
			'DiagnosisMaster' => array(
				array('CodeICDOMorpho', 'morphology', 'SARDO : Morpho Codes'),
				array('DescICDOMorpho', 'qc_nd_sardo_morphology_desc', 'SARDO : Morpho Descriptions'),
				array('CodeICDOTopo', 'topography', 'SARDO : Topo Codes'),
				array('DescICDOTopo', 'qc_nd_sardo_topography_desc', 'SARDO : Topo Descriptions'),
				array('CodeTNMcT' ,'clinical_tstage', 'SARDO : TNMcT'),
				array('CodeTNMcN' ,'clinical_nstage', 'SARDO : TNMcN'),
				array('CodeTNMcM' ,'clinical_mstage', 'SARDO : TNMcM'),
				array('StadeTNMc' ,'clinical_stage_summary', 'SARDO : TNMc Summary'),
				array('CodeTNMpT' ,'path_tstage', 'SARDO : TNMpT'),
				array('CodeTNMpN' ,'path_nstage', 'SARDO : TNMpN'),
				array('CodeTNMpM' ,'path_mstage', 'SARDO : TNMpM'),
				array('StadeTNMp' ,'path_stage_summary', 'SARDO : TNMp Summary'),
				array('GradeICDO' ,'tumour_grade', 'SARDO : Grade'),
				array('Duree' ,'survival_time_months', '')),
			'DiagnosisDetail' => array(
					array('Lateralite', 'laterality', 'SARDO : Laterality'),
					array('FIGO', 'figo', 'SARDO : FIGO'),
					array('CodeTNMG', 'codetnmg', 'SARDO : TNMg')));
		foreach($tmp_array as $model => $table_fields) {
			foreach($table_fields as $fields_info) {
				list($sardo_field, $atim_field, $custom_list_control_name) = $fields_info;
				$atim_diagnosis_data_to_create[$model][$atim_field] = $sardo_diagnosis_data[$sardo_field];
				if($custom_list_control_name) {
					$atim_diagnosis_data_to_create[$model][$atim_field] = addValuesToCustomList($custom_list_control_name, $atim_diagnosis_data_to_create[$model][$atim_field]);		
				}
			}
		}
		
		//Record diagnosis
		$diagnosis_master_id = customInsert($atim_diagnosis_data_to_create['DiagnosisMaster'], 'diagnosis_masters', __LINE__);
		$atim_diagnosis_data_to_create['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
		customInsert($atim_diagnosis_data_to_create['DiagnosisDetail'], $diagnosis_controls['detail_tablename'], __LINE__, true);
		
		$diagnosis_rec_nbrs_to_ids[$sardo_diagnosis_data['RecNumber']] = $diagnosis_master_id;
	}
	
	//Load Treatment
	importTreatmentData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string);
	
	//Load Report
	importReportData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string);
	
	//Load Labos
	importLaboData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string);
}

function finalizeDiagnosisCreation() {
	global $diagnosis_controls;
	
	customQuery("UPDATE diagnosis_masters SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
	customQuery("UPDATE diagnosis_masters_revs SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
}

// *** Treatment *******************************************************************************

function importTreatmentData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string) {
	global $treatment_controls;
	global $import_summary;
	
	if($diagnosis_rec_nbrs_to_ids) {
		$query_res = customQuery("SELECT * FROM sardo_traitement WHERE ParentRecNumber IN ('".implode("','", array_keys($diagnosis_rec_nbrs_to_ids))."');", __LINE__);
		$atim_treatments_data_to_create = array();
		while($sardo_treatments_data = mysqli_fetch_assoc($query_res)) {
			//Set treatment data
			$trt_type = $sardo_treatments_data['TypeTX'];
			$tx_method = 'sardo treatment - '.strtolower($trt_type);
			$start_date = null;
			$start_date_accuracy = null;
			if(!isset($treatment_controls[$tx_method])) {
				if($trt_type) {
					$import_summary['Treatment']['ERROR']["SARDO treatment [$trt_type] is unknow"][] = "See NoLabo(s) : $no_labos_string";
				} else {
					$import_summary['Treatment']['ERROR']["At least one SARDO treatment type is not defined"][] = "See NoLabo(s) : $no_labos_string";
				}
			} else {
				//Create treatment data set
				$start_date = $sardo_treatments_data['DateDebutTraitement'];
				$start_date_accuracy = $sardo_treatments_data['DateDebutTraitement_accuracy'];
				$finish_date = $sardo_treatments_data['DateFinTraitement'];
				$finish_date_accuracy = $sardo_treatments_data['DateFinTraitement_accuracy'];
				$NoPatho = $sardo_treatments_data['NoPatho'];
				$results = addValuesToCustomList("SARDO : $trt_type Results", $sardo_treatments_data['Resultat_Alpha']);
				$objectifs = addValuesToCustomList("SARDO : $trt_type Objectifs", $sardo_treatments_data['ObjectifTX']);
				//Build the treatment key
				$treatment_key = md5($trt_type.$start_date.$finish_date.$NoPatho.$results.$objectifs);
				if(!isset($atim_treatments_data_to_create[$treatment_key])) {
					$atim_treatments_data_to_create[$treatment_key] = array(
						'TreatmentMaster' => array(
							'treatment_control_id' => $treatment_controls[$tx_method]['treatment_control_id'],
							'participant_id' => $pariticpant_id,
							'diagnosis_master_id' => $diagnosis_rec_nbrs_to_ids[$sardo_treatments_data['ParentRecNumber']],
							'start_date' => $start_date,
							'start_date_accuracy' => $start_date_accuracy,
							'finish_date' => $finish_date,
							'finish_date_accuracy' => $finish_date_accuracy),
						'TreatmentDetail' => array(
							'patho_nbr' => $NoPatho,
							'results' => $results,
							'objectifs' => $objectifs),
						'TreatmentExtends' => array());			
				}
				$treatment_extend_data = addValuesToCustomList("SARDO : $trt_type Treatments", $sardo_treatments_data['Traitement']);
				if(strlen($treatment_extend_data)) {		
					$atim_treatments_data_to_create[$treatment_key]['TreatmentExtends'][] = array(
						'TreatmentExtendMaster' => array('treatment_extend_control_id' => $treatment_controls[$tx_method]['treatment_extend_control_id']),
						'TreatmentExtendDetail' => array('treatment' => $treatment_extend_data));
				}
			}
		}	
		//Record treatment
		foreach($atim_treatments_data_to_create as $new_treatment_to_create) {
			$treatment_master_id = customInsert($new_treatment_to_create['TreatmentMaster'], 'treatment_masters', __LINE__);
			$new_treatment_to_create['TreatmentDetail']['treatment_master_id'] = $treatment_master_id;
			customInsert($new_treatment_to_create['TreatmentDetail'], 'qc_nd_txd_sardos', __LINE__, true);
			foreach($new_treatment_to_create['TreatmentExtends'] as $new_extend) {
				$new_extend['TreatmentExtendMaster']['treatment_master_id'] = $treatment_master_id;
				$treatment_extend_master_id = customInsert($new_extend['TreatmentExtendMaster'], 'treatment_extend_masters', __LINE__);
				$new_extend['TreatmentExtendDetail']['treatment_extend_master_id'] = $treatment_extend_master_id;
				customInsert($new_extend['TreatmentExtendDetail'], 'qc_nd_txe_sardos', __LINE__, true);
			}
		}
	}	
}

// *** Report **********************************************************************************

function importReportData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string) {
	global $rapport_event_controls;
	global $import_summary;
	
	if($diagnosis_rec_nbrs_to_ids) {
		$query_res = customQuery("SELECT sr.*, st.ParentRecNumber as diagnosis_RecNumber, st.DateDebutTraitement, st.DateDebutTraitement_accuracy 
			FROM sardo_traitement st INNER JOIN sardo_rapport sr ON sr.ParentRecNumber = st.RecNumber 
			WHERE st.ParentRecNumber IN ('".implode("','", array_keys($diagnosis_rec_nbrs_to_ids))."');", __LINE__);
		while($sardo_report_data = mysqli_fetch_assoc($query_res)) {
			$control = array();
			$fish = false;
			switch($sardo_report_data['ElementRapport']) {
				case 'Récepteurs aux oestrogènes (RE)':
					$control = $rapport_event_controls['estrogen receptor report (RE)'];
					break;
				case 'Récepteurs aux progestatifs (RP)':
					$control = $rapport_event_controls['progestin receptor report (RP)'];
					break;
				case 'HER-2/NEU par FISH':
					$fish = true;
				case 'HER-2/NEU':
					$control = $rapport_event_controls['her2/neu'];
					break;
			}
			if($control) {
				$atim_event_data_to_create= array(
					'EventMaster' => array(
						'event_control_id' => $control['id'],
						'participant_id' => $pariticpant_id,
						'diagnosis_master_id' => $diagnosis_rec_nbrs_to_ids[$sardo_report_data['diagnosis_RecNumber']],
						'event_date' => $sardo_report_data['DateDebutTraitement'],
						'event_date_accuracy' => $sardo_report_data['DateDebutTraitement_accuracy']),
					'EventDetail' => array());
				if(in_array($control['detail_tablename'], array('qc_nd_ed_estrogen_receptor_reports', 'qc_nd_ed_progestin_receptor_reports'))) {
					$results = $sardo_report_data['Resultat'];
					$atim_event_data_to_create['EventMaster']['event_summary'] = $results;
					if(preg_match('/((,\ ){0,1}(\++))$/', $results, $matches)) {
						$atim_event_data_to_create['EventDetail']['intensity'] = addValuesToCustomList('SARDO : Estrogen/Progestin Receptor Intensities', $matches[3]);
						$results = str_replace($matches[1], '', $results);
					}
					if(preg_match('/((,\ ){0,1}(([0-9]+)([\.,][0-9]+){0,1})\ %)$/', $results, $matches)) {
						$atim_event_data_to_create['EventDetail']['percentage'] = str_Replace(',', '.', $matches[3]);
						$results = str_replace($matches[1], '', $results);
					}
					$atim_event_data_to_create['EventDetail']['result'] = addValuesToCustomList('SARDO : Estrogen/Progestin Receptor Results', $results);
				} else if($control['detail_tablename'] == 'qc_nd_ed_her2_neu') {
					$results = $sardo_report_data['Resultat'];
					$atim_event_data_to_create['EventMaster']['event_summary'] = $results;
					if(preg_match('/((,\ ){0,1}(\++))$/', $results, $matches)) {
						$atim_event_data_to_create['EventDetail']['intensity'] = addValuesToCustomList('SARDO : HER2/NEU Intensities', $matches[3]);
						$results = str_replace($matches[1], '', $results);
					}
					$atim_event_data_to_create['EventDetail']['result'] = addValuesToCustomList('SARDO : HER2/NEU Results', $results);
					$atim_event_data_to_create['EventDetail']['fish'] = $fish? 'y' : 'n';
				} else {
					importDie("ERR_LAB00003 : Unsupported detail tablename [".$control['detail_tablename']."]!");
				}
				$event_master_id = customInsert($atim_event_data_to_create['EventMaster'], 'event_masters', __LINE__, false);
				$atim_event_data_to_create['EventDetail']['event_master_id'] = $event_master_id;
				customInsert($atim_event_data_to_create['EventDetail'], $control['detail_tablename'], __LINE__, true);
			}
		}
	}
}

// *** APS & CA-125 (once) *********************************************************************

function importLaboData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string) {
	global $is_initial_import;
	global $ca125_psa_event_controls;
	
	if($is_initial_import && $diagnosis_rec_nbrs_to_ids) {
		$query_res = customQuery("SELECT * FROM sardo_labo WHERE ParentRecNumber IN ('".implode("','", array_keys($diagnosis_rec_nbrs_to_ids))."');", __LINE__);
		while($sardo_labo_data = mysqli_fetch_assoc($query_res)) {
			$test = $sardo_labo_data['NomLabo'];
			if(in_array($test, array('APS pré-op', 'APS', 'CA-125'))) {
				$atim_event_data_to_create= array(
					'EventMaster' => array(
						'event_control_id' => $ca125_psa_event_controls[(($test == 'CA-125')? 'ca125' : 'psa')]['id'], 
						'participant_id' => $pariticpant_id,
						'event_date' => $sardo_labo_data['Date'],
						'event_date_accuracy' => $sardo_labo_data['Date_accuracy']), 
					'EventDetail' => array(
						'value' => $sardo_labo_data['Resultat']));
				if($atim_event_data_to_create['EventDetail']['value'] == '-99') $atim_event_data_to_create['EventDetail']['value'] = '';
				$event_master_id = customInsert($atim_event_data_to_create['EventMaster'], 'event_masters', __LINE__, false, true);
				$atim_event_data_to_create['EventDetail']['event_master_id'] = $event_master_id;
				customInsert($atim_event_data_to_create['EventDetail'],  $ca125_psa_event_controls[(($test == 'CA-125')? 'ca125' : 'psa')]['detail_tablename'], __LINE__, true, true);				
			}
		}
		
	}
}

//==============================================================================================
// Other functions
//==============================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
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
		if(strlen($value)) $data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
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

?>