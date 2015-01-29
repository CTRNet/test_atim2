<?php

require_once 'Files/Inventory.php';

set_time_limit('3600');

//==============================================================================================
// Variables
//==============================================================================================

$files_name = array(
	'tissue' => 'Q-CROC-01 Tissue data v9_20150128.xls',
	'blood' => 'Q-CROC-01 Blood Data v5_20150128.xls'
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

global $sample_code;
$sample_code = 0;

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

//TODO remove
populateViewsAndLftRght();

//==============================================================================================
//BARCODES UPDATE
//==============================================================================================

$query = "UPDATE sample_masters SET sample_code = id;";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE sample_masters SET initial_specimen_sample_id = id WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_category = 'specimen');";
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
// 	//StorageControl
// 	$query = "SELECT id as storage_control_id, storage_type, detail_tablename, coord_x_type,coord_x_size,coord_y_type,coord_y_size FROM storage_controls WHERE flag_active = 1;";
// 	$results = customQuery($query, __FILE__, __LINE__);
// 	while($row = $results->fetch_assoc()) {
// 		$controls['storage_controls'][$row['storage_type']] = $row;
// 	}
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
		
		'aliquot_masters' => 0,
		'ad_tubes' => 1,
		'ad_whatman_papers' => 1,
		'ad_blocks' => 1,
	
		'aliquot_internal_uses' => 0,	
		'source_aliquots' => 0	,

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
	$date = str_replace(array(' ', 'N/A', 'n/a', 'x', '??'), array('', '', '', '', '', ''), $data[$field]);
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
	$tmp_date = getDateAndAccuracy($data, $field_date, $summary_title, $file, $line);
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
	$decimal_value = str_replace('x', '', $data[$field]);
	if(strlen($decimal_value)) {
		if(preg_match('/^[0-9]+([\.,][0-9]+){0,1}$/', $decimal_value)) {
			return str_replace(',', '.', $decimal_value);
		} else {
			$import_summary[$summary_title]['@@ERROR@@']["Wrong decimal format for field '$field'"][] = "See value [$decimal_value]. [field '$field' - file '$file' ($worksheet) - line: $line]";
		}
	} else {
		return null;
	}	
}

function dislayErrorAndMessage($import_summary) {
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

//==============================================================================================
// DEV Functions
//==============================================================================================

function truncate() {
	$truncate_queries = array(
			'TRUNCATE aliquot_internal_uses;', 'TRUNCATE aliquot_internal_uses_revs;',
			'TRUNCATE quality_ctrls;', 'TRUNCATE quality_ctrls_revs;',
			'TRUNCATE source_aliquots;', 'TRUNCATE source_aliquots_revs;',
				
			'TRUNCATE ad_blocks;', 'TRUNCATE ad_blocks_revs;',
			'TRUNCATE ad_whatman_papers;', 'TRUNCATE ad_whatman_papers_revs;',
			'TRUNCATE ad_tubes;', 'TRUNCATE ad_tubes_revs;',
			'DELETE FROM aliquot_masters;', 'DELETE FROM aliquot_masters_revs;',

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

			'TRUNCATE misc_identifiers;', 'TRUNCATE misc_identifiers_revs;',
			'DELETE FROM participants;','DELETE FROM participants_revs;'
	);
	foreach($truncate_queries as $query) customQuery($query, __FILE__, __LINE__);
}

function populateViewsAndLftRght() {
//TODO remove view insert
	$query = "TRUNCATE view_collections;";
	customQuery($query, __FILE__, __LINE__);
	$query = "REPLACE INTO view_collections (SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
MiscIdentifier.identifier_value,
Collection.qcrcoc_misc_identifier_control_id,
Collection.qcrcoc_collection_type
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Collection.qcrcoc_misc_identifier_control_id AND MiscIdentifier.participant_id = Collection.participant_id AND MiscIdentifier.deleted <> 1
		WHERE Collection.deleted <> 1 )";
	customQuery($query, __FILE__, __LINE__);

	$query = "TRUNCATE view_samples;";
	customQuery($query, __FILE__, __LINE__);
	$query = 'REPLACE INTO view_samples (SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
	
		Collection.bank_id,
		Collection.sop_master_id,
		Collection.participant_id,
	
		Participant.participant_identifier,
	
		Collection.acquisition_label,
	
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
	
		IF(SpecimenDetail.reception_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR SpecimenDetail.reception_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > SpecimenDetail.reception_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, SpecimenDetail.reception_datetime))))) AS coll_to_rec_spent_time_msg,
		
		IF(DerivativeDetail.creation_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR DerivativeDetail.creation_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > DerivativeDetail.creation_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg,
MiscIdentifier.identifier_value,
Collection.qcrcoc_misc_identifier_control_id,
Collection.qcrcoc_collection_type
	
		FROM sample_masters AS SampleMaster
		INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON SpecimenDetail.sample_master_id=SampleMaster.id
		LEFT JOIN derivative_details AS DerivativeDetail ON DerivativeDetail.sample_master_id=SampleMaster.id
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Collection.qcrcoc_misc_identifier_control_id AND MiscIdentifier.participant_id = Collection.participant_id AND MiscIdentifier.deleted <> 1
		WHERE SampleMaster.deleted != 1)';
	customQuery($query, __FILE__, __LINE__);
return;
	$query = "TRUNCATE view_aliquots;";
	customQuery($query, __FILE__, __LINE__);
	$query = 'REPLACE INTO view_aliquots (SELECT
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id,
			Collection.bank_id,
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id,

			Participant.participant_identifier,

			Collection.acquisition_label,
Collection.procure_visit AS procure_visit,

			SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
			SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
			ParentSampleControl.sample_type AS parent_sample_type,
			ParentSampleMaster.sample_control_id AS parent_sample_control_id,
			SampleControl.sample_type,
			SampleMaster.sample_control_id,

			AliquotMaster.barcode,
			AliquotMaster.aliquot_label,
			AliquotControl.aliquot_type,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,

			StorageMaster.code,
			StorageMaster.selection_label,
			AliquotMaster.storage_coord_x,
			AliquotMaster.storage_coord_y,

			StorageMaster.temperature,
			StorageMaster.temp_unit,

			AliquotMaster.created,

			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(Collection.collection_datetime IS NULL, -1,
			 IF(Collection.collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(SpecimenDetail.reception_datetime IS NULL, -1,
			 IF(SpecimenDetail.reception_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(DerivativeDetail.creation_datetime IS NULL, -1,
			 IF(DerivativeDetail.creation_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,

			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes

			FROM aliquot_masters AS AliquotMaster
			INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
			INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
			LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
			LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
			LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
			WHERE AliquotMaster.deleted != 1)';
	customQuery($query, __FILE__, __LINE__);

	$query = "TRUNCATE view_aliquot_uses;";
	customQuery($query, __FILE__, __LINE__);
	$queries = array("SELECT CONCAT(AliquotInternalUse.id,6) AS id,
		AliquotMaster.id AS aliquot_master_id,
		AliquotInternalUse.type AS use_definition,
		AliquotInternalUse.use_code AS use_code,
		AliquotInternalUse.use_details AS use_details,
		AliquotInternalUse.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		AliquotInternalUse.use_datetime AS use_datetime,
		AliquotInternalUse.use_datetime_accuracy AS use_datetime_accuracy,
		AliquotInternalUse.duration AS duration,
		AliquotInternalUse.duration_unit AS duration_unit,
		AliquotInternalUse.used_by AS used_by,
		AliquotInternalUse.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detailAliquotInternalUse/',AliquotMaster.id,'/',AliquotInternalUse.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		AliquotInternalUse.study_summary_id AS study_summary_id
		FROM aliquot_internal_uses AS AliquotInternalUse
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotInternalUse.deleted <> 1",
			"SELECT CONCAT(SourceAliquot.id,1) AS `id`,
		AliquotMaster.id AS aliquot_master_id,
		CONCAT('sample derivative creation#', SampleMaster.sample_control_id) AS use_definition,
		SampleMaster.sample_code AS use_code,
		'' AS `use_details`,
		SourceAliquot.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		DerivativeDetail.creation_datetime AS use_datetime,
		DerivativeDetail.creation_datetime_accuracy AS use_datetime_accuracy,
		'' AS `duration`,
		'' AS `duration_unit`,
		DerivativeDetail.creation_by AS used_by,
		SourceAliquot.created AS created,
		CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
		SampleMaster2.id AS sample_master_id,
		SampleMaster2.collection_id AS collection_id,
		'-1' AS study_summary_id
		FROM source_aliquots AS SourceAliquot
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
		JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
		WHERE SourceAliquot.deleted <> 1",
			"SELECT CONCAT(Realiquoting.id ,2) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'realiquoted to' AS use_definition,
		AliquotMasterChild.barcode AS use_code,
		'' AS use_details,
		Realiquoting.parent_used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		Realiquoting.realiquoting_datetime AS use_datetime,
		Realiquoting.realiquoting_datetime_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		'-1' AS study_summary_id
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1",
			"SELECT CONCAT(QualityCtrl.id,3) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'quality control' AS use_definition,
		QualityCtrl.qc_code AS use_code,
		'' AS use_details,
		QualityCtrl.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		QualityCtrl.date AS use_datetime,
		QualityCtrl.date_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		QualityCtrl.run_by AS used_by,
		QualityCtrl.created AS created,
		CONCAT('/InventoryManagement/QualityCtrls/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',QualityCtrl.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		'-1' AS study_summary_id
		FROM quality_ctrls AS QualityCtrl
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE QualityCtrl.deleted <> 1",
			"SELECT CONCAT(OrderItem.id,4) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'aliquot shipment' AS use_definition,
		Shipment.shipment_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		Shipment.datetime_shipped AS use_datetime,
		Shipment.datetime_shipped_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		Shipment.shipped_by AS used_by,
		Shipment.created AS created,
		CONCAT('/Order/Shipments/detail/',Shipment.order_id,'/',Shipment.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		JOIN `orders` AS `Order` ON  Order.id = OrderLine.order_id
		WHERE OrderItem.deleted <> 1",
			"SELECT CONCAT(AliquotReviewMaster.id,5) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'specimen review' AS use_definition,
		SpecimenReviewMaster.review_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		SpecimenReviewMaster.review_date AS use_datetime,
		SpecimenReviewMaster.review_date_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		'' AS used_by,
		AliquotReviewMaster.created AS created,
		CONCAT('/InventoryManagement/SpecimenReviews/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',SpecimenReviewMaster.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		'-1' AS study_summary_id
		FROM aliquot_review_masters AS AliquotReviewMaster
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
		JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotReviewMaster.deleted <> 1");
	foreach($queries as $select_query) customQuery("REPLACE INTO view_aliquot_uses ($select_query);", __FILE__, __LINE__);
	//rebuild left right
	$left_rght_nxt = 1;
	$results = customQuery("SELECT id FROM storage_masters WHERE parent_id IS NULL;", __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		updateLftRgt($row['id'],$left_rght_nxt);
	}

}
function updateLftRgt($storage_master_id,&$left_rght_nxt) {
	//TODO remove
	$lft = $left_rght_nxt;
	$left_rght_nxt++;
	$results = customQuery("SELECT id FROM storage_masters WHERE parent_id = $storage_master_id;", __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		updateLftRgt($row['id'],$left_rght_nxt);
	}
	$rght = $left_rght_nxt;
	$left_rght_nxt++;
	customQuery("UPDATE storage_masters SET lft = '$lft', rght = '$rght' WHERE id = $storage_master_id;", __FILE__, __LINE__);
}

?>