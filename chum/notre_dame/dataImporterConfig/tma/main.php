<?php

//First Line of any main.php file
require_once 'system.php';

//==============================================================================================
// Custom Require Section
//==============================================================================================

//TODO
pr("TODO: Check all values like '.', 'empty' and 'Empty' have been removed!");
pr("TODO: Check value 'BadCore' has been replaced by 'Bad Core'!");

//==============================================================================================
// Custom Variables
//==============================================================================================

//==============================================================================================
// Main Code
//==============================================================================================

displayMigrationTitle('ICM TMA Block Creation');

//---------------------------------------------------------------------------------------------
// INITIATE
//---------------------------------------------------------------------------------------------

global $banks_to_ids;
$banks_to_id = array();
foreach(getSelectQueryResult("SELECT id, name, misc_identifier_control_id FROM banks;") as $new_bank) $banks_to_ids[$new_bank['name']] = array('bank_id' => $new_bank['id'], 'misc_identifier_control_id' => $new_bank['misc_identifier_control_id']);

$lab_type_laterality_matches = array();
$query = "SELECT selected_type_code, selected_labo_laterality, sample_type_matching, tissue_source_matching, nature_matching, laterality_matching FROM lab_type_laterality_match;";
foreach(getSelectQueryResult($query) as $new_match) $lab_type_laterality_matches[strtolower($new_match['sample_type_matching'])][strtolower($new_match['selected_type_code'])][strtolower($new_match['selected_labo_laterality'])] = $new_match;

global $tma_short_label_to_storage_master_id;
$tma_short_label_to_storage_master_id = array();

//---------------------------------------------------------------------------------------------
// get 'TMA Controls' collection with existing marker
//---------------------------------------------------------------------------------------------

$controls_collections = array('collection_id' => array(), 'block_aliquot_master_ids' => array());
$query = "SELECT Collection.id as collection_id, 
		AliquotMaster.sample_master_id AS sample_master_id, 
		AliquotMaster.id AS aliquot_master_id, 
		AliquotDetail.patho_dpt_block_code
	FROM collections Collection
	LEFT JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id AND AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
	LEFT JOIN ".$atim_controls['aliquot_controls']['tissue-block']['detail_tablename']." AS AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
	WHERE Collection.collection_property = 'independent collection' AND Collection.deleted <> 1 AND Collection.acquisition_label = 'TMA Controls'
	ORDER BY Collection.id";
foreach(getSelectQueryResult($query) as $new_tma_block_control) {
	if(!in_array($new_tma_block_control['collection_id'], $controls_collections['collection_id'])) $controls_collections['collection_id'][] = $new_tma_block_control['collection_id'];
	if($new_tma_block_control['patho_dpt_block_code']) $controls_collections['block_aliquot_master_ids'][$new_tma_block_control['patho_dpt_block_code']][] = array('sample_master_id' => $new_tma_block_control['sample_master_id'], 'aliquot_master_id' => $new_tma_block_control['aliquot_master_id']);
}
if(empty($controls_collections['collection_id'])) migrationDie("Please create 'independant collection' labelled 'TMA Controls' to gather TMA controls core");
if(sizeof($controls_collections['collection_id']) > 1) migrationDie("More than one ''independant collection' labelled 'TMA Controls' into ATiM");
$controls_collections['collection_id'] = array_shift($controls_collections['collection_id']);

//---------------------------------------------------------------------------------------------
// Create Cores
//---------------------------------------------------------------------------------------------

$sample_counter = 0;
$aliquot_counter = 0;
$creation_messages_for_summary = array();
foreach($excel_files as $excel_data) {
	list($excel_file_name, $worksheet_name) = $excel_data;
	recordErrorAndMessage('TMA creation & positions check', '@@MESSAGE@@', "Files Names & TMA name", "FILE : $excel_file_name");
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {		
		if(strlen($excel_line_data['NoLabo'])) {
			//**************************************
			// *** 1 *** TMA Patient Tissue Core ***
			//**************************************
			// 1.0 --> check required fields
			$fields_validated = true;
			$required_fields = array(
				'TMA name',
				//NoLabo not empty for sure
				'Bank',
				//Type Code : optional
				//Laterality : optional
				'PathoID',
				//Dx PathRev : optional
				'BlocID',
				'Position X',
				'Position Y');
			foreach($required_fields as $tested_field) {
				if(!strlen($excel_line_data[$tested_field])) {
					$fields_validated = false;
					recordErrorAndMessage('Patient Core: Requested Data Validation', '@@ERROR@@', "Data of field '".$tested_field."' is requested", "The core won't be created . REF: $excel_file_name / $worksheet_name, line $line_number.");
				}
			}
			if($fields_validated) {
				// 1.a --> Look for the participant_id		
				$participant_id = null;
				if(!array_key_exists($excel_line_data['Bank'], $banks_to_ids)) {
					recordErrorAndMessage('Patient Core: ATiM Patient Detection', '@@ERROR@@', "Bank unknown", "The bank ".$excel_line_data['Bank']." is unknown. Patient can not be found. The core won't be created.  REF: $excel_file_name / $worksheet_name, line $line_number.");
				} else {
					$query = "SELECT participant_id FROM misc_identifiers
						WHERE misc_identifier_control_id = ".$banks_to_ids[$excel_line_data['Bank']]['misc_identifier_control_id']."
						AND deleted <> 1 AND identifier_value = '".$excel_line_data['NoLabo']."'";
					$identifier_data = getSelectQueryResult($query);
					if(sizeof($identifier_data) > 1) migrationDie("More than one patient for the same NoLabo (bank : ".$excel_line_data['Bank']." and NoLabo : ".$excel_line_data['NoLabo']." exist into ATiM");
					if($identifier_data) {
						$identifier_data = array_shift($identifier_data);
						$participant_id = $identifier_data['participant_id'];
					} else {
						recordErrorAndMessage('Patient Core: ATiM Patient Detection', '@@ERROR@@', "Patient unknown", "The patient ".$excel_line_data['NoLabo']." of the bank ".$excel_line_data['Bank']." is unknown. Patient can not be found. The core won't be created.  REF: $excel_file_name / $worksheet_name, line $line_number.");
					}
				}
				// 1.b --> Find or create paraffin block
				$block_ids = array(
					'collection_id'=>null, 
					'collection_participant_identifier' => null,
					'sample_master_id'=>null, 
					'qc_nd_sample_label'=>null, 
					'aliquot_master_id'=>null);
				if($participant_id) {
					//Check paraffin block already exists
					$query = "SELECT
						MiscIdentifier.identifier_value AS collection_participant_identifier,
						Collection.id AS collection_id,
						Collection.participant_id,
						SampleMaster.id AS sample_master_id,
						SampleMaster.qc_nd_sample_label,
						SpecimenDetail.type_code,
						SampleDetail.labo_laterality,
						AliquotMaster.id AS aliquot_master_id,
						AliquotDetail.block_type,
						AliquotDetail.patho_dpt_block_code,
						AliquotDetail.sample_position_code
						FROM aliquot_masters AliquotMaster
						INNER JOIN ".$atim_controls['aliquot_controls']['tissue-block']['detail_tablename']." AS AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
						INNER JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted <> 1
						INNER JOIN ".$atim_controls['sample_controls']['tissue']['detail_tablename']." SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
						INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
						INNER JOIN collections Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted <> 1
						LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
						LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Collection.participant_id AND MiscIdentifier.deleted <> 1								
						WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
						AND AliquotDetail.patho_dpt_block_code = '".$excel_line_data['PathoID']."' AND AliquotDetail.sample_position_code = '".$excel_line_data['BlocID']."'";
					$existing_paraffin_block_matching_patho_and_bloc_ids = getSelectQueryResult($query);
					if($existing_paraffin_block_matching_patho_and_bloc_ids) {
						//Paraffin block already exists: Check block is unique and check data linked to block are similar
						if(sizeof($existing_paraffin_block_matching_patho_and_bloc_ids) == 1) {
							$block_detection_error = false;							
							//Only one block: Will compare information
							$existing_paraffin_block_matching_patho_and_bloc_ids = array_shift($existing_paraffin_block_matching_patho_and_bloc_ids);
							if($existing_paraffin_block_matching_patho_and_bloc_ids['participant_id'] != $participant_id) {
								recordErrorAndMessage('Patient Core: Paraffin Block Detection/Creation', '@@ERROR@@', "Participant ID Conflict", "A block labelled as PathoID = '".$excel_line_data['PathoID']."' & BlocID = '".$excel_line_data['BlocID']."' already exists into ATiM but this one is linked to a patient different than ".$excel_line_data['NoLabo']." (participant_id = ".$existing_paraffin_block_matching_patho_and_bloc_ids['participant_id']."). No core will be created. REF: $excel_file_name / $worksheet_name, line $line_number.");
								$block_detection_error = true;
							}
							if($existing_paraffin_block_matching_patho_and_bloc_ids['block_type'] != 'paraffin') {
								recordErrorAndMessage('Patient Core: Paraffin Block Detection/Creation', '@@ERROR@@', "Wrong detected block type", "A block labelled as PathoID = '".$excel_line_data['PathoID']."' & BlocID = '".$excel_line_data['BlocID']."' already exists into ATiM but this one is not a paraffin block. Please check data. No core will be created. REF: $excel_file_name / $worksheet_name, line $line_number.");
								$block_detection_error = true;
							}
							if(strtolower($existing_paraffin_block_matching_patho_and_bloc_ids['type_code']) != strtolower($excel_line_data['Type Code'])) {
								recordErrorAndMessage('Patient Core: Paraffin Block Detection/Creation', '@@WARNING@@', "Type Code Conflict", "A block labelled as PathoID = '".$excel_line_data['PathoID']."' & BlocID = '".$excel_line_data['BlocID']."' already exists into ATiM but the 'type code' values are different ((atim) ".$existing_paraffin_block_matching_patho_and_bloc_ids['type_code'] ." != (excel) ".$excel_line_data['Type Code']."). Core will be created but data has to be valiated after migration. REF: $excel_file_name / $worksheet_name, line $line_number.");
							}
							if(strtolower($existing_paraffin_block_matching_patho_and_bloc_ids['labo_laterality']) != strtolower($excel_line_data['Laterality'])) {
								recordErrorAndMessage('Patient Core: Paraffin Block Detection/Creation', '@@WARNING@@', "Laterality Conflict", "A block labelled as PathoID = '".$excel_line_data['PathoID']."' & BlocID = '".$excel_line_data['BlocID']."' already exists into ATiM but the 'laterality' values are different ((atim)".$existing_paraffin_block_matching_patho_and_bloc_ids['labo_laterality'] ." != (excel)".$excel_line_data['Laterality']."). Core will be created but data has to be valiated after migration. REF: $excel_file_name / $worksheet_name, line $line_number.");
							}
							if(!$block_detection_error) {
								//Block found
								$block_ids = array(
									'collection_id' => $existing_paraffin_block_matching_patho_and_bloc_ids['collection_id'],
									'collection_participant_identifier' => $existing_paraffin_block_matching_patho_and_bloc_ids['collection_participant_identifier'],
									'sample_master_id' => $existing_paraffin_block_matching_patho_and_bloc_ids['sample_master_id'],
									'qc_nd_sample_label'=> $existing_paraffin_block_matching_patho_and_bloc_ids['qc_nd_sample_label'], 
									'aliquot_master_id' => $existing_paraffin_block_matching_patho_and_bloc_ids['aliquot_master_id']);
							}
						} else {
							//More than one paraffin block
							recordErrorAndMessage('Patient Core: Paraffin Block Detection/Creation', '@@ERROR@@', "More than one paraffin block", "More than one paraffin block labelled as PathoID = '".$excel_line_data['PathoID']."' & BlocID = '".$excel_line_data['BlocID']."' already exist into ATiM. The system won't be able to define the good one to use. No core will be created. REF: $excel_file_name / $worksheet_name, line $line_number.");
						}
					} else {
						//Tissue plus Paraffin block have to be created: Check collection already exists
						$block_detection_error = false;
						$query = "SELECT DISTINCT
							MiscIdentifier.identifier_value AS collection_participant_identifier,
							Collection.id AS collection_id,
							Collection.participant_id
							FROM aliquot_masters AliquotMaster
							INNER JOIN ".$atim_controls['aliquot_controls']['tissue-block']['detail_tablename']." AS AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
							INNER JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted <> 1
							INNER JOIN ".$atim_controls['sample_controls']['tissue']['detail_tablename']." SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
							INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
							INNER JOIN collections Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted <> 1
							LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
							LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Collection.participant_id AND MiscIdentifier.deleted <> 1								
							WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
							AND AliquotDetail.patho_dpt_block_code = '".$excel_line_data['PathoID']."'";
						$existing_collection_matching_patho_id = getSelectQueryResult($query);
						if($existing_collection_matching_patho_id) {
							//Collection already exists: Check Collection is unique and participant_id
							if(sizeof($existing_collection_matching_patho_id) == 1) {
								$existing_collection_matching_patho_id = array_shift($existing_collection_matching_patho_id);
								if($existing_collection_matching_patho_id['participant_id'] == $participant_id) {
									//Only Sample and block will have to be created
									$block_ids['collection_id'] = $existing_collection_matching_patho_id['collection_id'];
									$block_ids['collection_participant_identifier'] = $existing_collection_matching_patho_id['collection_participant_identifier'];
								} else {
									recordErrorAndMessage('Patient Core: Paraffin Block Detection/Creation', '@@ERROR@@', "PathoID '".$excel_line_data['PathoID']."' already assigns to a block of another participant", "A patient is already linked to a block labelled as PathoID = '".$excel_line_data['PathoID']."' but the patient of the collection is different than patient ".$excel_line_data['NoLabo'].". No core will be created. REF: $excel_file_name / $worksheet_name, line $line_number.");
									$block_detection_error = true;
								}
							} else {
								recordErrorAndMessage('Patient Core: Paraffin Block Detection/Creation', '@@WARNING@@', "PathoID '".$excel_line_data['PathoID']."' already assigns to many blocks contained in more than one collection", "The system won't be able to create block into the good one so a third collection will be created. Please check data after migration. REF: $excel_file_name / $worksheet_name, line $line_number.");
							}
						}
						if(!$block_detection_error) {
							//Create block
							if(!$block_ids['collection_id']) {
								$collection_data = array(
									'collections' => array(
										'participant_id' => $participant_id,
										'acquisition_label' => 'Collection Created From TMA Layout',
										'bank_id' => $banks_to_ids[$excel_line_data['Bank']]['bank_id'],
										'collection_property' => 'participant collection'));
								$block_ids['collection_id'] = customInsertRecord($collection_data);
								$block_ids['collection_participant_identifier'] = $excel_line_data['NoLabo'];
								$creation_messages_for_summary["Patient Core Creation Summary"]["New collection creation"][] = "The system created a new collection linked to bank '".$excel_line_data['Bank']."' and NoLabo '".$excel_line_data['NoLabo']."'. REF: $excel_file_name / $worksheet_name, line $line_number.";
							}
							// Sample
							$sample_counter++;
							$detail_tablename = $atim_controls['sample_controls']['tissue']['detail_tablename'];
							$sample_data = array(
								'sample_masters' => array(
									"sample_code" => 'tmp_tissue_'.$sample_counter,
									"sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
									"initial_specimen_sample_type" => 'tissue',
									"collection_id" => $block_ids['collection_id']),
								'specimen_details' => array('type_code' => ''),
								$atim_controls['sample_controls']['tissue']['detail_tablename'] => array('labo_laterality' => ''));
							if(isset($lab_type_laterality_matches['tissue'][strtolower($excel_line_data['Type Code'])][strtolower($excel_line_data['Laterality'])])) {
								$match_data = $lab_type_laterality_matches['tissue'][strtolower($excel_line_data['Type Code'])][strtolower($excel_line_data['Laterality'])];
								$sample_data['specimen_details']['type_code'] = $match_data['selected_type_code'];
								$sample_data[$detail_tablename]['labo_laterality'] = $match_data['selected_labo_laterality'];
								$sample_data[$detail_tablename]['tissue_source'] = $match_data['tissue_source_matching'];
								$sample_data[$detail_tablename]['tissue_nature'] = $match_data['nature_matching'];
								$sample_data[$detail_tablename]['tissue_laterality'] = $match_data['laterality_matching'];
							} else {
								recordErrorAndMessage('Patient Core: Paraffin Block Detection/Creation', '@@WARNING@@', "Type Code & Laterality unknown", "The sample 'Type Code' ".$excel_line_data['Type Code']." and the laterality '".$excel_line_data['Laterality']."' is not supported by the system. Core will be created but this information won't be be migrated and has to be set manually after migration.  REF: $excel_file_name / $worksheet_name, line $line_number.");
							}
							$sample_data['sample_masters']['qc_nd_sample_label'] = createSampleLabel($block_ids['collection_participant_identifier'], $sample_data['specimen_details']['type_code'], $sample_data[$detail_tablename]['labo_laterality']) ;
							$block_ids['sample_master_id'] = customInsertRecord($sample_data);
							$block_ids['qc_nd_sample_label'] = $sample_data['sample_masters']['qc_nd_sample_label'];
							$creation_messages_for_summary["Patient Core Creation Summary"]["New sample creation"][] = "The system created a new tissue sample '".$sample_data['sample_masters']['qc_nd_sample_label']."' linked to bank '".$excel_line_data['Bank']."' and NoLabo '".$excel_line_data['NoLabo']."'. REF: $excel_file_name / $worksheet_name, line $line_number.";
							//Aliquot: Block
							$aliquot_counter++;
							$aliquot_data = array(
								'aliquot_masters' => array(
									"barcode" => 'tmp_core_'.$aliquot_counter,
									"aliquot_label" => $excel_line_data['PathoID'].'-'.$excel_line_data['BlocID'],
									"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
									"collection_id" => $block_ids['collection_id'],
									"sample_master_id" => $block_ids['sample_master_id'],
									'in_stock' => 'yes - available',
									'use_counter' => '1',
									'notes' => 'Created by system for TMA creation'),
								$atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
									'block_type' => 'paraffin',
									'patho_dpt_block_code' => $excel_line_data['PathoID'],
									'sample_position_code' => $excel_line_data['BlocID']));
							$block_ids['aliquot_master_id'] = customInsertRecord($aliquot_data);
							$creation_messages_for_summary["Patient Core Creation Summary"]["New block creation"][] = "The system created a new tissue block '".$excel_line_data['PathoID'].'-'.$excel_line_data['BlocID']."' linked to bank '".$excel_line_data['Bank']."' and NoLabo '".$excel_line_data['NoLabo']."'. REF: $excel_file_name / $worksheet_name, line $line_number.";
						}
					}	
				}
				// 1.c --> Create core
				if($block_ids['aliquot_master_id']) {
					list($storage_master_id, $storage_coord_x, $storage_coord_y) = getStorageMasterIdAndValidatePositions($excel_line_data['TMA name'], $excel_line_data['Position X'], $excel_line_data['Position Y'], $excel_file_name, $worksheet_name, $line_number);
					if($storage_master_id) {
						$aliquot_counter++;
						$aliquot_data = array(
							'aliquot_masters' => array(
								"barcode" => 'tmp_core_'.$aliquot_counter,
								"aliquot_label" => $excel_line_data['PathoID'].'-'.$excel_line_data['BlocID'].' ('.$block_ids['collection_participant_identifier'].')',
								"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-core']['id'],
								"collection_id" => $block_ids['collection_id'],
								"sample_master_id" => $block_ids['sample_master_id'],
								'in_stock' => 'yes - available',
								'storage_master_id' => $storage_master_id,
								'storage_coord_x' => $storage_coord_x,
								'storage_coord_y' => $storage_coord_y,
								'use_counter' => '0',
								'notes' => 'Created by system for TMA creation'),
							$atim_controls['aliquot_controls']['tissue-core']['detail_tablename'] => array(
								'qc_nd_core_nature' => validateAndGetStructureDomainValue($excel_line_data['Dx PathRev'], 'qc_nd_core_natures', 'Core Creation', '', "REF: $excel_file_name / $worksheet_name, line $line_number.")));
						$core_aliquot_master_id = customInsertRecord($aliquot_data);
						if($block_ids['collection_participant_identifier'] != $excel_line_data['NoLabo']) {
							recordErrorAndMessage('Patient Core: Core Creation', '@@WARNING@@', "File NoLabo won't be dispalyed in core label", "The system created a new core with aliquot label '".$aliquot_data['aliquot_masters']["aliquot_label"]."' that does not containt the NoLabo of the excel file '".$excel_line_data['NoLabo']."'. REF: $excel_file_name / $worksheet_name, line $line_number.");
						}
						$realiquoting_data = array(
							'realiquotings' => array(
								'parent_aliquot_master_id' => $block_ids['aliquot_master_id'],
								'child_aliquot_master_id' => $core_aliquot_master_id));
						customInsertRecord($realiquoting_data);									
					} else {
						recordErrorAndMessage('Patient Core: Core Creation', '@@ERROR@@', "Unable to create TMA", "The system was not able to create the TMA '".$excel_line_data['TMA name']."' for the patient ".$excel_line_data['NoLabo'].". No core will be created. REF: $excel_file_name / $worksheet_name, line $line_number.");						
					}	
				}
			}
		} else if(strlen($excel_line_data['PathoID'])) {
			//*******************************
			// *** 2 *** TMA Control Core ***
			//*******************************
			// 1.0 --> check required fields
			$fields_validated = true;
			$required_fields = array(
					'TMA name' => 1,
					//NoLabo not empty for sure
					'Bank' => 0,
					'Type Code' => 0,
					'Laterality' => 0,
					//PathoID not empty for sure	
					//Dx PathRev : optional
					'BlocID' => 0,
					'Position X' => 1,
					'Position Y' => 1);
			foreach($required_fields as $tested_field => $requested) {
				if($requested) {
					if(!strlen($excel_line_data[$tested_field])) {
						$fields_validated = false;
						recordErrorAndMessage('TMA Control', '@@ERROR@@', "Data of field '$tested_field} is requested", "The core won't be created . REF: $excel_file_name / $worksheet_name, line $line_number.");
					}
				} else if(strlen($excel_line_data[$tested_field])) {
					$fields_validated = false;
					recordErrorAndMessage('TMA Control', '@@ERROR@@', "Data of field '".$tested_field."' should not be completed", "The core won't be created . REF: $excel_file_name / $worksheet_name, line $line_number.");
				}
			}
			if($fields_validated) {
				//Build tissue patho_dpt_block_code
				$collection_id = $controls_collections['collection_id'];
				$sample_master_id = null;
				$block_aliquot_master_id = null;
				$patho_dpt_block_code = $excel_line_data['PathoID'];
				if(strlen($excel_line_data['Dx PathRev']) && $patho_dpt_block_code != $excel_line_data['Dx PathRev']) $patho_dpt_block_code .= ' '.$excel_line_data['Dx PathRev'];
				if(isset($controls_collections['block_aliquot_master_ids'][$patho_dpt_block_code])) {
					if(sizeof($controls_collections['block_aliquot_master_ids'][$patho_dpt_block_code]) > 1) {
						recordErrorAndMessage('TMA Control', '@@WARNING@@', "TMA control block duplicated.", "The TMA control block '".$patho_dpt_block_code."' has been created more than once into ATiM. New core will be linked to the first one. Please check data. REF: $excel_file_name / $worksheet_name, line $line_number.");
					}
					list($sample_master_id, $block_aliquot_master_id) = array_values($controls_collections['block_aliquot_master_ids'][$patho_dpt_block_code][0]);
				} else {
					// Sample
					$sample_counter++;
					$detail_tablename = $atim_controls['sample_controls']['tissue']['detail_tablename'];
					$sample_data = array(
						'sample_masters' => array(
							"sample_code" => 'tmp_tissue_'.$sample_counter,
							"sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
							"initial_specimen_sample_type" => 'tissue',
							"collection_id" => $collection_id),
						'specimen_details' => array(),
						$atim_controls['sample_controls']['tissue']['detail_tablename'] => array());
					$sample_data['sample_masters']['qc_nd_sample_label'] = createSampleLabel('', '', '') ;
					$sample_master_id = customInsertRecord($sample_data);
					$creation_messages_for_summary["TMA Control Creation Summary"]["New sample creation"][] = "The system created a new tissue sample for the core control '$patho_dpt_block_code'. REF: $excel_file_name / $worksheet_name, line $line_number.";
					//Aliquot: Block
					$aliquot_counter++;
					$aliquot_data = array(
						'aliquot_masters' => array(
							"barcode" => 'tmp_core_'.$aliquot_counter,
							"aliquot_label" => $patho_dpt_block_code,
							"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
							"collection_id" => $collection_id,
							"sample_master_id" => $sample_master_id,
							'in_stock' => 'yes - available',
							'use_counter' => '1',
							'notes' => 'Created by system for TMA creation'),
						$atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
							'block_type' => 'paraffin',
							'patho_dpt_block_code' => $patho_dpt_block_code));
					$block_aliquot_master_id = customInsertRecord($aliquot_data);
					$creation_messages_for_summary["TMA Control Creation Summary"]["New block creation"][] = "The system created a new tissue block '$patho_dpt_block_code'. REF: $excel_file_name / $worksheet_name, line $line_number.";	
					$controls_collections['block_aliquot_master_ids'][$patho_dpt_block_code][] = array('sample_master_id' => $sample_master_id, 'aliquot_master_id' => $block_aliquot_master_id);
				}
				list($storage_master_id, $storage_coord_x, $storage_coord_y) = getStorageMasterIdAndValidatePositions($excel_line_data['TMA name'], $excel_line_data['Position X'], $excel_line_data['Position Y'], $excel_file_name, $worksheet_name, $line_number);
				if($storage_master_id) {
					$aliquot_counter++;
					$aliquot_data = array(
						'aliquot_masters' => array(
							"barcode" => 'tmp_core_'.$aliquot_counter,
							"aliquot_label" => $patho_dpt_block_code,
							"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-core']['id'],
							"collection_id" => $collection_id,
							"sample_master_id" => $sample_master_id,
							'in_stock' => 'yes - available',
							'storage_master_id' => $storage_master_id,
							'storage_coord_x' => $storage_coord_x,
							'storage_coord_y' => $storage_coord_y,
							'use_counter' => '0',
							'notes' => 'Created by system for TMA creation'),
						$atim_controls['aliquot_controls']['tissue-core']['detail_tablename'] => array());
					$core_aliquot_master_id = customInsertRecord($aliquot_data);
					$realiquoting_data = array(
						'realiquotings' => array(
							'parent_aliquot_master_id' => $block_aliquot_master_id,
							'child_aliquot_master_id' => $core_aliquot_master_id));
					customInsertRecord($realiquoting_data);
				} else {
					recordErrorAndMessage('TMA Control', '@@ERROR@@', "Unable to create TMA", "The system was not able to create the TMA '".$excel_line_data['TMA name']."' for the control ".$patho_dpt_block_code.". No core will be created. REF: $excel_file_name / $worksheet_name, line $line_number.");
				}
			}
		} else {
			//**********************
			// *** 3 *** No Core ***
			//**********************
			// 1.0 --> check required fields
			$unrequired_fields = array(
					//TMA name we don't care
					//NoLabo not empty for sure
					'Bank',
					'Type Code',
					'Laterality',
					//PathoID empty for sure
					'Dx PathRev',
					'BlocID');
			foreach($unrequired_fields as $tested_field) {
				if(strlen($excel_line_data[$tested_field])) {
					recordErrorAndMessage('Empty Line Data Validation', '@@WARNING@@', "Value of field '".$tested_field."' should not be completed", "Please check . REF: $excel_file_name / $worksheet_name, line $line_number.");
				}
			}
		}
	}
}

//---------------------------------------------------------------------------------------------
// End of the process
//---------------------------------------------------------------------------------------------

$query = "UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE sample_control_id=". $atim_controls['sample_controls']['tissue']['id']." AND sample_code LIKE 'tmp_tissue_%';";
customQuery($query);
$query = "UPDATE aliquot_masters SET barcode=id WHERE aliquot_control_id IN (". $atim_controls['aliquot_controls']['tissue-block']['id'].",".$atim_controls['aliquot_controls']['tissue-core']['id'].") AND barcode LIKE 'tmp_core_%';";
customQuery($query);

$query = "UPDATE storage_masters SET code=id WHERE code LIKE 'tmp%'";
customQuery($query);

if(false) {
	customQuery("UPDATE storage_masters  SET lft = null, rght = null;");
	customQuery("UPDATE versions SET permissions_regenerated = 0;");
} else {
	customQuery("UPDATE versions SET permissions_regenerated = 1;");
	customPermissionsRegeneration();
}

//Add creation message at the end of the summary
$query = "SELECT DISTINCT BlockAliquotMaster.barcode, BlockAliquotMaster.aliquot_label, BlockAliquotDetail.sample_position_code, BlockAliquotDetail.patho_dpt_block_code
	FROM aliquot_masters BlockAliquotMaster
	INNER JOIN ".$atim_controls['aliquot_controls']['tissue-block']['detail_tablename']." AS BlockAliquotDetail ON BlockAliquotDetail.aliquot_master_id = BlockAliquotMaster.id
	INNER JOIN realiquotings Realiquoting ON Realiquoting.parent_aliquot_master_id = BlockAliquotMaster.id AND Realiquoting.deleted <> 1
	INNER JOIN aliquot_masters CoreAliquotMaster ON Realiquoting.child_aliquot_master_id = CoreAliquotMaster.id
	WHERE BlockAliquotMaster.deleted <> 1
	AND BlockAliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
	AND BlockAliquotMaster.created != '".$import_date."'
	AND CoreAliquotMaster.deleted <> 1
	AND CoreAliquotMaster.aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-core']['id']."
	AND CoreAliquotMaster.created = '".$import_date."'";
foreach(getSelectQueryResult($query) as $new_block) {
	recordErrorAndMessage('Existing Block Used', '@@MESSAGE@@', "List of block already created into ATiM and linked to created cores", " --> Label : ".$new_block['aliquot_label'].' / PathoID : '.$new_block['sample_position_code'].' '.$new_block['patho_dpt_block_code'].' ('.$new_block['barcode'].')');
}
foreach($creation_messages_for_summary as $title => $creation_messages_for_summary_sub_level) {
	foreach($creation_messages_for_summary_sub_level as $sub_title => $creation_messages_for_summary_messages) {
		foreach($creation_messages_for_summary_messages as $summary_messages) {
			recordErrorAndMessage($title, '@@MESSAGE@@', $sub_title, $summary_messages);	
		}
	}	
}

dislayErrorAndMessage(false);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function createSampleLabel($bank_participant_identifier, $type_code, $labo_laterality) {
	return (empty($type_code)? 'n/a' : $type_code) . ' - ' . (empty($bank_participant_identifier)? 'n/a' : $bank_participant_identifier) . (empty($labo_laterality)? ' n/a': ' ' . $labo_laterality);
}

function getStorageMasterIdAndValidatePositions($tma_short_label, $storage_coord_x, $storage_coord_y, $excel_file_name, $worksheet_name, $line_number) {
	global $tma_short_label_to_storage_master_id;
	global $atim_controls;
	global $import_summary;
	
	$storage_master_id = false;
	
	// Get TMA id
	if($tma_short_label) {
		if(!isset($tma_short_label_to_storage_master_id[$tma_short_label])) {
			$existing_tma = getSelectQueryResult("SELECT StorageMaster.id AS storage_master_id
				FROM storage_masters StorageMaster
				WHERE StorageMaster.deleted <> 1 AND StorageMaster.storage_control_id = ".$atim_controls['storage_controls']['TMA-blc 29X29']['id']." AND StorageMaster.short_label = '$tma_short_label'");
			if(sizeof($existing_tma) > 1) migrationDie("More than one TMA $tma_short_label exist into ATiM");
			if($existing_tma) {
				$existing_tma = array_shift($existing_tma);
				$tma_short_label_to_storage_master_id[$tma_short_label] = $existing_tma['storage_master_id'];
				recordErrorAndMessage('TMA creation & positions check', '@@WARNING@@', "TMA name was already created into ATiM", "See TMA : $tma_short_label [FROM FILE : $excel_file_name]. Please check data (TMA, core, etc) has not been duplicated!");
			} else {
				$storage_data = array(
					'storage_masters' => array(
						'code' => 'tmp'.(sizeof($tma_short_label_to_storage_master_id) + 1),
						'storage_control_id' => $atim_controls['storage_controls']['TMA-blc 29X29']['id'],
						'short_label' => $tma_short_label,
						'selection_label' => $tma_short_label),
					$atim_controls['storage_controls']['TMA-blc 29X29']['detail_tablename'] => array());
				$tma_short_label_to_storage_master_id[$tma_short_label] = customInsertRecord($storage_data);
				recordErrorAndMessage('TMA creation & positions check', '@@MESSAGE@@', "Files Names & TMA name", " ==> Created TMA : $tma_short_label [FROM FILE : $excel_file_name]");
			}
		}
		$storage_master_id = $tma_short_label_to_storage_master_id[$tma_short_label];
	}
	
	// Validate positions
	if($storage_master_id) {
		if(!preg_match('/^(([1-9])|([12][0-9]))$/', $storage_coord_x)) {
			recordErrorAndMessage('TMA creation & positions check', '@@WARNING@@', "Wrong x coordinate", "See position '$storage_coord_x'. Core position won't be set.  REF: $excel_file_name / $worksheet_name, line $line_number.");
			$storage_coord_x = null;
		}
		if(!preg_match('/^(([1-9])|([12][0-9]))$/', $storage_coord_y)) {
			recordErrorAndMessage('TMA creation & positions check', '@@WARNING@@', "Wrong y coordinate", "See position '$storage_coord_y'. Core position won't be set.  REF: $excel_file_name / $worksheet_name, line $line_number.");
			$storage_coord_y = null;
		}
	} else {
		$storage_coord_x = null;
		$storage_coord_y = null;
	}
	
	return array($storage_master_id, $storage_coord_x, $storage_coord_y);
}

function customPermissionsRegeneration() {
	global $import_date;
	global $imported_by;
	
	pr("customPermissionsRegeneration() function used - not in prod");
	
	//Storage left right
	$query = "select MAX(rght) as last_rght from storage_masters;";
	$res_storage = getSelectQueryResult($query);
	$last_rght = $res_storage[0]['last_rght'];
	$query = "SELECT id from storage_masters WHERE lft IS NULL AND created = '".$import_date."' AND created_by = ".$imported_by;
	foreach(getSelectQueryResult($query) as $new_storage) {
		$query = "UPDATE storage_masters SET lft = ".($last_rght+1).", rght = ".($last_rght+2)." WHERE id = ".$new_storage['id'];
		customQuery($query);
		$last_rght += 2;
	}
	
	//View Update
	
	$query = 'SELECT
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
			WHERE AliquotMaster.deleted != 1 AND AliquotMaster.created = "'.$import_date.'" AND AliquotMaster.created_by = '.$imported_by;
	customQuery("REPLACE INTO view_aliquots ($query)");
	
	
	$query = '
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
		Participant.participant_identifier AS participant_identifier,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created,
Bank.name AS bank_name,
MiscIdentifier.identifier_value AS identifier_value,
MiscIdentifierControl.misc_identifier_name AS identifier_name,
Collection.visit_label AS visit_label
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
		WHERE Collection.deleted <> 1 AND Collection.created = "'.$import_date.'" AND Collection.created_by = '.$imported_by;
	customQuery("REPLACE INTO view_collections ($query)");
	
	
	$query = '
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
		WHERE SampleMaster.deleted != 1 AND SampleMaster.created = "'.$import_date.'" AND SampleMaster.created_by = '.$imported_by;
	customQuery("REPLACE INTO view_samples ($query)");
	
	$query =
		"SELECT CONCAT(Realiquoting.id ,2) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'realiquoted to' AS use_definition,
--		AliquotMasterChild.barcode AS use_code,
CONCAT(AliquotMasterChild.aliquot_label,' [',AliquotMasterChild.barcode,']') AS use_code,
		'' AS use_details,
		Realiquoting.parent_used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		Realiquoting.realiquoting_datetime AS use_datetime,
		Realiquoting.realiquoting_datetime_accuracy AS use_datetime_accuracy,
		'' AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		'-1' AS study_summary_id
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1 AND Realiquoting.created = '".$import_date."' AND Realiquoting.created_by = ".$imported_by;
	
	customQuery("REPLACE INTO view_aliquot_uses ($query)");
	
	$query = "SELECT StorageMaster.*, 
		IF(coord_x_size IS NULL AND coord_y_size IS NULL, NULL, IFNULL(coord_x_size, 1) * IFNULL(coord_y_size, 1) - COUNT(AliquotMaster.id) - COUNT(TmaSlide.id) - COUNT(ChildStorageMaster.id)) AS empty_spaces 
		FROM storage_masters AS StorageMaster
		INNER JOIN storage_controls AS StorageControl ON StorageMaster.storage_control_id=StorageControl.id
		LEFT JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.storage_master_id=StorageMaster.id AND AliquotMaster.deleted=0
		LEFT JOIN tma_slides AS TmaSlide ON TmaSlide.storage_master_id=StorageMaster.id AND TmaSlide.deleted=0
		LEFT JOIN storage_masters AS ChildStorageMaster ON ChildStorageMaster.parent_id=StorageMaster.id AND ChildStorageMaster.deleted=0
		WHERE StorageMaster.deleted=0  AND StorageMaster.created = '".$import_date."' AND StorageMaster.created_by = ".$imported_by." GROUP BY StorageMaster.id";
	
	customQuery("REPLACE INTO view_storage_masters ($query)");
	
}
		
?>
		