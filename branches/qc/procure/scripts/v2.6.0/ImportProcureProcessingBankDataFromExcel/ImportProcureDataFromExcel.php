<?php

require_once 'Files/Inventory.php';

set_time_limit('3600');

//==============================================================================================
// Variables
//==============================================================================================

global $patients_to_import;
//TODO set to empty
$patients_to_import = array();

//$patients_to_import = array();
$files_name = array(
	'plasma' => 'Plasma-ATiM.xls',
	'urine' => 'Urine-ATiM.xls',
	'dna' => 'ADN-ATiM.xls'
);

foreach($files_name as $key => $val) $files_name[$key] = utf8_decode($val);

$files_path = 'C:\\_NicolasLuc\\Server\\www\\procure\\data\\ProcessingBankDataFiles\\';
$files_path = "/ATiM/todelete/Data/";
require_once 'Excel/reader.php';

global $import_summary;
$import_summary = array();

global $db_schema;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_charset		= "utf8";

$db_pwd			= "";
$db_schema		= "procureprocessing";


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

global $sample_storage_types;
$sample_storage_types = array(
	'plasma' => 'box100',
	'centrifuged urine' => 'box100',
	'dna' => 'box100 1A-10J'	
);

global $storage_master_ids;
$storage_master_ids = array();

global $last_storage_code;
$last_storage_code = 0;

global $participant_identifiers_check;
$participant_identifiers_check = array(
	'participant_identifier_to_id' => array(), 
	'procure_participant_attribution_number_to_id' => array());
	
echo "<br><br><FONT COLOR=\"blue\" >
=====================================================================<br>
PROCURE - Data Migration to ATiM - Processing Bank<br>
$import_date<br>
=====================================================================</FONT><br>";

if(!empty($patients_to_import)) echo "<br><br><FONT COLOR=\"red\" ><b>PROCESS LIMITED TO A SUBSET OF PATIENT (TEST CONFIGURATION)</b></font><br><br>";

truncate();
	
//==============================================================================================
//Inventory
//==============================================================================================

$study_summary_id = customInsert(array('title' => 'FRSQ-Innovant'), 'study_summaries', 'No File', '-1');

global $created_collections_and_specimens;
$created_collections_and_specimens = array();

echo "<br><FONT COLOR=\"green\" >*** Inventory (plasma) - File(s) : ".$files_name['plasma']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadPlasma($XlsReader, $files_path, $files_name['plasma'], $study_summary_id);

echo "<br><FONT COLOR=\"green\" >*** Inventory (urine) - File(s) : ".$files_name['urine']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadUrine($XlsReader, $files_path, $files_name['urine'], $study_summary_id);

echo "<br><FONT COLOR=\"green\" >*** Inventory (DNA) - File(s) : ".$files_name['dna']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadDna($XlsReader, $files_path, $files_name['dna'], $study_summary_id);

//codes and barcodes update

$query = "UPDATE sample_masters SET sample_code = id WHERE sample_code LIKE 'tmp##%';";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE sample_masters SET initial_specimen_sample_id = id WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_category = 'specimen');";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE storage_masters SET code = id;";
customQuery($query, __FILE__, __LINE__);
$query = "SELECT barcode FROM (SELECT barcode, count(*) AS tx FROM aliquot_masters WHERE deleted <> 1 GROUP BY barcode) AS test WHERE test.tx > 1;";
$results = customQuery($query, __FILE__, __LINE__);
while($row = $results->fetch_assoc()){
	$import_summary['Inventory - Tissue (V01)']['@@ERROR@@']['Duplicated Barcodes'][] = "The migration process created duplciated barcode : ".$row['barcode'];
}
$query = "UPDATE quality_ctrls SET qc_code = id;";
customQuery($query, __FILE__, __LINE__);

// *** SQL TO CHECK DATA INTEGRITY ***

$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT selection_label, CONCAT(storage_coord_x, '-', storage_coord_y) AS position_with_more_than_one_aliquot
	FROM (
		SELECT count(*) AS nbr_of_aliquots, storage_master_id, storage_coord_x, '' AS storage_coord_y FROM aliquot_masters WHERE storage_master_id IS NOT NULL AND storage_coord_x IS NOT NULL AND storage_coord_y IS NULL
		GROUP BY storage_master_id, storage_coord_x
		UNION All
		SELECT count(*) AS nbr_of_aliquots, storage_master_id, storage_coord_x, storage_coord_y FROM aliquot_masters WHERE storage_master_id IS NOT NULL AND storage_coord_x IS NOT NULL AND storage_coord_y IS NOT NULL
		GROUP BY storage_master_id, storage_coord_x, storage_coord_y
	) Res INNER JOIN storage_masters ON storage_master_id = id
	WHERE res.nbr_of_aliquots > 1;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT barcode as 'aliquot_not_in_stock_with_postion' FROM aliquot_masters WHERE in_stock = 'no' AND storage_master_id IS NOT NULL;";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT participant_identifier AS '### MESSAGE ### Wrong participant_identifier format to correct', id AS participant_id FROM participants WHERE deleted <> 1 AND participant_identifier NOT REGEXP'^PS[1-4]P0[0-9]+$';";
// $import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT barcode AS '### MESSAGE ### List of aliquots with missing concentration unit.'
// FROM aliquot_masters
// INNER JOIN ad_tubes ON id = aliquot_master_id
// WHERE deleted <> 1 AND concentration NOT LIKE '' AND concentration IS NOT NULL AND (concentration_unit IS NULL OR concentration_unit LIKE '');";
// $import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT count(*) AS '### MESSAGE ### Number of procure_total_quantity_ug values updated. To validate (revs data not updated).', concentration_unit
// FROM aliquot_masters, ad_tubes
// WHERE deleted <> 1 AND id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
// AND current_volume NOT LIKE '' AND current_volume IS NOT NULL
// AND concentration_unit IN ('ug/ul', 'ng/ul', 'pg/ul') GROUP BY concentration_unit;";
// $import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "UPDATE aliquot_masters, ad_tubes
// SET procure_total_quantity_ug = (current_volume*concentration/1000000)
// WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
// AND current_volume NOT LIKE '' AND current_volume IS NOT NULL
// AND concentration_unit = 'pg/ul';";
// $import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "UPDATE aliquot_masters, ad_tubes
// SET procure_total_quantity_ug = (current_volume*concentration/1000)
// WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
// AND current_volume NOT LIKE '' AND current_volume IS NOT NULL
// AND concentration_unit = 'ng/ul';";
// $import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "UPDATE aliquot_masters, ad_tubes
// SET procure_total_quantity_ug = (current_volume*concentration)
// WHERE id = aliquot_master_id AND concentration NOT LIKE '' AND concentration IS NOT NULL
// AND current_volume NOT LIKE '' AND current_volume IS NOT NULL
// AND concentration_unit = 'ug/ul';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT Participant.participant_identifier AS '### TODO ### : Wrong participant idenitifier format : to correct'
FROM participants Participant WHERE Participant.participant_identifier NOT REGEXP '^PS[1-4]P[0-9]{4}$';";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT Collection.id AS '### MESSAGE ### : Collections with no visit - Has to be corrected'
FROM collections Collection
WHERE Collection.deleted <> 1 AND (Collection.procure_visit IS NULL OR Collection.procure_visit LIKE '');";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT AliquotMaster.barcode AS '### MESSAGE ### : Aliquots not linked to a participant - Has to be corrected'
FROM aliquot_masters AliquotMaster
INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id
WHERE AliquotMaster.deleted <> 1 AND Collection.deleted <> 1 AND (Collection.participant_id IS NULL OR Collection.participant_id LIKE '');";
$import_summary['TODO']['@@WARNING@@']['SQL TO CHECK DATA INTEGRITY'][] = "SELECT 'Aliquot Barcode Control : Check barcodes match participant_identifier + visit (Correct data if list below is not empty)' AS '### MESSAGE ###';
SELECT CONCAT('AliquotMaster', '.', AliquotMaster.id) AS 'Model.id', Participant.participant_identifier, Collection.procure_visit, AliquotMaster.barcode
FROM participants Participant
INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1
WHERE Participant.deleted <> 1 AND AliquotMaster.barcode NOT REGEXP CONCAT('^', Participant.participant_identifier, '\ ', Collection.procure_visit, '\ ')
AND procure_created_by_bank != 'p';";

//==============================================================================================
//End of the process
//==============================================================================================

dislayErrorAndMessage($import_summary);

updateAliquotUseAndVolume();
insertIntoRevs();

$query = "UPDATE versions SET permissions_regenerated = 0;";
customQuery($query, __FILE__, __LINE__);

//==============================================================================================
// DEV Functions
//==============================================================================================

function insertIntoRevs() {
	global $import_date;
	global $import_by;
	$tables = array(
		'participants' => 0,
		
		'collections' => 0,
			
		'sample_masters' => 0,
		'specimen_details' => 1,
		'derivative_details' => 1,
		'sd_spe_bloods' => 1,
		'sd_der_plasmas' => 1,
 		'sd_der_pbmcs' => 1,
 		'sd_der_dnas' => 1,
		'sd_spe_urines' => 1,
		'sd_der_urine_cents' => 1,
		
		'aliquot_masters' => 0,
		'ad_tubes' => 1,
	
		'aliquot_internal_uses' => 0,	
		'source_aliquots' => 0	,
		'realiquotings' => 0,
		'quality_ctrls' => 0,

		'study_summaries' => 0,
		'orders' => 0,
		'shipments' => 0,
		'order_items' => 0,

		'storage_masters' => 0,
		'std_nitro_locates' => 1,
		'std_fridges' => 1,
		'std_freezers' => 1,
		'std_boxs' => 1,		
		'std_racks' => 1
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

function loadATiMControlData(){
	$controls = array();
	// MiscIdentifierControl
	$query = "select id, misc_identifier_name, flag_unique FROM misc_identifier_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['MiscIdentifierControl'][$row['misc_identifier_name']] = array('id' => $row['id'], 'flag_unique' => $row['flag_unique']);
	}
	// ConsentControl
	$query = "SELECT id, controls_type, detail_tablename FROM consent_controls WHERE flag_active = 1;";
	$results =customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$controls['ConsentControl'][$row['controls_type']] = array('id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	// EventControl
	$query = "select id,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['EventControl'][$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	// TreatmentControl
	$query = "select tc.id, tc.tx_method, tc.detail_tablename, te.id as te_id, te.detail_tablename as te_detail_tablename
		from treatment_controls tc
		LEFT JOIN treatment_extend_controls te ON tc.treatment_extend_control_id = te.id AND te.flag_active = '1'
		where tc.flag_active = '1';";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['TreatmentControl'][$row['tx_method']] = array(
				'treatment_control_id' => $row['id'],
				'detail_tablename' => $row['detail_tablename'],
				'te_treatment_control_id' => $row['te_id'],
				'te_detail_tablename' => $row['te_detail_tablename'],
		);
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
	return $controls;
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
	}
	pr('-------------------------------------------------------------------------------------------------------------------------------------');
	$counter = 0;
	foreach(debug_backtrace() as $debug_data) {
		$counter++;
		pr("$counter- Function ".$debug_data['function']."() [File: ".$debug_data['file']." - Line: ".$debug_data['line']."]");
	}
	pr('-------------------------------------------------------------------------------------------------------------------------------------');
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
	
	return $record_id;
}

function getDateAndAccuracy($data, $field, $data_type, $file, $line) {
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
		$import_summary[$data_type]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [field <b>$field</b> - file <b>$file</b> - line: <b>$line</b>]";
		return array('date' => null, 'accuracy' =>null);
	}	
}

function getDecimal($data, $field, $data_type, $file_name, $line_counter) {
	global $import_summary;
	if(!array_key_exists($field, $data)) die("ERR 238729873298 7eeee $field $file_name, $line_counter");
	$decimal_value = str_replace(array('x', 'X', '?', '-', '­', 'n/a', 'N/A', 'N/D'), array('','','', '', '', '', '', ''), $data[$field]);
	if(strlen($decimal_value)) {
		if(preg_match('/^[0-9]+([\.,][0-9]+){0,1}$/', $decimal_value)) {
			return str_replace(',', '.', $decimal_value);
		} else {
			$import_summary[$data_type]['@@ERROR@@']["Wrong decimal format for field '$field'"][] = "See value [".$data[$field]."]. [field <b>$field</b> - file <b>$file_name</b> - line: <b>$line_counter</b>]";
			return '';
		}
	} else {
		return '';
	}	
}

function getInteger($data, $field, $data_type, $file_name, $line_counter) {
	global $import_summary;
	if(!array_key_exists($field, $data)) die("ERR 238729873298 7eeee $field $file_name, $line_counter");
	$integer_value = str_replace(array('x', 'X', '?', '-', '­', 'n/a', 'N/A', 'N/D'), array('','','', '', '', '', '', ''), $data[$field]);
	if(strlen($integer_value)) {
		if(preg_match('/^[0-9]+$/', $integer_value)) {
			return $integer_value;
		} else {
			$import_summary[$data_type]['@@ERROR@@']["Wrong integer format for field '$field'"][] = "See value [".$data[$field]."]. [field <b>$field</b> - file <b>$file_name</b> - line: <b>$line_counter</b>]";
			return '';
		}
	} else {
		return '';
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
		'DELETE FROM  order_items;', 'DELETE FROM  order_items_revs;',	
		'DELETE FROM  shipments;', 'DELETE FROM  shipments_revs;',	
		'DELETE FROM  orders;', 'DELETE FROM  orders_revs;',	
			
  		'TRUNCATE aliquot_internal_uses;', 'TRUNCATE aliquot_internal_uses_revs;',
  		'TRUNCATE quality_ctrls;', 'TRUNCATE quality_ctrls_revs;',
  		'TRUNCATE source_aliquots;', 'TRUNCATE source_aliquots_revs;',
  		'TRUNCATE realiquotings;', 'TRUNCATE realiquotings_revs;',

		'TRUNCATE ad_blocks;', 'TRUNCATE ad_blocks_revs;',
 		'TRUNCATE ad_tubes;', 'TRUNCATE ad_tubes_revs;',
 		'DELETE FROM aliquot_masters;', 'DELETE FROM aliquot_masters_revs;',

  		'TRUNCATE sd_der_rnas;', 'TRUNCATE sd_der_rnas_revs;',
  		'TRUNCATE sd_der_dnas;', 'TRUNCATE sd_der_dnas_revs;',
  		'TRUNCATE sd_der_pbmcs;', 'TRUNCATE sd_der_pbmcs_revs;',
  		'TRUNCATE sd_der_urine_cents;', 'TRUNCATE sd_der_urine_cents_revs;',
  		'TRUNCATE sd_spe_urines;', 'TRUNCATE sd_spe_urines_revs;',
  		'TRUNCATE sd_spe_tissues;', 'TRUNCATE sd_spe_tissues_revs;',
		'TRUNCATE sd_der_plasmas;', 'TRUNCATE sd_der_plasmas_revs;',
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
		
 		'DELETE FROM participants;','DELETE FROM participants_revs;',
					
		'DELETE FROM study_summaries;', 'DELETE FROM study_summaries_revs;'	
	);
	
	foreach($truncate_queries as $query) customQuery($query, __FILE__, __LINE__);
}

function updateAliquotUseAndVolume() {
	
	foreach(getViewCreateStatement() AS $table => $create_sql) {
		customQuery('DROP TABLE IF EXISTS '.$table, __FILE__, __LINE__);
		customQuery('DROP VIEW IF EXISTS '.$table, __FILE__, __LINE__);
		customQuery($create_sql, __FILE__, __LINE__);
	}
	foreach(getView() AS $table => $view_sql) {
		$queries = explode("UNION ALL", $view_sql);
		foreach($queries as $query){
			customQuery('INSERT INTO '.$table. '('.str_replace('%%WHERE%%', '', $query).')', __FILE__, __LINE__);
		}
	}

	//-A-Use counter
	$use_counters_updated = array();
	//Search all aliquots linked to at least one use and having use_counter = 0
	$tmp_sql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label, us.use_counter
		FROM aliquot_masters am
		INNER JOIN (SELECT count(*) AS use_counter, aliquot_master_id FROM view_aliquot_uses GROUP BY aliquot_master_id) us ON am.id = us.aliquot_master_id
		WHERE am.deleted <> 1 AND (am.use_counter IS NULL OR am.use_counter = 0)";
	$results = customQuery($tmp_sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$query = "UPDATE aliquot_masters SET use_counter = '".$row['use_counter']."' WHERE id = ".$row['aliquot_master_id'];
		customQuery($query, __FILE__, __LINE__);
	}
	//Search all unused aliquots having use_counter != 0
	$tmp_sql = "SELECT id AS aliquot_master_id, barcode, aliquot_label FROM aliquot_masters WHERE deleted <> 1 AND use_counter != 0 AND id NOT IN (SELECT DISTINCT aliquot_master_id FROM view_aliquot_uses);";
	$results = customQuery($tmp_sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$query = "UPDATE aliquot_masters SET use_counter = '".$row['use_counter']."' WHERE id = ".$row['aliquot_master_id'];
		customQuery($query, __FILE__, __LINE__);
	}	
	//Search all aliquots having use_counter != real use counter (from view_aliquot_uses)
	$tmp_sql = "SELECT am.id AS aliquot_master_id, am.barcode, am.aliquot_label,us.use_counter FROM aliquot_masters am INNER JOIN (SELECT aliquot_master_id, count(*) AS use_counter FROM view_aliquot_uses GROUP BY aliquot_master_id) us ON us.aliquot_master_id = am.id WHERE am.deleted <> 1 AND us.use_counter != am.use_counter;";
	$results = customQuery($tmp_sql, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$query = "UPDATE aliquot_masters SET use_counter = '".$row['use_counter']."' WHERE id = ".$row['aliquot_master_id'];
		customQuery($query, __FILE__, __LINE__);
	}
}

function getViewCreateStatement() {
	$data = array( 'view_aliquot_uses' => 
		"CREATE TABLE view_aliquot_uses (
			  id varchar(20) NOT NULL,
			  aliquot_master_id int NOT NULL,
			  use_definition varchar(50) NOT NULL DEFAULT '',
			  use_code varchar(250) NOT NULL DEFAULT '',
			  use_details VARchar(250) NOT NULL DEFAULT '',
			  used_volume decimal(10,5) DEFAULT NULL,
			  aliquot_volume_unit varchar(20) DEFAULT NULL,
			  use_datetime datetime DEFAULT NULL,
			  use_datetime_accuracy char(1) NOT NULL DEFAULT '',
			  duration VARCHAR(250) NOT NULL DEFAULT '',
			  duration_unit VARCHAR(250) NOT NULL DEFAULT '',
			  used_by VARCHAR(50) DEFAULT NULL,
			  created datetime NOT NULL,
			  detail_url varchar(250) NOT NULL DEFAULT '',
			  sample_master_id int(11) NOT NULL,
			  collection_id int(11) NOT NULL,
			  study_summary_id int(11) DEFAULT NULL,
			  procure_created_by_bank char(1) DEFAULT '')");
	return $data;
	
}
function getView() {
	
	$data = array( 'view_aliquot_uses' => 
	"SELECT CONCAT(AliquotInternalUse.id,6) AS id,
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
		AliquotInternalUse.study_summary_id AS study_summary_id,
AliquotInternalUse.procure_created_by_bank AS procure_created_by_bank
		FROM aliquot_internal_uses AS AliquotInternalUse
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotInternalUse.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(SourceAliquot.id,1) AS `id`,
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
		'-1' AS study_summary_id,
SampleMaster.procure_created_by_bank AS procure_created_by_bank
		FROM source_aliquots AS SourceAliquot
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
		JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
		WHERE SourceAliquot.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(Realiquoting.id ,2) AS id,
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
		'-1' AS study_summary_id,
AliquotMasterChild.procure_created_by_bank AS procure_created_by_bank
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(QualityCtrl.id,3) AS id,
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
		'-1' AS study_summary_id,
QualityCtrl.procure_created_by_bank AS procure_created_by_bank
		FROM quality_ctrls AS QualityCtrl
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE QualityCtrl.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(OrderItem.id,4) AS id,
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
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id,
'p' AS procure_created_by_bank
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		JOIN `orders` AS `Order` ON  Order.id = OrderItem.order_id
		WHERE OrderItem.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(AliquotReviewMaster.id,5) AS id,
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
		'-1' AS study_summary_id,
'' AS procure_created_by_bank
		FROM aliquot_review_masters AS AliquotReviewMaster
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
		JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotReviewMaster.deleted <> 1 %%WHERE%%");
	return $data;
}

?>