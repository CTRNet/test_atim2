<?php

require_once 'system.php';

truncate();

//==============================================================================================
// Main Code
//==============================================================================================

/* Banks:
 *   Breast/Sein
 *   Ovarian/Ovaire
 *   Prostate
 *   Head&Neck/Tête&cou
 *   Kidney/Rein
 *   Gynecologic/Gynécologique
 *   Autopsy/Autopsie
 */
$excel_file_names = array(
	utf8_decode("2006 Sein  Hotel Dieu Verifie-DJ ATIM.xls") => 'Breast/Sein',
	utf8_decode("2011 Sein Hotel-Dieu Verifie_AtiM.xls") => 'Breast/Sein',
	utf8_decode("2012 Sein Hotel-Dieu Verifie-_AtiM.xls") => 'Breast/Sein',
	utf8_decode("2013 Sein  Hotel-Dieu Verifie-AtiM.xls") => 'Breast/Sein',
	utf8_decode("2014 Sein Hotel-Dieu DIAMIC-DJ_ajout biopsies_ATIM.xls") => 'Breast/Sein',
	utf8_decode("2015 Sein Hotel-Dieu Diamic DJ_1ere partie_AtiM.xls") => 'Breast/Sein');

displayMigrationTitle('CHUM Pathology Departement Blocks Migration To Banks', array_keys($excel_file_names), true);

if(!testExcelFile(array_keys($excel_file_names))) {
	dislayErrorAndMessage();
	exit;
}

$bank_from_ids = array();
foreach(getSelectQueryResult("SELECT id, name from banks WHERE deleted <> 1") as $new_bank) $bank_from_ids[$new_bank['name']] = $new_bank['id'];
	
$matching_collections = 0;
$created_collections = 0;
$created_tissues = 0;
$created_blocks = 0;
$excel_participants_to_atim_data = array();
$excel_participants_names_and_ramq_controls = array();
global $storages;
$storages = array();
$created_storages = 0;
foreach($excel_file_names as $excel_file_name => $bank) {
	//-----------------------------------------------------------------------------------------------------------------------
	// NEW PARSED FILE
	//-----------------------------------------------------------------------------------------------------------------------
	
	// *** NEW STEP **************************************************************************************************************************************************************
	//	Check Bank
	// ***************************************************************************************************************************************************************************
	
	if(!array_key_exists($bank, $bank_from_ids)) {
		recordErrorAndMessage('File Check', '@@ERROR@@', "Bank does not exist into ATiM. No file data will be downloaded.", "Check bank '$bank' associated to the Excel file <b>".utf8_encode($excel_file_name)."</b>");
		continue;
		
	}
	$excel_bank_id = $bank_from_ids[$bank];
	
	$worksheet_name = 'blocks';
	$header_check_done = false;
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
		$excel_file_name_for_summary = "<b>".utf8_encode($excel_file_name)."</b>";
		
		// *** NEW STEP **************************************************************************************************************************************************************
		//	Check File Headers
		// ***************************************************************************************************************************************************************************
		
		if(!$header_check_done) {
			$headers = array(		
				'Nom',
				'Prénom',
				'No de dossier',
				'RAMQ',
				'Date du prélèvement',
				'No patho',
				'Lieu du Prélèvement ND, SL, HD',
				'Énumération des blocs',
				'Rangée',
				'Section',
				'Tablette',
				'Boite',
				'Tiroir');
			$missing_header = false;
			foreach($headers as $new_header) {
				if(!array_key_exists($new_header, $excel_line_data)) {
					$missing_header = true;
					recordErrorAndMessage('File Check', '@@ERROR@@', "File header missing. No file data will be downloaded.", "Check header '$new_header' in the Excel file '$excel_file_name_for_summary'.");
				}
			}
			if($missing_header) break;
			$header_check_done = true;
		}
		
		// *** NEW STEP **************************************************************************************************************************************************************
		//	Find a participant matching participant information
		// ***************************************************************************************************************************************************************************
		
		//Flush value that should be considered as empty (comment)
		foreach(array('RAMQ', 'No de dossier') as $excel_field) 
			$excel_line_data[$excel_field] = str_replace(array('rien sur diamic', 'pas sur diamic'), array('', ''), $excel_line_data[$excel_field]);
		
		//Set info for summary message
		$summary_label_see_line_and_file = "file <i>$excel_file_name_for_summary</i> line $line_number";
		
		if(!strlen($excel_line_data['RAMQ'].$excel_line_data['No de dossier'])) {
			recordErrorAndMessage('File Check', '@@WARNING@@', "The participant identifier values ('RAMQ' & 'No de dossier') are empty in a parsed Excel line. The Excel data of the line won't be downloaded.", "See $summary_label_see_line_and_file.");
		} else {
			//Set info for summary message
			$summary_label_participant_excel_nominal_data = "Excel participant ".$excel_line_data['Prénom']." ".$excel_line_data['Nom']." [RAMQ = '".$excel_line_data['RAMQ']."' and No de dossier' = '".$excel_line_data['No de dossier']."'] -  $summary_label_see_line_and_file";
			
			// *** Check RAMQ and names are always the same for an identifier accross lines and files ************************************************************************************
					
			$participant_names_and_ramq_key = $excel_line_data['Prénom']." ".$excel_line_data['Nom']." [RAMQ='".$excel_line_data['RAMQ']."']";
			$continue_line_parsing = true;
			foreach(array('RAMQ', 'No de dossier') as $identifier) {
				$identifier_value = $excel_line_data[$identifier];
				if(strlen($identifier_value)) {
					$identifier_value = "$identifier=$identifier_value";
					if(!array_key_exists($identifier_value, $excel_participants_names_and_ramq_controls)) {
						$excel_participants_names_and_ramq_controls[$identifier_value] = array('inital_names_and_ramq' => $participant_names_and_ramq_key, 'initial_parsed_line' => $summary_label_see_line_and_file);
					} else if($excel_participants_names_and_ramq_controls[$identifier_value]['inital_names_and_ramq'] != $participant_names_and_ramq_key) {
						recordErrorAndMessage('Participant detection', '@@ERROR@@', "The $identifier value is listed into more than one Excel line but the nominal data (names & 'RAMQ') of the new parsed line does not match data of a previous parsed line. No data of the new parsed Excel line will be downloaded.", "Please compare <b>$participant_names_and_ramq_key</b> and <b>".$excel_participants_names_and_ramq_controls[$identifier_value]['inital_names_and_ramq']."</b>. See $excel_file_name_for_summary plus ".$excel_participants_names_and_ramq_controls[$identifier_value]['initial_parsed_line'].".");
						$continue_line_parsing = false;
					}
				}
			}
			
			if($continue_line_parsing) {
				
				$excel_participants_to_atim_key = $excel_line_data['RAMQ']."//".$excel_line_data['No de dossier'];
				if(!isset($excel_participants_to_atim_data[$excel_participants_to_atim_key])) {
					
					// *** First time RAMQ and No Dossier combination parsed : Check identifiers match one participant *************************************************************************
								
					$excel_participants_to_atim_data[$excel_participants_to_atim_key] = array(
						'participant_id' => null,
						'first_name' => null,
						'last_name' => null,
						'collections' => array());
					$participant_detection_error = false;
					$matching_participants = array();
					$all_misc_identifier_control_ids = array(
						'RAMQ' => array($atim_controls['misc_identifier_controls']['ramq nbr']['id']),
						'No de dossier' => array($atim_controls['misc_identifier_controls']['hotel-dieu id nbr']['id'], $atim_controls['misc_identifier_controls']['notre-dame id nbr']['id'], $atim_controls['misc_identifier_controls']['saint-luc id nbr']['id']));
					foreach($all_misc_identifier_control_ids as $excel_field => $misc_identifier_controls_ids) {
						$excel_value = $excel_line_data[$excel_field];
						if(strlen($excel_value)) {
							$query = "SELECT DISTINCT participant_id, first_name, last_name 
								FROM misc_identifiers INNER JOIN participants ON participants.id = participant_id
								WHERE identifier_value = '".str_replace("'", "''", $excel_value)."'
								AND misc_identifiers.deleted <> 1
								AND misc_identifier_control_id IN (".implode(",", $misc_identifier_controls_ids).")";
							$atim_data = getSelectQueryResult($query);
							if(sizeof($atim_data) > 1) {
								recordErrorAndMessage('Participant detection', '@@ERROR@@', "More than one ATiM participant matches a $excel_field value. No data of the Excel lines matching this $excel_field will be downloaded.", "See all lines with  '$excel_field' = '$excel_value'. See for example : $summary_label_participant_excel_nominal_data.");
								$participant_detection_error = true;
							} else if(sizeof($atim_data)) {
								$matching_participants[$excel_field] = $atim_data;
							}
						}
					}
					if(!$participant_detection_error) {
						//At least one participant matched based on at least one identifier
						if(sizeof($matching_participants) == '2') {
							$matching_participants = array_values($matching_participants);
							if($matching_participants[0][0]['participant_id'] == $matching_participants[1][0]['participant_id']) {
								//Perfect match (on 2 identifiers) : Set participant_id and names
								$excel_participants_to_atim_data[$excel_participants_to_atim_key]['participant_id'] = $matching_participants[0][0]['participant_id'];
								$excel_participants_to_atim_data[$excel_participants_to_atim_key]['first_name'] = $matching_participants[0][0]['first_name'];
								$excel_participants_to_atim_data[$excel_participants_to_atim_key]['last_name'] = $matching_participants[0][0]['last_name'];
							} else {
								//The identifiers matche 2 different participant
								recordErrorAndMessage('Participant detection', '@@ERROR@@', "Two different ATiM participants match the Excel participant identifiers ('RAMQ' and 'No de dossier'). No data of the Excel lines with these 2 identifiers will be downloaded.", "See the 2 ATiM 'Participant System Codes' : ".$matching_participants[0][0]['participant_id']." & ".$matching_participants[1][0]['participant_id'].". See for example : $summary_label_participant_excel_nominal_data.");
							}
						} else if(sizeof($matching_participants)) {
							//Match (on 1 identifier) : Set participant_id and names
							$matching_identifier = array_keys($matching_participants);
							$matching_identifier = array_shift($matching_identifier);
							$matching_participants = array_values($matching_participants);
							$excel_participants_to_atim_data[$excel_participants_to_atim_key]['participant_id'] = $matching_participants[0][0]['participant_id'];
							$excel_participants_to_atim_data[$excel_participants_to_atim_key]['first_name'] = $matching_participants[0][0]['first_name']; 
							$excel_participants_to_atim_data[$excel_participants_to_atim_key]['last_name'] = $matching_participants[0][0]['last_name'];
							recordErrorAndMessage('Participant detection', '@@WARNING@@', "Participant matches based on only the $matching_identifier of the Excel line. Data of Excel file lines matching these $matching_identifier will be downloaded but please confirm match.", "See for example ATiM participant ".$matching_participants[0][0]['first_name']." ".$matching_participants[0][0]['last_name']." matching $summary_label_participant_excel_nominal_data.");
						} else {
							recordErrorAndMessage('Participant detection', '@@ERROR@@', "No participant matches the Excel participant identifiers ('RAMQ' and/or 'No de dossier'). No data of the Excel lines matching these identifier values combination will be downloaded.", "See for example : $summary_label_participant_excel_nominal_data.");
						}
					}
				}
				
				// *** NEW STEP **************************************************************************************************************************************************************
				//	Find collection
				// ***************************************************************************************************************************************************************************
				
				if($excel_participants_to_atim_data[$excel_participants_to_atim_key]['participant_id']) {
					$participant_id = $excel_participants_to_atim_data[$excel_participants_to_atim_key]['participant_id'];
					if(!strlen($excel_line_data['Énumération des blocs'])) {
						recordErrorAndMessage('Block Definition', '@@MESSAGE@@', "Empty Block code (ex:A1). No data of the block will be downloaded.", "See  $summary_label_participant_excel_nominal_data.");
					} else if(!preg_match('/^([A-Z]+)([0-9]+)$/', $excel_line_data['Énumération des blocs'], $matches)) {
						recordErrorAndMessage('Block Definition', '@@ERROR@@', "Wrong Block code format (ex:A1). No data of the block will be downloaded.", "See value [".$excel_line_data['Énumération des blocs']."] of the $summary_label_participant_excel_nominal_data.");
					} else {
						$sample_notes = array();
						//Get/format block data
						$excel_block_code = $excel_line_data['Énumération des blocs'];
						$excel_block_prefix = $matches[1];
						$excel_collection_site = '';
						if(in_array($excel_line_data['Lieu du Prélèvement ND, SL, HD'], array('ND', 'SL', 'HD'))) {
							$excel_collection_site = str_replace(array('ND', 'SL', 'HD'), array('', '', ''), $excel_line_data['Lieu du Prélèvement ND, SL, HD']);
						} else if(strlen($excel_line_data['Lieu du Prélèvement ND, SL, HD'])) {
							$sample_notes[] = "Tissue collection site = ".$excel_line_data['Lieu du Prélèvement ND, SL, HD'].".";
							recordErrorAndMessage('Block Definition', '@@WARNING@@', "Wrong 'Lieu du Prélèvement ND, SL, HD' format. The value won't be recorded at collection but in tissue notes.", "See value [".$excel_line_data['Lieu du Prélèvement ND, SL, HD']."].", $excel_line_data['Lieu du Prélèvement ND, SL, HD']);
						}
						$excel_no_patho = '';
						if(preg_match('/^[\']{0,1}(.*[0-9]{4,100}.*)$/', $excel_line_data['No patho'], $matches)) {
							$excel_no_patho = $matches[1];
						} else {
							recordErrorAndMessage('Block Definition', '@@WARNING@@', "Wrong pathology code format. The pathology code won't be recorded.", "See value [".$excel_line_data['No patho']."] of the $summary_label_participant_excel_nominal_data.");
						}
						list($excel_collection_datetime, $excel_collection_datetime_accuracy) = validateAndGetDateAndAccuracy($excel_line_data['Date du prélèvement'], 'Block Definition', 'Date du prélèvement', "See $summary_label_participant_excel_nominal_data.");
						
						// *** NEW STEP **************************************************************************************************************************************************************
						//	Create/Load Collection
						// ***************************************************************************************************************************************************************************
						
						$collection_id = null;
						$collection_key = $excel_bank_id.'//'.$participant_id."//".$excel_collection_datetime."//".$excel_collection_site;
						if(!isset($excel_participants_to_atim_data[$excel_participants_to_atim_key]['collections'][$collection_key])) {
							//Check collection exists or not
							$query = "SELECT DISTINCT
								Collection.id collection_id,
								Collection.collection_datetime,
								Collection.collection_datetime_accuracy,
								Collection.qc_nd_pathology_nbr
								FROM collections Collection
								INNER JOIN sample_masters SampleMaster ON Collection.id = SampleMaster.collection_id
								INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
								INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
								WHERE Collection.deleted <> 1
								AND SampleMaster.deleted <> 1
								AND Collection.bank_id = $excel_bank_id
								AND Collection.participant_id = $participant_id
								AND ".($excel_collection_datetime? "Collection.collection_datetime LIKE '$excel_collection_datetime%'" : "Collection.collection_datetime LIKE '-1'")."
								AND ".($excel_collection_site? "Collection.collection_site LIKE '$excel_collection_site'" : "TRUE")."
								AND ".($excel_no_patho? "Collection.qc_nd_pathology_nbr LIKE '$excel_no_patho'" : "TRUE").";";
							$atim_data = getSelectQueryResult($query);
							if($atim_data) {
								$collection_id = $atim_data[0]['collection_id'];
								$matching_collections++;
							} else {
								$collection_data = array(
									'bank_id' => $excel_bank_id,
									'participant_id' => $participant_id,
									'acquisition_label' => 'Pathology Blocks Collection',
									'collection_property' => 'participant collection',
									'qc_nd_pathology_nbr' => $excel_no_patho,
									'collection_site' => $excel_collection_site,
									'collection_notes' => 'Created by the process to download the pathology blocks data from excel file.'
								);
								if($excel_collection_datetime) {
									$collection_data['collection_datetime'] = $excel_collection_datetime;
									$collection_data['collection_datetime_accuracy'] = 'h';
								}
								$collection_id = customInsertRecord(array('collections' => $collection_data));
								$created_collections++;
							}
							$excel_participants_to_atim_data[$excel_participants_to_atim_key]['collections'][$collection_key] = array('collection_id' => $collection_id, 'tissues' => array());
						}
						$collection_id = $excel_participants_to_atim_data[$excel_participants_to_atim_key]['collections'][$collection_key]['collection_id'];
						
						// *** NEW STEP **************************************************************************************************************************************************************
						//	Create/Load Tissue
						// ***************************************************************************************************************************************************************************
						
						$sample_master_id = null;
						if(!isset($excel_participants_to_atim_data[$excel_participants_to_atim_key]['collections'][$collection_key]['tissues'][$excel_block_prefix])) {
							$sample_notes[] = "Created by the process to download the pathology blocks data from excel file.";
							$sample_data = array(
								'sample_masters' => array(
									'collection_id' => $collection_id,
									'sample_control_id' => $atim_controls['sample_controls']['tissue']['id'],
									'initial_specimen_sample_type' => 'nail',
									'qc_nd_sample_label' => "n/a - n/a n/a",
									'sample_code' => 'tmp_block_'.($created_tissues),
									'notes' => implode(' ', $sample_notes)),
								'specimen_details' => array(),
								$atim_controls['sample_controls']['tissue']['detail_tablename'] => array());
							$excel_participants_to_atim_data[$excel_participants_to_atim_key]['collections'][$collection_key]['tissues'][$excel_block_prefix] = customInsertRecord($sample_data);
							$created_tissues++;
						}
						$sample_master_id = $excel_participants_to_atim_data[$excel_participants_to_atim_key]['collections'][$collection_key]['tissues'][$excel_block_prefix];
						
						// *** NEW STEP **************************************************************************************************************************************************************
						//	Create block
						// ***************************************************************************************************************************************************************************
						
						$aliquot_label = ($excel_no_patho? $excel_no_patho : '?')." - $excel_block_code";
						$aliquot_data = array(
							'aliquot_masters' => array(
								"barcode" => 'tmp_block_'.($created_blocks),
								"aliquot_label" => $aliquot_label,
								"aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
								"collection_id" => $collection_id,
								"sample_master_id" => $sample_master_id,
								'in_stock' => 'yes - available'),
							$atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
								'block_type'  => 'paraffin',		
								'sample_position_code' => $excel_block_code));
						setStorageData($aliquot_data, $excel_line_data, $aliquot_label, $summary_label_participant_excel_nominal_data);					
						$aliquot_master_id = customInsertRecord($aliquot_data);
						$created_blocks++;
					}
				}
			}
		}
	}

}

$final_queries = array(
	"UPDATE sample_masters SET sample_code = id WHERE sample_code LIKE 'tmp_block_%';",
	"UPDATE aliquot_masters SET barcode = id WHERE barcode LIKE 'tmp_block_%';",
	"UPDATE storage_masters SET code = id WHERE code LIKE 'tmp_storage_%';",
	"UPDATE versions SET permissions_regenerated = 0;"
);
foreach($final_queries as $new_query) customQuery($new_query);

recordErrorAndMessage('Block Creation', '@@WARNING@@', "Number of created/used elements.", "$matching_collections ATiM collections used");
recordErrorAndMessage('Block Creation', '@@WARNING@@', "Number of created/used elements.", "$created_collections collections created");
recordErrorAndMessage('Block Creation', '@@WARNING@@', "Number of created/used elements.", "$created_tissues tissues samples created");
recordErrorAndMessage('Block Creation', '@@WARNING@@', "Number of created/used elements.", "$created_blocks aliquots created");
recordErrorAndMessage('Block Creation', '@@WARNING@@', "Number of created/used elements.", "$created_storages storages created");

dislayErrorAndMessage(true);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function truncate() {
	global $migration_user_id;
	
	$truncate_date_limnite = '2016-08-19';
	$truncate_queries = array(
		"DELETE FROM  ad_blocks WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')", 
		"DELETE FROM  ad_blocks_revs WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')", 
		"DELETE FROM aliquot_masters  WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite';", 
		"DELETE FROM aliquot_masters_revs  WHERE modified_by = $migration_user_id AND version_created > '$truncate_date_limnite';", 
		"DELETE FROM  sd_spe_tissues WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')", 
		"DELETE FROM  sd_spe_tissues_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')", 
		"DELETE FROM  specimen_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')", 
		"DELETE FROM  specimen_details_revs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite')", 
		"UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null  WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite'",
		"DELETE FROM sample_masters WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite'",
		"DELETE FROM sample_masters_revs WHERE modified_by = $migration_user_id AND version_created > '$truncate_date_limnite';", 
		"DELETE FROM collections WHERE created_by = $migration_user_id AND created > '$truncate_date_limnite'",
		"DELETE FROM collections_revs WHERE modified_by = $migration_user_id AND version_created > '$truncate_date_limnite';");
	
	foreach($truncate_queries as $query) customQuery($query, __FILE__, __LINE__);
}

function setStorageData(&$aliquot_data, $excel_line_data, $aliquot_label, $summary_label_participant_excel_nominal_data) {
	global $atim_controls;
	global $storages;
	global $created_storages;
	
	$room_short_label = 'Patho-blocks';
	
	$storage_properties = array(
		'room' => '',
		'row' => 'Rangée',
		'section' => 'Section',
		'shelf' => 'Tablette',
		'blocks box' => 'Boite',
		'position' => 'Tiroir');
	$selection_label = '';
	$previous_storage_master_id = null;
	foreach($storage_properties as $storage_type => $excel_field) {
		$storage_value = ($storage_type == 'room')? $room_short_label : $excel_line_data[$excel_field];
		//Check data
		if($storage_type != 'position' && !isset($atim_controls['storage_controls'][$storage_type])) migrationDie("Storage $storage_type does not exist into ATiM.");
		if(!strlen($storage_value)) {
			recordErrorAndMessage('Block Definition', '@@WARNING@@', "Position information is missing: See '$excel_field' value. The position of the block won't be set.", "See block [$aliquot_label] of the $summary_label_participant_excel_nominal_data.");
			return;
		}
		if($storage_type == 'position' && !preg_match('/^[1-8]$/', $storage_value)) {
			recordErrorAndMessage('Block Definition', '@@ERROR@@', "Block position is wrong: See '$excel_field' value. The position of the block won't be set.", "See block [$aliquot_label] and position [$storage_value] of the $summary_label_participant_excel_nominal_data.");
			return;
		}	
		if($storage_type != 'position') {
			//Get storage_master_id
			$selection_label = (strlen($selection_label)? $selection_label.'-' : '').$storage_value;
			if(isset($storages[$selection_label])) {
				$previous_storage_master_id = $storages[$selection_label];
			} else {
				$query = "SELECT id FROM storage_masters WHERE storage_control_id = ".$atim_controls['storage_controls'][$storage_type]['id']." AND deleted <> 1 AND selection_label = '".str_replace("'", "''", $selection_label)."'";
				$atim_data = getSelectQueryResult($query);
				if($atim_data) {
					$storages[$selection_label] = $atim_data[0]['collection_id'];
					$previous_storage_master_id = $atim_data[0]['collection_id'];
				}  else {
					$storage_data = array(
						'storage_masters' => array(
							"code" => 'tmp_storage_'.($created_storages),
							"short_label" => $storage_value,
							"selection_label" => $selection_label,
							"storage_control_id" => $atim_controls['storage_controls'][$storage_type]['id'],
							'notes' => 'Created by the process to download the pathology blocks data from excel file.'),
						$atim_controls['storage_controls'][$storage_type]['detail_tablename'] => array());
					if($previous_storage_master_id) $storage_data['storage_masters']['parent_id'] = $previous_storage_master_id;
					$previous_storage_master_id = customInsertRecord($storage_data);
					$storages[$selection_label] = $previous_storage_master_id;
					$created_storages++;
				}
			}
		} else {
			//Set position
			if(!$previous_storage_master_id) migrationDie("Block box not created. See $summary_label_participant_excel_nominal_data."); 
			$aliquot_data['aliquot_masters']['storage_master_id'] = $previous_storage_master_id;
			$aliquot_data['aliquot_masters']['storage_coord_x'] = $storage_value;	
		}
	}
}
	
?>
		