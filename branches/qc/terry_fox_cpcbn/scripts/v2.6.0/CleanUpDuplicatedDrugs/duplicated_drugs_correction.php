<?php

set_time_limit('3600');

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "am3-y-4606";
$db_schema		= "atimtfricpcbn";
$db_charset		= "utf8";

//==================================================================================================================================================================================
// DATABSE CONNECTION
//==================================================================================================================================================================================

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or migrationDie("ERR_DATABASE_CONNECTION: Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("ERR_DATABASE_CONNECTION: Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or migrationDie("ERR_DATABASE_CONNECTION: Unable to connect to $db_schema for user $db_user");
mysqli_autocommit($db_connection, false);

//==================================================================================================================================================================================
// SYSTEM VARIABLES
//==================================================================================================================================================================================
$migration_user_id = 1;
global $import_date;
global $imported_by;
$query_result = getSelectQueryResult("SELECT NOW() AS import_date, id FROM users WHERE id = '$migration_user_id';");
if(empty($query_result)) {
	migrationDie("ERR_DATABASE_CONNECTION: Migration user id '$migration_user_id' does not exist into $db_schema");
}
$import_date = $query_result[0]['import_date'];
$imported_by = $migration_user_id;

$sorted_drugs = array();
$query_result = getSelectQueryResult("SELECT generic_name, type, id FROM drugs WHERE deleted <> 1 ORDER BY id ASC;");
foreach($query_result as $new_drug_data) {
	$key = strtolower($new_drug_data['type'].'## ##'.$new_drug_data['generic_name']);
	$sorted_drugs[$key][] = $new_drug_data;
}

foreach($sorted_drugs as $same_drugs) {
	if(sizeof($same_drugs) > 1) {
		$id_to_keep = null;	
		$drug_ids_to_delete = array();
		foreach($same_drugs as $drug_data) {	
			if(!$id_to_keep) {
pr('Duplicated Drug (cleaned) : '.$drug_data['type'].' - '.$drug_data['generic_name']);
				$id_to_keep = $drug_data['id'];
			} else {
				$drug_ids_to_delete[] = $drug_data['id'];
			}
		}
		$query = "UPDATE txe_chemos SET drug_id = $id_to_keep WHERE drug_id IN (".implode(',',$drug_ids_to_delete).")";
pr($query);
		customQuery($query);
		customQuery(str_replace('txe_chemos', 'txe_chemos_revs', $query));
		$query = "DELETE FROM drugs WHERE id IN (".implode(',',$drug_ids_to_delete).")";
pr($query);
		customQuery($query);
		customQuery(str_replace('drugs', 'drugs_revs', $query));
	}
}

mysqli_commit($db_connection);

//==================================================================================================================================================================================
// SYSTEM FUNCTION
//==================================================================================================================================================================================

function migrationDie($error_messages) {
	if(is_array($error_messages)) {
		foreach($error_messages as $msg) pr($msg);
	} else {
		pr($error_messages);
	}
	pr('-------------------------------------------------------------------------------------------------------------------------------------');
	$counter = 0;
	foreach(debug_backtrace() as $debug_data) {
		$counter++;
		pr("$counter- Function ".$debug_data['function']."() [File: ".$debug_data['file']." - Line: ".$debug_data['line']."]");
	}
	die('Please contact your administrator');
}

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

// ---- QUERY FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------------------

function customQuery($query, $insert = false) {
	global $db_connection;
	$query_res = mysqli_query($db_connection, $query) or migrationDie(array("ERR_QUERY", mysqli_error($db_connection), $query));
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}

function getSelectQueryResult($query) {
	if(!preg_match('/^[\ ]*SELECT/i', $query))  migrationDie(array("ERR_QUERY", "'SELECT' query expected", $query));
	$select_result = array();
	$query_result = customQuery($query);
	while($row = $query_result->fetch_assoc()) {
		$select_result[] = $row;
	}
	return $select_result;
}
	
?>
		