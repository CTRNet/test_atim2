<?php

require_once 'system.php';

//if($is_test_process) truncate();

//==============================================================================================
// Main Code
//==============================================================================================

if(!testExcelFile(array_keys($excel_file_names))) {
	dislayErrorAndMessage();
	exit;
}

displayMigrationTitle("Block Migration Script", array_keys($excel_file_names));

echo "<font color='red'><br><br>Check at least one  collection date of the excel file matches a date of a created collection into ATiM!<br><br></font>";

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
foreach($excel_file_names as $excel_file_name => $file_info) {
	//-----------------------------------------------------------------------------------------------------------------------
	// NEW PARSED FILE
	//-----------------------------------------------------------------------------------------------------------------------
	
	// *** NEW STEP **************************************************************************************************************************************************************
	//	Check Bank
	// ***************************************************************************************************************************************************************************
	
	$bank = $file_info['bank'];
	if(!array_key_exists($bank, $bank_from_ids)) {
		recordErrorAndMessage('File Check'." [FILE : $excel_file_name]", '@@ERROR@@', "Bank does not exist into ATiM. No file data will be migrated into ATiM.", "Check bank '$bank' associated to the Excel file <b>".utf8_encode($excel_file_name)."</b>");
		continue;
		
	}
	$excel_bank_id = $bank_from_ids[$bank];
	
	foreach($file_info['worksheets'] as $worksheet_name) {
		$header_check_done = false;
		while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
			$excel_file_name_for_summary = "<b>".utf8_encode($excel_file_name)." [$worksheet_name]</b>";
			
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
					'No Patho',
					'Lieu du Prélèvement ND, SL, HD',
					'Enumeration des blocs',
					'Rangée',
					'Section',
					'Tablette',
					'Boite',
					'Tiroir');
				$missing_header = false;
				foreach($headers as $new_header) {
					if(!array_key_exists($new_header, $excel_line_data)) {
						$missing_header = true;
						recordErrorAndMessage('File Check'." [FILE : $excel_file_name]", '@@ERROR@@', "File header missing. No file data will be migrated into ATiM.", "Check header '$new_header' in the Excel file '$excel_file_name_for_summary'.");
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
				recordErrorAndMessage('File Check'." [FILE : $excel_file_name]", '@@WARNING@@', "The participant identifier values ('RAMQ' & 'No de dossier') are empty in a parsed Excel line. The Excel data of the line won't be migrated into ATiM.", "See $summary_label_see_line_and_file.");
			} else {
				//Set info for summary message
				$summary_label_participant_excel_nominal_data = "Excel participant ".$excel_line_data['Prénom']." ".$excel_line_data['Nom']." [RAMQ = '".$excel_line_data['RAMQ']."' and No de dossier' = '".$excel_line_data['No de dossier']."'] -  $summary_label_see_line_and_file";
				
				// *** Check RAMQ and names are always the same for an identifier accross lines and files ************************************************************************************
						
				$participant_names_and_ramq_key = strtolower(str_replace(array('-', 'é', 'è', 'ê'), array(' ', 'e', 'e', 'e'), $excel_line_data['Prénom']." ".$excel_line_data['Nom']." [RAMQ='".$excel_line_data['RAMQ']."']"));
				$continue_line_parsing = true;
				foreach(array('RAMQ', 'No de dossier') as $identifier) {
					$identifier_value = $excel_line_data[$identifier];
					if(strlen($identifier_value)) {
						$identifier_value = "$identifier=$identifier_value";
						if(!array_key_exists($identifier_value, $excel_participants_names_and_ramq_controls)) {
							$excel_participants_names_and_ramq_controls[$identifier_value] = array('inital_names_and_ramq' => $participant_names_and_ramq_key, 'initial_parsed_line' => $summary_label_see_line_and_file);
						} else if($excel_participants_names_and_ramq_controls[$identifier_value]['inital_names_and_ramq'] != $participant_names_and_ramq_key) {
							recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@ERROR@@', "The $identifier value is listed into more than one Excel line but the nominal data (names & 'RAMQ') of the new parsed line does not match data of a previous parsed line. No data of the new parsed Excel line will be migrated into ATiM.", "Please compare <b>$participant_names_and_ramq_key</b> and <b>".$excel_participants_names_and_ramq_controls[$identifier_value]['inital_names_and_ramq']."</b>. See $excel_file_name_for_summary plus ".$excel_participants_names_and_ramq_controls[$identifier_value]['initial_parsed_line'].".");
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
									recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@ERROR@@', "More than one ATiM participant matches a $excel_field value. No data of the Excel lines matching this $excel_field will be migrated into ATiM.", "See all lines with  '$excel_field' = '$excel_value'. See for example : $summary_label_participant_excel_nominal_data.");
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
									recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@ERROR@@', "Two different ATiM participants match the Excel participant identifiers ('RAMQ' and 'No de dossier'). No data of the Excel lines with these 2 identifiers will be migrated into ATiM.", "See the 2 ATiM 'Participant System Codes' : ".$matching_participants[0][0]['participant_id']." & ".$matching_participants[1][0]['participant_id'].". See for example : $summary_label_participant_excel_nominal_data.");
								}
							} else if(sizeof($matching_participants)) {
								//Match (on 1 identifier) : Set participant_id and names
								$matching_identifier = array_keys($matching_participants);
								$matching_identifier = array_shift($matching_identifier);
								$matching_participants = array_values($matching_participants);
								$excel_participants_to_atim_data[$excel_participants_to_atim_key]['participant_id'] = $matching_participants[0][0]['participant_id'];
								$excel_participants_to_atim_data[$excel_participants_to_atim_key]['first_name'] = $matching_participants[0][0]['first_name']; 
								$excel_participants_to_atim_data[$excel_participants_to_atim_key]['last_name'] = $matching_participants[0][0]['last_name'];
								recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@WARNING@@', "Participant matches based on only the $matching_identifier of the Excel line. Data of Excel file lines matching these $matching_identifier will be migrated into ATiM but please confirm match.", "See for example ATiM participant ".$matching_participants[0][0]['first_name']." ".$matching_participants[0][0]['last_name']." matching $summary_label_participant_excel_nominal_data.");
							} else {
								recordErrorAndMessage('Participant detection'." [FILE : $excel_file_name]", '@@ERROR@@', "No participant matches the Excel participant identifiers ('RAMQ' and/or 'No de dossier'). No data of the Excel lines matching these identifier values combination will be migrated into ATiM.", "See for example : $summary_label_participant_excel_nominal_data.");
							}
						}
					}
					
					// *** NEW STEP **************************************************************************************************************************************************************
					//	Find collection
					// ***************************************************************************************************************************************************************************
					
					if($excel_participants_to_atim_data[$excel_participants_to_atim_key]['participant_id']) {
						$participant_id = $excel_participants_to_atim_data[$excel_participants_to_atim_key]['participant_id'];
						if(!strlen($excel_line_data['Enumeration des blocs'])) {
							recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@MESSAGE@@', "Empty Block code (ex:A1). Block (plus collection and tissue) won't be created into ATiM.", "See  $summary_label_participant_excel_nominal_data.");
						} else if(!preg_match('/^((Congel)|([IV]{1,3}\-[A-Za-z]{1,3})|([A-Za-z]{1,3})|([IV]{1,3}\-[GD][0-9])|(I 4 NIV\.)|(CONG B[0-9])|(([A-Za-z]+)([0-9]+))|(([0-9]+)([A-Za-z]+))|(([A-Za-z]+)([0-9]+)([A-Za-z]+))|([0-9]+))$/', $excel_line_data['Enumeration des blocs'], $matches)) {
							recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@ERROR@@', "Wrong Block code format (ex:A1). Block (plus collection and tissue) won't be created into ATiM.", "See value [".$excel_line_data['Enumeration des blocs']."] of the $summary_label_participant_excel_nominal_data.");
						} else if(strtolower($excel_line_data['Enumeration des blocs']) == 'nul') {
							recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@MESSAGE@@', "Block code format equals 'NUL'. Block (plus collection and tissue) won't be created into ATiM.", "See value [".$excel_line_data['Enumeration des blocs']."] of the $summary_label_participant_excel_nominal_data.");
						} else {
							$sample_notes = array();
							//Get/format block data
							$excel_block_code = $excel_line_data['Enumeration des blocs'];
							$excel_block_prefix = $matches[1];
							$excel_collection_site = '';
							if(in_array($excel_line_data['Lieu du Prélèvement ND, SL, HD'], array('ND', 'SL', 'HD'))) {
								$excel_collection_site = str_replace(array('ND', 'SL', 'HD'), array('notre dame hospital', 'saint luc hospital', 'hotel dieu hospital'), $excel_line_data['Lieu du Prélèvement ND, SL, HD']);
							} else if(strlen($excel_line_data['Lieu du Prélèvement ND, SL, HD'])) {
								$sample_notes[] = "Tissue collection site = ".$excel_line_data['Lieu du Prélèvement ND, SL, HD'].".";
								recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "Wrong 'Lieu du Prélèvement ND, SL, HD' format. The value won't be recorded at collection but in tissue notes.", "See value [".$excel_line_data['Lieu du Prélèvement ND, SL, HD']."].", $excel_line_data['Lieu du Prélèvement ND, SL, HD']);
							}
							list($excel_collection_datetime, $excel_collection_datetime_accuracy) = validateAndGetDateAndAccuracy($excel_line_data['Date du prélèvement'], 'Block Definition', 'Date du prélèvement', "See $summary_label_participant_excel_nominal_data.");					
							if(!strlen($excel_collection_datetime)) recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "No collection date. Please confirm.", "See $summary_label_participant_excel_nominal_data.");
							$excel_no_patho = '';
							if(preg_match('/^[\']{0,1}([0-9A-Za-z\-]{2,100})$/', $excel_line_data['No Patho'], $matches)) {
								$excel_no_patho = $matches[1];
							} else {
								recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "Wrong pathology code format. The pathology code won't be recorded.", "See value [".$excel_line_data['No Patho']."] of the $summary_label_participant_excel_nominal_data.");
							}
							if(preg_match('/^200([3-9])/', $excel_collection_datetime, $matches)) {
								if(preg_match('/^'.$matches[1].'/', $excel_no_patho)) {
									recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "Added a 0 to the pathology code. Please confirm.", "Changed value [".$excel_no_patho."] to [0".$excel_no_patho."] for block colelcted on '$excel_collection_datetime' for the $summary_label_participant_excel_nominal_data.");
									$excel_no_patho = '0'.$excel_no_patho;
								}
							}
							
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
									AND ".(strlen($excel_collection_datetime)? "Collection.collection_datetime LIKE '$excel_collection_datetime%'" : "Collection.collection_datetime LIKE '-1'")."
									AND ".(strlen($excel_collection_site)? "Collection.collection_site LIKE '$excel_collection_site'" : "TRUE")."
									AND ".(strlen($excel_no_patho)? "Collection.qc_nd_pathology_nbr LIKE '$excel_no_patho'" : "TRUE").";";
								$atim_data = getSelectQueryResult($query);
								if($atim_data) {
									$collection_id = $atim_data[0]['collection_id'];
									$matching_collections++;
								} else {
									$create_new_collection = true;
									if(strlen($excel_no_patho)) {
										//Check collection exists or not
										$query = "SELECT DISTINCT
											Collection.id collection_id,
											Collection.collection_datetime,
											Collection.collection_datetime_accuracy,
											Collection.collection_site,
											Collection.qc_nd_pathology_nbr,
											Collection.collection_notes,
											Collection.diagnosis_master_id,
											Collection.consent_master_id,
											Collection.treatment_master_id,
											Collection.event_master_id
											FROM collections Collection
											INNER JOIN sample_masters SampleMaster ON Collection.id = SampleMaster.collection_id
											INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
											INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
											WHERE Collection.deleted <> 1
											AND SampleMaster.deleted <> 1
											AND Collection.bank_id = $excel_bank_id
											AND Collection.participant_id = $participant_id
											AND Collection.qc_nd_pathology_nbr LIKE '$excel_no_patho';";
										$atim_data = getSelectQueryResult($query);
										if($atim_data) {
											//Compare data
											if((strlen($excel_collection_datetime) && strlen($atim_data[0]['collection_datetime']) && $atim_data[0]['collection_datetime'] != $excel_collection_datetime)
											|| (strlen($excel_collection_site) && strlen($atim_data[0]['collection_site']) && $atim_data[0]['collection_site'] != $excel_collection_site)) {
												// Diff on at least one value
												// Create a new one
												recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "Collection with same pathology number already exists into ATiM but either date or site are different. New collection will be created but please confirm.", "Collection with pathology nbr [$excel_no_patho] with date values [(ATiM)".$atim_data[0]['collection_datetime']." & (Excel)$excel_collection_datetime] and site values [(ATiM)".$atim_data[0]['collection_site']." & (Excel)$excel_collection_site] for the $summary_label_participant_excel_nominal_data.");
											} else {
												$create_new_collection = false;
												$data_to_update = array();
												$data_to_update_message = array();
												if(!strlen($atim_data[0]['collection_site']) && strlen($excel_collection_site)) {
													$data_to_update['collection_site'] = $excel_collection_site;
													$data_to_update_message[] = "Site = '$excel_collection_site'";
												}
												if(!strlen($atim_data[0]['collection_site']) && strlen($excel_collection_datetime)) {
													$data_to_update['collection_datetime'] = $excel_collection_datetime;
													$data_to_update['collection_datetime_accuracy'] = ($excel_collection_datetime_accuracy == 'c')? 'h' : $excel_collection_datetime_accuracy;
													$data_to_update_message[] = "Date = '$excel_collection_datetime'";
												}
												if($data_to_update) {
													recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@MESSAGE@@', "Used collection with same pathology number but updated missing data. Please confirm.", "Collection with pathology nbr [$excel_no_patho] with following data updated [".implode(' & ', $data_to_update)."] for the $summary_label_participant_excel_nominal_data.");
													updateTableData($atim_data[0]['collection_id'], array('collections' => $data_to_update));
												}
												$collection_id = $atim_data[0]['collection_id'];
												$matching_collections++;
											}
										}
									}
									if($create_new_collection) {
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
											$collection_data['collection_datetime_accuracy'] = ($excel_collection_datetime_accuracy == 'c')? 'h' : $excel_collection_datetime_accuracy;
										}
										$collection_id = customInsertRecord(array('collections' => $collection_data));
										$created_collections++;
									}
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
											
											
Attention si il y a un numéro de labo cela doit être 'n/a - 500056 n/a'	
Ou alors ne pas mettre de bank comme pour le fichier 1996-2006 Cas a retrouver selon etc.xls qui fait que des femmes sont dans la banque prostate
Il faut aussi vérifier si il n'y a pas une collection qui existe déjà avec le numéro de patho.... créer pour garder les numéro de patho
Attention Dorsi avait des dates de collection '1995' or dans SARDO on a la date exacte. Donc le match ne se fera pas.											
											
SELECT *
FROM collections 
WHERE acquisition_label LIKE "Created by system to keep 'Patho Identifier'" 
AND created_by = @patho_collection_created_by 
AND deleted <> 1;
											
											
											
											
											
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
							setStorageData($aliquot_data, $excel_line_data, $aliquot_label, $summary_label_participant_excel_nominal_data, $excel_file_name);					
							$aliquot_master_id = customInsertRecord($aliquot_data);
							$created_blocks++;
						}
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
//if($is_test_process) addViewUpdate($final_queries);
foreach($final_queries as $new_query) customQuery($new_query);

recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$matching_collections ATiM collections used");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$created_collections collections created");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$created_tissues tissues samples created");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$created_blocks aliquots created");
recordErrorAndMessage('Block Creation'." [FILE : $excel_file_name]", '@@WARNING@@', "Number of created/used elements.", "$created_storages storages created");

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

function setStorageData(&$aliquot_data, $excel_line_data, $aliquot_label, $summary_label_participant_excel_nominal_data, $excel_file_name) {
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
			recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@WARNING@@', "Position information is missing: See '$excel_field' value. The position of the block won't be set.", "See block [$aliquot_label] of the $summary_label_participant_excel_nominal_data.");
			return;
		}
		if($storage_type == 'position' && !preg_match('/^[1-8]$/', $storage_value)) {
			recordErrorAndMessage('Block Definition'." [FILE : $excel_file_name]", '@@ERROR@@', "Block position is wrong: See '$excel_field' value. The position of the block won't be set.", "See block [$aliquot_label] and position [$storage_value] of the $summary_label_participant_excel_nominal_data.");
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
					$storages[$selection_label] = $atim_data[0]['id'];
					$previous_storage_master_id = $atim_data[0]['id'];
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

function addViewUpdate(&$final_queries) {/*
$final_queries[] = "UPDATE versions SET permissions_regenerated = 0;";
$final_queries[] = "SET @created = (SELECT created FROM aliquot_masters ORDER by id DESC LIMIT 0,1);";	
$final_queries[] = 'INSERT INTO view_collections(	
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
Collection.visit_label AS visit_label,
Collection.qc_nd_pathology_nbr,
TreatmentDetail.patho_nbr as qc_nd_pathology_nbr_from_sardo
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
LEFT JOIN banks As Bank ON Collection.bank_id = Bank.id AND Bank.deleted <> 1
LEFT JOIN misc_identifiers AS MiscIdentifier on MiscIdentifier.misc_identifier_control_id = Bank.misc_identifier_control_id AND MiscIdentifier.participant_id = Participant.id AND MiscIdentifier.deleted <> 1
LEFT JOIN misc_identifier_controls AS MiscIdentifierControl ON MiscIdentifier.misc_identifier_control_id=MiscIdentifierControl.id
LEFT JOIN treatment_masters AS TreatmentMaster ON TreatmentMaster.id = Collection.treatment_master_id AND TreatmentMaster.deleted <> 1
LEFT JOIN qc_nd_txd_sardos AS TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
			WHERE Collection.deleted <> 1 AND (Collection.created = @created OR Collection.modified = @created));';
	
$final_queries[] = 'INSERT INTO view_samples(	
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
		WHERE SampleMaster.deleted != 1 AND (SampleMaster.created = @created OR SampleMaster.modified = @created));';

$final_queries[] = 'INSERT INTO view_aliquots(	
	SELECT
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
AliquotMaster.in_stock_detail,
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
			WHERE AliquotMaster.deleted != 1 AND (AliquotMaster.modified = @created OR AliquotMaster.created = @created));';
	
$final_queries[] = 'INSERT INTO view_storage_masters (	
	SELECT StorageMaster.*, 
		StorageControl.is_tma_block,
		IF(coord_x_size IS NULL AND coord_y_size IS NULL, NULL, IFNULL(coord_x_size, 1) * IFNULL(coord_y_size, 1) - COUNT(AliquotMaster.id) - COUNT(TmaSlide.id) - COUNT(ChildStorageMaster.id)) AS empty_spaces 
		FROM storage_masters AS StorageMaster
		INNER JOIN storage_controls AS StorageControl ON StorageMaster.storage_control_id=StorageControl.id
		LEFT JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.storage_master_id=StorageMaster.id AND AliquotMaster.deleted=0
		LEFT JOIN tma_slides AS TmaSlide ON TmaSlide.storage_master_id=StorageMaster.id AND TmaSlide.deleted=0
		LEFT JOIN storage_masters AS ChildStorageMaster ON ChildStorageMaster.parent_id=StorageMaster.id AND ChildStorageMaster.deleted=0
		WHERE StorageMaster.deleted=0 AND (StorageMaster.modified = @created OR StorageMaster.created = @created) GROUP BY StorageMaster.id);';*/
}
	
?>
		