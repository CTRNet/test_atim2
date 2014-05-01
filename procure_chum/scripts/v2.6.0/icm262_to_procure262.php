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
$db_icm_schema		= "icm";
$db_icm_charset		= "utf8";

$db_procure_ip			= "127.0.0.1";
$db_procure_port 		= "3306";
$db_procure_user 		= "root";
$db_procure_pwd			= "";
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

//--------------------------------------------------------------------------------------------------------------------------------------------
// Trunkate : to remove
//TODO
//--------------------------------------------------------------------------------------------------------------------------------------------

foreignKeyCheck(0);
$truncate_arr = array(
	'participants', 'participants_revs',
	'misc_identifiers', 'misc_identifiers_revs',
	'consent_masters', 'consent_masters_revs',
	'procure_cd_sigantures', 'procure_cd_sigantures_revs'
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







































$query = "UPDATE versions SET permissions_regenerated = '0';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
pr('done');

exit;








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

?>