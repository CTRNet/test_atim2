<?php

global $created_storages;

/**
 * Script developed to migrate xenograft and paraffin block create in the past few years and stored at the CRCHUM. 
 * 
 * Source file : ‘FFPE_migration atim(xeno souris)(bon3).xls’. 
 * 
 * @author Nicolas Luc
 */

//First Line of any main.php file
require_once 'system.php';
displayMigrationTitle('Xenograft Blocks Creation', array($excel_file_name));

if(!testExcelFile(array($excel_file_name))) {
	dislayErrorAndMessage();
	exit;
}

//TODO REMOVE
//truncate();
//TODO END REMOVE

$atim_bank_data = getSelectQueryResult("SELECT id FROM banks WHERE name = 'Ovarian/Ovaire'");
$atim_ovarian_bank_id = $atim_bank_data['0']['id'];

$atim_cell_culture_control_data = getSelectQueryResult("SELECT id FROM sample_controls WHERE sample_type = 'cell culture'");
$atim_cell_culture_sample_control_id = $atim_cell_culture_control_data['0']['id'];

$found_parent_cell_cultures = 0;
$created_parent_cell_cultures = 0;
$found_parent_cell_culture_aliquots = 0;
$created_parent_cell_culture_aliquots = 0;
$created_xenografts = 0;
$created_xenograft_blocks = 0;

$created_samples = 0;
$created_aliquots = 0;

$created_storages = array();

$study_ids = array();

$cell_culture_key_to_cell_culture_sample_master_id = array();

$study_summary_ids = array();
$query = "SELECT title, id FROM study_summaries WHERE title IN ('Culture cellulaire pour la biobanque', 'Caractérisation lignées cellulaires pré/post chimio', 
		'Validation d\'anticorps thérapeutiques dans le cancer de l\'ovaire', 
		'Microfluidique', 'Caractérisation des lignées', 'PARP inhibitor', 'Étude de Ran');";
foreach(getSelectQueryResult($query) as $new_study) {
	$study_summary_ids[$new_study['title']] = $new_study['id'];
}

$worksheet_name = 'blocs';
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
	$excel_line_summary = "Excel Cells Line '".$excel_line_data['lignée']."'".(strlen($excel_line_data['alicot system code'])? " & Excel Aliquot Code '".$excel_line_data['alicot system code']."'" : '')." / Excel line $line_number";
	
	if($excel_line_data['cancer'] != 'Ovaire') {
		die('ERR#1');
		//recordErrorAndMessage('Unmigrated Field', '@@ERROR@@', "The content of the unmigrated excel field 'cancer' is different than 'Ovaire' - Data of the line will be migrated and linked to ovary bank but please validate", "See value '".$excel_line_data['cancer']."' and $excel_line_summary.");
	}
	if($excel_line_data['type'] != 'xénogreffe de souris') {
		recordErrorAndMessage('Unmigrated Field', '@@WARNING@@', "The content of the unmigrated excel field 'type' is different than 'xénogreffe de souris' - Data of the line will be migrated but please validate", "See value '".$excel_line_data['type']."' and $excel_line_summary.");
	}
	unset($excel_line_data['cancer']);
	unset($excel_line_data['type']);
	
	// Set parent sample and source aliquot
	
	$atim_collection_id = null;
	$atim_initial_specimen_sample_id = null;
	$atim_initial_specimen_sample_type = null;
	$atim_parent_sample_master_id = null;
	$atim_parent_sample_type = null;
	$atim_source_aliquot_master_id = null;
	
	$fomatted_excel_cell_line_number = '';
	if(preg_match('/^([A-Z]+)([0-9]+)(.*)$/', $excel_line_data['lignée'], $matches)) {
		$fomatted_excel_cell_line_number = $matches[1].' - '.$matches[2].(isset($matches[3])? ' '.trim($matches[3]) : '');
	} else {
		die('ERR#3');
	}
	
	if(strlen($excel_line_data['alicot system code'])) {
		
		// 1- Aliquot Defined Into The Excel
		
		$query = "SELECT 
			Collection.bank_id,
			MiscIdentifier.identifier_value AS no_labo,
			AliquotMaster.collection_id,
			AliquotMaster.sample_master_id,
			AliquotMaster.id AS aliquot_master_id,
			SampleMaster.qc_nd_sample_label,
			SampleControl.sample_type,
			SampleMaster.initial_specimen_sample_id,
			SampleMaster.initial_specimen_sample_type,
			AliquotMaster.barcode,
			AliquotMaster.aliquot_label,
			AliquotMaster.in_stock,
			AliquotMaster.in_stock_detail
			FROM aliquot_masters AliquotMaster
			INNER JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
			INNER JOIN sample_controls SampleControl ON SampleControl.id = SampleMaster.sample_control_id
			INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id
			LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
			LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Collection.participant_id AND MiscIdentifier.deleted <> 1
			LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
			WHERE AliquotMaster.deleted <> 1
			AND AliquotMaster.barcode = '".$excel_line_data['alicot system code']."'
			AND SampleMaster.sample_control_id = $atim_cell_culture_sample_control_id;";
		$atim_parent_aliquot_data = getSelectQueryResult($query);
		if(!$atim_parent_aliquot_data) {
			recordErrorAndMessage('Aliquot Source Check (No source aliquot defined into Excel)', '@@ERROR@@', "Excel Aliquot System Code i unknown into ATiM - No line data will be migrated", "See $excel_line_summary.");
		} else if(sizeof($atim_parent_aliquot_data) != 1) {
			recordErrorAndMessage('Aliquot Source Check (No source aliquot defined into Excel)', '@@ERROR@@', "Excel Aliquot System Code matches more than one aLiquot into ATiM - No line data will be migrated", "See $excel_line_summary.");
		} else {
			//Validate Source Aliquot
			$atim_parent_aliquot_data = $atim_parent_aliquot_data[0];
			$parent_aliquot_validate = true;
			
			// -Check Bank
			if($parent_aliquot_validate && $atim_parent_aliquot_data['bank_id'] != $atim_ovarian_bank_id) {
				$parent_aliquot_validate = false;
				recordErrorAndMessage('Aliquot Source Check (No source aliquot defined into Excel)', '@@ERROR@@', "Bank of the ATiM aliquot (based on the excel aliquot system code) is different than 'Ovary' - No line data will be migrated", "See $excel_line_summary.");
			}
				
			// -Check NoLabo
			if($parent_aliquot_validate && $atim_parent_aliquot_data['no_labo'] != $excel_line_data['no ATiM']) {
				$parent_aliquot_validate = false;
				recordErrorAndMessage('Aliquot Source Check (No source aliquot defined into Excel)', '@@ERROR@@', "NoLabo of the ATiM aliquot (based on the excel aliquot system code) is different than the Excel 'no ATiM' - No line data will be migrated", "'".$atim_parent_aliquot_data['no_labo']."' (ATIM) != '".$excel_line_data['no ATiM']."' (Excel). See $excel_line_summary.");
			}	
				
			// -Check Cell Line
			if($parent_aliquot_validate && (!strlen($fomatted_excel_cell_line_number) || !preg_match("/".str_replace(array('(',')','/','-'), array('\(','\)','\/','\-'), $fomatted_excel_cell_line_number)."/", $atim_parent_aliquot_data['qc_nd_sample_label']))) {
				recordErrorAndMessage('Aliquot Source Check (No source aliquot defined into Excel)', '@@WARNING@@', "The Excel Cell Line 'Lignée' does not match the sample label of the ATiM aliquot (based on the excel aliquot system code) - Data of the line will be migrated but please validate", "'".$atim_parent_aliquot_data['qc_nd_sample_label']."' (ATIM) != '$fomatted_excel_cell_line_number' (Excel). See $excel_line_summary.");
			}
			if($parent_aliquot_validate && !preg_match("/$fomatted_excel_cell_line_number/", $atim_parent_aliquot_data['aliquot_label'])) {
				recordErrorAndMessage('Aliquot Source Check (No source aliquot defined into Excel)', '@@WARNING@@', "The Excel Cell Line 'Lignée' does not match the label of the ATiM aliquot (based on the excel aliquot system code) - Data of the line will be migrated but please validate", "'".$atim_parent_aliquot_data['aliquot_label']."' (ATIM) != '$fomatted_excel_cell_line_number' (Excel). See $excel_line_summary.");
			}
			
			// -Check Passage Of The Source
			if($parent_aliquot_validate && $excel_line_data['cell passage number (Original)']) {
				$excel_cell_passage_number = $excel_line_data['cell passage number (Original)'];
				if(!preg_match("/\ P$excel_cell_passage_number\ /", $atim_parent_aliquot_data['aliquot_label'])) {
					recordErrorAndMessage('Aliquot Source Check (No source aliquot defined into Excel)', '@@WARNING@@', "The Excel Cell Passage Number 'cell passage number (Original)' does not match the label of the ATiM aliquot (based on the excel aliquot system code) - Data of the line will be migrated but please validate", "ATiM aliquot Label '".$atim_parent_aliquot_data['aliquot_label']."' does not match Excel cell passage number 'P$excel_cell_passage_number'. See $excel_line_summary.");
				}
			}
			
			if($parent_aliquot_validate) {
				if($atim_parent_aliquot_data['sample_type'] != 'cell culture') die('ERR 237828723678');		
				//Aliquot Found : Set sample and aliquot ids and types
				$atim_collection_id = $atim_parent_aliquot_data['collection_id'];
				$atim_initial_specimen_sample_id = $atim_parent_aliquot_data['initial_specimen_sample_id'];
				$atim_initial_specimen_sample_type = $atim_parent_aliquot_data['initial_specimen_sample_type'];
				$atim_parent_sample_master_id = $atim_parent_aliquot_data['sample_master_id'];
				$atim_parent_sample_type = $atim_parent_aliquot_data['sample_type'];
				$atim_source_aliquot_master_id = $atim_parent_aliquot_data['aliquot_master_id'];
				//Set counter
				$found_parent_cell_cultures++;
				$found_parent_cell_culture_aliquots++;
			}
		}
		
	} else {
		
		// 2- Only Cell Line Defined Into Excel
		// Find Cell Culture based on cell line number  
		//   - If more than one cell culture matches cell line data, create a new one linked to the parent of the first one created then create aliquot 
		//   - If only one cell culture matches cell line data, use this one and create aliquot
		//   - If no cell culture matches cell line data, no migration
				
		if(strlen($excel_line_data['cell passage number (Original)'])) {
			//They only completed this field when aliquot has been found
			die('ERR#435');
		}
		
		$cell_culture_key = $fomatted_excel_cell_line_number.'//'.$excel_line_data['no ATiM'];
		$cell_culture_sample_label = '';
		
		if(array_key_exists($cell_culture_key, $cell_culture_key_to_cell_culture_sample_master_id)) {
			// Cell Culture created by the process - reuse this one plus create an new aliquot
			list($atim_collection_id,
				$atim_initial_specimen_sample_id, 
				$atim_initial_specimen_sample_type, 
				$atim_parent_sample_master_id, 
				$atim_parent_sample_type, 
				$atim_source_aliquot_master_id,					
				$cell_culture_sample_label) = $cell_culture_key_to_cell_culture_sample_master_id[$cell_culture_key];
			
		} else {
		
			$query = "SELECT
				SampleMaster.collection_id,
				Collection.bank_id,
				MiscIdentifier.identifier_value AS no_labo,
				SampleMaster.id AS sample_master_id,
				SampleMaster.qc_nd_sample_label,
				SampleMaster.sample_code,
				SampleMaster.initial_specimen_sample_id,
				SampleMaster.initial_specimen_sample_type,
				SampleMaster.parent_id,
				SampleMaster.parent_sample_type,
				ParentSampleMaster.sample_code AS parent_sample_code,
				ParentSampleMaster.qc_nd_sample_label AS parent_sample_qc_nd_sample_label
				FROM sample_masters SampleMaster
				INNER JOIN collections Collection ON Collection.id = SampleMaster.collection_id
				INNER JOIN sample_masters AS ParentSampleMaster ON ParentSampleMaster.id = SampleMaster.parent_id
				INNER JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
				INNER JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
				INNER JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Collection.participant_id AND MiscIdentifier.deleted <> 1
				INNER JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
				WHERE SampleMaster.deleted <> 1
				AND SampleMaster.qc_nd_sample_label LIKE '% $fomatted_excel_cell_line_number%'
				AND SampleMaster.sample_control_id = $atim_cell_culture_sample_control_id
				AND Collection.bank_id = $atim_ovarian_bank_id
				AND MiscIdentifier.identifier_value = '".$excel_line_data['no ATiM']."'
				ORDER BY SampleMaster.id ASC;";
			$atim_cell_line_sample_data = getSelectQueryResult($query);
			if($atim_cell_line_sample_data) {
				if(sizeof($atim_cell_line_sample_data) > 1) {
					//Will create a new cell culture linked to the parent of the first cell culture found.
					$atim_qc_sample_labels = array();
					$atim_collection_ids = array();
					$atim_initial_specimen_sample_ids = array();
					foreach($atim_cell_line_sample_data as $new_atim_cell_line_sample) {
						$atim_qc_sample_labels[] = $new_atim_cell_line_sample['qc_nd_sample_label'].' [code : '.$new_atim_cell_line_sample['sample_code'].']';
						$atim_qc_sample_collection_ids[$new_atim_cell_line_sample['collection_id']] = '';
						$atim_initial_specimen_sample_ids[$new_atim_cell_line_sample['initial_specimen_sample_id']] = '';
					}
					$notes = array();
					$notes[] = "Created by the process to download the xenograft blocks data from excel file.\n";
					$notes[] = sizeof($atim_qc_sample_labels)." cell cultures ".
						(sizeof($atim_qc_sample_collection_ids) > 1? 'of '.sizeof($atim_qc_sample_collection_ids).' collections ' : '').
						(sizeof($atim_initial_specimen_sample_ids) > 1? 'created from '.sizeof($atim_initial_specimen_sample_ids).' different specimens ' : '').
						"matched the 'lignée', the 'no labo' and the bank defined into the excel.\n";
					$notes[] = "So system was not able to define the parent cell culture of the xenograft.\n";
					$notes[] = "Here is the list of cell cultures found:\n - ".implode("\n - ", $atim_qc_sample_labels).'.';
					$created_samples++;
					$created_parent_cell_cultures++;
					$cell_culture_sample_label = "C-CULT $fomatted_excel_cell_line_number";
					$sample_data = array(
						'sample_masters' => array(
							'collection_id' => $atim_cell_line_sample_data[0]['collection_id'],
							'sample_control_id' => $atim_controls['sample_controls']['cell culture']['id'],
							'initial_specimen_sample_id' => $atim_cell_line_sample_data[0]['initial_specimen_sample_id'],
							'initial_specimen_sample_type' => $atim_cell_line_sample_data[0]['initial_specimen_sample_type'],
							'parent_id' => $atim_cell_line_sample_data[0]['parent_id'],
							'parent_sample_type' => $atim_cell_line_sample_data[0]['parent_sample_type'],
							'qc_nd_sample_label' => $cell_culture_sample_label,
							'sample_code' => 'tmp_'.($created_samples),
							'notes' => implode(' ',$notes)),
						'derivative_details' => array('creation_by' => 'autre'),
						$atim_controls['sample_controls']['cell culture']['detail_tablename'] => array());
					$atim_collection_id = $atim_cell_line_sample_data[0]['collection_id'];
					$atim_initial_specimen_sample_id = $atim_cell_line_sample_data[0]['initial_specimen_sample_id'];
					$atim_initial_specimen_sample_type = $atim_cell_line_sample_data[0]['initial_specimen_sample_type'];
					$atim_parent_sample_master_id = customInsertRecord($sample_data);
					$atim_parent_sample_type = 'cell culture';
					recordErrorAndMessage('Parent Sample Selection And Aliquot Source Creation (No source aliquot defined into Excel)', 
						'@@WARNING@@', 
						"More than one cell culture matches the Excel values 'NoLabo' plus 'bank' plus the 'Cell Line' ('lignée') - System will create a new cell culture linked to the parent sample of the first cell culture of the list and created into the system.", 
						"Created cell culture '".$sample_data['sample_masters']['qc_nd_sample_label']."' from ".$new_atim_cell_line_sample['parent_sample_type']." sample ".$new_atim_cell_line_sample['parent_sample_qc_nd_sample_label']."' (code = '".$new_atim_cell_line_sample['parent_sample_code']."') with note displayed below. See $excel_line_summary and more.".
							"<br><i>".str_replace("\n", '<br>', $sample_data['sample_masters']['notes'])."</i>");
					$found_parent_cell_cultures++;
				} else {
					//Parent cell culture found
					$atim_collection_id = $atim_cell_line_sample_data[0]['collection_id'];
					$atim_initial_specimen_sample_id = $atim_cell_line_sample_data[0]['initial_specimen_sample_id'];
					$atim_initial_specimen_sample_type = $atim_cell_line_sample_data[0]['initial_specimen_sample_type'];
					$atim_parent_sample_master_id = $atim_cell_line_sample_data[0]['sample_master_id'];
					$atim_parent_sample_type = 'cell culture';
					$cell_culture_sample_label = $atim_cell_line_sample_data[0]['qc_nd_sample_label'];
					$found_parent_cell_cultures++;
				}
			} else {
				// No cell culture found into ATiM matching the code
				recordErrorAndMessage('Parent Sample Selection And Aliquot Source Creation (No source aliquot defined into Excel)',
					'@@ERROR@@',
					"No cell culture found into ATiM based on the Excel values 'NoLabo' plus 'bank' plus the 'Cell Line' ('lignée') - The data of the line won't be migrated",
					"Cell line : '$fomatted_excel_cell_line_number'.See $excel_line_summary.");
			}
		}
		
		if($atim_parent_sample_master_id) {
			// Create Aliquot
			$created_aliquots++;
			$created_parent_cell_culture_aliquots++;
			$aliquot_data = array(
				'aliquot_masters' => array(
					"barcode" => 'tmp_'.($created_aliquots),
					"aliquot_label" => $cell_culture_sample_label,
					"aliquot_control_id" => $atim_controls['aliquot_controls']['cell culture-tube']['id'],
					"collection_id" => $atim_collection_id,
					"sample_master_id" => $atim_parent_sample_master_id,
					'in_stock' => 'no',
					'notes' => "Created by the process to download the xenograft blocks data from excel file."),
				$atim_controls['aliquot_controls']['cell culture-tube']['detail_tablename'] => array());
			$atim_source_aliquot_master_id = customInsertRecord($aliquot_data);
			// Reset value
			$cell_culture_key_to_cell_culture_sample_master_id[$cell_culture_key] = array(
				$atim_collection_id,
				$atim_initial_specimen_sample_id,
				$atim_initial_specimen_sample_type,
				$atim_parent_sample_master_id,
				$atim_parent_sample_type,
				$atim_source_aliquot_master_id,
				$cell_culture_sample_label);
		}
	}		
	
	if($atim_source_aliquot_master_id) {
		
		// Add use to aliquot
		$study_summary_id = null;
		if(!isset($study_summary_ids[$excel_line_data["projet atim"]])) {
			recordErrorAndMessage('Xenograft Creation', '@@ERROR@@', "Unknown study - Aliquot use to create the xenograft won't be linked to the study", "Excel value : '".$excel_line_data["projet atim"]."'.See $excel_line_summary.");
		} else {
			$study_summary_id = $study_summary_ids[$excel_line_data["projet atim"]];
		}
		$aliquot_use_data = array(
			'aliquot_internal_uses' => array(
				"aliquot_master_id" => $atim_source_aliquot_master_id,
				"type" => 'internal use',
				"use_code" => 'Injection Souris (Xéno-greffe)',
				"use_details" => "Created by the process to download the xenograft blocks data from excel file.",
				"study_summary_id" => $study_summary_id
			)
		);
		customInsertRecord($aliquot_use_data);
		
		// Created xenograft and aliquots
		
		$source_cell_passage_number = '';
		if(strlen($excel_line_data["(passage à l'injection)"])) {
			if(preg_match('/^[pP]([0-9]+)$/', $excel_line_data["(passage à l'injection)"], $matches)) {
				$source_cell_passage_number = $matches[1];
			} else {
				recordErrorAndMessage('Xenograft Creation', '@@ERROR@@', "Wrong 'passage à l'injection' - Value won't be migrated", "Excel value : '".$excel_line_data["(passage à l'injection)"]."'.See $excel_line_summary.");
			}
		}
		
		if(!in_array(strtolower($excel_line_data["tx"]), array('', "abt", "olap/abt", "ctrl dmso/epg", "olaparib", "ctrl dmso", "ctrl epg", "doxy (625 mg/kg)"))) {
			recordErrorAndMessage('Xenograft Creation', '@@ERROR@@', "Wrong 'tx' - Value won't be migrated", "Excel value : '".$excel_line_data["tx"]."'.See $excel_line_summary.");
			$excel_line_data["tx"] = '';
		} else {
			$excel_line_data["tx"] = strtolower($excel_line_data["tx"]);
		}
		
		list($creation_datetime, $creation_datetime_accuracy) = validateAndGetDateAndAccuracy($excel_line_data['date injection en souris (année/mois/jour)'], 'Xenograft Creation', 'date injection en souris (année/mois/jour)', "See $excel_line_summary.");					
		list($qc_nd_collection_datetime, $qc_nd_collection_datetime_accuracy) = validateAndGetDateAndAccuracy($excel_line_data['Date récolte (année/mois/jour)'], 'Xenograft Creation', 'Date récolte (année/mois/jour)', "See $excel_line_summary.");
		
		$created_samples++;
		$created_xenografts++;
		$xenograft_sample_label = "XEN $fomatted_excel_cell_line_number";
		$sample_data = array(
			'sample_masters' => array(
				'collection_id' => $atim_collection_id,
				'sample_control_id' => $atim_controls['sample_controls']['xenograft']['id'],
				'initial_specimen_sample_id' => $atim_initial_specimen_sample_id,
				'initial_specimen_sample_type' => $atim_initial_specimen_sample_type,
				'parent_id' => $atim_parent_sample_master_id,
				'parent_sample_type' => $atim_parent_sample_type,
				'qc_nd_sample_label' => $xenograft_sample_label,
				'sample_code' => 'tmp_'.($created_samples),
				'notes' =>  'Created by the process to download the xenograft blocks data from excel file. '.$excel_line_data["Notes"]),
			'derivative_details' => array(
				'creation_by' => 'autre',
				'creation_datetime' => $creation_datetime,
				'creation_datetime_accuracy' => $creation_datetime_accuracy),
			$atim_controls['sample_controls']['xenograft']['detail_tablename'] => array(
				'qc_nd_clones' => $excel_line_data["clones"],
				'qc_nd_treatment' => $excel_line_data["tx"],
				'source_cell_passage_number' => $source_cell_passage_number,
				'species' => 'mouse',
				'qc_nd_collection_datetime' => $qc_nd_collection_datetime,
				'qc_nd_collection_datetime_accuracy' => $qc_nd_collection_datetime_accuracy
			)
		);
		$xenograft_sample_master_id = customInsertRecord($sample_data);
		customInsertRecord(array('source_aliquots' => array('aliquot_master_id' => $atim_source_aliquot_master_id, 'sample_master_id' => $xenograft_sample_master_id)));
		
		// Create Aliquot
		
		list($storage_master_id, $storage_coord_x) = setStorageData($excel_line_data['Entreposage'], $excel_line_data['rangée']);
		
		$created_aliquots++;
		$created_xenograft_blocks++;
		$aliquot_data = array(
			'aliquot_masters' => array(
				"barcode" => 'tmp_'.($created_aliquots),
				"aliquot_label" => strlen($excel_line_data['Numéro (sur bloc)'])? $excel_line_data['Numéro (sur bloc)'] : $xenograft_sample_label,
				"aliquot_control_id" => $atim_controls['aliquot_controls']['xenograft-block']['id'],
				"collection_id" => $atim_collection_id,
				"sample_master_id" => $xenograft_sample_master_id,
				'in_stock' => 'yes - available',
				'storage_master_id' => $storage_master_id, 
				'storage_coord_x' => $storage_coord_x,
				'notes' => "Created by the process to download the xenograft blocks data from excel file."),
			$atim_controls['aliquot_controls']['xenograft-block']['detail_tablename'] => array(
				'block_type' => 'paraffin'
			)
		);
		$atim_xenograft_block_aliquot_master_id = customInsertRecord($aliquot_data);

		if(strlen($excel_line_data['utilisation (utilisateur et date)'])) {
			$tmp_use = array(
				"use_code" => $excel_line_data['utilisation (utilisateur et date)'],
				'use_datetime' => '',
				'use_datetime_accuracy' => '',
				'used_by' => '');
			switch($excel_line_data['utilisation (utilisateur et date)']) {
				case 'Kayla Simeone 2017-02-02':
					$tmp_use = array(
						'use_datetime' => '2017-02-02',
						'use_datetime_accuracy' => 'h',
						'used_by' => 'Kayla Simeone');
					break;
				case 'Kayla used 21 sept. 2016':
					$tmp_use = array(
						'use_datetime' => '2016-09-21',
						'use_datetime_accuracy' => 'h',
						'used_by' => 'Kayla Simeone');
					break;
				case 'Kayla 30 sept. 2016':
					$tmp_use = array(
						'use_datetime' => '2016-09-30',
						'use_datetime_accuracy' => 'h',
						'used_by' => 'Kayla Simeone');
					break;
				case 'Liliane TMA (fin novembre 2016)':
					$tmp_use = array(
						"use_code" => 'TMA',
						'use_datetime' => '2016-11-01',
						'use_datetime_accuracy' => 'd',
						'used_by' => 'liliane meunier');
					break;
			}
			$aliquot_use_data = array(
				'aliquot_internal_uses' => array_merge(
					array(
						"aliquot_master_id" => $atim_xenograft_block_aliquot_master_id,
						"type" => 'internal use',
						"use_details" => "Created by the process to download the xenograft blocks data from excel file."),
					$tmp_use
				)
			);
			customInsertRecord($aliquot_use_data);
		}
	}
}
		
recordErrorAndMessage("Xenograft Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Linked xenograft to $found_parent_cell_cultures cell cultures found into ATiM");
recordErrorAndMessage("Xenograft Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_parent_cell_cultures cell cultures into ATiM");
recordErrorAndMessage("Xenograft Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Linked xenograft to $found_parent_cell_culture_aliquots cell culture aliquots found into ATiM");
recordErrorAndMessage("Xenograft Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_parent_cell_culture_aliquots cell culture aliquots into ATiM");
recordErrorAndMessage("Xenograft Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_xenografts xenografts into ATiM");
recordErrorAndMessage("Xenograft Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_xenograft_blocks  xenograft blocks into ATiM");
recordErrorAndMessage("Xenograft Creation Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created ".sizeof($created_storages)."  xenograft drawers into ATiM");

$final_queries = array(
		"UPDATE sample_masters SET sample_code = id WHERE sample_code LIKE 'tmp_%';",
		"UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE 'tmp__%';",
		"UPDATE storage_masters SET code = id WHERE code LIKE 'tmp_%';",
//TODO REMOVE		
		"UPDATE versions SET permissions_regenerated = 0;"
);

foreach($final_queries as $new_query) customQuery($new_query);

//TODO REMOVE
//TODO viewUpdate();
//TODO END REMOVE

insertIntoRevsBasedOnModifiedValues();

dislayErrorAndMessage(true);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function truncate() {
	global $migration_user_id;

	$truncate_date_limnite = '2017-04-26';
	$truncate_queries = array(
		"DELETE FROM aliquot_internal_uses WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite'",
		"DELETE FROM source_aliquots WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  ad_tubes WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  ad_tubes_revs WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  ad_blocks WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  ad_blocks_revs WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM aliquot_masters  WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite';",
		"DELETE FROM aliquot_masters_revs  WHERE modified_by = $migration_user_id AND version_created > '$truncate_date_limnite';",
		"DELETE FROM  sd_der_xenografts WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  sd_der_xenografts_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  sd_der_cell_cultures WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  sd_der_cell_cultures_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  derivative_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"DELETE FROM  derivative_details_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')",
		"UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null  WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite'",
		"DELETE FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite'",
		"DELETE FROM sample_masters_revs WHERE modified_by = $migration_user_id AND version_created > '$truncate_date_limnite';");
	foreach($truncate_queries as $query) customQuery($query, __FILE__, __LINE__);
}

function setStorageData($excel_drawer_label, $excel_position) {
	global $atim_controls;
	global $created_storages;

	$storage_matches = array(
    	'Tiroir xeno ovaire #4' => 'Xeno#4',
    	'Tiroir xeno ovaire #1' => 'Xeno#1',
    	'Tiroir xeno ovaire #3' => 'Xeno#3',
    	'Tiroir xeno ovaire #2' => 'Xeno#2'
	);
	
	$storage_master_id = null;
	$position_x = null;
	
	if(strlen($excel_drawer_label)) {
		if(!preg_match('/^Tiroir xeno ovaire #([0-9]+)$/', $excel_drawer_label, $matches)) {
			die('ERR 11111 '.$excel_drawer_label);
		} else {
			$excel_drawer_label_short = 'Xeno#'.$matches[1];
			if(!preg_match('/^[1-7]$/', $excel_position)) {
				die('ERR 11112 '.$excel_drawer_label.' '.$excel_position);
			} else {
				if(!isset($created_storages[$excel_drawer_label_short])) {
					$query = "SELECT id FROM storage_masters WHERE storage_control_id = ".$atim_controls['storage_controls']['drawer7']['id']." AND deleted <> 1 AND selection_label = '$excel_drawer_label_short'";
					$atim_data = getSelectQueryResult($query);
					if($atim_data) {
						$storage_master_id = $atim_data[0]['id'];
					} else {
						$storage_data = array(
							'storage_masters' => array(
								"code" => 'tmp_'.sizeof($created_storages),
								"short_label" => $excel_drawer_label_short,
								"selection_label" => $excel_drawer_label_short,
								"storage_control_id" => $atim_controls['storage_controls']['drawer7']['id'],
								'notes' => 'Created by the process to download the pathology blocks data from excel file.'),
							$atim_controls['storage_controls']['drawer7']['detail_tablename'] => array());
						$storage_master_id = customInsertRecord($storage_data);
					}
					$created_storages[$excel_drawer_label_short] = $storage_master_id;
				} 
				$storage_master_id = $created_storages[$excel_drawer_label_short];
				$position_x = $excel_position;
			}			
		}
	}
	
	return 	array($storage_master_id ,$position_x);
}

function viewUpdate() {
	global $migration_user_id;

	$truncate_date_limnite = '2017-04-26';
	
	$view_sample_table_query = '
		SELECT SampleMaster.id AS sample_master_id,
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
		
MiscIdentifier.identifier_value AS identifier_value,
Collection.visit_label AS visit_label,
Collection.diagnosis_master_id AS diagnosis_master_id,
Collection.consent_master_id AS consent_master_id,
SampleMaster.qc_nd_sample_label AS qc_nd_sample_label
	
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
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
		WHERE SampleMaster.deleted != 1 AND SampleMaster.id IN  (SELECT id FROM sample_masters WHERE created_by = '.$migration_user_id.' AND created > "'.$truncate_date_limnite.'")';
	
	$view_aliquot_table_query =
		'SELECT
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
			AliquotMaster.in_stock_detail,
			StudySummary.title AS study_summary_title,
			StudySummary.id AS study_summary_id,
		
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
	
			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes,
		
MiscIdentifier.identifier_value AS identifier_value,
Collection.visit_label AS visit_label,
Collection.diagnosis_master_id AS diagnosis_master_id,
Collection.consent_master_id AS consent_master_id,
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
			LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
			WHERE AliquotMaster.deleted != 1 AND AliquotMaster.id IN  (SELECT id FROM aliquot_masters WHERE created_by = '.$migration_user_id.' AND created > "'.$truncate_date_limnite.'")';
	
	$view_aliquot_use_table_query_1 =
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
			StudySummary.id AS study_summary_id,
			StudySummary.title AS study_title
			FROM aliquot_internal_uses AS AliquotInternalUse
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
			LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotInternalUse.study_summary_id AND StudySummary.deleted != 1
			WHERE AliquotInternalUse.deleted <> 1 AND AliquotInternalUse.created_by = '$migration_user_id' AND AliquotInternalUse.created > '$truncate_date_limnite'";
	
	$view_aliquot_use_table_query_2 =
		"SELECT CONCAT(SourceAliquot.id,1) AS `id`,
			AliquotMaster.id AS aliquot_master_id,
			CONCAT('sample derivative creation#', SampleMaster.sample_control_id) AS use_definition,
	--		SampleMaster.sample_code AS use_code,
	CONCAT(SampleMaster.qc_nd_sample_label, ' [', SampleMaster.sample_code,']') AS use_code,
			'' AS `use_details`,
			SourceAliquot.used_volume AS used_volume,
			AliquotControl.volume_unit AS aliquot_volume_unit,
			DerivativeDetail.creation_datetime AS use_datetime,
			DerivativeDetail.creation_datetime_accuracy AS use_datetime_accuracy,
			NULL AS `duration`,
			'' AS `duration_unit`,
			DerivativeDetail.creation_by AS used_by,
			SourceAliquot.created AS created,
			CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
			SampleMaster2.id AS sample_master_id,
			SampleMaster2.collection_id AS collection_id,
			NULL AS study_summary_id,
			'' AS study_title
			FROM source_aliquots AS SourceAliquot
			JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
			JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
			JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
			JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
			WHERE SourceAliquot.deleted <> 1 AND SourceAliquot.created_by = '$migration_user_id' AND SourceAliquot.created > '$truncate_date_limnite'";
	
	customQuery("DELETE FROM view_samples WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = '$migration_user_id' AND created > '$truncate_date_limnite')", __FILE__, __LINE__);
	customQuery("DELETE FROM view_aliquots WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = '$migration_user_id' AND created > '$truncate_date_limnite')", __FILE__, __LINE__);
	
	customQuery("INSERT INTO view_samples($view_sample_table_query)", __FILE__, __LINE__);
	customQuery( "INSERT INTO view_aliquots($view_aliquot_table_query)", __FILE__, __LINE__);
	
	customQuery("DELETE FROM view_aliquot_uses WHERE created  > '$truncate_date_limnite'", __FILE__, __LINE__);
	customQuery( "INSERT INTO view_aliquot_uses($view_aliquot_use_table_query_1)", __FILE__, __LINE__);
	customQuery( "INSERT INTO view_aliquot_uses($view_aliquot_use_table_query_2)", __FILE__, __LINE__);

	
}