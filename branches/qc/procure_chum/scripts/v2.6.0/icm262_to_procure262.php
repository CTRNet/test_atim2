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
mysqli_autocommit($db_icm_connection, true);

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
// Trunkate : to remove
//TODO
//--------------------------------------------------------------------------------------------------------------------------------------------

foreignKeyCheck(0);
$truncate_arr = array(
	'participants', 'participants_revs',
	'misc_identifiers', 'misc_identifiers_revs'
);
foreach($truncate_arr as $tablename) 	mysqli_query($db_procure_connection, "TRUNCATE participants;") or die("query failed ["."TRUNCATE participants;"."]: " . mysqli_error($db_procure_connection)."]");
foreignKeyCheck(1);

//--------------------------------------------------------------------------------------------------------------------------------------------
// USERS/GROUPS
//--------------------------------------------------------------------------------------------------------------------------------------------

echo "<br><br>****************** USERS/GROUPS ******************************<br><br>";

foreignKeyCheck(0);
foreach(array('banks','groups','versions') as $tablename) {
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

$query = "select participant_identifier, date_of_death, approximate_date_of_death FROM participants WHERE approximate_date_of_death IS NOT NULL;";
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
	'qc_nd_last_contact');
//Record data into participants
$fields = implode(', ', array_merge($participants_fields, array('created','created_by','modified','modified_by','deleted')));
$query = "REPLACE INTO $db_procure_schema.participants ($fields) (SELECT $fields FROM $db_icm_schema.participants);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$fields = implode(', ', array_merge($participants_fields, array('modified_by','version_id','version_created')));
$query = "REPLACE INTO $db_procure_schema.participants_revs ($fields) (SELECT $fields FROM $db_icm_schema.participants_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Check all participants linked to No Labo Prostate (IN ICM)
$query = "SELECT count(*) AS count FROM participants WHERE deleted <> 1 AND id NOT IN (SELECT mid.participant_id FROM misc_identifiers mid INNER JOIN misc_identifier_controls midc ON midc.id = mid.misc_identifier_control_id WHERE midc.misc_identifier_name = 'prostate bank no lab' AND mid.deleted <> 1);";
$query_res = mysqli_query($db_icm_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_icm_connection)."]");
$res = mysqli_fetch_assoc($query_res);
if($res['count']) die('ERR 73873783939309300');
//Record Misc Identifier data
mysqli_query($db_procure_connection, "TRUNCATE misc_identifier_controls;") or die("query failed ["."TRUNCATE misc_identifier_controls;"."]: " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifier_controls (SELECT * FROM $db_icm_schema.misc_identifier_controls);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifiers (SELECT * FROM $db_icm_schema.misc_identifiers);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "REPLACE INTO $db_procure_schema.misc_identifiers_revs (SELECT * FROM $db_icm_schema.misc_identifiers_revs);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Replace participant_identifier by No Labo Prostate
$query = "UPDATE participants part, misc_identifiers mid, misc_identifier_controls midc 
	SET part.participant_identifier = mid.identifier_value, part.modified = '$modified', part.modified_by = $modified_by
	WHERE midc.id = mid.misc_identifier_control_id AND part.id = mid.participant_id AND midc.misc_identifier_name = 'prostate bank no lab' AND mid.deleted <> 1;";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$fields = implode(', ', array_merge($participants_fields, array('modified_by','modified')));
$fields_revs = implode(', ', array_merge($participants_fields, array('modified_by','version_created')));
$query = "INSERT INTO participants_revs ($fields_revs) (SELECT $fields FROM participants);";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
//Delete all No Labo Prostate
$query = "UPDATE misc_identifiers mid, misc_identifier_controls midc SET mid.deleted = 1, mid.modified = '$modified', mid.modified_by = $modified_by WHERE midc.id = mid.misc_identifier_control_id AND midc.misc_identifier_name = 'prostate bank no lab';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "INSERT INTO misc_identifiers_revs (id,identifier_value,misc_identifier_control_id,participant_id,modified_by,version_created,tmp_deleted,flag_unique) 
	(SELECT mid.id,mid.identifier_value,mid.misc_identifier_control_id,mid.participant_id,mid.modified_by,mid.modified,mid.tmp_deleted,mid.flag_unique
	FROM misc_identifiers mid INNER JOIN misc_identifier_controls midc WHERE midc.id = mid.misc_identifier_control_id AND midc.misc_identifier_name = 'prostate bank no lab');";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");
$query = "UPDATE misc_identifier_controls midc	SET midc.flag_active = 0 WHERE midc.misc_identifier_name = 'prostate bank no lab';";
mysqli_query($db_procure_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_procure_connection)."]");







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


function recordAndSortMsg($type, $patient_bank_nbr, $line_counter, $msg) {
	global $messages;
	global $messages_codes;
	
	if(!preg_match('/^(Msg#[0-9]{1,3})\ ::\ /', $msg, $matches)) {
		die('ERR 66276872687326827 '.$msg);
	}
	$messages_codes[$matches[1]] = $matches[1];
	
	switch($type) {
		case 'error':
			$messages['error'][] = "Patient $patient_bank_nbr : " .$msg;
			$msg = "<FONT color='red'>$msg</FONT>";
			break;
		case 'warning':
			$msg = "<FONT color='#E56717'>$msg</FONT>";
			break;
		case 'message':
			$msg = "<FONT color='black'><i>$msg</i></FONT>";
			break;
		case 'todo':
			$msg = "<FONT color='blue'>$msg</FONT>";
			break;
		default:
	}
	$messages["patient :: $patient_bank_nbr // line :: $line_counter"][] = $msg;
}

function printMessages() {
	global $messages;
	
	echo "<br><FONT color='red'><b> ---- ERRORS -------------------------------------------</b></FONT><br><br>";
	foreach($messages['error'] as $msg) echo "$msg<br>";
	unset($messages['error']);
	
	echo "<br><FONT color='red'><b> ---- Message Per Participant -------------------------------------------</b></FONT><br><br>";
	foreach($messages as $patient_info => $patient_msgs) {
		echo "<b>*** $patient_info ***</b><br>";
		foreach($patient_msgs AS $msg)echo "$msg<br>";
	}
}

function printQueries(){
	global $all_queries;
	foreach($all_queries as $patient_info => $queries) {
		echo "<b>$patient_info</b><br>";
		foreach($queries AS $new_query) echo "<i><font color='#848484'>$new_query</i></font><br>";
	}
}

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

?>