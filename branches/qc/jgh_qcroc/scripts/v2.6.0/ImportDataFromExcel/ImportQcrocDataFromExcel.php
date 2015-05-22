<?php

require_once 'Files/Inventory.php';

set_time_limit('3600');

//==============================================================================================
// Variables
//==============================================================================================

$files_name = array(
	'tissue' => 'Copie de Q-CROC-01 Tissue data v14 Selecting patient with all data for DNA RNA tube_20150514.xls',
	'blood' => 'Copie de Q-CROC-01 Blood Data v9  Only clean data from v8_20150514.xls'
);
$files_path = 'C:\\_Perso\\Server\\jgh_qcroc\\data\\';
require_once 'Excel/reader.php';

global $import_summary;
$import_summary = array();

global $db_schema;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_charset		= "utf8";
$db_schema	= "jghqcroc";

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed 2 $db_user $db_schema ");

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE id = '1';", __FILE__, __LINE__);
if($query_res->num_rows != 1) importDie('ERR : No user Migration!');
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

global $controls;
$controls = loadATiMControlData();

global $patient_qcroc_ids_to_part_and_col_ids;
$patient_qcroc_ids_to_part_and_col_ids = array();

global $sample_code;
$sample_code = 0;

global $tmp_barcode;
$tmp_barcode = 0;

global $storage_master_ids;
$storage_master_ids = array();
global $last_storage_code;
$last_storage_code = 0;

global $qc_code_counter;
$qc_code_counter = 0;

echo "<br><br><FONT COLOR=\"blue\" >
=====================================================================<br>
QCROC - Data Migration to ATiM<br>
$import_date<br>
=====================================================================</FONT><br>";


//TODO remove
truncate();

//==============================================================================================
//MAIN CODE
//==============================================================================================

global $qcroc_ids_to_part_and_col_ids;
$qcroc_ids_to_part_and_col_ids = array();

echo "<br><FONT COLOR=\"green\" >File(s) : ".$files_name['tissue']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadTissue($XlsReader, $files_path, $files_name['tissue']);

echo "<br><FONT COLOR=\"green\" >File(s) : ".$files_name['blood']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadBlood($XlsReader, $files_path, $files_name['blood']);

//==============================================================================================
//BARCODES UPDATE
//==============================================================================================

$query = "UPDATE sample_masters SET sample_code = id;";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE sample_masters SET initial_specimen_sample_id = id WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_category = 'specimen');";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE aliquot_masters SET barcode = CONCAT('SYS#', id) WHERE barcode LIKE 'SYS#%';";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE storage_masters SET code = id;";
customQuery($query, __FILE__, __LINE__);
$query = "SELECT barcode FROM (SELECT barcode, count(*) AS tx FROM aliquot_masters WHERE deleted <> 1 GROUP BY barcode) AS test WHERE test.tx > 1;";
$results = customQuery($query, __FILE__, __LINE__);
$query = "UPDATE quality_ctrls SET qc_code = id;";
customQuery($query, __FILE__, __LINE__);
while($row = $results->fetch_assoc()){
	$import_summary['Inventory']['@@ERROR@@']['Duplicated Aliquot Barcodes'][] = "The The migration process created duplciated barcode : ".$row['barcode'];
}

//==============================================================================================
//End of the process
//==============================================================================================

dislayErrorAndMessage($import_summary);

insertIntoRevs();

$query = "UPDATE versions SET permissions_regenerated = 0;";
customQuery($query, __FILE__, __LINE__);

//==============================================================================================
// DEV Functions
//==============================================================================================

function loadATiMControlData(){
	$controls = array();
	// MiscIdentifierControl
	$query = "select id, misc_identifier_name, flag_unique FROM misc_identifier_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['MiscIdentifierControl'][$row['misc_identifier_name']] = array('id' => $row['id'], 'flag_unique' => $row['flag_unique']);
	}
	//SampleControl
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue', 'blood', 'serum', 'plasma', 'pbmc','dna','rna','urine','centrifuged urine')";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['sample_aliquot_controls'][$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}
	foreach($controls['sample_aliquot_controls'] as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = customQuery($query, __FILE__, __LINE__);
		while($row = $results->fetch_assoc()){
			$controls['sample_aliquot_controls'][$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}
	}
	//StorageControl
	$query = "SELECT id as storage_control_id, storage_type, detail_tablename, coord_x_type,coord_x_size,coord_y_type,coord_y_size FROM storage_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$controls['storage_controls'][$row['storage_type']] = $row;
	}
	//ReviewControl
	$query = "SELECT id as specimen_review_control_id, review_type, detail_tablename FROM specimen_review_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$controls['specimen_review_controls'][$row['review_type']] = $row;
	}
	$query = "SELECT id as aliquot_review_control_id, databrowser_label as review_type, detail_tablename FROM aliquot_review_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$controls['aliquot_review_controls'][$row['review_type']] = $row;
	}
	return $controls;
}

function insertIntoRevs() {
	global $import_date;
	global $import_by;
		
	$tables = array(
		'participants' => 0,
		'misc_identifiers' => 0,
		
		'collections' => 0,
			
		'sample_masters' => 0,
		'specimen_details' => 1,
		'derivative_details' => 1,
		'sd_spe_tissues' => 1,
		'sd_spe_bloods' => 1,
		'sd_der_serums' => 1,
		'sd_der_pbmcs' => 1,
		'sd_der_plasmas' => 1,
		'sd_spe_urines' => 1,
		'sd_der_urine_cents' => 1,
		'sd_der_rnas' => 1,
		'sd_der_dnas' => 1,
		
		'aliquot_masters' => 0,
		'ad_tubes' => 1,
		'ad_tissue_slides' => 1,
		'ad_whatman_papers' => 1,
		'ad_blocks' => 1,
	
		'specimen_review_masters' => 0,
		'qcroc_spr_tissues'=> 1,
		'aliquot_review_masters' => 0,
		'qcroc_ar_tissue_slides'=> 1,
			
		'aliquot_internal_uses' => 0,	
		'source_aliquots' => 0	,
		'realiquotings' => 0,

		'quality_ctrls' => 0
	
// 		'storage_masters' => 0,
// 		'std_nitro_locates' => 1,
// 		'std_fridges' => 1,
// 		'std_freezers' => 1,
// 		'std_boxs' => 1,		
// 		'std_racks' => 1
	);
	
	foreach($tables as $table_name => $is_detail_table) {
		$fields = array();
		$results = customQuery("DESC $table_name;", __FILE__, __LINE__);
		while($row = $results->fetch_assoc()) {
			$field = $row['Field'];
			if(!in_array($field, array('created', 'created_by','modified', 'modified_by','deleted'))) $fields[$row['Field']] = $row['Field'];
		}
		$fields = implode(',', $fields);
		if(!$is_detail_table) {
			$query = "INSERT INTO ".$table_name."_revs ($fields, modified_by, version_created) (SELECT $fields, $import_by, '$import_date' FROM $table_name)";
		} else {
			$query = "INSERT INTO ".$table_name."_revs ($fields, version_created) (SELECT $fields, '$import_date' FROM $table_name)";
		}
		customQuery($query, __FILE__, __LINE__);
	}
}

//=================================================================================================================================
// System Functions
//=================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function formatNewLineData($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[trim(utf8_encode($field))] = trim(utf8_encode($data[$key]));
		} else {
			$line_data[trim(utf8_encode($field))] = '';
		}
	}
	return $line_data;
}

function importDie($msg, $rollbak = true) {
	if($rollbak) {
		//TODO manage commit rollback
	}
	die($msg);
}

function customQuery($query, $file, $line, $insert = false) {
	global $db_connection;
	$query_res = mysqli_query($db_connection, $query) or importDie("QUERY ERROR: file $file line $line [".mysqli_error($db_connection)."] : $query");
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}
	
function customInsert($data, $table_name, $file, $line, $is_detail_table = false, $insert_into_revs = false) {
	global $import_date;
	global $import_by;
	
	$data_to_insert = array();
	foreach($data as $key => $value) {
		if(strlen(str_replace(array(' ', "\n"), array('', ''), $value))) $data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
	}
	// Insert into table
	$table_system_data = $is_detail_table? array() : array("created" => "'$import_date'", "created_by" => "'$import_by'", "modified" => "'$import_date'", "modified_by" => "'$import_by'");
	$insert_arr = array_merge($data_to_insert, $table_system_data);
	$record_id = customQuery("INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $file, $line, true);
	// Insert into revs table
	if($insert_into_revs) {
		$revs_table_system_data = $is_detail_table? array('version_created' => "'$import_date'") : array('id' => "$record_id", 'version_created' => "'$import_date'", "modified_by" => "'$import_by'");
		$insert_arr = array_merge($data_to_insert, $revs_table_system_data);
		customQuery("INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $file, $line, true);
	}
	
	return $record_id;
}

function getDateAndAccuracy($data, $field, $summary_title, $file, $worksheet, $line) {
	global $import_summary;
	if(!array_key_exists($field, $data)) die("ERR 238729873298 732 $field $file, $line");
	$date = str_replace(array(' ', 'N/A', 'n/a', 'x', '??', 'ND'), array('', '', '', '', '', '', ''), $data[$field]);
	if(empty($date) || $date == '-') {
		return array('date' => null, 'accuracy' =>null);
	} else if(preg_match('/^([0-9]+)$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date - $xls_offset) * 86400));
		return array('date' => $date, 'accuracy' => 'c');	
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/',$date,$matches)) {
		return array('date' => $date, 'accuracy' => 'c');
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])$/',$date,$matches)) {
		return array('date' => $date.'-01', 'accuracy' => 'd');
	} else if(preg_match('/^((19|20)([0-9]{2})\-([01][0-9]))\-unk$/',$date,$matches)) {
		return array('date' => $matches[1].'-01', 'accuracy' => 'd');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^([0-3][0-9])\/([01][0-9])\/(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else if(preg_match('/^([0-3][0-9])\-([01][0-9])\-(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else {
		$import_summary[$summary_title]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [field '$field' - file '$file' ($worksheet) - line: $line]";
		return array('date' => null, 'accuracy' =>null);
	}	
}

function getDateTimeAndAccuracy($data, $field_date, $field_time, $summary_title, $file, $worksheet, $line) {
	global $import_summary;
	if(!array_key_exists($field_time, $data)) die("ERR 238729873298 732 $field $file, $line");
	$time = str_replace(array(' ', 'N/A', 'n/a', 'x', '??'), array('', '', '', '', '', ''), $data[$field_time]);
	//Get Date
	$tmp_date = getDateAndAccuracy($data, $field_date, $summary_title, $file, $worksheet, $line);
	if(!$tmp_date['date']) {
		if(!empty($time) && $time != '-') $import_summary[$summary_title]['@@ERROR@@']['DateTime: Only time is set'][] = "See following fields details. [fields '$field_date' & '$field_time' - file '$file' ($worksheet) - line: $line]";
		return array('datetime' => null, 'accuracy' =>null);
	} else {
		$formatted_date = $tmp_date['date'];
		$formatted_date_accuracy = $tmp_date['accuracy'];
		//Combine date and time
		if(empty($time) || $time == '-') {
			return array('datetime' => $formatted_date.' 00:00', 'accuracy' => str_replace('c', 'h', $formatted_date_accuracy));
		} else {
			if($formatted_date_accuracy != 'c') {
				$import_summary[$summary_title]['@@ERROR@@']['Time set for an unaccuracy date'][] = "Date and time are set but date is unaccuracy. No datetime will be set! [fields '$field_date' & '$field_time' - file '$file' ($worksheet) - line: $line]";
				return array('datetime' => null, 'accuracy' =>null);
			} else if(preg_match('/^(0{0,1}[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/',$time, $matches)) {
				return array('datetime' => $formatted_date.' '.((strlen($time) == 5)? $time : '0'.$time), 'accuracy' => 'c');
			} else if(preg_match('/^0\.[0-9]+$/', $time)) {
				$hour = floor(24*$time);
				$mn = round((24*$time - $hour)*60);
				$mn = (strlen($mn) == 1)? '0'.$mn  : $mn ;
				if($mn == '60') {
					$mn = '00';
					$hour += 1;
				}
				if($hour > 23) die('ERR time >= 24 79904044--4-44');
				$time=$hour.':'.$mn;				
				return array('datetime' => $formatted_date.' '.((strlen($time) == 5)? $time : '0'.$time), 'accuracy' => 'c');
			} else {
				$import_summary[$summary_title]['@@ERROR@@']['Time Format Error'][] = "Format of time '$time' is not supported! [field '$field_time' - file '$file' ($worksheet) - line: $line]";
				return array('datetime' => null, 'accuracy' =>null);;
			}
		}
	}
}

function getTime($data, $field_time, $summary_title, $file, $worksheet, $line) {
	global $import_summary;
	if(!array_key_exists($field_time, $data)) die("ERR 238729873298 732 $field $file, $line");
	$time = str_replace(array(' ', 'N/A', 'n/a', '-', 'x', '??'), array('', '', '', '', '', ''), $data[$field_time]);
	if(empty($time) || $time == '-') {
		return null;
	} else {
		if(preg_match('/^(0{0,1}[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/',$time, $matches)) {
			return (strlen($time) == 5)? $time : '0'.$time;
		} else if(preg_match('/^0\.[0-9]+$/', $time)) {
			$hour = floor(24*$time);
			$mn = round((24*$time - $hour)*60);
			$mn = (strlen($mn) == 1)? '0'.$mn  : $mn ;
			if($mn == '60') {
				$mn = '00';
				$hour += 1;
			}
			if($hour > 23) die('ERR time >= 24 79904044--4-44');
			$time=$hour.':'.$mn;
			return (strlen($time) == 5)? $time : '0'.$time;
		} else {
			$import_summary[$summary_title]['@@ERROR@@']['Time Format Error'][] = "Format of time '$time' is not supported! [field '$field_time' - file '$file' ($worksheet) - line: $line]";
			return null;
		}
	}
}

function getDecimal($data, $field, $summary_title, $file, $worksheet, $line) {
	global $import_summary;
	if(!array_key_exists($field, $data)) die("ERR 238729873298 7eeee $field / $file / $worksheet / $line");
	$decimal_value = str_replace(array('x','ND'), array('',''), $data[$field]);
	if(strlen($decimal_value)) {
		if(preg_match('/^[0-9]+([\.,][0-9]+){0,1}$/', $decimal_value)) {
			return str_replace(',', '.', $decimal_value);
		} else {
			$import_summary[$summary_title]['@@ERROR@@']["Wrong decimal format for field '$field'"][] = "See value [$decimal_value]. [field '$field' - file '$file' ($worksheet) - line: $line]";
			return '';
		}
	} else {
		return '';
	}	
}

function dislayErrorAndMessage($import_summary) {
	if(empty($import_summary)) {
		echo "<br><br><FONT COLOR=\"blue\" >No Migration Message</FONT><br>";
	} else {
		$err_counter = 0;
		foreach($import_summary as $worksheet => $data1) {
			echo "<br><br><FONT COLOR=\"blue\" >
				=====================================================================<br>
				Errors on $worksheet<br>
				=====================================================================</FONT><br>";
			foreach($data1 as $message_type => $data2) {
				$color = 'black';
				switch($message_type) {
					case '@@ERROR@@':
						$color = 'red';
						break;
					case '@@WARNING@@':
						$color = 'orange';
						break;
					case '@@MESSAGE@@':
						$color = 'green';
						break;
					default:
						echo '<br><br><br>UNSUPORTED message_type : '.$message_type.'<br><br><br>';
				}
				foreach($data2 as $error => $details) {
					$err_counter++;
					$error = str_replace("\n", ' ', utf8_decode("[ER#$err_counter] $error"));
					echo "<br><br><FONT COLOR=\"$color\" ><b>$error</b></FONT><br>";
					foreach($details as $detail) {
						$detail = str_replace("\n", ' ', $detail);
						echo ' - '.utf8_decode($detail)."<br>";	
					}
				}
			}
		}
	}	
}

//==============================================================================================
// DEV Functions
//==============================================================================================

function truncate() {
	$truncate_queries = array(
			'TRUNCATE qcroc_ar_tissue_slides;', 'TRUNCATE qcroc_ar_tissue_slides_revs;',
			'TRUNCATE qcroc_spr_tissues;', 'TRUNCATE qcroc_spr_tissues_revs;',
			'DELETE FROM aliquot_review_masters;', 'DELETE FROM aliquot_review_masters_revs;',
			'DELETE FROM specimen_review_masters;', 'DELETE FROM specimen_review_masters_revs;',
			
			'TRUNCATE aliquot_internal_uses;', 'TRUNCATE aliquot_internal_uses_revs;',
			'TRUNCATE realiquotings;', 'TRUNCATE realiquotings_revs;',
			'TRUNCATE quality_ctrls;', 'TRUNCATE quality_ctrls_revs;',
			'TRUNCATE source_aliquots;', 'TRUNCATE source_aliquots_revs;',
				
			'TRUNCATE ad_blocks;', 'TRUNCATE ad_blocks_revs;',
			'TRUNCATE ad_whatman_papers;', 'TRUNCATE ad_whatman_papers_revs;',
			'TRUNCATE ad_tubes;', 'TRUNCATE ad_tubes_revs;',
			'TRUNCATE ad_tissue_slides;', 'TRUNCATE ad_tissue_slides_revs;',
			'DELETE FROM aliquot_masters;', 'DELETE FROM aliquot_masters_revs;',

			'TRUNCATE sd_der_dnas;', 'TRUNCATE sd_der_dnas_revs;',
			'TRUNCATE sd_der_rnas;', 'TRUNCATE sd_der_rnas_revs;',
			'TRUNCATE sd_der_urine_cents;', 'TRUNCATE sd_der_urine_cents_revs;',
			'TRUNCATE sd_spe_urines;', 'TRUNCATE sd_spe_urines_revs;',
			'TRUNCATE sd_der_plasmas;', 'TRUNCATE sd_der_plasmas_revs;',
			'TRUNCATE sd_der_pbmcs;', 'TRUNCATE sd_der_pbmcs_revs;',
			'TRUNCATE sd_der_serums;', 'TRUNCATE sd_der_serums_revs;',
			'TRUNCATE sd_spe_tissues;', 'TRUNCATE sd_spe_tissues_revs;',
			'TRUNCATE sd_spe_bloods;', 'TRUNCATE sd_spe_bloods_revs;',
			'TRUNCATE specimen_details;', 'TRUNCATE specimen_details_revs;',
			'TRUNCATE derivative_details;', 'TRUNCATE derivative_details_revs;',
			'UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null;',
			'DELETE FROM sample_masters;', 'DELETE FROM sample_masters_revs;',

			'DELETE FROM collections;', 'DELETE FROM collections_revs;',
			
			'TRUNCATE std_nitro_locates;', 'TRUNCATE std_nitro_locates_revs;',
			'TRUNCATE std_fridges;', 'TRUNCATE std_fridges_revs;',
			'TRUNCATE std_freezers;', 'TRUNCATE std_freezers_revs;',
			'TRUNCATE std_boxs;', 'TRUNCATE std_boxs_revs;',
			'TRUNCATE std_racks;', 'TRUNCATE std_racks_revs;',
			'UPDATE storage_masters SET parent_id = null;',
			'DELETE FROM storage_masters;', 'DELETE FROM storage_masters_revs;',

			'TRUNCATE misc_identifiers;', 'TRUNCATE misc_identifiers_revs;',
			'DELETE FROM participants;','DELETE FROM participants_revs;'
	);
	foreach($truncate_queries as $query) customQuery($query, __FILE__, __LINE__);
}

?>