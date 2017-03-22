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

global $banks_to_ids;
$banks_to_id = array();
foreach(getSelectQueryResult("SELECT id,name FROM banks;") as $new_bank) {
	$banks_to_ids[(preg_match('/^(.+)\ #[0-9]$/', $new_bank['name'], $matches)? $matches[1]: $new_bank['name'])] = $new_bank['id'];
}

global $tma_name_to_storage_data;
$tma_name_to_storage_data = array();

//---------------------------------------------------------------------------------------------
// REMOVE TMA
//---------------------------------------------------------------------------------------------

if($tma_name_to_remove) {
	foreach($tma_name_to_remove as $tma_name) {
		$existing_tma = getSelectQueryResult("SELECT StorageMaster.id AS storage_master_id, qc_tf_tma_label_site, qc_tf_bank_id, Bank.name as bank_name
			FROM storage_masters StorageMaster LEFT JOIN banks Bank ON Bank.id = StorageMaster.qc_tf_bank_id AND Bank.deleted <> 1
			WHERE StorageMaster.deleted <> 1 AND StorageMaster.storage_control_id = ".$atim_controls['storage_controls']['TMA-blc 29X29']['id']."
			AND qc_tf_tma_name = '$tma_name'");
		if(sizeof($existing_tma) > 1) migrationDie("More than one TMA $tma_name exist into ATiM");
		if($existing_tma) {
			$existing_tma = array_shift($existing_tma);
			$tma_storage_master_id = $existing_tma['storage_master_id'];
			$deleted_aliquots_master_ids = array();
			$query = "SELECT id FROM aliquot_masters WHERE deleted <> 1 AND aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-core']['id']." AND storage_master_id = $tma_storage_master_id;";
			foreach(getSelectQueryResult($query) as $new_aliquot_to_delete) {
				$deleted_aliquots_master_ids[] = $new_aliquot_to_delete['id'];
			}
			$deleted_aliquot_count = sizeof($deleted_aliquots_master_ids);
			//Delete aliquot_review_masters
			$query = "SELECT id, aliquot_master_id FROM aliquot_review_masters WHERE deleted <> 1 AND aliquot_review_control_id = ".$atim_controls['specimen_review_controls']['core review']['aliquot_review_control_id']." AND aliquot_master_id IN (".implode(',',$deleted_aliquots_master_ids).")";
			foreach(getSelectQueryResult($query) as $new_aliquot_review_to_delete) {
				updateTableData($new_aliquot_review_to_delete['id'], array('aliquot_review_masters' => array('deleted' => '1')));
			}
			//Delete aliquot_masters
			foreach($deleted_aliquots_master_ids as $new_aliquot_master_id_to_delete) {
				updateTableData($new_aliquot_master_id_to_delete, array('aliquot_masters' => array('deleted' => '1')));
			}
			//Delete specimen_review_masters 
			$query = "SELECT id FROM specimen_review_masters WHERE deleted <> 1 AND id NOT IN (SELECT specimen_review_master_id FROM aliquot_review_masters WHERE deleted <> 1)";
			foreach(getSelectQueryResult($query) as $new_specimen_review_to_delete) {
				updateTableData($new_specimen_review_to_delete['id'], array('specimen_review_masters' => array('deleted' => '1')));
			}
			//Delete sample_masters 
			$query = "SELECT id FROM sample_masters WHERE deleted <> 1 
				AND id NOT IN (SELECT sample_master_id FROM specimen_review_masters WHERE deleted <> 1)
				AND id NOT IN (SELECT sample_master_id FROM aliquot_masters WHERE deleted <> 1)";
			foreach(getSelectQueryResult($query) as $new_sample_to_delete) {
				updateTableData($new_sample_to_delete['id'], array('sample_masters' => array('deleted' => '1')));
			}
			//Delete sample_masters
			updateTableData($tma_storage_master_id, array('storage_masters' => array('deleted' => '1')));
			recordErrorAndMessage('Removed TMA', '@@MESSAGE@@', "Removed TMA", "Rmoved TMA : $tma_name and $deleted_aliquot_count cores.");
		} else {
			recordErrorAndMessage('Removed TMA', '@@WARNING@@', "TMA to remove has noe been found", "See TMA : $tma_name.");
		}
	}
}

//---------------------------------------------------------------------------------------------
// Get participant & collection data
//---------------------------------------------------------------------------------------------

$query = "SELECT Participant.id AS participant_id, 
		Participant.participant_identifier, 
		Participant.qc_tf_bank_participant_identifier, 
		Bank.name AS bank_name, 
		Collection.id AS collection_id
	FROM participants Participant 
	INNER JOIN banks Bank ON Bank.id = Participant.qc_tf_bank_id AND Bank.deleted <> 1 
	LEFT JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
	WHERE Participant.deleted <> 1;";
$atim_patient = array();
foreach(getSelectQueryResult($query) as $new_patient) {
	$tmp_patient_data = array(
		'participant_id' => $new_patient['participant_id'], 
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
// get collection with existing marker
//---------------------------------------------------------------------------------------------

$controls_collections = array('collection_id' => null, 'sample_master_ids' => array());
$query = "SELECT Collection.id as collection_id, SampleMaster.id AS sample_master_id, Bank.name as bank_name, SampleMaster.qc_tf_tma_sample_control_code as dx_initial_site, SampleDetail.tissue_source
	FROM collections Collection
	INNER JOIN sample_masters SampleMaster ON Collection.id = SampleMaster.collection_id AND SampleMaster.deleted <> 1 AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
	INNER JOIN ".$atim_controls['sample_controls']['tissue']['detail_tablename']." SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
	LEFT JOIN banks Bank ON Bank.id = SampleMaster.qc_tf_tma_sample_control_bank_id AND Bank.deleted <> 1
	WHERE Collection.collection_property = 'independent collection' AND Collection.deleted <> 1";
$collection_id = array();
foreach(getSelectQueryResult($query) as $new_sample_flagged_control) {
	$sample_key = $new_sample_flagged_control['bank_name'].$new_sample_flagged_control['dx_initial_site'].$new_sample_flagged_control['tissue_source'];
	$controls_collections['sample_master_ids'][$sample_key] = $new_sample_flagged_control['sample_master_id'];
	$collection_id[$new_sample_flagged_control['collection_id']] = $new_sample_flagged_control['collection_id'];
}
if(sizeof($collection_id) != 1)  migrationDie("More than one 'independent collection' into ATiM");
$controls_collections['collection_id'] = array_shift($collection_id);					

//---------------------------------------------------------------------------------------------
// Parse File
//---------------------------------------------------------------------------------------------

recordErrorAndMessage('Core Creation', '@@MESSAGE@@', "ID ATiM value won't be take in consideration", "n/a.");

$sample_counter = 0;
$aliquot_counter = 0;
foreach($excel_files as $excel_data) {
	list($excel_file_name, $worksheet_name, $review_date, $review_date_accuracy, $review_field_extension) = $excel_data;
	recordErrorAndMessage('Parsed Files and created TMA', '@@MESSAGE@@', "Files Names & TMA Name", "FILE : $excel_file_name");
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
		if(array_key_exists('Tissue', $excel_line_data)) migrationDie('Tissue column name has to be change to Tissu');
		if(!array_key_exists('Dx PathRev1'.$review_field_extension, $excel_line_data)) migrationDie("Field 'Dx PathRev1$review_field_extension' does not exist. Process failed. Please review arg 5th of config variable ".'$excel_files.');
		if(!array_key_exists('NotesReview1'.$review_field_extension, $excel_line_data)) migrationDie("Field 'NotesReview1$review_field_extension' does not exist. Process failed. Please review arg 5th of config variable ".'$excel_files.');
		if(!array_key_exists('TMA Grade X+Y'.$review_field_extension, $excel_line_data)) migrationDie("Field 'TMA Grade X+Y$review_field_extension' does not exist. Process failed. Please review arg 5th of config variable ".'$excel_files.');
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
						if(!isset($atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']])) {
							recordErrorAndMessage('Core Creation', '@@ERROR@@', "Patient Does Not Exist", "Patient '".$excel_line_data['ID Bank']."' of bank '".$excel_line_data['BANK']."' does not exist into ATiM. No core will be created! REF: $excel_file_name, $worksheet_name.",$worksheet_name.$excel_line_data['ID Bank'].$excel_line_data['BANK']);
						} else {
							if(empty($atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['collection_id'])) {						
								$collection_data = array(
									'collections' => array(
										'participant_id' => $atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['participant_id'],
										'collection_property' => 'participant collection'));
								$atim_patient[$excel_line_data['BANK']][$excel_line_data['ID Bank']]['collection_id'] = customInsertRecord($collection_data);
								recordErrorAndMessage('Core Creation', '@@WARNING@@', "Patient With No Collection", "Patient '".$excel_line_data['ID Bank']."' of bank '".$excel_line_data['BANK']."' was not linked to a collection into ATiM. System created a collection. Please review created collectoin plus complete data as collection site, collection type, collection date. REF: $excel_file_name, $worksheet_name.",$worksheet_name.$excel_line_data['ID Bank'].$excel_line_data['BANK']);
							}
							//Create one sample
							$tissue_source = validateAndGetStructureDomainValue((isset($excel_line_data['Tissu'])? $excel_line_data['Tissu'] : ''), 'tissue_source_list', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
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
							$revised_nature = ($excel_line_data['Dx PathRev1'.$review_field_extension] == '.')? '' : validateAndGetStructureDomainValue($excel_line_data['Dx PathRev1'.$review_field_extension], 'qc_tf_tissue_core_nature', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
							$aliquot_counter++;
							$aliquot_data = array(
								'aliquot_masters' => array(
									"barcode" => 'tmp_core_'.$aliquot_counter,
									"aliquot_label" => substr(strtoupper(strlen($revised_nature)? $revised_nature : (strlen($site_nature)? $site_nature : 'U')), 0, 1),
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
									'review_date' => $review_date,
									'review_date_accuracy' => $review_date_accuracy),
								$atim_controls['specimen_review_controls']['core review']['detail_tablename'] => array());
							$specimen_review_master_id = customInsertRecord($specimen_review_data);
							$grade = ($excel_line_data['TMA Grade X+Y'.$review_field_extension] == '.')? '' : validateAndGetStructureDomainValue($excel_line_data['TMA Grade X+Y'.$review_field_extension], 'qc_tf_core_review_grade', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
							$aliquot_review_data = array(
								'aliquot_review_masters' => array(
									'aliquot_master_id' => $aliquot_master_id,
									'aliquot_review_control_id' => $atim_controls['specimen_review_controls']['core review']['aliquot_review_control_id'],
									'specimen_review_master_id' => $specimen_review_master_id),
								$atim_controls['specimen_review_controls']['core review']['aliquot_review_detail_tablename'] => array(
									'revised_nature' => $revised_nature,
									'grade' => $grade,
									'notes' => $excel_line_data['NotesReview1'.$review_field_extension]));	
							customInsertRecord($aliquot_review_data);
						}
					} else {
						// *** Control TMA Block *** 
						// Not linked to an ATiM patient
						$tissue_source = validateAndGetStructureDomainValue((isset($excel_line_data['Tissu'])? $excel_line_data['Tissu'] : ''), 'tissue_source_list', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
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
						$revised_nature = ($excel_line_data['Dx PathRev1'.$review_field_extension] == '.')? '' : validateAndGetStructureDomainValue($excel_line_data['Dx PathRev1'.$review_field_extension], 'qc_tf_tissue_core_nature', 'Core Creation', '', "REF: $excel_file_name, $worksheet_name, $line_number.");
						$notes = array();
						if(strlen($excel_line_data['Core #']) && $excel_line_data['Core #'] != '.') $notes[] = 'Core # '.$excel_line_data['Core #'].'.';
						if(strlen($excel_line_data['NotesReview1'.$review_field_extension]) && $excel_line_data['NotesReview1'.$review_field_extension] != '.') $notes[] = 'Review ccl : '.$excel_line_data['NotesReview1'.$review_field_extension].'.';
						$aliquot_counter++;
						$site_nature = '';
						$aliquot_data = array(
							'aliquot_masters' => array(
								"barcode" => 'tmp_core_'.$aliquot_counter,
								"aliquot_label" => substr(strtoupper(strlen($revised_nature)? $revised_nature : (strlen($site_nature)? $site_nature : 'U')), 0, 1),
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
								'qc_tf_core_nature_site' => $site_nature,
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

updateTMABankAndSiteLabel();

$query = "UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE sample_control_id=". $atim_controls['sample_controls']['tissue']['id']." AND sample_code LIKE 'tmp_tissue_%';";
customQuery($query);
$query = "UPDATE aliquot_masters SET barcode=id WHERE aliquot_control_id=". $atim_controls['aliquot_controls']['tissue-core']['id']." AND barcode LIKE 'tmp_core_%';";
customQuery($query);


$query = "UPDATE storage_masters SET code=id, short_label = CONCAT('TMA',id), selection_label = CONCAT('TMA',id) WHERE code LIKE 'tmp%'";
customQuery($query);
		
customQuery("UPDATE storage_masters  SET lft = null, rght = null;");
customQuery("UPDATE versions SET permissions_regenerated = 0;");

dislayErrorAndMessage(true);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function getStorageMasterId($tma_name, $bank, $tma_label_site, $excel_file_name, $worksheet_name, $line_number) {
	global $banks_to_ids;
	global $tma_name_to_storage_data;
	global $atim_controls;
	global $import_summary;
	
	$storage_master_id = false;
	
	if($tma_name) {
		if(isset($tma_name_to_storage_data[$tma_name])) {
			if(!empty($tma_label_site)) {
				if(empty($tma_name_to_storage_data[$tma_name]['qc_tf_tma_label_site'])) {
					$tma_name_to_storage_data[$tma_name]['qc_tf_tma_label_site'] = $tma_label_site;
				} else if ($tma_name_to_storage_data[$tma_name]['qc_tf_tma_label_site'] != $tma_label_site) {
					recordErrorAndMessage('TMA Block Creation', '@@ERROR@@', "Tma site label unconsistant", "See TMA $tma_name and the 2 TMA Site labels ($tma_label_site != ".$tma_name_to_storage_data[$tma_name]['qc_tf_tma_label_site']."). Please check and correct. REF: $excel_file_name, $worksheet_name, $line_number.");	
				}
			}
			if($bank) {
				if(array_key_exists($bank, $banks_to_ids)) {
					$qc_tf_bank_id = $banks_to_ids[$bank];
					if(empty($tma_name_to_storage_data[$tma_name]['qc_tf_bank_id'])) {
						$tma_name_to_storage_data[$tma_name]['qc_tf_bank_id'] = $qc_tf_bank_id;
						$tma_name_to_storage_data[$tma_name]['bank_name'] = $bank;
					} else if ($tma_name_to_storage_data[$tma_name]['qc_tf_bank_id'] != $qc_tf_bank_id) {
						recordErrorAndMessage('TMA Block Creation', '@@WARNING@@', "Tma bank unconsistant", "See TMA $tma_name and the 2 TMA banks ($bank != ".$tma_name_to_storage_data[$tma_name]['bank_name']."). Please validate the bank of the TMA after migration after migration and correct if if required (set no bank if TMA gathers core of many banks) plus check all tma cores provider. REF: $excel_file_name, $worksheet_name, $line_number.", "$tma_name $bank ".$tma_name_to_storage_data[$tma_name]['bank_name']);
					}
				} else {
					recordErrorAndMessage('TMA Block Creation', '@@ERROR@@', "Bank unknown for a TMA block of a site", "See TMA $tma_name and bank $bank. Bank won't be linked to the created TMA. REF: $excel_file_name, $worksheet_name, $line_number.");
				}
			}
		} else {
			$existing_tma = getSelectQueryResult("SELECT StorageMaster.id AS storage_master_id, qc_tf_tma_label_site, qc_tf_bank_id, Bank.name as bank_name
				FROM storage_masters StorageMaster LEFT JOIN banks Bank ON Bank.id = StorageMaster.qc_tf_bank_id AND Bank.deleted <> 1 
				WHERE StorageMaster.deleted <> 1 AND StorageMaster.storage_control_id = ".$atim_controls['storage_controls']['TMA-blc 29X29']['id']."
				AND qc_tf_tma_name = '$tma_name'");
			if(sizeof($existing_tma) > 1) migrationDie("More than one TMA $tma_name exist into ATiM");
			if($existing_tma) {
				$existing_tma = array_shift($existing_tma);
				$tma_name_to_storage_data[$tma_name] = array(
					'id' => $existing_tma['storage_master_id'],
					'qc_tf_tma_label_site' => $existing_tma['qc_tf_tma_label_site'],
					'qc_tf_bank_id' => $existing_tma['qc_tf_bank_id'],
					'bank_name' => (preg_match('/^(.+)\ #[0-9]$/', $existing_tma['bank_name'], $matches)? $matches[1]: $existing_tma['bank_name'])
				);
				recordErrorAndMessage('Parsed Files and created TMA', '@@WARNING@@', "TMA Name was already created into ATiM", "See TMA : $tma_name [FROM FILE : $excel_file_name]. Please check data (TMA, core, etc) has not been duplicated!");
			} else {
				$storage_data = array(
					'storage_masters' => array(
						'code' => 'tmp'.(sizeof($tma_name_to_storage_data) + 1),
						'storage_control_id' => $atim_controls['storage_controls']['TMA-blc 29X29']['id'],
						'qc_tf_tma_name' => $tma_name,
						'short_label' => 'tmp'.'TMA'.(sizeof($tma_name_to_storage_data) + 1),
						'selection_label' => 'tmp'.'TMA'.(sizeof($tma_name_to_storage_data) + 1)),
					$atim_controls['storage_controls']['TMA-blc 29X29']['detail_tablename'] => array());
				$qc_tf_bank_id = null;
				if($bank) {
					if(array_key_exists($bank, $banks_to_ids)) {
						$qc_tf_bank_id = $banks_to_ids[$bank];
					} else {
						recordErrorAndMessage('TMA Block Creation', '@@ERROR@@', "Bank unknown for a TMA block of a site", "See TMA $tma_name and bank $bank. Bank won't be linked to the created TMA. REF: $excel_file_name, $worksheet_name, $line_number.");
					}
				}
				$tma_name_to_storage_data[$tma_name] = array(
					'id' => customInsertRecord($storage_data), 
					//TMA Bank and TMA site label won't be always known on the first row... so data will be updated at the end of the process...
					'qc_tf_tma_label_site' => $tma_label_site,
					'qc_tf_bank_id' => $qc_tf_bank_id,
					'bank_name' => $bank
				);
				recordErrorAndMessage('Parsed Files and created TMA', '@@MESSAGE@@', "Files Names & TMA Name", " ==> TMA : $tma_name [FROM FILE : $excel_file_name]");
			}
		}
		$storage_master_id = $tma_name_to_storage_data[$tma_name]['id'];
	}
	
	return $storage_master_id;
}

function updateTMABankAndSiteLabel() {
	global $tma_name_to_storage_data;
	foreach($tma_name_to_storage_data as $created_tma) {
		$storage_data = array();
		$storage_data['storage_masters']['qc_tf_tma_label_site'] = $created_tma['qc_tf_tma_label_site'];
		if($created_tma['qc_tf_bank_id']) $storage_data['storage_masters']['qc_tf_bank_id'] = $created_tma['qc_tf_bank_id'];
		updateTableData($created_tma['id'], $storage_data);
	}
}
		
?>
		