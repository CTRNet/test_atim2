<?php

	/*
	 * STEP 3 OF PROCURE ICM DIVISION
	 * 
	 * To RUN after TissuBlock_PathoData_CleanUp.php
	 * 
	 * Will sdd new prostate tissu blocks from teodora files
	 */


//-- EXCEL FILE ---------------------------------------------------------------------------------------------------------------------------

$file_path = "C:/_Perso/Server/icm/data/Selection blocs paraffine - ProCure - NL.xls";

require_once 'Excel/reader.php';

$XlsReader = new Spreadsheet_Excel_Reader();
$XlsReader->read($file_path);

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "127.0.0.1";
$db_port 		= "3306";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "icm";
$db_charset		= "utf8";

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_connection;

$db_connection = @mysqli_connect(
		$db_ip.":".$db_port,
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

foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;

// Load data from : Données clinico-pathologiques

$headers = array();
$line_counter = 0;
foreach($XlsReader->sheets[$sheets_nbr[utf8_decode('2013')]]['cells'] as $line => $new_line) {
	$line_counter++;
	if($line_counter == 1) {
		$headers = $new_line;
	} else {
		$new_line_data = formatNewLineData($headers, $new_line);
		loadNewBlocks($new_line_data, $line_counter);	
		exit;
	}
}

function loadNewBlocks($new_line_data, $line) {
	global $db_connection;
	
	$participant_id  = getParticipantId($new_line_data, $line);
	if($participant_id) {
		$query = "SELECT am.id, am.aliquot_label, bl.sample_position_code, am.notes FROM aliquot_masters am INNER JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
			 WHERE bl.sample_position_code != '' AND bl.sample_position_code IS NOT NULL AND am.deleted != 1;";
		$new_block_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		
		
		
		SELECT col.bank_id, 
			sm.qc_nd_sample_label, 
			am.id aliquot_master_id, am.aliquot_label, am.study_summary_id,
			bl.block_type, bl.patho_dpt_block_code, bl.sample_position_code , bl.tumor_presence
		FROM collections col
		INNER JOIN sample_masters sm ON col.id = sm.collection_id
		INNER JOIN sample_controls sc ON sc.id = sm.sample_control_id AND sc.sample_type = 'tissue'
		INNER JOIN aliquot_masters am ON sm.id = am.sample_master_id
		INNER JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
		LIMIT 0,10
		
		aucun parafin ne devrait être créé
		
		
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

function getParticipantId($new_line_data, $line) {
	global $db_connection;
	if(!isset($new_line_data['# prostate bank'])) die('Missing Field # prostate bank');
	$identifier_value = $new_line_data['# prostate bank'];
	$query = "SELECT participant_id FROM misc_identifiers WHERE deleted != 1 AND misc_identifier_control_id = 5 AND identifier_value = '3$identifier_value';";
	$participant_id_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	$participant_id = mysqli_fetch_assoc($participant_id_res);
	return ($participant_id && $participant_id['participant_id'])? $participant_id['participant_id'] : false;
	
}




	//-- Clean up sample_position_code ---------------------------------------------------------------------------------------------------------------------------
/*
	$query = "SELECT am.id, am.aliquot_label, bl.sample_position_code, am.notes FROM aliquot_masters am INNER JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
		 WHERE bl.sample_position_code != '' AND bl.sample_position_code IS NOT NULL AND am.deleted != 1;";
	$new_block_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	while($new_block = mysqli_fetch_assoc($new_block_res)) {
		$aliquot_master_id = $new_block['id'];
		$aliquot_label = $new_block['aliquot_label'];
		$sample_position_code = $new_block['sample_position_code'];
		$notes = $new_block['notes'];
		
		$studied_data_key = "sample_position_code = [<b>$sample_position_code</b>]";
		
		if(preg_match('/^[0-9]+$/', $sample_position_code)) continue;
		
		if(preg_match('/^\ {0,1}([0-9]+)\ {0,1}-\ {0,1}([LR][AP])\ {0,1}$/', $sample_position_code, $matches)) {
			$new_sample_position_code = $matches[1];
			$new_procure_origin_of_slice = $matches[2];
			$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET sample_position_code = '$new_sample_position_code', procure_origin_of_slice = '$new_procure_origin_of_slice' WHERE aliquot_master_id = $aliquot_master_id;";
		} else if(preg_match('/^\ {0,1}([0-9]+)\ {0,1}-{0,1}\ {0,1}(.+)$/', $sample_position_code, $matches)) {
			$new_sample_position_code = $matches[1];
			$new_note = ' Sample Position Precision : '.$matches[2].'.';
			if($notes) {
				$queries_to_update[$step][$studied_data_key][] = "UPDATE aliquot_masters SET notes = CONCAT(notes, '$new_note') WHERE id = $aliquot_master_id;";
			} else {
				$queries_to_update[$step][$studied_data_key][] = "UPDATE aliquot_masters SET notes = '$new_note' WHERE id = $aliquot_master_id;";
			}
			$queries_to_update[$step][$studied_data_key][] = "UPDATE view_aliquots SET has_notes = 'y' WHERE aliquot_master_id = $aliquot_master_id;";
			$queries_to_update[$step][$studied_data_key][] = "UPDATE ad_blocks SET sample_position_code = '$new_sample_position_code' WHERE aliquot_master_id = $aliquot_master_id;";
			pr_msg('message',"Added new note [$new_note] from block Position Code  ($sample_position_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
		} else {
			die("Unable to work on block Position Code ($sample_position_code). See aliquot $aliquot_label (syst. code : $aliquot_master_id)");
		}
	}
		
	foreach($queries_to_update[$step] as $query_set) {
		foreach($query_set as $query) mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	}
*/	

	
	echo "****************** PROCESS DONE ******************************<br><br><br>";
	
	echo "--------------------------------------------------------------------------------------------------------------------------<br><br><br>";
	
	echo "****************** QUERIES SUMMARY ******************************<br>";
	

	
	
	//====================================================================================================================================================
	
function pr_msg($type, $msg) {
	$font = 'black';
	switch($type) {
		case 'error':
			$font = 'red';
			break;
		case 'warning':
			$font = '#E56717';
			break;
		case 'message':
			$font = 'green';
			break;
	}
	pr("<FONT color='$font'>$msg</FONT>");
}
	
function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

function formatNewLineData($headers, $data) {
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

?>