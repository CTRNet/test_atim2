<?php

/*
 * Migrate all data from icm v2.6.2 with procure data to procure v262
 */

set_time_limit('3600');

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_icm_ip			= "127.0.0.1";
$db_icm_port 		= "3306";
$db_icm_user 		= "root";
$db_icm_pwd			= "";
global $db_icm_schema;
$db_icm_schema		= "icm";
$db_icm_charset		= "utf8";

$db_procure_ip			= "127.0.0.1";
$db_procure_port 		= "3306";
$db_procure_user 		= "root";
$db_procure_pwd			= "";
global $db_procure_schema;
$db_procure_schema		= "procurechum";
$db_procure_charset		= "utf8";

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_icm_connection;
$db_icm_connection = @mysqli_connect(
		$db_icm_ip.(!empty($db_icm_port)? ":".$db_icm_port : ''),
		$db_icm_user,
		$db_icm_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_icm_connection, $db_icm_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_icm_connection, $db_icm_schema) or die("db selection failed");

global $db_procure_connection;
$db_procure_connection = @mysqli_connect(
		$db_procure_ip.(!empty($db_procure_port)? ":".$db_procure_port : ''),
		$db_procure_user,
		$db_procure_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_procure_connection, $db_procure_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_procure_connection, $db_procure_schema) or die("db selection failed");
mysqli_autocommit($db_procure_connection, true);

//--------------------------------------------------------------------------------------------------------------------------------------------

global $modified_by;
global $modified;

$modified_by = '9';

$query = "SELECT NOW() as modified FROM study_summaries;";
$modified_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_icm_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}

//--------------------------------------------------------------------------------------------------------------------------------------------

$bank_identification = 'PS1P';

$no_labo_to_db_data = array();
$query = "SELECT p.id AS participant_id, m.identifier_value, cm.consent_signed_date
	FROM participants p
	INNER JOIN misc_identifiers m ON m.participant_id = p.id AND m.deleted <> 1 
	INNER JOIN misc_identifier_controls mc ON mc.id = m.misc_identifier_control_id
	LEFT JOIN consent_masters cm ON cm.participant_id = p.id
	WHERE p.deleted <> 1 AND m.deleted <> 1 AND mc.misc_identifier_name = 'prostate bank no lab' AND cm.deleted <> 1
	ORDER BY p.id ASC, cm.consent_signed_date DESC";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_icm_connection)."]");
While($res = mysqli_fetch_assoc($query_res)) {
	if(!isset($no_labo_to_db_data[$res['identifier_value']])) {
		$no_labo_to_db_data[$res['identifier_value']] = array(
			'participant_id' => $res['participant_id'],
			'consent_signed_date' => $res['consent_signed_date']);
	}
}

//--------------------------------------------------------------------------------------------------------------------------------------------
// Trunkate : to remove
//TODO
//--------------------------------------------------------------------------------------------------------------------------------------------

foreignKeyCheck(0);
$truncate_arr = array(
	'participants', 'participants_revs',
	'misc_identifiers', 'misc_identifiers_revs',
	'consent_masters', 'consent_masters_revs',
	'procure_cd_sigantures', 'procure_cd_sigantures_revs',
	'participant_messages','participant_messages_revs', 
	'participant_contacts', 'participant_contacts_revs',
	'event_masters', 'event_masters_revs',
	'procure_ed_lifestyle_quest_admin_worksheets', 'procure_ed_lifestyle_quest_admin_worksheets_revs',
	'storage_masters','std_rooms','std_cupboards','std_nitro_locates','std_incubators','std_fridges','std_freezers','std_boxs','std_racks','std_shelfs','std_tma_blocks',
	'storage_masters_revs','std_rooms_revs','std_cupboards_revs','std_nitro_locates_revs','std_incubators_revs','std_fridges_revs','std_freezers_revs','std_boxs_revs','std_racks_revs','std_shelfs_revs','std_tma_blocks_revs',	
	'collections', 'collections_revs',
	'study_summaries', 'study_summaries_revs'
);
foreach($truncate_arr as $tablename) 	mysqli_query($db_procure_connection, "TRUNCATE $tablename;") or die("query failed ["."TRUNCATE $tablename;"."]: " . mysqli_error($db_procure_connection)."]");
foreignKeyCheck(1);

//--------------------------------------------------------------------------------------------------------------------------------------------
// USERS/GROUPS
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** USERS/GROUPS ******************************<br><br>";

foreignKeyCheck(0);
foreach(array('banks','groups','users') as $tablename) {
	$query = "REPLACE INTO $db_procure_schema.$tablename (SELECT * FROM $db_icm_schema.$tablename);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
}
$tablename = 'banks';
$revs_tablename = $tablename."_revs";
$query = "TRUNCATE $revs_tablename;";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.$revs_tablename (SELECT * FROM $db_icm_schema.$revs_tablename);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");

$query = "SELECT count(*) AS count FROM groups WHERE bank_id NOT IN (SELECT id FROM banks);";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
if($res['count']) die('ERR 7387383989309.1');

$query = "SELECT count(*) AS count  FROM users WHERE group_id NOT IN (SELECT id FROM groups);";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
if($res['count']) die('ERR 7387383989309.2');

$query = "UPDATE users SET flag_active = 0 WHERE group_id != (SELECT id FROM groups WHERE name = 'Users Prostate') AND username != 'NicoEn';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// PARTICIPANTS & MISC-IDENTIFIERS
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** PARTICIPANTS ******************************<br><br>";

echo "Following participants fields wont't be migrated :<br> - last_visit_date,<br> - sardo_participant_id, <br> - sardo_medical_record_number, <br> - last_sardo_import_date, <br> - qc_nd_from_center, <br> - is_anonymous, <br> - anonymous_reason, <br> - anonymous_precision<br><br>";

$query = "select participant_identifier, date_of_death, approximate_date_of_death FROM participants WHERE approximate_date_of_death IS NOT NULL AND deleted <> 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['participant_identifier'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have an approximate date of death in ICM version : Dates won't be migrated<br><br>";

$participants_fields = array(
	'id',
	'title',
	'first_name',
	'middle_name',
	'last_name',
	'date_of_birth',
	'date_of_birth_accuracy',
	'marital_status',
	'language_preferred',
	'sex',
	'race',
	'vital_status',
	'notes',
	'date_of_death',
	'date_of_death_accuracy',
	'cod_icd10_code',
	'secondary_cod_icd10_code',
	'cod_confirmation_source',
	'participant_identifier',
	'last_chart_checked_date',
	'last_chart_checked_date_accuracy',
	'last_modification',
	'last_modification_ds_id',
	'qc_nd_last_contact'
);
//Record data into participants
$fields = implode(', ', array_merge($participants_fields, array('created','created_by','modified','modified_by','deleted')));
$query = "REPLACE INTO $db_procure_schema.participants ($fields) (SELECT $fields FROM $db_icm_schema.participants);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$fields = implode(', ', array_merge($participants_fields, array('modified_by','version_id','version_created')));
$query = "REPLACE INTO $db_procure_schema.participants_revs ($fields) (SELECT $fields FROM $db_icm_schema.participants_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Check all participants linked to No Labo Prostate (IN ICM)
$query = "SELECT id FROM participants WHERE deleted <> 1 AND id NOT IN (SELECT mid.participant_id FROM misc_identifiers mid INNER JOIN misc_identifier_controls midc ON midc.id = mid.misc_identifier_control_id WHERE midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1)
		UNION ALL
		SELECT mid.participant_id FROM misc_identifiers mid INNER JOIN misc_identifier_controls midc ON midc.id = mid.misc_identifier_control_id WHERE midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1 AND mid.identifier_value NOT REGEXP '^(([0-9]{3,4})|([Ss]1-P[0-9]{3}))$';";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['id'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have no barcode or barcode with a wrong format<br><br>";
$participant_ids_with_no_barcode = $participant_identifiers;
//Record Misc Identifier data
mysqli_query($db_procure_connection, "TRUNCATE misc_identifier_controls;") or die("query failed ["."TRUNCATE misc_identifier_controls;"."]: " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifier_controls (SELECT * FROM $db_icm_schema.misc_identifier_controls);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifiers (SELECT * FROM $db_icm_schema.misc_identifiers);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifiers_revs (SELECT * FROM $db_icm_schema.misc_identifiers_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Replace participant_identifier by $bank_identification+code barre
$query = "UPDATE participants part, misc_identifiers mid, misc_identifier_controls midc 
	SET part.participant_identifier = CONCAT('$bank_identification', mid.identifier_value), part.modified = '$modified', part.modified_by = $modified_by
	WHERE midc.id = mid.misc_identifier_control_id AND part.id = mid.participant_id AND midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1 AND mid.identifier_value REGEXP '^[0-9]{4}$';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE participants part, misc_identifiers mid, misc_identifier_controls midc
	SET part.participant_identifier = CONCAT('$bank_identification','0', mid.identifier_value), part.modified = '$modified', part.modified_by = $modified_by
	WHERE midc.id = mid.misc_identifier_control_id AND part.id = mid.participant_id AND midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1 AND mid.identifier_value REGEXP '^[0-9]{3}$';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE participants part, misc_identifiers mid, misc_identifier_controls midc
	SET part.participant_identifier = CONCAT('$bank_identification','0', REPLACE( mid.identifier_value , 'S1-P' , '')), part.modified = '$modified', part.modified_by = $modified_by
	WHERE midc.id = mid.misc_identifier_control_id AND part.id = mid.participant_id AND midc.misc_identifier_name = 'code-barre' AND mid.deleted <> 1 AND mid.identifier_value REGEXP '^[Ss]1-P[0-9]{3}$';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE participants SET participant_identifier = CONCAT('$bank_identification', '0000') WHERE id IN (".implode(',',$participant_ids_with_no_barcode).");";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$fields = implode(', ', array_merge($participants_fields, array('modified_by','modified')));
$fields_revs = implode(', ', array_merge($participants_fields, array('modified_by','version_created')));
$query = "INSERT INTO participants_revs ($fields_revs) (SELECT $fields FROM participants);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Delete all No Labo Prostate
$query = "UPDATE misc_identifiers mid, misc_identifier_controls midc SET mid.deleted = 1, mid.modified = '$modified', mid.modified_by = $modified_by WHERE midc.id = mid.misc_identifier_control_id AND midc.misc_identifier_name = 'code-barre';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO misc_identifiers_revs (id,identifier_value,misc_identifier_control_id,participant_id,tmp_deleted,flag_unique,modified_by,version_created) 
	(SELECT mid.id,mid.identifier_value,mid.misc_identifier_control_id,mid.participant_id,mid.tmp_deleted,mid.flag_unique,mid.modified_by,mid.modified
	FROM misc_identifiers mid INNER JOIN misc_identifier_controls midc WHERE midc.id = mid.misc_identifier_control_id AND midc.misc_identifier_name = 'code-barre');";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE misc_identifier_controls midc SET midc.flag_active = 0 WHERE midc.misc_identifier_name = 'code-barre';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// CONSENTS
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** CONSENTS ******************************<br><br>";

echo "Following consents fields won't be migrated :
<br> - consent_version_date
<br> - invitation_date
<br> - consent_status
<br> - status_date
<br> - reason_denied
<br> - consent_control_id<br><br>";

$query = "SELECT * FROM (SELECT count(*) as count, participant_id FROM consent_masters WHERE deleted <> 1 GROUP BY participant_id) AS res WHERE res.count > 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['participant_id'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have 2 consents<br><br>";
$participant_ids_with_2_csts = $participant_identifiers;

$query = "SELECT participant_id FROM consent_masters WHERE consent_status <> 'obtained' AND deleted <> 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['participant_id'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have consent status != obtained<br><br>";

$query = "SELECT participant_id FROM consent_masters WHERE consent_control_id != (SELECT id FROM consent_controls WHERE flag_active = 1 AND controls_type = 'procure') AND deleted <> 1;";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_icm_connection)."]");
$participant_identifiers = array();
While($res = mysqli_fetch_assoc($query_res)) {
	$participant_identifiers[] = $res['participant_id'];
}
if($participant_identifiers) echo "Participants (#syst code = ".implode(', ',$participant_identifiers).") have consent different than  'procure' consent<br><br>";

$query = "select id from consent_controls WHERE controls_type = 'procure consent form signature';";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$consent_control_id = $res['id'];

//Consent Master
$query = "INSERT INTO $db_procure_schema.consent_masters (id, participant_id, consent_control_id, procure_form_identification, form_version, consent_signed_date, consent_signed_date_accuracy,notes,created,created_by,modified,modified_by,deleted)
	(SELECT id, participant_id, $consent_control_id, id, consent_language,consent_signed_date, consent_signed_date_accuracy,notes,created,created_by,modified,modified_by,deleted from $db_icm_schema.consent_masters);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.consent_masters_revs (id, participant_id, consent_control_id, procure_form_identification, form_version, consent_signed_date, consent_signed_date_accuracy,notes,modified_by,version_id,version_created)
	(SELECT id, participant_id, $consent_control_id, id, consent_language,consent_signed_date, consent_signed_date_accuracy,notes,modified_by,version_id,version_created from $db_icm_schema.consent_masters_revs);";
$queries = array(
	"UPDATE consent_masters SET form_version = 'english' WHERE form_version = 'en';",
	"UPDATE consent_masters_revs SET form_version = 'english' WHERE form_version = 'en';",
	"UPDATE consent_masters SET form_version = 'french' WHERE form_version = 'fr';",
	"UPDATE consent_masters_revs SET form_version = 'french' WHERE form_version = 'fr';",
	"UPDATE consent_masters SET consent_signed_date_accuracy = 'h' WHERE consent_signed_date_accuracy IN ('c','');",
	"UPDATE consent_masters_revs SET consent_signed_date_accuracy = 'h' WHERE consent_signed_date_accuracy IN ('c','');",
	"UPDATE consent_masters cst, participants p SET cst.procure_form_identification = CONCAT(p.participant_identifier, ' V0 -CSF1') WHERE p.id = cst.participant_id;",
	"UPDATE consent_masters_revs cst, participants p SET cst.procure_form_identification = CONCAT(p.participant_identifier, ' V0 -CSF1') WHERE p.id = cst.participant_id;");
foreach($queries as $query) mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Consent Detail
$cst_detail_fields = array(
	'consent_master_id',
	'qc_nd_biological_material_use',
	'qc_nd_use_of_urine',
	'qc_nd_use_of_blood',
	'qc_nd_research_other_disease',
	'qc_nd_urine_blood_use_for_followup',
	'qc_nd_stop_followup',
	'qc_nd_stop_followup_date',
	'qc_nd_allow_questionnaire',
	'qc_nd_stop_questionnaire',
	'qc_nd_stop_questionnaire_date',
	'qc_nd_contact_for_additional_data',
	'qc_nd_inform_significant_discovery',
	'qc_nd_inform_discovery_on_other_disease');
$fields = implode(', ', $cst_detail_fields);
$fields_icm = str_replace('qc_nd_','',$fields);
$query = "INSERT INTO $db_procure_schema.procure_cd_sigantures ($fields) (SELECT $fields_icm FROM $db_icm_schema.cd_icm_generics);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$fields_revs = implode(', ', array_merge($cst_detail_fields, array('version_id','version_created')));
$fields_revs_icm = str_replace('qc_nd_','',$fields_revs);
$query = "INSERT INTO $db_procure_schema.procure_cd_sigantures_revs ($fields_revs) (SELECT $fields_revs_icm FROM $db_icm_schema.cd_icm_generics_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Update Identification (cst.) for patient having more than 1 cst
$query = "SELECT cst.participant_id, p.participant_identifier, cst.id AS consent_master_id FROM consent_masters cst INNER JOIN participants p ON p.id = cst.participant_id WHERE participant_id IN (".implode(',',$participant_ids_with_2_csts).") AND cst.deleted <> 1 ORDER BY cst.participant_id, cst.consent_signed_date;";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$std_p_id = null;
$sct_nbr = null;
while($res = mysqli_fetch_assoc($query_res)) {	
	if($std_p_id != $res['participant_id']) {
		$std_p_id = $res['participant_id'];
		$sct_nbr = 0;
	}
	$sct_nbr++;
	$queries = array(
		"UPDATE consent_masters SET procure_form_identification = CONCAT('".$res['participant_identifier']."', ' V0 -CSF', $sct_nbr) WHERE id = ".$res['consent_master_id'].";",
		"UPDATE consent_masters_revs SET procure_form_identification = CONCAT('".$res['participant_identifier']."', ' V0 -CSF', $sct_nbr) WHERE id = ".$res['consent_master_id'].";");
	foreach($queries as $query) mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
}

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// Questionnaire
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** QUESTIONNAIRES ******************************<br><br>";

$query = "SELECT id FROM event_controls WHERE event_type = 'procure questionnaire administration worksheet';";
$query_res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$res = mysqli_fetch_assoc($query_res);
$event_control_id = $res['id'];
require_once 'Excel/reader.php';
$file_path = "C:/_Perso/Server/procure_chum/data/Biobanque ProCure 2005-2012--25-02-2014.xls";
$XlsReader = new Spreadsheet_Excel_Reader();
$XlsReader->read($file_path);
foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
$headers = array();
$nl_labos_linked_to_approximative_date_equal_to_cst_date = array();
$nl_labos_with_no_questionnaire = array();
$line_counter = 0;
$q_errors = array('empty date' => array(), 'no_labo_unknown' => array(), 'more than one' => array());
foreach($XlsReader->sheets[$sheets_nbr['Cas complet']]['cells'] as $line => $new_line) {
	
//TODO
continue; 
//TODO
		
	$line_counter++;
	if($line_counter == 1) {
		$headers = $new_line;
	} else {
		//Get line data
		$new_line_data = array();
		foreach($headers as $key => $field) {
			if(isset($new_line[$key])) {
				$new_line_data[utf8_encode($field)] = utf8_encode($new_line[$key]);
			} else {
				$new_line_data[utf8_encode($field)] = '';
			}
		}
		//Manage data
		$approximative_date = '';
		$q_no_labo = ((strlen($new_line_data['NoLabo']) == '3')? '500' : '50').$new_line_data['NoLabo'];	
		$q_revision_date_tmp = getDateAndAccuracy($new_line_data['Date de révision'], 'Date de révision', $line_counter, true);
		$q_revision_date = $q_revision_date_accuracy = null;
		if($q_revision_date_tmp) {
			$q_revision_date = $q_revision_date_tmp['date'];
			$q_revision_date_accuracy = $q_revision_date_tmp['accuracy'];
			$approximative_date = $q_revision_date;
		}
		$q_reception_date_tmp = getDateAndAccuracy($new_line_data['Date de reception'], 'Date de reception', $line_counter, true);
		$q_reception_date = $q_reception_date_accuracy = null;
		if($q_reception_date_tmp) {
			$q_reception_date = $q_reception_date_tmp['date'];
			$q_reception_date_accuracy = $q_reception_date_tmp['accuracy'];
			$approximative_date = $q_reception_date;
		}
		if(isset($no_labo_to_db_data[$q_no_labo])) {
			if(isset($no_labo_to_db_data[$q_no_labo]['qc_done']) && $no_labo_to_db_data[$q_no_labo]['qc_done']) {
				$q_errors['more than one'][] = $q_no_labo;
			} else {
				$no_labo_to_db_data[$q_no_labo]['qc_done'] = true;
				if(!$approximative_date)  {
					if(empty($no_labo_to_db_data[$q_no_labo]['consent_signed_date'])) {
						$q_errors['empty date'][] = $q_no_labo;
					} else {
						$approximative_date = $no_labo_to_db_data[$q_no_labo]['consent_signed_date'];
						$nl_labos_linked_to_approximative_date_equal_to_cst_date[] = $q_no_labo;
					}
				}
				if($approximative_date) {
					$detail_data = array();
					foreach(array('Distribué', 'Reçu', 'Vérifié', 'Révisé', 'Complet') as $excel_field) if(!in_array($new_line_data[$excel_field], array('0','1', ''))) die('ERR 2376 287632 ');
					if($new_line_data['Révisé'] || $q_revision_date) {
						$detail_data = array(
							'delivery_date' => "'$approximative_date'", 'delivery_date_accuracy' => "'y'",
							'recovery_date' => "'".($q_reception_date? $q_reception_date : $approximative_date)."'", 'recovery_date_accuracy' => ($q_reception_date? "'$q_reception_date_accuracy'" : "'y'"),
							'verification_date' => "'$approximative_date'", 'verification_date_accuracy' => "'y'",
							'revision_date' => "'".($q_revision_date? $q_revision_date : $approximative_date)."'", 'revision_date_accuracy' => ($q_revision_date? "'$q_revision_date_accuracy'" : "'y'"),
							'verification_result' => ($new_line_data['Complet'] == '1')? "'complete'" : (($new_line_data['Complet'] == '0')? "'incomplete'" : "''"));
					} else if($new_line_data['Vérifié']) {
						$detail_data = array(
							'delivery_date' => "'$approximative_date'", 'delivery_date_accuracy' => "'y'",
							'recovery_date' => "'".($q_reception_date? $q_reception_date : $approximative_date)."'", 'recovery_date_accuracy' => ($q_reception_date? "'$q_reception_date_accuracy'" : "'y'"),
							'verification_date' => "'$approximative_date'", 'verification_date_accuracy' => "'y'",
							'verification_result' => ($new_line_data['Complet'] == '1')? "'complete'" : (($new_line_data['Complet'] == '0')? "'incomplete'" : "''"));
					} else if($new_line_data['Reçu'] || $q_reception_date) {
						$detail_data = array(
							'delivery_date' => "'$approximative_date'", 'delivery_date_accuracy' => "'y'",
							'recovery_date' => "'".($q_reception_date? $q_reception_date : $approximative_date)."'", 'recovery_date_accuracy' => ($q_reception_date? "'$q_reception_date_accuracy'" : "'y'"));
					} else if($new_line_data['Distribué']) {
						$detail_data = array(
							'delivery_date' => "'$approximative_date'", 'delivery_date_accuracy' => "'y'");
					}
					if($detail_data) {
						//EventMaster
						$query = "INSERT INTO $db_procure_schema.event_masters (participant_id, event_control_id, procure_form_identification, event_summary,created,created_by,modified,modified_by)
							VALUES
							(".$no_labo_to_db_data[$q_no_labo]['participant_id'].", $event_control_id, '', '', '$modified', $modified_by, '$modified', $modified_by);";
						
						mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
						$event_master_id = mysqli_insert_id($db_procure_connection);
						//EventDetail
						$fields = 'event_master_id,'.implode(', ', array_keys($detail_data));
						$values = $event_master_id.','.implode(', ', $detail_data);
						$query = "INSERT INTO $db_procure_schema.procure_ed_lifestyle_quest_admin_worksheets ($fields) VALUES ($values);";
						
						mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
					} else {
						$nl_labos_with_no_questionnaire[] = $q_no_labo;
						if($new_line_data['Complet']) die('ERR 23 7687326 872 '.$line_counter);					
					}
				}
			}
		} else {
			$q_errors['no_labo_unknown'][] = $q_no_labo;
		}
	}
}
//procure_form_identification
$query = "UPDATE $db_procure_schema.event_masters ev, $db_procure_schema.participants p SET ev.procure_form_identification = CONCAT(p.participant_identifier, ' V0 -QUE1') WHERE p.id = ev.participant_id AND ev.event_control_id = $event_control_id;";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Revs table
$query = "INSERT INTO $db_procure_schema.event_masters_revs (id, participant_id, event_control_id, procure_form_identification, event_summary, modified_by, version_created)
	(SELECT id, participant_id, event_control_id, procure_form_identification, event_summary, modified_by, modified from $db_procure_schema.event_masters WHERE event_control_id = $event_control_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO $db_procure_schema.procure_ed_lifestyle_quest_admin_worksheets_revs (event_master_id, delivery_date, recovery_date, verification_date, revision_date, verification_result, version_created)
	(SELECT event_master_id, delivery_date, recovery_date, verification_date, revision_date, verification_result, modified FROM $db_procure_schema.procure_ed_lifestyle_quest_admin_worksheets INNER JOIN $db_procure_schema.event_masters ON event_masters.id = event_master_id);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Messages
if($q_errors['empty date']) echo "Error: NoLabos [".implode(', ',$q_errors['empty date'])."] defined into questionnaire is both not linked to a date into questionnaire excel file and not linked to a consent date into ATiM database : unable to set a questionnaire approximative date so no questionnaire will be created<br><br>";
if($q_errors['no_labo_unknown']) echo "Error: NoLabos [".implode(', ',$q_errors['no_labo_unknown'])."] defined into questionnaire excel file does not match a patient into ATiM database<br><br>";
if($q_errors['more than one']) echo "Error: NoLabos [".implode(', ',$q_errors['more than one'])."] are linked to more than one questionnaire. Only the first one will be created<br><br>";
if($nl_labos_with_no_questionnaire) echo "Error: NoLabos [".implode(', ',$nl_labos_with_no_questionnaire)."] defined into questionnaire are not linked to questionnaire data : no questionnaire will be created<br><br>";
if($nl_labos_linked_to_approximative_date_equal_to_cst_date) echo "Error: NoLabos [".implode(', ',$nl_labos_linked_to_approximative_date_equal_to_cst_date)."] defined into questionnaire are not linked to questionnaire date : used consent date as approximative date<br><br>";

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// Contacts & Messages
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** CONTACTS & MESSAGES ******************************<br><br>";

foreach(array('participant_contacts', 'participant_contacts_revs') as $tablename) {
	$query = "INSERT INTO $db_procure_schema.$tablename (SELECT * FROM $db_icm_schema.$tablename);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
}
$message_fields = array('id',
	'date_requested',
	'date_requested_accuracy',
	'author',
	'message_type',
	'title',
	'description',
	'due_date',
	'due_date_accuracy',
	'expiry_date',
	'expiry_date_accuracy',
	'participant_id',
	'done',
	'status');
$fields = implode(',',$message_fields).',created,created_by,modified,modified_by,deleted';
$query = "INSERT INTO $db_procure_schema.participant_messages (".str_replace('status','qc_nd_status',$fields).") (SELECT $fields FROM $db_icm_schema.participant_messages);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$fields = implode(',',$message_fields).',modified_by,version_id,version_created';
$query = "INSERT INTO $db_procure_schema.participant_messages_revs (".str_replace('status','qc_nd_status',$fields).") (SELECT $fields FROM $db_icm_schema.participant_messages_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// STORAGES
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** STORAGES ******************************<br><br>";

$query = "TRUNCATE storage_controls;";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");		
$query = "INSERT INTO $db_procure_schema.storage_controls (SELECT * FROM $db_icm_schema.storage_controls);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$storage_tables = array('storage_masters','std_rooms','std_cupboards','std_nitro_locates','std_incubators','std_fridges','std_freezers','std_boxs','std_racks','std_shelfs','std_tma_blocks');
foreach($storage_tables as $new_table) {
	$query = "INSERT INTO $db_procure_schema.$new_table (SELECT * FROM $db_icm_schema.$new_table);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
	$new_table = $new_table.'_revs';
	$query = "INSERT INTO $db_procure_schema.$new_table (SELECT * FROM $db_icm_schema.$new_table);";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
}

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// STUDY
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** STUDIES ******************************<br><br>";

echo "Following fields won't be migrated : qc_nd_researcher, qc_nd_contact, qc_nd_code<br><br>";

$fields = array(
	'id',
	'disease_site',
	'study_type',
	'study_science',
	'study_use',
	'title',
	'start_date',
	'start_date_accuracy',
	'end_date',
	'end_date_accuracy',
	'summary',
	'abstract',
	'hypothesis',
	'approach',
	'analysis',
	'significance',
	'additional_clinical',
	'path_to_file');	
$field_strg = implode(', ', array_merge($fields, array('created','created_by','modified','modified_by','deleted')));
$query = "INSERT INTO $db_procure_schema.study_summaries ($field_strg) (SELECT $field_strg FROM $db_icm_schema.study_summaries);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$field_strg = implode(', ', array_merge($fields, array('modified_by','version_id','version_created')));
$query = "INSERT INTO $db_procure_schema.study_summaries_revs ($field_strg) (SELECT $field_strg FROM $db_icm_schema.study_summaries_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");

echo "done<br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// ORDER
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** ORDERS ******************************<br><br>";

echo "Nothing migrated<br><br>";

//--------------------------------------------------------------------------------------------------------------------------------------------
// INVENTORY
//--------------------------------------------------------------------------------------------------------------------------------------------

// -- COLLECTION --------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** COLLECTIONS ******************************<br><br>";

$procure_control_id = migrateCustomList('Specimen Collection Sites%', 'Specimen Collection Sites%');
$query = "DELETE FROM $db_procure_schema.structure_permissible_values_customs WHERE control_id = $procure_control_id AND value NOT IN (SELECT distinct collection_site FROM $db_icm_schema.collections WHERE collection_site IS NOT NULL);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");

$fields = array(
	'id',
	'collection_site',
	'collection_datetime',
	'collection_datetime_accuracy',
	'collection_property',
	'collection_notes',
	'participant_id',
	'procure_visit');
$field_strg = implode(', ', array_merge($fields, array('created','created_by','modified','modified_by','deleted')));
$query = "INSERT INTO $db_procure_schema.collections ($field_strg) (SELECT ".str_replace('procure_visit', 'visit_label', $field_strg)." FROM $db_icm_schema.collections);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$field_strg = implode(', ', array_merge($fields, array('modified_by','version_id','version_created')));
$query = "INSERT INTO $db_procure_schema.collections_revs ($field_strg) (SELECT ".str_replace('procure_visit', 'visit_label', $field_strg)." FROM $db_icm_schema.collections_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");

echo "done<br>";

// -- SAMPLES --------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** SAMPLES ******************************<br><br>";









/*

ICM sample controls

+----+--------------------+-----------------+------------------------+---------------------------------------+----------------------+---------------+--------------------+
| id | sample_type        | sample_category | qc_nd_sample_type_code | detail_form_alias                     | detail_tablename     | display_order | databrowser_label  |
+----+--------------------+-----------------+------------------------+---------------------------------------+----------------------+---------------+--------------------+
|  2 | blood              | specimen        | B                      | sd_spe_bloods,specimens               | sd_spe_bloods        |             0 | blood              |
|  3 | tissue             | specimen        | T                      | sd_spe_tissues,specimens              | sd_spe_tissues       |             0 | tissue             |
|  4 | urine              | specimen        | U                      | sd_spe_urines,specimens               | sd_spe_urines        |             0 | urine              |
|  7 | blood cell         | derivative      | BLD-C                  | sd_der_blood_cells,derivatives        | sd_der_blood_cells   |             0 | blood cell         |
|  8 | pbmc               | derivative      | PBMC                   | sd_der_pbmcs,derivatives              | sd_der_pbmcs         |             0 | pbmc               |
|  9 | plasma             | derivative      | PLS                    | sd_der_plasmas,derivatives            | sd_der_plasmas       |             0 | plasma             |
| 10 | serum              | derivative      | SER                    | sd_der_serums,derivatives             | sd_der_serums        |             0 | serum              |
| 11 | cell culture       | derivative      | C-CULT                 | sd_der_cell_cultures,derivatives      | sd_der_cell_cultures |             0 | cell culture       |
| 12 | dna                | derivative      | DNA                    | sd_der_dnas,derivatives               | sd_der_dnas          |             0 | dna                |
| 13 | rna                | derivative      | RNA                    | sd_der_rnas,derivatives               | sd_der_rnas          |             0 | rna                |
| 14 | concentrated urine | derivative      | CONC-U                 | sd_undetailed_derivatives,derivatives | sd_der_urine_cons    |             0 | concentrated urine |
| 15 | centrifuged urine  | derivative      | CENT-U                 | sd_undetailed_derivatives,derivatives | sd_der_urine_cents   |             0 | centrifuged urine  |
| 18 | b cell             | derivative      | LB                     | sd_undetailed_derivatives,derivatives | sd_der_b_cells       |             0 | b cell             |
+----+--------------------+-----------------+------------------------+---------------------------------------+----------------------+---------------+--------------------+

*/



















$query = "UPDATE versions SET permissions_regenerated = '0';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
pr('done');

exit;












//====================================================================================================================================================

function foreignKeyCheck($id) {
	global $db_procure_connection;
	$query = "SET foreign_key_checks = $id;";
	mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
}

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

function getDateAndAccuracy($date, $field, $line, $change_date_format = false) {
	$date_matches = array(
		'janv' => '01', 
		'février' => '02', 
		'mars' => '03', 
		'avr' => '04', 
		'avril' => '04', 
		'mai' => '05', 
		'juin' => '06', 
		'déc' => '12');
	$date = str_replace(array(' (v02)', '13-7-2010'), array('', '13-07-2010'), strtolower($date));
	$res = null;
	if(empty($date)) {
		return null;
	} else if(preg_match('/^([0-9]{5})$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date(($change_date_format? "Y-d-m" : "Y-m-d"), $php_offset + (($date - $xls_offset) * 86400));
		$res = array('date' => $date, 'accuracy' => 'c', 'format' => '# 1 #');
	} else if(preg_match('/^(0[1-9]|1[0-2])\-(19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[2].$matches[3].'-'.$matches[1].'-01', 'accuracy' => 'd', 'format' => '# 2 #');
	} else if(preg_match('/^(0[1-9]|[12][0-9]|3[0-1])[\-\/](0[1-9]|1[0-2])[\-\/](19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c', 'format' => '# 3 #');
	} else if(preg_match('/^(0[1-9]|[12][0-9]|3[0-1])[\-\/](0[1-9]|1[0-2])[\-\/]([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => '20'.$matches[3].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c', 'format' => '# 4 #');
	} else if(preg_match('/^([1-9])[\-\/](0[1-9]|1[0-2])[\-\/](19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[3].$matches[4].'-'.$matches[2].'-0'.$matches[1], 'accuracy' => 'c', 'format' => '# 5 #');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[1].$matches[2].'-01-01', 'accuracy' => 'm', 'format' => '# 6 #');
	} else if(preg_match('/^([1-9])[\-\ ]('.implode('|', array_keys($date_matches)).')[\-\ ](19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[3].$matches[4].'-'.str_replace(array_keys($date_matches), $date_matches, $matches[2]).'-0'.$matches[1], 'accuracy' => 'c', 'format' => '# 7 #');
	} else if(preg_match('/^(0[1-9]|[12][0-9]|3[0-1])[\-\ ]('.implode('|', array_keys($date_matches)).')[\-\ ](19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[3].$matches[4].'-'.str_replace(array_keys($date_matches), $date_matches, $matches[2]).'-'.$matches[1], 'accuracy' => 'c', 'format' => '# 8 #');
	} else if(preg_match('/^(0[1-9]|[12][0-9]|3[0-1])[\-\ ]('.implode('|', array_keys($date_matches)).')[\-\ ]([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => '20'.$matches[3].'-'.str_replace(array_keys($date_matches), $date_matches, $matches[2]).'-'.$matches[1], 'accuracy' => 'c', 'format' => '# 9 #');
	} else if(preg_match('/^('.implode('|', array_keys($date_matches)).')\ (19|20)([0-9]{2})$/',$date, $matches)) {
		$res = array('date' => $matches[2].$matches[3].'-'.str_replace(array_keys($date_matches), $date_matches, $matches[1]).'-01', 'accuracy' => 'd', 'format' => '# 10 #');
	} else {
		echo "Format of date '$date' is not supported! [field '$field' - line: $line]<br>";
		return null;
	}
	if(!preg_match('/^(19|20)([0-9]{2})\-(0[1-9]|1[0-2])\-(0[1-9]|[12][0-9]|3[0-1])$/',$res['date'], $matches)) {
		echo "Format of date '$date' is not supported! [field '$field' - line: $line]<br>";
		return null;
	}
	return $res;
}

function migrateCustomList($icm_list_name, $procure_list_name) {
	global $db_procure_connection;
	global $db_procure_schema;
	global $db_icm_schema;
	
	$query = "SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE '$icm_list_name'";
	$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
	$res = mysqli_fetch_assoc($res);
	$icm_control_id = $res['id'];
	
	$query = "SELECT id FROM structure_permissible_values_custom_controls WHERE name LIKE '$procure_list_name'";
	$res = mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
	$res = mysqli_fetch_assoc($res);
	$procure_control_id = $res['id'];	
	
	$queries = array(
			"DELETE FROM $db_procure_schema.structure_permissible_values_customs WHERE control_id = $procure_control_id;",
			"DELETE FROM $db_procure_schema.structure_permissible_values_customs_revs WHERE control_id = $procure_control_id;",
			"INSERT INTO $db_procure_schema.structure_permissible_values_customs (control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted) 
				(SELECT $procure_control_id, value, en, fr, display_order, use_as_input, created, created_by, modified, modified_by, deleted FROM $db_icm_schema.structure_permissible_values_customs WHERE control_id = $icm_control_id);",
			"INSERT INTO $db_procure_schema.structure_permissible_values_customs_revs (id, control_id, value, en, fr, display_order, use_as_input, modified_by, version_created) (SELECT id, control_id, value, en, fr, display_order, use_as_input, modified_by, modified FROM $db_procure_schema.structure_permissible_values_customs WHERE control_id = $procure_control_id);");
	foreach($queries AS $query) mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
	
	return $procure_control_id;
}

?>