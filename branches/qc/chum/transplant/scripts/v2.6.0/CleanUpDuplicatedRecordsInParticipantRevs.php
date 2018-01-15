<?php

global $import_summary;
$import_summary = array();

//==============================================================================================
// Database Connection
//==============================================================================================

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "atimoncologyaxisprod";
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

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE username = 'SardoMigration';", __LINE__);
if($query_res->num_rows != 1) importDie("DB connection: No user 'SardoMigration' into ATiM users table!");
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

//Get table fields

$unused_fields = array(
	'qc_nd_sardo_last_import',
	'qc_nd_sardo_cause_of_death',
	'qc_nd_sardo_rec_number',
	'qc_nd_sardo_diff_first_name',
	'qc_nd_sardo_diff_last_name',
	'qc_nd_sardo_diff_date_of_birth',
	'qc_nd_sardo_diff_sex',
	'qc_nd_sardo_diff_ram',
	'qc_nd_sardo_diff_hospital_nbr',
	'qc_nd_sardo_diff_date_of_death',
	'qc_nd_sardo_diff_vital_status',
	'qc_nd_sardo_diff_reproductive_history');		
$query = "SELECT COLUMN_NAME
	FROM information_schema.COLUMNS
	WHERE TABLE_SCHEMA='$db_schema' AND COLUMN_NAME NOT IN ('".implode("','", $unused_fields)."') AND TABLE_NAME LIKE 'participants_revs'";
$query_res = customQuery($query, __LINE__);
$table_fields = array();
while($res =  mysqli_fetch_assoc($query_res)) $table_fields[] = $res['COLUMN_NAME'];

// Get data

$query_res = customQuery("SELECT count(*) as nbr_of_records from participants_revs;", __LINE__);
$res =  mysqli_fetch_assoc($query_res);
pr("Start :: Nbr of records in participant_revs = ".$res['nbr_of_records']);

$query = "SELECT id FROM participants ORDER BY id";
$query_participant_id_res = customQuery($query, __LINE__);
while($participant_id_res =  mysqli_fetch_assoc($query_participant_id_res)) {
	$participant_id = $participant_id_res['id'];  
	$query = "SELECT ".implode(', ', $table_fields)." FROM participants_revs WHERE id = $participant_id ORDER BY id, version_id ASC;";
	$query_res = customQuery($query, __LINE__);
	$previous_record = null;
	$version_ids_to_delete = array();
	while($res =  mysqli_fetch_assoc($query_res)) {
		$modified_by = $res['modified_by'];
		unset($res['modified_by']);
		$version_id = $res['version_id'];
		unset($res['version_id']);
		$version_created = $res['version_created'];
		unset($res['version_created']);
		if($previous_record && $modified_by == $import_by) {
			if(!array_diff_assoc($previous_record, $res)) {
				$version_ids_to_delete[] = $version_id;
			}
		}
		$previous_record = $res;
		$previous_version_id = $version_id;
	}
	if($version_ids_to_delete) {
		$query = "DELETE FROM participants_revs WHERE version_id IN (".implode(',',$version_ids_to_delete).") AND modified_by = $import_by AND id = $participant_id;";
		customQuery($query, __LINE__);
	}
}

$query_res = customQuery("SELECT count(*) as nbr_of_records from participants_revs;", __LINE__);
$res =  mysqli_fetch_assoc($query_res);
pr("End :: Nbr of records in participant_revs = ".$res['nbr_of_records']);

mysqli_commit($db_connection);
die("participant_revs table cleanup completed on $import_date");

//=========================================================================================================================================================================================================
//
// ******* FUNCTIONS *******
//
//=========================================================================================================================================================================================================


function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function importDie($msg, $rollbak = true) {
	global $db_connection;
	if($rollbak) {
		mysqli_rollback($db_connection);
		echo "$msg";
		die($msg);
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


?>