<?php

	/*
	 * STEP 3 OF PROCURE ICM DIVISION
	 * 
	 * To RUN after TissuBlock_PathoData_CleanUp.php
	 * 
	 * Will sdd new prostate tissu blocks from teodora files
	 */


//-- EXCEL FILE ---------------------------------------------------------------------------------------------------------------------------

$file_name = "ChumHepatoProtocolDetail.xls";
$file_path = 'C:/_Perso/Server/chum_hepato/scripts/v2.6.0/cutom_post_261_script/'.$file_name;
require_once 'Excel/reader.php';

$XlsReader = new Spreadsheet_Excel_Reader();
$XlsReader->read($file_path);

set_time_limit('3600');

//-- DB PARAMETERS ---------------------------------------------------------------------------------------------------------------------------

$db_ip			= "127.0.0.1";
$db_port 		= "3306";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "chumhepato";
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

global $modified_by;

$modified_by = '9';

global $modified;

$query = "SELECT NOW() as modified;";
$modified_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}

global $messages;

$messages = array();

mysqli_query($db_connection, "DELETE FROM pe_chemos;") or die("query failed [3]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM pe_chemos_revs;") or die("query failed [4]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM protocol_extend_masters;") or die("query failed [5]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM protocol_extend_masters_revs;") or die("query failed [6]: " . mysqli_error($db_connection)."]");

//---TO REMOVE ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
mysqli_query($db_connection, "DELETE FROM pd_chemos WHERE protocol_master_id IN (SELECT id FROM protocol_masters WHERE created_by = $modified_by AND created > '2014-04-01');") or die("query failed [7]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM pd_chemos_revs WHERE protocol_master_id IN (SELECT id FROM protocol_masters WHERE created_by = $modified_by AND created > '2014-04-01');") or die("query failed [8]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM protocol_masters WHERE created_by = $modified_by AND created > '2014-04-01';") or die("query failed [9]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM protocol_masters_revs WHERE modified_by = $modified_by AND version_created > '2014-04-01';") or die("query failed [10]: " . mysqli_error($db_connection)."]");
//---TO REMOVE------------------------------------------------------------------------------------------------------------------------------------------------------------------------

mysqli_query($db_connection, "TRUNCATE txe_chemos;") or die("query failed [13]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "TRUNCATE txe_chemos_revs;") or die("query failed [14]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM treatment_extend_masters WHERE treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos');") or die("query failed [15]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM treatment_extend_masters_revs WHERE treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos');") or die("query failed [16]: " . mysqli_error($db_connection)."]");

mysqli_query($db_connection, "DELETE FROM drugs;") or die("query failed [1]: " . mysqli_error($db_connection)."]");
mysqli_query($db_connection, "DELETE FROM drugs_revs;") or die("query failed [2]: " . mysqli_error($db_connection)."]");

//control_id
$query = "SELECT id FROM protocol_controls WHERE type = 'chemotherapy';";
$res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($res);
$chemotherapy_protocol_control_id = $res['id'];

$query = "SELECT id FROM protocol_extend_controls WHERE detail_tablename = 'pe_chemos';";
$res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($res);
$pe_chemos_protocol_extend_control_id = $res['id'];

$query = "SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos';";
$res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$res = mysqli_fetch_assoc($res);
$txe_chemos_treatment_extend_control_id = $res['id'];

$chemotherapies_treatment_control_ids = array();
$query = "SELECT id FROM treatment_controls WHERE treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos');";
$res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
while($new_ctrl = mysqli_fetch_assoc($res)) $chemotherapies_treatment_control_ids[] = $new_ctrl['id'];

// Get old protocol

$old_protocol_data = array();
$query = "SELECT id, deleted, code FROM protocol_masters WHERE protocol_control_id = $chemotherapy_protocol_control_id;";
$res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
while($old_pr = mysqli_fetch_assoc($res)) {
	$old_protocol_data[$old_pr['code']] = array('id' => $old_pr['id'], 'deleted' => $old_pr['deleted']);
}

// Load protocol

$drug_ids = array();
$new_protocol_data = array();
$updated_new_protocol_master_ids = array();

$headers = array();
$line_counter = 0;
foreach($XlsReader->sheets[0]['cells'] as $line => $new_line) {
	$line_counter++;
	if($line_counter == 1) {
		$headers = $new_line;
	} else {
		$new_line_data = formatNewLineData($headers, $new_line);
		if($new_line_data['Type'] != 'chemotherapy') die('ERR 237 68327 6 8726 2');
		$old_protocol_name = $new_line_data['Nom Protocole'];
		$query = "SELECT id, deleted FROM protocol_masters WHERE (code = '$old_protocol_name' OR code = '$old_protocol_name ') AND protocol_control_id = $chemotherapy_protocol_control_id;";
		$res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		if($res->num_rows != 0) {
			unset($old_protocol_data[$old_protocol_name]);
			unset($old_protocol_data[$old_protocol_name.' ']);
			$test_old_protocol_master_ids = array();
			while($res_old_proto = mysqli_fetch_assoc($res)) {
				$old_protocol_master_id = $res_old_proto['id'];
				$test_old_protocol_master_ids[] = $old_protocol_master_id;
				if(!$res_old_proto['deleted']) {
					// ** 2 ** Manage New Protocol
					$new_protocol_name = $new_line_data['Nouveau Nom Protocole'];	
					$new_protocol_master_id = null;
					if(!array_key_exists($new_protocol_name, $new_protocol_data)) {
						//Create New Protocol
						$new_protocol_master_id = customInsertRecord(array('protocol_control_id' => $chemotherapy_protocol_control_id, 'code' => $new_line_data['Nouveau Nom Protocole']), 'protocol_masters');
						customInsertRecord(array('protocol_master_id' => $new_protocol_master_id), 'pd_chemos', true);
						$new_protocol_data[$new_protocol_name] = array('protocol_master_id' => $new_protocol_master_id, 'drugs' => array());
						//record drugs
						for ($i = 1; $i <= 5; $i++) {
							$drug = $new_line_data['Molecule-'.$i];
							if(strlen($drug)) {
								if(!array_key_exists($drug, $drug_ids)) {
									$drug_id = customInsertRecord(array('generic_name' => $drug), 'drugs');
									$drug_ids[$drug] = $drug_id;
								}
								$drug_id = $drug_ids[$drug];
								$protocol_extend_master_id = customInsertRecord(array('protocol_extend_control_id' => $pe_chemos_protocol_extend_control_id, 'protocol_master_id' => $new_protocol_master_id), 'protocol_extend_masters');
								customInsertRecord(array('protocol_extend_master_id' => $protocol_extend_master_id, 'drug_id' => $drug_id, 'method' => (($drug != 'Capecitabine')? 'IV: Intravenous' : 'p.o.: by mouth')), 'pe_chemos', true);
								$new_protocol_data[$new_protocol_name]['drugs'][] = $drug;
							}
						}
						asort($new_protocol_data[$new_protocol_name]['drugs']);
					} else {
						//New protocol already exists check drugs are the same
						$new_protocol_master_id = $new_protocol_data[$new_protocol_name]['protocol_master_id'];
						$tmp_drugs = array();
						for ($i = 1; $i <= 5; $i++) {
							$drug = $new_line_data['Molecule-'.$i];
							if(strlen($drug)) $tmp_drugs[] = $drug;
						}
						asort($tmp_drugs);
						if(array_diff($new_protocol_data[$new_protocol_name]['drugs'],$tmp_drugs) || array_diff($tmp_drugs, $new_protocol_data[$new_protocol_name]['drugs'])) {
							pr($new_protocol_name);
							pr($new_protocol_data[$new_protocol_name]);
							die('ERR 328 287687 6232');
						}
					}
					// ** 3 ** Erase Old Protocol
					$query = "UPDATE protocol_masters SET deleted = 1, modified = '$modified', modified_by = $modified_by  WHERE id = $old_protocol_master_id;";
					mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
					$updated_new_protocol_master_ids[$new_protocol_master_id] = $new_protocol_master_id;
					//Revs table updated below
					$tmp_updated_treatment_master_ids = array();
					$query = "SELECT id FROM treatment_masters WHERE protocol_master_id = $old_protocol_master_id AND deleted <> 1;";
					$ids_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
					while($ids_res2 = mysqli_fetch_assoc($ids_res)) $tmp_updated_treatment_master_ids[$ids_res2['id']] = $ids_res2['id'];
					if(!empty($tmp_updated_treatment_master_ids)) {
						$query = "UPDATE treatment_masters SET protocol_master_id = $new_protocol_master_id, modified = '$modified', modified_by = $modified_by WHERE id IN (".implode(',',$tmp_updated_treatment_master_ids).")";
						mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
						//Revs table updated below
echo("UPDATE treatment_masters SET protocol_master_id = $old_protocol_master_id WHERE protocol_master_id = $new_protocol_master_id;<br>");
echo("UPDATE protocol_masters SET deleted = 0 WHERE id = $old_protocol_master_id;<br>");
						for ($dg_nbr = 1; $dg_nbr <= 5; $dg_nbr++) {
							$drug = $new_line_data['Molecule-'.$dg_nbr];
							if(strlen($drug)) {
								$drug_id = $drug_ids[$drug];
								if(!$drug_id) die('ERR 237 682768 72362');
								$cycle = $new_line_data['Cycles-'.$dg_nbr];
								$query = "INSERT INTO treatment_extend_masters (`treatment_extend_control_id`, `treatment_master_id`, `modified`, `created`, `created_by`, `modified_by`)
									(SELECT $txe_chemos_treatment_extend_control_id, id, '$modified', '$modified', $modified_by, $modified_by FROM treatment_masters WHERE id IN (".implode(',',$tmp_updated_treatment_master_ids)."));";
								mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
								$query = "INSERT INTO txe_chemos (`drug_id`, `method`, `qc_hb_cycles`, `treatment_extend_master_id`) 
									(SELECT $drug_id, '".(($drug != 'Capecitabine')? 'IV: Intravenous' : 'p.o.: by mouth')."', '$cycle', treatment_extend_masters.id 
									FROM treatment_extend_masters WHERE treatment_master_id IN (".implode(',',$tmp_updated_treatment_master_ids).")
									AND id NOT IN (SELECT id FROM treatment_extend_masters INNER JOIN txe_chemos ON txe_chemos.treatment_extend_master_id = treatment_extend_masters.id WHERE treatment_master_id IN (".implode(',',$tmp_updated_treatment_master_ids).")))";
								mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");				
							}				
						}
					}
				} else {
					$messages[] =  "Msg #1: Protocole $old_protocol_name is a deleted protocol into ATiM (id=$old_protocol_master_id): Won't be processed";
					$query = "select count(*) as res from treatment_masters WHERE protocol_master_id = $old_protocol_master_id and deleted != 1;";
					$res2 = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
					$res2 = mysqli_fetch_assoc($res2);
					if($res2['res']) die('ERR 23876 823768 7326 2');
				}
			}
			if(sizeof($test_old_protocol_master_ids) > 1) {
				$messages[] =  "Msg #2: Protocole $old_protocol_name matches more than one protocol into ATiM (ids : ".implode(', ', $test_old_protocol_master_ids).")";
			}
		} else {
			$messages[] =  "Msg #3: Protocole $old_protocol_name (defined in excel file) does not exist into ATiM or is not a chemotherapy protocol : Won't be processed";
		}
	}
}


// Revs Table Update : Treatment
$query = "INSERT INTO treatment_masters_revs (`treatment_control_id`, `id`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `modified_by`, `version_created`)
	(SELECT `treatment_control_id`, `id`, `tx_intent`, `target_site_icdo`, `start_date`, `start_date_accuracy`, `finish_date`, `finish_date_accuracy`, `information_source`, `facility`, `notes`, `protocol_master_id`, `participant_id`, `diagnosis_master_id`, `modified_by`, `modified` FROM treatment_masters WHERE protocol_master_id IN (".implode(',',$updated_new_protocol_master_ids)."));";
mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$query ="INSERT INTO qc_hb_txd_others_revs (`treatment_master_id`, `type`, `version_created`) 
	(SELECT `id`, `modified` FROM treatment_masters INNER JOIN qc_hb_txd_others ON treatment_master_id = id WHERE protocol_master_id IN (".implode(',',$updated_new_protocol_master_ids)."));";
$query ="INSERT INTO txd_chemos_revs (`chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `qc_hb_treatment`, `qc_hb_reason_of_change`, `qc_hb_toxicity_complication`, `qc_hb_toxicity_complication_date`, `qc_hb_toxicity_complication_date_accuracy`, `qc_hb_tace_complication_treatment`, `treatment_master_id`, `version_created`) 
	(SELECT `chemo_completed`, `response`, `num_cycles`, `length_cycles`, `completed_cycles`, `qc_hb_treatment`, `qc_hb_reason_of_change`, `qc_hb_toxicity_complication`, `qc_hb_toxicity_complication_date`, `qc_hb_toxicity_complication_date_accuracy`, `qc_hb_tace_complication_treatment`, `id`, `modified` FROM treatment_masters INNER JOIN txd_chemos ON treatment_master_id = id WHERE protocol_master_id IN (".implode(',',$updated_new_protocol_master_ids)."));";
mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
// Revs Table Update : protocol
$query = "INSERT INTO protocol_masters_revs (`protocol_control_id`, `id`, `name`, `notes`, `code`, `arm`, `status`, `expiry`, `expiry_accuracy`, `activated`, `activated_accuracy`, `modified_by`, `form_id`, `version_created`)
	(SELECT `protocol_control_id`, `id`, `name`, `notes`, `code`, `arm`, `status`, `expiry`, `expiry_accuracy`, `activated`, `activated_accuracy`, `modified_by`, `form_id`, `modified` FROM protocol_masters WHERE deleted = 1 AND modified = '$modified' AND  modified_by = $modified_by AND protocol_control_id = $chemotherapy_protocol_control_id);";
mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$query = "INSERT INTO pd_chemos_revs (`protocol_master_id`, `version_created`) (SELECT `id`, `modified` FROM protocol_masters WHERE  deleted = 1 AND modified = '$modified' AND  modified_by = $modified_by AND protocol_control_id = $chemotherapy_protocol_control_id);";
mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
// Revs Table Update : Treatment_extend
$query = "INSERT INTO treatment_extend_masters_revs (`treatment_extend_control_id`, `treatment_master_id`, `modified_by`, `id`, `version_created`) 
	(SELECT `treatment_extend_control_id`, `treatment_master_id`, `modified_by`, `id`, `modified` FROM treatment_extend_masters);";
mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$query = "INSERT INTO `txe_chemos_revs` (`drug_id`, `method`, `qc_hb_cycles`, `treatment_extend_master_id`, `version_created`) 
	(SELECT `drug_id`, `method`, `qc_hb_cycles`, `treatment_extend_master_id`, `modified` FROM txe_chemos INNER JOIN treatment_extend_masters ON treatment_extend_masters.id = txe_chemos.treatment_extend_master_id)";
mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");

printMessages();
ksort($drug_ids);
ksort($new_protocol_data);
echo "<br><FONT color='red'><b> ---- created drugs -------------------------------------------</b></FONT><br><br>";
pr(implode('<br>',array_keys($drug_ids)).'<br>');
echo "<br><FONT color='red'><b> ---- created protocols -------------------------------------------</b></FONT><br><br>";
pr(implode('<br>',array_keys($new_protocol_data)).'<br>');
echo "<br><FONT color='red'><b> ---- ATiM protocol not defined in excel file (not processed) -------------------------------------------</b></FONT><br><br>";
$deleted = '';
$not_detled = '';
foreach($old_protocol_data as $code => $data) {
	if($data['deleted']) {
		$deleted .= "[$code] ".$data['id'].'<br>';
	} else {
		$not_detled .= "[$code] ".$data['id'].'<br>';
	}
}
pr('** not deleted **');
pr($not_detled);
pr('** deleted **');
pr($deleted);

echo "<br><FONT color='red'><b> ---- Queries for control -------------------------------------------</b></FONT><br><br>
select * from drugs;<br>
select * from drugs_revs;<br>
		
select count(*) FROM protocol_extend_masters;<br>
select count(*) FROM protocol_extend_masters_revs;<br>
select * FROM protocol_extend_masters LIMIT 0,20;<br>
select * FROM protocol_extend_masters_revs LIMIT 0,20;<br>
select count(*) FROM pe_chemos;<br>
select count(*) FROM pe_chemos_revs;<br>
select * FROM pe_chemos LIMIT 0,20;<br>
select * FROM pe_chemos_revs LIMIT 0,20;<br>
		
select count(*) FROM treatment_extend_masters WHERE treatment_extend_control_id IN (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos');<br>		
select count(*) FROM treatment_extend_masters_revs WHERE treatment_extend_control_id IN (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos');<br>		
select * FROM treatment_extend_masters WHERE treatment_extend_control_id IN (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos') LIMIT 0,20;<br>		
select * FROM treatment_extend_masters_revs WHERE treatment_extend_control_id IN (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos') LIMIT 0,20;<br>		
SELECT * FROM treatment_extend_masters WHERE ID NOT IN (select treatment_extend_master_id FROM txe_chemos) AND treatment_extend_control_id IN (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos');<br>		
select count(*) FROM txe_chemos;<br>
select count(*) FROM txe_chemos_revs;<br>
select * FROM txe_chemos LIMIT 0,20;<br>
select * FROM txe_chemos_revs LIMIT 0,20;<br>
		
SELECT count(*), protocol_control_id FROM protocol_masters WHERE modified_by = $modified_by AND modified = '$modified'  GROUP BY protocol_control_id
SELECT count(*), protocol_control_id FROM protocol_masters_revs WHERE modified_by = $modified_by AND version_created = '$modified' GROUP BY protocol_control_id
SELECT count(*) FROM pd_chemos_revs WHERE modified_by = $modified_by AND modified = '$modified';<br>
SELECT count(*), protocol_control_id FROM protocol_masters GROUP BY protocol_control_id;<br>
SELECT count(*) FROM pd_chemos;<br>
SELECT * FROM protocol_masters WHERE id NOT IN (SELECT protocol_master_id FROM pd_chemos) AND protocol_control_id = $chemotherapy_protocol_control_id;<br>
		
SELECT * FROM protocol_masters WHERE modified_by = $modified_by AND modified = '$modified' ORDER BY id, version_created LIMIT 0,10;<br>	
SELECT * FROM protocol_masters_revs WHERE id IN (SELECT distinct id FROM protocol_masters WHERE modified_by = $modified_by AND modified = '$modified') ORDER BY id, version_created LIMIT 0,10;<br>	
SELECT * FROM pd_chemos_revs WHERE protocol_master_id IN (SELECT distinct id FROM protocol_masters WHERE modified_by = $modified_by AND modified = '$modified') ORDER BY protocol_master_id, version_created LIMIT 0,10;<br>	

SELECT * from treatment_masters WHERE protocol_master_id NOT IN (SELECT id FROM protocol_masters);<br>
SELECT * from treatment_masters WHERE protocol_master_id IN (SELECT id FROM protocol_masters WHERE deleted = 1) AND deleted <> 1 AND protocol_master_id IS NOT NULL;<br>

SELECT id, detail_tablename FROM treatment_controls WHERE treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos');<br>
SELECT count(*), treatment_control_id FROM treatment_masters WHERE treatment_control_id IN (SELECT id FROM treatment_controls WHERE treatment_extend_control_id = (SELECT id FROM treatment_extend_controls WHERE detail_tablename = 'txe_chemos')) GROUP BY treatment_control_id;<br>
SELECT count(*) FROM txd_chemos;<br>
SELECT count(*) FROM qc_hb_txd_others;<br>
SELECT count(*), treatment_control_id FROM treatment_masters WHERE treatment_control_id IN (SELECT id FROM treatment_controls WHERE detail_tablename = 'qc_hb_txd_others') GROUP BY treatment_control_id;<br>

SELECT * FROM treatment_masters WHERE modified_by = $modified_by AND modified = '$modified' ORDER BY id, version_created LIMIT 0,10;<br><br>	
SELECT * FROM treatment_masters_revs WHERE id IN (SELECT distinct id FROM treatment_masters WHERE modified_by = $modified_by AND modified = '$modified') ORDER BY id, version_created LIMIT 0,10;<br>	
SELECT * FROM txd_chemos_revs WHERE treatment_master_id IN (SELECT distinct id FROM treatment_masters WHERE modified_by = $modified_by AND modified = '$modified') ORDER BY treatment_master_id, version_created LIMIT 0,10;<br>	
SELECT * FROM qc_hb_txd_others WHERE treatment_master_id IN (SELECT distinct id FROM treatment_masters WHERE modified_by = $modified_by AND modified = '$modified') ORDER BY treatment_master_id, version_created LIMIT 0,10;<br>	


<br>";


exit;

//====================================================================================================================================================
	
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

function recordAndSortMsg($type, $patient_bank_nbr, $line_counter, $msg) {
	global $messages;
	
	switch($type) {
		case 'error':
			$messages['error'][] = "Patient $patient_bank_nbr : " .$msg;
			$msg = "<FONT color='red'>$msg</FONT>";
			break;
		case 'warning':
			$msg = "<FONT color='#E56717'>$msg</FONT>";
			break;
		case 'message':
			$msg = "<FONT color='black'><i>$msg</i></FONT>";
			break;
		case 'todo':
			$msg = "<FONT color='blue'>$msg</FONT>";
			break;
		default:
	}
	$messages["patient :: $patient_bank_nbr // line :: $line_counter"][] = $msg;
}

function printMessages() {
	global $messages;
	
	echo "<br><FONT color='red'><b> ---- Msg -------------------------------------------</b></FONT><br><br>";
	foreach($messages as $msg) echo "$msg<br>";

	

}

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

?>