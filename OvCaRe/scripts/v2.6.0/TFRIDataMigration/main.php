<?php

require_once 'profile.php';
require_once 'diagnosis.php';

set_time_limit('3600');

//-- EXCEL FILE ---------------------------------------------------------------------------------------------------------------------------

require_once 'Excel/reader.php';
$file_name = "Formated-all TFRI cases.xls";
$file_path = isset($_GET['file_path'])? $_GET['file_path'] : "C:\_Perso\Server\ovcare\data";
$file_path .= (preg_match('/\//', $file_path)? '/': '\\').$file_name;
//TODO test file path in arg on unbuntu
$tmp_xls_reader = new Spreadsheet_Excel_Reader();
$tmp_xls_reader->read($file_path);
$sheets_keys = array();
foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_keys[$tmp['name']] = $key;

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "localhost";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "ovcare";
$db_charset		= "utf8";

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(empty($db_port)? '' : ":").$db_port,
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed");
mysqli_autocommit($db_connection, false);

//-- GLOBAL VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------

global $modified_by;
$modified_by = '9';

global $modified;
$query = "SELECT NOW() as modified FROM study_summaries;";
$modified_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}

global $summary_msg;
$summary_msg = array();

global $voas_to_participant_id;
$voas_to_participant_id = array();

//===========================================================================================================================================================
//===========================================================================================================================================================

echo "<br><FONT COLOR=\"green\" >
=====================================================================<br>
OVCARE TFRI DATA EXPORT PROCESS<br>
source_file = $file_name<br>
<br>=====================================================================</FONT><br><br>";

// **** START ********************************************************

$atim_controls = loadATiMControlData();
setVoaToParticipantIds($atim_controls);

// **** EXCEL DATA EXTRACTION ****************************************

list($all_studied_voas, $participants_last_contact, $participant_id_to_skip) = updateProfile($tmp_xls_reader->sheets, $sheets_keys, 'Patients', $atim_controls);
updateOvaryEndometriumDiagnosis($tmp_xls_reader->sheets, $sheets_keys, 'EOC - Diagnosis', 'EOC-  Event', $atim_controls, $all_studied_voas, $participant_id_to_skip);






//TODO Date of Last Contact
pr($participants_last_contact);

exit;

$voa_to_patient_id = checkVoaNbrAndPatientId($tmp_xls_reader->sheets[$sheets_keys['Patient Id To Voa Corrections']]['cells'], $tmp_xls_reader->sheets[$sheets_keys['Subject Demographics']]['cells']);
$clinical_outcome_data = loadClinicalOutcomeData($tmp_xls_reader->sheets[$sheets_keys['Clinical Outcome']]['cells'], 'Clinical Outcome', $voa_to_patient_id);
$voas_to_collection_data = loadAndRecordClinicalData($tmp_xls_reader->sheets, $sheets_keys, $voa_to_patient_id, $clinical_outcome_data, $atim_controls);

//Load Inventory

$voas_to_collection_ids = recordCollection($voas_to_collection_data);
loadSamplesAndAliquots($tmp_xls_reader->sheets, $sheets_keys, $voas_to_collection_ids, $atim_controls);

// **** END **********************************************************

// Migration Done

// COLLECTIONS COMPLETION

$queries = array();
foreach($queries as $query)  mysqli_query($db_connection, $query) or die("Error [$query] ");

// Empty date clean up 

$date_times_to_check = array(
	'consent_masters.consent_signed_date',
	'event_masters.event_date',
	'treatment_masters.start_date',
	'treatment_masters.finish_date',
	'collections.collection_datetime',
	'specimen_details.reception_datetime',
	'derivative_details.creation_datetime',
	'aliquot_masters.storage_datetime'			
);
foreach($date_times_to_check as $table_field) {
	$names = explode(".", $table_field);
	$query = "UPDATE ".$names[0]." SET ".$names[1]." = null,".$names[1]."_accuracy = null WHERE ".$names[1]." LIKE '0000-00-00%'";
	mysqli_query($db_connection, $query) or die("Error [$query] ");
	$query = "UPDATE ".$names[0]."_revs SET ".$names[1]." = null,".$names[1]."_accuracy = null WHERE ".$names[1]." LIKE '0000-00-00%'";
	mysqli_query($db_connection, $query) or die("Error [$query] ");
}

$query = "UPDATE participants SET last_modification = null WHERE last_modification LIKE '0000-00-00%'";
mysqli_query($db_connection, $query) or die("Error [$query] ");
mysqli_query($db_connection, str_replace('participants', 'participants_revs', $query)) or die("Error [$query] ");

$query = "UPDATE versions SET permissions_regenerated = 0;";
mysqli_query($db_connection, $query) or die("Error [$query] ");

$ccl = 'but not committed!';
if(dislayErrorAndMessage()) {
//TODO	mysqli_commit($db_connection);
	$ccl = 'and committed!';
}

echo "<br><FONT COLOR=\"green\" >
=====================================================================<br>
Migration Process done $ccl<br>
<br>=====================================================================</FONT><br><br>";

//===========================================================================================================================================================
// START functions
//===========================================================================================================================================================

function loadATiMControlData(){
	global $db_connection;
	$controls = array();
	// MiscIdentifier
	$query = "select id, misc_identifier_name, flag_unique FROM misc_identifier_controls WHERE flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['misc_identifier_controls'][$row['misc_identifier_name']] = array('id' => $row['id'], 'flag_unique' => $row['flag_unique']);
	}
	//dx
	$query = "SELECT id, category, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die("Dx Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		$controls['diagnosis_control_ids'][$row['category']][$row['controls_type']] = array('id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	//event
	$query = "select id,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['event_controls'][$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	//trt
	$query = "select tc.id, tc.tx_method, tc.detail_tablename, te.id as te_id, te.detail_tablename as te_detail_tablename
		from treatment_controls tc
		LEFT JOIN treatment_extend_controls te ON tc.treatment_extend_control_id = te.id AND te.flag_active = '1'
		where tc.flag_active = '1';";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['treatment_controls'][$row['tx_method']] = array(
			'treatment_control_id' => $row['id'], 
			'detail_tablename' => $row['detail_tablename'],
       		'te_treatment_control_id' => $row['te_id'],
			'te_detail_tablename' => $row['te_detail_tablename'],
		);
	}
	return $controls;
}

function setVoaToParticipantIds($atim_controls){
	global $db_connection;
	global $voas_to_participant_id;
	$voas_to_participant_id = array();
	//1
	$query = "SELECT participant_id, collection_voa_nbr FROM collections;";
	$results = mysqli_query($db_connection, $query) or die("Main [line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		if(isset($voas_to_participant_id[$row['collection_voa_nbr']])) {
			if($voas_to_participant_id[$row['collection_voa_nbr']] != $row['participant_id']) {
				$summary_msg['VOA to Participant ID']['@@ERROR@@']["Voa linked to more than one participant"][] = "See V0A# ".$row['collection_voa_nbr']." Linke to ATiM participant id :".$voas_to_participant_id[$row['collection_voa_nbr']]." and ".$row['participant_id'];
			}
		} else {
			$voas_to_participant_id[$row['collection_voa_nbr']] = $row['participant_id'];
		}
	}
	//2
	$query = "SELECT participant_id, identifier_value FROM misc_identifiers WHERE misc_identifier_control_id = ".$atim_controls['misc_identifier_controls']['unassigned VOA#']['id'].";";
	$results = mysqli_query($db_connection, $query) or die("Main [line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		if(isset($voas_to_participant_id[$row['identifier_value']])) {
			if($voas_to_participant_id[$row['identifier_value']] != $row['participant_id']) {
				$summary_msg['VOA to Participant ID']['@@ERROR@@']["Voa linked to more than one participant"][] = "See V0A# ".$row['identifier_value']." Linke to ATiM participant id :".$voas_to_participant_id[$row['identifier_value']]." and ".$row['participant_id'];
			}
		} else {
			$voas_to_participant_id[$row['identifier_value']] = $row['participant_id'];
		}
	}
}

//===========================================================================================================================================================
// End functions
//===========================================================================================================================================================

//===========================================================================================================================================================
// Other functions
//===========================================================================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function customInsertRecord($data_arr, $table_name, $is_detail_table = false) {
	global $db_connection;
	global $modified_by;
	global $modified;
	
	$tmp_set_id_for_check = array_key_exists('id', $data_arr)? $data_arr['id'] : null;
	
	$created = $is_detail_table? array() : array(
		"created"		=> "'$modified'", 
		"created_by"	=> $modified_by, 
		"modified"		=> "'$modified'",
		"modified_by"	=> $modified_by
	);
	
	$data_to_insert = array();
	foreach($data_arr as $key => $value) {
		if(strlen($value)) {
			$data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
		}
	}
	
	$insert_arr = array_merge($data_to_insert, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	$record_id = mysqli_insert_id($db_connection);
	$additional_fields = $is_detail_table? array('version_created' => "NOW()") : array('id' => "$record_id", 'version_created' => "NOW()");
	$rev_insert_arr = array_merge($data_to_insert, $additional_fields);
	$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
	mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	if(!is_null($tmp_set_id_for_check) && $tmp_set_id_for_check != $record_id) die('ERR 2332872872');//Not really usefull
	
	return $record_id;	
}

function getDateAndAccuracy($data_type, $data, $worksheet, $field, $accuracy_field, $line) {
	global $summary_msg;
	$result = null;
	if(!array_key_exists($field, $data)) {
		pr("getDateAndAccuracy: Missing field [$field]");
		pr($data);
		die('ERR36100833');
	}
	$date = $data[$field];
	if(empty($date) || (strtoupper($date) == 'N/A')) {
		return null;
	} else if(preg_match('/^([0-9]+)$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date - $xls_offset) * 86400));
		$result = array('date' => $date, 'accuracy' => 'c');	
	} else if(preg_match('/^(19|20)([0-9]{2})\-((0[1-9])|(1[0-2]))\-((0[1-9])|([12][0-9])|(3[0-1]))$/',$date,$matches)) {
		$result = array('date' => $date, 'accuracy' => 'c');
	} else if(preg_match('/^(19|20)([0-9]{2})\-((0[1-9])|(1[0-2]))$/',$date,$matches)) {
		$result = array('date' => $date.'-01', 'accuracy' => 'd');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		$result = array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^((0[1-9])|([12][0-9])|(3[0-1]))[\/\-]((0[1-9])|(1[0-2]))[\/\-](19|20)([0-9]{2})$/',$date,$matches)) {
		$result = array('date' => $matches[8].$matches[9].'-'.$matches[5].'-'.$matches[1], 'accuracy' => 'c');
	} else {
		$summary_msg[$data_type]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [worksheet $worksheet - field '$field' - line: $line]";
		return null;
	}
	if($data[$accuracy_field] && in_array($data[$accuracy_field], array('m','d'))) $result['accuracy'] = str_replace(array('y','m'), array('m','d'), $data[$accuracy_field]);
	return $result;
}

function customArrayCombineAndUtf8Encode($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[utf8_encode($field)] = utf8_encode($data[$key]);
		} else {
			$line_data[utf8_encode($field)] = '';
		}
	}
	return $line_data;
}

function displayErrorAndMessage() {
	global $summary_msg;
	
	$creation_summary = $summary_msg['Data Creation/Update Summary'];
	unset($summary_msg['Data Creation/Update Summary']);
	
	$commit = true;
	foreach($summary_msg as $data_type => $msg_arr) {

		echo "<br><br><FONT COLOR=\"blue\" >
		=====================================================================<br><br>
		PROCESS SUMMARY: $data_type
		<br><br>=====================================================================
		</FONT><br>";
			
		if(!empty($msg_arr['@@ERROR@@'])) {
			echo "<br><FONT COLOR=\"red\" ><b> ** Errors summary ** </b> </FONT><br>";
			foreach($msg_arr['@@ERROR@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"red\" >". utf8_decode($type) . "</FONT><br>";
				$counter = 0;
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
				$commit = false;
			}
		}
		unset($msg_arr['@@ERROR@@']);

		if(!empty($msg_arr['@@WARNING@@'])) {
			echo "<br><FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> </FONT><br>";
			foreach($msg_arr['@@WARNING@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"orange\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
			}
		}
		unset($msg_arr['@@WARNING@@']);

		if(!empty($msg_arr['@@MESSAGE@@'])) {
			echo "<br><FONT COLOR=\"green\" ><b> ** Message ** </b> </FONT><br>";
			foreach($msg_arr['@@MESSAGE@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
			}
		}
		unset($msg_arr['@@MESSAGE@@']);
		
		if(!empty($msg_arr)) {
			pr($msg_arr);die('ERR327327732');
		}
	}
	
	echo "<br><br><FONT COLOR=\"blue\" >
	=====================================================================<br><br>
	PROCESS SUMMARY: DATA CREATION and UPDATE
	<br><br>=====================================================================
	</FONT><br>";
	echo "<i>";
	foreach($creation_summary as $participant_id => $data) {
		echo "<br><FONT COLOR=\"orange\" ><b> ATiM Patient Id $participant_id </b> </FONT><br>";
		foreach($data as $type => $msgs) {
			echo " --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT><br>";
			foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
		}
	}
	echo "</i>";
	return $commit;
}

?> 