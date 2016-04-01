<?php

set_time_limit('3600');

//-- Initiate config file variables ------------------------------------------------------------------------------------------------------------------------------------------------

global $migration_process_version;
$migration_process_version = 'v0.1';

$db_ip			= "";
$db_port 		= "";
$db_user 		= "";
$db_pwd			= "";
global $procure_db_schema;
$procure_db_schema		= "";
$chumoncoaxis_db_schema = '';
$db_charset		= "";

$migration_user_id = null;

global $files_path;
$files_path = "";
global $excel_files_names;
$excel_files_names = array();

// Serial number of 1 January 2001 in Excel: 36526 (Windows) / 35064 (MAC)
$windows_xls_offset = 36526;
$mac_xls_offset = 35064;

//==================================================================================================================================================================================
// SYSTEM REQUIRE SECTION
//==================================================================================================================================================================================

require_once 'config.php';
require_once 'Excel/reader.php';

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
@mysqli_select_db($db_connection, $chumoncoaxis_db_schema) or migrationDie("ERR_DATABASE_CONNECTION: Unable to connect to $chumoncoaxis_db_schema for user $db_user");
@mysqli_select_db($db_connection, $procure_db_schema) or migrationDie("ERR_DATABASE_CONNECTION: Unable to connect to $procure_db_schema for user $db_user");
mysqli_autocommit($db_connection, false);

//==================================================================================================================================================================================
// SYSTEM VARIABLES
//==================================================================================================================================================================================

global $all_update_insert_queries;
$all_update_insert_queries = array();

global $import_date;
$import_date = array();
global $imported_by;
$imported_by = array();

foreach(array($procure_db_schema,$chumoncoaxis_db_schema) as $db_schema) {
	$query_result = getSelectQueryResult("SELECT NOW() AS import_date, id FROM $db_schema.users WHERE id = '$migration_user_id';");
	if(empty($query_result)) {
		migrationDie("ERR_DATABASE_CONNECTION: Migration user id '$migration_user_id' does not exist into $procure_db_schema");
	}
	$import_date[$db_schema] = $query_result[0]['import_date'];
	$imported_by[$db_schema] = $query_result[0]['id'];
}

global $atim_controls;
$atim_controls = array();

foreach(array($procure_db_schema,$chumoncoaxis_db_schema) as $db_schema) {
	//*** Control : sample_controls ***
	$atim_controls[$db_schema]['sample_controls'] = array();
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
		$atim_controls[$db_schema]['sample_controls'][$new_sample_control['sample_type']] = $new_sample_control;
		$ids_to_types[$new_sample_control['id']] = $new_sample_control['sample_type'];
	}
	$atim_controls[$db_schema]['sample_controls']['***id_to_type***'] = $ids_to_types;
	
	//*** Control : aliquot_controls ***
	$atim_controls[$db_schema]['aliquot_controls'] = array();
	$query = "SELECT ac.id, sample_type, aliquot_type, ac.detail_tablename, volume_unit 
		FROM $db_schema.aliquot_controls ac INNER JOIN $db_schema.sample_controls sc ON sc.id = ac.sample_control_id 
		WHERE ac.flag_active = '1' AND ac.sample_control_id IN (".implode(',', $active_sample_control_ids).")";
	foreach(getSelectQueryResult($query) as $new_aliquot_control) $atim_controls[$db_schema]['aliquot_controls'][$new_aliquot_control['sample_type'].'-'.$new_aliquot_control['aliquot_type']] = $new_aliquot_control;
	//*** Control : misc_identifier_controls ***
	$atim_controls[$db_schema]['misc_identifier_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, misc_identifier_name, flag_active, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_unique FROM $db_schema.misc_identifier_controls WHERE flag_active = 1") as $new_control) $atim_controls[$db_schema]['misc_identifier_controls'][$new_control['misc_identifier_name']] = $new_control;
	//*** Control : storage_controls ***
	$atim_controls[$db_schema]['storage_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, storage_type, coord_x_title, coord_x_type, coord_x_size, coord_y_title, coord_y_type, coord_y_size, display_x_size, display_y_size , set_temperature, is_tma_block, detail_tablename FROM $db_schema.storage_controls WHERE flag_active = 1 AND storage_type = 'box27'") as $new_control) $atim_controls[$db_schema]['storage_controls'][$new_control['storage_type']] = $new_control;

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

global $XlsReader;
$XlsReader = null;
global $studied_excel_file_name_properties;
$studied_excel_file_name_properties = null;

global $modified_database_tables_list;
$modified_database_tables_list = array();

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

// ---- TITLE, ERROR AND MESSAGE DISPLAY  ------------------------------------------------------------------------------------------------------------------------------------------

global $import_summary;
$import_summary = array();

function displayMigrationTitle($title, $display_file_names = false) {
	global $import_date;
	global $procure_db_schema;
	global $migration_process_version;
	global $excel_files_paths;
	echo "<br><FONT COLOR=\"blue\">=====================================================================<br>
		<b>ATiM DATA MIGRATION PROCESS</b></FONT><br>
		<b><FONT COLOR=\"blue\">Processus : </FONT>$title</b><br>
		<b><FONT COLOR=\"blue\">Version : </FONT>$migration_process_version</b><br>
		<b><FONT COLOR=\"blue\">Date : </FONT>".$import_date[$procure_db_schema]."</b><br>
		<FONT COLOR=\"blue\">=====================================================================</FONT><br>";
	if($display_file_names && !empty($excel_files_paths)) {
		foreach($excel_files_paths as $file_data) {
			echo "<FONT COLOR=\"blue\" >File : </FONT>".$file_data['file_name']."<br>";		
		}
		echo "<FONT COLOR=\"blue\" >=====================================================================</FONT><br>";
	}
}

function recordErrorAndMessage($summary_section_title, $summary_type, $summary_title, $summary_details, $message_detail_key = null) {
	global $import_summary;
	if(is_null($message_detail_key)) {
		$import_summary[$summary_section_title][$summary_type][$summary_title][] = $summary_details;
	} else {
		$import_summary[$summary_section_title][$summary_type][$summary_title][$message_detail_key] = $summary_details;
	}
}

function dislayErrorAndMessage($commit = false) {
	global $import_summary;
	global $db_connection;
	echo "<br><FONT COLOR=\"blue\">
		=====================================================================<br>
		<b>Migration Summary</b><br>
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
		<b>Migration Done $ccl</b><br>
		=====================================================================</FONT><br>";
}

// ---- QUERY FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------------------

function customQuery($query, $insert = false) {
	global $db_connection;
	global $all_update_insert_queries;
	
	if(preg_match('/((UPDATE)|(INSERT))/', $query)) $all_update_insert_queries[] = $query;
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

function customInsertRecord($tables_data, $db_schema) {
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
				$tables_data_keys = array_keys($tables_data);
				$table_name = array_shift($tables_data_keys);
				if(preg_match('/_masters$/', $table_name)) migrationDie("ERR_FUNCTION_customInsertRecord(): Detail table is missing to record data into $table_name");
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
				if(empty($main_table_data)) migrationDie("ERR_FUNCTION_customInsertRecord(): Table sample_masters is missing (See table names: ".implode(' & ', array_keys($tables_data)).")");
				if(empty($details_tables_data)) migrationDie("ERR_FUNCTION_customInsertRecord(): Table 'specimen_details' or 'derivative_details' is missing (See table names: ".implode(' & ', array_keys($tables_data)).")");
				if(sizeof($tables_data) != 1) migrationDie("ERR_FUNCTION_customInsertRecord(): Wrong 3 tables names for a new sample (See table names: ".implode(' & ', array_keys($tables_data)).")");
				$details_tables_data[] = array('name' => $details_table_name, 'data' => $tables_data[$details_table_name]);
				break;
			case '2':
				$details_table_name = '';
				foreach(array_keys($tables_data) as $table_name) {
					if(in_array($table_name, array('specimen_details', 'derivative_details', 'sample_masters'))) {
						migrationDie("ERR_FUNCTION_customInsertRecord(): Table 'sample_masters', 'specimen_details' or 'derivative_details' defined for a record different than Sample or wrong tables definition for a sample creation (See table names: ".implode(' & ', array_keys($tables_data)).")");
						exit;
					} else if(preg_match('/_masters$/', $table_name)) {
						$main_table_data = array('name' => $table_name, 'data' => $tables_data[$table_name]);
						unset($tables_data[$table_name]);
					} else {
						$details_table_name = $table_name;
					}
				}
				if(empty($main_table_data)) migrationDie("ERR_FUNCTION_customInsertRecord(): Table %%_masters is missing (See table names: ".implode(' & ', array_keys($tables_data)).")");
				if(sizeof($tables_data) != 1) migrationDie("ERR_FUNCTION_customInsertRecord(): Wrong 2 tables names for a master/detail model record (See table names: ".implode(' & ', array_keys($tables_data)).")");
				$details_tables_data[] = array('name' => $details_table_name, 'data' => $tables_data[$details_table_name]);
				break;
			default:
				migrationDie("ERR_FUNCTION_customInsertRecord(): Too many tables passed in arguments: ".implode(', ',array_keys($tables_data)).".");
		}
		//-- 2 -- Main or master table record
		if(isset($main_table_data['data']['sample_control_id'])) {
			if(!isset($atim_controls[$db_schema]['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']])) migrationDie('ERR_FUNCTION_customInsertRecord(): Unsupported sample control id.');
			$sample_type = $atim_controls[$db_schema]['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']];
			if($atim_controls[$db_schema]['sample_controls'][$sample_type]['sample_category'] == 'specimen') {
				if(isset($main_table_data['data']['initial_specimen_sample_id'])) unset($main_table_data['data']['initial_specimen_sample_id']);
				$main_table_data['data']['initial_specimen_sample_type'] = $sample_type;
				if(isset($main_table_data['data']['parent_id'])) unset($main_table_data['data']['parent_id']);
				if(isset($main_table_data['data']['parent_sample_type'])) unset($main_table_data['data']['parent_sample_type']);
				if(!isset($main_table_data['data']['sample_code'])) $main_table_data['data']['sample_code'] = "@@@TO_GENERATE@@";
			} else {
				if(!isset($main_table_data['data']['initial_specimen_sample_id'])) migrationDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : initial_specimen_sample_id.');
				if(!isset($main_table_data['data']['initial_specimen_sample_type'])) migrationDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : initial_specimen_sample_type.');
				if(!isset($main_table_data['data']['parent_id'])) migrationDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : parent_id.');
				if(!isset($main_table_data['data']['parent_sample_type'])) migrationDie('ERR_FUNCTION_customInsertRecord(): Missing sample information : parent_sample_type.');
				if(!isset($main_table_data['data']['sample_code'])) $main_table_data['data']['sample_code'] = "@@@TO_GENERATE@@";
			}
		}
		$main_table_data['data'] = array_merge($main_table_data['data'], array("created" => $import_date[$db_schema], "created_by" => $imported_by[$db_schema], "modified" => $import_date[$db_schema], "modified_by" => $imported_by[$db_schema]));
		$query = "INSERT INTO $db_schema.`".$main_table_data['name']."` (`".implode("`, `", array_keys($main_table_data['data']))."`) VALUES (\"".implode("\", \"", array_values($main_table_data['data']))."\")";
		$record_id = customQuery($query, true);
		if(isset($main_table_data['data']['diagnosis_control_id'])) {
			if(in_array($main_table_data['data']['diagnosis_control_id'], $atim_controls[$db_schema]['diagnosis_controls']['***primary_control_ids***'])) {
				customQuery("UPDATE $db_schema.diagnosis_masters SET primary_id=id WHERE id = $record_id;", true);
			} else {
				if(!isset($main_table_data['data']['primary_id']) || !isset($main_table_data['data']['parent_id']))
					migrationDie('ERR_FUNCTION_customInsertRecord(): Missing diagnosis_masters primary_id or parent_id key.');
			}
		} else if(isset($main_table_data['data']['sample_control_id'])) {
			$sample_type = $atim_controls[$db_schema]['sample_controls']['***id_to_type***'][$main_table_data['data']['sample_control_id']];
			$set_strings = array();
			if($atim_controls[$db_schema]['sample_controls'][$sample_type]['sample_category'] == 'specimen') $set_strings[] = "initial_specimen_sample_id=id";
			if($main_table_data['data']['sample_code'] == "@@@TO_GENERATE@@") $set_strings[] = "sample_code=id";
			if($set_strings) {
				customQuery("UPDATE $db_schema.sample_masters SET ".implode(',',$set_strings)." WHERE id = $record_id;", true);
			}
		}			
		//-- 3 -- Details tables record
		if(isset($main_table_data['data']['sample_control_id'])) {
			if(sizeof($details_tables_data) != 2) migrationDie("ERR_FUNCTION_customInsertRecord(): Table 'specimen_details', 'derivative_details' or 'SampleDetail' is missing (See table names: ".implode(' & ', array_keys($tables_data)).")");
		} else {
			if(sizeof($details_tables_data) > 2) migrationDie("ERR_FUNCTION_customInsertRecord(): Too many tables are declared (>2) (See table names: ".implode(' & ', array_keys($tables_data)).")");
		}
		$tmp_detail_tablename = null;
		if($details_tables_data) {
			$foreign_key = str_replace('_masters', '_master_id', $main_table_data['name']);
			foreach($details_tables_data as $detail_table) {
				$detail_table['data'] = array_merge($detail_table['data'], array($foreign_key => $record_id));
				$query = "INSERT INTO $db_schema.`".$detail_table['name']."` (`".implode("`, `", array_keys($detail_table['data']))."`) VALUES (\"".implode("\", \"", array_values($detail_table['data']))."\")";
				customQuery($query, true);
				if(!in_array($detail_table['name'], array('specimen_details', 'derivative_details'))) $tmp_detail_tablename = $detail_table['name'];
			}
		}
		//-- 4 -- Keep updated tables in memory
		addToModifiedDatabaseTablesList($db_schema.'.'.$main_table_data['name'], $db_schema.'.'.$tmp_detail_tablename);
	}
	return $record_id;
}

function updateTableData($id, $tables_data, $db_schema) {
	global $import_date;
	global $imported_by;
	if($tables_data) {
		$to_update = false;
		//Check data passed in args
		$main_or_master_tablename = null;
		switch(sizeof($tables_data)) {
			case '1':
				$main_or_master_tablename = array_keys($tables_data);
				$main_or_master_tablename = array_shift($main_or_master_tablename);
				if(!empty($tables_data[$main_or_master_tablename])) $to_update = true;
				break;
			case '2':
			case '3':
				foreach(array_keys($tables_data) as $table_name) {
					if(preg_match('/_masters$/', $table_name)) {
						if(!is_null($main_or_master_tablename)) migrationDie("ERR_FUNCTION_updateTableData(): 2 Master tables passed in arguments: ".implode(', ',array_keys($tables_data)).".");
						$main_or_master_tablename = $table_name;
					}
					if(!empty($tables_data[$table_name])) $to_update = true;
				}
				if(is_null($main_or_master_tablename)) migrationDie("ERR_FUNCTION_updateTableData(): Master table not passed in arguments: ".implode(', ',array_keys($tables_data)).".");
				break;
			default:
				migrationDie("ERR_FUNCTION_updateTableData(): Too many tables passed in arguments: ".implode(', ',array_keys($tables_data)).".");
		}
		if($to_update) {
			//Master/Main Table Update
			$table_name = $main_or_master_tablename;
			$table_data = $tables_data[$main_or_master_tablename];
			unset($tables_data[$main_or_master_tablename]);
			$set_sql_strings = array();
			foreach(array_merge($table_data, array('modified' => $import_date[$db_schema], 'modified_by' => $imported_by[$db_schema]))  as $key => $value) $set_sql_strings[] = "`$key` = \"$value\"";
			$query = "UPDATE $db_schema.`$table_name` SET ".implode(', ', $set_sql_strings)." WHERE `id` = $id;";
			customQuery($query);
			//Detail or SpecimenDetail/DerivativeDetail Table Update
			$foreaign_key = str_replace('_masters', '_master_id', $main_or_master_tablename);
			$tmp_detail_tablename = null;
			foreach($tables_data as $table_name => $table_data) {
				if(!empty($table_data)) {
					$set_sql_strings = array();
					foreach($table_data  as $key => $value) $set_sql_strings[] = "`$key` = \"$value\"";
					$query = "UPDATE $db_schema.`$table_name` SET ".implode(', ', $set_sql_strings)." WHERE `$foreaign_key` = $id;";
					customQuery($query);
					if(!in_array($table_name, array('specimen_details', 'derivative_details'))) $tmp_detail_tablename = $table_name;
				}
			}
			//Keep updated tables in memory
			addToModifiedDatabaseTablesList($db_schema.'.'.$main_or_master_tablename, $db_schema.'.'.$tmp_detail_tablename);
		}
	}	
}

function addToModifiedDatabaseTablesList($main_table_name, $detail_table_name) {
	global $modified_database_tables_list;
	$detail_table_name = preg_match('/\.$/',$detail_table_name)? '' : $detail_table_name;
	$key = $main_table_name.'-'.(is_null($detail_table_name)? '' : $detail_table_name);
	$modified_database_tables_list[$key] = array($main_table_name, $detail_table_name);
}










/**
 * Insert into revs table data created or updated . 
 * When no parameter is set, the system will insert any record created or modified by 
 * follwing functions:
 * 		- customInsertRecord()
 * 		- updateTableData()
 *
 * @param unknown $main_table_name Name of the main table
 * @param unknown $detail_table_name Name of the detail table name
 */
function insertIntoRevsBasedOnModifiedValues($main_tablename = null, $detail_tablename = null) {
	global $import_date;
	global $imported_by;
	global $atim_controls;
	global $modified_database_tables_list;
	
	$tables_sets_to_update = $modified_database_tables_list;
	if(!is_null($main_tablename)) {
		$key = $main_tablename.'-'.(is_null($detail_tablename)? '' : $detail_tablename);
		$tables_sets_to_update = array($key => array($main_tablename, $detail_tablename));
	}
	
	//Check masters model alone
	$initial_tables_sets_to_update = $tables_sets_to_update;
	foreach($initial_tables_sets_to_update as $key => $tmp) {
		if(preg_match('/^(.*)\.([a-z]+_masters)\-$/', $key, $matches)) {
			$tmp_db_schema = $matches[1];
			$master_table_name = $matches[2];
			$control_table_name = str_replace('_masters', '_controls', $master_table_name);
			if(!isset($atim_controls[$tmp_db_schema][$control_table_name])) migrationDie("ERR 778894003 #$master_table_name.$control_table_name");
			foreach($atim_controls[$tmp_db_schema][$control_table_name] as $control_data) {
				if(is_array($control_data) && isset($control_data['detail_tablename'])) {
					$detail_table_name = $control_data['detail_tablename'];
					$new_key = "$tmp_db_schema.$master_table_name-$tmp_db_schema.$detail_table_name";
					if(!isset($tables_sets_to_update[$new_key])) $tables_sets_to_update[$new_key] = array("$tmp_db_schema.$master_table_name", "$tmp_db_schema.$detail_table_name");
				}
			}
			unset($tables_sets_to_update[$key]);
		}
	}
	
	//Insert Into Revs
	$insert_queries = array();
	$set_key_done = array();
	foreach($tables_sets_to_update as $new_tables_set) {
		list($main_tablename, $detail_tablename) = $new_tables_set;
		list($db_schema, $main_tablename) = explode('.', $main_tablename);
		if($detail_tablename) {
			list($tmp_db_schema, $detail_tablename) = explode('.', $detail_tablename);
			if($tmp_db_schema != $db_schema) die('ERR 23 7y78326 87 32 68623');
		}
		if(!$detail_tablename) {
			// *** CLASSICAL MODEL ***
			$query = "DESCRIBE $db_schema.`$main_tablename`;";
			$results = customQuery($query);
			$table_fields = array();
			while($row = $results->fetch_assoc()) {
				if(!in_array($row['Field'], array('created','created_by','modified','modified_by','deleted'))) $table_fields[] = $row['Field'];
			}
			$source_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ')."`modified_by`, `modified`";
			$revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`modified_by`, `version_created`';
			$insert_queries[] = "INSERT INTO $db_schema.`".$main_tablename."_revs` ($revs_table_fields)
				(SELECT $source_table_fields FROM $db_schema.`$main_tablename` WHERE `modified_by` = '".$imported_by[$db_schema]."' AND `modified` = '".$import_date[$db_schema]."');";
		} else {
			// *** MASTER DETAIL MODEL ***
			if(!preg_match('/^.+\_masters$/', $main_tablename)) migrationDie("ERR_FUNCTION_insertIntoRevsBasedOnModifiedValues(): '$main_tablename' is not a 'Master' table of a MasterDetail model.");
			$foreign_key = str_replace('_masters', '_master_id', $main_tablename);
			//Master table
			$query = "DESCRIBE $db_schema.$main_tablename;";
			$results = customQuery($query);
			$table_fields = array();
			while($row = $results->fetch_assoc()) {
				if(!in_array($row['Field'], array('created','created_by','modified','modified_by','deleted'))) $table_fields[] = $row['Field'];
			}
			$source_table_fields = (empty($table_fields)? '' : 'Master.`'.implode('`, Master.`',$table_fields).'`, ')."Master.`modified_by`, Master.`modified`";
			$revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`modified_by`, `version_created`';
			$insert_queries[] = "INSERT INTO $db_schema.`".$main_tablename."_revs` ($revs_table_fields)
				(SELECT $source_table_fields FROM $db_schema.`$main_tablename` AS Master INNER JOIN $db_schema.$detail_tablename AS Detail ON Master.`id` = Detail.`$foreign_key` WHERE Master.`modified_by` = '".$imported_by[$db_schema]."' AND Master.`modified` = '".$import_date[$db_schema]."');";
			//Detail table
			$all_detail_tablenames = ($main_tablename != 'sample_masters')? array($detail_tablename) : array($detail_tablename, 'specimen_details', 'derivative_details');
			foreach($all_detail_tablenames as $detail_tablename) {
				$query = "DESCRIBE $db_schema.$detail_tablename;";
				$results = customQuery($query);
				$table_fields = array();
				while($row = $results->fetch_assoc()) $table_fields[] = $row['Field'];
				if(!in_array($foreign_key, $table_fields)) migrationDie("ERR_FUNCTION_insertIntoRevsBasedOnModifiedValues(): Foreign Key '$foreign_key' defined based on 'Master' table name '$main_tablename' is not a field of the 'Detail' table '$detail_tablename'.");
				$source_table_fields = (empty($table_fields)? '' : 'Detail.`'.implode('`, Detail.`',$table_fields).'`, ')."Master.`modified`";
				$revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`version_created`';
				$insert_queries[] = "INSERT INTO $db_schema.`".$detail_tablename."_revs` ($revs_table_fields)
					(SELECT $source_table_fields FROM $db_schema.`$main_tablename` AS Master INNER JOIN $db_schema.`$detail_tablename` AS Detail ON Master.`id` = Detail.`$foreign_key` WHERE Master.`modified_by` = '".$imported_by[$db_schema]."' AND Master.`modified` = '".$import_date[$db_schema]."');";
			}
		}
	}
	foreach($insert_queries as $query) {
		customQuery($query, true);
	}
}

// ---- EXCEL FILE -----------------------------------------------------------------------------------------------------------------------------------------------------------------

function testExcelFile($file_names) {
	global $import_summary;
	global $files_path;
	$validated = true;
	foreach($file_names as $excel_file_name) {	
		if(!file_exists($files_path.$excel_file_name)) {
			recordErrorAndMessage('Excel Data Reading', '@@ERROR@@', "Non-Existent File", "File '$excel_file_name' in directory ($files_path) does not exist. File won't be parsed.", $excel_file_name);
			$validated = false;
		}
		if(!preg_match('/\.xls$/', $excel_file_name)) {
			recordErrorAndMessage('Excel Data Reading', '@@ERROR@@', "Wrong File Extension", "File '$excel_file_name' in directory ($files_path) is not a '.xls' file. File won't be parsed.", $excel_file_name);
			$validated = false;
		}
	}
	return $validated;
}

function getNextExcelLineData($excel_file_name, $worksheet_name, $header_lines_nbr = 1, $file_xls_offset = '36526') {
	global $import_summary;
	global $XlsReader;
	global $files_path;
	global $studied_excel_file_name_properties;
	global $xls_offset;
	
	$xls_offset = $file_xls_offset;

	// ** LOAD NEW EXCEL FILE **

	if(is_null($studied_excel_file_name_properties) || $studied_excel_file_name_properties['file_name'] != $excel_file_name) {
		if(!testExcelFile(array($excel_file_name))) return false;
		//Load Excel Data
		$XlsReader = new Spreadsheet_Excel_Reader();	
		$XlsReader->read($files_path.$excel_file_name);
		//Set studied_excel_file_name_properties
		$studied_excel_file_name_properties = array('file_name' => $excel_file_name, 'file_worksheets' => array());
		foreach($XlsReader->boundsheets as $key => $tmp) $studied_excel_file_name_properties['file_worksheets'][$tmp['name']] = $key;
	}

	// ** SET NEW WOKRSHEET DATA **

	if(!array_key_exists('worksheet_name', $studied_excel_file_name_properties) || $studied_excel_file_name_properties['worksheet_name'] != $worksheet_name) {
		if(!array_key_exists($worksheet_name, $studied_excel_file_name_properties['file_worksheets'])) {
			recordErrorAndMessage('Excel Data Reading', '@@ERROR@@', "Non-Existent Worksheet", "Worksheet '$worksheet_name' is not a worksheet of file '$excel_file_name'. Worksheet won't be parsed.");
			return false;
		} else if(!isset($XlsReader->sheets[$studied_excel_file_name_properties['file_worksheets'][$worksheet_name]]['cells']) || empty($XlsReader->sheets[$studied_excel_file_name_properties['file_worksheets'][$worksheet_name]]['cells'])) {
			//Empty worksheet
			recordErrorAndMessage('Excel Data Reading', '@@WARNING@@', "EMpty Worksheet", "Worksheet '$worksheet_name' of file '$excel_file_name' is empty. Worksheet won't be parsed.");
			return false;
		} else {
			$studied_excel_file_name_properties['worksheet_name'] = $worksheet_name;
			$studied_excel_file_name_properties['headers'] = array();
			$tmp_worksheet_line_counters = array_keys($XlsReader->sheets[$studied_excel_file_name_properties['file_worksheets'][$worksheet_name]]['cells']);
			$studied_excel_file_name_properties['last_worksheet_line_counter'] = end($tmp_worksheet_line_counters);
			$studied_excel_file_name_properties['last_studied_line_counter'] = '0';
		}
	}
	$excel_file_handler = $XlsReader->sheets[$studied_excel_file_name_properties['file_worksheets'][$worksheet_name]];
	
	// ** LOAD EXCEL HEADER **

	if($studied_excel_file_name_properties['headers'] == '-1') {
		return false;
	} else if(empty($studied_excel_file_name_properties['headers'])) {
		if(!preg_match('/^[1-9][0-9]*$/', $header_lines_nbr)) {
			recordErrorAndMessage('Excel Data Reading', '@@ERROR@@', "Excel Headers Definition", "The number of header lines [$header_lines_nbr] passed in arguments to the function getNextExcelLineData() is not supported. No data will be parsed. (Defintion used for worksheet '$worksheet_name' of file '$excel_file_name')");
			return false;
		} else {
			//Get Header Excel Line Numbers (in case there are some empty line before or between headers)
			$header_excel_line_numbers = array();
			$detected_header_lines_counter = 0;
			while($detected_header_lines_counter < $header_lines_nbr && $studied_excel_file_name_properties['last_studied_line_counter'] <= $studied_excel_file_name_properties['last_worksheet_line_counter']) {
				$studied_excel_file_name_properties['last_studied_line_counter']++;
				if(array_key_exists($studied_excel_file_name_properties['last_studied_line_counter'], $excel_file_handler['cells'])) {
					$header_excel_line_numbers[] = $studied_excel_file_name_properties['last_studied_line_counter'];
					$detected_header_lines_counter++;
				}
			}
			if(empty($header_excel_line_numbers) || sizeof($header_excel_line_numbers) != $header_lines_nbr) {
				recordErrorAndMessage('Excel Data Reading', '@@ERROR@@', "Missing or Incomplete Header", "No header (or incomplete header) exsists into worksheet '$worksheet_name' of file '$excel_file_name'. No data will be parsed.");
				$studied_excel_file_name_properties['headers'] = '-1';
				return false;
			}
			//Build Header
			$header_excel_line_numbers = array_reverse($header_excel_line_numbers);
			$headers = array();
			foreach($header_excel_line_numbers as $line_number) {
				if(empty($headers)) {
					$headers = $excel_file_handler['cells'][$line_number];
				} else {				
					foreach($excel_file_handler['cells'][$line_number] as $key => $title){
						if(isset($headers[$key])){
							$colspan = isset($excel_file_handler['cellsInfo'][$line_number]) && isset($excel_file_handler['cellsInfo'][$line_number][$key]) && isset($excel_file_handler['cellsInfo'][$line_number][$key]['colspan']) && is_numeric($excel_file_handler['cellsInfo'][$line_number][$key]['colspan']) ? $excel_file_handler['cellsInfo'][$line_number][$key]['colspan'] : 1;
							for($i = $colspan - 1; $i >= 0; -- $i){
								$headers[$key + $i] = $title." ".$headers[$key + $i];
							}
						}else{
							$headers[$key] = $title;
						}
					}
				}
			}
			ksort($headers);
			foreach($headers as $key => $title) {
				$title = trim(str_replace(array("\n", "  "), array(' ', ' '), $title));
				$studied_excel_file_name_properties['headers'][$key] = $title;
			}		
		}
	}

	// ** LOAD NEW EXCEL LINE DATA **

	while($studied_excel_file_name_properties['last_studied_line_counter'] <= $studied_excel_file_name_properties['last_worksheet_line_counter']) {
		$studied_excel_file_name_properties['last_studied_line_counter']++;
		if(array_key_exists($studied_excel_file_name_properties['last_studied_line_counter'], $excel_file_handler['cells'])) {
			$formatted_new_line_data = array();
			$new_excel_line_data = $excel_file_handler['cells'][$studied_excel_file_name_properties['last_studied_line_counter']];
			$data_found = false;
			foreach($studied_excel_file_name_properties['headers'] as $key => $field) {
				if(isset($new_excel_line_data[$key])) {
					$formatted_new_line_data[trim(utf8_encode($field))] = trim(utf8_encode($new_excel_line_data[$key]));
					$data_found = true;
				} else {
					$formatted_new_line_data[trim(utf8_encode($field))] = '';
				}
			}
			if($data_found) return array($studied_excel_file_name_properties['last_studied_line_counter'], $formatted_new_line_data);
		}
	}
	
	// ** END OF FILE **
	
	return false;
}	
	
?>
		