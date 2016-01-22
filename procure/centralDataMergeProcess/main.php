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
	'chuq' =>	null,// $db_chuq_schemas,
	'chus' =>	null,//  $db_chus_schemas,
	'cusm' => 	null,// $db_cusm_schemas
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
							recordErrorAndMessage('ATiM Controls Data Check', '@@ERROR@@', "Missing control table in central bank", '', "The $control_table_name control '$atim_control_type' of site $bank_site is missing into central.");
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
								recordErrorAndMessage('ATiM Controls Data Check', '@@ERROR@@', "Control '$control_table_name' data not compatible", '', "Following fields values are different in [the 'central' ATiM database and the '$bank_site' ATiM database : ".implode(' & ', $field_messages));
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
	recordErrorAndMessage('Merge Information', '@@ERROR@@', "Merge Process Aborted", '', "The data control values are not compatible.");
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
$tables_to_truncate[] = 'datamart_browsing_indexes';
$tables_to_truncate[] = 'datamart_browsing_results';
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
// 3- Clean up data
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

// Merge duplicated patients: 
//    Note we won't merge patient created in the processing site database
//    These patient should be deleted in section below

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
	recordErrorAndMessage('Participants', '@@MESSAGE@@', "Transferred participant", "Participant is recorded into more than one bank. All data of the participant will be merged and linked to the last modified participant profile.", "$participant_identifier in banks $participants_banks");
	if(!$check_all_flagged_as_transferred) recordErrorAndMessage('Participants', '@@WARNING@@', "Participant not flagged as 'Transferred Participant'", "At least one bank did not flagged participant listed in more than one bank as 'Transferred Participant'. Please validate with banks.", "$participant_identifier in banks $participants_banks");
	if(!$check_all_data_similar) recordErrorAndMessage('Participants', '@@WARNING@@', "'Transferred Participant' data mismatches", "The profile of a 'Transferred Participant' does not match the profile of the same patient in the other bank(s). Please validate with banks.", "$participant_identifier in banks $participants_banks");
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
$main_participant_ids = array_keys($matching_participant_ids);
if($main_participant_ids) {
	$query = "UPDATE participants SET procure_transferred_participant = 'y' WHERE id IN (".implode(',',$main_participant_ids).")";
	customQuery($query);
}
if($participant_ids_to_delete) customQuery("DELETE FROM participants WHERE id IN (".implode(',', $participant_ids_to_delete).")");

// Delete all quality controls different than 'nanodrop', 'bioanalyzer', 'spectrophotometer'

$queries = array();
$queries[] = "UPDATE quality_ctrls QualityCtrl, aliquot_masters AliquotMaster
	SET AliquotMaster.use_counter = (AliquotMaster.use_counter - 1)
	WHERE QualityCtrl.aliquot_master_id = AliquotMaster.id AND AliquotMaster.deleted <> 1 AND QualityCtrl.deleted <> 1
	AND QualityCtrl.type NOT IN ('nanodrop', 'bioanalyzer', 'spectrophotometer');";
$queries[] = "UPDATE quality_ctrls SET deleted = '1' WHERE type NOT IN ('nanodrop', 'bioanalyzer', 'spectrophotometer');";
foreach($queries as $query) customQuery($query);

//==============================================================================================
// 4- Import Data From Processing Site
//==============================================================================================

// 1- Link Bank aliquots to Psp aliquots when match exists on barcode
//    and change the procure_created_by_bank field of these aliquots from bank code to 'p'

$queries = array();
$queries[] = "DROP TABLE IF EXISTS procure_tmp_transfered_aliquot_ids;";
$queries[] = "CREATE TABLE procure_tmp_transfered_aliquot_ids (
	bank_aliquot_collection_id int(11) DEFAULT NULL,
	bank_aliquot_sample_master_id int(11) DEFAULT NULL,
	bank_aliquot_master_id int(11) DEFAULT NULL,
	psp_aliquot_collection_id int(11) DEFAULT NULL,
	psp_aliquot_sample_master_id int(11) DEFAULT NULL,
	psp_aliquot_master_id int(11) DEFAULT NULL);";
$queries[] = "INSERT INTO procure_tmp_transfered_aliquot_ids (bank_aliquot_collection_id, bank_aliquot_sample_master_id, bank_aliquot_master_id, psp_aliquot_collection_id, psp_aliquot_sample_master_id, psp_aliquot_master_id)	
	(SELECT CollectionBank.id, AliquotMasterBank.sample_master_id, AliquotMasterBank.id, CollectionPsp.id, AliquotMasterPsp.sample_master_id, AliquotMasterPsp.id
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
	(SELECT TransferedIdsTable.bank_aliquot_master_id, TransferedIdsTable.psp_aliquot_master_id, '1', '$import_date',$imported_by, '$import_date',$imported_by FROM procure_tmp_transfered_aliquot_ids TransferedIdsTable);";
$queries[] = "UPDATE aliquot_masters AliquotMaster, procure_tmp_transfered_aliquot_ids TransferedIdsTable
	SET AliquotMaster.procure_created_by_bank = 'p'
	WHERE AliquotMaster.id = TransferedIdsTable.psp_aliquot_master_id;";
$queries[] = "UPDATE aliquot_masters AliquotMaster, procure_tmp_transfered_aliquot_ids TransferedIdsTable 
	SET AliquotMaster.use_counter = (AliquotMaster.use_counter + 1) 
	WHERE AliquotMaster.id = TransferedIdsTable.bank_aliquot_master_id;";
foreach($queries as $query) customQuery($query);

// 2- List all Psp aliquots defined as received from bank
//    that the system is not able to connect to a bank aliquot

$query = "SELECT AliquotMasterPsp.id, AliquotMasterPsp.barcode, AliquotMasterPsp.procure_created_by_bank,
	AliquotMasterBank.deleted AS bank_aliquot_deleted, 
	AliquotMasterBank.aliquot_control_id bank_aliquot_control_id, AliquotMasterPsp.aliquot_control_id psp_aliquot_control_id,
	AliquotMasterBank.procure_created_by_bank aliquot_bank, AliquotMasterPsp.procure_created_by_bank aliquot_bank_in_psp
	FROM participants ParticipantBank, collections CollectionBank, aliquot_masters AliquotMasterBank,
	participants ParticipantPsp, collections CollectionPsp, aliquot_masters AliquotMasterPsp
	WHERE AliquotMasterBank.collection_id = CollectionBank.id AND CollectionBank.participant_id = ParticipantBank.id
	AND ParticipantBank.procure_last_modification_by_bank != 'p' AND ParticipantBank.procure_last_modification_by_bank = AliquotMasterBank.procure_created_by_bank
	AND AliquotMasterPsp.deleted <> 1 AND AliquotMasterPsp.collection_id = CollectionPsp.id AND CollectionPsp.participant_id = ParticipantPsp.id
	AND ParticipantPsp.procure_last_modification_by_bank = 'p' AND ParticipantPsp.procure_last_modification_by_bank != AliquotMasterPsp.procure_created_by_bank
	AND AliquotMasterBank.barcode = AliquotMasterPsp.barcode;";
$deleted_bank_aliquot_master_ids = array();
$aliquot_master_ids_with_control_id_msimatch = array();
$aliquot_master_ids_with_bank_msimatch = array();
foreach(getSelectQueryResult($query) as $new_aliquot) {
	if($new_aliquot['bank_aliquot_deleted']) {
		$deleted_bank_aliquot_master_ids[] = $new_aliquot['id'];
		recordErrorAndMessage('Aliquots', '@@WARNING@@', "'Processing Site' aliquot flagged as transfered deleted in bank", "Aliquot listed in the 'Processing Site' ATiM database and defined transfered from a bank to the processing site that has been deleted into the ATiM database of the bank. Please see batchset 'Psp aliquots linked to deleted bank aliquots' created then validate with banks. Aliquot won't be linked in the central ATiM.", $new_aliquot['barcode']." of bank '".$new_aliquot['procure_created_by_bank']."'");
	} else if($new_aliquot['bank_aliquot_control_id'] != $new_aliquot['psp_aliquot_control_id']) {
		$aliquot_master_ids_with_control_id_msimatch[] = $new_aliquot['id'];
		recordErrorAndMessage('Aliquots', '@@WARNING@@', "'Processing Site' aliquot flagged as transfered but aliquot type mismatch", "Aliquot listed in the 'Processing Site' ATiM database and defined transfered from a bank to the processing site and having an aliquot type recorded in the 'Processing Site' ATiM database different than this one defined in bank. Please see batchset 'Psp aliquots linked to bank aliquots with type mismatch' created then validate with banks. Aliquot won't be linked in the central ATiM.", $new_aliquot['barcode']." of bank '".$new_aliquot['procure_created_by_bank']."'");
	} else if($new_aliquot['aliquot_bank'] != $new_aliquot['aliquot_bank_in_psp']) {
		$aliquot_master_ids_with_bank_msimatch[] = $new_aliquot['id'];
		recordErrorAndMessage('Aliquots', '@@WARNING@@', "'Processing Site' aliquot flagged as transfered but source bank mismatch", "Aliquot listed in the 'Processing Site' ATiM database and defined transfered from a bank to the processing site and having a 'Source Bank' recorded in the 'Processing Site' ATiM database different then the real bank that shipped the aliquot. Please see batchset 'Psp aliquots linked to bank aliquots with bank value mismatch' created then validate with banks. Aliquot won't be linked in the central ATiM.", $new_aliquot['barcode']." of bank '".$new_aliquot['procure_created_by_bank']."'");
	} else {
		mergeDie('ERR_MATCHING_BARCODE_ERROR_DETECTION_IS_MISSING');
	}
}
foreach(array(array($deleted_bank_aliquot_master_ids, 'Psp aliquots linked to deleted bank aliquots'), array($aliquot_master_ids_with_control_id_msimatch, 'Psp aliquots linked to bank aliquots with type mismatch'), array($aliquot_master_ids_with_bank_msimatch, 'Psp aliquots linked to bank aliquots with bank value mismatch')) as $tmp_batchset_data) {
	list($batchset_ids, $batchset_title) = $tmp_batchset_data;
	createBatchSet('ViewAliquot', $batchset_title, $batchset_ids);
}
$not_in_ids = array_merge($deleted_bank_aliquot_master_ids, $aliquot_master_ids_with_control_id_msimatch, $aliquot_master_ids_with_bank_msimatch, array('-1'));
$query = "SELECT AliquotMasterPsp.id, AliquotMasterPsp.barcode, AliquotMasterPsp.procure_created_by_bank
	FROM participants ParticipantPsp, collections CollectionPsp, aliquot_masters AliquotMasterPsp
	WHERE AliquotMasterPsp.deleted <> 1 AND AliquotMasterPsp.collection_id = CollectionPsp.id AND CollectionPsp.participant_id = ParticipantPsp.id
	AND ParticipantPsp.procure_last_modification_by_bank = 'p' AND ParticipantPsp.procure_last_modification_by_bank != AliquotMasterPsp.procure_created_by_bank
	AND AliquotMasterPsp.id NOT IN (".implode(',', $not_in_ids).");";
$unmatching_bank_aliquot_master_ids = array();
foreach(getSelectQueryResult($query) as $new_aliquot) {
	$unmatching_bank_aliquot_master_ids[] = $new_aliquot['id'];
	recordErrorAndMessage('Aliquots', '@@WARNING@@', "'Processing Site' aliquot flagged as transfered but not 'linked' to a bank's aliquot", "Aliquot listed in the 'Processing Site' ATiM database and defined as transfered from a bank to the processing site that does not exist into the ATiM database of a bank. Please see batchset 'Psp aliquots received that does not exist in bank' created then validate with banks.", $new_aliquot['barcode']." of bank '".$new_aliquot['procure_created_by_bank']."'");
}
createBatchSet('ViewAliquot', 'Psp aliquots received that does not exist in bank', $unmatching_bank_aliquot_master_ids);

// 3- Set procure_created_by_bank field of all aliquots created in Psp ATiM database to 'p'

$query = "UPDATE participants ParticipantPsp, collections CollectionPsp, aliquot_masters AliquotMasterPsp
	SET AliquotMasterPsp.procure_created_by_bank = 'p'
	WHERE AliquotMasterPsp.deleted <> 1 AND AliquotMasterPsp.collection_id = CollectionPsp.id AND CollectionPsp.participant_id = ParticipantPsp.id
	AND ParticipantPsp.procure_last_modification_by_bank = 'p';";
customQuery($query);

// 4- Update sample_master_id foreign_key values for all aliquot_masters, quality_ctrls, path_reviews 
//    and 'derivatives' sample_masters records that was linked to the sample of the transfered aliquot
//    into the processing site database.

// AliquotMaster.collection_id & AliquotMaster.sample_master_id
$queries = array();
$queries[] = "UPDATE aliquot_masters AliquotMaster, procure_tmp_transfered_aliquot_ids TransferedIdsTable
	SET AliquotMaster.collection_id = TransferedIdsTable.bank_aliquot_collection_id,  
	AliquotMaster.sample_master_id = TransferedIdsTable.bank_aliquot_sample_master_id
	WHERE AliquotMaster.sample_master_id = TransferedIdsTable.psp_aliquot_sample_master_id;";
// QualityCtrl.sample_master_id
$queries[] = "UPDATE quality_ctrls QualityCtrl, procure_tmp_transfered_aliquot_ids TransferedIdsTable
	SET QualityCtrl.sample_master_id = TransferedIdsTable.bank_aliquot_sample_master_id
	WHERE QualityCtrl.sample_master_id = TransferedIdsTable.psp_aliquot_sample_master_id;";
// SpecimenReviewMaster.collection_id & SpecimenReviewMaster.sample_master_id	
$queries[] = "UPDATE specimen_review_masters SpecimenReviewMaster, procure_tmp_transfered_aliquot_ids TransferedIdsTable
	SET SpecimenReviewMaster.collection_id = TransferedIdsTable.bank_aliquot_collection_id, 
	SpecimenReviewMaster.sample_master_id = TransferedIdsTable.bank_aliquot_sample_master_id
	WHERE SpecimenReviewMaster.sample_master_id = TransferedIdsTable.psp_aliquot_sample_master_id;";
//Move all psp derivative samples to link them to the bank sample linked to the transfered aliquot...	
$queries[] = "UPDATE sample_masters NewParentSampleMaster, sample_masters PspDerivativeSampleMaster, procure_tmp_transfered_aliquot_ids TransferedIdsTable
	SET PspDerivativeSampleMaster.collection_id = NewParentSampleMaster.collection_id, 
	PspDerivativeSampleMaster.initial_specimen_sample_id = NewParentSampleMaster.initial_specimen_sample_id, 
	PspDerivativeSampleMaster.initial_specimen_sample_type = NewParentSampleMaster.initial_specimen_sample_type,
	PspDerivativeSampleMaster.parent_id = NewParentSampleMaster.id
	WHERE NewParentSampleMaster.id = TransferedIdsTable.bank_aliquot_sample_master_id
	AND PspDerivativeSampleMaster.parent_id = TransferedIdsTable.psp_aliquot_sample_master_id;";
foreach($queries as $query) customQuery($query);
//... then update all derivatives and the sub-derivatives of the derivative updated above
$query_to_test = "SELECT PspDerivativeSampleMaster.id
	FROM sample_masters NewParentSampleMaster, sample_masters PspDerivativeSampleMaster
	WHERE NewParentSampleMaster.id = PspDerivativeSampleMaster.parent_id 
	AND (NewParentSampleMaster.collection_id != PspDerivativeSampleMaster.collection_id 
	OR NewParentSampleMaster.initial_specimen_sample_id != PspDerivativeSampleMaster.initial_specimen_sample_id);";
while(!empty(getSelectQueryResult($query_to_test))) {
	$query = "UPDATE sample_masters NewParentSampleMaster, sample_masters PspDerivativeSampleMaster
		SET PspDerivativeSampleMaster.collection_id = NewParentSampleMaster.collection_id, 
		PspDerivativeSampleMaster.initial_specimen_sample_id = NewParentSampleMaster.initial_specimen_sample_id,
		PspDerivativeSampleMaster.initial_specimen_sample_type = NewParentSampleMaster.initial_specimen_sample_type
		WHERE NewParentSampleMaster.id = PspDerivativeSampleMaster.parent_id
		AND (NewParentSampleMaster.collection_id != PspDerivativeSampleMaster.collection_id 
		OR NewParentSampleMaster.initial_specimen_sample_id != PspDerivativeSampleMaster.initial_specimen_sample_id);";
	customQuery($query);
}
//Set collection_id of all aliquots of the derivatvies updated
$query = "UPDATE sample_masters SampleMaster, aliquot_masters AliquotMaster
	SET AliquotMaster.collection_id = SampleMaster.collection_id
	WHERE AliquotMaster.collection_id != SampleMaster.collection_id
	AND AliquotMaster.sample_master_id = SampleMaster.id;";
customQuery($query);

// 5- Set the procure_participant_attribution_number to bank participants

$query = "UPDATE participants BankParticipant, participants PspParticipant
	SET BankParticipant.procure_participant_attribution_number = PspParticipant.procure_participant_attribution_number
	WHERE BankParticipant.procure_last_modification_by_bank != 'p' AND BankParticipant.deleted <> 1
	AND PspParticipant.procure_last_modification_by_bank = 'p' AND PspParticipant.deleted <> 1
	AND BankParticipant.participant_identifier = PspParticipant.participant_identifier;";
customQuery($query);

// 6- Clean up samples, collections and participants created in processing site

$queries = array();
$queries[] = "UPDATE collections Collection 
	SET Collection.deleted = '99' 
	WHERE Collection.id NOT IN (SELECT DISTINCT collection_id FROM aliquot_masters WHERE deleted <> 1);";
$queries[] = "UPDATE quality_ctrls QualityCtrls, sample_masters SampleMaster, collections Collection
	SET QualityCtrls.deleted = 1 
	WHERE QualityCtrls.sample_master_id = SampleMaster.id AND SampleMaster.collection_id = Collection.id AND Collection.deleted = '99';";
$queries[] = "UPDATE aliquot_review_masters ReviewMaster, aliquot_masters AliquotMaster, collections Collection
	SET ReviewMaster.deleted = 1
	WHERE ReviewMaster.aliquot_master_id = AliquotMaster.id AND AliquotMaster.collection_id = Collection.id AND Collection.deleted = '99';";
$queries[] = "UPDATE specimen_review_masters ReviewMaster, collections Collection
	SET ReviewMaster.deleted = 1
	WHERE ReviewMaster.collection_id = Collection.id AND Collection.deleted = '99';";
$queries[] = "UPDATE sample_masters SampleMaster, collections Collection
	SET SampleMaster.deleted = 1
	WHERE SampleMaster.collection_id = Collection.id AND Collection.deleted = '99';";
$queries[] = "UPDATE collections Collection 
	SET Collection.deleted = '1' 
	WHERE Collection.deleted = '99';";
$queries[] = "UPDATE participants Participant 
	SET Participant.deleted = '1' 
	WHERE Participant.procure_last_modification_by_bank = 'p' AND Participant.id NOT IN (SELECT distinct participant_id FROM collections WHERE participant_id IS NOT NULL AND deleted <> 1);";
$queries[] = "UPDATE participants Participant, misc_identifiers MiscIdentifier 
	SET MiscIdentifier.deleted = '1' 
	WHERE Participant.procure_last_modification_by_bank = 'p' AND Participant.deleted = '1' AND Participant.id = MiscIdentifier.participant_id;";
foreach($queries as $query) customQuery($query);

$query = "SELECT id, procure_participant_attribution_number, participant_identifier FROM participants WHERE deleted <> 1 AND procure_last_modification_by_bank = 'p'";
$participant_ids = array();
foreach(getSelectQueryResult($query) as $new_participant) {
	$participant_ids[] = $new_participant['id'];
	recordErrorAndMessage('Participants', '@@WARNING@@', "Un-merged participants created in Psp", "At least one aliquot of a participant listed in the 'Processing Site' ATiM database can not be linked to a sample created in a ATiM database of a 'Bank'. Please see batchset 'Psp participants un-deleted' created then validate with banks.", $new_participant['participant_identifier']);
}
createBatchSet('Participant', 'Psp participants un-deleted', $participant_ids);

$query = "SELECT id, procure_participant_attribution_number, participant_identifier 
	FROM participants
	WHERE deleted <> 1 AND procure_last_modification_by_bank = 'p' AND participant_identifier NOT IN (SELECT participant_identifier FROM participants WHERE deleted <> 1 AND procure_last_modification_by_bank != 'p')";
$participant_ids = array();
foreach(getSelectQueryResult($query) as $new_participant) {
	$participant_ids[] = $new_participant['id'];
	recordErrorAndMessage('Participants', '@@WARNING@@', "Unknown participants created in Psp", "Participant listed in the 'Processing Site' ATiM database is not listed in a 'Bank' ATiM database. Please see batchset 'Psp participants unknown' created then validate with banks.", $new_participant['participant_identifier']);
}
createBatchSet('Participant', 'Psp participants unknown', $participant_ids);

customQuery("DROP TABLE IF EXISTS procure_tmp_transfered_aliquot_ids;");		
		
//**********************************************************************************************************************************************************************************************
//
// CHECK DATA INTEGRITY
//
//**********************************************************************************************************************************************************************************************

// Duplicated PROCURE form Identification (tx, cst, event)

foreach(array('consent_masters' => 'Consents', 'treatment_masters' => 'Treatments', 'event_masters' => 'Events') as $table_name => $data_type) {
	$query = "SELECT procure_created_by_banks, procure_form_identification
		FROM (
			SELECT GROUP_CONCAT(procure_created_by_bank) as procure_created_by_banks, procure_form_identification FROM $table_name WHERE deleted <> 1 AND procure_form_identification NOT LIKE '%Vx%' GROUP BY procure_form_identification
		) res WHERE procure_created_by_banks LIKE '%,%'
		ORDER BY procure_form_identification;";
	$duplicated_forms = getSelectQueryResult($query);
	foreach($duplicated_forms as $new_form_set) recordErrorAndMessage($data_type, '@@WARNING@@', "Form Identification Duplicated", '', $new_form_set['procure_form_identification']."' in bank(s) '".$new_form_set['procure_created_by_banks']."'.");
}

// Duplicated PROCURE aliquot barcode

$query = "SELECT procure_created_by_bank, barcode
	FROM (
		SELECT GROUP_CONCAT(procure_created_by_bank) as procure_created_by_bank, barcode FROM aliquot_masters 
		WHERE deleted <> 1 AND id NOT IN (
			SELECT child_aliquot_master_id FROM realiquotings WHERE procure_central_is_transfer = '1'
		) GROUP BY barcode
	) res WHERE procure_created_by_bank LIKE '%,%'
	ORDER BY barcode;";
$duplicated_forms = getSelectQueryResult($query);
foreach($duplicated_forms as $new_form_set) recordErrorAndMessage('Aliquots', '@@WARNING@@', "Barcode Duplicated", '', $new_form_set['barcode']."' in bank(s) '".$new_form_set['procure_created_by_bank']."'.");

// Participant flagged as 'Transferred participant' listed in only one bank

$merged_participant_ids = array_merge($merged_participant_ids, array('-1'));
$query = "SELECT participant_identifier, procure_last_modification_by_bank FROM participants WHERE deleted <> 1 AND procure_transferred_participant = 'y' AND id NOT IN (".implode(',', $merged_participant_ids).")";
foreach(getSelectQueryResult($query) as $new_particiant) recordErrorAndMessage('Participants', '@@WARNING@@', "'Transferred Participant' listed in only one bank", "Participant is flagged as 'Transferred Participant' but this one is just recorded into one bank database. Please validate with banks.", $new_particiant['participant_identifier'].' in bank '.$new_particiant['procure_last_modification_by_bank']);

// In stock values of transferred aliquots

$query = "SELECT BankAliquotMaster.id, BankAliquotMaster.barcode, BankAliquotMaster.procure_created_by_bank, PspAliquotMaster.id as psp_id
	FROM aliquot_masters BankAliquotMaster, realiquotings TransferLink, aliquot_masters PspAliquotMaster
	WHERE TransferLink.procure_central_is_transfer = '1' AND BankAliquotMaster.id = TransferLink.parent_aliquot_master_id AND PspAliquotMaster.id = TransferLink.child_aliquot_master_id 
	AND BankAliquotMaster.in_stock = 'yes - available' AND PspAliquotMaster.in_stock = 'yes - available'";
$barcodes = getSelectQueryResult($query);
$aliquot_ids = array();
foreach($barcodes as $new_aliquot) {
	$aliquot_ids[] = $new_aliquot['id'];
	$aliquot_ids[] = $new_aliquot['psp_id'];
	recordErrorAndMessage('Participants', '@@WARNING@@', "'Transferred Aliquot' in stock conflict", "Aliquot is flagged as in stock and available in both bank and processing site. Please see 'Transferred aliquot with stock value conflict' batchset and correct data in site.", $new_aliquot['barcode'].' in bank '.$new_aliquot['procure_created_by_bank']);
}
createBatchSet('ViewAliquot', 'Transferred aliquot with stock value conflict', $aliquot_ids);

$query = "SELECT BankAliquotMaster.barcode, BankAliquotMaster.procure_created_by_bank
	FROM aliquot_masters BankAliquotMaster, realiquotings TransferLink, aliquot_masters PspAliquotMaster
	WHERE TransferLink.procure_central_is_transfer = '1' AND BankAliquotMaster.id = TransferLink.parent_aliquot_master_id AND PspAliquotMaster.id = TransferLink.child_aliquot_master_id 
	AND BankAliquotMaster.in_stock = 'yes - not available' AND PspAliquotMaster.in_stock = 'yes - available'";
$barcodes = getSelectQueryResult($query);
foreach($barcodes as $new_aliquot) recordErrorAndMessage('Participants', '@@MESSAGE@@', "'Transferred Aliquot' in stock warning", "Aliquot is flagged as in stock and available in processing site and in stock but not available in bank. Please validate with bank.", $new_aliquot['barcode'].' in bank '.$new_aliquot['procure_created_by_bank']);

// Check aliquots are defined as chiped

$query = "SELECT  BankAliquotMaster.id, BankAliquotMaster.barcode, BankAliquotMaster.procure_created_by_bank
	FROM aliquot_masters BankAliquotMaster, realiquotings TransferLink
	WHERE TransferLink.procure_central_is_transfer = '1' AND BankAliquotMaster.id = TransferLink.parent_aliquot_master_id
	AND BankAliquotMaster.id NOT IN (SELECT aliquot_master_id FROM aliquot_internal_uses WHERE type = 'sent to processing site' AND deleted <> 1)";
$barcodes = getSelectQueryResult($query);
$aliquot_ids = array();
foreach($barcodes as $new_aliquot) {
	$aliquot_ids[] = $new_aliquot['id'];
	recordErrorAndMessage('Participants', '@@WARNING@@', "'Transferred Aliquot' in stock conflict", "Aliquot is transferred to processing site but no inforamtion is recorded in bank database. Please see 'Transferred aliquot not defined as sent' batchset and correct data in site.", $new_aliquot['barcode'].' in bank '.$new_aliquot['procure_created_by_bank']);
}
createBatchSet('ViewAliquot', 'Transferred aliquot not defined as sent', $aliquot_ids);

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

// ...

customQuery("UPDATE versions SET permissions_regenerated = 0");
dislayErrorAndMessage(true);
pr('<br>******************************************************************************************');
pr('PROCESS DONE');
pr('******************************************************************************************');

?>
		