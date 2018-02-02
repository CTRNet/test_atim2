<?php


//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "";
$db_charset		= "utf8";

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_connection;

$db_connection = @mysqli_connect(
		$db_ip,
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed");
mysqli_autocommit($db_connection, true);

$queries_to_update = array();

//--------------------------------------------------------------------------------------------------------------------------------------------

global $modified_by;

$modified_by = '2';

global $modified;

$query = "SELECT NOW() as modified;";
$modified_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}


$query = "SELECT * FROM misc_identifier_controls WHERE flag_active = 1;";
$res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$ramqControl_id = null;
$stlucControl_id = null;
$cerControl_id = null;
while($new_record = mysqli_fetch_assoc($res)) {
    switch($new_record['misc_identifier_name']) {
        case 'CER#':
            $cerControl_id = $new_record['id'];
            break;
        case 'saint_luc_hospital_nbr':
            $stlucControl_id = $new_record['id'];
            break;
        case 'health_insurance_card':
            $ramqControl_id = $new_record['id'];
            break;
    }
    
}
if(!$ramqControl_id || !$stlucControl_id || !$cerControl_id) die('ERR232323');

$ivadoData = getIvadoData();
if(implode('/',$ivadoData[0])!= "Bank Nbr/ID IMAGIA/CHUM St-Luc Hospital Number/RAMQ") die('ERR74848494');
unset($ivadoData[0]);
foreach($ivadoData as $newIvadoRecode) {
    list($participant_identifier, $imagiaNbr, $stlucNbr, $ramq) = $newIvadoRecode;
    $query = "
        SELECT Participant.id AS participant_id, Ramq.identifier_value as ramq, StLuc.identifier_value st_luc_nbr
        FROM participants Participant 
        LEFT JOIN misc_identifiers Ramq ON Ramq.participant_id = Participant.id AND Ramq.deleted <> 1 AND Ramq.misc_identifier_control_id = $ramqControl_id
        LEFT JOIN misc_identifiers StLuc ON StLuc.participant_id = Participant.id AND StLuc.deleted <> 1 AND StLuc.misc_identifier_control_id = $stlucControl_id
        WHERE Participant.deleted <> 1 
        AND Participant.participant_identifier = '$participant_identifier';";
    $res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
    if($res->num_rows == 0) {
        pr("WARNING#1: $participant_identifier, $imagiaNbr, $stlucNbr, $ramq");
    } elseif($res->num_rows > 1) {
        pr("WARNING#2: $participant_identifier, $imagiaNbr, $stlucNbr, $ramq");
    } else {
        $new_participant = mysqli_fetch_assoc($res);
        $participant_id = $new_participant['participant_id'];
        $diff = array();
        $new_participant['ramq'] = trim($new_participant['ramq']);
        $new_participant['st_luc_nbr'] = trim($new_participant['st_luc_nbr']);
        $ramq = trim($ramq);
        $stlucNbr = trim($stlucNbr);
        if(!strlen($ramq) || $new_participant['ramq'] != $ramq) {
            $diff[] = "RAMQ (excel/atim): [$ramq]/[".$new_participant['ramq']."]";
        }
        if(!strlen($stlucNbr) || $new_participant['st_luc_nbr'] != $stlucNbr) {
            $diff[] = "StLuc (excel/atim): [$stlucNbr]/[".$new_participant['st_luc_nbr']."]";
        }
        if(sizeof($diff) > 1) {
            pr("WARNING#3: $participant_identifier, $imagiaNbr, $stlucNbr, $ramq");
            pr($diff);
            $participant_id = null;
        } else if(sizeof($diff) == 1) {
            pr("MESSAGE#1: One of the 2 identifiers is different for participant bank nbr $participant_identifier: ".$diff[0]);
        }
        if($participant_id) {
            $ivadoNbr = $imagiaNbr;
            if(strlen($imagiaNbr)) {
                if(!preg_match('/^[0-9]+$/', $imagiaNbr)) die('ERR232323');
                customInsertRecord(array('identifier_value' => "IMAGIA#$imagiaNbr", 'misc_identifier_control_id' => $cerControl_id, 'participant_id' => $participant_id), 'misc_identifiers');
            } else {
                $ivadoNbr = 'N/D';
            }
            customInsertRecord(array('identifier_value' => "IVADO#$imagiaNbr", 'misc_identifier_control_id' => $cerControl_id, 'participant_id' => $participant_id), 'misc_identifiers');
        }
    }    
}

pr('Done');

//=======================================================================================================================================================================
//=======================================================================================================================================================================

function getIvadoData() {
    return array(
        array("Bank Nbr", "ID IMAGIA", "CHUM St-Luc Hospital Number", "RAMQ"),
        array("1", "15..", "10.....", "MMMM838383"),
        array("...", "...", "...", "..."),
    );
}

//====================================================================================================================================================
//=======================================================================================================================================================================

function customInsertRecord($data_arr, $table_name, $is_detail_table = false/*, $flush_empty_fields = false*/) {
	global $modified_by;
	global $modified;
	global $db_connection;
	
	$created = $is_detail_table? array() : array(
			"created"		=> "'$modified'",
			"created_by"	=> $modified_by,
			"modified"		=> "'$modified'",
			"modified_by"	=> $modified_by
	);

	//if($flush_empty_fields) {
	$data_to_insert = array();
	foreach($data_arr as $key => $value) {
		if(strlen($value)) {
			$data_to_insert[$key] = "'".$value."'";
		}
	}
	//}

	$insert_arr = array_merge($data_to_insert, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));

	$record_id = mysqli_insert_id($db_connection);
	$additional_fields = $is_detail_table? array('version_created' => "'$modified'") : array('id' => "$record_id", 'version_created' => "'$modified'", "modified_by" => $modified_by);
	if(true) {
		$rev_insert_arr = array_merge($data_to_insert, $additional_fields);
		$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
		mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	}

	return $record_id;
}

function pr($var) {
	echo "\n";
	print_r($var);
	echo "\n";
}	

?>