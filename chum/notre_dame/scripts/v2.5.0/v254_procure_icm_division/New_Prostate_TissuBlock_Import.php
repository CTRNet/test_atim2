<?php

	/*
	 * STEP 3 OF PROCURE ICM DIVISION
	 * 
	 * To RUN after TissuBlock_PathoData_CleanUp.php
	 * 
	 * Will sdd new prostate tissu blocks from teodora files
	 */


//-- EXCEL FILE ---------------------------------------------------------------------------------------------------------------------------

$file_path = "C:/_Perso/Server/icm/data/Selection blocs paraffine - ProCure - NL - test.xls";
//$file_path = "/ATiM/procure/ATiM-Prod/ProCure.xls";
require_once 'Excel/reader.php';
//require_once '/ATiM/procure/ATiM-Prod/Excel/reader.php';

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

global $modified_by;

$modified_by = '9';

global $modified;

$query = "SELECT NOW() as modified FROM study_summaries;";
$modified_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}

global $procure_study_summary_id;

$query = "SELECT id, title FROM study_summaries WHERE title = 'PROCURE' AND deleted != 1;";
$procure_study_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$procure_study = mysqli_fetch_assoc($procure_study_res);
if($procure_study) {
	$procure_study_summary_id = $procure_study['id'];
} else {
	die('ERR 889383839393');
}


global $patho_dpt_storage_master_id;
$query = "SELECT id FROM storage_masters WHERE short_label = 'Patho.Dpt.' AND storage_control_id = 1 AND deleted != 1;";
$patho_dpt_storage_master_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$patho_dpt_storage_master = mysqli_fetch_assoc($patho_dpt_storage_master_res);
if($patho_dpt_storage_master) {
	$patho_dpt_storage_master_id = $patho_dpt_storage_master['id'];
} else {
	die('ERR 889383839392');
}

//--------------------------------------------------------------------------------------------------------------------------------------------

global $messages;
$messages = array();

global $all_queries;
$all_queries = array();

global $summary_data;
$summary_data = array(
	'nbr of atim oct blocks' => 0,
	'nbr of atim paraffin blocks' => 0,
		
	'nbr of excel oct blocks' => 0,
	'nbr of excel paraffin blocks' => 0,
		
	'nbr of oct blocks created' => 0,
	'nbr of paraffin blocks created' => 0,
		
	'nbr of oct blocks matching' => 0,
	'nbr of paraffin blocks matching' => 0);

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

updateView();
echo "****************** PROCESS DONE ******************************<br><br><br>";
echo "<br>****************** SUMMRAY ******************************<br><br><br>";
printMessages();
echo "<br>****************** QUERIES ******************************<br><br><br>";
printQueries();

//--------------------------------------------------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------------------------------------------------

function loadNewBlocks($new_line_data, $line_counter) {
	global $db_connection;
	global $procure_study_summary_id;
	global $summary_data;
	global $patho_dpt_storage_master_id;
	global $modified_by;
	global $modified;
	global $all_queries;
		
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
			SELECT 
				col.id collection_id,
				sm.id sample_master_id, sm.qc_nd_sample_label, spd.sequence_number,
				am.id aliquot_master_id, am.aliquot_label, am.study_summary_id, stud.title as study_title, am.in_stock, am.storage_master_id, stm.selection_label, am.storage_coord_x, am.storage_coord_y, am.notes,
				bl.block_type, bl.patho_dpt_block_code, bl.sample_position_code , bl.procure_origin_of_slice, bl.tumor_presence
			FROM collections col
			INNER JOIN sample_masters sm ON col.id = sm.collection_id AND sm.sample_control_id = 3
			INNER JOIN specimen_details spd ON spd.sample_master_id = sm.id
			LEFT JOIN aliquot_masters am ON sm.id = am.sample_master_id AND am.deleted != 1 AND am.aliquot_control_id = 10
			LEFT JOIN ad_blocks bl ON bl.aliquot_master_id = am.id
			LEFT JOIN storage_masters stm ON am.storage_master_id = stm.id
			LEFT JOIN study_summaries stud ON stud.id = am.study_summary_id
			WHERE col.participant_id = '$participant_id' AND bank_id = 4 AND sm.deleted != 1;";
		$tissues_and_blocks_from_database_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		while($new_tissue_and_block = mysqli_fetch_assoc($tissues_and_blocks_from_database_res)) {
			//Sample
			$sample_master_id = $new_tissue_and_block['sample_master_id'];
			$db_sample_data_from_id[$sample_master_id] = array('collection_id' => $new_tissue_and_block['collection_id'], 'sample_master_id' => $sample_master_id, 'qc_nd_sample_label' => $new_tissue_and_block['qc_nd_sample_label'], 'aliquots' => array(), 'patho_dpt_block_codes' => array());
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
						$summary_data['nbr of atim oct blocks']++;
						$block_type = 'OCT';
						break;
					case 'paraffin':
						$block_type = 'paraffin';
						$summary_data['nbr of atim paraffin blocks']++;
						break;
					default:
						pr($new_tissue_and_block);
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
			recordAndSortMsg('todo', $patient_bank_nbr, $line_counter, "No tissue exists into ATiM. All tissues and blocks have to be created manually.");
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
						if($procure_origin_of_slice && !in_array($procure_origin_of_slice, array('RA','RP','LA','LP'))) {
							$notes = "Slice origin precision (from excel): $procure_origin_of_slice";
							$procure_origin_of_slice = '';
						}
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
							if($column_blocks_properties['block_type'] == 'OCT') {
								$summary_data['nbr of excel oct blocks']++;
							} else {
								$summary_data['nbr of excel paraffin blocks']++;
							}
						}
					} else {
						recordAndSortMsg('error', $patient_bank_nbr, $line_counter, "Unable to extract blocks information from cell value [$new_blocks_set] of column '".utf8_decode($column_name)."'.");	
					}
				}
			}
		}		
		
		// *** Define block matches or new blocks to create ***
		
		$aliquot_to_update = array();
		$aliquot_to_create = array();
		foreach($blocks_from_excel as $new_block_from_excel) {
			$block_description = " See block [".$new_block_from_excel['sample_position_code'].'('.$new_block_from_excel['procure_origin_of_slice'].')'."] of column '".utf8_decode($column_name)."'.";
			$excel_block_type = $new_block_from_excel['block_type'];
			$create_new_block = true;
			if($db_aliquot_id_from_criteria['block_type'][$excel_block_type]) {
				// Try to match OCT (or paraffin) block to an existing one
				$create_new_block = false;
				$match_criteria = array('block_type' => "$excel_block_type block");
				$res = $db_aliquot_id_from_criteria['block_type'][$excel_block_type];
				foreach(array('T_vs_N' => 'Tumor presence','procure_origin_of_slice' => 'Origin of slice', 'sample_position_code' => 'Position') as $new_criteria => $criteria_desc) {
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
							recordAndSortMsg('warning', $patient_bank_nbr, $line_counter, "Match between ATiM and excel blocks has not been done considering block position. Only following criteria have been used : ".implode(', ', $match_criteria).".".$block_description);
						}
						$aliquot_to_update[$aliquot_master_id_to_update] = array(
							'excel_data' => array_merge(array('aliquot_master_id_to_update' => $aliquot_master_id_to_update), $new_block_from_excel),
							'db_data' => $db_aliquot_data_from_id[$aliquot_master_id_to_update]);
					} else {
						recordAndSortMsg('warning', $patient_bank_nbr, $line_counter, "More than one excel $excel_block_type blocks match the same ATiM $excel_block_type block considering following criteria :  ".implode(', ', $match_criteria).". New block will be created.".$block_description);
						$create_new_block = true;
					}
				} else if(sizeof($res) > 1) {
					recordAndSortMsg('todo', $patient_bank_nbr, $line_counter, "More than one ATiM $excel_block_type blocks match block from excel considering following criteria : ".implode(', ', $match_criteria).". Match between ATiM block and excel block has to be done manually.".$block_description);
				} else {
					recordAndSortMsg('warning', $patient_bank_nbr, $line_counter, "No ATiM $excel_block_type blocks match block from excel considering following criteria : ".implode(', ', $match_criteria).". New block will be created.".$block_description);
					$create_new_block = true;	
				}
			}
			if($create_new_block) {
				// No block matching into database => block has to be create and linked to a sample.
				$sample_master_id_to_link = null;
				$new_block_from_excel_T_vs_N = $new_block_from_excel['T_vs_N'];
				if(sizeof($db_sample_id_from_criteria['T_vs_N'][$new_block_from_excel_T_vs_N]) == 1) {
					$sample_master_id_to_link = current($db_sample_id_from_criteria['T_vs_N'][$new_block_from_excel_T_vs_N]);
				} else if(sizeof($db_sample_id_from_criteria['T_vs_N'][$new_block_from_excel_T_vs_N]) > 1){
					$all_sample_labels_for_display = array();
					foreach($db_sample_id_from_criteria['T_vs_N'][$new_block_from_excel_T_vs_N] as $new_sample_id_tmp) $all_sample_labels_for_display[] = $db_sample_data_from_id[$new_sample_id_tmp]['qc_nd_sample_label'];
					recordAndSortMsg('todo', $patient_bank_nbr, $line_counter, "More than one '$new_block_from_excel_T_vs_N' tissues [".implode(', ',$all_sample_labels_for_display)."] already exist in ATiM. Link between block and tissue has to be done manually.". $block_description);
				} else if(sizeof($db_sample_id_from_criteria['T_vs_N']['other']) == 1) {
					$sample_master_id_to_link = current($db_sample_id_from_criteria['T_vs_N']['other']);
				//	recordAndSortMsg('message', $patient_bank_nbr, $line_counter, "Linked a '$new_block_from_excel_T_vs_N' $excel_block_type block to a tissue having no 'Sequence number' like 'T' or 'N'.". $block_description);	
				} else if(sizeof($db_sample_id_from_criteria['T_vs_N']['other']) > 1){
					$all_sample_labels_for_display = array();
					foreach($db_sample_id_from_criteria['T_vs_N']['other'] as $new_sample_id_tmp) $all_sample_labels_for_display[] = $db_sample_data_from_id[$new_sample_id_tmp]['qc_nd_sample_label'];
					recordAndSortMsg('todo', $patient_bank_nbr, $line_counter, "More than one tissues having no 'Sequence number' like 'T' or 'N' [".implode(', ',$all_sample_labels_for_display)."] already exist in ATiM. Link between block and tissue has to be done manually.".$block_description);
				} else {
					die('ERR 84894940044');
				}
				if($sample_master_id_to_link) {
					if($new_block_from_excel['patho_dpt_block_code'] && !empty($db_sample_data_from_id[$sample_master_id_to_link]['patho_dpt_block_codes'])) {
						if(!in_array($new_block_from_excel['patho_dpt_block_code'], $db_sample_data_from_id[$sample_master_id_to_link]['patho_dpt_block_codes'])) {
							recordAndSortMsg('warning', $patient_bank_nbr, $line_counter, "Linked $excel_block_type block to sample '".$db_sample_data_from_id[$sample_master_id_to_link]['qc_nd_sample_label']."' but the path report codes between db [".implode(', ',$db_sample_data_from_id[$sample_master_id_to_link]['patho_dpt_block_codes'])."] and file [".$new_block_from_excel['patho_dpt_block_code']."] don't seam to match.".$block_description);	
						}
					}
					$aliquot_to_create[] = array_merge(
						array('sample_master_id' => $sample_master_id_to_link, 
							'qc_nd_sample_label' => $db_sample_data_from_id[$sample_master_id_to_link]['qc_nd_sample_label'],
							'collection_id' => $db_sample_data_from_id[$sample_master_id_to_link]['collection_id']), 
						$new_block_from_excel);
				}
			}
		}
		
		// *** Run Queries ***
		
		$queries_to_update = array();
		foreach($aliquot_to_update as $new_aliquot_to_update) {
			$excel_aliquot_data = $new_aliquot_to_update['excel_data'];
			$db_aliquot_data = $new_aliquot_to_update['db_data'];			
			$aliquot_master_id = $db_aliquot_data['aliquot_master_id'];
			$data_for_update = array('AliquotMaster' => array(), 'AliquotDetail' => array());
			$block_description = " See block [".$db_aliquot_data['aliquot_label'].'('.$excel_aliquot_data['sample_position_code'].'/'.$excel_aliquot_data['procure_origin_of_slice'].')'."].";
			// Bank Check
			if($excel_aliquot_data['bank'] == 'procure') {
				if(!$db_aliquot_data['study_summary_id']) {
					$data_for_update['AliquotMaster']['study_summary_id'] = $procure_study_summary_id;
					recordAndSortMsg('message', $patient_bank_nbr, $line_counter, "A PROCURE aliquot was not linked to a study in ATiM. Updated link to PROCURE. $block_description");
				} else if($db_aliquot_data['study_summary_id'] != $procure_study_summary_id) {
					$data_for_update['AliquotMaster']['study_summary_id'] = $procure_study_summary_id;
					recordAndSortMsg('warning', $patient_bank_nbr, $line_counter, "A PROCURE aliquot was already linked to a study (".$db_aliquot_data['study_title'].") in ATiM. Changed link to PROCURE. $block_description");
				}
			} else {
				if($db_aliquot_data['study_summary_id'] == $procure_study_summary_id) {
					$data_for_update['AliquotMaster']['study_summary_id'] = '';
					recordAndSortMsg('warning', $patient_bank_nbr, $line_counter, "An ICM aliquot was linked to a study PROCURE in ATiM. Changed link to nothing. $block_description");	
				}
			}
			// T_vs_N Check
			$data_for_update['AliquotDetail']['tumor_presence'] = ($excel_aliquot_data['T_vs_N'] == 'T')? 'y': 'n';
			if(preg_match('/^([NT])(\.[0-9]){0,1}$/', $db_aliquot_data['sequence_number'], $matches)) {
				if($matches[1] != $excel_aliquot_data['T_vs_N']) {
					recordAndSortMsg(
						'warning', 
						$patient_bank_nbr, 
						$line_counter, 
						(($matches[1] == 'T')? 
							"A tissue having a 'sequence number' like 'T' in ATiM is linked to a block in excel having no tumor presence. $block_description" :
							"A tissue having a 'sequence number' like 'N' in ATiM is linked to a block in excel having tumor presence. $block_description" ));
				}
			}
			// patho dpt block code Check
			if($excel_aliquot_data['patho_dpt_block_code']) {
				if(!$db_aliquot_data['patho_dpt_block_code']) {
					$data_for_update['AliquotDetail']['patho_dpt_block_code'] = $excel_aliquot_data['patho_dpt_block_code'];
				} else if($db_aliquot_data['patho_dpt_block_code'] != $excel_aliquot_data['patho_dpt_block_code']) {
					recordAndSortMsg('error', $patient_bank_nbr, $line_counter, "The Patho Depratment Codes are different in ATiM (".$db_aliquot_data['patho_dpt_block_code'].") and excel (".$excel_aliquot_data['patho_dpt_block_code']."). $block_description");
				}
			}
			// Block type Check
			switch($db_aliquot_data['block_type']) {
				case 'OCT':
				case 'isopentane + OCT':
				case 'frozen':
					$summary_data['nbr of oct blocks matching']++;
					if($excel_aliquot_data['block_type'] != 'OCT') die('ERR 8839893938383.1');
					break;
				case 'paraffin':
					$summary_data['nbr of paraffin blocks matching']++;
					if($excel_aliquot_data['block_type'] != 'paraffin') die('ERR 8839893938383.2');
					break;
				default:
					die('ERR 8839893938383.3');
			}
			// Origin of slice Check
			if($excel_aliquot_data['procure_origin_of_slice']) {
				if(!$db_aliquot_data['procure_origin_of_slice']) {
					$data_for_update['AliquotDetail']['procure_origin_of_slice'] = $excel_aliquot_data['procure_origin_of_slice'];
				} else if($db_aliquot_data['procure_origin_of_slice'] != $excel_aliquot_data['procure_origin_of_slice']) {
					recordAndSortMsg('error', $patient_bank_nbr, $line_counter, "The Origines of slide are different in ATiM (".$db_aliquot_data['procure_origin_of_slice'].") and excel (".$excel_aliquot_data['procure_origin_of_slice']."). $block_description");
				}
			}
			// Position Code check
			if($excel_aliquot_data['sample_position_code']) {
				if(!$db_aliquot_data['sample_position_code']) {
					$data_for_update['AliquotDetail']['sample_position_code'] = $excel_aliquot_data['sample_position_code'];
				} else if($db_aliquot_data['sample_position_code'] != $excel_aliquot_data['sample_position_code']) {
					recordAndSortMsg('error', $patient_bank_nbr, $line_counter, "The Block Positions Codes are different in ATiM (".$db_aliquot_data['sample_position_code'].") and excel (".$excel_aliquot_data['sample_position_code']."). $block_description");
				}
			}
			// Storage Master
			if($excel_aliquot_data['block_type'] == 'paraffin') {
				if(!$db_aliquot_data['storage_master_id']) $data_for_update['AliquotMaster']['study_summary_id'] = $procure_study_summary_id;
			}
			// Notes 
			if($excel_aliquot_data['notes']) {
				if($db_aliquot_data['notes']) {
					$data_for_update['AliquotMaster']['notes'] = "CONCAT(notes, ' ', '".$excel_aliquot_data['notes']."')";
				} else {
					$data_for_update['AliquotMaster']['notes'] = "'".$excel_aliquot_data['notes']."'";
				}
			}
			// Set queries for update
			if($data_for_update['AliquotMaster'] || $data_for_update['AliquotDetail']) {			
				foreach($data_for_update AS $model => $data) {
					switch($model) {
						case 'AliquotMaster':
							$set_arr = array("modified = '$modified'", "modified_by = '$modified_by'");
								if($field == 'notes') {
									$set_arr[] = "$field = $value";
								} else if($field == 'study_summary_id' && empty($value)) {
									$set_arr[] = "$field = null";
								} else {
									$set_arr[] = "$field = '$value'";
								}
							}
							$queries_to_update[] = "UPDATE aliquot_masters SET ".implode(', ', $set_arr)." WHERE id = $aliquot_master_id";
							$queries_to_update[] = "INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, stored_by, product_code, notes, modified_by, version_created)
								(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, stored_by, product_code, notes, '$modified_by', '$modified'
								FROM aliquot_masters WHERE id = $aliquot_master_id)";			
							break;
						case 'AliquotDetail':
							$set_arr = array();
							foreach($data as $field => $value) $set_arr[] = "$field = '$value'";
							if($data) $queries_to_update[] = "UPDATE ad_blocks SET ".implode(', ', $set_arr)." WHERE aliquot_master_id = $aliquot_master_id";
							$queries_to_update[] = "INSERT INTO ad_blocks_revs (aliquot_master_id, block_type, sample_position_code, patho_dpt_block_code, tmp_gleason_primary_grade, tmp_gleason_secondary_grade, tmp_tissue_primary_desc, tmp_tissue_secondary_desc, histogel_use, version_created, procure_origin_of_slice, tumor_presence) 
								(SELECT aliquot_master_id, block_type, sample_position_code, patho_dpt_block_code, tmp_gleason_primary_grade, tmp_gleason_secondary_grade, tmp_tissue_primary_desc, tmp_tissue_secondary_desc, histogel_use, '$modified', procure_origin_of_slice, tumor_presence
								FROM ad_blocks WHERE aliquot_master_id = $aliquot_master_id);";
							break;
						default:
							die('ERR 9948449949');
					}
				}
			}
		}	
		foreach($queries_to_update AS $new_query) {
			$all_queries["patient:$patient_bank_nbr line:$line_counter"][] =$new_query;
			mysqli_query($db_connection, $new_query) or die("query failed [".$new_query."]: " . mysqli_error($db_connection)."]");
		}
		foreach($aliquot_to_create as $new_aliquot_to_create) {
			// AliquotMaster
			$aliquot_master = array(
				'barcode' => "'tmp_2345678'",
				'aliquot_label' => "'".$new_aliquot_to_create['qc_nd_sample_label']."'", 
				'aliquot_control_id' => "'10'", 
				'collection_id' => "'".$new_aliquot_to_create['collection_id']."'", 
				'sample_master_id' => "'".$new_aliquot_to_create['sample_master_id']."'", 
				'in_stock' => "'yes - available'", 
				'notes' => "'".$new_aliquot_to_create['notes']."'",
				'created' => "'".$modified."'", 
				'created_by' => "'".$modified_by."'", 
				'modified' => "'".$modified."'", 
				'modified_by' => "'".$modified_by."'");
			if($new_aliquot_to_create['bank'] == 'procure') $aliquot_master['study_summary_id'] = "'".$procure_study_summary_id."'";
			if($new_aliquot_to_create['block_type'] == 'paraffin') {
				$aliquot_master['storage_master_id'] = "'".$patho_dpt_storage_master_id."'";
				$summary_data['nbr of paraffin blocks created']++;
			} else {
				$summary_data['nbr of oct blocks created']++;
			}
			$query = "INSERT INTO aliquot_masters (".implode(',', array_keys($aliquot_master)).") VALUES (".implode(',', $aliquot_master).");";
			$all_queries["patient:$patient_bank_nbr line:$line_counter"][] =$query;		
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			$query = "SELECT id FROM aliquot_masters WHERE barcode = 'tmp_2345678'";	
			$aliquot_master_id_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			$aliquot_master_id = mysqli_fetch_assoc($aliquot_master_id_res);
			if($aliquot_master_id) {
				$aliquot_master_id = $aliquot_master_id['id'];
			} else {
				die('ERR 9993999399');
			}
			$query = "UPDATE aliquot_masters SET barcode = id WHERE barcode = 'tmp_2345678'";
			$all_queries["patient:$patient_bank_nbr line:$line_counter"][] =$query;			
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			$query = "INSERT INTO aliquot_masters_revs (id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, stored_by, product_code, notes, modified_by, version_created)
				(SELECT id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id, initial_volume, current_volume, in_stock, in_stock_detail, use_counter, study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, stored_by, product_code, notes, '$modified_by', '$modified'
				FROM aliquot_masters WHERE id = $aliquot_master_id)";
			$all_queries["patient:$patient_bank_nbr line:$line_counter"][] =$query;		
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			// AliquotDetail
			$aliquot_detail = array(
				'aliquot_master_id' => "'$aliquot_master_id'",
				'block_type' => "'".(($new_aliquot_to_create['block_type'] == 'paraffin')? 'paraffin' : 'OCT')."'", 
				'sample_position_code' => "'".$new_aliquot_to_create['sample_position_code']."'", 
				'patho_dpt_block_code' => "'".$new_aliquot_to_create['patho_dpt_block_code']."'", 
				'procure_origin_of_slice' => "'".$new_aliquot_to_create['procure_origin_of_slice']."'", 
				'tumor_presence' => "'".(($new_aliquot_to_create['T_vs_N'] == 'T')? 'y' : 'n')."'");
			$query = "INSERT INTO ad_blocks (".implode(',', array_keys($aliquot_detail)).") VALUES (".implode(',', $aliquot_detail).");";
			$all_queries["patient:$patient_bank_nbr line:$line_counter"][] =$query;		
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
			$query = "INSERT INTO ad_blocks_revs (aliquot_master_id, block_type, sample_position_code, patho_dpt_block_code, tmp_gleason_primary_grade, tmp_gleason_secondary_grade, tmp_tissue_primary_desc, tmp_tissue_secondary_desc, histogel_use, version_created, procure_origin_of_slice, tumor_presence)
				(SELECT aliquot_master_id, block_type, sample_position_code, patho_dpt_block_code, tmp_gleason_primary_grade, tmp_gleason_secondary_grade, tmp_tissue_primary_desc, tmp_tissue_secondary_desc, histogel_use, '$modified', procure_origin_of_slice, tumor_presence
				FROM ad_blocks WHERE aliquot_master_id = $aliquot_master_id);";
			$all_queries["patient:$patient_bank_nbr line:$line_counter"][] =$query;		
			mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
		}	
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

function updateView() {
	global $modified_by;
	global $modified;
	global $db_connection;
	
	//TODO Validate nothing else to do
		
	$query =
		"REPLACE INTO view_aliquots ( SELECT
		AliquotMaster.id AS aliquot_master_id,
		AliquotMaster.sample_master_id AS sample_master_id,
		AliquotMaster.collection_id AS collection_id,
		Collection.bank_id,
		AliquotMaster.storage_master_id AS storage_master_id,
		Collection.participant_id,
		
		Participant.participant_identifier,
		
		Collection.acquisition_label,
		
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
		IF(Collection.collection_datetime_accuracy != 'c' OR AliquotMaster.storage_datetime_accuracy != 'c', -2,
		IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
		TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
		IF(AliquotMaster.storage_datetime IS NULL, NULL,
		IF(SpecimenDetail.reception_datetime IS NULL, -1,
		IF(SpecimenDetail.reception_datetime_accuracy != 'c' OR AliquotMaster.storage_datetime_accuracy != 'c', -2,
		IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
		TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
		IF(AliquotMaster.storage_datetime IS NULL, NULL,
		IF(DerivativeDetail.creation_datetime IS NULL, -1,
		IF(DerivativeDetail.creation_datetime_accuracy != 'c' OR AliquotMaster.storage_datetime_accuracy != 'c', -2,
		IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
		TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,
			
		IF(LENGTH(AliquotMaster.notes) > 0, 'y', 'n') AS has_notes,
			
		MiscIdentifier.identifier_value AS identifier_value,
		Collection.visit_label AS visit_label,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		AliquotMaster.in_stock_detail,
		AliquotMaster.study_summary_id,
		SampleMaster.qc_nd_sample_label AS qc_nd_sample_label
		
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
		LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
		LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
		LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
		WHERE AliquotMaster.deleted != 1 AND AliquotMaster.modified = '$modified' AND AliquotMaster.modified_by = '$modified_by')";
	mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
}

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
	$messages["patient:$patient_bank_nbr line:$line_counter"][] = $msg;
}

function printMessages() {
	global $messages;
	
	echo "<br><FONT color='red'><b> ---- ERRORS -------------------------------------------</b></FONT><br><br>";
	foreach($messages['error'] as $msg) echo "$msg<br>";
	unset($messages['error']);
	
	echo "<br><FONT color='red'><b> ---- Message Per Participant -------------------------------------------</b></FONT><br><br>";
	foreach($messages as $patient_info => $patient_msgs) {
		echo "<b>$patient_info</b><br>";
		foreach($patient_msgs AS $msg)echo " . . . $msg<br>";
	}
}

function printQueries(){
	global $all_queries;
	foreach($all_queries as $patient_info => $queries) {
		echo "<b>$patient_info</b>";
		foreach($queries AS $new_query) echo " . . . $new_query<br>";
	}
}

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}	

?>