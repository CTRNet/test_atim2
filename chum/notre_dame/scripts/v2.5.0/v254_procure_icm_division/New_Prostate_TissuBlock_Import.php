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

global $procure_study_summary_id;

$query = "SELECT id, title FROM study_summaries WHERE title = 'PROCURE' AND deleted != 1;";
$procure_study_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$procure_study = mysqli_fetch_assoc($procure_study_res);
if($procure_study) {
	$procure_study_summary_id = $procure_study['id'];
} else {
	die('ERR 889383839393');
}

//--------------------------------------------------------------------------------------------------------------------------------------------

global $messages;
$messages = array();

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
	}
}

pr($messages);

//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------


function loadNewBlocks($new_line_data, $line_counter) {
	global $db_connection;
	global $procure_study_summary_id;
	
	$participant_id  = getParticipantId($new_line_data, $line_counter);
	if($participant_id) {
		$patient_bank_nbr = $new_line_data['# prostate bank'];
		
		
		// *** Get samples && blocks from database *** 
		$db_sample_data_from_id = array();
		$db_sample_id_from_criteria = array(
			'T_vs_N' => array('T' => array(), 'N' => array(), 'other' => array()),
			'patho_dpt_block_code' => array());
		$db_aliquot_data_from_id = array();
		$db_aliquot_id_from_criteria = array(
			'T_vs_N' => array('T' => array(), 'N' => array(), 'other' => array()),
			'block_type' => array('OCT' => array(), 'paraffin' => array()),
			'procure_origin_of_slice' => array('RA' => array(), 'LA' => array(), 'RP' => array(), 'LP' => array(), 'other' => array()),
			'sample_position_code' => array()
		);
		$query = "
			SELECT sm.id sample_master_id, sm.qc_nd_sample_label, spd.sequence_number,
				am.id aliquot_master_id, am.aliquot_label, am.study_summary_id,
				bl.block_type, bl.patho_dpt_block_code, bl.sample_position_code , bl.procure_origin_of_slice, bl.tumor_presence
			FROM collections col
			INNER JOIN sample_masters sm ON col.id = sm.collection_id AND sm.sample_control_id = 3
			INNER JOIN specimen_details spd ON spd.sample_master_id = sm.id
			LEFT JOIN aliquot_masters am ON sm.id = am.sample_master_id AND am.deleted != 1 AND am.aliquot_control_id = 10
			LEFT JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
			WHERE col.participant_id = '$participant_id' AND bank_id = 4 AND sm.deleted != 1;";
		$tissues_and_blocks_from_database_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		while($new_tissue_and_block = mysqli_fetch_assoc($tissues_and_blocks_from_database_res)) {
			//Sample
			$sample_master_id = $new_tissue_and_block['sample_master_id'];
			$db_sample_data_from_id[$sample_master_id] = array('sample_master_id' => $sample_master_id, 'qc_nd_sample_label' => $new_tissue_and_block['qc_nd_sample_label'], 'aliquots' => array(), 'patho_dpt_block_codes' => array());
			$T_vs_N = 'other';
			if(preg_match('/^N(\.[0-9]){0,1}$/', $new_tissue_and_block['sequence_number'])) {
				$T_vs_N = 'N';
			} else if(preg_match('/^T(\.[0-9]){0,1}$/', $new_tissue_and_block['sequence_number'])) {
				$T_vs_N = 'T';
			} else if($new_tissue_and_block['sequence_number']) {
				if(!preg_match('/^[0-9]+$/', $new_tissue_and_block['sequence_number'])) die("Sequence_number = ".$new_tissue_and_block['sequence_number']." is not supported");
			}
			$db_sample_id_from_criteria['T_vs_N'][$T_vs_N][$sample_master_id] = $sample_master_id;
			if($new_tissue_and_block['patho_dpt_block_code']) {
				$db_sample_id_from_criteria['patho_dpt_block_code'][$new_tissue_and_block['patho_dpt_block_code']][$sample_master_id] = $sample_master_id;
				$db_sample_data_from_id[$sample_master_id]['patho_dpt_block_codes'][$new_tissue_and_block['patho_dpt_block_code']] = $new_tissue_and_block['patho_dpt_block_code'];
			}
			//Aliquot
			if($new_tissue_and_block['aliquot_master_id']) {
				$aliquot_master_id = $new_tissue_and_block['aliquot_master_id'];
				$db_sample_data_from_id[$sample_master_id]['aliquots'][$aliquot_master_id] = $aliquot_master_id;
				$db_aliquot_data_from_id[$aliquot_master_id] = $new_tissue_and_block;
				$db_aliquot_id_from_criteria['T_vs_N'][$T_vs_N][$aliquot_master_id] = $aliquot_master_id;
				$block_type = '';
				switch($new_tissue_and_block['block_type']) {
					case 'OCT':
					case 'isopentane + OCT':
					case 'frozen':
						$block_type = 'OCT';
						break;
					case 'paraffin':
						$block_type = 'paraffin';
						break;
					default:
						die("block_type = ".$new_tissue_and_block['block_type']." is not supported");
				}
				$db_aliquot_id_from_criteria['block_type'][$block_type][$aliquot_master_id] = $aliquot_master_id;
				if($new_tissue_and_block['procure_origin_of_slice'] && in_array($new_tissue_and_block['procure_origin_of_slice'], array('RA','RP','LA','RA'))) {
					$db_aliquot_id_from_criteria['procure_origin_of_slice'][$new_tissue_and_block['procure_origin_of_slice']][$aliquot_master_id] = $aliquot_master_id;
				} else {
					$db_aliquot_id_from_criteria['procure_origin_of_slice']['other'][$aliquot_master_id] = $aliquot_master_id;
				}
				if($new_tissue_and_block['sample_position_code']) $db_aliquot_id_from_criteria['sample_position_code'][$new_tissue_and_block['sample_position_code']][$aliquot_master_id] = $aliquot_master_id;
			}
		}
		if(empty($db_sample_data_from_id)) {
			pr_msg('todo', $patient_bank_nbr, $line_counter, "No tissue exists into ATiM. All tissues and blocks have to be created manually.");
			return;
		}
		
		// *** Get blocks data from file *** 
		$blocks_from_excel = array();
		$block_headers = array(
			"ProCure # bloc paraffine (C)- tranche #1" 		=> array('T_vs_N' => 'T', 'block_type' => 'paraffin', 'bank' => 'procure'),
			"ProCure # bloc paraffine (B)-tranche #1" 		=> array('T_vs_N' => 'N', 'block_type' => 'paraffin', 'bank' => 'procure'),	
			"ProCure # bloc paraffine (C)- tranche #2" 		=> array('T_vs_N' => 'T', 'block_type' => 'paraffin', 'bank' => 'procure'),	
			"ProCure # bloc paraffine (B)-tranche #2" 		=> array('T_vs_N' => 'N', 'block_type' => 'paraffin', 'bank' => 'procure'),	
			"ProCure # OCT - C  (?) pour ProCure" 			=> array('T_vs_N' => 'T', 'block_type' => 'OCT', 'bank' => 'procure'),
			"ProCure # OCT - B (?) pour Procure" 			=> array('T_vs_N' => 'N', 'block_type' => 'OCT', 'bank' => 'procure'),	
			"ICM # bloc OCT - CHUM" 						=> array('T_vs_N' => 'T', 'block_type' => 'OCT', 'bank' => 'icm'),	
			"ICM # bloc OCT (B)-tranche #1 - CHUM" 			=> array('T_vs_N' => 'N', 'block_type' => 'OCT', 'bank' => 'icm'),	
			"ICM # bloc paraffine (C)- tranche #1 - CHUM" 	=> array('T_vs_N' => 'T', 'block_type' => 'paraffin', 'bank' => 'icm'),	
			"ICM # bloc paraffine (B)-tranche #1 - CHUM" 	=> array('T_vs_N' => 'N', 'block_type' => 'paraffin', 'bank' => 'icm'),	
			"ICM # blocs de paraffine réstants (C) - CHUM"	=> array('T_vs_N' => 'T', 'block_type' => 'paraffin', 'bank' => 'icm'),	
			"ICM # blocs de paraffine réstants (B) - CHUM" => array('T_vs_N' => 'N', 'block_type' => 'paraffin', 'bank' => 'icm'));
		foreach($block_headers as $column_name => $column_blocks_properties) {			
			$cell_contents = explode(';', str_replace(
				array(' ', 	'?', 	'()',	'),',	')/',	').',	':',	'((',	'(RP(',	'(LA(',	'(RA(',	'))',	'&',	'V.S.',	'C.D.'), 
				array('', 	'', 	'',		');',	');',	');',	';',	'(',	'(RP)',	'(LA)',	'(RA)',	')', 	',',	'VS',	'CD'), 
				$new_line_data[$column_name]));
			foreach($cell_contents as $new_blocks_set) {
				if(strlen($new_blocks_set) && strtolower($new_blocks_set) != 'x') {
					if(preg_match_all('/(([0-9]+)\-([0-9]+))/', $new_blocks_set, $matches)) {
						foreach($matches[1] as $interval_id => $interval) {
							$all_values_of_interval = array();
							for($counter = $matches[2][$interval_id]; $counter <= $matches[3][$interval_id]; $counter++) $all_values_of_interval[] = $counter;
							if(empty($all_values_of_interval)) die("ERR 778393993939393 ($new_blocks_set) line : ".$line_counter);
							$new_blocks_set = str_replace($interval, implode(',',$all_values_of_interval), $new_blocks_set);
						}
					}					
					if(preg_match('/^([0-9,]*)(\(([A-Za-zé\+]+)\){0,1}){0,1}$/', $new_blocks_set, $matches)) {					
						$notes = '';
						$procure_origin_of_slice = isset($matches[3])? $matches[3] : ''; 
						if($procure_origin_of_slice && !in_array($procure_origin_of_slice, array('RA','RP','LA','LP'))) $notes = "Slice origin precision (from excel): $procure_origin_of_slice";
						$sample_position_codes = empty($matches[1])? array('') : explode(',', $matches[1]);
						foreach($sample_position_codes as $new_sample_position_code) {
							$blocks_from_excel[] = array(
								'bank' => $column_blocks_properties['bank'],
								'T_vs_N' => $column_blocks_properties['T_vs_N'],
								'patho_dpt_block_code' => $new_line_data['# patho'],
								'block_type' => $column_blocks_properties['block_type'],
								'procure_origin_of_slice' => $procure_origin_of_slice,
								'sample_position_code' => $new_sample_position_code,
								'notes' => $notes
							);
						}
					} else {
						pr_msg('error', $patient_bank_nbr, $line_counter, "Unable to extract blocks information from cell value [$new_blocks_set] of column '".utf8_decode($column_name)."'.");	
					}
				}
			}
		}
		
		
		// *** Define block matches or new blocks to create ***
		$aliquot_to_update = array();
		$aliquot_to_create = array();
		foreach($blocks_from_excel as $new_block_from_excel) {
			// Try to match block to existing one
			
			if($new_block_from_excel['block_type'] == 'paraffin') {
				
				// -- 1 -- Work on Excel paraffin block
				
				$create_new_block = true;
				if($db_aliquot_id_from_criteria['block_type']['paraffin']) {
					$create_new_block = false;
					$match_criteria = array('block_type' => 'Paraffin block');
					$res = $db_aliquot_id_from_criteria['block_type']['paraffin'];
					foreach(array('T_vs_N' => 'Tumor presence','procure_origin_of_slice' => 'Origin of slice','sample_position_code' => 'Position') as $new_criteria => $criteria_desc) {
						if(isset($db_aliquot_id_from_criteria[$new_criteria][$new_block_from_excel[$new_criteria]]) 
						&& $db_aliquot_id_from_criteria[$new_criteria][$new_block_from_excel[$new_criteria]]) {
							$match_criteria[$new_criteria] = $criteria_desc.': '.$new_block_from_excel[$new_criteria];
							$res = array_intersect($res, $db_aliquot_id_from_criteria[$new_criteria][$new_block_from_excel[$new_criteria]]);	
						}
					}
					if(sizeof($res) == 1) {
						$aliquot_master_id_to_update = current($res);
						if(!isset($aliquot_to_update[$aliquot_master_id_to_update])) {
							if(!isset($match_criteria['sample_position_code'])) {
								pr_msg('warning', $patient_bank_nbr, $line_counter, "Match between database and excel has been done considering following criteria : ".implode(', ', $match_criteria).". See paraffin block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.");
							}
							$aliquot_to_update[$aliquot_master_id_to_update] = array_merge(array('aliquot_master_id_to_update' => $aliquot_master_id_to_update), $new_block_from_excel);
						} else {
							pr_msg('warning', $patient_bank_nbr, $line_counter, "More than one excel paraffin blocks match the same database paraffin block considering following criteria :  ".implode(', ', $match_criteria).". New block will be created. See paraffin block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.");
							$create_new_block = true;
						}
					} else if(sizeof($res) > 1) {
						pr_msg('todo', $patient_bank_nbr, $line_counter, "More than one database paraffin blocks match block from excel considering following criteria : ".implode(', ', $match_criteria).". Match between database block and excel block has to be done manually. See paraffin block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.");
					} else {
						pr_msg('warning', $patient_bank_nbr, $line_counter, "No database paraffin blocks match block from excel considering following criteria : ".implode(', ', $match_criteria).". New block will be created. See paraffin block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.");
						$create_new_block = true;	
					}
				}
				if($create_new_block) {
					// No paraffin block into database. Link to a sample.
					$sample_master_id_to_link = null;
					$new_block_from_excel_T_vs_N = $new_block_from_excel['T_vs_N'];
					if(sizeof($db_sample_id_from_criteria['T_vs_N'][$new_block_from_excel_T_vs_N]) == 1) {
						$sample_master_id_to_link = current($db_sample_id_from_criteria['T_vs_N'][$new_block_from_excel_T_vs_N]);
					} else if(sizeof($db_sample_id_from_criteria['T_vs_N'][$new_block_from_excel_T_vs_N]) > 1){
						$all_sample_labels_for_display = array();
						foreach($db_sample_id_from_criteria['T_vs_N'][$new_block_from_excel_T_vs_N] as $new_sample_id_tmp) $all_sample_labels_for_display[] = $db_sample_data_from_id[$new_sample_id_tmp]['qc_nd_sample_label'];
						pr_msg('todo', $patient_bank_nbr, $line_counter, "More than one '$new_block_from_excel_T_vs_N' tissues [".implode(', ',$all_sample_labels_for_display)."] already exist in database. Link between block and tissue has to be done manually. See block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.");
					} else if(sizeof($db_sample_id_from_criteria['T_vs_N']['other']) == 1) {
						$sample_master_id_to_link = current($db_sample_id_from_criteria['T_vs_N']['other']);
						pr_msg('match_summary', $patient_bank_nbr, $line_counter, "Linked a '$new_block_from_excel_T_vs_N' paraffin block to a tissue having no 'Sequence number' like 'T' or 'N'. See block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.");	
					} else if(sizeof($db_sample_id_from_criteria['T_vs_N']['other']) > 1){
						$all_sample_labels_for_display = array();
						foreach($db_sample_id_from_criteria['T_vs_N']['other'] as $new_sample_id_tmp) $all_sample_labels_for_display[] = $db_sample_data_from_id[$new_sample_id_tmp]['qc_nd_sample_label'];
						pr_msg('todo', $patient_bank_nbr, $line_counter, "More than one tissues having no 'Sequence number' like 'T' or 'N' [".implode(', ',$all_sample_labels_for_display)."] already exist in database. Link between block and tissue has to be done manually. See block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.");
					} else {
						die('ERR 84894940044');
					}
					if($sample_master_id_to_link) {
						if($new_block_from_excel['patho_dpt_block_code'] && !empty($db_sample_data_from_id[$sample_master_id_to_link]['patho_dpt_block_codes'])) {
							if(!in_array($new_block_from_excel['patho_dpt_block_code'], $db_sample_data_from_id[$sample_master_id_to_link]['patho_dpt_block_codes'])) {
								pr_msg('warning', $patient_bank_nbr, $line_counter, "Linked paraffin block to sample '".$db_sample_data_from_id[$sample_master_id_to_link]['qc_nd_sample_label']."' but the path report codes between db [".implode(', ',$db_sample_data_from_id[$sample_master_id_to_link]['patho_dpt_block_codes'])."] and file [".$new_block_from_excel['patho_dpt_block_code']."] don't seam to match. See block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.");	
							}
						}
						$aliquot_to_create[] = array_merge(array('sample_master_id' => $sample_master_id_to_link), $new_block_from_excel);
					}
				}
			
			} else {
				
				// -- 2 -- Work on Excel paraffin block
				
				
				//TODO
				
				
				
				
			}
		}

//TODO il faut comparer les aliquot intiaux non updater pour voire combien ne sont pas touché		
//TODO definir ou ils sont entreposé		
		
//		pr('aliquot_to_update : '.sizeof($aliquot_to_update));
//		pr('aliquot_to_create : '.sizeof($aliquot_to_create));

	} else {
		die("Participant $patient_bank_nbr is unknown. See line $line_counter.");
	}
	
}

function getParticipantId($new_line_data, $line_counter) {
	global $db_connection;
	if(!isset($new_line_data['# prostate bank'])) die('Missing Field # prostate bank');
	$identifier_value = $new_line_data['# prostate bank'];
	$query = "SELECT participant_id FROM misc_identifiers WHERE deleted != 1 AND misc_identifier_control_id = 5 AND identifier_value = '$identifier_value';";
	$participant_id_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
	$participant_id = mysqli_fetch_assoc($participant_id_res);
	return ($participant_id && $participant_id['participant_id'])? $participant_id['participant_id'] : false;
}

function manageMatchProcess($msg, $new_block_from_excel, $db_sample_data_from_id, $db_sample_id_from_criteria, $db_aliquot_data_from_id, $db_aliquot_id_from_criteria) {
	pr('-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --');
	pr('New Match Issue: '.$msg);
	pr('-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --');
	pr($new_block_from_excel);
	pr('-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --');
	pr($db_sample_data_from_id);
	pr($db_sample_id_from_criteria);
	pr($db_aliquot_data_from_id);
	pr($db_aliquot_id_from_criteria);
	exit;
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
	
function pr_msg($type, $patient_bank_nbr, $line_counter, $msg) {
	global $messages;
	
	switch($type) {
		case 'error':
			$msg = "<FONT color='red'>$msg</FONT>";
			break;
		case 'warning':
			$msg = "<FONT color='#E56717'>$msg</FONT>";
			break;
		case 'message':
			$msg = "<FONT color='green'>$msg</FONT>";
			break;
		case 'todo':
			$msg = "<FONT color='blue'>$msg</FONT>";
			break;
		case 'match_summary':
			$msg = "<FONT color='black'><i>$msg</i></FONT>";
			return;
			break;
		default:
	}
	$messages["$patient_bank_nbr line:$line_counter"][] = $msg;
	//pr($msg);
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