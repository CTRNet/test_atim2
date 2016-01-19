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
// VARIOUS ACTIONS & VARIABLES 
//**********************************************************************************************************************************************************************************************

displayMergeTitle('PROCURE CENTRAL ATIM : Data Sites Merge Process');

$track_queries = true;

$sites_to_sitecodes = array(
	'chum' => 'ps1',
	'chuq' => 'ps2',
	'chus' => 'ps4',
	'cusm' => 'ps3',
	'processing site' => 'psp'
);

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
//    - Will import the storage_controls data of each bank and site
//    -  all be recorded as different storage type.
//    - So no control done at this level.
//
//**********************************************************************************************************************************************************************************************

$sites_atim_controls = array();
foreach(array_merge(array('central' => $db_central_schemas, 'processing site' => $db_processing_schemas), $bank_databases) as $bank_site => $db_schema) {
	if($db_schema) $sites_atim_controls[$bank_site] = getControls($db_schema);
}
$matching_control_table_names = array(
	'consent_controls', 
	'event_controls', 
	'treatment_controls', 
	'sample_controls',
	'aliquot_controls', 
	'specimen_review_controls', 
	'aliquot_review_controls');
$control_data_mismatch_detected = false;
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
//TODO: à afficher dans le résumé....
	recordErrorAndMessage('Merge Information', '@@ERROR@@', "Merge Process Aborted", "The data control values are not compatible.");
	dislayErrorAndMessage(false);
	mergeDie("ERR_CONTROLS_MISMATCHES_DETECTED (please see summary).");
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

//Orders
$tables_to_truncate[] = 'order_items';
$tables_to_truncate[] = 'shipments';
$tables_to_truncate[] = 'order_lines';
$tables_to_truncate[] = 'orders';
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
$tables_to_truncate[] = 'misc_identifiers';
$tables_to_truncate[] = 'misc_identifier_controls';
$tables_to_truncate[] = 'participants';
//StorageLayout
foreach($sites_atim_controls['central']['storage_controls'] as $control_type => $control_data) $tables_to_truncate[$control_data['detail_tablename']] = $control_data['detail_tablename'];
$tables_to_truncate[] = 'storage_masters';
$tables_to_truncate[] = 'storage_masters_revs';
$tables_to_truncate[] = 'storage_controls';
//Study
$tables_to_truncate[] = 'study_summaries';
//...
$tables_to_truncate[] = 'datamart_batch_ids';
$tables_to_truncate[] = 'datamart_batch_sets';
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
// 2- Import Data From The 4 Banks (Collection Sites) + Processing Site
//==============================================================================================

global $populated_tables_information;
$populated_tables_information = array();

foreach(array_merge(array('processing site' => $db_processing_schemas), $bank_databases) as $site => $site_schema) {
	//New Bank or Processing Site
	$site_code = $sites_to_sitecodes[$site];
	if($site_schema) {
		
		// I - STUDY
		
		if($site == 'processing site') magicSelectInsert($site_schema, 'study_summaries');
		
		// II - PARTICIPANTS
		
		magicSelectInsert($site_schema, 'participants');
		
		// III - IDENTIFIERS
		
		if($site == 'processing site') {
			magicSelectInsert($site_schema, 'misc_identifier_controls');
			magicSelectInsert($site_schema, 'misc_identifiers', array('participant_id' => 'participants', 'study_summary_id' => 'study_summaries', 'misc_identifier_control_id' => 'misc_identifier_controls'));			
		}
		
		if($site != 'processing site') {
			
			// IV - CONSENTS
			
			magicSelectInsert($site_schema, 'consent_masters', array('participant_id' => 'participants'));
			// Detail
			$detail_table_names_already_imported = array();
			foreach($sites_atim_controls['central']['consent_controls'] as $control_type => $control_data) {
				$detail_table_name = $control_data['detail_tablename'];
				if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
					magicSelectInsert($site_schema, $detail_table_name, array('consent_master_id' => 'consent_masters'));
					$detail_table_names_already_imported[] = $detail_table_name;
				}
			}
			
			// V - EVENTS
			
			magicSelectInsert($site_schema, 'event_masters', array('participant_id' => 'participants'));
			// Detail
			$detail_table_names_already_imported = array();
			foreach($sites_atim_controls['central']['event_controls'] as $control_type => $control_data) {
				$detail_table_name = $control_data['detail_tablename'];
				if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
					magicSelectInsert($site_schema, $detail_table_name, array('event_master_id' => 'event_masters'));
					$detail_table_names_already_imported[] = $detail_table_name;
				}
			}
		
			// VI - TREATMENTS & DRUGS
			
			//Drugs
			magicSelectInsert($site_schema, 'drugs', array());
			//Treatment masters
			magicSelectInsert($site_schema, 'treatment_masters', array('participant_id' => 'participants'));
			// Detail
			$detail_table_names_already_imported = array();
			foreach($sites_atim_controls['central']['treatment_controls'] as $control_type => $control_data) {
				$detail_table_name = $control_data['detail_tablename'];
				if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
					magicSelectInsert($site_schema, $detail_table_name, array('treatment_master_id' => 'treatment_masters', 'drug_id' => 'drugs'));
					$detail_table_names_already_imported[] = $detail_table_name;
				}
			}			
		}
		
		// VII - COLLECTION
		
		magicSelectInsert($site_schema, 'collections', array('participant_id' => 'participants'));
		
		// VIII - SAMPLE
		
		//Sample masters
		magicSelectInsert($site_schema, 'sample_masters', array('initial_specimen_sample_id' => 'sample_masters', 'parent_id' => 'sample_masters', 'collection_id' => 'collections'), array('sample_code' => "CONCAT('$site_code#',sample_code)"));
		//SpecimenDetails & DerivativeDetails
		foreach(array('specimen_details', 'derivative_details') as $table_name) magicSelectInsert($site_schema, $table_name, array('sample_master_id' => 'sample_masters'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['sample_controls'] as $control_type => $control_data) {
			if($control_type != '***id_to_type***') {
				$detail_table_name = $control_data['detail_tablename'];
				if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
					magicSelectInsert($site_schema, $detail_table_name, array('sample_master_id' => 'sample_masters'));
					$detail_table_names_already_imported[] = $detail_table_name;
				}
			}
		}
		
		// IX - STORAGE
		
		//Controls
		magicSelectInsert($site_schema, 'storage_controls', array(), array('storage_type' => "CONCAT(storage_type,' [$site_code]')"));
		$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types'");
		if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_STORAGE_TYPE_VALUES_CONTROL');
		$atim_control_id = $atim_control_id['0']['id'];
		$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id)
			(SELECT CONCAT(value,' [$site_code]'), IF(en = '', '', CONCAT(en,' [$site_code]')), IF(fr = '', '', CONCAT(fr,' [$site_code]')), use_as_input, $atim_control_id
			FROM $site_schema.structure_permissible_values_custom_controls ctrl INNER JOIN $site_schema.structure_permissible_values_customs val ON val.control_id = ctrl.id
			WHERE ctrl.name = 'Storage Types' AND val.deleted <> 1)";
		customQuery($query);
		//StorageMasters
		customQuery("SET FOREIGN_KEY_CHECKS=0;");	//StorageMaster.parent_id can make reference to a storage created later in the past (The StorageMaster.parent_id of the record will be bigger than StorageMaster.id of the same record)
		magicSelectInsert($site_schema, 'storage_masters', array('storage_control_id' => 'storage_controls', 'parent_id' => 'storage_masters'),  array('code' => "CONCAT('$site_code#',code)"));
		customQuery("SET FOREIGN_KEY_CHECKS=1;");
		//Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls[$site]['storage_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($site_schema, $detail_table_name, array('storage_master_id' => 'storage_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
		}
		//StorageMastersRevs
		magicSelectInsert($site_schema, 'storage_masters_revs', array('id' => 'storage_masters', 'storage_control_id' => 'storage_controls', 'parent_id' => 'storage_masters'));
		
		// X - Aliquot

		// Aliquot masters
		magicSelectInsert($site_schema, 'aliquot_masters', array('collection_id' => 'collections', 'sample_master_id' => 'sample_masters', 'storage_master_id' => 'storage_masters'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['aliquot_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($site_schema, $detail_table_name, array('aliquot_master_id' => 'aliquot_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
		}
		//AliquotMastersRevs
		magicSelectInsert($site_schema, 'aliquot_masters_revs', array('id' => 'aliquot_masters', 'collection_id' => 'collections', 'sample_master_id' => 'sample_masters', 'storage_master_id' => 'storage_masters'));
		// Realiquoting
		magicSelectInsert($site_schema, 'realiquotings', array('parent_aliquot_master_id' => 'aliquot_masters', 'child_aliquot_master_id' => 'aliquot_masters'), array('procure_central_is_transfer' => '0'));
		// Source Aliquot
		magicSelectInsert($site_schema, 'source_aliquots', array('sample_master_id' => 'sample_masters', 'aliquot_master_id' => 'aliquot_masters'));
		// Aliquot Internal Uses
		magicSelectInsert($site_schema, 'aliquot_internal_uses', array('aliquot_master_id' => 'aliquot_masters'));

		// XI - QUALITY CONTROL
		
		magicSelectInsert($site_schema, 'quality_ctrls', array('sample_master_id' => 'sample_masters', 'aliquot_master_id' => 'aliquot_masters'), array('qc_code' => "CONCAT('$site_code#',qc_code)"));
		
		// XII - PATH REVIEW
		
		magicSelectInsert($site_schema, 'specimen_review_masters', array('collection_id' => 'collections', 'sample_master_id' => 'sample_masters'), array('review_code' => "CONCAT('$site_code#',review_code)"));
		magicSelectInsert($site_schema, 'aliquot_review_masters', array('specimen_review_master_id' => 'specimen_review_masters', 'aliquot_master_id' => 'aliquot_masters'), array('review_code' => "CONCAT('$site_code#',review_code)"));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['specimen_review_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($site_schema, $detail_table_name, array('specimen_review_master_id' => 'specimen_review_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
			}
			$aliquot_review_detail_table_name = $control_data['aliquot_review_detail_tablename'];
			if(!in_array($aliquot_review_detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($site_schema, $aliquot_review_detail_table_name, array('aliquot_review_master_id' => 'aliquot_review_masters'));
				$detail_table_names_already_imported[] = $aliquot_review_detail_table_name;
			}
		}	
		
		// XIII - ORDERS
		
		if($site == 'processing site') {
			magicSelectInsert($site_schema, 'orders', array('default_study_summary_id' => 'study_summaries'));
			magicSelectInsert($site_schema, 'order_lines', array('order_id' => 'orders', 'study_summary_id' => 'study_summaries'));
			magicSelectInsert($site_schema, 'shipments', array('order_id' => 'orders'));
			magicSelectInsert($site_schema, 'order_items', array('order_id' => 'orders', 'order_line_id' => 'order_lines', 'aliquot_master_id' => 'aliquot_masters', 'shipment_id' => 'shipments'));
		}
		
		// End of bank data import : Get max value of each primary key
		
		regenerateTablesInformation();
		
		// XIV - CUSTOM LISTS
		
		foreach($structure_permissible_values_custom_control_names as $control_name) {
			$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = '$control_name'");
			if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_VALUES_CONTROL::'.$control_name);
			$atim_control_id = $atim_control_id['0']['id'];
			$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id)
				(SELECT site_val.value, site_val.en, site_val.fr, site_val.use_as_input, $atim_control_id
				FROM $site_schema.structure_permissible_values_custom_controls site_ctrl
				INNER JOIN $site_schema.structure_permissible_values_customs site_val ON site_val.control_id = site_ctrl.id
				WHERE site_ctrl.name = '$control_name'
				AND site_val.deleted <> 1
				AND site_val.value NOT IN (
					SELECT central_val.value
					FROM structure_permissible_values_custom_controls central_ctrl
					INNER JOIN structure_permissible_values_customs central_val ON central_val.control_id = central_ctrl.id
					WHERE central_ctrl.name = '$control_name' AND central_val.deleted <> 1)
				);";
			customQuery($query);
		}
	}
}

//==============================================================================================
// 3- Clean up duplicated data
//==============================================================================================

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

// Merge duplicated patient. 
// Note we won't merge patient created in the processing site database
// These patient should be deleted in section below

$query = "SELECT ids, participant_identifier
	FROM (
		SELECT GROUP_CONCAT(id) AS ids, participant_identifier
		FROM participants
		WHERE deleted <> 1 AND procure_last_modification_by_bank != 'p'
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

//==============================================================================================
// 4- Import Data From Processing Site
//==============================================================================================

// 1- Link Bank aliquots to Psp aliquots when match exists on barcode
//    and change the procure_created_by_bank field of these aliquot from bank code to 'p'

$queries = array();
$queries[] = "DROP TABLE IF EXISTS procure_tmp_link_transfered_aliquots;";
$queries[] = "CREATE TABLE procure_tmp_link_transfered_aliquots (
	collection_id int(11) DEFAULT NULL,
	sample_master_id int(11) DEFAULT NULL,
	aliquot_master_id int(11) DEFAULT NULL,
	link_to_collection_id int(11) DEFAULT NULL,
	link_to_sample_master_id int(11) DEFAULT NULL,
	link_to_aliquot_master_id int(11) DEFAULT NULL);";
$queries[] = "INSERT INTO procure_tmp_link_transfered_aliquots (collection_id, sample_master_id, aliquot_master_id, link_to_collection_id, link_to_sample_master_id, link_to_aliquot_master_id)	
	(SELECT CollectionPsp.id, AliquotMasterPsp.sample_master_id, AliquotMasterPsp.id, CollectionBank.id, AliquotMasterBank.sample_master_id, AliquotMasterBank.id
	FROM participants ParticipantBank, collections CollectionBank, aliquot_masters AliquotMasterBank,
	participants ParticipantPsp, collections CollectionPsp, aliquot_masters AliquotMasterPsp
	WHERE AliquotMasterBank.deleted <> 1 AND AliquotMasterBank.collection_id = CollectionBank.id AND CollectionBank.participant_id = ParticipantBank.id
	AND ParticipantBank.procure_last_modification_by_bank != 'p' AND ParticipantBank.procure_last_modification_by_bank = AliquotMasterBank.procure_created_by_bank
	AND AliquotMasterPsp.deleted <> 1 AND AliquotMasterPsp.collection_id = CollectionPsp.id AND CollectionPsp.participant_id = ParticipantPsp.id
	AND ParticipantPsp.procure_last_modification_by_bank = 'p' AND ParticipantPsp.procure_last_modification_by_bank != AliquotMasterPsp.procure_created_by_bank
	AND AliquotMasterBank.barcode = AliquotMasterPsp.barcode
	AND AliquotMasterBank.aliquot_control_id = AliquotMasterPsp.aliquot_control_id
	AND AliquotMasterBank.procure_created_by_bank =  AliquotMasterPsp.procure_created_by_bank);";
$queries[] = "INSERT INTO realiquotings (parent_aliquot_master_id, child_aliquot_master_id, procure_central_is_transfer, created, created_by, modified, modified_by) 
	(SELECT aliquot_master_id, link_to_aliquot_master_id, '1', '$import_date',$imported_by, '$import_date',$imported_by FROM procure_tmp_link_transfered_aliquots);";
$queries[] = "UPDATE aliquot_masters AliquotMaster, procure_tmp_link_transfered_aliquots Link
	SET AliquotMaster.procure_created_by_bank = 'p'
	WHERE AliquotMaster.id = Link.aliquot_master_id;";
$queries[] = "UPDATE aliquot_masters AliquotMaster, procure_tmp_link_transfered_aliquots Link SET AliquotMaster.use_counter = (AliquotMaster.use_counter+1) 
	WHERE AliquotMaster.id = Link.aliquot_master_id";
foreach($queries as $query) customQuery($query);

// 2- List all Psp aliquots defined as received from bank
//    that the system is not able to connect to a bank aliquot
//    then set their procure_created_by_bank field to 'p'

$query = "SELECT AliquotMasterPsp.id, AliquotMasterPsp.barcode, AliquotMasterPsp.procure_created_by_bank
	FROM participants ParticipantPsp, collections CollectionPsp, aliquot_masters AliquotMasterPsp
	WHERE AliquotMasterPsp.deleted <> 1 AND AliquotMasterPsp.collection_id = CollectionPsp.id AND CollectionPsp.participant_id = ParticipantPsp.id
	AND ParticipantPsp.procure_last_modification_by_bank = 'p' AND ParticipantPsp.procure_last_modification_by_bank != AliquotMasterPsp.procure_created_by_bank;";
$unmatching_bank_aliquot_master_ids = array();
foreach(getSelectQueryResult($query) as $new_aliquot) {
	$unmatching_bank_aliquot_master_ids[] = $new_aliquot['id'];
	recordErrorAndMessage('Aliquots', '@@WARNING@@', "Source of a 'Processing Site' aliquot not found", "The aliquot '".$new_aliquot['barcode']."' listed in the 'Processing Site' ATiM database and defined as shipped by bank '".$new_aliquot['procure_created_by_bank']."' does not exist into the ATiM database of the bank. Please see batchset 'Psp aliquots unlinked to Banks aliquots' created then validate with banks.");
}
createBatchSet('ViewAliquot', 'Psp aliquots unlinked to Banks aliquots', $unmatching_bank_aliquot_master_ids);
$query = "SELECT AliquotMasterPsp.id, AliquotMasterPsp.barcode, AliquotMasterPsp.procure_created_by_bank
	FROM participants ParticipantBank, collections CollectionBank, aliquot_masters AliquotMasterBank,
	participants ParticipantPsp, collections CollectionPsp, aliquot_masters AliquotMasterPsp
	WHERE AliquotMasterBank.deleted = 1 AND AliquotMasterBank.collection_id = CollectionBank.id AND CollectionBank.participant_id = ParticipantBank.id
	AND ParticipantBank.procure_last_modification_by_bank != 'p' AND ParticipantBank.procure_last_modification_by_bank = AliquotMasterBank.procure_created_by_bank
	AND AliquotMasterPsp.deleted <> 1 AND AliquotMasterPsp.collection_id = CollectionPsp.id AND CollectionPsp.participant_id = ParticipantPsp.id
	AND ParticipantPsp.procure_last_modification_by_bank = 'p' AND ParticipantPsp.procure_last_modification_by_bank != AliquotMasterPsp.procure_created_by_bank
	AND AliquotMasterBank.barcode = AliquotMasterPsp.barcode
	AND AliquotMasterBank.aliquot_control_id = AliquotMasterPsp.aliquot_control_id
	AND AliquotMasterBank.procure_created_by_bank =  AliquotMasterPsp.procure_created_by_bank";
$deleted_bank_aliquot_master_ids = array();
foreach(getSelectQueryResult($query) as $new_aliquot) {
	$deleted_bank_aliquot_master_ids[] = $new_aliquot['id'];
	recordErrorAndMessage('Aliquots', '@@WARNING@@', "Source of a 'Processing Site' aliquot not found cause deleted in bank", "The aliquot '".$new_aliquot['barcode']."' listed in the 'Processing Site' ATiM database and defined as shipped by bank '".$new_aliquot['procure_created_by_bank']."' does not exist into the ATiM database of the bank. Please see batchset 'Psp aliquots linked to Banks aliquots deleted' created then validate with banks.");
}
createBatchSet('ViewAliquot', 'Psp aliquots linked to Banks aliquots deleted', $deleted_bank_aliquot_master_ids);
$query = "UPDATE participants ParticipantPsp, collections CollectionPsp, aliquot_masters AliquotMasterPsp
	SET AliquotMasterPsp.procure_created_by_bank = 'p'
	WHERE AliquotMasterPsp.deleted <> 1 AND AliquotMasterPsp.collection_id = CollectionPsp.id AND CollectionPsp.participant_id = ParticipantPsp.id
	AND ParticipantPsp.procure_last_modification_by_bank = 'p' AND ParticipantPsp.procure_last_modification_by_bank != AliquotMasterPsp.procure_created_by_bank;";
customQuery($query);

// 3- Update sample_master_id foreign_key values for all aliquots, order_items, quality_ctrls, path_reviews and 'derivatives' records 
//    matching a value of the field procure_tmp_link_transfered_aliquots.sample_master_id 
//    to the value of the field procure_tmp_link_transfered_aliquots.link_to_sample_master_id

$queries[] = "UPDATE aliquot_masters AliquotMaster, procure_tmp_link_transfered_aliquots Link
	SET AliquotMaster.collection_id = Link.link_to_collection_id,  AliquotMaster.sample_master_id = Link.link_to_sample_master_id
	WHERE AliquotMaster.sample_master_id = Link.sample_master_id;";
$queries[] = "UPDATE quality_ctrls QualityCtrl, procure_tmp_link_transfered_aliquots Link
	SET QualityCtrl.sample_master_id = Link.link_to_sample_master_id
	WHERE QualityCtrl.sample_master_id = Link.sample_master_id;";
$queries[] = "UPDATE specimen_review_masters SpecimenReviewMaster, procure_tmp_link_transfered_aliquots Link
	SET SpecimenReviewMaster.collection_id = Link.link_to_collection_id, SpecimenReviewMaster.sample_master_id = Link.link_to_sample_master_id
	WHERE SpecimenReviewMaster.sample_master_id = Link.sample_master_id;";
$queries[] = "UPDATE sample_masters ParentSampleMaster, sample_masters DerivatvieSampleMaster, procure_tmp_link_transfered_aliquots Link
	SET DerivatvieSampleMaster.collection_id = ParentSampleMaster.collection_id, 
	DerivatvieSampleMaster.initial_specimen_sample_id = ParentSampleMaster.initial_specimen_sample_id, 
	DerivatvieSampleMaster.initial_specimen_sample_type = ParentSampleMaster.initial_specimen_sample_type, 
	DerivatvieSampleMaster.collection_id = ParentSampleMaster.collection_id, 
	DerivatvieSampleMaster.parent_id = ParentSampleMaster.id
	WHERE DerivatvieSampleMaster.parent_id = Link.sample_master_id AND ParentSampleMaster.id = Link.sample_master_id;";
foreach($queries as $query) customQuery($query);
$query_to_test = "SELECT DerivativeSampleMaster.id
	FROM sample_masters ParentSampleMaster, sample_masters DerivativeSampleMaster
	WHERE ParentSampleMaster.id = DerivativeSampleMaster.parent_id 
	AND (ParentSampleMaster.collection_id != DerivativeSampleMaster.collection_id OR ParentSampleMaster.initial_specimen_sample_id != DerivativeSampleMaster.initial_specimen_sample_id);";
while(!empty(getSelectQueryResult($query_to_test))) {
	$query = "UPDATE sample_masters ParentSampleMaster, sample_masters DerivativeSampleMaster
		SET DerivativeSampleMaster.collection_id = ParentSampleMaster.collection_id, DerivativeSampleMaster.initial_specimen_sample_id = ParentSampleMaster.initial_specimen_sample_id 
		WHERE ParentSampleMaster.id = DerivativeSampleMaster.parent_id
		AND (ParentSampleMaster.collection_id != DerivativeSampleMaster.collection_id OR ParentSampleMaster.initial_specimen_sample_id != DerivativeSampleMaster.initial_specimen_sample_id);";
	customQuery($query);
}

// 4- Set the procure_participant_attribution_number to bank participants

$query = "UPDATE participants BankParticipant, participants ProcSiteParticipant
	SET BankParticipant.procure_participant_attribution_number = ProcSiteParticipant.procure_participant_attribution_number
	WHERE BankParticipant.procure_last_modification_by_bank != 'p' AND BankParticipant.deleted <> 1
	AND ProcSiteParticipant.procure_last_modification_by_bank = 'p' AND ProcSiteParticipant.deleted <> 1
	AND BankParticipant.participant_identifier = ProcSiteParticipant.participant_identifier;";
customQuery($query);

// 5- Clean up samples, collections and participants created in processing site

$queries = array();
$queries[] = "UPDATE collections SET deleted = '-99' WHERE id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters)";
$queries[] = "DELETE FROM quality_ctrls WHERE sample_master_id IN (SELECT DISTINCT sample_masters.id FROM collections INNER JOIN sample_masters ON collections.id = collection_id WHERE collections.deleted = '-99')";
$queries[] = "DELETE FROM specimen_review_masters WHERE collection_id IN (SELECT DISTINCT collection_id FROM collections WHERE deleted = '-99')";
$queries[] = "UPDATE sample_masters SET parent_id = null WHERE collection_id IN (SELECT DISTINCT collection_id FROM collections WHERE deleted = '-99')";
$queries[] = "DELETE FROM sample_masters WHERE collection_id IN (SELECT DISTINCT collection_id FROM collections WHERE deleted = '-99')";
$queries[] = "DELETE FROM collections WHERE deleted = '-99'";
$queries[] = "DELETE FROM participants WHERE procure_last_modification_by_bank = 'p' AND id NOT IN (SELECT distinct participant_id FROM collections WHERE participant_id IS NOT NULL)";
foreach($queries as $query) customQuery($query);
$query = "SELECT id, procure_participant_attribution_number, participant_identifier FROM participants WHERE deleted <> 1 AND procure_last_modification_by_bank = 'p'";
$participant_ids = array();
foreach(getSelectQueryResult($query) as $new_participant) {
	$participant_ids[] = $new_participant['id'];
	recordErrorAndMessage('Participants', '@@WARNING@@', "Un-merged participants created in Psp", "At least one aliquot of the participant '".$new_participant['participant_identifier']."' listed in the 'Processing Site' ATiM database can not be linked to a sample created in a ATiM database of a 'Bank'. Please see batchset 'Psp participants un-deleted' created then validate with banks.");
}
createBatchSet('Participant', 'Psp participants un-deleted', $participant_ids);

$query = "SELECT id, procure_participant_attribution_number, participant_identifier 
	FROM participants
	WHERE deleted <> 1 AND procure_last_modification_by_bank = 'p' AND participant_identifier NOT IN (SELECT participant_identifier FROM participants WHERE deleted <> 1 AND procure_last_modification_by_bank != 'p')";
$participant_ids = array();
foreach(getSelectQueryResult($query) as $new_participant) {
	$participant_ids[] = $new_participant['id'];
	recordErrorAndMessage('Participants', '@@WARNING@@', "Unknown participants created in Psp", "At least one participant '".$new_participant['participant_identifier']."' listed in the 'Processing Site' ATiM database is not be listed in any 'Bank' ATiM database. Please see batchset 'Psp participants un-known' created then validate with banks.");
}
createBatchSet('Participant', 'Psp participants un-known', $participant_ids);

//TODOverifier le statut des aliquots
//TODOverifier que aliquot defined as shipped....
//TODO dans les utilisations jouer avec le champs procure_central_is_transfer

customQuery("DROP TABLE IF EXISTS procure_tmp_link_transfered_aliquots;");
		
//**********************************************************************************************************************************************************************************************
//
// CHECK DATA INTEGRITY
//
//**********************************************************************************************************************************************************************************************

// PROCURE Form Identification

foreach(array('consent_masters' => 'Consents', 'treatment_masters' => 'Treatments', 'event_masters' => 'Events') as $table_name => $data_type) {
	$query = "SELECT procure_created_by_banks, procure_form_identification
		FROM (
			SELECT GROUP_CONCAT(procure_created_by_bank) as procure_created_by_banks, procure_form_identification FROM $table_name WHERE deleted <> 1 AND procure_form_identification NOT LIKE '%Vx%' GROUP BY procure_form_identification
		) res WHERE procure_created_by_banks LIKE '%,%'
		ORDER BY procure_form_identification;";
	$duplicated_forms = getSelectQueryResult($query);
	foreach($duplicated_forms as $new_form_set) recordErrorAndMessage($data_type, '@@WARNING@@', "Form Identification Duplicated", "See '".$new_form_set['procure_form_identification']."' from banks '".$new_form_set['procure_created_by_banks']."'.");
}

// PROCURE Aliquot Identification

//TODO : Be sure aliquot recorded into processing site created in other bank are flagged as created in processing site?
$query = "SELECT procure_created_by_bank, barcode
	FROM (
		SELECT GROUP_CONCAT(procure_created_by_bank) as procure_created_by_bank, barcode FROM aliquot_masters WHERE deleted <> 1 GROUP BY barcode
	) res WHERE procure_created_by_bank LIKE '%,%'
	ORDER BY barcode;";
$duplicated_forms = getSelectQueryResult($query);
foreach($duplicated_forms as $new_form_set) recordErrorAndMessage('Aliquots', '@@WARNING@@', "Barcode Duplicated", "See aliquot '".$new_form_set['barcode']."' from banks '".$new_form_set['procure_created_by_bank']."'.");





// 'Transferred participant' listed in only one bank

$query = "SELECT GROUP_CONCAT(participant_identifier) AS participant_identifiers FROM participants WHERE deleted <> 1 AND procure_transferred_participant = 'y' AND id NOT IN (".implode(',', $merged_participant_ids).")";
$participants_list = getSelectQueryResult($query);
if($participants_list && isset($participants_list[0]['participant_identifiers'])) recordErrorAndMessage('Participants', '@@WARNING@@', "Transferred participant listed in only one bank", "Following participants are flagged as 'Transferred Participant' but are not found in more than one bank  (see ".$participants_list[0]['participant_identifiers']."). Please validate with banks.");

//**********************************************************************************************************************************************************************************************
//
// FINAL PROCESSES
//
//**********************************************************************************************************************************************************************************************

// Add site/bank as root to any root storages 

$query = "INSERT INTO storage_controls (storage_type, display_x_size, display_y_size, reverse_x_numbering, reverse_y_numbering, horizontal_increment, set_temperature, is_tma_block, flag_active, detail_form_alias, detail_tablename, databrowser_label, check_conflicts) VALUES
	('site', 0, 0, 0, 0, 1, 1, 0, 1, 'std_rooms', 'std_rooms', 'custom#storage types#site', 1);";
$storage_control_id = customQuery($query, true);
$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types'");
if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_STORAGE_TYPE_VALUES_CONTROL');
$atim_control_id = $atim_control_id['0']['id'];
$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id) VALUES ('site', 'Site', 'Site', 1, $atim_control_id)";
customQuery($query);

foreach($sites_to_sitecodes as $bank_site => $site_code) {
	$query = "INSERT INTO storage_masters (code,storage_control_id,short_label,created,created_by,modified,modified_by)  VALUES ('$site_code', $storage_control_id, '$site_code', '$import_date', $imported_by, '$import_date', $imported_by);";
	$storage_master_id = customQuery($query, true);
	$query = "INSERT INTO std_rooms (storage_master_id) VALUES ($storage_master_id);";
	customQuery($query, true);
	$query = "UPDATE storage_masters SET parent_id = $storage_master_id, modified = '$import_date', modified_by = $imported_by WHERE parent_id IS NULL AND code LIKE '$site_code#%'";
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

function createBatchSet($model, $title, $ids) {
	global $imported_by;
	global $import_date;
	
	if($ids) {
		$ids = is_array($ids)?  implode(',',$ids) : $ids ;
		if(!preg_match('/^[0-9,]+$/', $ids))  mergeDie("ERR_createBatchSet_#1 ('$title', '$model', '$ids')!");
		$datamart_structure_id = getSelectQueryResult("SELECT id FROM datamart_structures WHERE model = '$model';");
		if(!$datamart_structure_id || !isset($datamart_structure_id[0]['id'])) mergeDie("ERR_createBatchSet_#2 ('$title', '$model', '$ids')!");
		$datamart_structure_id = $datamart_structure_id[0]['id'];
		$query = "INSERT INTO `datamart_batch_sets` (user_id, group_id, sharing_status, title, `datamart_structure_id`, `created`, `created_by`, `modified`, `modified_by`) 
			(SELECT id, group_id, 'all', '$title', $datamart_structure_id, '$import_date', $imported_by, '$import_date', $imported_by FROM users WHERE id = $imported_by);";
		customQuery($query, true);
		$datamart_batch_set_id = getSelectQueryResult("SELECT id FROM datamart_batch_sets WHERE title = '$title'");
		if(!($datamart_batch_set_id && $datamart_batch_set_id['0']['id'])) mergeDie("ERR_createBatchSet_#3 ('$title', '$model', '$ids')!");
		$datamart_batch_set_id = $datamart_batch_set_id['0']['id'];
		$query = "INSERT INTO datamart_batch_ids (set_id, lookup_id) VALUES ($datamart_batch_set_id, ".str_replace(",", "), ($datamart_batch_set_id, ", $ids).");";
		customQuery($query, true);
	}
}

?>
		