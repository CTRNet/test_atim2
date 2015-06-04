<?php

//First Line of any main.php file
require_once 'system.php';

//==============================================================================================
// Custom Require Section
//==============================================================================================

//==============================================================================================
// Custom Variables
//==============================================================================================

//==============================================================================================
// Main Code
//==============================================================================================

displayMigrationTitle('CPCBN TMA Block Creation + First Revision Record');

//---------------------------------------------------------------------------------------------
// INITIATE
//---------------------------------------------------------------------------------------------

$queries = array(
	"TRUNCATE qc_tf_ar_tissue_cores;", "TRUNCATE qc_tf_ar_tissue_cores_revs;",
	"DELETE FROM  aliquot_review_masters;", "DELETE FROM  aliquot_review_masters_revs;",
	"TRUNCATE qc_tf_spr_tissue_cores;", "TRUNCATE qc_tf_spr_tissue_cores_revs;",
	"DELETE FROM  specimen_review_masters;", "DELETE FROM  specimen_review_masters_revs;",
		
	"TRUNCATE ad_tissue_cores;", "TRUNCATE ad_tissue_cores_revs;",
	"DELETE FROM aliquot_masters;", "DELETE FROM aliquot_masters_revs;",
	"TRUNCATE sd_spe_tissues;", "TRUNCATE sd_spe_tissues_revs;",
	"TRUNCATE specimen_details;", "TRUNCATE specimen_details_revs;",
	"UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null;",
	"DELETE FROM sample_masters;", "DELETE FROM sample_masters_revs;",
	
	"TRUNCATE std_tma_blocks;", "TRUNCATE std_tma_blocks_revs;",
	"UPDATE storage_masters SET parent_id = null;",
	"DELETE FROM storage_masters;", "DELETE FROM storage_masters_revs;",
		
	"DELETE FROM collections WHERE collection_property = 'independent collection'",
	"DELETE FROM collections_revs WHERE collection_property = 'independent collection'",
);
foreach($queries as $query) customQuery($query);

global $banks_to_ids;
$banks_to_id = array();
foreach(getSelectQueryResult("SELECT id,name FROM banks;") as $new_bank) {
	$banks_to_ids[(preg_match('/^(.+)\ #[0-9]$/', $new_bank['name'], $matches)? $matches[1]: $new_bank['name'])] = $new_bank['id'];
}

global $storage_to_ids;
$storage_to_ids = array();

//---------------------------------------------------------------------------------------------
// Get participant & collection data
//---------------------------------------------------------------------------------------------

$query = "SELECT Participant.participant_identifier, Participant.qc_tf_bank_participant_identifier, Bank.name AS bank_name, Collection.id AS collection_id
	FROM participants Participant INNER JOIN banks Bank ON Bank.id = Participant.qc_tf_bank_id LEFT JOIN collections Collection ON Collection.participant_id = Participant.id
	WHERE Participant.deleted <> 1;";
$atim_patient = array();
foreach(getSelectQueryResult($query) as $new_patient) {
	$tmp_patient_data = array(
		'participant_identifier' => $new_patient['participant_identifier'], 
		'bank_participant_identifier' => $new_patient['qc_tf_bank_participant_identifier'], 
		'bank_name' => preg_match('/^(.+)\ #[0-9]$/', $new_patient['bank_name'], $matches)? $matches[1] : $new_patient['bank_name'],
		'collection_id' => $new_patient['collection_id'],
		'sample_master_id' => null,
		'speciment_pathe_review_master_id' => null
	);
	if(isset($atim_patient[$tmp_patient_data['bank_name']][$tmp_patient_data['bank_participant_identifier']])) {
		recordErrorAndMessage('ATiM Patient Data', '@@WARNING@@', "Patient Linked to More Than One Collection", "The patient ".$tmp_patient_data['bank_participant_identifier']." of the bank ".$tmp_patient_data['bank_name']." is linked to more than one collection. Core will be linked to the first one.");
	} else {
		$atim_patient[$tmp_patient_data['bank_name']][$tmp_patient_data['bank_participant_identifier']] = $tmp_patient_data;
	}
}

//---------------------------------------------------------------------------------------------
// Create collection with marker
//---------------------------------------------------------------------------------------------

$controls_collections = array('collection_id' => null, 'sample_master_ids' => array());
$controls_collections['collection_id'] = customInsertRecord(array('collections' => array('collection_notes' => 'Collections gathering project controls', 'collection_property' => 'independent collection')));

//---------------------------------------------------------------------------------------------
// Parse File
//---------------------------------------------------------------------------------------------

recordErrorAndMessage('Core Creation', '@@MESSAGE@@', "ID ATiM value won't be take in consideration", "n/a.");

$excel_files = array(
	array('Optimisation_CPCBN_(2013-06-06)_03062015_CCVO.xls', 'TMA Layout '),
		
	array('150602_TMA_layout_ATiM_AA-1-2-3.xls', 'Core'),
	array('150602_TMA_layout_ATiM_AA-4-6-Repunch-test.xls', 'Core'),
	array('150602_TMA_layout_ATiM_FS1-2-3.xls', 'Core'),
	array('150602_TMA_layout_ATiM_FS4-5-Test-Repunch.xls', 'Core'),
	array('150602_TMA_layout_ATiM_LL1-2-3-5.xls', 'Core'),
	array('150602_TMA_layout_ATiM_LL-6-7-Test-Repunch_CC.xls', 'Core'),
	array('150602_TMA_layout_ATiM_MG-1-2-3-5.xls', 'Core'),
	array('150602_TMA_layout_ATiM_MG-4-6-TEAM-test-repunch-testrepunch.xls', 'Core'),
	array('150602_TMA_layout_ATiM_NF-1-2-3_CC.xls', 'Core'),
	array('150602_TMA_layout_ATiM_NF-4-5_CC.xls', 'Core')
);

$sample_counter = 0;
$aliquot_counter = 0;
foreach($excel_files as $excel_data) {
	list($excel_file_name, $worksheet_name) = $excel_data;
	recordErrorAndMessage('Parsed File', '@@MESSAGE@@', "Files Names Parsed", "$excel_file_name");
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
		if(($excel_line_data['ID Bank'] && $excel_line_data['ID Bank'] != '.') || ($excel_line_data['Dx Initial - Site'] && $excel_line_data['Dx Initial - Site'] != '.')) {		
			//Core To Rccord
			$storage_master_id = getStorageMasterId($excel_line_data['TMA name'], $excel_line_data['BANK'], $excel_line_data['TMA Label Site'], $excel_file_name, $worksheet_name, $line_number);
			if($storage_master_id) {
				$storage_coord_error = false;
				$storage_coord_x = $excel_line_data['Position X'];
				if(preg_match('/^(-1)|([0-9])|(1[0-9])|(2[0-7])$/', $storage_coord_x)) {
					$storage_coord_x += 2;
				} else {
					recordErrorAndMessage('Core Storage position', '@@WARNING@@', "Wrong x coordinate", "See position '$storage_coord_x'. No core will be migrated.  REF: $excel_file_name, $worksheet_name, $line_number.");
					$storage_coord_error = true;
				}
				$storage_coord_y = $excel_line_data['Position Y'];
				if(preg_match('/^(-1)|([0-9])|(1[0-9])|(2[0-7])$/', $storage_coord_y)) {
					$storage_coord_y += 2;
				} else {
					recordErrorAndMessage('Core Storage position', '@@WARNING@@', "Wrong y coordinate", "See position '$storage_coord_y'. No core will be migrated.  REF: $excel_file_name, $worksheet_name, $line_number.");
					$storage_coord_error = true;
				}
				if(!$storage_coord_error) {
					if($excel_line_data['ID Bank'] && $excel_line_data['ID Bank'] != '.') {
						// *** Site's TMA Block *** 
						// Should be site core inlcuded in a TMA block built by the site
						if(isset($atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']])) {
							//Create one sample
							$tissue_source = validateAndGetStructureDomainValue((isset($excel_line_data['Tissue'])? $excel_line_data['Tissue'] : ''), 'tissue_source_list', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
							if($tissue_source && $tissue_source != 'prostate') {
								recordErrorAndMessage('Core Creation', '@@ERROR@@', "Site's TMA block contains tissue different than 'prostate", "See patient '".$excel_line_data['ID Bank']."' of bank '".$excel_line_data['BANK']."'. Tissue will be considered as 'prostate tissue'. REF: $excel_file_name, $worksheet_name, $line_number.");
							}
							$tissue_source = 'prostate';
							if(!$atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['sample_master_id']) {
								$sample_counter++;
								$sample_data = array(
									'sample_masters' => array(
										"sample_code" => 'tmp_tissue_'.$sample_counter,
										"sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
										"initial_specimen_sample_type" => 'tissue',
										"collection_id" => $atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['collection_id']),
									'specimen_details' => array(),
									$atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
										'tissue_source' => $tissue_source));
								$atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['sample_master_id'] = customInsertRecord($sample_data);
							}
							//Create Core
							$site_nature = ($excel_line_data['Dx Initial - Site'] == '.')? '' : validateAndGetStructureDomainValue($excel_line_data['Dx Initial - Site'], 'qc_tf_tissue_core_nature', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
							$revised_nature = ($excel_line_data['Dx PathRev1 05-2015'] == '.')? '' : validateAndGetStructureDomainValue($excel_line_data['Dx PathRev1 05-2015'], 'qc_tf_tissue_core_nature', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
							$aliquot_counter++;
							$aliquot_data = array(
								'aliquot_masters' => array(
									"barcode" => 'tmp_core_'.$aliquot_counter,
									"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-core']['id'],
									"collection_id" => $atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['collection_id'],
									"sample_master_id" => $atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['sample_master_id'],
									'in_stock' => 'yes - available',
									'storage_master_id' => $storage_master_id,
									'storage_coord_x' => $storage_coord_x,
									'storage_coord_y' => $storage_coord_y,
									'use_counter' => '1',
									'notes' => (strlen($excel_line_data['Core #']) && $excel_line_data['Core #'] != '.')? 'Core # '.$excel_line_data['Core #'] : ''),
								$atim_controls['aliquot_controls']['tissue-core']['detail_tablename'] => array(
									'qc_tf_core_nature_site' => $site_nature,
									'qc_tf_core_nature_revised' => $revised_nature));
							$aliquot_master_id = customInsertRecord($aliquot_data);
							//Create path review
							$specimen_review_data = array(
								'specimen_review_masters' => array(
									'collection_id' => $atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['collection_id'],
									'sample_master_id' => $atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['sample_master_id'],
									'specimen_review_control_id' => $atim_controls['specimen_review_controls']['core review']['id'],
//TODO Date to change for new import										
									'review_date' => '2015-05-01',
									'review_date_accuracy' => 'd'),
								$atim_controls['specimen_review_controls']['core review']['detail_tablename'] => array());
							$specimen_review_master_id = customInsertRecord($specimen_review_data);
							$grade = ($excel_line_data['TMA Grade X+Y 05-2015'] == '.')? '' : validateAndGetStructureDomainValue($excel_line_data['TMA Grade X+Y 05-2015'], 'qc_tf_core_review_grade', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
							$aliquot_review_data = array(
								'aliquot_review_masters' => array(
									'aliquot_master_id' => $aliquot_master_id,
									'aliquot_review_control_id' => $atim_controls['specimen_review_controls']['core review']['aliquot_review_control_id'],
									'specimen_review_master_id' => $specimen_review_master_id),
								$atim_controls['specimen_review_controls']['core review']['aliquot_review_detail_tablename'] => array(
									'revised_nature' => $revised_nature,
									'grade' => $grade,
									'notes' => $excel_line_data['NotesReview1 05-2015']));	
							customInsertRecord($aliquot_review_data);
						} else {
							recordErrorAndMessage('Core Creation', '@@ERROR@@', "Patient Does Not Exist", "Patient '".$excel_line_data['ID Bank']."' of bank '".$excel_line_data['BANK']."' does not exist into ATiM. No core will be created! REF: $excel_file_name, $worksheet_name.",$worksheet_name.$excel_line_data['ID Bank'].$excel_line_data['BANK']);
						}
					} else {
						// *** Control TMA Block *** 
						// Not linked to an ATiM patient
						$tissue_source = validateAndGetStructureDomainValue((isset($excel_line_data['Tissue'])? $excel_line_data['Tissue'] : ''), 'tissue_source_list', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
						$qc_tf_tma_sample_control_bank_id = null;
						if(array_key_exists($excel_line_data['BANK'], $banks_to_ids)) {
							$qc_tf_tma_sample_control_bank_id = $banks_to_ids[$excel_line_data['BANK']];
						} else if(strlen($excel_line_data['BANK'])) {
							recordErrorAndMessage('Core Creation', '@@ERROR@@', "Bank unknown for a TMA block core", "See TMA ".$excel_line_data['TMA name']." and bank '".$excel_line_data['BANK']."'. REF: $excel_file_name, $worksheet_name, $line_number.", $excel_line_data['BANK']);
						}
						$sample_key = $excel_line_data['BANK'].$excel_line_data['Dx Initial - Site'].$tissue_source;
						if(!isset($controls_collections['sample_master_ids'][$sample_key])) {
							$sample_counter++;
							$sample_data = array(
								'sample_masters' => array(
									"sample_code" => 'tmp_tissue_'.$sample_counter,
									"sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
									"initial_specimen_sample_type" => 'tissue',
									"collection_id" => $controls_collections['collection_id'],
									'qc_tf_is_tma_sample_control' => 'y',
									'qc_tf_tma_sample_control_code' => $excel_line_data['Dx Initial - Site']),
								'specimen_details' => array(),
								$atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
									'tissue_source' => $tissue_source));
							if($qc_tf_tma_sample_control_bank_id) $sample_data['sample_masters']['qc_tf_tma_sample_control_bank_id'] = $qc_tf_tma_sample_control_bank_id;
							$controls_collections['sample_master_ids'][$sample_key] = customInsertRecord($sample_data);
						}
						//Create Core
						$revised_nature = ($excel_line_data['Dx PathRev1 05-2015'] == '.')? '' : validateAndGetStructureDomainValue($excel_line_data['Dx PathRev1 05-2015'], 'qc_tf_tissue_core_nature', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
						$notes = array();
						if(strlen($excel_line_data['Core #']) && $excel_line_data['Core #'] != '.') $notes[] = 'Core # '.$excel_line_data['Core #'].'.';
						if(strlen($excel_line_data['NotesReview1 05-2015']) && $excel_line_data['NotesReview1 05-2015'] != '.') $notes[] = 'Review ccl : '.$excel_line_data['NotesReview1 05-2015'].'.';
						$aliquot_counter++;
						$aliquot_data = array(
							'aliquot_masters' => array(
								"barcode" => 'tmp_core_'.$aliquot_counter,
								"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-core']['id'],
								"collection_id" => $controls_collections['collection_id'],
								"sample_master_id" => $controls_collections['sample_master_ids'][$sample_key],
								'in_stock' => 'yes - available',
								'storage_master_id' => $storage_master_id,
								'storage_coord_x' => $storage_coord_x,
								'storage_coord_y' => $storage_coord_y,
								'use_counter' => '0',
								'notes' => implode(' ', $notes)),
							$atim_controls['aliquot_controls']['tissue-core']['detail_tablename'] => array(
								'qc_tf_core_nature_site' => '',
								'qc_tf_core_nature_revised' => $revised_nature));
						customInsertRecord($aliquot_data);
					}
				}
			}			
		} else if($excel_line_data['ID ATiM'] && $excel_line_data['ID ATiM'] != '.') {
			recordErrorAndMessage('Core Creation', '@@ERROR@@', "ID ATiM value set with no 'ID Bank' or 'Dx Initial - Site'", "See value (".$excel_line_data['ID ATiM']."). No core will be created.  REF: $excel_file_name, $worksheet_name, $line_number.");	
		}
	}	
}

$query = "UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE sample_control_id=". $atim_controls['sample_controls']['tissue']['id']." AND sample_code LIKE 'tmp_tissue_%';";
customQuery($query);
$query = "UPDATE aliquot_masters SET barcode=id WHERE aliquot_control_id=". $atim_controls['aliquot_controls']['tissue-core']['id']." AND barcode LIKE 'tmp_core_%';";
customQuery($query);

dislayErrorAndMessage(true);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function getStorageMasterId($tma_name, $bank, $tma_label_site, $excel_file_name, $worksheet_name, $line_number) {
	global $banks_to_ids;
	global $storage_to_ids;
	global $atim_controls;
	global $import_summary;
	
	$storage_master_id = false;
	
	if($tma_name) {
		if(isset($storage_to_ids[$tma_name])) {
			if(!empty($tma_label_site) && $tma_label_site !=  $storage_to_ids[$tma_name]['tma_label_site']) {
				if(array_key_exists($bank, $banks_to_ids)) {
					$storage_data = array();
					$storage_data['storage_masters']['qc_tf_tma_label_site'] = $tma_label_site;
					$storage_data['storage_masters']['qc_tf_bank_id'] = $banks_to_ids[$bank];
					updateTableData($storage_master_id = $storage_to_ids[$tma_name]['id'], $storage_data);
					$storage_master_id = $storage_to_ids[$tma_name]['tma_label_site'] = $tma_label_site;
					if(isset($import_summary['TMA Block Creation']['@@WARNING@@']["Bank not defined but tma site label defined"]["$tma_name ($tma_label_site)"])) {
						unset($import_summary['TMA Block Creation']['@@WARNING@@']["Bank not defined but tma site label defined"]["$tma_name ($tma_label_site)"]);
						if(empty($import_summary['TMA Block Creation']['@@WARNING@@']["Bank not defined but tma site label defined"])) unset($import_summary['TMA Block Creation']['@@WARNING@@']["Bank not defined but tma site label defined"]);
					} else {
						recordErrorAndMessage('TMA Block Creation', '@@MESSAGE@@', "Tma site label updated", "See TMA $tma_name ($tma_label_site) for bank '$bank'. Label Site has been updated. REF: $excel_file_name, $worksheet_name, $line_number.");
					}
				} else {
					if(empty($bank)) {
						recordErrorAndMessage('TMA Block Creation', '@@WARNING@@', "Bank not defined but tma site label defined", "See TMA $tma_name ($tma_label_site). Label Site is defined but no bank is defined. Label Site and bank won't be linked to the created TMA. See if this TMA data will be updated before the end of the process. REF: $excel_file_name, $worksheet_name, $line_number.","$tma_name ($tma_label_site)");
					} else {
						recordErrorAndMessage('TMA Block Creation', '@@ERROR@@', "Bank unknown for a TMA block of a site", "See TMA $tma_name and bank $bank. Label Site and bank won't be linked to the created TMA. REF: $excel_file_name, $worksheet_name, $line_number.");
					}
				}
			}
		} else {
			$storage_data = array(
				'storage_masters' => array(
					'code' => (sizeof($storage_to_ids) + 1),
					'storage_control_id' => $atim_controls['storage_controls']['TMA-blc 29X29']['id'],
					'qc_tf_tma_name' => $tma_name,
					'short_label' => 'TMA'.(sizeof($storage_to_ids) + 1),
					'selection_label' => 'TMA'.(sizeof($storage_to_ids) + 1)),
				$atim_controls['storage_controls']['TMA-blc 29X29']['detail_tablename'] => array());
			if(!empty($tma_label_site)) {
				if(array_key_exists($bank, $banks_to_ids)) {
					$storage_data['storage_masters']['qc_tf_tma_label_site'] = $tma_label_site;
					$storage_data['storage_masters']['qc_tf_bank_id'] = $banks_to_ids[$bank];
				} else {
					if(empty($bank)) {
						recordErrorAndMessage('TMA Block Creation', '@@WARNING@@', "Bank not defined but tma site label defined", "See TMA $tma_name ($tma_label_site). Label Site is defined but no bank is defined. Label Site and bank won't be linked to the created TMA. See if this TMA data will be updated before the end of the process. REF: $excel_file_name, $worksheet_name, $line_number.","$tma_name ($tma_label_site)");
					} else {
						recordErrorAndMessage('TMA Block Creation', '@@ERROR@@', "Bank unknown for a TMA block of a site", "See TMA $tma_name and bank $bank. Label Site and bank won't be linked to the created TMA. REF: $excel_file_name, $worksheet_name, $line_number.");
					}
					$tma_label_site = '';
				}
			}
			$storage_to_ids[$tma_name] = array('id' => customInsertRecord($storage_data), 'tma_label_site' => $tma_label_site);
		}
		$storage_master_id = $storage_to_ids[$tma_name]['id'];
	}
	
	return $storage_master_id;
}
		
?>
		