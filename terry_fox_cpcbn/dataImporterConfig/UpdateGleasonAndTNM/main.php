<?php

require_once 'Excel/reader.php';

set_time_limit('3600');

//==============================================================================================
// Variables
//==============================================================================================

$files_path = "C:/_NicolasLuc/Server/www/tfri_cpcbn/data/";
$files_path = "/ATiM/atim-tfri/dataUpdate/cpcbn/UpdateGleasonAndTNM/data/";
$files_names = array(
	'HDQupdate2015.xls' => 'CHUQ-Lacombe #2',
	'mcgillupdate2015.xls' => 'McGill-Aprikian #3',
	'VPCupdate2015.xls' => 'VPC-Gleave #5');

global $import_summary;
$import_summary = array();

global $db_schema;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_charset		= "utf8";
$db_schema	= "atimtfricpcbn";

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
mysqli_autocommit($db_connection, false);

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE id = '1';", __FILE__, __LINE__);
if($query_res->num_rows != 1) importDie('ERR : No user Migration!');
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

echo "<br><br><FONT COLOR=\"blue\" >
=====================================================================<br>
TFRICPCBN - Update Gleason AND TNM<br>
$import_date<br>
=====================================================================</FONT><br>";

$banks_to_id = array();
$query  = "SELECT name, id FROM banks;";
$results = customQuery($query, __FILE__, __LINE__);
while($row = $results->fetch_assoc()){
	$banks_to_id[$row['name']] = $row['id'];
}

$controls = array();
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
		'te_detail_tablename' => $row['te_detail_tablename']
	);
}
$query = "select id, category,controls_type, detail_form_alias, detail_tablename from diagnosis_controls WHERE flag_active = 1;";
$results = customQuery($query, __FILE__, __LINE__);
while($row = $results->fetch_assoc()){
	$controls['DiagnosisControl'][$row['category']][$row['controls_type']] = array(
		'diagnosis_control_id' => $row['id'],
		'detail_tablename' => $row['detail_tablename']
	);
}
$domains_values = array();
foreach(array('qc_tf_gleason_grades', 'qc_tf_ctnm', 'qc_tf_ptnm') as $domain_name) {
	$domains_values[$domain_name] = array();
	foreach(getDomainValues($domain_name) as $value) $domains_values[$domain_name][] = $value;
}

foreach($files_names as $file => $bank) {
	$import_summary[$file]['@@MESSAGE@@']['New File'][$file] = "Loaded file '$file' of bank '$bank'.";
	$studied_patient_nbr = 0;
	if(!array_key_exists($bank, $banks_to_id)) die('ERR 23i7 62876 32 '.$bank);
	$bank_id = $banks_to_id[$bank];
	$XlsReader = new Spreadsheet_Excel_Reader();
	$XlsReader->read($files_path.$file);
	$sheets_nbr = array();
	foreach($XlsReader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	if(!array_key_exists('diagnosis', $sheets_nbr)) die('ERR238763287632 8726 .'.$file);
	$headers = array();
	foreach($XlsReader->sheets[$sheets_nbr['diagnosis']]['cells'] as $line_counter => $new_line) {
		//$line_counter++;
		if($line_counter < 3) {
			mergeHeaders($headers, $new_line, $line_counter);
		} else if($line_counter > 2){
			$new_line_data = formatNewLineData($headers, $new_line);
			if(strlen($new_line_data['Patient # in biobank'])) {
				$file_qc_tf_bank_participant_identifier = $new_line_data['Patient # in biobank'];
				$query = "SELECT id AS participant_id FROM participants WHERE qc_tf_bank_id = $bank_id AND qc_tf_bank_participant_identifier = '$file_qc_tf_bank_participant_identifier';";
				$results = customQuery($query, __FILE__, __LINE__);
				if($results->num_rows == 1) {
					$studied_patient_nbr++;
					$row = $results->fetch_assoc();
					$pariticpant_id = $row['participant_id'];
					//** Biopsy Update **
					if(!array_key_exists('Gleason Grade at biopsy (X+Y)', $new_line_data)) die('ERR [Gleason Grade at biopsy (X+Y)] - '.$file);
					if(!array_key_exists('cTNM RT', $new_line_data)) die('ERR [cTNM RT] - '.$file);
					$excel_gleason_grade = $new_line_data['Gleason Grade at biopsy (X+Y)'];
					$excel_ctnm = str_replace('t', '', strtolower($new_line_data['cTNM RT']));
					if($excel_ctnm && !in_array($excel_ctnm, $domains_values['qc_tf_ctnm'])) {
						$import_summary[$file]['@@WARNING@@']['Unknown cTNM'][] = "cTNM value '$excel_ctnm' is unknown. Value won't be migrated. See Patient # '$file_qc_tf_bank_participant_identifier'.";
						$excel_ctnm = '';
					}
					if($excel_gleason_grade && !in_array($excel_gleason_grade, $domains_values['qc_tf_gleason_grades'])) {
						$import_summary[$file]['@@WARNING@@']['Unknown Gleason Grade at biopsy'][] = "Gleason Grade at biopsy value '$excel_gleason_grade' is unknown. Value won't be migrated. See Patient # '$file_qc_tf_bank_participant_identifier'.";
						$excel_gleason_grade = '';
					}
					if(strlen($excel_gleason_grade.$excel_ctnm)) {
						$query = "SELECT TreatmentMaster.id AS treatment_master_id, TreatmentDetail.gleason_grade, TreatmentDetail.ctnm
							FROM treatment_masters TreatmentMaster
							INNER JOIN ".$controls['TreatmentControl']['biopsy and turp']['detail_tablename']." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
							WHERE TreatmentMaster.participant_id = $pariticpant_id 
							AND TreatmentMaster.treatment_control_id = ".$controls['TreatmentControl']['biopsy and turp']['treatment_control_id']." 
							AND TreatmentMaster.deleted <> 1;";
						$results = customQuery($query, __FILE__, __LINE__);
						if($results->num_rows == 1) {
							$row = $results->fetch_assoc();
							$data_to_update = array();
							if(strlen($excel_gleason_grade)) {
								$atim_gleason_grade = $row['gleason_grade'];
								if($atim_gleason_grade == $excel_gleason_grade) {
									//nothing to do
								} else {
									$data_to_update[] = "TreatmentDetail.gleason_grade = '$excel_gleason_grade'";
									if(strlen($atim_gleason_grade)) {
										$import_summary[$file]['@@WARNING@@']['Updated Gleason Grade at biopsy'][] = "From '$atim_gleason_grade' to '$excel_gleason_grade'. See Patient # '$file_qc_tf_bank_participant_identifier'.";
									} else {
										$import_summary[$file]['@@MESSAGE@@']['Loaded Gleason Grade at biopsy'][] = "Value = '$excel_gleason_grade'. See Patient # '$file_qc_tf_bank_participant_identifier'.";
									}
								}
							}
							if(strlen($excel_ctnm)) {
								$atim_ctnm = $row['ctnm'];
								if($atim_ctnm == $excel_ctnm) {
									//nothing to do
								} else {
									$data_to_update[] = "TreatmentDetail.ctnm = '$excel_ctnm'";
									if(strlen($atim_ctnm)) {
										$import_summary[$file]['@@WARNING@@']['Updated cTNM'][] = "From '$atim_ctnm' to '$excel_ctnm'. See Patient # '$file_qc_tf_bank_participant_identifier'.";
									} else {
										$import_summary[$file]['@@MESSAGE@@']['Loaded cTNM'][] = "Value = '$excel_ctnm'. See Patient # '$file_qc_tf_bank_participant_identifier'.";
									}
								}
							}
							if($data_to_update) {
								$query = "UPDATE treatment_masters TreatmentMaster, ".$controls['TreatmentControl']['biopsy and turp']['detail_tablename']." TreatmentDetail
									SET ".implode(',',$data_to_update).", TreatmentMaster.modified = '$import_date', TreatmentMaster.modified_by = $import_by
									WHERE TreatmentDetail.treatment_master_id = TreatmentMaster.id AND TreatmentMaster.id = ".$row['treatment_master_id'].";";
								customQuery($query, __FILE__, __LINE__, TRUE);	
							}
						} else if($results->num_rows == 0) {
							$import_summary[$file]['@@WARNING@@']['No Biopsy'][] = "No biopsy was created for the Patient # '$file_qc_tf_bank_participant_identifier' of the bank '$bank'. System won't be able to set values : gleason_grade = [$excel_gleason_grade] and ctnm = [$excel_ctnm]. To do manualy!";		
						} else {
							$import_summary[$file]['@@WARNING@@']['More than one Biopsy'][] = "Too many biopsies were created for the Patient # '$file_qc_tf_bank_participant_identifier' of the bank '$bank'. System won't be able to set values : gleason_grade = [$excel_gleason_grade] and ctnm = [$excel_ctnm]. To do manualy!";			
						}
					}
					//** Surgery Update **
					if(!array_key_exists('Gleason RP (X+Y)', $new_line_data)) die('ERR [Gleason RP (X+Y)] - '.$file);
					$excel_qc_tf_gleason_grade = $new_line_data['Gleason RP (X+Y)'];
					if($excel_qc_tf_gleason_grade && !in_array($excel_qc_tf_gleason_grade, $domains_values['qc_tf_gleason_grades'])) {
						$import_summary[$file]['@@WARNING@@']['Unknown Gleason RP (X+Y)'][] = "Gleason RP (X+Y) value '$excel_qc_tf_gleason_grade' is unknown. Value won't be migrated. See Patient # '$file_qc_tf_bank_participant_identifier'.";
						$excel_qc_tf_gleason_grade = '';
					}
					if(strlen($excel_qc_tf_gleason_grade)) {
						$query = "SELECT TreatmentMaster.id AS treatment_master_id, TreatmentDetail.qc_tf_gleason_grade
							FROM treatment_masters TreatmentMaster
							INNER JOIN ".$controls['TreatmentControl']['RP']['detail_tablename']." AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
							WHERE TreatmentMaster.participant_id = $pariticpant_id
							AND TreatmentMaster.treatment_control_id = ".$controls['TreatmentControl']['RP']['treatment_control_id']."
							AND TreatmentMaster.deleted <> 1;";
						$results = customQuery($query, __FILE__, __LINE__);
						if($results->num_rows == 1) {
							$row = $results->fetch_assoc();
							$data_to_update = array();
							if(strlen($excel_qc_tf_gleason_grade)) {
								$atim_qc_tf_gleason_grade = $row['qc_tf_gleason_grade'];
								if($atim_qc_tf_gleason_grade == $excel_qc_tf_gleason_grade) {
									//nothing to do
								} else {
									$data_to_update[] = "TreatmentDetail.qc_tf_gleason_grade = '$excel_qc_tf_gleason_grade'";
									if(strlen($atim_qc_tf_gleason_grade)) {
										$import_summary[$file]['@@WARNING@@']['Updated Gleason RP (X+Y)'][] = "From '$atim_qc_tf_gleason_grade' to '$excel_qc_tf_gleason_grade'. See Patient # '$file_qc_tf_bank_participant_identifier'.";
									} else {
										$import_summary[$file]['@@MESSAGE@@']['Loaded Gleason RP (X+Y)'][] = "Value = '$excel_qc_tf_gleason_grade'. See Patient # '$file_qc_tf_bank_participant_identifier'.";
									}
								}
							}
							if($data_to_update) {
								$query = "UPDATE treatment_masters TreatmentMaster, ".$controls['TreatmentControl']['RP']['detail_tablename']." TreatmentDetail
									SET ".implode(',',$data_to_update).", TreatmentMaster.modified = '$import_date', TreatmentMaster.modified_by = $import_by
									WHERE TreatmentDetail.treatment_master_id = TreatmentMaster.id AND TreatmentMaster.id = ".$row['treatment_master_id'].";";
								customQuery($query, __FILE__, __LINE__, TRUE);	
							}
						} else if($results->num_rows == 0) {
							$import_summary[$file]['@@WARNING@@']['No RP'][] = "No RP was created for the Patient # '$file_qc_tf_bank_participant_identifier' of the bank '$bank'. System won't be able to set values : qc_tf_gleason_grade = [$excel_qc_tf_gleason_grade]. To do manualy!";
						} else {
							$import_summary[$file]['@@WARNING@@']['More than one RP'][] = "Too many RP were created for the Patient # '$file_qc_tf_bank_participant_identifier' of the bank '$bank'. System won't be able to set values : qc_tf_gleason_grade = [$excel_qc_tf_gleason_grade]. To do manualy!";
						}
					}
						
					//** Surgery Update **
					if(!array_key_exists('pTNM RP', $new_line_data)) die('ERR [pTNM RP] - '.$file);
					$excel_ptnm = $new_line_data['pTNM RP'];
					if($excel_ptnm && !in_array($excel_ptnm, $domains_values['qc_tf_ptnm'])) {
						$import_summary[$file]['@@WARNING@@']['Unknown pTNM RP'][] = "pTNM RP value '$excel_ptnm' is unknown. Value won't be migrated. See Patient # '$file_qc_tf_bank_participant_identifier'.";
						$excel_ptnm = '';
					}
					if(strlen($excel_ptnm)) {
						$query = "SELECT DiagnosisMaster.id AS diagnosis_master_id, DiagnosisDetail.ptnm
							FROM diagnosis_masters DiagnosisMaster
							INNER JOIN ".$controls['DiagnosisControl']['primary']['prostate']['detail_tablename']." AS DiagnosisDetail ON DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id
							WHERE DiagnosisMaster.participant_id = $pariticpant_id
							AND DiagnosisMaster.diagnosis_control_id = ".$controls['DiagnosisControl']['primary']['prostate']['diagnosis_control_id']."
							AND DiagnosisMaster.deleted <> 1;";
						$results = customQuery($query, __FILE__, __LINE__);
						if($results->num_rows == 1) {
							$row = $results->fetch_assoc();
							$data_to_update = array();
							if(strlen($excel_ptnm)) {
								$atim_ptnm = $row['ptnm'];
								if($atim_ptnm == $excel_ptnm) {
									//nothing to do
								} else {
									$data_to_update[] = "DiagnosisDetail.ptnm = '$excel_ptnm'";
									if(strlen($atim_ptnm)) {
										$import_summary[$file]['@@WARNING@@']['Updated pTNM RP'][] = "From '$atim_ptnm' to '$excel_ptnm'. See Patient # '$file_qc_tf_bank_participant_identifier'.";
									} else {
										$import_summary[$file]['@@MESSAGE@@']['Loaded pTNM RP'][] = "Value = '$excel_ptnm'. See Patient # '$file_qc_tf_bank_participant_identifier'.";
									}
								}
							}
							if($data_to_update) {
								$query = "UPDATE diagnosis_masters DiagnosisMaster, ".$controls['DiagnosisControl']['primary']['prostate']['detail_tablename']." DiagnosisDetail
									SET ".implode(',',$data_to_update).", DiagnosisMaster.modified = '$import_date', DiagnosisMaster.modified_by = $import_by
									WHERE DiagnosisDetail.diagnosis_master_id = DiagnosisMaster.id AND DiagnosisMaster.id = ".$row['diagnosis_master_id'].";";
								customQuery($query, __FILE__, __LINE__, TRUE);	
							}
						} else if($results->num_rows == 0) {
							$import_summary[$file]['@@WARNING@@']['No Prostate Primary Diagnosis'][] = "No Prostate Primary Diagnosis was created for the Patient # '$file_qc_tf_bank_participant_identifier' of the bank '$bank'. System won't be able to set values : ptnm = [$excel_ptnm]. To do manualy!";
						} else {
							$import_summary[$file]['@@WARNING@@']['More than one Prostate Primary Diagnosis'][] = "Too many Prostate Primary Diagnosis were created for the Patient # '$file_qc_tf_bank_participant_identifier' of the bank '$bank'. System won't be able to set values : ptnm = [$excel_ptnm]. To do manualy!";
						}
					}
				} else if(!$results->num_rows) {
					$import_summary[$file]['@@ERROR@@']['Unknown Patient #'][] = "The Patient # '$file_qc_tf_bank_participant_identifier' of the bank '$bank' does not exist into ATiM. No data will be updated!";;
				} else {
					die('ERR 2873 62876 28762 3');
				}
			}
		}
	}
	unset($XlsReader);
	$import_summary[$file]['@@MESSAGE@@']['New File'][$file] = "$studied_patient_nbr patients studied.";
}

//Update Diagnosis ctn
$query = "UPDATE diagnosis_masters dm, ".$controls['DiagnosisControl']['primary']['prostate']['detail_tablename']." dd, treatment_masters tm, ".$controls['TreatmentControl']['biopsy and turp']['detail_tablename']." td
	SET dd.ctnm = td.ctnm, dm.modified = '$import_date', dm.modified_by = $import_by
	WHERE dm.deleted <> 1 AND dm.diagnosis_control_id = ".$controls['DiagnosisControl']['primary']['prostate']['diagnosis_control_id']."
	AND dm.id = dd.diagnosis_master_id
	AND tm.deleted <> 1 AND tm.treatment_control_id = ".$controls['TreatmentControl']['biopsy and turp']['treatment_control_id']."
	AND tm.id = td.treatment_master_id
	AND tm.participant_id = dm.participant_id
	AND td.type IN ('Bx Dx', 'TURP Dx','Bx Dx TRUS-Guided')
	AND tm.modified = '$import_date' AND tm.modified_by = $import_by;";
customQuery($query, __FILE__, __LINE__, TRUE);	

insertIntoRevsBasedOnModifiedValues($import_date, $import_by, 'treatment_masters', $controls['TreatmentControl']['biopsy and turp']['detail_tablename']);
insertIntoRevsBasedOnModifiedValues($import_date, $import_by, 'treatment_masters', $controls['TreatmentControl']['RP']['detail_tablename']);
insertIntoRevsBasedOnModifiedValues($import_date, $import_by, 'diagnosis_masters', $controls['DiagnosisControl']['primary']['prostate']['detail_tablename']);

dislayErrorAndMessage($import_summary);

$commit_strg = 'not committed';
if(true) {
	$commit_strg = 'committed';
	mysqli_commit($db_connection);
}
echo "<br><br><FONT COLOR=\"red\" >
=====================================================================<br>
Data $commit_strg<br>
=====================================================================</FONT><br>";

//==================================================================================================================================================================================
//==================================================================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function mergeHeaders(&$headers, $new_line, $header_line_counter) {
	if($header_line_counter == 1) {	
		$last_val = '';
		$last_key = 0;
		foreach($new_line as $key => $val) {
			$headers[$key] = $val;
			for($previous_key = ($last_key + 1); $previous_key < $key; $previous_key++) $headers[$previous_key] = $last_val;
			$last_val = $val;
			$last_key = $key;
		}
	} else if($header_line_counter == 2) {
		foreach($new_line as $key => $val) {
			if(isset($headers[$key])) {
				$headers[$key] .= '::'.$val;
			} else {
				$headers[$key] = $val;
			}
		}
		ksort($headers);
	} else {
		die('ERR47748484:'.$header_line_counter);
	}
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

function getDomainValues($domain_name) {
	$values = array();
	$query = "select id, source from structure_value_domains WHERE domain_name = '$domain_name';";
	$results = customQuery($query, __FILE__, __LINE__);
	if($results->num_rows == 0) {
		die('ERR3276328732873287.1:'.$domain_name);
	} else {
		$row = $results->fetch_assoc();
		if($row['source']) {
			if(preg_match('/getCustomDropdown\(\'(.*)\'\)/', $row['source'], $matches)) {
				$query = "SELECT val.value 
					FROM structure_permissible_values_custom_controls AS ct
					INNER JOIN structure_permissible_values_customs val ON val.control_id = ct.id
					WHERE ct.name = '".$matches[1]."';";
				$results = customQuery($query, __FILE__, __LINE__);
				while($row = $results->fetch_assoc()) {
					$values[] = $row['value'];
				}	
			} else {
				die('ERR3276328732873287.2:'.$domain_name);
			}
		} else {
			$query = "SELECT val.value
				FROM structure_permissible_values val
				INNER JOIN structure_value_domains_permissible_values link ON link.structure_permissible_value_id = val.id 
				WHERE link.structure_value_domain_id = ".$row['id']." AND link.flag_active = '1';";
			$results = customQuery($query, __FILE__, __LINE__);
			while($row = $results->fetch_assoc()) {
				$values[] = $row['value'];
			}
		}		
	}
	return $values;
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

function insertIntoRevsBasedOnModifiedValues($import_date, $import_by, $main_tablename, $detail_tablename = null) {
	$insert_queries = array();
	if(!$detail_tablename) {
		// *** CLASSICAL MODEL ***
		$query = "DESCRIBE $main_tablename;";
		$results = customQuery($query, __FILE__, __LINE__);
		$table_fields = array();
		while($row = $results->fetch_assoc()) {
			if(!in_array($row['Field'], array('created','created_by','modified','modified_by','deleted'))) $table_fields[] = $row['Field'];
		}
		$source_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ')."`modified_by`, `modified`";
		$revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`modified_by`, `version_created`';
		$insert_queries[] = "INSERT INTO `".$main_tablename."_revs` ($revs_table_fields) 
			(SELECT $source_table_fields FROM `$main_tablename` WHERE `modified_by` = '$import_by' AND `modified` = '$import_date');";
	} else {
		// *** MASTER DETAIL MODEL ***
		if(!preg_match('/^.+\_masters$/', $main_tablename)) die("ERR2323872387238.1: $main_tablename");
		$foreign_key = str_replace('_masters', '_master_id', $main_tablename);
		//Master table
		$query = "DESCRIBE $main_tablename;";
		$results = customQuery($query, __FILE__, __LINE__);
		$table_fields = array();
		while($row = $results->fetch_assoc()) {
			if(!in_array($row['Field'], array('created','created_by','modified','modified_by','deleted'))) $table_fields[] = $row['Field'];
		}
		$source_table_fields = (empty($table_fields)? '' : 'Master.`'.implode('`, Master.`',$table_fields).'`, ')."Master.`modified_by`, Master.`modified`";
		$revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`modified_by`, `version_created`';
		$insert_queries[] = "INSERT INTO `".$main_tablename."_revs` ($revs_table_fields) 
			(SELECT $source_table_fields FROM `$main_tablename` AS Master INNER JOIN $detail_tablename AS Detail ON Master.`id` = Detail.`$foreign_key` WHERE Master.`modified_by` = '$import_by' AND Master.`modified` = '$import_date');";
		//Detail table
		$query = "DESCRIBE $detail_tablename;";
		$results = customQuery($query, __FILE__, __LINE__);
		$table_fields = array();
		while($row = $results->fetch_assoc()) $table_fields[] = $row['Field'];
		if(!in_array($foreign_key, $table_fields))  die("ERR2323872387238.2: $main_tablename && $detail_tablename");
		$source_table_fields = (empty($table_fields)? '' : 'Detail.`'.implode('`, Detail.`',$table_fields).'`, ')."Master.`modified`";
		$revs_table_fields = (empty($table_fields)? '' : '`'.implode('`, `',$table_fields).'`, ').'`version_created`';
		$insert_queries[] = "INSERT INTO `".$detail_tablename."_revs` ($revs_table_fields)
			(SELECT $source_table_fields FROM `$main_tablename` AS Master INNER JOIN `$detail_tablename` AS Detail ON Master.`id` = Detail.`$foreign_key` WHERE Master.`modified_by` = '$import_by' AND Master.`modified` = '$import_date');";

	}
	foreach($insert_queries as $query) {
		customQuery($query, __FILE__, __LINE__, TRUE);
	}
}



function dislayErrorAndMessage($import_summary) {
	$err_counter = 0;
	foreach($import_summary as $worksheet => $data1) {
		echo "<br><br><FONT COLOR=\"blue\" >
		=====================================================================<br>
		Messages based on $worksheet data export<br>
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
	
	
?>
		