<?php

set_time_limit('3600');

//-- Initiate config file variables ------------------------------------------------------------------------------------------------------------------------------------------------

global $merge_process_version;
$merge_process_version = 'v0.1';

//-- DB PARAMETERS -----------------------------------------------------------------------------------------------------------------------------------------------------------------

global $db_ip;
global $db_port;
global $db_user;
global $db_pwd;
global $db_charset;
$db_ip		= 	"localhost";
$db_port	= 	"";
$db_user	= 	"root";
$db_pwd		= 	"";
$db_charset	= "utf8";

global $db_central_schemas;
$db_central_schemas	= "";

$db_chum_schemas = "";
$db_chuq_schemas = "";
$db_chus_schemas = "";
$db_cusm_schemas = "";
$db_processing_schemas = "";

global $db_connection;
$db_connection = null;

//-- Migration id and date ---------------------------------------------------------------------------------------------------------------------------------------------------------

global $merge_user_id;
$merge_user_id = 1;

global $import_date;
$import_date = null;

global $imported_by;
$imported_by = null;

//-- Other Varaiables --------------------------------------------------------------------------------------------------------------------------------------------------------------

global $import_summary;
$import_summary = array();

global $executed_queries;
$executed_queries = array();

global $track_queries;
$track_queries = false;

//==================================================================================================================================================================================
// DATABSE CONNECTION
//==================================================================================================================================================================================

function connectToCentralDatabase() {
	global $db_ip;
	global $db_port;
	global $db_user;
	global $db_pwd;
	global $db_charset;
	global $db_connection;
	global $db_central_schemas;
	
	$db_connection = @mysqli_connect(
			$db_ip.(!empty($db_port)? ":".$db_port : ''),
			$db_user,
			$db_pwd
	) or die("ERR_DATABASE_CONNECTION: Could not connect to MySQL");
	if(!mysqli_set_charset($db_connection, $db_charset)) die("ERR_DATABASE_CONNECTION: Invalid charset");
	selectCentralDatabase();
	
	// Set merge date and user id
	
	global $merge_user_id;
	global $import_date;
	global $imported_by;
	
	$query_result = getSelectQueryResult("SELECT NOW() AS import_date, id FROM users WHERE id = '$merge_user_id';");
	if(empty($query_result)) {
		mergeDie("ERR_DATABASE_CONNECTION: merge user id '$merge_user_id' does not exist into $db_schema");
	}
	$import_date = $query_result[0]['import_date'];
	$imported_by = $query_result[0]['id'];
}

function testDbSchemas($db_schema, $site) {
	global $db_connection;
	global $db_sites_schemas;
	
	if($db_schema) {
		if(!@mysqli_select_db($db_connection, $db_schema)) {
			recordErrorAndMessage('ATiM Database Check', '@@ERROR@@', "Wrong DB schema", "Unable to connect to the schema $db_schema defined for site $site. No data will be imported.");
			return false;
		} else {
			$atim_dump_data = getSelectQueryResult('SELECT created FROM atim_procure_dump_information LIMIT 0 ,1');
			if($atim_dump_data) {
				$atim_dump_data['0']['created'];
				recordErrorAndMessage('Merge Information', '@@MESSAGE@@', "Site Dump Information", "Use of database dump of '$site' created on '".$atim_dump_data['0']['created'].".");
				return true;
			} else {
				recordErrorAndMessage('ATiM Database Check', '@@ERROR@@', "Missing atim_procure_dump_information Table Data", "See data of site '$site'. No data will be imported.");
				return false;
			}
		}
	} else {
		recordErrorAndMessage('ATiM Database Check', '@@WARNING@@', "No DB schema defined", "No schema defined for site '$site'. No data will be imported.");
		return false;
	}
	return false;
}

function selectCentralDatabase() {
	global $db_connection;
	global $db_central_schemas;
	@mysqli_select_db($db_connection, $db_central_schemas) or die("ERR_CENTRAL_SCHEMA: Unable to use central database : $db_central_schemas");
	mysqli_autocommit ($db_connection , false);	
}

//==================================================================================================================================================================================
// ATiM CONTROLS DATA
//==================================================================================================================================================================================

// Controls

function getControls($db_schema) {
	$atim_controls = array();
	
	//*** Control : sample_controls ***
	$atim_controls['sample_controls'] = array();
	$query_result = getSelectQueryResult("SELECT parent_sample_control_id, derivative_sample_control_id FROM $db_schema.parent_to_derivative_sample_controls WHERE flag_active = 1");
	foreach($query_result as $unit){
		$key = $unit["parent_sample_control_id"];
		$value = $unit["derivative_sample_control_id"];
		if(!isset($relations[$key])){
			$relations[$key] = array();
		}
		$relations[$key][] = $value;
	}
	$active_sample_control_ids = getActiveSampleControlIds($relations, "");
	$ids_to_types = array();
	foreach(getSelectQueryResult("SELECT id, sample_type, sample_category, detail_tablename FROM $db_schema.sample_controls WHERE id IN (".implode(',', $active_sample_control_ids).")") as $new_sample_control) {
		$atim_controls['sample_controls'][$new_sample_control['sample_type']] = $new_sample_control;
		$ids_to_types[$new_sample_control['id']] = $new_sample_control['sample_type'];
	}
	$atim_controls['sample_controls']['***id_to_type***'] = $ids_to_types;
	
	//*** Control : aliquot_controls ***
	$atim_controls['aliquot_controls'] = array();
	$query = "SELECT ac.id, sample_type, aliquot_type, ac.detail_tablename, volume_unit 
		FROM $db_schema.aliquot_controls ac INNER JOIN $db_schema.sample_controls sc ON sc.id = ac.sample_control_id 
		WHERE ac.flag_active = '1' AND ac.sample_control_id IN (".implode(',', $active_sample_control_ids).")";
	foreach(getSelectQueryResult($query) as $new_aliquot_control) $atim_controls['aliquot_controls'][$new_aliquot_control['sample_type'].'-'.$new_aliquot_control['aliquot_type']] = $new_aliquot_control;
	//*** Control : consent_controls ***
	$atim_controls['consent_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, controls_type, detail_tablename FROM $db_schema.consent_controls WHERE flag_active = 1") as $new_control) $atim_controls['consent_controls'][$new_control['controls_type']] = $new_control;
	//*** Control : event_controls ***
	$atim_controls['event_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, disease_site, event_type, detail_tablename FROM $db_schema.event_controls WHERE flag_active = 1") as $new_control) $atim_controls['event_controls'][(strlen($new_control['disease_site'])? $new_control['disease_site'].'-': '').$new_control['event_type']] = $new_control;
	//*** Control : misc_identifier_controls ***
	$atim_controls['misc_identifier_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, misc_identifier_name, flag_active, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_unique FROM $db_schema.misc_identifier_controls WHERE flag_active = 1") as $new_control) $atim_controls['misc_identifier_controls'][$new_control['misc_identifier_name']] = $new_control;
	//*** Control : storage_controls ***
	$atim_controls['storage_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, storage_type, coord_x_title, coord_x_type, coord_x_size, coord_y_title, coord_y_type, coord_y_size, display_x_size, display_y_size , set_temperature, is_tma_block, detail_tablename FROM $db_schema.storage_controls WHERE flag_active = 1") as $new_control) $atim_controls['storage_controls'][$new_control['storage_type']] = $new_control;
	//*** Control : treatment_controls ***
	$atim_controls['treatment_controls'] = array();
	$query  = "SELECT tc.id, disease_site, tx_method, tc.detail_tablename, applied_protocol_control_id, tec.id AS treatment_extend_control_id, tec.detail_tablename AS treatment_extend_detail_tablename
		FROM $db_schema.treatment_controls tc LEFT JOIN $db_schema.treatment_extend_controls tec ON tc.treatment_extend_control_id = tec.id AND tec.flag_active = 1
		WHERE tc.flag_active = 1";
	foreach(getSelectQueryResult($query) as $new_control) $atim_controls['treatment_controls'][(strlen($new_control['disease_site'])?$new_control['disease_site'].'-':'').$new_control['tx_method']] = $new_control;
	//*** Control : specimen_review_controls ***
	$atim_controls['specimen_review_controls'] = array();
	$query  = "SELECT src.id, src.review_type, sample_control_id, src.detail_tablename, arc.id AS aliquot_review_control_id, arc.review_type AS aliquot_review_type, arc.detail_tablename AS aliquot_review_detail_tablename, aliquot_type_restriction
		FROM $db_schema.specimen_review_controls src LEFT JOIN $db_schema.aliquot_review_controls arc ON src.aliquot_review_control_id = arc.id AND arc.flag_active = 1
		WHERE src.flag_active = 1";
	foreach(getSelectQueryResult($query) as $new_control) $atim_controls['specimen_review_controls'][$new_control['review_type']] = $new_control;
	ksort($atim_controls);
	
	return $atim_controls;
}

function getActiveSampleControlIds($relations, $current_check){
	$active_ids = array('-1');	//If no sample
	if(array_key_exists($current_check, $relations)) {
		foreach($relations[$current_check] as $sample_id){
			if($current_check != $sample_id && $sample_id != 'already_parsed'){
				$active_ids[] = $sample_id;
				if(isset($relations[$sample_id]) && !in_array('already_parsed', $relations[$sample_id])){
					$relations[$sample_id][] = 'already_parsed';
					$active_ids = array_merge($active_ids, getActiveSampleControlIds($relations, $sample_id));
				}
			}
		}
	}
	return array_unique($active_ids);
}

//==================================================================================================================================================================================
// SYSTEM FUNCTION
//==================================================================================================================================================================================

function mergeDie($error_messages) {
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

// ---- TITLE, ERROR AND MESSAGE DISPLAY  ------------------------------------------------------------------------------------------------------------------------------------------

/**
 * Display the title of the merge (html format).
 * 
 * @param string $title Title of the merge process
 */
function displayMergeTitle($title) {
	global $import_date;
	global $merge_process_version;
	global $excel_files_paths;
	echo "<br><FONT COLOR=\"blue\">=====================================================================<br>
		<b><FONT COLOR=\"blue\">$title</b></FONT><br>
		<b><FONT COLOR=\"blue\">Version : </FONT>$merge_process_version</b><br>
		<b><FONT COLOR=\"blue\">Date : </FONT>$import_date</b><br>
		<FONT COLOR=\"blue\">=====================================================================</FONT><br>";
}

/**
 * Record an error or message that could be dispalyed in html format using function dislayErrorAndMessage().
 * The format of the display will be similar than the example below
 * 
 * =====================================================================
 * $summary_section_title
 * =====================================================================
 * 
 * $summary_title
 * - $summary_details 1
 * - $summary_details 2
 * - $summary_details 3
 * - $summary_details ...
 * 
 * @param string $summary_section_title Title of a section gathering error or message linked to the same task, data type, etc.
 * @param string $summary_type @@ERROR@@ or @@WARNING@@ or @@MESSAGE@@
 * @param string $summary_title Error type
 * @param string $summary_details Details of the error (to inlude excel line number or a patient identifier, etc)
 * @param string $message_detail_key Key to not duplicate summary details for a same error.
 */
function recordErrorAndMessage($summary_section_title, $summary_type, $summary_title, $summary_details, $message_detail_key = null) {
	global $import_summary;
	if(is_null($message_detail_key)) {
		$import_summary[$summary_section_title][$summary_type][$summary_title][] = $summary_details;
	} else {
		$import_summary[$summary_section_title][$summary_type][$summary_title][$message_detail_key] = $summary_details;
	}
}

/**
 * Display any errors or messages recorded by function recordErrorAndMessage() in html forma.
 * 
 * @param boolean $commit Commit all sql statements.
 */
function dislayErrorAndMessage($commit = false) {
	global $import_summary;
	global $db_connection;
	global $track_queries;
	
	if($track_queries) addQueryToMessages();
	
	echo "<br><FONT COLOR=\"blue\">
		=====================================================================<br>
		<b>Merge Summary</b><br>
		=====================================================================</FONT><br>";
	$err_counter = 0;
	foreach($import_summary as $summary_section_title => $data1) {
		echo "<br><br><FONT COLOR=\"0066FF\" >
		=====================================================================<br>
		$summary_section_title<br>
		=====================================================================</FONT><br>";
		foreach($data1 as $message_type => $data2) {
			$color = 'black';
			$code = 'ER';
			switch($message_type) {
				case '@@ERROR@@':
					$color = 'red';
					$code = 'ER';
					break;
				case '@@WARNING@@':
					$color = 'orange';
					$code = 'WAR';
					break;
				case '@@MESSAGE@@':
					$color = 'green';
					$code = 'MSG';
					break;
				default:
					echo '<br><br><br>UNSUPORTED message_type : '.$message_type.'<br><br><br>';
			}
			foreach($data2 as $error => $details) {
				$err_counter++;
				$error = str_replace("\n", ' ', utf8_decode("[$code#$err_counter] $error"));
				echo "<br><br><FONT COLOR=\"$color\" ><b>$error</b></FONT><br>";
				foreach($details as $detail) {
					$detail = str_replace("\n", ' ', $detail);
					echo ' - '.utf8_decode($detail)."<br>";
				}
			}
		}
	}
	if($commit) {
		$query = "UPDATE versions SET permissions_regenerated = 0;";
		customQuery($query);
		mysqli_commit($db_connection);
		$ccl = '& Commited';
	} else {
		$ccl = 'But Not Commited';
	}
	echo "<br><FONT COLOR=\"blue\">
		=====================================================================<br>
		<b>Merge Done $ccl</b><br>
		=====================================================================</FONT><br>";
}

// ---- QUERY FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------------------

/**
 * Exeute an sql statement.
 * 
 * @param string $query SQL statement
 * @param boolean $insert True for any $query being an INSERT statement
 * 
 * @return multitype Id of the insert when $insert set to TRUE else the mysqli_result object
 */
function customQuery($query, $insert = false) {
	global $db_connection;
	global $executed_queries;
	global $track_queries;
	
	if($track_queries) $executed_queries[] = $query;
	$query_res = mysqli_query($db_connection, $query) or mergeDie(array("ERR_QUERY", mysqli_error($db_connection), $query));
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}

function addQueryToMessages() {
	global $executed_queries;
	
	foreach($executed_queries as $query) {
		recordErrorAndMessage('Executed Queries', '@@MESSAGE@@', "List of queries", $query);
	}
}

/**
 * Execute an sql SELECT statement and return results into an array.
 *
 * @param string $query SQL statement
 *
 * @return array Query results in an array
 */
function getSelectQueryResult($query) {
	if(!preg_match('/^[\ ]*((SELECT)|(SHOW))/i', $query))  mergeDie(array("ERR_QUERY", "'SELECT' query expected", $query));
	$select_result = array();
	$query_result = customQuery($query);
	while($row = $query_result->fetch_assoc()) {
		$select_result[] = $row;
	}
	return $select_result;
}

/**
 * Record new data into ATiM table.
 * 
 * Submitted data format:
 * 
 * 1- Simple Table
 * 
 * array(table_name => array(field1 => value, field2 => value, etc)
 * 
 * array('participants' => array('first_name' => 'James', 'last_name' => 'Bond))
 * 
 * 2- Master/Detail Tables
 * 
 * array(master_table_name => array(master_control_id => value, field1 => value, field2 => value, etc)
 * 		detail_table_name => array(field1 => value, field2 => value, etc))
 * 
 * array('aliquot_masters' => array(aliquot_control_id => 12, field1 => value, field2 => value, etc)
 * 		'ad_tubes' => array(field1 => value, field2 => value, etc))
 * 
 * 3- Sample Master/Detail Tables
 * 
 * array(master_table_name => array(master_control_id => value, field1 => value, field2 => value, etc)
 * 		specimen_details/derivativ_details => array(field1 => value, field2 => value, etc)
 * 		detail_table_name => array(field1 => value, field2 => value, etc))
 * 
 * @param array $tables_data Data to insert. See format above.
 * 
 * @return string Id of the created record
 */
function customInsertRecord($tables_data) {
	global $import_date;
	global $imported_by;
	global $atim_controls;
	$record_id = null;
	$main_table_data = array();
	$details_tables_data = array();
//TODO: Add control on detail table based on _control_id	
	if($tables_data) {
		//--1-- Check data
		switch(sizeof($tables_data)) {
			case '1':
				$table_name = array_shift(array_keys($tables_data));
				if(preg_match('/_masters$/', $table_name)) mergeDie("ERR_FUNCTION_customInsertRecord(): Detail table is missing to record data into $table_name");
				$main_table_data = array('name' => $table_name, 'data' => $tables_data[$table_name]);
				break;
			case '3':
				$details_table_name = '';
				foreach(array_keys($tables_data) as $table_name) {
					if(in_array($table_name, array('specimen_details', 'derivative_details'))) {
						$details_tables_data[] = array('name' => $table_name, 'data' => $tables_data[$table_name]);
						unset($tables_data[$table_name]);
					} else if($table_name == 'sample_masters') {
						$main_table_data = array('name' => $table_name, 'data' => $tables_data[$table_name]);
						unset($tables_data[$table_name]);
					} else {
						$details_table_name = $table_name;
					}
				}
				if(empty($main_table_data)) mergeDie("ERR_FUNCTION_customInsertRecord(): Table sample_masters is missing (See table names: ".implode(' & ', array_keys($tables_data)).")");
				if(empty($details_tables_data)) mergeDie("ERR_FUNCTION_customInsertRecord(): Table 'specimen_details' or 'derivative_details' is missing (See table names: ".implode(' & ', array_keys($tables_data)).")");
				if(sizeof($tables_data) != 1) mergeDie("ERR_FUNCTION_customInsertRecord(): Wrong 3 tables names for a new sample (See table names: ".implode(' & ', array_keys($tables_data)).")");
				$details_tables_data[] = array('name' => $details_table_name, 'data' => $tables_data[$details_table_name]);
				break;
			case '2':
				$details_table_name = '';
				foreach(array_keys($tables_data) as $table_name) {
					if(in_array($table_name, array('specimen_details', 'derivative_details', 'sample_masters'))) {
						mergeDie("ERR_FUNCTION_customInsertRecord(): Table 'sample_masters', 'specimen_details' or 'derivative_details' defined for a record different than Sample or wrong tables definition for a sample creation (See table names: ".implode(' & ', array_keys($tables_data)).")");
						exit;
					} else if(preg_match('/_masters$/', $table_name)) {
						$main_table_data = array('name' => $table_name, 'data' => $tables_data[$table_name]);
						unset($tables_data[$table_name]);
					} else {
						$details_table_name = $table_name;
					}
				}
				if(empty($main_table_data)) mergeDie("ERR_FUNCTION_customInsertRecord(): Table %%_masters is missing (See table names: ".implode(' & ', array_keys($tables_data)).")");
				if(sizeof($tables_data) != 1) mergeDie("ERR_FUNCTION_customInsertRecord(): Wrong 2 tables names for a master/detail model record (See table names: ".implode(' & ', array_keys($tables_data)).")");
				$details_tables_data[] = array('name' => $details_table_name, 'data' => $tables_data[$details_table_name]);
				break;
			default:
				mergeDie("ERR_FUNCTION_customInsertRecord(): Too many tables passed in arguments: ".implode(', ',array_keys($tables_data)).".");
		}
		//-- 2 -- Main or master table record
		if(isset($main_table_data['data']['sample_control_id'])) {
			if(!isset($atim_controls['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']])) mergeDie('ERR_FUNCTION_customInsertRecord(): Unsupported sample control id.');
			$sample_type = $atim_controls['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']];
			if($atim_controls['sample_controls'][$sample_type]['sample_category'] == 'specimen') {
				if(isset($main_table_data['data']['initial_specimen_sample_id'])) unset($main_table_data['data']['initial_specimen_sample_id']);
				$main_table_data['data']['initial_specimen_sample_type'] = $sample_type;
				if(isset($main_table_data['data']['parent_id'])) unset($main_table_data['data']['parent_id']);
				if(isset($main_table_data['data']['parent_sample_type'])) unset($main_table_data['data']['parent_sample_type']);
				if(!isset($main_table_data['data']['sample_code'])) $main_table_data['data']['sample_code'] = "@@@TO_GENERATE@@";
			} else {
				if(!isset($main_table_data['data']['initial_specimen_sample_id'])) mergeDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : initial_specimen_sample_id.');
				if(!isset($main_table_data['data']['initial_specimen_sample_type'])) mergeDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : initial_specimen_sample_type.');
				if(!isset($main_table_data['data']['parent_id'])) mergeDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : parent_id.');
				if(!isset($main_table_data['data']['parent_sample_type'])) mergeDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : parent_sample_type.');
				if(!isset($main_table_data['data']['sample_code'])) $main_table_data['data']['sample_code'] = "@@@TO_GENERATE@@";
			}
		}
		$main_table_data['data'] = array_merge($main_table_data['data'], array("created" => $import_date, "created_by" => $imported_by, "modified" => "$import_date", "modified_by" => $imported_by));
		$query = "INSERT INTO `".$main_table_data['name']."` (`".implode("`, `", array_keys($main_table_data['data']))."`) VALUES (\"".implode("\", \"", array_values($main_table_data['data']))."\")";
		$record_id = customQuery($query, true);
		if(isset($main_table_data['data']['diagnosis_control_id'])) {
			if(in_array($main_table_data['data']['diagnosis_control_id'], $atim_controls['diagnosis_controls']['***primary_control_ids***'])) {
				customQuery("UPDATE diagnosis_masters SET primary_id=id WHERE id = $record_id;", true);
			} else {
				if(!isset($main_table_data['data']['primary_id']) || !isset($main_table_data['data']['parent_id']))
					mergeDie('ERR_FUNCTION_customInsertRecord(): Missing diagnosis_masters primary_id or parent_id key.');
			}
		} else if(isset($main_table_data['data']['sample_control_id'])) {
			$sample_type = $atim_controls['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']];
			$set_strings = array();
			if($atim_controls['sample_controls'][$sample_type]['sample_category'] == 'specimen') $set_strings[] = "initial_specimen_sample_id=id";
			if($main_table_data['data']['sample_code'] == "@@@TO_GENERATE@@") $set_strings[] = "sample_code=id";
			if($set_strings) {
				customQuery("UPDATE sample_masters SET ".implode(',',$set_strings)." WHERE id = $record_id;", true);
			}
		}			
		//-- 3 -- Details tables record
		if(isset($main_table_data['data']['sample_control_id'])) {
			if(sizeof($details_tables_data) != 2) mergeDie("ERR_FUNCTION_customInsertRecord(): Table 'specimen_details', 'derivative_details' or 'SampleDetail' is missing (See table names: ".implode(' & ', array_keys($tables_data)).")");
		} else {
			if(sizeof($details_tables_data) > 2) mergeDie("ERR_FUNCTION_customInsertRecord(): Too many tables are declared (>2) (See table names: ".implode(' & ', array_keys($tables_data)).")");
		}
		$tmp_detail_tablename = null;
		if($details_tables_data) {
			$foreign_key = str_replace('_masters', '_master_id', $main_table_data['name']);
			foreach($details_tables_data as $detail_table) {
				$detail_table['data'] = array_merge($detail_table['data'], array($foreign_key => $record_id));
				$query = "INSERT INTO `".$detail_table['name']."` (`".implode("`, `", array_keys($detail_table['data']))."`) VALUES (\"".implode("\", \"", array_values($detail_table['data']))."\")";
				customQuery($query, true);
				if(!in_array($detail_table['name'], array('specimen_details', 'derivative_details'))) $tmp_detail_tablename = $detail_table['name'];
			}
		}
	}
	return $record_id;
}

/**
 * Update an ATim table record.
 * 
 * @param string $id Id of the record to update
 * @param array $tables_data Data to update (see format above)
 */
function updateTableData($id, $tables_data) {
	global $import_date;
	global $imported_by;
	if($tables_data) {
		$to_update = false;
		//Check data passed in args
		$main_or_master_tablename = null;
		switch(sizeof($tables_data)) {
			case '1':
				$main_or_master_tablename = array_shift(array_keys($tables_data));
				if(!empty($tables_data[$main_or_master_tablename])) $to_update = true;
				break;
			case '2':
			case '3':
				foreach(array_keys($tables_data) as $table_name) {
					if(preg_match('/_masters$/', $table_name)) {
						if(!is_null($main_or_master_tablename)) mergeDie("ERR_FUNCTION_updateTableData(): 2 Master tables passed in arguments: ".implode(', ',array_keys($tables_data)).".");
						$main_or_master_tablename = $table_name;
					}
					if(!empty($tables_data[$table_name])) $to_update = true;
				}
				if(is_null($main_or_master_tablename)) mergeDie("ERR_FUNCTION_updateTableData(): Master table not passed in arguments: ".implode(', ',array_keys($tables_data)).".");
				break;
			default:
				mergeDie("ERR_FUNCTION_updateTableData(): Too many tables passed in arguments: ".implode(', ',array_keys($tables_data)).".");
		}
		if($to_update) {
			//Master/Main Table Update
			$table_name = $main_or_master_tablename;
			$table_data = $tables_data[$main_or_master_tablename];
			unset($tables_data[$main_or_master_tablename]);
			$set_sql_strings = array();
			foreach(array_merge($table_data, array('modified' => $import_date, 'modified_by' => $imported_by))  as $key => $value) $set_sql_strings[] = "`$key` = \"$value\"";
			$query = "UPDATE `$table_name` SET ".implode(', ', $set_sql_strings)." WHERE `id` = $id;";
			customQuery($query);
			//Detail or SpecimenDetail/DerivativeDetail Table Update
			$foreaign_key = str_replace('_masters', '_master_id', $main_or_master_tablename);
			$tmp_detail_tablename = null;
			foreach($tables_data as $table_name => $table_data) {
				if(!empty($table_data)) {
					$set_sql_strings = array();
					foreach($table_data  as $key => $value) $set_sql_strings[] = "`$key` = \"$value\"";
					$query = "UPDATE `$table_name` SET ".implode(', ', $set_sql_strings)." WHERE `$foreaign_key` = $id;";
					customQuery($query);
					if(!in_array($table_name, array('specimen_details', 'derivative_details'))) $tmp_detail_tablename = $table_name;
				}
			}
		}
	}	
}

// ---- VALUE DOMAIN FUNCTIONS & EXCEL LIST VALIDATION FUNCTION --------------------------------------------------------------------------------------------------------------------

global $domains_values;
$domains_values = array();

/**
 * Validate a value is a value of a system list or a custom drop down list and return
 * the formatted value as it exists into database (when cases are different).
 * 
 * @param unknown $value Value to validate
 * @param unknown $domain_name Domain name of the list
 * @param unknown $summary_section_title Section title if an error is generated by the function (See recordErrorAndMessage() description)
 * @param string $summary_title_add_in Additional information to add to summary title if an error is generated by the function (See recordErrorAndMessage() description)
 * @param string $summary_details_add_in Additional information to add to seummary detail if an error is generated by the function (See recordErrorAndMessage() description)
 * 
 * @return string Formatted value to use to match value in database. 
 */
function validateAndGetStructureDomainValue($value, $domain_name, $summary_section_title, $summary_title_add_in = '', $summary_details_add_in = '') {
	global $import_summary;
	global $domains_values;
	if(!array_key_exists($domain_name, $domains_values)) {
		$domains_values[$domain_name] = array();
		$domain_data_results = getSelectQueryResult("SELECT id, source FROM structure_value_domains WHERE domain_name = '$domain_name'");
		if(!empty($domain_data_results)) {
			$domain_data_results = $domain_data_results[0];
			if($domain_data_results['source']) {
				if(preg_match('/getCustomDropdown\(\'(.*)\'\)/', $domain_data_results['source'], $matches)) {
					$query = "SELECT val.value
						FROM structure_permissible_values_custom_controls AS ct
						INNER JOIN structure_permissible_values_customs val ON val.control_id = ct.id
						WHERE ct.name = '".$matches[1]."';";
					foreach(getSelectQueryResult($query) as $domain_value)  $domains_values[$domain_name][strtolower($domain_value['value'])] = $domain_value['value'];
				} else {
					mergeDie("ERR_STRUCTURE_DOMAIN: Source value format for domain_name '$domain_name' is not supported by the merge process.");
				}
			} else {
				$query = "SELECT val.value
					FROM structure_permissible_values val
					INNER JOIN structure_value_domains_permissible_values link ON link.structure_permissible_value_id = val.id
					WHERE link.structure_value_domain_id = ".$domain_data_results['id']." AND link.flag_active = '1';";
				foreach(getSelectQueryResult($query) as $domain_value) $domains_values[$domain_name][strtolower($domain_value['value'])] = $domain_value['value'];
			}
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Wrong '$domain_name'".(empty($summary_title_add_in)? '' : ' - '.$summary_title_add_in), "The '$domain_name' Structure Domain (defined as domain of value '$value') does not exist. The value will be erased.".(empty($summary_details_add_in)? '' : " [$summary_details_add_in]"));
			$value = '';
		}
	}
	if(strlen($value)) {
		if(array_key_exists(strtolower($value), $domains_values[$domain_name])) {
			$value = $domains_values[$domain_name][strtolower($value)];	//To set the right case
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Wrong '$domain_name' Value".(empty($summary_title_add_in)? '' : ' - '.$summary_title_add_in), "Value '$value' is not a value of the '$domain_name' Structure Domain. The value will be erased.".(empty($summary_details_add_in)? '' : " [$summary_details_add_in]")); 
			$value = '';
		}
	}
	return $value;
}

/**
 * Test an excel value match a predefined list of values and return the value to record in database.
 * 
 * @param string $value Value to test
 * @param array $values_matches List of good values (key being a value you can find in excel and value being the value to record in database (ex: array('yes' => 'y', 'y' => 'y', 'unknown' => 'u', '?' => 'u', etc)
 * @param string $str_to_lower Should the case of the value to test change to lower for test
 * @param unknown $summary_section_title Section title if an error is generated by the function (See recordErrorAndMessage() description)
 * @param string $summary_title_add_in Additional information to add to summary title if an error is generated by the function (See recordErrorAndMessage() description)
 * @param string $summary_details_add_in Additional information to add to seummary detail if an error is generated by the function (See recordErrorAndMessage() description)
 * 
 * @return string Tested value (in lower case if expected)
 */
function validateAndGetExcelValueFromList($value, $values_matches, $str_to_lower = false, $summary_section_title = '', $summary_title_add_in = '', $summary_details_add_in = '') {
	if(strlen($value)) {
		if($str_to_lower) $value = strtolower($value);
		if(array_key_exists($value, $values_matches)) {
			$value = $values_matches[$value];
		} else {
			recordErrorAndMessage($summary_section_title, '@@ERROR@@', "Wrong Excel Value".(empty($summary_title_add_in)? '' : ' - '.$summary_title_add_in), "Value '$value' is not a supported eexcel value. The value will be erased.".(empty($summary_details_add_in)? '' : " [$summary_details_add_in]")); 
		}
	}
	return $value;
}
	
?>
		