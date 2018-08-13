<?php  

$nbr_of_identifiers_to_create = 500;

//-------------------------------------------------------------------------------------------------------------------------

$db_ip				= "localhost";
$db_port 			= "";
$db_user 			= "root";
$db_pwd				= "";
$db_schema	= "";
$db_charset			= "utf8";

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("DB connection: Could not connect to MySQL [".$db_ip.(!empty($db_port)? ":".$db_port : '')." / $db_user]");
if(!mysqli_set_charset($db_connection, $db_charset)){
	importDie("DB connection: Invalid charset", false);
}
@mysqli_select_db($db_connection, $db_schema) or die("DB connection: DB selection failed [$db_schema]");
mysqli_autocommit ($db_connection , false);

//-------------------------------------------------------------------------------------------------------------------------

if(true) {
    $key_name = 'ovary bank no lab';
    $misc_identifier_name = 'ovary/gyneco bank no lab';
    $nbr_of_identifiers_to_create = 50;
} else {
    $key_name = 'pulmonary bank no lab';
    $misc_identifier_name = $key_name;
    $nbr_of_identifiers_to_create = 50;
}

$query = "SELECT key_value FROM key_increments WHERE key_name = '$key_name';";
$query_res = customQuery($query, __LINE__);
$res =  mysqli_fetch_assoc($query_res);
$next_identifier_value_before_script = $res['key_value'];
if(empty($next_identifier_value_before_script)) die('err 1');

$query = "SELECT id FROM misc_identifier_controls WHERE misc_identifier_name = '$misc_identifier_name';";
$query_res = customQuery($query, __LINE__);
$res =  mysqli_fetch_assoc($query_res);
$misc_identifier_control_id = $res['id'];
if(empty($misc_identifier_control_id)) die('err 2');

$query = "SELECT NOW() as creation_date FROM aros LIMIT 0,1;";
$query_res = customQuery($query, __LINE__);
$res =  mysqli_fetch_assoc($query_res);
$date = $res['creation_date'];
if(empty($date)) die('err 2');

$insert_queries = array();
for($identifier_value = $next_identifier_value_before_script; $identifier_value < ($next_identifier_value_before_script + $nbr_of_identifiers_to_create); $identifier_value++) {
	$insert_queries[] = "($identifier_value, $misc_identifier_control_id, null, 1, '$date', '$date', 9, 9, 1, 1)";
}
$query = "INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, flag_unique, `modified`, `created`, `created_by`, `modified_by`, tmp_deleted, deleted) VALUES".
	implode(', ',$insert_queries).";";
customQuery($query, __LINE__);
$query = "INSERT INTO misc_identifiers_revs (id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, `modified_by`, `version_created`)
	(SELECT id, identifier_value, misc_identifier_control_id, participant_id, flag_unique, `modified_by`, `modified` FROM misc_identifiers WHERE misc_identifier_control_id = $misc_identifier_control_id AND created = '$date' AND created_by = 9);";
customQuery($query, __LINE__);
$query = "UPDATE key_increments SET key_value = ($next_identifier_value_before_script + $nbr_of_identifiers_to_create) WHERE key_name = '$key_name';";
customQuery($query, __LINE__);

mysqli_commit($db_connection);

pr("Created $nbr_of_identifiers_to_create identifiers '$misc_identifier_name' from $next_identifier_value_before_script to ".($next_identifier_value_before_script + $nbr_of_identifiers_to_create -1).". Next identifier value will be ".($next_identifier_value_before_script + $nbr_of_identifiers_to_create).".");

//-------------------------------------------------------------------------------------------------------------------------

function customQuery($query, $line, $insert = false) {
	global $db_connection;
	if($query_res = mysqli_query($db_connection, $query)) {
		return ($insert)? mysqli_insert_id($db_connection) : $query_res;
	} else {
		echo "Query Error :: ".mysqli_error($db_connection)."\n";
		echo "Line :: $line\n";
		echo "QUERY : [$query]\n\n";
		die("Query Error! ERR#_$line");
	}
}

function pr($var) {
	echo "\n";
	print_r($var);
	echo "\n";
}

?>