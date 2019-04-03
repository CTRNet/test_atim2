<?php

/**
 * 
 * @author     Nicolas L.
 * @version     Revs 7027 - 20180302
 * 
 * */
 
global $import_summary;
$import_summary = array();

//==============================================================================================
// Config
//==============================================================================================

$is_server = true;
// Database

$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "chumonco";

if($is_server) {
    $db_user 		= "testuser";
    $db_pwd			= "";
    $db_schema		= "test_atim_chum_onco";
}

// File

$file_name = "ATiM_short.xml";
$file_path = "C:/_NicolasLuc/Server/www/";

if($is_server) {
    $file_name = "ATiM.xml";
    $file_path = "/ch06chuma6134/";
}

//==============================================================================================
// Database Connection
//==============================================================================================

$db_ip			= "localhost";
$db_port 		= "";
$db_charset		= "utf8";

global $db_connection;
$db_connection = @mysqli_connect(
	$db_ip.(!empty($db_port)? ":".$db_port : ''),
	$db_user,
	$db_pwd
) or importDie("DB connection: Could not connect to MySQL [".$db_ip.(!empty($db_port)? ":".$db_port : '')." / $db_user]", false);
if(!mysqli_set_charset($db_connection, $db_charset)){
	importDie("DB connection: Invalid charset", false);
}
@mysqli_select_db($db_connection, $db_schema) or importDie("DB connection: DB selection failed [$db_schema]", false);
mysqli_autocommit ($db_connection , false);

// cd_icm_sardo_data_import_tries table record

global $cd_icm_sardo_data_import_try_id;
$cd_icm_sardo_data_import_triy_id = '-1';
$query = "INSERT INTO cd_icm_sardo_data_import_tries (datetime_try, global_result, sardo_data_load_result, atim_data_management_result, details, sardo_participant_counter, update_participant_counter)
    VALUES
    (NOW(), 'failed', 'failed', 'failed', '', null, null);";
$cd_icm_sardo_data_import_triy_id = customQuery($query, __LINE__, true);
mysqli_commit($db_connection);

global $cd_icm_sardo_data_import_try_final_queries;
$cd_icm_sardo_data_import_try_final_queries = array();

// $import_date & $import_by defintion

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE username = 'SardoMigration';", __LINE__);
if($query_res->num_rows != 1) importDie("DB connection: No user 'SardoMigration' into ATiM users table!");
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

// cd_icm_sardo_data_import_tries table record

$cd_icm_sardo_data_import_try_final_queries[] = "UPDATE cd_icm_sardo_data_import_tries
	SET datetime_try = '$import_date'
	WHERE id = $cd_icm_sardo_data_import_triy_id;";
    
//==============================================================================================
// Load XML file data in DB sardo_* tables
//==============================================================================================

$file_path = $file_path.$file_name;
//$file_path = str_replace('file_name', $file_name, "C:/_NicolasLuc/Server/www/file_name");
if(!file_exists($file_path)) {
    importDie("XML File : The file $file_path does not exist!");
}

$reader = new XMLReader();
$reader->open($file_path);

$sql_sardo_tables_creations = array(
	"DROP TABLE IF EXISTS sardo_rapport;",
	"DROP TABLE IF EXISTS sardo_traitement;",
	"DROP TABLE IF EXISTS sardo_labo;",
	"DROP TABLE IF EXISTS sardo_progression;",
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
        StatutMenopause varchar(255) DEFAULT NULL,
        GravidaParaAborta varchar(255) DEFAULT NULL,
		DateDerniereVisite date DEFAULT NULL,
		DateDerniereVisite_accuracy char(1) NOT NULL DEFAULT '',
		Duree varchar(255) DEFAULT NULL,
		Censure varchar(255) DEFAULT NULL,
		KEY (RecNumber),
		KEY(NoBANQUE));",
	"CREATE TABLE sardo_progression (
		RecNumber varchar(20),
		ParentRecNumber varchar(20),
		DateProgression date DEFAULT NULL,
		DateProgression_accuracy char(1) NOT NULL DEFAULT '',
		Code varchar(50) DEFAULT NULL,
		Detail varchar(250) DEFAULT NULL,
		NbLesions int(4) DEFAULT NULL,
		Certitude varchar(50) DEFAULT NULL,
		Type varchar(50) DEFAULT NULL,
		KEY (RecNumber));",
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
	"CREATE TABLE sardo_rapport (
		RecNumber varchar(20),
		ParentRecNumber varchar(20),
		ElementRapport varchar(255) DEFAULT NULL,
		Resultat varchar(255) DEFAULT NULL,
		KEY (RecNumber));",
	"CREATE TABLE sardo_labo (
		RecNumber varchar(20),
		ParentRecNumber varchar(20),
		NomLabo varchar(255) DEFAULT NULL,
		Date date DEFAULT NULL,
		Date_accuracy char(1) NOT NULL DEFAULT '',
		Resultat varchar(255) DEFAULT NULL,
		KEY (RecNumber));");
foreach($sql_sardo_tables_creations as $new_query) customQuery($new_query, __LINE__);

$data = null;
$field = null;
$data_types = array("Patient","Rapport","Diagnostic","Progression","Traitement","Labo");
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
			if($data['type'] == 'Labo' && isset($data['values']['NomLabo']) && !in_array($data['values']['NomLabo'], array('APS pré-op', 'APS', 'CA-125', 'SCC'))) {
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

// Constraints Check And Cleanup

$constraint_check_queries = array(
	'Diagnosis' => 'SELECT DISTINCT ParentRecNumber FROM sardo_diagnostic WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_patient)',
	'Treatment' => 'SELECT DISTINCT ParentRecNumber FROM sardo_traitement WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_diagnostic)',
	'Progression' => 'SELECT DISTINCT ParentRecNumber FROM sardo_progression WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_diagnostic)',
	'Labo' => 'SELECT DISTINCT ParentRecNumber FROM sardo_labo WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_diagnostic)',
	'Report' => 'SELECT DISTINCT ParentRecNumber FROM sardo_rapport WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_traitement)');
$missing_rec_numbers_messages = array();
foreach($constraint_check_queries as $data_type => $query) {
	preg_match('/FROM\ (sardo_[a-z]+)\ WHERE\ ParentRecNumber\ NOT\ IN \(SELECT\ RecNumber\ FROM\ (sardo_[a-z]+)\)$/', $query, $matches);
	$tablename =$matches[1];
	$parent_tablename =$matches[2];
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) {
		$missing_rec_numbers_messages[$data_type]["Missing ".$parent_tablename.".RecNumber referenced into ".$tablename.".ParentRecNumber. Linked ".strtolower($data_type)." data won't be imported."][$res['ParentRecNumber']] = $res['ParentRecNumber'];
	}
}
foreach($missing_rec_numbers_messages as $data_type => $messages_and_numbers) 
	foreach($messages_and_numbers as $message => $rec_numbers) 
		$import_summary[$data_type]['ERROR'][$message][$message] = "See RecNumbers : ".implode(', ', $rec_numbers);
$sql_sardo_tables_updates = array(
	"DELETE FROM sardo_diagnostic WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_patient)",
	"ALTER TABLE sardo_diagnostic
		ADD CONSTRAINT sardo_diagnostic_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_patient(RecNumber);",
	"DELETE FROM sardo_progression WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_diagnostic)",
	"ALTER TABLE sardo_progression
		ADD CONSTRAINT sardo_progression_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_diagnostic(RecNumber);",
	"DELETE FROM sardo_traitement WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_diagnostic)",
	"ALTER TABLE sardo_traitement
		ADD CONSTRAINT sardo_traitement_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_diagnostic(RecNumber);",
	"DELETE FROM sardo_rapport WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_traitement)",
	"ALTER TABLE sardo_rapport
		ADD CONSTRAINT sardo_rapport_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_traitement(RecNumber);",
	"DELETE FROM sardo_labo WHERE ParentRecNumber NOT IN (SELECT RecNumber FROM sardo_diagnostic)",
	"ALTER TABLE sardo_labo
	 	ADD CONSTRAINT sardo_labo_ibfk_1 FOREIGN KEY (ParentRecNumber) REFERENCES sardo_diagnostic(RecNumber);");
foreach($sql_sardo_tables_updates as $new_query) customQuery($new_query, __LINE__);

// cd_icm_sardo_data_import_tries table record

$query = "SELECT count(*) AS sardo_patient_nbr FROM sardo_patient;";
$query_res = customQuery($query, __LINE__);
$sardo_participant_counter = mysqli_fetch_assoc($query_res);
if(!$sardo_participant_counter['sardo_patient_nbr']) {
    importDie("XML File : No participant data has been extracted from the SARDO XML file!");
}
$cd_icm_sardo_data_import_try_final_queries[] = "UPDATE cd_icm_sardo_data_import_tries
    SET sardo_data_load_result = 'successfull', 
    sardo_participant_counter = '".$sardo_participant_counter['sardo_patient_nbr']."' 
    WHERE id = $cd_icm_sardo_data_import_triy_id;";

//==============================================================================================
// Table Clean Up & controls data record
//==============================================================================================

global $next_reusable_table_ids;    // To manage reuse of ids for tables like event_masters for which one we could not reset AUTO_INCREMENT = 1
$next_reusable_table_ids = array();

// Treatment

global $treatment_controls;
$treatment_controls = array();
$query_res = customQuery("SELECT tc.id as treatment_control_id, tc.detail_tablename as treatment_detail_tablename, tc.tx_method, tc.treatment_extend_control_id, tec.detail_tablename treatment_extend_detail_tablename
		FROM treatment_controls tc LEFT JOIN treatment_extend_controls tec ON tec.id = tc.treatment_extend_control_id  
		WHERE tc.flag_active = 1;", __LINE__);
while($res =  mysqli_fetch_assoc($query_res)) {
	$treatment_controls[$res['tx_method']] = $res;
	if($res['treatment_detail_tablename'] != 'qc_nd_txd_sardos') importDie("Treatment detail table error! ERR#_TX00002");
	if($res['treatment_extend_detail_tablename'] != 'qc_nd_txe_sardos') importDie("Treatment extend detail table error! ERR#_TX00003");
}
customQuery("DELETE FROM qc_nd_txe_sardos;", __LINE__);
customQuery("ALTER TABLE qc_nd_txe_sardos AUTO_INCREMENT = 1;", __LINE__);
customQuery("DELETE FROM treatment_extend_masters;", __LINE__);
customQuery("ALTER TABLE treatment_extend_masters AUTO_INCREMENT = 1;", __LINE__);
//No SARDO data recorded in _revs table
customQuery("DELETE FROM qc_nd_txd_sardos;", __LINE__);
customQuery("ALTER TABLE qc_nd_txd_sardos AUTO_INCREMENT = 1;", __LINE__);
customQuery("UPDATE collections SET treatment_master_id = null;", __LINE__);
customQuery("UPDATE collections_revs SET treatment_master_id = null;", __LINE__);	//Value can be set if user updated a collection already linked to a treatment
customQuery("DELETE FROM treatment_masters;", __LINE__);
customQuery("ALTER TABLE treatment_masters AUTO_INCREMENT = 1;", __LINE__);
//No SARDO data recorded in _revs table

// Event (rapport)

global $rapport_event_controls;
$rapport_event_controls = array();
$query_res = customQuery("SELECT id, detail_tablename, event_type FROM event_controls WHERE event_type IN ('estrogen receptor report (RE)', 'progestin receptor report (RP)', 'her2/neu') AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 3) importDie('Report controls unknown! ERR#_ERR_LAB00002');
while($res =  mysqli_fetch_assoc($query_res)) {
	$rapport_event_controls[$res['event_type']] = $res;
	customQuery("DELETE FROM ".$res['detail_tablename'].";", __LINE__);
	customQuery("ALTER TABLE ".$res['detail_tablename']." AUTO_INCREMENT = 1;", __LINE__);
	customQuery("DELETE FROM event_masters WHERE event_control_id = ".$res['id'].";", __LINE__);
	//No SARDO data recorded in _revs table
}

// Event (PSA/CA125/SCC)

global $ca125_psa_scc_event_controls;
$ca125_psa_scc_event_controls = array();
$query_res = customQuery("SELECT id, detail_tablename, event_type FROM event_controls WHERE event_type IN ('ca125', 'psa', 'scc') AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 3) importDie('CA125 and/or PSA and/or SCC controls unknown! ERR#_LAB00001');
while($res =  mysqli_fetch_assoc($query_res)) {
	$ca125_psa_scc_event_controls[$res['event_type']] = $res;
}

// Diagnosis

global $diagnosis_controls;
$query_res = customQuery("SELECT id, detail_tablename, category, controls_type FROM diagnosis_controls WHERE flag_active = 1;", __LINE__);
if($query_res->num_rows != 2) importDie('SARDO primary/progression diagnosis control unknown! ERR#_DX00002.1');
while($res = mysqli_fetch_assoc($query_res)) {
	if($res['controls_type'] != 'sardo') importDie('SARDO primary/progression diagnosis control unknown! ERR#_DX00002.2');
	$diagnosis_controls[$res['category']] = $res;
}
//WARNING progression - locoregional because ATiM does not support generic defintion progression
if(!isset($diagnosis_controls['primary']) || !isset($diagnosis_controls['progression - locoregional'])) importDie('SARDO primary/progression diagnosis control unknown! ERR#_DX00002.3');
foreach($diagnosis_controls as $category => $tmp) {
	customQuery("DELETE FROM ".$diagnosis_controls[$category]['detail_tablename'].";", __LINE__);
	customQuery("ALTER TABLE ".$diagnosis_controls[$category]['detail_tablename']." AUTO_INCREMENT = 1;", __LINE__);
	//No SARDO data recorded in _revs table
}
customQuery("UPDATE diagnosis_masters SET parent_id = null, primary_id = null;", __LINE__);
customQuery("DELETE FROM diagnosis_masters;", __LINE__);
customQuery("ALTER TABLE diagnosis_masters AUTO_INCREMENT = 1;", __LINE__);
//No SARDO data recorded in _revs table

// Participant
//qc_nd_sardo_rec_number won't be erased at this level: Will be used as a flag to tracks any patient matching SARDO patient in the ast but matching no sardo patient anymore

$query = "UPDATE participants SET 
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
// participants_revs table clean up done in finalizePatientUpdate()

// Identifiers

global $misc_identifier_control_ids_to_names;
$misc_identifier_control_ids_to_names = array();
$query_res = customQuery("SELECT id, misc_identifier_name FROM misc_identifier_controls WHERE misc_identifier_name IN ('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr', 'ramq nbr') AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 4) importDie('Misc identifier controls error! ERR#_PAT00001');
while($res =  mysqli_fetch_assoc($query_res)) {
	$misc_identifier_control_ids_to_names[$res['id']] = $res['misc_identifier_name'];
}

//==============================================================================================
// Manage Data Import
//==============================================================================================

global $participant_ids_already_synchronized;
$participant_ids_already_synchronized = array();
$updated_participants_counter = 0;

$query = "SELECT ParentRecNumber, NoBANQUE, Censure, DateDerniereVisite, DateDerniereVisite_accuracy FROM sardo_diagnostic ORDER BY ParentRecNumber;";
$query_res = customQuery($query, __LINE__);
if($query_res->num_rows == 0) echo "XML Load Error :: No Diagnosis has been imported from SARDO - No sardo data will be imported - Please check XML file structure.\n";
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
if(manageSardoNewPatient($sardo_patient_data)) $updated_participants_counter++;

function manageSardoNewPatient($sardo_patient_data) {
	global $participant_ids_already_synchronized;
	global $import_summary;
	
	if($sardo_patient_data && $sardo_patient_data['no_labos']) {
		$no_labos_string = "'".implode("','",$sardo_patient_data['no_labos'])."'";
		$query = "SELECT mi.participant_id, mi.identifier_value 
			FROM misc_identifier_controls mic INNER JOIN misc_identifiers mi ON mi.misc_identifier_control_id = mic.id
			WHERE mic.misc_identifier_name LIKE '%bank no lab' AND mic.misc_identifier_name NOT IN ('old bank no lab', 'old breast bank no lab', 'old ovary bank no lab') AND mic.flag_active = 1
			AND mi.identifier_value IN ($no_labos_string) AND mi.deleted <> 1;";
		$query_res = customQuery($query, __LINE__);
		if($query_res->num_rows == 0) {
			$import_summary['Diagnosis']['ERROR']["SARDO patient(s) not linked to ATiM patients - Patient SARDO data won't be migrated"][] = "See NoLabos : ".formatNoLabosForSummary($no_labos_string);
		} else if($query_res->num_rows != sizeof($sardo_patient_data['no_labos'])) {
		    if($query_res->num_rows > sizeof($sardo_patient_data['no_labos'])) {
		        $import_summary['Diagnosis']['ERROR']["SARDO diagnosis NoLabo matches more than one ATiM NoLabo (or at least one of them) - Patient SARDO data won't be migrated"][] = "See NoLabos : ".formatNoLabosForSummary($no_labos_string);
		    } else {
                $import_summary['Diagnosis']['ERROR']["SARDO diagnosis NoLabo does not exist into ATiM (or at least one of them) - Patient SARDO data won't be migrated"][] = "See NoLabos : ".formatNoLabosForSummary($no_labos_string);
		    }
		} else {
			$participant_ids = array();
			while($res = mysqli_fetch_assoc($query_res)) {
				$participant_ids[$res['participant_id']] = $res['participant_id'];
			}			
			if(sizeof($participant_ids) != 1) {
				$import_summary['Diagnosis']['ERROR']["SARDO patient(s) linked to more than one ATiM patients - Patient SARDO data won't be migrated"][] = "See NoLabos : ".formatNoLabosForSummary($no_labos_string);
			} else {
				$pariticpant_id = array_shift($participant_ids);
				if(isset($participant_ids_already_synchronized[$pariticpant_id])) {
					$import_summary['Diagnosis']['ERROR']["ATiM patient(s) linked to more than one SARDO patients - Part of patient SARDO data won't be migrated"][] = "See NoLabos: ".formatNoLabosForSummary($no_labos_string).", ".formatNoLabosForSummary($participant_ids_already_synchronized[$pariticpant_id]);
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
linkCollectionToSardoTreatment($db_schema);

foreach($sql_sardo_tables_creations as $new_query) {
    if(preg_match('/^DROP TABLE/', $new_query)) {
        customQuery($new_query, __LINE__);
    }
}

//Check duplacated labos

$laboToCheck = array(
    'CA125' => 'qc_nd_ed_ca125s',
    'PSA' => 'qc_nd_ed_psas',
    'SCC' => 'qc_nd_ed_sccs'    
);
foreach($laboToCheck as $typeLabo => $tableLabo) {
    $query = "
        SELECT participant_identifier, participant_id, event_date, event_control_id, GROUP_CONCAT(ERES3.value ORDER BY ERES3.value ASC SEPARATOR ' + ') AS all_day_values
        FROM (
            SELECT PART.participant_identifier, ERES2.participant_id, ERES2.event_date, ERES2.event_control_id, ED.value
            FROM (
                SELECT ERES1.participant_id, ERES1.event_date, ERES1.event_control_id FROM (
                    SELECT EM.participant_id, EM.event_date, EM.event_control_id, COUNT(*) AS dup
                    FROM event_masters EM
                    INNER JOIN detail_table_name ED ON EM.id = ED.event_master_id AND EM.deleted <> 1
                    WHERE EM.event_date IS NOT NULL
                    GROUP BY EM.participant_id, EM.event_date, EM.event_control_id
                ) ERES1 WHERE ERES1.dup > 1
            ) ERES2
            INNER JOIN event_masters EM ON EM.participant_id = ERES2.participant_id AND EM.event_date = ERES2.event_date AND EM.event_control_id = ERES2.event_control_id
            INNER JOIN detail_table_name ED ON EM.id = ED.event_master_id AND EM.deleted <> 1
            INNER JOIN participants PART ON PART.id = EM.participant_id
        ) ERES3
        GROUP BY ERES3.participant_identifier, ERES3.participant_id, ERES3.event_date, ERES3.event_control_id;";
    $query_res = customQuery(str_replace('detail_table_name', $tableLabo, $query), __LINE__);
    while($res = mysqli_fetch_assoc($query_res)) {
        $import_summary['Labo']['WARNING']["More than one $typeLabo on same date. Please validate and clean up data if required."][] = "See $typeLabo test on " . $res['event_date'] . " for 'Participant System Code' #" . $res['participant_identifier'] . " : " . $res['all_day_values'];  
    }
}

//==============================================================================================
// END OF THE PROCESS
//==============================================================================================

// Import Summary

recordImportSummary();

// cd_icm_sardo_data_import_tries table record

$query = "SELECT MAX(dx_date) as max_date FROM diagnosis_masters WHERE deleted <> 1 AND created = '$import_date' AND created_by = '$import_by' 
    UNION 
    SELECT MAX(start_date) as max_date FROM treatment_masters WHERE deleted <> 1 AND created = '$import_date' AND created_by = '$import_by'
    UNION 
    SELECT MAX(event_date) as max_date FROM event_masters WHERE deleted <> 1 AND created = '$import_date' AND created_by = '$import_by'";
$query_res = customQuery($query, __LINE__);
$max_date = '';
while($res =  mysqli_fetch_assoc($query_res)) {
    if(!$max_date || $max_date < $res['max_date']) {
        $max_date = $res['max_date'];
    }
}
$cd_icm_sardo_data_import_try_final_queries[] = "UPDATE cd_icm_sardo_data_import_tries
    SET global_result = 'successfull', 
    last_sardo_treatment_event_dx_date = " . (empty($max_date)? "null" : "'$max_date'") . ",
    atim_data_management_result = 'successfull', 
    update_participant_counter = '$updated_participants_counter'
    WHERE id = $cd_icm_sardo_data_import_triy_id;";
foreach($cd_icm_sardo_data_import_try_final_queries as $cd_icm_sardo_data_import_tries_query) {
    customQuery($cd_icm_sardo_data_import_tries_query, __LINE__);
}

//Commit
mysqli_commit($db_connection);

die("New SARDO data import completed on $import_date");

//=========================================================================================================================================================================================================
//
// ******* DATA CREATION/UPDATE FUNCTIONS *******
//
//=========================================================================================================================================================================================================


// *** Patient *********************************************************************************

function updatePatientData($participant_id, $sardo_patient_data, $no_labos_string) {
	global $import_summary;
	global $misc_identifier_control_ids_to_names;
	global $import_date;
	global $import_by;
	
	$misc_identifier_control_names_to_ids = array_flip($misc_identifier_control_ids_to_names);

	$audited_atim_patient_data_to_update = array();
	$non_audited_sardo_patient_data_to_create = array(
		'qc_nd_sardo_rec_number' => $sardo_patient_data['patient_RecNumber'],
		'qc_nd_sardo_last_import' => $import_date);
	$atim_patient_data_creation_update_summary = array();
	
	// Get ATiM patient data
	
	$query_res = customQuery("SELECT first_name, last_name, date_of_birth, date_of_birth_accuracy, sex, vital_status, date_of_death, date_of_death_accuracy, qc_nd_last_contact, qc_nd_last_contact_accuracy, reproductive_histories.id AS reproductive_history_id, lnmp_date, lnmp_date_accuracy, menopause_status
			FROM participants
			LEFT JOIN reproductive_histories ON reproductive_histories.participant_id = participants.id AND reproductive_histories.deleted <> 1
			WHERE participants.id = $participant_id AND participants.deleted <> 1;", __LINE__);
	if(!$query_res->num_rows) importDie("Patient does not exist (participant id = $participant_id)! ERR#_PAT00002");
	$atim_patient_data =  mysqli_fetch_assoc($query_res);
	
	$atim_patient_identifiers = array();
	$query = "SELECT misc_identifier_control_id, identifier_value FROM misc_identifiers WHERE deleted <> 1 AND participant_id = $participant_id AND misc_identifier_control_id IN (".implode(',', $misc_identifier_control_names_to_ids).");";
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) $atim_patient_identifiers[$misc_identifier_control_ids_to_names[$res['misc_identifier_control_id']]] = $res['identifier_value'];
	$atim_patient_identifiers_to_create = array();
	
	// Get SARDO patient data
	
	$query_res = customQuery("SELECT * FROM sardo_patient WHERE RecNumber = '".$sardo_patient_data['patient_RecNumber']."';", __LINE__);
	if(!$query_res->num_rows) importDie("SARDO Patient does not exist (RecNumber = ".$sardo_patient_data['patient_RecNumber'].")! ERR#_PAT00003");
	$sardo_patient_data =  array_merge(mysqli_fetch_assoc($query_res), $sardo_patient_data);

	// Validate selected patient based on RAMQ, etc and set SARDO data to update
	
	$is_patient_identifier_validated = false;	// One match will validate patient
	
	//   --> RAMQ 
	$sardo_ramq = $sardo_patient_data['RAMQ'];
	if($sardo_ramq) {
		if(isset($atim_patient_identifiers['ramq nbr'])) {
			if(trim($atim_patient_identifiers['ramq nbr']) != trim($sardo_ramq)) {
				$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_ramq'] = 'y';
			} else {
				$is_patient_identifier_validated = true;
			}
		} else {
			$atim_patient_identifiers_to_create[] = array('participant_id' => $participant_id, 'misc_identifier_control_id' => $misc_identifier_control_names_to_ids['ramq nbr'], 'identifier_value' => $sardo_ramq);
			$atim_patient_data_creation_update_summary[] = "Recorded RAMQ $sardo_ramq";
		}	
	}
	
	//   --> Hospital number
	$hospital_nbr = $sardo_patient_data['NoDossier'];
	if($hospital_nbr) {
		if(preg_match('/^([HSN])[0-9]+/', $hospital_nbr, $matches)) {
			$misc_identifier_control_name = str_replace(array('H', 'S', 'N'), array('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr'), $matches[1]);
			if(isset($atim_patient_identifiers[$misc_identifier_control_name])) {
				if(trim($atim_patient_identifiers[$misc_identifier_control_name]) != trim($hospital_nbr)) {
					$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_hospital_nbr'] = 'y';
				} else {
					$is_patient_identifier_validated = true;
				}
			} else {
				$atim_patient_identifiers_to_create[] = array('participant_id' => $participant_id, 'misc_identifier_control_id' => $misc_identifier_control_names_to_ids[$misc_identifier_control_name], 'identifier_value' => $hospital_nbr);
				$atim_patient_data_creation_update_summary[] = "Recorded $misc_identifier_control_name $hospital_nbr";
			}
		} else {
			$import_summary['Patient']['WARNING']["Wrong SARDO hopsital number format"][] = "See [$hospital_nbr] for patient with NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
		}		
	}
	
	//   --> first name
	$is_first_name_validated = false;
	$sardo_first_name = $sardo_patient_data['Prenom'];
	if($sardo_first_name) {
		if(empty($atim_patient_data['first_name'])) {
			$audited_atim_patient_data_to_update['first_name'] = $sardo_first_name;
			$atim_patient_data_creation_update_summary[] = "Recorded first name '$sardo_first_name'";
		} else if(strtolower($sardo_first_name) != strtolower($atim_patient_data['first_name'])) {
			$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_first_name'] = 'y';
		} else {
			$is_first_name_validated = true;
		}
	} else if(!empty($atim_patient_data['first_name'])) {
		$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_first_name'] = 'y';
	}
	
	//   --> last name
	$is_last_name_validated = false;
	$sardo_last_name = $sardo_patient_data['Nom'];
	if($sardo_last_name) {
		if(empty($atim_patient_data['last_name'])) {
			$audited_atim_patient_data_to_update['last_name'] = $sardo_last_name;
			$atim_patient_data_creation_update_summary[] = "Recorded last name '$sardo_last_name'";
		} else if(strtolower($sardo_last_name) != strtolower($atim_patient_data['last_name'])) {
			$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_last_name'] = 'y';
		} else {
			$is_last_name_validated = true;
		}
	} else if(!empty($atim_patient_data['last_name'])) {
		$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_last_name'] = 'y';
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
				$audited_atim_patient_data_to_update['sex'] = $sardo_sex;
				$atim_patient_data_creation_update_summary[] = "Recorded sex '$sardo_sex'";
			} else if($sardo_sex != $atim_patient_data['sex']) {
				$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_sex'] = 'y';
			}
		} else if(!empty($atim_patient_data['sex'])) {
			$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_sex'] = 'y';
		}
		
		//   --> date of birth
		$sardo_date_of_birth = $sardo_patient_data['DateNaissance'];
		$sardo_date_of_birth_accuracy = $sardo_patient_data['DateNaissance_accuracy'];
		if($sardo_date_of_birth) {
			if(empty($atim_patient_data['date_of_birth'])) {
				$audited_atim_patient_data_to_update['date_of_birth'] = $sardo_date_of_birth;
				$audited_atim_patient_data_to_update['date_of_birth_accuracy'] = $sardo_date_of_birth_accuracy;
				$atim_patient_data_creation_update_summary[] = "Recorded date of birth '$sardo_date_of_birth'";
			} else if($sardo_date_of_birth != $atim_patient_data['date_of_birth'] || $sardo_date_of_birth_accuracy != $atim_patient_data['date_of_birth_accuracy']) {
				$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_date_of_birth'] = 'y';
			}
		} else if(!empty($atim_patient_data['date_of_birth'])) {
			$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_date_of_birth'] = 'y';
		}
		
		//   --> death	
		$non_audited_sardo_patient_data_to_create['qc_nd_sardo_cause_of_death'] = $sardo_patient_data['CauseDeces'];
		$sardo_date_of_death = $sardo_patient_data['DateDeces'];
		$sardo_date_of_death_accuracy = $sardo_patient_data['DateDeces_accuracy'];
		$sardo_vital_status = ($sardo_patient_data['censure'] != '1' && (strlen(str_replace(' ', '', $non_audited_sardo_patient_data_to_create['qc_nd_sardo_cause_of_death'])) == 0) && $sardo_date_of_death == '')? '' : 'deceased';
		if($sardo_vital_status) {
			if(empty($atim_patient_data['vital_status']) || ($atim_patient_data['vital_status'] == 'unknown')) {
				$audited_atim_patient_data_to_update['vital_status'] = $sardo_vital_status;
				$atim_patient_data_creation_update_summary[] = "Recorded vital status '$sardo_vital_status'";
			} else if($atim_patient_data['vital_status'] == 'alive') {
				$audited_atim_patient_data_to_update['vital_status'] = $sardo_vital_status;
				$atim_patient_data_creation_update_summary[] = "Changed vital_status from 'alive' to '$sardo_vital_status'";
				$import_summary['Patient']['WARNING']["Vital status changed from 'alive' to 'deceased'"][] = "See NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
			} else  if($sardo_vital_status != $atim_patient_data['vital_status']) {
				$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_vital_status'] = 'y';
				//Not sure this case can exist.... :-)
			}
		} else if($atim_patient_data['vital_status'] == 'deceased') {
			$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_vital_status'] = 'y';
		}
		if($sardo_date_of_death) {
			if(empty($atim_patient_data['date_of_death'])) {
				$audited_atim_patient_data_to_update['date_of_death'] = $sardo_date_of_death;
				$audited_atim_patient_data_to_update['date_of_death_accuracy'] = $sardo_date_of_death_accuracy;
				$atim_patient_data_creation_update_summary[] = "Recorded date_of_death '$sardo_date_of_death'";
			} else if($sardo_date_of_death != $atim_patient_data['date_of_death'] || $sardo_date_of_death_accuracy != $atim_patient_data['date_of_death_accuracy']) {
				$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_date_of_death'] = 'y';
			}
		} else if(!empty($atim_patient_data['date_of_death'])) {
			$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_date_of_death'] = 'y';
		}
		
		//   --> last Contact
		if($sardo_patient_data['last_visite_date']) {
			if(empty($atim_patient_data['qc_nd_last_contact']) || $atim_patient_data['qc_nd_last_contact'] < $sardo_patient_data['last_visite_date']) {
				$audited_atim_patient_data_to_update['qc_nd_last_contact'] = $sardo_patient_data['last_visite_date'];
				$audited_atim_patient_data_to_update['qc_nd_last_contact_accuracy'] = $sardo_patient_data['last_visite_date_accuracy'];
				if(empty($atim_patient_data['qc_nd_last_contact'])) {
					$atim_patient_data_creation_update_summary[] = "Recorded last contact date '".$sardo_patient_data['last_visite_date']."'";
				} else {
					$atim_patient_data_creation_update_summary[] = "Changed last contact date from '".$atim_patient_data['qc_nd_last_contact']."' to '".$sardo_patient_data['last_visite_date']."'";
				}
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
					$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_reproductive_history'] = 'y';
				}
				//   -> (menopause date)
				if(empty($atim_patient_data['lnmp_date'])) {
					$atim_reporductive_history_data_to_update['lnmp_date'] = $sardo_lnmp.'-01-01';
					$atim_reporductive_history_data_to_update['lnmp_date_accuracy'] = 'm';
				} else if($sardo_lnmp != substr($atim_patient_data['lnmp_date'], 0, 4)) {
					$non_audited_sardo_patient_data_to_create['qc_nd_sardo_diff_reproductive_history'] = 'y';
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
		
		$atim_patient_data_to_update = array_merge($audited_atim_patient_data_to_update, $non_audited_sardo_patient_data_to_create);
		if($audited_atim_patient_data_to_update) {
			// To force record in participants_revs table
			$atim_patient_data_to_update = array_merge(
				$atim_patient_data_to_update, 
				array(
					'modified' => $import_date,
					'modified_by' => $import_by));
		}
		if($atim_patient_data_to_update) {
			$query = "UPDATE participants SET ";
			$coma = '';
			foreach($atim_patient_data_to_update as $field => $value ) {
				if(strlen($value)) $query .= $coma." $field = '".str_replace("'", "''", $value)."'";
				$coma = ', ';
			}
			$query .= " WHERE id = $participant_id;";
			customQuery($query, __LINE__);
		}
		
		// Add missing identifiers
		foreach($atim_patient_identifiers_to_create as $new_ids) customInsert($new_ids, 'misc_identifiers', __LINE__, false, true);
		
		// Add patient creation/update summary
		if($atim_patient_data_creation_update_summary) $import_summary['Patient']['MESSAGE']["Profile & Reproductive History Creation/Update summary"][] = "NoLabo(s) ".formatNoLabosForSummary($no_labos_string)." : ".implode(' | ',$atim_patient_data_creation_update_summary);
		
		return true;

	} else {
		$import_summary['Patient']['WARNING']["Patient selection can not be validated based on identifiers (RAMQ, hospital Nbr) or names - No SARDO data will be imported"][] = "See NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
		return false;
	}
}

function finalizePatientUpdate($db_schema) {
	global $import_summary;
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
	$query = "UPDATE participants_revs SET
		qc_nd_sardo_last_import = null,
		qc_nd_sardo_cause_of_death = '',
		qc_nd_sardo_rec_number = '',
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
	
	// Tracks patients matching SARDO patient in th epast but matching no sardo patient anymore
	$query = "SELECT Participant.id, Participant.participant_identifier, GROUP_CONCAT(DISTINCT identifier_value  ORDER BY identifier_value DESC SEPARATOR ',') AS no_labos
		FROM participants Participant
		LEFT JOIN misc_identifiers MiscIdentifier ON Participant.id = MiscIdentifier.participant_id AND MiscIdentifier.deleted <> 1 AND MiscIdentifier.misc_identifier_control_id IN (SELECT id FROM misc_identifier_controls WHERE misc_identifier_name LIKE '% bank no lab')
		WHERE Participant.deleted <> 1
		AND (Participant.qc_nd_sardo_rec_number IS NOT NULL AND Participant.qc_nd_sardo_rec_number NOT LIKE '')
		AND Participant.qc_nd_sardo_last_import IS NULL
		GROUP BY Participant.id";
	$participant_ids_to_clean_up = array();
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) {
		$no_labos_string = strlen($res['no_labos'])? "'".str_replace(",", "','",$res['no_labos'])."'" : "";
		$import_summary['Patient']['WARNING']['ATiM patient (previously synchronized) not synchronized anymore'][] = "See patient with : 'Participant System Code' ".$res['participant_identifier']." / 'NoLabo(s)' : ".formatNoLabosForSummary($no_labos_string);
		$participant_ids_to_clean_up[] = $res['id'];
	}
	if($participant_ids_to_clean_up) {
		customQuery("UPDATE participants SET qc_nd_sardo_rec_number = null WHERE id IN (".implode(',',$participant_ids_to_clean_up).");", __LINE__);
		//All values are null in _revs table (see query above)
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
				'diagnosis_control_id' => $diagnosis_controls['primary']['id'], 
				'participant_id' => $pariticpant_id, 
				'dx_date' => $sardo_diagnosis_data['DateDiagnostic'],
				'dx_date_accuracy' => $sardo_diagnosis_data['DateDiagnostic_accuracy'],
				'qc_nd_sardo_id' => $sardo_diagnosis_data['RecNumber']), 
			'DiagnosisDetail' => array());
		$tmp_array= array(
			'DiagnosisMaster' => array(
				array('CodeICDOMorpho', 'morphology'),
				array('DescICDOMorpho', 'qc_nd_sardo_morphology_desc'),
				array('CodeICDOTopo', 'topography'),
				array('DescICDOTopo', 'qc_nd_sardo_topography_desc'),
				array('CodeTNMcT' ,'clinical_tstage'),
				array('CodeTNMcN' ,'clinical_nstage'),
				array('CodeTNMcM' ,'clinical_mstage'),
				array('StadeTNMc' ,'clinical_stage_summary'),
				array('CodeTNMpT' ,'path_tstage'),
				array('CodeTNMpN' ,'path_nstage'),
				array('CodeTNMpM' ,'path_mstage'),
				array('StadeTNMp' ,'path_stage_summary'),
				array('GradeICDO' ,'tumour_grade'),
				array('Duree' ,'survival_time_months')),
			'DiagnosisDetail' => array(
					array('Lateralite', 'laterality'),
					array('FIGO', 'figo'),
					array('CodeTNMG', 'codetnmg')));
		foreach($tmp_array as $model => $table_fields) {
			foreach($table_fields as $fields_info) {
				list($sardo_field, $atim_field) = $fields_info;
				$atim_diagnosis_data_to_create[$model][$atim_field] = $sardo_diagnosis_data[$sardo_field];
			}
		}
		
		//Record diagnosis
		$diagnosis_master_id = customInsert($atim_diagnosis_data_to_create['DiagnosisMaster'], 'diagnosis_masters', __LINE__);
		$atim_diagnosis_data_to_create['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
		customInsert($atim_diagnosis_data_to_create['DiagnosisDetail'], $diagnosis_controls['primary']['detail_tablename'], __LINE__, true);
		
		$diagnosis_rec_nbrs_to_ids[$sardo_diagnosis_data['RecNumber']] = $diagnosis_master_id;
	}
	
	//Load Progression
	importProgressionData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string);
	
	//Load Treatment
	importTreatmentData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string);
	
	//Load Report
	importReportData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string);
	
	//Load Labos
	importLaboData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string);
}

function finalizeDiagnosisCreation() {
	global $diagnosis_controls;
	
	customQuery("UPDATE diagnosis_masters SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['primary']['id'].";", __LINE__);
	//No SARDO data recorded in _revs table
}

// *** Progression *******************************************************************************

function importProgressionData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string) {
	global $diagnosis_controls;
	global $import_summary;

	if($diagnosis_rec_nbrs_to_ids) {
		$query_res = customQuery("SELECT * FROM sardo_progression WHERE ParentRecNumber IN ('".implode("','", array_keys($diagnosis_rec_nbrs_to_ids))."');", __LINE__);
		while($sardo_progressions_data = mysqli_fetch_assoc($query_res)) {
			$atim_diagnosis_data_to_create = array(
				'DiagnosisMaster' => array(
					'diagnosis_control_id' => $diagnosis_controls['progression - locoregional']['id'],
					'participant_id' => $pariticpant_id,
					'primary_id' => $diagnosis_rec_nbrs_to_ids[$sardo_progressions_data['ParentRecNumber']],
					'parent_id' => $diagnosis_rec_nbrs_to_ids[$sardo_progressions_data['ParentRecNumber']],
					'dx_date' => $sardo_progressions_data['DateProgression'],
					'dx_date_accuracy' => $sardo_progressions_data['DateProgression_accuracy']),
				'DiagnosisDetail' => array(
					'code' => $sardo_progressions_data['Code'],
					'detail' => $sardo_progressions_data['Detail'],
					'nbr_lesions' => str_replace('-99', '', $sardo_progressions_data['NbLesions']),
					'type' => $sardo_progressions_data['Type'],
					'certitude' => $sardo_progressions_data['Certitude']));
			//Record diagnosis
			$diagnosis_master_id = customInsert($atim_diagnosis_data_to_create['DiagnosisMaster'], 'diagnosis_masters', __LINE__);
			$atim_diagnosis_data_to_create['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
			customInsert($atim_diagnosis_data_to_create['DiagnosisDetail'], $diagnosis_controls['progression - locoregional']['detail_tablename'], __LINE__, true);
		}
	}
}

// *** Treatment *******************************************************************************

$query_res = customQuery("SELECT count(*) AS nbr_of_wrong_records
 FROM sardo_traitement 
 INNER JOIN sardo_rapport ON sardo_traitement.RecNumber = sardo_rapport.ParentRecNumber
 INNER JOIN sardo_diagnostic ON sardo_diagnostic.RecNumber = sardo_traitement.ParentRecNumber
 INNER JOIN sardo_patient ON sardo_patient.RecNumber = sardo_diagnostic.ParentRecNumber
 WHERE ElementRapport = 'Gleason' AND TypeTx NOT IN ('CHIR', 'BIOP');");
$sardo_gleason_wrong_data = mysqli_fetch_assoc($query_res);
if($sardo_gleason_wrong_data['nbr_of_wrong_records']) $import_summary['Report']['ERROR']["Gleason to treatment link"][] = $sardo_gleason_wrong_data['nbr_of_wrong_records']." gleason scores are linked to treatments different than 'CHIR' or 'BIOP'. Please ask administartor to review SARDO data source.";

function importTreatmentData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string) {
	global $treatment_controls;
	global $import_summary;
	
	if($diagnosis_rec_nbrs_to_ids) {
		//Build gleason array
		$query_res = customQuery("
			SELECT sardo_traitement.RecNumber AS sardo_traitement_RecNumber, TypeTX, sardo_rapport.Resultat
			FROM sardo_traitement 
			INNER JOIN sardo_rapport ON sardo_traitement.RecNumber = sardo_rapport.ParentRecNumber
			WHERE ElementRapport = 'Gleason' AND TypeTx IN ('CHIR', 'BIOP') AND sardo_traitement.ParentRecNumber IN ('".implode("','", array_keys($diagnosis_rec_nbrs_to_ids))."');", __LINE__);
		$sardo_treatment_rec_number_to_gleason = array();
		while($sardo_gleason_data = mysqli_fetch_assoc($query_res)) {
			$sardo_gleason_data['Resultat'] = str_replace(' ','', $sardo_gleason_data['Resultat']);
			if(strlen($sardo_gleason_data['Resultat']) && $sardo_gleason_data['Resultat'] != 'Gleason') {
    			if(preg_match('/\[((([0-9]+\+[0-9]+)=){0,1}([0-9]+))\]$/', $sardo_gleason_data['Resultat'], $matches)) {
    				$gleason_sum = $matches[4];
    				$gleason_grade = $matches[3];
    				if(array_key_exists($sardo_gleason_data['sardo_traitement_RecNumber'], $sardo_treatment_rec_number_to_gleason)) {
    					list($recorded_gleason_sum, $recorded_gleason_grade) = $sardo_treatment_rec_number_to_gleason[$sardo_gleason_data['sardo_traitement_RecNumber']];
    					if($recorded_gleason_sum != $gleason_sum || $recorded_gleason_grade != $gleason_grade) {
    						$import_summary['Report']['WARNING']["More than one gleason linked to the same ".$sardo_gleason_data['TypeTX']][] = "See NoLabo(s) { ".formatNoLabosForSummary($no_labos_string)." } and treatment RecNumber ".$sardo_gleason_data['sardo_traitement_RecNumber'].".";
    					}
    				} else {
    					$sardo_treatment_rec_number_to_gleason[$sardo_gleason_data['sardo_traitement_RecNumber']] = array($gleason_sum, $gleason_grade);
    				}
    			} elseif(preg_match('/\[N\/S\]$/', $sardo_gleason_data['Resultat'], $matches)) {	
    			    $gleason_sum = '';
    			    $gleason_grade = 'N/S';
    			} else {
    				$import_summary['Report']['ERROR']["Wrong SARDO gleason format "][] = "See ".$sardo_gleason_data['TypeTX']." gleason [".$sardo_gleason_data['Resultat']."] of NoLabo(s) { ".formatNoLabosForSummary($no_labos_string)." } and treatment RecNumber ".$sardo_gleason_data['sardo_traitement_RecNumber'].".";
    			}
			}
		}
		//Work on treatment
		$query_res = customQuery("SELECT * FROM sardo_traitement WHERE ParentRecNumber IN ('".implode("','", array_keys($diagnosis_rec_nbrs_to_ids))."');", __LINE__);
		$atim_treatments_data_to_create = array();
		$tmp_treatment_summaries = array();
		while($sardo_treatments_data = mysqli_fetch_assoc($query_res)) {	    
			//Set treatment data
			$trt_type = $sardo_treatments_data['TypeTX'];
			if(in_array($trt_type, array('CHIR','BIOP'))) $trt_type = 'CHIR/BIOP';
			$tx_method = 'sardo treatment - '.strtolower($trt_type);
			$start_date = null;
			$start_date_accuracy = null;
			if(!isset($treatment_controls[$tx_method])) {
				if($trt_type) {
					$import_summary['Treatment']['ERROR']["SARDO treatment [$trt_type] is unknow"][$trt_type] = 'No detail'; //"See NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
				} else {
					$import_summary['Treatment']['ERROR']["At least one SARDO treatment type is not defined"][] = "See NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
				}
			} else {			    
				//Create treatment data set
				$start_date = $sardo_treatments_data['DateDebutTraitement'];
				$start_date_accuracy = $sardo_treatments_data['DateDebutTraitement_accuracy'];
				$finish_date = $sardo_treatments_data['DateFinTraitement'];
				$finish_date_accuracy = $sardo_treatments_data['DateFinTraitement_accuracy'];
				$NoPatho = $sardo_treatments_data['NoPatho'];
				$results = $sardo_treatments_data['Resultat_Alpha'];
				$objectifs = $sardo_treatments_data['ObjectifTX'];
				$gleason_sum = '';
				$gleason_grade = '';
				if(array_key_exists($sardo_treatments_data['RecNumber'], $sardo_treatment_rec_number_to_gleason)) {
					list($gleason_sum, $gleason_grade) = $sardo_treatment_rec_number_to_gleason[$sardo_treatments_data['RecNumber']];
				}
				//Build the treatment key
                $treatment_key = md5($trt_type.$start_date.$finish_date);
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
						'TreatmentDetail' => array(),
						'TreatmentExtends' => array());	
					$tmp_treatment_summaries[$treatment_key] = array('qc_nd_sardo_tx_all_patho_nbrs' => array(), 'qc_nd_sardo_tx_detail_summary' => array());
				}
				$treatment_extend_data = $sardo_treatments_data['Traitement'];
				if(strlen($treatment_extend_data.$NoPatho.$results.$objectifs.$gleason_sum.$gleason_grade)) {		
					$atim_treatments_data_to_create[$treatment_key]['TreatmentExtends'][] = array(
						'TreatmentExtendMaster' => array('treatment_extend_control_id' => $treatment_controls[$tx_method]['treatment_extend_control_id']),
						'TreatmentExtendDetail' => array(
						    'treatment' => $treatment_extend_data,
            				'patho_nbr' => $NoPatho,
            				'results' => $results,
            				'objectifs' => $objectifs,
            				'gleason_sum' => $gleason_sum,
            				'gleason_grade' => $gleason_grade));
            		if(strlen($NoPatho)) $tmp_treatment_summaries[$treatment_key]['qc_nd_sardo_tx_all_patho_nbrs'][$NoPatho] = $NoPatho;
            		if(strlen($sardo_treatments_data['Traitement'])) $tmp_treatment_summaries[$treatment_key]['qc_nd_sardo_tx_detail_summary'][$sardo_treatments_data['Traitement']] = $sardo_treatments_data['Traitement'];
				}
			}
		}	
		//Record treatment
		foreach($atim_treatments_data_to_create as $treatment_key => $new_treatment_to_create) {
		    $new_treatment_to_create['TreatmentMaster']['qc_nd_sardo_tx_all_patho_nbrs'] = implode(' & ', $tmp_treatment_summaries[$treatment_key]['qc_nd_sardo_tx_all_patho_nbrs']);
		    $new_treatment_to_create['TreatmentMaster']['qc_nd_sardo_tx_detail_summary'] = implode(' & ', $tmp_treatment_summaries[$treatment_key]['qc_nd_sardo_tx_detail_summary']);
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
		    if(strlen($sardo_report_data['Resultat']) && $sardo_report_data['ElementRapport'] != $sardo_report_data['Resultat']) {
		        // If Résultat == ÉlementRapport LIKE 'Récepteurs aux oestrogènes (RE)', it means that no result exists in SARDO
		        if(!preg_match('/ \-\-\-\-> \[ (.+) \]$/i', $sardo_report_data['Resultat'], $matches)) {
                    $import_summary['Report']['ERROR']["Wrong report result format. Data won't be imported."][] = "See result [" .$sardo_report_data['Resultat']. "] for '".$sardo_report_data['ElementRapport']."' on ".$sardo_report_data['DateDebutTraitement']." NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
		        } else {
                    $results = $matches[1];
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
        						'event_date_accuracy' => $sardo_report_data['DateDebutTraitement_accuracy'],
        						'event_summary' => $results . (strlen($results)? " (données de SARDO)." : "")),
        					'EventDetail' => array());
        				if(preg_match('/^((\++)|(.*\ (\++))|(.*\ (\++),.*)|((\++),.*)|(.*intensité\ (0).*))$/i', $results, $matches)) {
        				    $atim_event_data_to_create['EventDetail']['intensity'] = '';
        				    foreach(array(2,4,6,8,10) as $matchId) {
        				        $atim_event_data_to_create['EventDetail']['intensity'] .= (array_key_exists($matchId, $matches) && strlen($matches[$matchId]))? $matches[$matchId] : '';
        				    }
        				}
        				if(preg_match('/((faiblement positif)|(douteux)|(positif)|(négatif))/i', $results, $matches)) {
        				    $atim_event_data_to_create['EventDetail']['result'] = $matches[1];
        				}
        				if(in_array($control['detail_tablename'], array('qc_nd_ed_estrogen_receptor_reports', 'qc_nd_ed_progestin_receptor_reports'))) {
        					if(preg_match('/(([0-9]+\.{0,1}[0-9]*)\ \%)/i', $results, $matches)) {
        						$atim_event_data_to_create['EventDetail']['percentage'] = str_Replace(',', '.', $matches[2]);
        					}
        				} else if($control['detail_tablename'] == 'qc_nd_ed_her2_neu') {
        					$atim_event_data_to_create['EventDetail']['fish'] = $fish? 'y' : 'n';
        				} else {
        					importDie("Unsupported detail tablename [".$control['detail_tablename']."]! ERR#_LAB00003");
        				}
        				$atim_event_data_to_create['EventMaster']['id'] = getNextReusableId('event_masters');
        				$event_master_id = customInsert($atim_event_data_to_create['EventMaster'], 'event_masters', __LINE__, false);
        				$atim_event_data_to_create['EventDetail']['event_master_id'] = $event_master_id;
        				customInsert($atim_event_data_to_create['EventDetail'], $control['detail_tablename'], __LINE__, true);
        			}
		        }
    		}
		}
	}
}

// *** APS & CA-125 *********************************************************************

function importLaboData($pariticpant_id, $patient_rec_number, $diagnosis_rec_nbrs_to_ids, $no_labos_string) {
	global $import_summary;
	global $import_date;
	global $import_by;
	global $ca125_psa_scc_event_controls;
	
	if($diagnosis_rec_nbrs_to_ids) {
		//Get SARO Labo Data
		$query_res_sardo_labo = customQuery("SELECT * FROM sardo_labo WHERE NomLabo IN ('APS pré-op', 'APS', 'CA-125', 'SCC') AND ParentRecNumber IN ('".implode("','", array_keys($diagnosis_rec_nbrs_to_ids))."');", __LINE__);
		if($query_res_sardo_labo->num_rows) {
			$atim_all_labos_data = array('ca125' => array(), 'psa' => array(), 'scc' => array());
			foreach(array('ca125','psa', 'scc') as $test) {
				$event_control_id = $ca125_psa_scc_event_controls[$test]['id'];
				$query_res_atim_labo = customQuery("SELECT EventMaster.id, EventMaster.event_date, EventMaster.event_date_accuracy, EventMaster.event_control_id, EventDetail.value
					FROM event_masters EventMaster INNER JOIN ".$ca125_psa_scc_event_controls[$test]['detail_tablename']." EventDetail ON EventDetail.event_master_id = EventMaster.id
					WHERE EventMaster.participant_id = $pariticpant_id AND EventMaster.deleted <> 1 AND EventMaster.event_control_id = ".$ca125_psa_scc_event_controls[$test]['id'].";", __LINE__);
				while($atim_labo_data = mysqli_fetch_assoc($query_res_atim_labo)) {
					$atim_formated_date = getFormatedDateForATiMDisplay($atim_labo_data['event_date'], $atim_labo_data['event_date_accuracy']);					
					if($atim_formated_date) $atim_all_labos_data[$test][$atim_formated_date][] = $atim_labo_data;
				}
			}
			$sardo_all_labos_data = array();
			while($sardo_labo_data = mysqli_fetch_assoc($query_res_sardo_labo)) {
			    if($sardo_labo_data['Resultat'] != '-99' && strlen($sardo_labo_data['Resultat'])) {
    			    $sardo_formated_date = getFormatedDateForATiMDisplay($sardo_labo_data['Date'], $sardo_labo_data['Date_accuracy']);
    				$atim_test_title = '';
    				switch($sardo_labo_data['NomLabo']) {
    					case 'CA-125':
    						$atim_test_title = 'ca125';
    						break;
    					case 'SCC':
    						$atim_test_title = 'scc';
    						break;
    					default:
    						$atim_test_title = 'psa';
    						break;
    				}
    				if(!$sardo_formated_date) {
    					$import_summary['Labo']['WARNING']["At least one SARDO $atim_test_title date is not defined. $atim_test_title has not been studied"][] = "$atim_test_title = ".$sardo_labo_data['Resultat'].". See NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
    				} else {
                        $sardo_labo_data['Resultat'] = str_replace(',','.',$sardo_labo_data['Resultat']);
    				    if(preg_match('/^([0-9]+)(\.([0-9]+)){0,1}$/', $sardo_labo_data['Resultat'], $matches)) {
    				        $sardo_labo_data['Resultat'] = $matches[1].'.'.substr((isset($matches[3])? $matches[3].'000' : '000'), 0, (($atim_test_title == 'scc')? '2' : '3'));
    				    }
    					$sardo_all_labos_data[$atim_test_title][$sardo_formated_date][] = array(
    					    'Date' => $sardo_labo_data['Date'],
    					    'Date_accuracy' => $sardo_labo_data['Date_accuracy'],
    					    'Resultat' => $sardo_labo_data['Resultat']
    					);
    				}
			    }
			}
			$multiple_daily_results = array();
			foreach($sardo_all_labos_data as $atim_test_title => $sardo_all_labos_data_level1) {
			    foreach($sardo_all_labos_data_level1 as $sardo_formated_date => $sardo_all_labos_data_level2) {
					if(sizeof($sardo_all_labos_data[$atim_test_title][$sardo_formated_date]) > 1) {
					   $multiple_daily_results[$atim_test_title][$sardo_formated_date] = 'found';
					} else {
					    $sardo_labo_data = $sardo_all_labos_data[$atim_test_title][$sardo_formated_date][0];
    					if(!isset($atim_all_labos_data[$atim_test_title][$sardo_formated_date])) {
    						$atim_event_data_to_create= array(
    							'EventMaster' => array(
    								'event_control_id' => $ca125_psa_scc_event_controls[$atim_test_title]['id'],
    								'participant_id' => $pariticpant_id,
    								'event_date' => $sardo_labo_data['Date'],
    								'event_date_accuracy' => $sardo_labo_data['Date_accuracy']),
    							'EventDetail' => array(
    								'value' => $sardo_labo_data['Resultat']));
    				        $atim_event_data_to_create['EventMaster']['id'] = getNextReusableId('event_masters');
    				        $event_master_id = customInsert($atim_event_data_to_create['EventMaster'], 'event_masters', __LINE__, false, true);
    						$atim_event_data_to_create['EventDetail']['event_master_id'] = $event_master_id;
    						customInsert($atim_event_data_to_create['EventDetail'],  $ca125_psa_scc_event_controls[$atim_test_title]['detail_tablename'], __LINE__, true, true);
    					} else if(sizeof($atim_all_labos_data[$atim_test_title][$sardo_formated_date]) > 1) {
    					    $multiple_daily_results[$atim_test_title][$sardo_formated_date] = 'found';
    					} else if($atim_all_labos_data[$atim_test_title][$sardo_formated_date][0]['value'] != $sardo_labo_data['Resultat']) {
    						$import_summary['Labo']['WARNING']["SARDO $atim_test_title value different than ATiM $atim_test_title value on the same date. Will update ATiM data with the SARDO value"][] = "SARDO $atim_test_title = ".$sardo_labo_data['Resultat']."/ ATiM $atim_test_title = ".$atim_all_labos_data[$atim_test_title][$sardo_formated_date][0]['value']." on $sardo_formated_date. See NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
    						$event_master_id = $atim_all_labos_data[$atim_test_title][$sardo_formated_date][0]['id'];
    						$detail_tablename = $ca125_psa_scc_event_controls[$atim_test_title]['detail_tablename'];
    						$queries = array(	
    							"UPDATE event_masters SET modified = '$import_date', modified_by = '$import_by' WHERE id = $event_master_id;",
    							"INSERT INTO event_masters_revs (event_control_id, id, event_summary, event_date, event_date_accuracy, modified_by, participant_id, diagnosis_master_id, version_created) (SELECT event_control_id, id, event_summary, event_date, event_date_accuracy, modified_by, participant_id, diagnosis_master_id, modified FROM event_masters WHERE modified = '$import_date' AND modified_by = '$import_by' AND id = $event_master_id);",
    							"UPDATE $detail_tablename SET value = '".$sardo_labo_data['Resultat']."' WHERE event_master_id = $event_master_id;",
    							"INSERT INTO ".$detail_tablename."_revs (value, event_master_id, version_created) VALUES ('".$sardo_labo_data['Resultat']."', $event_master_id, '$import_date');");	
    						foreach($queries as $new_query) customQuery($new_query, __LINE__);
    					}
    				}
				}
			}
			foreach($multiple_daily_results as $atim_test_title => $multiple_daily_results_level1) {
			    foreach($multiple_daily_results_level1 as $sardo_formated_date => $multiple_daily_results_level2) {
			        //ATiM
			        $atim_day_results = array();
			        if(isset($atim_all_labos_data[$atim_test_title][$sardo_formated_date])) {
    			        foreach($atim_all_labos_data[$atim_test_title][$sardo_formated_date] as $atim_labo_result) {
    			            $atim_day_results[$atim_labo_result['value']] = $atim_labo_result['value'];
    			        }
			        }
			        ksort($atim_day_results);
			        //SARDO
			        $sardo_day_results = array();
			        $atim_event_date = '';
			        $atim_event_date_accuracy = '';
			        foreach($sardo_all_labos_data[$atim_test_title][$sardo_formated_date] as $sardo_labo_result) {
			            $sardo_day_results[$sardo_labo_result['Resultat']] = $sardo_labo_result['Resultat'];
    			        $atim_event_date = $sardo_labo_result['Date'];
    			        $atim_event_date_accuracy = $sardo_labo_result['Date_accuracy'];
			        }
			        ksort($sardo_day_results);
			        // Define new lab to create
			        $sardo_day_results_to_create = array_diff($sardo_day_results, $atim_day_results);
			        $created_sardo_day_results_strg = null;
			        if($sardo_day_results_to_create) {
			            $sardo_day_results_created = array();
    			        foreach($sardo_day_results_to_create as $new_sardo_day_result) {
    			            if(!in_array($new_sardo_day_result, $atim_day_results)) {
        			            $atim_event_data_to_create= array(
        			                'EventMaster' => array(
        			                    'event_control_id' => $ca125_psa_scc_event_controls[$atim_test_title]['id'],
        			                    'participant_id' => $pariticpant_id,
        			                    'event_date' => $atim_event_date,
        			                    'event_date_accuracy' =>$atim_event_date_accuracy),
        			                'EventDetail' => array(
        			                    'value' => $new_sardo_day_result));
        			            $atim_event_data_to_create['EventMaster']['id'] = getNextReusableId('event_masters');
        			            $event_master_id = customInsert($atim_event_data_to_create['EventMaster'], 'event_masters', __LINE__, false, true);
        			            $atim_event_data_to_create['EventDetail']['event_master_id'] = $event_master_id;
        			            customInsert($atim_event_data_to_create['EventDetail'],  $ca125_psa_scc_event_controls[$atim_test_title]['detail_tablename'], __LINE__, true, true);
        			            $sardo_day_results_created[] = $new_sardo_day_result;
        			        }
    			        }
    			        if($sardo_day_results_created) {
        			        $created_sardo_day_results_strg = implode(' & ', $sardo_day_results_created);
        			        $created_sardo_day_results_strg = "Created following $atim_test_title results on $sardo_formated_date : ".$created_sardo_day_results_strg;
    			        }
			        } 
			        //Manage message
			        $atim_day_results_strg = implode(' & ', $atim_day_results);
			        $atim_day_results = implode('#', array_keys($atim_day_results));
			        $sardo_day_results_strg = implode(' & ', $sardo_day_results);
			        $sardo_day_results = implode('#', array_keys($sardo_day_results));
			        if ($created_sardo_day_results_strg) {
			            $import_summary['Labo']['WARNING']["New Labo has been created but many $atim_test_title values exist either into ATiM or into SARDO on the same date. Please confirm."][] = "$created_sardo_day_results_strg. SARDO results = [$sardo_day_results_strg] / ATiM previous results = [" . (strlen($atim_day_results_strg)? $atim_day_results_strg : 'no value')."]. See NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
			        } else if($sardo_day_results != $atim_day_results) {
		                $import_summary['Labo']['WARNING']["Many $atim_test_title values exist either into ATiM or into SARDO on the same date but set of results are different. No new data has been created. Please validate and add correction if required."][] = "SARDO results = [$sardo_day_results_strg] / ATiM results = [" . (strlen($atim_day_results_strg)? $atim_day_results_strg : 'no value')."] on $sardo_formated_date. See NoLabo(s) : ".formatNoLabosForSummary($no_labos_string);
		            }
			    } 
			}
		}
	}
}

function getFormatedDateForATiMDisplay($date, $accuracy)  {
	if(!empty($date)) {
		switch($accuracy) {
			case 'c':
				return $date;
			case 'd':
				return substr($date, 0, strrpos($date, '-'));
			case 'm':
				return substr($date, 0, strpos($date, '-'));
			case 'y':
				return '+/-'.substr($date, 0, strpos($date, '-'));
		}
	}
	return '';
}

// *** Collection *********************************************************************

function linkCollectionToSardoTreatment($db_schema) {
	global $import_summary;

	//Check more than one SARDO treatments can be linked to a collection based on date
	$query = "SELECT bank_name, identifier_value, collection_datetime, visit_label
		FROM (
			SELECT count(*) AS nbr_of_treatments, collection_id
			FROM (
				SELECT DISTINCT Collection.id collection_id, TreatmentMaster.id treatment_master_id
				FROM collections Collection, treatment_masters TreatmentMaster, sample_masters SampleMaster, sample_controls SampleControl
				WHERE Collection.deleted <> 1
				AND Collection.collection_datetime IS NOT NULL
				AND Collection.collection_datetime NOT LIKE ''
				AND SampleMaster.deleted <> 1
				AND SampleMaster.collection_id = Collection.id
				AND SampleMaster.sample_control_id = SampleControl.id
				AND SampleControl.sample_type = 'tissue'
				AND TreatmentMaster.deleted <> 1
				AND TreatmentMaster.start_date IS NOT NULL
				AND TreatmentMaster.start_date NOT LIKE ''
				AND TreatmentMaster.participant_id = Collection.participant_id
				AND TreatmentMaster.start_date = DATE(Collection.collection_datetime)
				AND TreatmentMaster.treatment_control_id IN (SELECT id FROM treatment_controls WHERE flag_active = 1 AND tx_method = 'sardo treatment - chir/biop')
			) RES1 GROUP BY collection_id
		) RES2 INNER JOIN view_collections ON RES2.collection_id = view_collections.collection_id
		WHERE RES2.nbr_of_treatments > 1;";
	$query_res = customQuery($query, __LINE__);
	while($res = mysqli_fetch_assoc($query_res))
		$import_summary['Collection']['WARNING']["Collection cannot be linked to more than one SARDO treatments - Only one treatment will be linked to the collection"][] = "See collection on ".$res['collection_datetime']." for the participant ".formatNoLabosForSummary($res['identifier_value'])." (NoLabo of bank ".$res['bank_name'].").";
	//Set collections.treatment_master_id
	// - Exact matches on dates and approximatively match on patho # for collection with tissue first then collection with patho # only
	// - Exact matches on dates and no collection patho #
	customQuery("UPDATE collections SET treatment_master_id = null;", __LINE__);
	customQuery("UPDATE collections_revs SET treatment_master_id = null;", __LINE__);	//Value can be set if user updated a collection already linked to a treatment
	//.... Both dates are exact (0000-00-00) & dates match & collection patho # is completed (length > 2) and matches approximatively the patho # of the sardo biop/surg
	$query = "UPDATE collections Collection, treatment_masters TreatmentMaster, treatment_controls TreatmentControl
		SET Collection.treatment_master_id = TreatmentMaster.id
		WHERE Collection.deleted <> 1
		AND Collection.treatment_master_id IS NULL
		AND TreatmentMaster.deleted <> 1
		AND TreatmentMaster.participant_id = Collection.participant_id
		AND TreatmentMaster.treatment_control_id = TreatmentControl.id
	    AND TreatmentControl.flag_active = 1
	    AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
		AND Collection.collection_datetime IS NOT NULL
		AND TreatmentMaster.start_date = DATE(Collection.collection_datetime)
        AND TreatmentMaster.start_date_accuracy NOT IN ('y','m','d')
	    AND Collection.collection_datetime_accuracy NOT IN ('y','m','d')
	    AND (TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs LIKE CONCAT('%', Collection.qc_nd_pathology_nbr, '%') OR Collection.qc_nd_pathology_nbr LIKE CONCAT('%', TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs, '%'))
        AND LENGTH(Collection.qc_nd_pathology_nbr) >= 2
	    AND LENGTH(TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs) >= 2;";
	customQuery($query, __LINE__);
	//.... Both dates are exact (0000-00-00) & dates match & collection contains tissue & collection patho # is not completed
	$query = "UPDATE collections Collection, treatment_masters TreatmentMaster, treatment_controls TreatmentControl, sample_masters SampleMaster, sample_controls SampleControl
		SET Collection.treatment_master_id = TreatmentMaster.id
		WHERE Collection.deleted <> 1
		AND Collection.treatment_master_id IS NULL
		AND TreatmentMaster.deleted <> 1
		AND TreatmentMaster.participant_id = Collection.participant_id
		AND TreatmentMaster.treatment_control_id = TreatmentControl.id
	    AND TreatmentControl.flag_active = 1
	    AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
		AND SampleMaster.deleted <> 1
		AND SampleMaster.collection_id = Collection.id
		AND SampleMaster.sample_control_id = SampleControl.id
		AND SampleControl.sample_type = 'tissue'
		AND Collection.collection_datetime IS NOT NULL
		AND TreatmentMaster.start_date = DATE(Collection.collection_datetime)
        AND TreatmentMaster.start_date_accuracy NOT IN ('y','m','d')
	    AND Collection.collection_datetime_accuracy NOT IN ('y','m','d')
        AND (Collection.qc_nd_pathology_nbr IS NULL OR Collection.qc_nd_pathology_nbr = '');";
	customQuery($query, __LINE__);
	//.... Both dates are exact (0000-00-00) & dates match & collection contains tissue & collection patho # is completed (length > 2) & biops/surg patho# is not completed
	$query = "UPDATE collections Collection, treatment_masters TreatmentMaster, treatment_controls TreatmentControl, sample_masters SampleMaster, sample_controls SampleControl
		SET Collection.treatment_master_id = TreatmentMaster.id
		WHERE Collection.deleted <> 1
		AND Collection.treatment_master_id IS NULL
		AND TreatmentMaster.deleted <> 1
		AND TreatmentMaster.participant_id = Collection.participant_id
		AND TreatmentMaster.treatment_control_id = TreatmentControl.id
	    AND TreatmentControl.flag_active = 1
	    AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
		AND SampleMaster.deleted <> 1
		AND SampleMaster.collection_id = Collection.id
		AND SampleMaster.sample_control_id = SampleControl.id
		AND SampleControl.sample_type = 'tissue'
		AND Collection.collection_datetime IS NOT NULL
		AND TreatmentMaster.start_date = DATE(Collection.collection_datetime)
        AND TreatmentMaster.start_date_accuracy NOT IN ('y','m','d')
	    AND Collection.collection_datetime_accuracy NOT IN ('y','m','d')
	    AND LENGTH(Collection.qc_nd_pathology_nbr) >= 2
        AND (TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs IS NULL OR TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs = '');";
    // Data Integrity Warning: Approximatively the same patho # but dates are diferent probably
	$query = "SELECT
    	Collection.participant_id,
    	Collection.collection_datetime,
    	Collection.collection_datetime_accuracy,
    	TreatmentMaster.start_date,
    	TreatmentMaster.start_date_accuracy,
    	Collection.qc_nd_pathology_nbr,
    	TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs,
	    TreatmentMaster.qc_nd_sardo_tx_detail_summary
    	FROM collections Collection, treatment_masters TreatmentMaster, treatment_controls TreatmentControl
    	WHERE Collection.deleted <> 1
    	AND Collection.treatment_master_id IS NULL
    	AND TreatmentMaster.deleted <> 1
    	AND TreatmentMaster.participant_id = Collection.participant_id
    	AND TreatmentMaster.treatment_control_id = TreatmentControl.id
    	AND TreatmentControl.flag_active = 1
    	AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
    	AND (TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs LIKE CONCAT('%', Collection.qc_nd_pathology_nbr, '%') OR Collection.qc_nd_pathology_nbr LIKE CONCAT('%', TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs, '%'))
    	AND LENGTH(Collection.qc_nd_pathology_nbr) >= 2
    	AND LENGTH(TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs) >= 2;";
	$query_res_collection_treatment_error = customQuery($query, __LINE__);
	while($atim_collection_treatment_error = mysqli_fetch_assoc($query_res_collection_treatment_error)) {
	    $import_summary['Unlinked Collection to SARDO BIOP/SURG : Data integrity check']['WARNING']["Pathology numbers are approximatively the same but dates are different"][] = 
    	    "ATiM Collection on '".substr($atim_collection_treatment_error['collection_datetime'], 0 ,10)." (".$atim_collection_treatment_error['collection_datetime_accuracy'].")' with Patho# '".$atim_collection_treatment_error['qc_nd_pathology_nbr']."'".
    	    " vs ".
    	    "SARDO BIOP/SURG on '".$atim_collection_treatment_error['start_date']." (".$atim_collection_treatment_error['start_date_accuracy'].")' with Patho# '".$atim_collection_treatment_error['qc_nd_sardo_tx_all_patho_nbrs']."' (".$atim_collection_treatment_error['qc_nd_sardo_tx_detail_summary'].")";
	}
	// Warning: Approximatively the same day of tissue collection and date of surgery
	$query = "SELECT DISTINCT
    	Collection.participant_id,
    	DATE(Collection.collection_datetime),
    	Collection.collection_datetime_accuracy,
    	TreatmentMaster.start_date,
    	TreatmentMaster.start_date_accuracy,
    	Collection.qc_nd_pathology_nbr,
    	TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs,
	    TreatmentMaster.qc_nd_sardo_tx_detail_summary
    	FROM collections Collection, treatment_masters TreatmentMaster, treatment_controls TreatmentControl, sample_masters SampleMaster, sample_controls SampleControl
    	WHERE Collection.deleted <> 1
    	AND Collection.treatment_master_id IS NULL
    	AND TreatmentMaster.deleted <> 1
    	AND TreatmentMaster.participant_id = Collection.participant_id
    	AND TreatmentMaster.treatment_control_id = TreatmentControl.id
    	AND TreatmentControl.flag_active = 1
    	AND TreatmentControl.tx_method = 'sardo treatment - chir/biop'
    	AND SampleMaster.deleted <> 1
    	AND SampleMaster.collection_id = Collection.id
    	AND SampleMaster.sample_control_id = SampleControl.id
    	AND SampleControl.sample_type = 'tissue'
    	AND Collection.collection_datetime IS NOT NULL
        AND TreatmentMaster.start_date IS NOT NULL
        AND TreatmentMaster.start_date_accuracy NOT IN ('y','m','d')
        AND Collection.collection_datetime_accuracy NOT IN ('y','m','d')
    	AND ABS(DATEDIFF(TreatmentMaster.start_date, DATE(Collection.collection_datetime))) <= 2;";
	while($atim_collection_treatment_error = mysqli_fetch_assoc($query_res_collection_treatment_error)) {
	    $import_summary['Unlinked Collection to SARDO BIOP/SURG : Data integrity check']['WARNING']["2 days exist between the 2 events"][] = 
            "ATiM Collection on '".$atim_collection_treatment_error['collection_datetime']." (".$atim_collection_treatment_error['collection_datetime_accuracy'].")' with Patho# '".$atim_collection_treatment_error['qc_nd_pathology_nbr']."'".
            " vs ".
            "SARDO BIOP/SURG on '".$atim_collection_treatment_error['start_date']." (".$atim_collection_treatment_error['start_date_accuracy'].")' with Patho# '".$atim_collection_treatment_error['qc_nd_sardo_tx_all_patho_nbrs']."' (".$atim_collection_treatment_error['qc_nd_sardo_tx_detail_summary'].")";
	}
	//Update view_collections
	$query = "SELECT COUNT(*) AS field_exists
	   FROM information_schema.COLUMNS
	   WHERE TABLE_SCHEMA='$db_schema' AND TABLE_NAME LIKE 'view_collections' AND COLUMN_NAME = 'qc_nd_pathology_nbr_from_sardo';";
	$update_view = customQuery($query, __LINE__);
	$update_view =  mysqli_fetch_assoc($update_view);
	if($update_view['field_exists']) {
		$query = "REPLACE INTO view_collections (
			SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Collection.collection_protocol_id AS collection_protocol_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
Bank.name AS bank_name,
MiscIdentifier.identifier_value AS identifier_value,
MiscIdentifierControl.misc_identifier_name AS identifier_name,
Collection.visit_label AS visit_label,
Collection.qc_nd_pathology_nbr,
TreatmentMaster.qc_nd_sardo_tx_all_patho_nbrs as qc_nd_pathology_nbr_from_sardo
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.id = Collection.treatment_master_id AND TreatmentMaster.deleted <> 1
        WHERE Collection.deleted <> 1);";
		customQuery($query, __LINE__);
	} else {
		customQuery("UPDATE versions SET permissions_regenerated = 0;", __LINE__);
	}
}

//=========================================================================================================================================================================================================
//
// ******* OTHER FUNCTIONS *******
//
//=========================================================================================================================================================================================================


function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function importDie($msg, $rollbak = true) {
	global $import_summary;
	global $db_connection;
	global $import_date;
	global $cd_icm_sardo_data_import_try_final_queries;
	global $cd_icm_sardo_data_import_triy_id;
	
	$msg = "ImportSardoDataFromXmlFile Process Aborted\nError : $msg\nNo ATiM data has been updated";
	if($rollbak) {
		mysqli_rollback($db_connection);
		echo "$msg";
		$cd_icm_sardo_data_import_try_final_queries[] = "UPDATE cd_icm_sardo_data_import_tries
    		SET global_result = 'failed',
    		update_participant_counter = '0',
    		details = '".str_replace("'", "''", $msg)."'
    		WHERE id = $cd_icm_sardo_data_import_triy_id;";
		foreach($cd_icm_sardo_data_import_try_final_queries as $cd_icm_sardo_data_import_tries_query) {
		    customQuery($cd_icm_sardo_data_import_tries_query, __LINE__);
		}		
		mysqli_commit($db_connection);
		die();
	} else {
		// Any error before tables data change
		die($msg);
	}
}

function customQuery($query, $line, $insert = false) {
	global $db_connection;
	if($query_res = mysqli_query($db_connection, $query)) { 
		return ($insert)? mysqli_insert_id($db_connection) : $query_res;
	} else {
		echo "Query Error :: ".mysqli_error($db_connection)."\n";
		echo "Line :: $line\n";
		echo "QUERY : [$query]\n\n";
		importDie("Query Error! ERR#_$line");
	}
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
		$revs_table_system_data = $is_detail_table? array('version_created' => "'$import_date'") : array('id' => "$record_id", 'version_created' => "'$import_date'", "modified_by" => "'$import_by'");
		$insert_arr = array_merge($data_to_insert, $revs_table_system_data);
		customQuery("INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $line, true);
	}
	
	return $record_id;
}

function formatNoLabosForSummary($no_labos_string) {
	if($no_labos_string) {
		return "NoLabo#".str_replace(array("'",","), array("", "#, NoLabo#"), $no_labos_string)."#";
	}
	return $no_labos_string;
}

function recordImportSummary() {
	global $import_summary;
	
	customQuery("DELETE FROM sardo_import_summary;", __LINE__, true);
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
}

function getNextReusableId($table_name) {
    global $next_reusable_table_ids;
    
    if(!array_key_exists($table_name, $next_reusable_table_ids)) {
        $query_res = customQuery("SELECT MIN(id) AS next_used_id FROM $table_name;", __LINE__);
        $query_res = mysqli_fetch_assoc($query_res);
        if(empty($query_res['next_used_id'])) {
            $next_free_id = 1;
            $next_used_id = null;
        } else if($query_res['next_used_id'] != '1') {
            $next_free_id = 1;
            $next_used_id = $query_res['next_used_id'];
        } else {
            $query_res = customQuery(" SELECT id + 1 AS next_free_id FROM $table_name WHERE (id + 1) NOT IN (SELECT id FROM $table_name) ORDER BY id LIMIT 1;", __LINE__);
            $query_res = mysqli_fetch_assoc($query_res);
            $next_free_id = $query_res['next_free_id'];
            $query_res = customQuery("SELECT MIN(id) AS next_used_id FROM $table_name WHERE id > $next_free_id;", __LINE__);
            $query_res = mysqli_fetch_assoc($query_res);
            $next_used_id = empty($query_res['next_used_id'])? null : $query_res['next_used_id'];
        }
        $next_reusable_table_ids[$table_name] = array($next_free_id, $next_used_id);
    }
    list($next_free_id, $next_used_id) = $next_reusable_table_ids[$table_name];
    if(is_null($next_used_id) || ($next_free_id < $next_used_id)) {
        $next_reusable_table_ids[$table_name] = array(($next_free_id+1), $next_used_id);
        return $next_free_id;
    } else {
        //$next_free_id == $next_used_id
        $query_res = customQuery(" SELECT id + 1 AS next_free_id FROM $table_name WHERE (id + 1) NOT IN (SELECT id FROM $table_name) AND id >= $next_used_id ORDER BY id LIMIT 1;", __LINE__);
        $query_res = mysqli_fetch_assoc($query_res);
        $next_free_id = $query_res['next_free_id'];
        $query_res = customQuery("SELECT MIN(id) AS next_used_id FROM $table_name WHERE id > $next_free_id;", __LINE__);
        $query_res = mysqli_fetch_assoc($query_res);
        $next_used_id = empty($query_res['next_used_id'])? null : $query_res['next_used_id'];
        $next_reusable_table_ids[$table_name] = array(($next_free_id+1), $next_used_id);
    }
    return $next_free_id;
}
