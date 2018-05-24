<?php

//-------------------------------------------------------------------------------------------------------------------------

$db_ip				= "localhost";
$db_port 			= "";
$db_user 			= "root";
$db_pwd			= "am3-y-4606";
$db_schema		= "";
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

customQuery("SET @user_id = (SELECT id FROM users WHERE username = 'Migration');", __LINE__);
customQuery("SET @date = (SELECT NOW() FROM users WHERE username = 'Migration');", __LINE__);

$query = "select id, notes, qc_nd_email, @user_id as uid, @date as udate from participant_contacts WHERE notes like '%@%' AND deleted <> 1;";
$query_res = customQuery($query, __LINE__);
$update_counter = 0;
while($res =  mysqli_fetch_assoc($query_res)) {
    if(!strlen($res['qc_nd_email'])) {
        if(preg_match('/(([a-z0-9A-z\.\-]+)@(([a-z0-9A-z\.\-]+)))/', $res['notes'], $matches)) {
            $query = "UPDATE participant_contacts SET qc_nd_email = '".str_replace("'", "''", $matches['1'])."', modified = @date, modified_by = @user_id WHERE id = ".$res['id'].";";
            customQuery($query, __LINE__);
            $update_counter++;
        }
    }
    
}
$query = "SELECT count(*) as updated_records FROM participant_contacts WHERE modified = @date AND modified_by = @user_id";
$query_res = customQuery($query, __LINE__);
$res = mysqli_fetch_assoc($query_res);
$updated_records = $res['updated_records'];
if($updated_records != $update_counter) die('ERR232387238');

$query = "SELECT count(*) as contact_records FROM participant_contacts WHERE deleted <> 1";
$query_res = customQuery($query, __LINE__);
$res = mysqli_fetch_assoc($query_res);
$contact_records = $res['contact_records'];

pr("UPDATED $updated_records / $contact_records contacts with email");

$query = "INSERT INTO participant_contacts_revs (id, contact_name, contact_type, other_contact_type, effective_date, effective_date_accuracy, expiry_date, expiry_date_accuracy, notes, street, locality, region, country, mail_code, 
    phone, phone_type, phone_secondary, phone_secondary_type, relationship, participant_id, confidential, qc_nd_email, modified_by, version_created)
    (SELECT id, contact_name, contact_type, other_contact_type, effective_date, effective_date_accuracy, expiry_date, expiry_date_accuracy, notes, street, locality, region, country, mail_code,
    phone, phone_type, phone_secondary, phone_secondary_type, relationship, participant_id, confidential, qc_nd_email, modified_by, modified FROM participant_contacts WHERE modified = @date AND modified_by = @user_id);";
customQuery($query, __LINE__);

mysqli_commit($db_connection);

//-------------------------------------------------------------------------------------------------------------------------

function customQuery($query, $line, $insert = false) {
	global $db_connection;
	pr($query);
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