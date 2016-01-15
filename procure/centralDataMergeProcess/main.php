<?php

require_once 'system.php';
require_once 'config.php';

//**********************************************************************************************************************************************************************************************
//
// DATABASE CONNECTIONS AND TESTS
//
//**********************************************************************************************************************************************************************************************

connectToCentralDatabase();

$bank_databases = array(
	'chum' => $db_chum_schemas,
	'chuq' => $db_chuq_schemas,
	'chus' => $db_chus_schemas,
	'cusm' => $db_cusm_schemas
);
foreach($bank_databases as $site => $db_schema) {
	if(!testDbSchemas($db_schema, $site)) $bank_databases[$site] = null;
}

if(!testDbSchemas($db_processing_schemas, 'processing site')) $db_processing_schemas = null;;

selectCentralDatabase();

//**********************************************************************************************************************************************************************************************
//**********************************************************************************************************************************************************************************************

displayMergeTitle('PROCURE CENTRAL ATIM : Data Sites Merge Process');

$track_queries = true;

//**********************************************************************************************************************************************************************************************
//
// LOAD AND TESTS THE ATiM CONTROLS TABLES CONTENT
//
// 1- Main Controls Table ('consent_controls', 'event_controls', 'treatment_controls', 'sample_controls', 'aliquot_controls', 'specimen_review_controls', 'aliquot_review_controls'):
//    - Compare the content of all of them to validate id and detail_tablename are similar.
//
// 2- MiscIdentifierControl :
//    - Just Import 'participant study number' from processing site.
//    - So no control done at this level.
//
// 3- StorageControl:
//    - Will importe the storage_controls data of each bank and site
//    - Will all be recorded as different storage type.
//    - So no control done at this level.
//
//**********************************************************************************************************************************************************************************************

$sites_atim_controls = array();
foreach(array_merge(array('central' => $db_central_schemas, 'processing site' => $db_processing_schemas), $bank_databases) as $bank_site => $db_schema) {
	if($db_schema) $sites_atim_controls[$bank_site] = getControls($db_schema);
}

$control_data_mismatch_detected = false;
$matching_control_table_names = array(
	'consent_controls', 
	'event_controls', 
	'treatment_controls', 
	'sample_controls',
	'aliquot_controls', 
	'specimen_review_controls', 
	'aliquot_review_controls');
foreach($sites_atim_controls as $bank_site => $site_atim_controls) {
	if($bank_site != 'central') {
		foreach($site_atim_controls as $control_table_name => $table_atim_controls) {
			//New Control Table
			if(in_array($control_table_name, $matching_control_table_names)) {
				foreach($table_atim_controls as $atim_control_type => $atim_control_data) {
					if($atim_control_type != '***id_to_type***') {
						//Content of these control table should be identical
						if(!array_key_exists($atim_control_type, $sites_atim_controls['central'][$control_table_name])) {
							//Control does not exist into ATiM Central
							recordErrorAndMessage('ATiM Controls Data Check', '@@ERROR@@', "Missing control table in central bank", "The $control_table_name control '$atim_control_type' of site $bank_site is missing into central.");
							$control_data_mismatch_detected = false;
						} else {
							$diff1 = array_diff_assoc($sites_atim_controls['central'][$control_table_name][$atim_control_type], $atim_control_data);
							$diff2 = array_diff_assoc($atim_control_data, $sites_atim_controls['central'][$control_table_name][$atim_control_type]);
							if($diff1 || $diff2) {
								//The data of a control are different into central and the studied bank or site (check id, detail_tablename, etc)
								$field_messages = array();
								foreach($diff1 as $field => $value) {
									$field_messages[] = " $field [$value !=  ".$diff2[$field]."]";
								}
								recordErrorAndMessage('ATiM Controls Data Check', '@@ERROR@@', "Control '$control_table_name' data not compatible", "Following fields values are different in [the 'central' ATiM database and the '$bank_site' ATiM database : ".implode(' & ', $field_messages));
								$control_data_mismatch_detected = false;
							}
						}
					}
				}
			}
		}
	}
}
if($control_data_mismatch_detected) {
//TODO à afficher dans le résumé....
	recordErrorAndMessage('Merge Information', '@@ERROR@@', "Merge Process Aborted", "The data control values are not compatible.");
	dislayErrorAndMessage(false);
	mergeDie("ERR_CONTROLS_UNCOMPATIBLE_DETECTED (please see summary).");
}

//**********************************************************************************************************************************************************************************************
//
// POPULATE CENTRAL DATABASE
//
//**********************************************************************************************************************************************************************************************

//==============================================================================================
// 1 - Delete central database data
//==============================================================================================

$tables_to_truncate = array();

//Inventory
foreach($sites_atim_controls['central']['specimen_review_controls'] as $control_type => $control_data) {
	if(isset($control_data['detail_tablename'])) $tables_to_truncate[$control_data['detail_tablename']] = $control_data['detail_tablename'];
	if(isset($control_data['aliquot_review_detail_tablename'])) $tables_to_truncate[$control_data['aliquot_review_detail_tablename']] = $control_data['aliquot_review_detail_tablename'];
}
$tables_to_truncate[] = 'aliquot_review_masters';
$tables_to_truncate[] = 'specimen_review_masters';
$tables_to_truncate[] = 'realiquotings';
$tables_to_truncate[] = 'source_aliquots';
$tables_to_truncate[] = 'aliquot_internal_uses';
$tables_to_truncate[] = 'quality_ctrls';
foreach($sites_atim_controls['central']['aliquot_controls'] as $control_type => $control_data) if(isset($control_data['detail_tablename'])) $tables_to_truncate[$control_data['detail_tablename']] = $control_data['detail_tablename'];
$tables_to_truncate[] = 'aliquot_masters';
$tables_to_truncate[] = 'aliquot_masters_revs';
foreach($sites_atim_controls['central']['sample_controls'] as $control_type => $control_data) if(isset($control_data['detail_tablename'])) $tables_to_truncate[$control_data['detail_tablename']] = $control_data['detail_tablename'];
$tables_to_truncate[] = 'derivative_details';
$tables_to_truncate[] = 'specimen_details';
$tables_to_truncate[] = 'sample_masters';
$tables_to_truncate[] = 'collections';
//ClinicalAnnotation
foreach($sites_atim_controls['central']['treatment_controls'] as $control_type => $control_data) $tables_to_truncate[$control_data['detail_tablename']] = $control_data['detail_tablename'];
$tables_to_truncate[] = 'treatment_masters';
$tables_to_truncate[] = 'drugs';
foreach($sites_atim_controls['central']['event_controls'] as $control_type => $control_data) $tables_to_truncate[$control_data['detail_tablename']] = $control_data['detail_tablename'];
$tables_to_truncate[] = 'event_masters';
foreach($sites_atim_controls['central']['consent_controls'] as $control_type => $control_data) $tables_to_truncate[$control_data['detail_tablename']] = $control_data['detail_tablename'];
$tables_to_truncate[] = 'consent_masters';
$tables_to_truncate[] = 'participants';
//StorageLayout
foreach($sites_atim_controls['central']['storage_controls'] as $control_type => $control_data) $tables_to_truncate[$control_data['detail_tablename']] = $control_data['detail_tablename'];
$tables_to_truncate[] = 'storage_masters';
$tables_to_truncate[] = 'storage_masters_revs';
$tables_to_truncate[] = 'storage_controls';
//Orders
$tables_to_truncate[] = 'order_items';
$tables_to_truncate[] = 'shipments';
$tables_to_truncate[] = 'order_lines';
$tables_to_truncate[] = 'orders';
//Study
$tables_to_truncate[] = 'study_summaries';
//...
$structure_permissible_values_custom_control_names = array(
		'Aliquot Use and Event Types',
		'Consent Form Versions',
		'Laboratory Sites',
		'Laboratory Staff',
		'Questionnaire version date',
		'Radiotherapy Sites',
		'Shipping Conditions',
		'Storage Coordinate Titles',
		'Storage Coordinate Titles');
$all_queries = array(
	"UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null",
	"UPDATE storage_masters SET parent_id = null",
	"DELETE FROM structure_permissible_values_customs WHERE control_id IN (SELECT id FROM structure_permissible_values_custom_controls WHERE name IN ('".implode("','",$structure_permissible_values_custom_control_names)."'))",
	"DELETE FROM structure_permissible_values_customs WHERE control_id IN (SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types')"
);
foreach($tables_to_truncate as $new_table) $all_queries[] = "DELETE FROM $new_table";
foreach($all_queries as $new_query) customQuery($new_query);

//==============================================================================================
// 2- Import Data From The 4 Banks (Collection Sites)
//==============================================================================================

global $populated_tables_information;
$populated_tables_information = array();

foreach($bank_databases as $bank => $bank_schema) {
	if(!in_array($bank, array('processsing', 'central')) && $bank_schema) {
		//New bank
		
		// I - PARTICIPANTS
		
		magicSelectInsert($bank_schema, 'participants');
		
		// II - IDENTIFIERS
		
		//No Identifier will come from sites
		
		// III - CONSENTS
		
		magicSelectInsert($bank_schema, 'consent_masters', array('participant_id' => 'participants'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['consent_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($bank_schema, $detail_table_name, array('consent_master_id' => 'consent_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
		}
		
		// IV - EVENTS
		
		magicSelectInsert($bank_schema, 'event_masters', array('participant_id' => 'participants'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['event_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($bank_schema, $detail_table_name, array('event_master_id' => 'event_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
		}
	
		// IV - TREATMENTS & DRUGS
		
		//Drugs
		magicSelectInsert($bank_schema, 'drugs', array());
		//Treatment masters
		magicSelectInsert($bank_schema, 'treatment_masters', array('participant_id' => 'participants'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['treatment_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($bank_schema, $detail_table_name, array('treatment_master_id' => 'treatment_masters', 'drug_id' => 'drugs'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
		}
		
		// V - COLLECTION
		
		magicSelectInsert($bank_schema, 'collections', array('participant_id' => 'participants'));
		
		// VI - SAMPLE
		
		//Sample masters
		magicSelectInsert($bank_schema, 'sample_masters', array('initial_specimen_sample_id' => 'sample_masters', 'parent_id' => 'sample_masters', 'collection_id' => 'collections'), array('sample_code' => "CONCAT('$bank#',sample_code)"));
		//SpecimenDetails & DerivativeDetails
		foreach(array('specimen_details', 'derivative_details') as $table_name) magicSelectInsert($bank_schema, $table_name, array('sample_master_id' => 'sample_masters'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['sample_controls'] as $control_type => $control_data) {
			if($control_type != '***id_to_type***') {
				$detail_table_name = $control_data['detail_tablename'];
				if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
					magicSelectInsert($bank_schema, $detail_table_name, array('sample_master_id' => 'sample_masters'));
					$detail_table_names_already_imported[] = $detail_table_name;
				}
			}
		}
		
		// VII - STORAGE
		
		//Controls
		magicSelectInsert($bank_schema, 'storage_controls', array(), array('storage_type' => "CONCAT(storage_type,' [$bank]')"));
		$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types'");
		if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_STORAGE_TYPE_VALUES_CONTROL');
		$atim_control_id = $atim_control_id['0']['id'];
		$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id)
			(SELECT CONCAT(value,' [$bank]'), IF(en = '', '', CONCAT(en,' [$bank]')), IF(fr = '', '', CONCAT(fr,' [$bank]')), use_as_input, $atim_control_id
			FROM $bank_schema.structure_permissible_values_custom_controls ctrl INNER JOIN $bank_schema.structure_permissible_values_customs val ON val.control_id = ctrl.id
			WHERE ctrl.name = 'Storage Types')";
		customQuery($query);
		//StorageMasters
		customQuery("SET FOREIGN_KEY_CHECKS=0;");	//StorageMaster.parent_id can make reference to a storage created later in the past (The StorageMaster.parent_id of the record will be bigger than StorageMaster.id of the same record)
		magicSelectInsert($bank_schema, 'storage_masters', array('storage_control_id' => 'storage_controls', 'parent_id' => 'storage_masters'),  array('code' => "CONCAT('$bank#',code)"));
		customQuery("SET FOREIGN_KEY_CHECKS=1;");
		//Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls[$bank]['storage_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($bank_schema, $detail_table_name, array('storage_master_id' => 'storage_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
		}
		//StorageMastersRevs
		magicSelectInsert($bank_schema, 'storage_masters_revs', array('id' => 'storage_masters', 'storage_control_id' => 'storage_controls', 'parent_id' => 'storage_masters'));
		
		// VIII - Aliquot

		// Aliquot masters
		magicSelectInsert($bank_schema, 'aliquot_masters', array('collection_id' => 'collections', 'sample_master_id' => 'sample_masters', 'storage_master_id' => 'storage_masters'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['aliquot_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($bank_schema, $detail_table_name, array('aliquot_master_id' => 'aliquot_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
		}
		//AliquotMastersRevs
		magicSelectInsert($bank_schema, 'aliquot_masters_revs', array('id' => 'aliquot_masters', 'collection_id' => 'collections', 'sample_master_id' => 'sample_masters', 'storage_master_id' => 'storage_masters'));
		// Realiquoting
		magicSelectInsert($bank_schema, 'realiquotings', array('parent_aliquot_master_id' => 'aliquot_masters', 'child_aliquot_master_id' => 'aliquot_masters'));
		// Source Aliquot
		magicSelectInsert($bank_schema, 'source_aliquots', array('sample_master_id' => 'sample_masters', 'aliquot_master_id' => 'aliquot_masters'));
		// Aliquot Internal Uses
		magicSelectInsert($bank_schema, 'aliquot_internal_uses', array('aliquot_master_id' => 'aliquot_masters'));

		// IX - QUALITY CONTROL
		
		magicSelectInsert($bank_schema, 'quality_ctrls', array('sample_master_id' => 'sample_masters', 'aliquot_master_id' => 'aliquot_masters'));
		
		// X - Path Review
		
		magicSelectInsert($bank_schema, 'specimen_review_masters', array('collection_id' => 'collections', 'sample_master_id' => 'sample_masters'), array('review_code' => "CONCAT('$bank#',review_code)"));
		magicSelectInsert($bank_schema, 'aliquot_review_masters', array('specimen_review_master_id' => 'specimen_review_masters', 'aliquot_master_id' => 'aliquot_masters'), array('review_code' => "CONCAT('$bank#',review_code)"));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['specimen_review_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($bank_schema, $detail_table_name, array('specimen_review_master_id' => 'specimen_review_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
			$aliquot_review_detail_table_name = $control_data['aliquot_review_detail_tablename'];
			if(!in_array($aliquot_review_detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($bank_schema, $aliquot_review_detail_table_name, array('aliquot_review_master_id' => 'aliquot_review_masters'));
				$detail_table_names_already_imported[] = $aliquot_review_detail_table_name;
			}
		}	
		
		// End of bank data import : Get max value of each primary key
		
		regenerateTablesInformation();
	}
}

// Merge duplicated drugs

$query = "SELECT ids, generic_name, type, procure_study 
	FROM (
		SELECT GROUP_CONCAT(id) AS ids, generic_name, type, procure_study 
		FROM (
			SELECT id, LOWER(TRIM(generic_name)) AS generic_name, type, procure_study FROM drugs WHERE deleted <> 1	
		) res_level1 GROUP BY generic_name, type, procure_study
	)res_level2 WHERE ids LIKE '%,%';";
$duplicated_drug_data = getSelectQueryResult($query);
$matching_drug_ids = array();
foreach($duplicated_drug_data as $new_duplicated_drug_data) {
	$drug_ids = explode(',', $new_duplicated_drug_data['ids']);
	$main_drug_id = $drug_ids[0];
	unset($drug_ids[0]);
	$duplicated_drug_ids = implode(',',$drug_ids);
	$matching_drug_ids[$main_drug_id] = $duplicated_drug_ids;
}
$drug_ids_to_delete = array();
foreach($populated_tables_information as $table_name => $populated_table_data) {
	if(in_array('drug_id', $populated_table_data['fields'])) {
		foreach($matching_drug_ids as $main_drug_id => $duplicated_drug_ids) {
			customQuery("UPDATE $table_name SET drug_id = $main_drug_id WHERE drug_id IN ($duplicated_drug_ids)");
			$drug_ids_to_delete[] = $duplicated_drug_ids;
		}
	}
}
if($drug_ids_to_delete) customQuery("DELETE FROM drugs WHERE id IN (".implode(',', $drug_ids_to_delete).")");

// Merge duplicated patient

$query = "SELECT ids, participant_identifier
	FROM (
		SELECT GROUP_CONCAT(id) AS ids, participant_identifier
		FROM participants
		WHERE deleted <> 1
		GROUP BY participant_identifier
	)res_level1 WHERE ids LIKE '%,%';";
$duplicated_participants = getSelectQueryResult($query);
$matching_participant_ids = array();
foreach($duplicated_participants as $new_duplicated_participants_data) {
	$participant_identifier = $new_duplicated_participants_data['participant_identifier'];
	//Merge participants having the same identifier
	//  - Get all of them
	//  - Keep the last one modified
	//  - Track data mismatches
	$query = "SELECT * from participants WHERE participant_identifier = '$participant_identifier' AND deleted <> 1 ORDER BY modified DESC";
	$participants_data = getSelectQueryResult($query);
	$participants_data_to_display = $participants_data[0];
	unset($participants_data[0]);
	$participants_banks = array($participants_data_to_display['procure_last_modification_by_bank']);
	$all_notes_to_merge = strlen($participants_data_to_display['notes'])? array($participants_data_to_display['notes']) : array();
	$check_all_flagged_as_transferred = ($participants_data_to_display['procure_transferred_participant'] == 'y')? true : false;
	$check_all_data_similar = true;
	foreach($participants_data as $duplicated_participant) {
		$matching_participant_ids[$participants_data_to_display['id']][] = $duplicated_participant['id'];
		$participants_banks[] = $duplicated_participant['procure_last_modification_by_bank'];
		if(strlen($duplicated_participant['notes'])) $all_notes_to_merge[] = $duplicated_participant['notes'];
		if($duplicated_participant['procure_transferred_participant'] != 'y') $check_all_flagged_as_transferred = false;
		foreach(array('date_of_birth', 'vital_status', 'date_of_death', 'procure_cause_of_death', 'procure_patient_withdrawn', 'procure_patient_withdrawn_date', 'procure_patient_withdrawn_reason') as $studied_field) {
			if($participants_data_to_display[$studied_field] !== $duplicated_participant[$studied_field]) $check_all_data_similar = false;
		}
	}
	$matching_participant_ids[$participants_data_to_display['id']] = implode(',', $matching_participant_ids[$participants_data_to_display['id']]);
	$participants_banks = implode(', ', $participants_banks);
	//Update notes
	$all_notes_to_merge[] = "Participant followed by banks : $participants_banks.";
	$query = "UPDATE participants SET notes = '".str_replace("'", "''", implode(' ',$all_notes_to_merge))."' WHERE id = ".$participants_data_to_display['id'];
	customQuery($query);
	//Record merge process message
	recordErrorAndMessage('Participants', '@@MESSAGE@@', "Transferred participant", "Participant $participant_identifier is recorded into more than one bank (see banks $participants_banks). All data of the participants will be merged and linked to the last modified participant profile.");
	if(!$check_all_flagged_as_transferred) recordErrorAndMessage('Participants', '@@WARNING@@', "Participant not flagged as 'Transferred Participant'", "At least one bank did not flagged participant $participant_identifier as 'Transferred Participant' (see banks $participants_banks). Please validate with banks.");
	if(!$check_all_data_similar) recordErrorAndMessage('Participants', '@@WARNING@@', "'Transferred Participant' data mismatches", "The profile data of at least one 'Transferred Participant' with identifier $participant_identifier does not match the data of the other sites (see banks $participants_banks). Please validate with banks.");
}
$participant_ids_to_delete = array();
$merged_participant_ids = array();
foreach($populated_tables_information as $table_name => $populated_table_data) {
	if(in_array('participant_id', $populated_table_data['fields'])) {
		foreach($matching_participant_ids as $main_participant_id => $duplicated_participant_ids) {
			customQuery("UPDATE $table_name SET participant_id = $main_participant_id WHERE participant_id IN ($duplicated_participant_ids)");
			$participant_ids_to_delete[] = $duplicated_participant_ids;
			$merged_participant_ids[] = $main_participant_id;
			$merged_participant_ids[] = $duplicated_participant_ids;
		}
	}
}
if($participant_ids_to_delete) customQuery("DELETE FROM participants WHERE id IN (".implode(',', $participant_ids_to_delete).")");
//Check no participant foiund in only one bank is flagged as 'Transferred participant'
$query = "SELECT GROUP_CONCAT(participant_identifier) AS participant_identifiers FROM participants WHERE deleted <> 1 AND procure_transferred_participant = 'y' AND id NOT IN (".implode(',', $merged_participant_ids).")";
$participants_list = getSelectQueryResult($query);
if($participants_list && isset($participants_list[0]['participant_identifiers'])) recordErrorAndMessage('Participants', '@@WARNING@@', "Transferred participant listed in only one bank", "Following participants are flagged as 'Transferred Participant' but are not found in more than one bank  (see ".$participants_list[0]['participant_identifiers']."). Please validate with banks.");

//==============================================================================================
// 3- Import Data From Processing Site
//==============================================================================================

//TODO penser a mettre le procure_participant_attribution_number dans participants
//TODO verifier que patient existe bien dans banque
//TODO verifier que aliquot source existe bien dans banque

//==============================================================================================
// 4- Final data Import
//==============================================================================================

// Add data to structure_permissible_values_custom_controls

foreach(array_merge(array('processing site' => $db_processing_schemas), $bank_databases) as $bank_site => $db_schema) {
	foreach($structure_permissible_values_custom_control_names as $control_name) {
		$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = '$control_name'");
		if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_VALUES_CONTROL::'.$control_name);
		$atim_control_id = $atim_control_id['0']['id'];
		$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id)
			(SELECT site_val.value, site_val.en, site_val.fr, site_val.use_as_input, $atim_control_id
			FROM $db_schema.structure_permissible_values_custom_controls site_ctrl
			INNER JOIN $db_schema.structure_permissible_values_customs site_val ON site_val.control_id = site_ctrl.id
			WHERE site_ctrl.name = '$control_name'
			AND site_val.value NOT IN (
					SELECT central_val.value
					FROM structure_permissible_values_custom_controls central_ctrl
					INNER JOIN structure_permissible_values_customs central_val ON central_val.control_id = central_ctrl.id
					WHERE central_ctrl.name = '$control_name'
			));";
		customQuery($query);
	}
}

// Check data integrity

foreach(array('consent_masters' => 'Consents', 'treatment_masters' => 'Treatments', 'event_masters' => 'Events') as $table_name => $data_type) {
	$query = "SELECT procure_created_by_banks, procure_form_identification
		FROM (
			SELECT GROUP_CONCAT(procure_created_by_bank) as procure_created_by_banks, procure_form_identification FROM $table_name WHERE deleted <> 1 AND procure_form_identification NOT LIKE '%Vx%' GROUP BY procure_form_identification
		) res WHERE procure_created_by_banks LIKE '%,%'
		ORDER BY procure_form_identification;";
	$duplicated_forms = getSelectQueryResult($query);
	foreach($duplicated_forms as $new_form_set) recordErrorAndMessage($data_type, '@@WARNING@@', "Form Identification Duplicated", "See '".$new_form_set['procure_form_identification']."' from banks '".$new_form_set['procure_created_by_banks']."'.");
}

$query = "SELECT procure_created_by_banks, barcode
	FROM (
		SELECT GROUP_CONCAT(procure_created_by_bank) as procure_created_by_banks, barcode FROM aliquot_masters WHERE deleted <> 1 GROUP BY barcode
	) res WHERE procure_created_by_banks LIKE '%,%'
	ORDER BY barcode;";
$duplicated_forms = getSelectQueryResult($query);
foreach($duplicated_forms as $new_form_set) recordErrorAndMessage('Aliquots', '@@WARNING@@', "Barcode Duplicated", "See aliquot '".$new_form_set['barcode']."' from banks '".$new_form_set['procure_created_by_banks']."'.");

//**********************************************************************************************************************************************************************************************
//
// FINAL PROCESSES
//
//**********************************************************************************************************************************************************************************************

// Add site as root to any storage 

$query = "INSERT INTO storage_controls (storage_type, display_x_size, display_y_size, reverse_x_numbering, reverse_y_numbering, horizontal_increment, set_temperature, is_tma_block, flag_active, detail_form_alias, detail_tablename, databrowser_label, check_conflicts) VALUES
	('site', 0, 0, 0, 0, 1, 1, 0, 1, 'std_rooms', 'std_rooms', 'custom#storage types#site', 1);";
$storage_control_id = customQuery($query, true);
$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types'");
if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_STORAGE_TYPE_VALUES_CONTROL');
$atim_control_id = $atim_control_id['0']['id'];
$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id) VALUES ('site', 'Site', 'Site', 1, $atim_control_id)";
customQuery($query);

foreach(array_merge(array('p'), array_keys($bank_databases)) as $bank_site) {
	$query = "INSERT INTO storage_masters (code,storage_control_id,short_label,created,created_by,modified,modified_by)  VALUES ('$bank_site', $storage_control_id, '$bank_site', '$import_date', $imported_by, '$import_date', $imported_by);";
	$storage_master_id = customQuery($query, true);
	$query = "INSERT INTO std_rooms (storage_master_id) VALUES ($storage_master_id);";
	customQuery($query, true);
	$query = "UPDATE storage_masters SET parent_id = $storage_master_id, modified = '$import_date', modified_by = $imported_by WHERE parent_id IS NULL AND code LIKE '$bank_site#%'";
	customQuery($query, true);
	//NOTE: Won't update revs table
}

updateStorageLftRghtAndLabel();

//TODO Effacer les batchset ids??

customQuery("UPDATE versions SET permissions_regenerated = 0");

dislayErrorAndMessage(true);

pr('<br>******************************************************************************************');
pr('PROCESS DONE');
pr('******************************************************************************************');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function magicSelectInsert($bank_schema, $table_name, $table_foreign_keys = array(), $specific_select_field_rules = array()) {
	$table_information = getTablesInformation($table_name);

	//Get fields of table
	$insert_table_fields = $select_table_fields = $table_information['fields'];
	
	//Check Primary Key exists and increment this one if required
	if($table_information['primary_key']) {
		$primary_key = $table_information['primary_key'];
		$key_id = array_search($primary_key, $select_table_fields);
		$select_table_fields[$key_id] = "($primary_key + ".$table_information['last_downloaded_bank_max_pk_value'].")";
	}
	
	//Increment foreign_key if required (or id in specific cases like revs table (table_revs.id ref table.id))
	foreach($table_foreign_keys as $field => $linked_table_name) {
		$key_id = array_search($field, $select_table_fields);
		if($key_id !== false) {
			$linked_table_information = getTablesInformation($linked_table_name);
			if(!$linked_table_information['primary_key']) mergeDie("ER_magicSelectInsert_001 (".$table_name.".".$field." to ".$linked_table_name.").");
			$select_table_fields[$key_id] = "(".$field." + ".$linked_table_information['last_downloaded_bank_max_pk_value'].")";
		} else {
			recordErrorAndMessage('Function magicSelectInsert() : Messages for administrator', '@@WARNING@@', 'Validate field of $table_foreign_keys does not exist into table', "Field $field is not a field of $table_name", $field.$table_name);
		}
	}
	
	//Add specific field import rule
	foreach($specific_select_field_rules as $field => $rule) {
		$key_id = array_search($field, $select_table_fields);
		if($key_id === false) mergeDie("ER_magicSelectInsert_002 (".$table_name.".".$field.").");
		$select_table_fields[$key_id] = "($rule)";
	}
	
	//Select & Insert
	$query = "INSERT INTO $table_name (".implode(',',$insert_table_fields).") (SELECT ".implode(',',$select_table_fields)." FROM ".$bank_schema.".$table_name)";
	customQuery($query);	
}

function getTablesInformation($table_name) {
	global $populated_tables_information;
	
	if(!isset($populated_tables_information[$table_name])) {
		//First bank downloaded: Get fields and set previous max id to 0
		$table_fields = array();
		$primary_key = null;
		foreach(getSelectQueryResult("SHOW columns FROM $table_name;") as $new_field_data) {
			$table_fields[] = $new_field_data['Field'];
			if($new_field_data['Key'] == 'PRI') $primary_key = $new_field_data['Field'];
		}
		$populated_tables_information[$table_name] = array(
			'fields' => $table_fields, 
			'primary_key' => $primary_key,
			'last_downloaded_bank_max_pk_value' => strlen($primary_key)? 0 : null);
	}
	return $populated_tables_information[$table_name];
}

function regenerateTablesInformation() {
	global $populated_tables_information;
	
	foreach($populated_tables_information as $table_name => $table_information) {
		if($table_information['primary_key']) {
			//Get the last primarey key value (max()) recorded into this table
			$atim_table_data = getSelectQueryResult("SELECT MAX(".$table_information['primary_key'].") AS max_record_id FROM $table_name");
			$populated_tables_information[$table_name]['last_downloaded_bank_max_pk_value'] = ($atim_table_data && $atim_table_data['0']['max_record_id'])? $atim_table_data['0']['max_record_id'] : 0;
		}
	}
}

function updateStorageLftRghtAndLabel() {
	$lft_rght_id = 0;
	foreach(getSelectQueryResult("SELECT id, short_label FROM storage_masters WHERE deleted <> 1 AND (parent_id IS NULL OR parent_id LIKE '')") as $new_storage) {
		$storage_master_id = $new_storage['id'];
		$short_label= $new_storage['short_label'];
		$lft_rght_id++;
		$lft = $lft_rght_id;
		updateChildrenStorageLftRghtAndLabel($storage_master_id, $lft_rght_id,$short_label);
		$lft_rght_id++;
		$rght = $lft_rght_id;
		customQuery("UPDATE storage_masters SET lft = '$lft', rght = '$rght', selection_label = '".str_replace("'","''",$short_label)."' WHERE id = $storage_master_id");
	}
}

function updateChildrenStorageLftRghtAndLabel($parent_id, &$lft_rght_id, $parent_selection_label) {
	foreach(getSelectQueryResult("SELECT id, short_label FROM storage_masters WHERE deleted <> 1 AND parent_id = $parent_id") as $new_storage) {
		$storage_master_id = $new_storage['id'];
		$short_label= $new_storage['short_label'];
		$selection_label = $parent_selection_label.'-'.$short_label;
		$lft_rght_id++;
		$lft = $lft_rght_id;
		updateChildrenStorageLftRghtAndLabel($storage_master_id, $lft_rght_id, $selection_label);
		$lft_rght_id++;
		$rght = $lft_rght_id;
		customQuery("UPDATE storage_masters SET lft = '$lft', rght = '$rght', selection_label = '".str_replace("'","''",$selection_label)."' WHERE id = $storage_master_id");
	}
	return;
}

?>
		