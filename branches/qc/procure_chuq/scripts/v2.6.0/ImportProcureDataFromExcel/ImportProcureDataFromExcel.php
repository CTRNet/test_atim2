<?php

//TODO: Supprimer le contenu de toute cellule égale à '¯' ou égale à '­', ' ­' dans Inventaire et RNA files et patho
//TODO: Dans patho, formater vol. prost. Atteint en % en text standard
require_once 'Files/ClinicalAnnotation.php';
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
	'patient' => 'Patients_v20150420.xls',
		'patient_status' => '20150619_copie deces juin 2015.xls',
		'consent' => '20150619_5-05-2015Copie de consentement_v20150420.xls',
	'psa' => utf8_decode('revis_30_mars_2015_APS_et_traitements_v20150420.xls'),	
	'treatment' => utf8_decode('revis_30_mars_2015_APS_et_traitements_v20150420.xls'),	
		'frozen block' => '20150619_copie taille tissus juin 2015.xls',
		'paraffin block' => '20150619_copie de sortie de blocs procure juin 2015.xls',
		'inventory' => utf8_decode('20150619_copie inventaire procure CHU Quebec juin 2015.xls'),
	'arn' => 'ARN_sang_paxgene_v20150420.xls',
		
	'biopsy' => '20150619_Copie de Biopsies.xls',
	'patho' => '20150619_patho ATIM juin 2015 pour Nicolas.xls'
);
$files_path = 'C:\\_Perso\\Server\\procure_chuq\\data\\';
$files_path = "/ATiM/todelete/ImportProcureDataFromExcel/data/";
require_once 'Excel/reader.php';

global $import_summary;
$import_summary = array();

global $db_schema;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_charset		= "utf8";

$db_pwd			= "am3-y-4606";
$db_schema	= "procurechuqtmp";


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
	'tissue' => 'box27 1A-9C',
	'serum' => 'box81',
	'plasma' => 'box81',
	'pbmc' => 'box81',
	'whatman' => 'box',
	'urine' => 'box49 1A-7G',
	'concentrated urine' => 'box81',
	'rna' => 'box81'
);

global $storage_master_ids;
$storage_master_ids = array();

global $last_storage_code;
$last_storage_code = 0;

echo "<br><br><FONT COLOR=\"blue\" >
=====================================================================<br>
PROCURE - Data Migration to ATiM<br>
$import_date<br>
=====================================================================</FONT><br>";

echo "<br><FONT COLOR=\"red\" ><b>Check all dates in excel have been formated to date format 2000-00-00 (including treatment worksheet)</b></FONT><br><br>";

//TODO
truncate();

//==============================================================================================
//Clinical Annotation
//==============================================================================================

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Patient - File(s) : ".$files_name['patient']." && ".$files_name['patient_status']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$patients_status = loadVitalStatus($XlsReader, $files_path, $files_name['patient_status']);
$XlsReader = new Spreadsheet_Excel_Reader();
$psp_nbr_to_participant_id_and_patho = loadPatients($XlsReader, $files_path, $files_name['patient'], $patients_status);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Consent & Questionnaire - File(s) : ".$files_name['consent']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadConsents($XlsReader, $files_path, $files_name['consent'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Biopy) : ".$files_name['biopsy']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadBiopsy($XlsReader, $files_path, $files_name['biopsy'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Patho - File(s) : ".$files_name['patho']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadPathos($XlsReader, $files_path, $files_name['patho'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - PSA - File(s) : ".$files_name['psa']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadPSAs($XlsReader, $files_path, $files_name['psa'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Treatment - File(s) : ".$files_name['treatment']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$created_prostatectomy = loadTreatments($XlsReader, $files_path, $files_name['treatment'], $psp_nbr_to_participant_id_and_patho);

//==============================================================================================
//Inventory
//==============================================================================================

echo "<br><FONT COLOR=\"green\" >*** Inventory (Tissue) - File(s) : ".$files_name['frozen block']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$psp_nbr_to_frozen_blocks_data = loadFrozenBlock($XlsReader, $files_path, $files_name['frozen block']);

echo "<br><FONT COLOR=\"green\" >*** Inventory (Tissue) - File(s) : ".$files_name['paraffin block']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$psp_nbr_to_paraffin_blocks_data = loadParaffinBlock($XlsReader, $files_path, $files_name['paraffin block']);

echo "<br><FONT COLOR=\"green\" >*** Inventory - File(s) : ".$files_name['inventory']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadInventory($XlsReader, $files_path, $files_name['inventory'], $psp_nbr_to_frozen_blocks_data, $psp_nbr_to_paraffin_blocks_data, $psp_nbr_to_participant_id_and_patho, $created_prostatectomy);
unset($psp_nbr_to_frozen_blocks_data);
unset($psp_nbr_to_paraffin_blocks_data);
unset($created_prostatectomy);

echo "<br><FONT COLOR=\"green\" >*** Inventory - File(s) : ".$files_name['arn']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadRNA($XlsReader, $files_path, $files_name['arn']);

//codes and barcodes update

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
	$import_summary['Inventory - Tissue (V01)']['@@ERROR@@']['Duplicated Barcodes'][] = "The The migration process created duplciated barcode : ".$row['barcode'];
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

function insertIntoRevs() {
	global $import_date;
	global $import_by;
		
	$tables = array(
		'participants' => 0,
		'misc_identifiers' => 0,
			
		'consent_masters' => 0,
		'procure_cd_sigantures' => 1,
		
		'event_masters' => 0,
		'procure_ed_lifestyle_quest_admin_worksheets' => 1,
		'procure_ed_clinical_followup_worksheet_aps' => 1,
		'procure_ed_lab_pathologies' => 1,

		'treatment_masters' => 0,
		'procure_txd_medication_drugs' => 1,
		'procure_txd_followup_worksheet_treatments' => 1,
		
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

		'quality_ctrls' => 0,
	
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


function getDateTimeAndAccuracy($data, $field_date, $field_time, $data_type, $file, $line) {
	global $import_summary;
	if(!array_key_exists($field_time, $data)) die("ERR 238729873298 732 $field $file, $line");
	$time = str_replace(array(' ', 'N/A', 'n/a', 'x', '??', '?', 'X'), array('', '', '', '', '', '', '', ''), $data[$field_time]);
	//Get Date
	$tmp_date = getDateAndAccuracy($data, $field_date, $data_type, $file, $line);
	if(!$tmp_date['date']) {
		if(strlen($time) && $time != '-') $import_summary[$data_type]['@@ERROR@@']['DateTime: Only time is set'][] = "See following fields details. [fields <b>$field_date</b> & <b>$field_time</b> - file <b>$file</b> - line: <b>$line</b>]";
		return array('datetime' => null, 'accuracy' =>null);
	} else {
		$formatted_date = $tmp_date['date'];
		$formatted_date_accuracy = $tmp_date['accuracy'];
		//Combine date and time
		if(!strlen($time) || $time == '-' || $time == '­') {
			return array('datetime' => $formatted_date.' 00:00', 'accuracy' => str_replace('c', 'h', $formatted_date_accuracy));
		} else {
			if($formatted_date_accuracy != 'c') {
				$import_summary[$data_type]['@@ERROR@@']['Time set for an unaccuracy date'][] = "Date and time are set but date is unaccuracy. No datetime will be set! [fields <b>$field_date</b> & <b>$field_time</b> - file <b>$file</b> - line: <b>$line</b>]";
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
				$import_summary[$data_type]['@@ERROR@@']['Time Format Error (1)'][] = "Format of time '".$data[$field_time]."' is not supported! [field <b>$field_time</b> - file <b>$file</b> - line: <b>$line</b>]";
				return array('datetime' => null, 'accuracy' =>null);;
			}
		}
	}
}

function getTime($data, $field_time, $data_type, $file, $line) {
	global $import_summary;
	if(!array_key_exists($field_time, $data)) die("ERR 238729873298 732 $field $file, $line");
	$time = str_replace(array(' ', 'N/A', 'n/a', 'x', '??', '?', 'X'), array('', '', '', '', '', '', '', ''), $data[$field_time]);
	if(!strlen($time) || $time == '-' || $time == '­') {
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
			$import_summary[$data_type]['@@ERROR@@']['Time Format Error (2)'][] = "Format of time '".$data[$field_time]."' is not supported! [field <b>$field_time</b> - file <b>$file</b> - line: <b>$line</b>]";
			return null;
		}
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
			
		'TRUNCATE std_nitro_locates;', 'TRUNCATE std_nitro_locates_revs;',
		'TRUNCATE std_fridges;', 'TRUNCATE std_fridges_revs;',
		'TRUNCATE std_freezers;', 'TRUNCATE std_freezers_revs;',
		'TRUNCATE std_boxs;', 'TRUNCATE std_boxs_revs;',
		'TRUNCATE std_racks;', 'TRUNCATE std_racks_revs;',
		'UPDATE storage_masters SET parent_id = null;',
		'DELETE FROM storage_masters;', 'DELETE FROM storage_masters_revs;',
			
		'TRUNCATE procure_txd_medication_drugs;', 'TRUNCATE procure_txd_medication_drugs_revs;',
		'TRUNCATE procure_txd_followup_worksheet_treatments;', 'TRUNCATE procure_txd_followup_worksheet_treatments_revs;',
		'DELETE FROM treatment_masters;', 'DELETE FROM treatment_masters_revs;',
		
		'TRUNCATE procure_ed_lab_diagnostic_information_worksheets;', 'TRUNCATE procure_ed_lab_diagnostic_information_worksheets_revs;',
		'TRUNCATE procure_ed_lab_pathologies;', 'TRUNCATE procure_ed_lab_pathologies_revs;',
		'TRUNCATE procure_ed_clinical_followup_worksheet_aps;', 'TRUNCATE procure_ed_clinical_followup_worksheet_aps_revs;',
		'TRUNCATE procure_ed_lifestyle_quest_admin_worksheets;', 'TRUNCATE procure_ed_lifestyle_quest_admin_worksheets_revs;',
		'DELETE FROM event_masters;', 'DELETE FROM event_masters_revs;',
		'DELETE FROM event_masters WHERE event_control_id = 54;', 'DELETE FROM event_masters_revs WHERE event_control_id = 54;',
		
		'TRUNCATE procure_cd_sigantures;', 'TRUNCATE procure_cd_sigantures_revs;',
		'DELETE FROM consent_masters;', 'DELETE FROM consent_masters_revs;',

		'TRUNCATE misc_identifiers;', 'TRUNCATE misc_identifiers_revs;',
		'DELETE FROM participants;','DELETE FROM participants_revs;'
	);
	
	foreach($truncate_queries as $query) customQuery($query, __FILE__, __LINE__);
}

?>