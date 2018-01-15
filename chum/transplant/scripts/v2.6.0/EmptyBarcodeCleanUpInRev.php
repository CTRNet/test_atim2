<?php  

$db_ip				= "localhost";
$db_port 			= "";
$db_user 			= "root";
$db_pwd				= "";
$db_schema	= "icm";
$db_charset			= "utf8";

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or importDie("DB connection: Could not connect to MySQL [".$db_ip.(!empty($db_port)? ":".$db_port : '')." / $db_user]", false);
if(!mysqli_set_charset($db_connection, $db_charset)){
	importDie("DB connection: Invalid charset", false);
}
@mysqli_select_db($db_connection, $db_schema) or importDie("DB connection: DB selection failed [$icm_db_schema]", false);
mysqli_autocommit ($db_connection , false);

$query = "SELECT DISTINCT id FROM aliquot_masters_revs WHERE barcode like '';";
$empty_barcode_ids = array('-1');
$query_res = customQuery($query, __LINE__);
while($res =  mysqli_fetch_assoc($query_res)) {
	$empty_barcode_ids[] = $res['id'];
}

pr('1-- Number of aliquots revs records with empty barcode = '.(sizeof($empty_barcode_ids)-1));

$query = "SELECT * FROM  aliquot_masters_revs WHERE id IN (".implode(',', $empty_barcode_ids).") ORDER BY id, version_created ASC;";
$studied_aliquot_master_id = null;
$all_revs_records_of_the_same_aliquot = array();
$aliquot_master_revs_version_ids_to_delete = array();
$aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update = array();
$query_res = customQuery($query, __LINE__);
while($res =  mysqli_fetch_assoc($query_res)) {
	if($studied_aliquot_master_id && $studied_aliquot_master_id != $res['id']) {
		parseRevsRecords($all_revs_records_of_the_same_aliquot, $aliquot_master_revs_version_ids_to_delete, $aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update);
		$all_revs_records_of_the_same_aliquot = array();
	}
	$studied_aliquot_master_id = $res['id'];
	$all_revs_records_of_the_same_aliquot[] = $res;
}
parseRevsRecords($all_revs_records_of_the_same_aliquot, $aliquot_master_revs_version_ids_to_delete, $aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update);

pr('2-- Number of aliquots revs records linked to an empty barcode revs record and that has to be updated (version created updated) = '.sizeof($aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update));

if(!empty($aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update)) {
	$query = "UPDATE aliquot_masters_revs am_0, aliquot_masters_revs am_1
		SET am_1.version_created = am_0.version_created
		WHERE am_0.barcode LIKE ''
		AND am_1.barcode NOT LIKE ''
		AND am_0.id = am_1.id
		AND am_0.version_id IN (".implode(',',array_keys($aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update)).")
		AND am_1.version_id IN (".implode(',',$aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update).");";
	customQuery($query, __LINE__);
}

pr('3-- Number of aliquots revs records with empty barcode that will be deleted = '.sizeof($aliquot_master_revs_version_ids_to_delete));

if(!empty($aliquot_master_revs_version_ids_to_delete)) {
	$query = "DELETE FROM aliquot_masters_revs WHERE version_id IN (".implode(',',$aliquot_master_revs_version_ids_to_delete).") AND barcode LIKE '';";
	customQuery($query, __LINE__);
}

$query = "SELECT count(*) as updated_barcode_nbr FROM aliquot_masters_revs WHERE barcode LIKE '';";
$query_res = customQuery($query, __LINE__);
$res =  mysqli_fetch_assoc($query_res);

pr('4-- Number of aliquots revs records with empty barcode that will be updated by the script (empty barcode updated) = '.$res['updated_barcode_nbr']);

$query = "UPDATE aliquot_masters_revs SET barcode = id WHERE barcode LIKE '';";
$query_res = customQuery($query, __LINE__);

mysqli_commit($db_connection);

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

function parseRevsRecords($all_revs_records_of_the_same_aliquot, &$aliquot_master_revs_version_ids_to_delete, &$aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update) {
	if(sizeof($all_revs_records_of_the_same_aliquot) > 1) {
		if(empty($all_revs_records_of_the_same_aliquot[0]['barcode']) && !empty($all_revs_records_of_the_same_aliquot[1]['barcode'])) {
			$to_delete = true;
			$update_version_created = false;
			foreach(array_diff_assoc($all_revs_records_of_the_same_aliquot[0], $all_revs_records_of_the_same_aliquot[1]) as $field => $value) {
				if(!in_array($field, array('barcode','version_id','version_created'))) {
					//Other fields values are different: No revs record to delete because differences exist. Barcode of the first revs record will be updated.
					$to_delete = false;
				} else if($field == 'version_created') {
					if(sizeof($all_revs_records_of_the_same_aliquot) == 2) {
						//2 revs records with different version_created: To keep to match created and modified values of the main record. Barcode of the first revs record will be updated.
						$to_delete = false;
					} else {
						//More than 3 records in revs, we can delete the first one and keep the version created of this one to update the value of the second one that will match the created value of the main record.
						$update_version_created = true;
					}
				}
			}
			if($to_delete) {
				$aliquot_master_revs_version_ids_to_delete[] = $all_revs_records_of_the_same_aliquot[0]['version_id'];
				if($update_version_created) {
					$aliquot_master_revs_version_ids_to_delete_and_version_ids_to_update[$all_revs_records_of_the_same_aliquot[0]['version_id']] = $all_revs_records_of_the_same_aliquot[1]['version_id'];
				}
			}
		}
	} else {
		//Just one record in revs (with empty barcode): No revs record deletion. Barcode of the first revs record will be updated.
	}
}

?>