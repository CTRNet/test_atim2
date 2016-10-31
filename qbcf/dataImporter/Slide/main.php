<?php

require_once 'system.php';

global $atim_short_label_storage_master_id;
$atim_short_label_storage_master_id = array();
global $atim_storage_master_id_to_storage_data;
$atim_storage_master_id_to_storage_data = array();
global $created_storage_counter;
$created_storage_counter = 0;

//==============================================================================================
// Main Code
//==============================================================================================

$tmp_files_names_list = array();

foreach($excel_files_names as $file_data) {
	list($excel_file_name, $excel_xls_offset) = $file_data;
	$tmp_files_names_list[] = $excel_file_name;
}

displayMigrationTitle('QBCF Slide Data Creation');

if(!testExcelFile($tmp_files_names_list)) {
	dislayErrorAndMessage();
	exit;
}

// *** PARSE EXCEL FILES ***

$bank_to_bank_id = array();
$qbcf_bank_participant_identifier_to_participant_id = array();
$created_sample_counter = 0;
$created_aliquot_counter = 0;
foreach($excel_files_names as $file_data) {
	
	// New Excel File
	
	list($excel_file_name, $excel_xls_offset) = $file_data;
	$excel_file_name_for_ref = ((strlen($excel_file_name) > 24)? substr($excel_file_name, '1', '20')."...xls" : $excel_file_name);
	$test_new_file_for_excel_xls_offset = true;
	
	$worksheet_name = 'Feuil1';
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $excel_xls_offset)) {
		if($line_number > 2)  {
			$qbcf_bank_participant_identifier = $excel_line_data['Patient # in biobank (absolutely needed)'];
			$bank = $excel_line_data['Site'];
			$excel_data_references = "Bank '<b>$bank</b>' & Participant '<b>$qbcf_bank_participant_identifier</b>' & Excel '<b>$excel_file_name_for_ref</b>' & Line '<b>$line_number</b>' & Worksheet '<b>$worksheet_name</b>'";
			
			if(strlen($qbcf_bank_participant_identifier)) {
				
				// 1- CHECK BANK
				//..............................................................................................

				$qbcf_bank_id = null;
				if(isset($bank_to_bank_id[$bank])) {
					$qbcf_bank_id = $bank_to_bank_id[$bank];
				} else {
					$banks_data = getSelectQueryResult("SELECT id, name FROM banks WHERE name like '$bank%'");
					if(!$banks_data) {
						recordErrorAndMessage('Bank', '@@ERROR@@', "Bank unknown into ATiM - No line data will be migrated", "See Bank '$bank' for participant : $excel_data_references");
					} else if(sizeof($banks_data) > 1) {
						$ATiM_banks_names = array();
						foreach($banks_data as $new_bank) {
							$ATiM_banks_names[] = $new_bank['name'];
						}
						recordErrorAndMessage('Bank', '@@ERROR@@', "More than one bank matches the bank name - No line data will be migrated", "See Bank '$bank' for participant : $excel_data_references");
					} else {
						$qbcf_bank_id = $banks_data[0]['id'];
						$bank_to_bank_id[$bank] = $qbcf_bank_id;
					}
				}
				
				if($qbcf_bank_id) {
					
					// 2- SEARCH/CREATE ATiM PARTICIPANT
					//..............................................................................................
					
					if(!isset($qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier])) {
							
						$query = "SELECT * FROM participants WHERE qbcf_bank_id = '$qbcf_bank_id' AND qbcf_bank_participant_identifier = '$qbcf_bank_participant_identifier' AND deleted <> 1";
						$query_data = getSelectQueryResult($query);
							
						if(sizeof($query_data) > 1) {
					
							// 2.a - PARTICIPANT DETECTION ERROR
							//..............................................................................................
							
							// Patient defined twice into ATiM
							
							recordErrorAndMessage('Participant', '@@ERROR@@', "More than one ATiM participant matches the bank patient identifier - No excel data will be migrated - Please fix bug into ATiM", "See following participant : $excel_data_references.");
							$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier] = null;
								
						} else if(!$query_data) {
									
							// 2.b - PARTICIPANT CREATION
							//..............................................................................................
								
							$excel_participant_data = array(
								'qbcf_bank_id' => $qbcf_bank_id,
								'qbcf_bank_participant_identifier' => $qbcf_bank_participant_identifier,
								'last_modification' => $import_date);
							$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier] = customInsertRecord(array('participants' => $excel_participant_data));
							addCreatedDataToSummary('New Participant', "Participant '$qbcf_bank_participant_identifier' of bank '$bank'", $excel_data_references);
								
						} else {
								
							// 2.c - PARTICIPANT FOUND
							//..............................................................................................
								
							$qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier] = $query_data[0]['id'];
						}
						
					} // End search/create participant
					
					if($qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier]) {
						
						// 3- BLOCK CREATION/UPDATE
						
						$excel_pathology_id = $excel_line_data['Pathology ID number'];
						$excel_block_code = $excel_line_data['Block ID'];
							
						if(!strlen($excel_pathology_id) || !strlen($excel_block_code)) {
								
							recordErrorAndMessage('Block', '@@ERROR@@', "The Pathology ID or the Block Code is missing - No data will be migrated", "See data for following participant : $excel_data_references.");
								
						} else {
							
							$block_collection_id = null;
							$block_sample_master_id = null;
							$block_aliquot_master_id = null;
							
							$tissue_sample_detail_tablename = $atim_controls['sample_controls']['tissue']['detail_tablename'];
							$tissue_block_sample_detail_tablename = $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'];
							
							$excel_block_aliquot_label = $excel_pathology_id.' '.$excel_block_code;
							
							$block_storage_master_id = getStorageMasterId($excel_data_references, $excel_line_data['Localisation block'], 'room', null);
							
							$excel_tissue_source = 'breast';
							
							$query = "SELECT Participant.qbcf_bank_id,
								Participant. qbcf_bank_participant_identifier,
								Collection.id as collection_id,
								Collection.treatment_master_id,
								Collection.qbcf_pathology_id,
								SampleMaster.id AS sample_master_id,
								SampleDetail.tissue_source,
								AliquotMaster.id AS aliquot_master_id,
								AliquotMaster.barcode,
								AliquotMaster.aliquot_label,
								AliquotMaster.in_stock,
								AliquotMaster.storage_master_id,
								AliquotMaster.storage_coord_x,
								AliquotMaster.storage_coord_y,
								AliquotDetail.patho_dpt_block_code
								FROM participants Participant
								INNER JOIN collections Collection ON Collection.participant_id = Participant.id
								INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
								INNER JOIN $tissue_sample_detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
								INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND SampleMaster.id = AliquotMaster.sample_master_id
								INNER JOIN $tissue_block_sample_detail_tablename AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
								WHERE Participant.deleted <> 1
								AND Participant.qbcf_bank_id = '$qbcf_bank_id'
								AND Collection.deleted <> 1
								AND Collection.qbcf_pathology_id = '$excel_pathology_id'
								AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
								AND SampleMaster.deleted <> 1
								AND AliquotMaster.deleted <> 1
								AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
								AND AliquotDetail.patho_dpt_block_code = '$excel_block_code';";
							$query_data = getSelectQueryResult($query);
							
							if($query_data) {
									
								// 3.a- BLOCK UPDATE (if required)
									
								// Bank Block already created (based on the bank & the Pathology ID number & the Block Code) : Check data and update block if required
							
								if(sizeof($query_data) > 1) {
									// Two bank blocks matched the excel file block based on 'Pathology ID number' & 'Block Code' & the bank
									recordErrorAndMessage('Block', '@@ERROR@@', "More than one ATiM tissue block matches the excel tissue block (based on Pathology ID number' & 'Block Code' & the bank name) - System will only compare excel data to the first ATiM record and update data of this one if required.", "See block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								}
								$atim_block_data = $query_data[0];
									
								if($atim_block_data['qbcf_bank_participant_identifier'] != $qbcf_bank_participant_identifier) {
									// ATiM block not linked to the same participant idenitifier than this one listed into excel
									recordErrorAndMessage('Block', '@@ERROR@@', "Bank block already exists into ATiM (based on 'Pathology ID number' & 'Block Code' & the bank name) but the participant does not match the excel participant based on the Patient # in biobank - ATiM block and slide won't be created and/or updated", "See block '$excel_block_aliquot_label' linked to ATiM bank participant '".$atim_block_data['qbcf_bank_participant_identifier']."'for following participant : $excel_data_references.");
								
								} else {
									
									$block_collection_id = $atim_block_data['collection_id'];
									$block_sample_master_id = $atim_block_data['sample_master_id'];
									$block_aliquot_master_id = $atim_block_data['aliquot_master_id'];
									
									$atim_field_to_excel = array(
										"Sample.$tissue_sample_detail_tablename.tissue_source"
											=> array("Tissue source of the block (not an excel value)", $excel_tissue_source),
										"Aliquot.aliquot_masters.in_stock"
											=> array("Block in stock value (should be yes -not an excel value)", 'yes - available'),
										"Aliquot.aliquot_masters.aliquot_label"
											=> array('Pathology ID number' & 'Block ID', $excel_block_aliquot_label),
										"Aliquot.aliquot_masters.storage_master_id"
											=> array("Block storage (storage_master_id)", $block_storage_master_id),
										"Aliquot.aliquot_masters.storage_coord_x"
											=> array("Block storage position x (storage_coord_x)", ''),
										"Aliquot.aliquot_masters.storage_coord_y"
											=> array("Block storage position y (storage_coord_y)", ''));
									
									$block_data_mismatches_array = array();
									$block_data_to_update_boolean = false;
									$block_data_to_update_array = array(
										'Collection' => array('collections' => array()),
										'Sample' => array('sample_masters' => array(), 'specimen_details' => array(), $tissue_sample_detail_tablename => array()),
										'Aliquot' => array('aliquot_masters' => array(), $tissue_block_sample_detail_tablename => array()));
							
									foreach($atim_field_to_excel as $atim_table_and_field => $excel_field_value) {
										$atim_table_and_field = explode('.', $atim_table_and_field);
										list($atim_data_type, $atim_table_name, $atim_field) = $atim_table_and_field;
										list($excel_field, $excel_value) = $excel_field_value;
										if(!strlen($atim_block_data[$atim_field]) && strlen($excel_value)) {
											$block_data_to_update_array[$atim_data_type][$atim_table_name][$atim_field] = $excel_value;
											$block_data_to_update_boolean = true;
										} else if($excel_value != $atim_block_data[$atim_field]) {
											$block_data_mismatches_array[] = "$excel_field ([ATiM] '".$atim_block_data[$atim_field]."' != [Excel] '$excel_value')";
										}
									}
									if($block_data_mismatches_array) {
										recordErrorAndMessage('Block', '@@WARNING@@', "Bank block already exists into ATiM (based on 'Pathology ID number' & 'Block Code' & the bank name) but differences exist between excel and ATiM data - No ATiM value (excepted empty value) will be updated. Please confirm and update block if required.", "See block '$excel_block_aliquot_label' and data [".implode(' & ', $block_data_mismatches_array)."] for following participant : $excel_data_references.");
									}
									if($block_data_to_update_boolean) {
										//Collection Update
										if($block_data_to_update_array['Collection']['collections']) {
											updateTableData($atim_block_data['collection_id'], $block_data_to_update_array['Collection']);
											addUpdatedDataToSummary('Block Collection Update', $block_data_to_update_array['Collection']['collections'], $excel_data_references);
										}
										//Block Tissue Update
										if($block_data_to_update_array['Sample']['sample_masters'] || $block_data_to_update_array['Sample']['specimen_details'] || $block_data_to_update_array['Sample'][$tissue_sample_detail_tablename]) {
											updateTableData($atim_block_data['sample_master_id'], $block_data_to_update_array['Sample']);
											addUpdatedDataToSummary('Block Tissue Update', array_merge($block_data_to_update_array['Sample']['sample_masters'], $block_data_to_update_array['Sample']['specimen_details'], $block_data_to_update_array['Sample'][$tissue_sample_detail_tablename]), $excel_data_references);
										}
										//Block Update
										if($block_data_to_update_array['Aliquot']['aliquot_masters'] || $block_data_to_update_array['Aliquot'][$tissue_block_sample_detail_tablename]) {
											updateTableData($atim_block_data['aliquot_master_id'], $block_data_to_update_array['Aliquot']);
											addUpdatedDataToSummary('Block Update', array_merge($block_data_to_update_array['Aliquot']['aliquot_masters'], $block_data_to_update_array['Aliquot'][$tissue_block_sample_detail_tablename]), $excel_data_references);
										}
									}
								}
									
							} else {
									
								// 3.b- BLOCK CREATION
									
								// Check block code does not exist into ATiM for an other bank
									
								$query = "SELECT AliquotMaster.barcode
									FROM collections Collection
									INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
									INNER JOIN $tissue_sample_detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
									INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND SampleMaster.id = AliquotMaster.sample_master_id
									INNER JOIN $tissue_block_sample_detail_tablename AliquotDetail ON AliquotMaster.id = AliquotDetail.aliquot_master_id
									WHERE Collection.deleted <> 1
									AND Collection.qbcf_pathology_id = '$excel_pathology_id'
									AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
									AND SampleMaster.deleted <> 1
									AND AliquotMaster.deleted <> 1
									AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
									AND AliquotDetail.patho_dpt_block_code = '$excel_block_code';";
									
								$query_data = getSelectQueryResult($query);
								if($query_data) {
									recordErrorAndMessage('Block', '@@WARNING@@', "Block already exists into ATiM (based on 'Pathology ID number' & 'Block Code') but the bank is different - New block will be created but please validate.", "See block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								}
									
								// Create new collection or use an old one
									
								$query = "SELECT DISTINCT Collection.id AS collection_id,
									Collection.treatment_master_id
									FROM participants Participant
									INNER JOIN collections Collection ON Collection.participant_id = Participant.id
									WHERE Participant.deleted <> 1
									AND Participant.qbcf_bank_id = '$qbcf_bank_id'
									AND Participant. qbcf_bank_participant_identifier = '$qbcf_bank_participant_identifier'
									AND Collection.deleted <> 1
									AND Collection.qbcf_pathology_id = '$excel_pathology_id'";
								$query_data = getSelectQueryResult($query);
									
								$block_collection_id = null;
								if($query_data) {
									//Collection already created
							
									if(sizeof($query_data) > 1) {
										// Two collections matched the excel file block based on 'Pathology ID number' & 'Block Code' & the bank
										recordErrorAndMessage('Block', '@@ERROR@@', "More than one ATiM collection matches the excel tissue block defintion (based on Pathology ID number' & Patient # in biobank & the bank name) - System will use the first ATiM record.", "See block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
									}
									$block_collection_id = $query_data[0]['collection_id'];
								}
							
								if(!$block_collection_id) {
									$collection_data = array(
										'collection_property' => 'participant collection',
										'participant_id' => $qbcf_bank_participant_identifier_to_participant_id[$qbcf_bank_participant_identifier],
										'qbcf_pathology_id' => $excel_pathology_id);
									$block_collection_id = customInsertRecord(array('collections' => $collection_data));
									addCreatedDataToSummary('New Collection', "New collection for participant '$qbcf_bank_participant_identifier' of bank '$bank' and block '$excel_block_aliquot_label'", $excel_data_references);
								}
									
								// Create one tissue sample per block
									
								$created_sample_counter++;
								$sample_data = array(
									'sample_masters' => array(
										"sample_code" => 'tmp_tissue_'.$created_sample_counter,
										"sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
										"initial_specimen_sample_type" => 'tissue',
										"collection_id" => $block_collection_id),
									'specimen_details' => array(),
									$tissue_sample_detail_tablename => array(
										'tissue_source' => $excel_tissue_source));
								$block_sample_master_id = customInsertRecord($sample_data);
									
								// Create block
									
								$created_aliquot_counter++;
								$aliquot_data = array(
									'aliquot_masters' => array(
										"barcode" => 'tmp_core_'.$created_aliquot_counter,
										'aliquot_label' => $excel_block_aliquot_label,
										"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
										"collection_id" => $block_collection_id,
										"sample_master_id" => $block_sample_master_id,
										'storage_master_id' => $block_storage_master_id,
										'in_stock' => 'yes - available',
										'in_stock_detail' => ''),
									$tissue_block_sample_detail_tablename => array(
										'patho_dpt_block_code' => $excel_block_code));
								$block_aliquot_master_id = customInsertRecord($aliquot_data);
								addCreatedDataToSummary('New Block', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : Aliquot '$excel_block_aliquot_label'", $excel_data_references);
							}
							
							if($block_aliquot_master_id) {
								
								// 4- SLIDE CREATION
								
								$query = "SELECT id 
									FROM aliquot_masters 
									WHERE deleted <> 1 
									AND aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-slide']['id']."
									AND sample_master_id = $block_sample_master_id ;";
								$query_data = getSelectQueryResult($query);
								if($query_data) recordErrorAndMessage('Block Slide', '@@WARNING@@', "Tissue slide already exists into ATiM for the tissue of the block (based on Pathology ID number' & Patient # in biobank & the bank name) - New slide will be created but please validate.", "See tissue of block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
									
								$qbcf_staining = 'H&E';
								
								$qbcf_thickness_um = validateAndGetDecimal($excel_line_data['Slide thickness'], 'Block Slide', '', "See slide of block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
								
								$slide_storage_master_id = getStorageMasterId($excel_data_references, 
									$excel_line_data['Localisation slide - box ID'], 
									'box100', 
									getStorageMasterId($excel_data_references, $excel_line_data['Localisation slide -room'], 'room', null));
								
								$slide_storage_coord_x = $excel_line_data['Localisation slide in box'];
								if(!preg_match('/^(([1-9])|([1-9][0-9])|(100))$/', $slide_storage_coord_x)) {
									recordErrorAndMessage('Block Slide', '@@ERROR@@', "Slide position error (not an integer lower or equalt to 100) - No position recorded.", "See slide of block '$excel_block_aliquot_label' for following participant : $excel_data_references.");
									$slide_storage_coord_x = '';
								}
								if(!$slide_storage_master_id) $slide_storage_coord_x = '';
								
								$excel_field = 'Date of coloration';
								list($qbcf_staining_date, $qbcf_staining_date_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'Block Slide', $excel_field, "See $excel_data_references");
								
								$created_aliquot_counter++;
								$aliquot_data = array(
									'aliquot_masters' => array(
										"barcode" => 'tmp_core_'.$created_aliquot_counter,
										'aliquot_label' => $excel_block_aliquot_label,
										"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-slide']['id'],
										"collection_id" => $block_collection_id,
										"sample_master_id" => $block_sample_master_id,
										'storage_master_id' => $slide_storage_master_id,
										'storage_coord_x' => $slide_storage_coord_x,
										'in_stock' => 'yes - available',
										'in_stock_detail' => ''),
									$atim_controls['aliquot_controls']['tissue-slide']['detail_tablename'] => array(
										'qbcf_staining' => $qbcf_staining,
										'qbcf_staining_date' => $qbcf_staining_date,
										'qbcf_staining_date_accuracy' => $qbcf_staining_date_accuracy,
										'qbcf_thickness_um' => $qbcf_thickness_um,));
								$slide_aliquot_master_id = customInsertRecord($aliquot_data);
								addCreatedDataToSummary('Block Slide', "Participant '$qbcf_bank_participant_identifier' of bank '$bank' : Aliquot '$excel_block_aliquot_label'", $excel_data_references);
								
								$excel_field = 'Date of sectionning';
								list($realiquoting_datetime, $realiquoting_datetime_accuracy) = validateAndGetDateAndAccuracy($excel_line_data[$excel_field], 'Block Slide', $excel_field, "See $excel_data_references");
								
								$realiquoting_data = array('realiquotings' => array(
									'parent_aliquot_master_id' => $block_aliquot_master_id,
									'child_aliquot_master_id' => $slide_aliquot_master_id,
									'realiquoting_datetime' => $realiquoting_datetime,
									'realiquoting_datetime_accuracy' => $realiquoting_datetime_accuracy));
								customInsertRecord($realiquoting_data);
							}
						}
					} //Participant found
				} // Bank found in section above
			} else if(strlen($excel_line_data['Pathology ID number'])) {
				//No $qbcf_bank_participant_identifier but block defined
				recordErrorAndMessage('Participant', '@@ERROR@@', "No participant defined for a block pathology ID - No block data will be migrated", "See block '".$excel_line_data['Pathology ID number']." ".$excel_line_data['Block ID']."' for participant : $excel_data_references");
			}
		}
	}  //End new line
}
	
$last_queries_to_execute = array(
	"UPDATE participants SET participant_identifier = id WHERE participant_identifier = '' OR participant_identifier IS NULL;",
	"UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE sample_control_id=". $atim_controls['sample_controls']['tissue']['id']." AND sample_code LIKE 'tmp_tissue_%';",
	"UPDATE aliquot_masters SET barcode=id WHERE aliquot_control_id=".$atim_controls['aliquot_controls']['tissue-block']['id']." AND barcode LIKE 'tmp_core_%';",
	"UPDATE aliquot_masters SET barcode=id WHERE aliquot_control_id=".$atim_controls['aliquot_controls']['tissue-slide']['id']." AND barcode LIKE 'tmp_core_%';",
	"UPDATE storage_masters SET code=id WHERE  code LIKE 'tmp%';",
	"UPDATE versions SET permissions_regenerated = 0;"
);
foreach($last_queries_to_execute as $query)	customQuery($query);

//*** SUMMARY DISPLAY ***

global $import_summary;

$creation_update_summary = array();
foreach(array('Data Update Summary', 'Data Creation Summary') as $new_section) {
	if(isset($import_summary[$new_section])) {
		$creation_update_summary[$new_section] = $import_summary[$new_section];
		unset($import_summary[$new_section]);
	}
}

dislayErrorAndMessage(false, 'Migration Errors/Warnings/Messages');

$import_summary = $creation_update_summary;

dislayErrorAndMessage(true, 'Creation/Update Summary');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function getDataToUpdate($atim_data, $excel_data) {
	$data_to_update = array();
	foreach($excel_data as $key => $value) {
		if(!array_key_exists($key, $atim_data)) die('ERR_8837282882:'.$key);
		if(strlen($value) && $value != $atim_data[$key]) $data_to_update[$key] = $value;
	}
	return $data_to_update;
}

function addCreatedDataToSummary($creation_type, $detail, $excel_data_references) {
	recordErrorAndMessage('Data Creation Summary', '@@MESSAGE@@', $creation_type, "$detail. See $excel_data_references.");
}

function addUpdatedDataToSummary($update_type, $updated_data, $excel_data_references) {
	if($updated_data) {
		$updates = array();
		foreach($updated_data as $field => $value) $updates[] = "[$field = $value]";
		recordErrorAndMessage('Data Update Summary', '@@MESSAGE@@', $update_type, "Updated field(s) : ".implode(' + ', $updates).". See $excel_data_references.");
	}
}

function getDrugKey($drug_name, $type) {
	if(!in_array($type, array('bone specific', 'chemotherapy', 'immunotherapy', 'hormonal'))) die('ERR 237 7263726 drug type'.$type);
	return strtolower($drug_name.'## ##'.$type);
}

function getStorageMasterId($excel_data_references, $short_label, $storage_type, $parent_storage_master_id = null) {
	global $atim_controls;
	global $atim_storage_key_storage_master_id;
	global $atim_storage_master_id_to_storage_data;
	global $created_storage_counter;
	
	if(!isset($atim_controls['storage_controls'][$storage_type])) die('ERR_storage_control_type#80064884 :: '.$storage_type);
	$storage_controls = $atim_controls['storage_controls'][$storage_type];
	
	if(empty($short_label)) {
		return null;
	} else {
		$storage_key = $storage_type.'-'.($parent_storage_master_id? $parent_storage_master_id : 'null').'-'.$short_label;
		if(isset($atim_storage_key_storage_master_id[$storage_key])) {
			return $atim_storage_key_storage_master_id[$storage_key];
		} else {
			$query = "SELECT id AS storage_master_id
				FROM storage_masters
				WHERE deleted <> 1
				AND storage_control_id = ".$storage_controls['id']."
				AND short_label = '$short_label' 
				AND (".($parent_storage_master_id? 'parent_id = '.$parent_storage_master_id : 'TRUE').");";
			$query_data = getSelectQueryResult($query);
			if($query_data) {
				if($query_data > 1) {
					recordErrorAndMessage('Storage', '@@ERROR@@', "More than one storage matches the excel storage based on short label and storage type - System will only use the first one. Please update data if required.", "See $storage_type short label '$short_label' [$excel_data_references].");
				}
				return $query_data[0]['storage_master_id'];				
			} else {
				//Get parent storage
				if($parent_storage_master_id && !isset($atim_storage_master_id_to_storage_data[$parent_storage_master_id])) {
					$query = "SELECT short_label, selection_label FROM storage_masters WHERE id = $parent_storage_master_id AND deleted <> 1";
					$query_data = getSelectQueryResult($query);
					if(!$query_data) die('ERR_storage_master_id#74784884');
					$atim_storage_master_id_to_storage_data[$parent_storage_master_id] = array(
						'short_label' => $query_data[0]['short_label'],
						'selection_label' => $query_data[0]['selection_label']);
				}
				$selection_label = ($parent_storage_master_id? $atim_storage_master_id_to_storage_data[$parent_storage_master_id]['selection_label'].'-' : '').$short_label;
				if(sizeof($short_label) > 50) recordErrorAndMessage('Storage', '@@WARNING@@', "Storage short label too long (>50) - Will generate many storage creation.", "See $storage_type short label '$short_label' [$excel_data_references].");
				if(sizeof($selection_label) > 110) recordErrorAndMessage('Storage', '@@WARNING@@', "Storage selection label too long (>50) - Will generate many storage creation.", "See $storage_type selection label '$selection_label' [$excel_data_references].");
				$created_storage_counter++;
				$storage_data = array(
					'storage_masters' => array(
						"code" => 'tmp'.$created_storage_counter,
						"short_label" => $short_label,
						"selection_label" => $selection_label,
						"storage_control_id" => $storage_controls['id'],
						"parent_id" => $parent_storage_master_id),
					$storage_controls['detail_tablename'] => array());
				$storage_master_id = customInsertRecord($storage_data);
				addCreatedDataToSummary('Storage', "New Storage $storage_type '$short_label'.", $short_label);
				$atim_storage_key_storage_master_id[$storage_key] = $storage_master_id;
				return $storage_master_id;
			}
		}
	}
}
	
?>
		