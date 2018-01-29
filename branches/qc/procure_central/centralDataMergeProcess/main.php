<?php

$track_queries = false;

require_once 'system.php';
require_once 'config.php';

$atim_user_id = '2';
$import_date = DATE('Ymd H:m:s');

displayMergeTitle('PROCURE CENTRAL ATIM : Data Sites Merge Process');

//**********************************************************************************************************************************************************************************************
//
// DATABASE CONNECTIONS AND TESTS
//
//**********************************************************************************************************************************************************************************************

connectToCentralDatabase();

customQuery("INSERT INTO procure_banks_data_merge_tries(datetime, result) VALUES ('$import_date', 'failed');");
customQuery("TRUNCATE procure_banks_data_merge_messages;");
mysqli_commit($db_connection);

$bank_databases = array(
	'PS1' => $db_ps1_schemas,
	'PS2' => $db_ps2_schemas,
	'PS3' => $db_ps3_schemas,
	'PS4' => $db_ps4_schemas
);
foreach($bank_databases as $site => $db_schema) {
	if(!testDbSchemas($db_schema, $site)) {
		recordErrorAndMessage(
		    'ATiM Databases Check',
			'@@WARNING@@',
			"Bank/Site data missing",
			"The database of the site/bank '$site' does not exist on the server. No data of the bank will be imported into the 'ATiM Central' database.");
		$bank_databases[$site] = null;
	}
}

//**********************************************************************************************************************************************************************************************
//
// LOAD AND TESTS THE ATiM CONTROLS TABLES CONTENT
//
// 1- Main Controls Table ('consent_controls', 'event_controls', 'treatment_controls', 'sample_controls', 'aliquot_controls', 'specimen_review_controls', 'aliquot_review_controls'):
//    - Compare the content of all of them to validate id and detail_tablename are similar.
//
// 2- MiscIdentifierControl :
//    - Just Import 'participant study number' from bank and site
//    - The 'participant study number' misc_identifier_controls of each site will be renamed as 'participant study number ({bank or site name})' to be considered as unique
//
// 3- StorageControl:
//    - Will import the storage_controls data of each bank and site
//    - All storage controls will be recorded as different storage type.
//    - So no control done at this level.
//
//**********************************************************************************************************************************************************************************************

$sites_atim_controls = array();
foreach(array_merge(array('central' => $db_central_schemas), $bank_databases) as $bank_site => $db_schema) {
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
							recordErrorAndMessage(
							    'ATiM Databases Check', 
								'@@ERROR@@', 
								"Missing control table in central bank",
								"The $control_table_name control '$atim_control_type' of site '$bank_site' is missing into central.");
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
								recordErrorAndMessage(
								    'ATiM Databases Check', 
									'@@ERROR@@', 
									"Control '$control_table_name' data not compatible",
									"Following fields values are different in [the 'central' ATiM database and the '$bank_site' ATiM database : ".implode(' & ', $field_messages));
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
	recordErrorAndMessage(
	    'ATiM Databases Check', 
	    '@@ERROR@@', 
	    "Merge Process Aborted", 
	    "The data control values are not compatible.");
	dislayErrorAndMessage(true);
	mergeDie("ERR_CONTROLS_MISMATCHES_DETECTED (please see summary).");
}

//**********************************************************************************************************************************************************************************************
//
// POPULATE CENTRAL DATABASE
//
//**********************************************************************************************************************************************************************************************

//==============================================================================================
// 1 - Backups ALiquot and Participant batchsets
//==============================================================================================

$batch_set_queries = array();
$batch_set_queries[] = "DROP TABLE IF EXISTS procure_tmp_datamart_batch_sets;";
$batch_set_queries[] = "DROP TABLE IF EXISTS procure_tmp_datamart_batch_ids;";
$batch_set_queries[] = "CREATE TABLE IF NOT EXISTS `procure_tmp_datamart_batch_sets` (
	`id` int(11) NOT NULL,
	`user_id` int(11) NOT NULL,
	`group_id` int(11) NOT NULL,
	`sharing_status` varchar(50) DEFAULT 'user',
	`title` varchar(50) NOT NULL DEFAULT 'unknown',
	`description` text,
	`datamart_structure_id` int(10) unsigned NOT NULL,
	`locked` tinyint(1) NOT NULL DEFAULT '0',
	`flag_tmp` tinyint(1) NOT NULL DEFAULT '0',
	`created` datetime DEFAULT NULL,
	`created_by` int(10) unsigned NOT NULL,
	`modified` datetime DEFAULT NULL,
	`modified_by` int(10) unsigned NOT NULL);";
$batch_set_queries[] = "CREATE TABLE IF NOT EXISTS `procure_tmp_datamart_batch_ids` (
	`set_id` int(11) DEFAULT NULL,
	`participant_identifier` varchar(50) DEFAULT NULL,
	`barcode` varchar(60) DEFAULT NULL);";
$batch_set_queries[] = "INSERT INTO procure_tmp_datamart_batch_sets(`id`, `user_id`, `group_id`, `sharing_status`, `title`, `description`, `datamart_structure_id`, `locked`, `flag_tmp`, `created`, `created_by`, `modified`, `modified_by`)
	(SELECT `id`, `user_id`, `group_id`, `sharing_status`, `title`, `description`, `datamart_structure_id`, `locked`, `flag_tmp`, `created`, `created_by`, `modified`, `modified_by` 
	FROM datamart_batch_sets 
	WHERE (datamart_batch_sets.created_by != $imported_by OR (datamart_batch_sets.created_by = $imported_by AND (datamart_batch_sets.description NOT LIKE '### Merge Process BatchSet ###' OR datamart_batch_sets.description IS NULL)))
	AND datamart_structure_id IN (SELECT id FROM datamart_structures WHERE model IN ('ViewAliquot', 'Participant')));";	
$batch_set_queries[] = "INSERT INTO procure_tmp_datamart_batch_ids (`set_id`, `participant_identifier`)
	(SELECT datamart_batch_ids.set_id, participants.participant_identifier
	FROM participants
	INNER JOIN datamart_batch_ids ON participants.id = datamart_batch_ids.lookup_id
	INNER JOIN datamart_batch_sets ON datamart_batch_sets.id = datamart_batch_ids.set_id
	INNER JOIN datamart_structures ON datamart_structures.id = datamart_batch_sets.datamart_structure_id
	INNER JOIN procure_tmp_datamart_batch_sets ON datamart_batch_sets.id = procure_tmp_datamart_batch_sets.id
	WHERE datamart_structures.model = 'Participant'
	AND participants.deleted <> 1);";
$batch_set_queries[] = "INSERT INTO procure_tmp_datamart_batch_ids (`set_id`, `barcode`)
	(SELECT datamart_batch_ids.set_id, aliquot_masters.barcode
	FROM aliquot_masters
	INNER JOIN datamart_batch_ids ON aliquot_masters.id = datamart_batch_ids.lookup_id
	INNER JOIN datamart_batch_sets ON datamart_batch_sets.id = datamart_batch_ids.set_id
	INNER JOIN datamart_structures ON datamart_structures.id = datamart_batch_sets.datamart_structure_id
	INNER JOIN procure_tmp_datamart_batch_sets ON datamart_batch_sets.id = procure_tmp_datamart_batch_sets.id
	WHERE datamart_structures.model = 'ViewAliquot'
	AND aliquot_masters.deleted <> 1);";
foreach($batch_set_queries as $new_query) customQuery($new_query);

//==============================================================================================
// 2 - Delete central database data
//==============================================================================================

$tables_to_truncate = array();

//Orders
$tables_to_truncate[] = 'order_items';
$tables_to_truncate[] = 'shipments';
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
$tables_to_truncate[] = 'tma_slides';
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
$tables_to_truncate[] = 'procure_banks_data_merge_messages';

$structure_permissible_values_custom_control_names = array(
	'Aliquot Use and Event Types',
    'Clinical Exam - Results (PROCURE values only)',
    'Clinical Exam - Sites (PROCURE values only)',
    'Clinical Exam - Types (PROCURE values only)',
    'Clinical Note Types',
    'Consent Form Versions',
    'Progressions & Comorbidities (PROCURE values only)',
    'Questionnaire version date',
    'Slide Review : Tissue Type',
    'Storage Coordinate Titles',
    'Storage Types',
    'Surgery Types (PROCURE values only)',
    'Tissue Slide Stains',
    'TMA Slide Stains',
    'Treatment Precisions (PROCURE values only)',
    'Treatment Sites (PROCURE values only)',
    'Treatment Types (PROCURE values only)');
    
$all_queries = array(
	"UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null",
	"UPDATE storage_masters SET parent_id = null",
	"DELETE FROM structure_permissible_values_customs WHERE control_id IN (SELECT id FROM structure_permissible_values_custom_controls WHERE name IN ('".implode("','",$structure_permissible_values_custom_control_names)."'))",
);
foreach($tables_to_truncate as $new_table) {
	$all_queries[] = "DELETE FROM $new_table";
	$all_queries[] = "ALTER TABLE $new_table AUTO_INCREMENT = 1";
}
foreach($all_queries as $new_query) customQuery($new_query);

//==============================================================================================
// 3- Import Data From The 4 Banks (Collection Sites) + Processing Site (data included into PS3)
//==============================================================================================

$populated_tables_information = array();
foreach($bank_databases as $site => $site_schema) {
	//New Bank
	
	$site_code = str_replace('PS', '', $site);
	
	if($site_schema) {
		
		// I - STUDY
		
		magicSelectInsert($site_schema, 'study_summaries');
		
		// II - PARTICIPANTS
		
		magicSelectInsert($site_schema, 'participants');
		
		// III - IDENTIFIERS
		
		customQuery("UPDATE $site_schema.misc_identifier_controls SET misc_identifier_name = CONCAT(misc_identifier_name, ' $site');");
		magicSelectInsert($site_schema, 'misc_identifier_controls');
		magicSelectInsert($site_schema, 'misc_identifiers', array('participant_id' => 'participants', 'study_summary_id' => 'study_summaries', 'misc_identifier_control_id' => 'misc_identifier_controls'));
		customQuery("UPDATE $site_schema.misc_identifier_controls SET misc_identifier_name = REPLACE(misc_identifier_name, ' $site', '');");

		// IV - CONSENTS
		
		magicSelectInsert($site_schema, 'consent_masters', array('participant_id' => 'participants'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['consent_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($site_schema, $detail_table_name, array('consent_master_id' => 'consent_masters'), array(), true);
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
		magicSelectInsert($site_schema, 'treatment_masters', array('participant_id' => 'participants', 'procure_drug_id' => 'drugs'));
		// Detail
		$detail_table_names_already_imported = array();
		foreach($sites_atim_controls['central']['treatment_controls'] as $control_type => $control_data) {
			$detail_table_name = $control_data['detail_tablename'];
			if(!in_array($detail_table_name, $detail_table_names_already_imported)) {
				magicSelectInsert($site_schema, $detail_table_name, array('treatment_master_id' => 'treatment_masters'));
				$detail_table_names_already_imported[] = $detail_table_name;
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
		$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id, created, created_by, modified, modified_by)
			(SELECT CONCAT(value,' [$site_code]'), IF(en = '', '', CONCAT(en,' [$site_code]')), IF(fr = '', '', CONCAT(fr,' [$site_code]')), use_as_input, $atim_control_id, NOW(), '1', NOW(), '1'
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
		//Tma slide
		magicSelectInsert($site_schema, 'tma_slides', array('storage_master_id' => 'storage_masters', 'tma_block_storage_master_id' => 'storage_masters', 'study_summary_id' => 'study_summaries'));
		
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
		magicSelectInsert($site_schema, 'aliquot_internal_uses', array('aliquot_master_id' => 'aliquot_masters', 'study_summary_id' => 'study_summaries'));

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
		
		magicSelectInsert($site_schema, 'orders', array('default_study_summary_id' => 'study_summaries'));
		magicSelectInsert($site_schema, 'shipments', array('order_id' => 'orders'));
		magicSelectInsert($site_schema, 'order_items', array('order_id' => 'orders', 'aliquot_master_id' => 'aliquot_masters', 'tma_slide_id' => 'tma_slides', 'shipment_id' => 'shipments'));
		
		// End of bank data import : Get max value of each primary key
		
		regenerateTablesInformation();
		
		// XIV - CUSTOM LISTS
		
		foreach($structure_permissible_values_custom_control_names as $control_name) {
			$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = '$control_name'");
			if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_VALUES_CONTROL::'.$control_name);
			$atim_control_id = $atim_control_id['0']['id'];
			$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id, created, created_by, modified, modified_by)
				(SELECT site_val.value, site_val.en, site_val.fr, site_val.use_as_input, $atim_control_id, NOW(), 1, NOW(), 1
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
// 4- Clean up data
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

$merged_participants_fields = array(
    'date_of_birth', 
    'vital_status', 
    'date_of_death', 
    'procure_cause_of_death', 
    'procure_patient_withdrawn',
    'procure_patient_refusal_withdrawal_date', 
    'procure_last_contact', 
    'procure_last_contact_details',
    'procure_next_collections_refusal', 
    'procure_refusal_to_be_contacted', 
    'procure_clinical_file_update_refusal', 
    'procure_contact_lost', 
    'procure_next_visits_refusal', 
    'procure_patient_refusal_withdrawal_reason');
customQuery("UPDATE participants
    SET procure_last_modification_by_bank = 's'
    WHERE deleted <> 1 
    AND procure_last_modification_by_bank = '3'
    AND participant_identifier NOT LIKE 'PS3%'");
$query = "SELECT ids, participant_identifier
	FROM (
		SELECT GROUP_CONCAT(id) AS ids, participant_identifier
		FROM participants
		WHERE deleted <> 1 AND procure_last_modification_by_bank != 's'
		GROUP BY participant_identifier
	)res_level1 WHERE ids LIKE '%,%';";
$duplicated_participants = getSelectQueryResult($query);
$matching_participant_ids = array();
$multi_bank_participant_identifiers = array();
$unflagged_transferred_multi_bank_participant_identifiers = array();
$data_mismatches_multi_bank_participant_identifiers = array();
foreach($duplicated_participants as $new_duplicated_participants_data) {
	$participant_identifier = $new_duplicated_participants_data['participant_identifier'];
	//Merge participants having the same identifier
	//  - Get all of them
	//  - Keep the last one modified
	//  - Track data mismatches
	$query = "SELECT * from participants WHERE participant_identifier = '$participant_identifier' AND deleted <> 1 AND procure_last_modification_by_bank != 's' ORDER BY modified DESC";
	$participants_data = getSelectQueryResult($query);
	$participants_data_to_display = $participants_data[0];
	unset($participants_data[0]);
	$check_all_flagged_as_transferred = ($participants_data_to_display['procure_transferred_participant'] == 'y')? true : false;	
	$check_all_data_similar = true;
	if(!isset($matching_participant_ids[$participants_data_to_display['id']])) $matching_participant_ids[$participants_data_to_display['id']] = array();
	foreach($participants_data as $duplicated_participant) {
		$matching_participant_ids[$participants_data_to_display['id']][] = $duplicated_participant['id'];
		if($duplicated_participant['procure_transferred_participant'] != 'y') $check_all_flagged_as_transferred = false;
		foreach($merged_participants_fields as $studied_field) {
			if($participants_data_to_display[$studied_field] !== $duplicated_participant[$studied_field]) $check_all_data_similar = false;
		}
	}
	$multi_bank_participant_identifiers[] = $participant_identifier;
	if(!$check_all_flagged_as_transferred) {
	    $unflagged_transferred_multi_bank_participant_identifiers[] = $participant_identifier;
	}
	if(!$check_all_data_similar) {
	    $data_mismatches_multi_bank_participant_identifiers[] = $participant_identifier;
	}
	$matching_participant_ids[$participants_data_to_display['id']] = implode(',', $matching_participant_ids[$participants_data_to_display['id']]);
}
if($multi_bank_participant_identifiers) {
    createTemporaryBatchsetAndMessage(
        "Transferred Participants",
        $multi_bank_participant_identifiers, 
        'Participant', 
        'Participants', 
        '@@MESSAGE@@', 
        "Participants recorded into more than one bank. All data will be merged except the profile.");
}
if($unflagged_transferred_multi_bank_participant_identifiers) {
    createTemporaryBatchsetAndMessage(
        "Unflagged Transferred Participants", 
        $unflagged_transferred_multi_bank_participant_identifiers,
        'Participant',
        'Participants',
        '@@WARNING@@',
        "Participants recorded into more than one bank but at least one bank did not flag participant as 'Transferred Participant'.");
}
if($data_mismatches_multi_bank_participant_identifiers) {
    createTemporaryBatchsetAndMessage(
        "Transferred Participants with profile mismatches",
        $data_mismatches_multi_bank_participant_identifiers,
        'Participant',
        'Participants',
        '@@WARNING@@',
        "Participants recorded into more than one bank but the data of the profiles do not match.");
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
customQuery("UPDATE participants
    SET procure_last_modification_by_bank = '3'
    WHERE deleted <> 1
    AND procure_last_modification_by_bank = 's'");
    
// Delete all quality controls different than 'nanodrop', 'bioanalyzer', 'spectrophotometer'

customQuery("UPDATE quality_ctrls SET deleted = '1' WHERE type NOT IN ('nanodrop', 'bioanalyzer', 'spectrophotometer');");

//==============================================================================================
// 5- Import Data From Processing Site 
//   In 2017 the data of the processing site have been merged into the ATiM PS3.
//   So in ATiM PS3 a transferred aliquot is an aliquot flagged as created by PS1, 2 or 4 and
//   linked to a sample created by system. Note that all PS3 aliquot previously recorded into 
//   the processing site database are now linked to the sample of PS3 so won't be flagged as 
//   a transferred aliquot.
//   In following lines we will keep psp annotation.
//==============================================================================================

// 1- Link Bank aliquots to Psp aliquots when match exists on barcode

$queries = array();
$queries[] = "DROP TABLE IF EXISTS procure_tmp_transfered_aliquot_ids;";
$queries[] = "CREATE TABLE procure_tmp_transfered_aliquot_ids (
    barcode varchar(60) DEFAULT NULL,
	bank_aliquot_collection_id int(11) DEFAULT NULL,
	bank_aliquot_sample_master_id int(11) DEFAULT NULL,
	bank_aliquot_master_id int(11) DEFAULT NULL,
	psp_aliquot_collection_id int(11) DEFAULT NULL,
	psp_aliquot_sample_master_id int(11) DEFAULT NULL,
	psp_aliquot_master_id int(11) DEFAULT NULL);";
$queries[] = "INSERT INTO procure_tmp_transfered_aliquot_ids (
    barcode,
    bank_aliquot_collection_id, bank_aliquot_sample_master_id, bank_aliquot_master_id, 
    psp_aliquot_collection_id, psp_aliquot_sample_master_id, psp_aliquot_master_id)	
	(SELECT AliquotMasterPsp.barcode,
    AliquotMasterBank.collection_id, AliquotMasterBank.sample_master_id, AliquotMasterBank.id, 
    AliquotMasterPsp.collection_id, AliquotMasterPsp.sample_master_id, AliquotMasterPsp.id
	FROM aliquot_masters AliquotMasterBank, sample_masters SampleMasterBank,
    aliquot_masters AliquotMasterPsp, sample_masters SampleMasterPsp
	WHERE AliquotMasterPsp.deleted <> 1 
    AND AliquotMasterPsp.procure_created_by_bank IN (1,2,4)
    AND AliquotMasterPsp.sample_master_id = SampleMasterPsp.id
    AND SampleMasterPsp.procure_created_by_bank = 's'
    AND AliquotMasterPsp.procure_created_by_bank = AliquotMasterBank.procure_created_by_bank
    AND AliquotMasterPsp.barcode = AliquotMasterBank.barcode
    AND AliquotMasterPsp.aliquot_control_id = AliquotMasterBank.aliquot_control_id
    AND AliquotMasterBank.deleted <> 1
    AND AliquotMasterBank.sample_master_id = SampleMasterBank.id
    AND AliquotMasterBank.procure_created_by_bank = SampleMasterBank.procure_created_by_bank);";
$queries[] = "INSERT INTO realiquotings (parent_aliquot_master_id, child_aliquot_master_id, procure_central_is_transfer, created, created_by, modified, modified_by) 
	(SELECT TransferedIdsTable.bank_aliquot_master_id, TransferedIdsTable.psp_aliquot_master_id, '1', '$import_date',$imported_by, '$import_date',$imported_by 
	FROM procure_tmp_transfered_aliquot_ids TransferedIdsTable);";
foreach($queries as $query) customQuery($query);

// 2- List all Psp aliquots defined as received from bank
//    that the system is not able to connect to a bank aliquot

$query = "SELECT AliquotMasterPsp.id, 
    AliquotMasterPsp.barcode, 
    AliquotMasterPsp.procure_created_by_bank,
	AliquotMasterBank.deleted AS bank_aliquot_deleted, 
	AliquotMasterBank.aliquot_control_id bank_aliquot_control_id, 
    AliquotMasterPsp.aliquot_control_id psp_aliquot_control_id,
	AliquotMasterBank.procure_created_by_bank aliquot_bank, 
    AliquotMasterPsp.procure_created_by_bank aliquot_bank_in_psp
    FROM aliquot_masters AliquotMasterBank, sample_masters SampleMasterBank,
    aliquot_masters AliquotMasterPsp, sample_masters SampleMasterPsp
    WHERE AliquotMasterPsp.deleted <> 1
    AND AliquotMasterPsp.id NOT IN (SELECT psp_aliquot_master_id FROM procure_tmp_transfered_aliquot_ids)
    AND AliquotMasterPsp.procure_created_by_bank IN (1,2,4)
    AND AliquotMasterPsp.sample_master_id = SampleMasterPsp.id
    AND SampleMasterPsp.procure_created_by_bank = 's'
    AND AliquotMasterPsp.barcode = AliquotMasterBank.barcode
    AND AliquotMasterBank.sample_master_id = SampleMasterBank.id
    AND AliquotMasterBank.procure_created_by_bank = SampleMasterBank.procure_created_by_bank;";
$psp_aliquot_master_ids_deleted_in_bank = array();
$psp_aliquot_master_ids_with_control_id_msimatch = array();
$psp_aliquot_master_ids_with_bank_msimatch = array();
foreach(getSelectQueryResult($query) as $new_aliquot) {
	if($new_aliquot['bank_aliquot_deleted']) {
		$psp_aliquot_master_ids_deleted_in_bank[] = $new_aliquot['id'];
	} else if($new_aliquot['bank_aliquot_control_id'] != $new_aliquot['psp_aliquot_control_id']) {
		$psp_aliquot_master_ids_with_control_id_msimatch[] = $new_aliquot['id'];
	} else if($new_aliquot['aliquot_bank'] != $new_aliquot['aliquot_bank_in_psp']) {
		$psp_aliquot_master_ids_with_bank_msimatch[] = $new_aliquot['id'];
	} else {
		mergeDie('ERR_MATCHING_BARCODE_ERROR_DETECTION_IS_MISSING');
	}
}
if($psp_aliquot_master_ids_deleted_in_bank) {
    createBatchsetAndMessage(
        "Aliquot transferred to PS3 deleted in bank",
        $psp_aliquot_master_ids_deleted_in_bank,
        'ViewAliquot',
        'Aliquots',
        '@@ERROR@@',
        "Processing site aliquot (in PS3) flagged as received from bank has been deleted into the ATiM of the bank.");
}
if($psp_aliquot_master_ids_with_control_id_msimatch) {
    createBatchsetAndMessage(
        "Aliquot transferred to PS3 with types mismatches",
        $psp_aliquot_master_ids_with_control_id_msimatch,
        'ViewAliquot',
        'Aliquots',
        '@@ERROR@@',
        "Processing site aliquot (in PS3) flagged as received from bank does not match the type of the aliquot into the ATiM of the bank.");
}
if($psp_aliquot_master_ids_with_bank_msimatch) {
    createBatchsetAndMessage(
        "Aliquot transferred to PS3 with provider conflict",
        $psp_aliquot_master_ids_with_bank_msimatch,
        'ViewAliquot',
        'Aliquots',
        '@@ERROR@@',
        "Processing site aliquot (in PS3) flagged as received from bank with a bank name or provider different than the real bank that shipped the aliquots.");
}
$not_in_ids = array_merge($psp_aliquot_master_ids_deleted_in_bank, $psp_aliquot_master_ids_with_control_id_msimatch, $psp_aliquot_master_ids_with_bank_msimatch, array('-1'));
$query = "SELECT AliquotMasterPsp.id, 
    AliquotMasterPsp.barcode, 
    AliquotMasterPsp.procure_created_by_bank
	FROM aliquot_masters AliquotMasterPsp, sample_masters SampleMasterPsp
    WHERE AliquotMasterPsp.deleted <> 1 
    AND AliquotMasterPsp.procure_created_by_bank IN (1,2,4)
    AND AliquotMasterPsp.sample_master_id = SampleMasterPsp.id
    AND SampleMasterPsp.procure_created_by_bank = 's'
    AND AliquotMasterPsp.id NOT IN (SELECT psp_aliquot_master_id FROM procure_tmp_transfered_aliquot_ids)
    AND AliquotMasterPsp.id NOT IN (".implode(',', $not_in_ids).");";
$unmatching_bank_aliquot_master_ids = array();
foreach(getSelectQueryResult($query) as $new_aliquot) {
	$unmatching_bank_aliquot_master_ids[] = $new_aliquot['id'];
}
if($unmatching_bank_aliquot_master_ids) {
    createBatchsetAndMessage(
        "Aliquot transferred to PS3 never created in bank",
        $unmatching_bank_aliquot_master_ids,
        'ViewAliquot',
        'Aliquots',
        '@@ERROR@@',
        "Processing site aliquot (in PS3) flagged as received from bank has never been created into the ATiM of the bank.");
}

// 3- Update sample_master_id foreign_key values for all aliquot_masters, quality_ctrls, path_reviews 
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
$query_to_test_results = getSelectQueryResult($query_to_test);
while(!empty($query_to_test_results)) {
	$query = "UPDATE sample_masters NewParentSampleMaster, sample_masters PspDerivativeSampleMaster
		SET PspDerivativeSampleMaster.collection_id = NewParentSampleMaster.collection_id, 
		PspDerivativeSampleMaster.initial_specimen_sample_id = NewParentSampleMaster.initial_specimen_sample_id,
		PspDerivativeSampleMaster.initial_specimen_sample_type = NewParentSampleMaster.initial_specimen_sample_type
		WHERE NewParentSampleMaster.id = PspDerivativeSampleMaster.parent_id
		AND (NewParentSampleMaster.collection_id != PspDerivativeSampleMaster.collection_id 
		OR NewParentSampleMaster.initial_specimen_sample_id != PspDerivativeSampleMaster.initial_specimen_sample_id);";
	customQuery($query);
	$query_to_test_results = getSelectQueryResult($query_to_test);
}
//Set collection_id of all aliquots of the derivatvies updated
$query = "UPDATE sample_masters SampleMaster, aliquot_masters AliquotMaster
	SET AliquotMaster.collection_id = SampleMaster.collection_id
	WHERE AliquotMaster.collection_id != SampleMaster.collection_id
	AND AliquotMaster.sample_master_id = SampleMaster.id;";
customQuery($query);

// 4- Set procure_created_by_bank to PS3 for the transferred aliquot recorded into PS3 ATiM and defined as received from bank

$query = "UPDATE aliquot_masters AliquotMaster, procure_tmp_transfered_aliquot_ids TransferedIdsTable
	SET AliquotMaster.procure_created_by_bank = '3'
	WHERE AliquotMaster.id = TransferedIdsTable.psp_aliquot_master_id;";
customQuery($query);

// 5- Delete all samples with procure_created_by_bank = 's' then collections

$query = "SELECT count(*) AS nbr FROM sample_masters
    WHERE deleted <> 1
    AND procure_created_by_bank = 's'
    AND collection_id IN (SELECT psp_aliquot_collection_id FROM procure_tmp_transfered_aliquot_ids)
    AND id NOT IN (
        SELECT parent_id FROM (
            SELECT DISTINCT parent_id 
            FROM sample_masters, procure_tmp_transfered_aliquot_ids 
            WHERE psp_aliquot_collection_id = collection_id 
            AND parent_id IS NOT NULL
            AND deleted <> 1)
        AS Res)
    AND id NOT IN (
        SELECT sample_master_id FROM (
            SELECT DISTINCT sample_master_id 
            FROM aliquot_masters, procure_tmp_transfered_aliquot_ids 
            WHERE psp_aliquot_collection_id = collection_id 
            AND deleted <> 1)
        AS Res)
    AND id NOT IN (
        SELECT sample_master_id FROM (
            SELECT DISTINCT sample_master_id 
            FROM sample_masters, procure_tmp_transfered_aliquot_ids, quality_ctrls 
            WHERE psp_aliquot_collection_id = collection_id 
            AND quality_ctrls.sample_master_id = sample_masters.id
            AND quality_ctrls.deleted <> 1)
        AS Res)
    AND id NOT IN (
        SELECT sample_master_id FROM (
            SELECT DISTINCT sample_master_id 
            FROM specimen_review_masters, procure_tmp_transfered_aliquot_ids
            WHERE psp_aliquot_collection_id = collection_id 
            AND deleted <> 1)
        AS Res);";
$sample_to_delete = getSelectQueryResult($query);
while($sample_to_delete[0]['nbr'] != '0') {
    customQuery(str_replace('SELECT count(*) AS nbr FROM sample_masters', 'UPDATE sample_masters SET deleted = 1', $query));
    $sample_to_delete = getSelectQueryResult($query);
}
$query = "UPDATE collections, procure_tmp_transfered_aliquot_ids
    SET deleted = 1
    WHERE id = psp_aliquot_collection_id
    AND id NOT IN (
        SELECT DISTINCT collection_id 
        FROM sample_masters, procure_tmp_transfered_aliquot_ids 
        WHERE psp_aliquot_collection_id = collection_id 
        AND deleted <> 1)
    AND id NOT IN (
        SELECT DISTINCT collection_id 
        FROM specimen_review_masters, procure_tmp_transfered_aliquot_ids 
        WHERE psp_aliquot_collection_id = collection_id 
        AND deleted <> 1)";
customQuery($query);

// 5- Delete all participants created on PS3 to record transferred aliquots and not linked to collection anymore

$queries = array();
$queries[] = "UPDATE participants
    SET procure_last_modification_by_bank = 's'
    WHERE deleted <> 1
    AND procure_last_modification_by_bank = '3'
    AND participant_identifier NOT LIKE 'PS3%'";
$queries[] = "UPDATE misc_identifiers Mi, misc_identifier_controls MiCtrl, participants PspParticipant, participants BankParticipant
    SET Mi.participant_id = BankParticipant.id 
    WHERE MiCtrl.misc_identifier_name = 'participant study number PS3'
    AND MiCtrl.id = Mi.misc_identifier_control_id
    AND Mi.deleted <> 1
    AND Mi.participant_id = PspParticipant.id
    AND PspParticipant.deleted <> 1
    AND PspParticipant.procure_last_modification_by_bank = 's'
    AND PspParticipant.participant_identifier = BankParticipant.participant_identifier
    AND BankParticipant.procure_last_modification_by_bank != 's'
    AND BankParticipant.deleted <> 1";
$queries[] = "UPDATE participants
    SET deleted = 1
    WHERE procure_last_modification_by_bank = 's'
    AND id NOT IN (SELECT participant_id FROM treatment_masters WHERE deleted <> 1)
    AND id NOT IN (SELECT participant_id FROM event_masters WHERE deleted <> 1)
    AND id NOT IN (SELECT participant_id FROM consent_masters WHERE deleted <> 1)
    AND id NOT IN (SELECT participant_id FROM misc_identifiers WHERE deleted <> 1);";
foreach($queries as $query) customQuery($query);

$query = "SELECT id, participant_identifier FROM participants WHERE deleted <> 1 AND procure_last_modification_by_bank = 's'";
$participant_ids = array();
foreach(getSelectQueryResult($query) as $new_participant) {
	$participant_ids[] = $new_participant['id'];
}
if($participant_ids) {
    createBatchsetAndMessage(
        "Undeleted 'Processing Site' participants",
        $participant_ids,
        'Participant',
        'Participants',
        '@@ERROR@@',
        "'Processing Site' participants that have not been deleted by the 'Central Data Merge' script. Check no data are linked to these participants in 'ATiM-PS3' and all aliquots can be linked to aliquots of another bank.");
}

$query = "SELECT id, participant_identifier 
	FROM participants
	WHERE deleted <> 1 AND procure_last_modification_by_bank = 's' AND participant_identifier NOT IN (SELECT participant_identifier FROM participants WHERE deleted <> 1 AND procure_last_modification_by_bank != 's')";
$participant_ids = array();
foreach(getSelectQueryResult($query) as $new_participant) {
	$participant_ids[] = $new_participant['id'];
}
if($participant_ids) {
    createBatchsetAndMessage(
        "Unknown 'Processing Site' participants",
        $participant_ids,
        'Participant',
        'Participants',
        '@@WARNING@@',
        "'Processing Site' participants not found into another bank.");
}

customQuery("UPDATE participants
    SET procure_last_modification_by_bank = '3'
    WHERE deleted <> 1
    AND procure_last_modification_by_bank = 's'");
    
// 6- End of the tasks on participant

customQuery("DROP TABLE IF EXISTS procure_tmp_transfered_aliquot_ids;");

$control_name = 'aliquot use and event types';
$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = '$control_name'");
if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_VALUES_CONTROL_2::'.$control_name);
$atim_control_id = $atim_control_id['0']['id'];
$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id, created, created_by, modified, modified_by) 
    VALUES ('###system_transfer_flag###' ,'Transfer (System Record)', 'Transfert (donnée système)', '1', $atim_control_id, NOW(), 1, NOW(), 1);";
customQuery($query);

//==============================================================================================
// 6 - Recreates ALiquot and Participant batchsets
//==============================================================================================

//TODO Fix created because the cautocommit = false seams to not be functional
$create_previous_id = true;
$query_result = customQuery('DESC datamart_batch_sets;');
while($row = $query_result->fetch_assoc()) if($row['Field'] == 'previous_id') $create_previous_id = false;

$batch_set_queries = array();
if($create_previous_id) $batch_set_queries[] = "ALTER TABLE datamart_batch_sets ADD COLUMN `previous_id` int(11) DEFAULT NULL;";
$batch_set_queries[] = "INSERT INTO datamart_batch_sets (`previous_id`, `user_id`, `group_id`, `sharing_status`, `title`, `description`, `datamart_structure_id`, `locked`, `flag_tmp`, `created`, `created_by`, `modified`, `modified_by`)
	(SELECT `id`, `user_id`, `group_id`, `sharing_status`, `title`, `description`, `datamart_structure_id`, `locked`, `flag_tmp`, `created`, `created_by`, `modified`, `modified_by` FROM procure_tmp_datamart_batch_sets);";
$batch_set_queries[] = "INSERT INTO datamart_batch_ids (`set_id`, `lookup_id`)
	(SELECT datamart_batch_sets.id, participants.id
	FROM datamart_batch_sets
	INNER JOIN procure_tmp_datamart_batch_ids ON datamart_batch_sets.previous_id = procure_tmp_datamart_batch_ids.set_id
	INNER JOIN participants ON participants.participant_identifier = procure_tmp_datamart_batch_ids.participant_identifier
	INNER JOIN datamart_structures ON datamart_structures.id = datamart_batch_sets.datamart_structure_id
	WHERE datamart_structures.model = 'Participant'
	AND participants.deleted <> 1);";
$batch_set_queries[] = "INSERT INTO datamart_batch_ids (`set_id`, `lookup_id`)
	(SELECT datamart_batch_sets.id, aliquot_masters.id
	FROM datamart_batch_sets
	INNER JOIN procure_tmp_datamart_batch_ids ON datamart_batch_sets.previous_id = procure_tmp_datamart_batch_ids.set_id
	INNER JOIN aliquot_masters ON aliquot_masters.barcode = procure_tmp_datamart_batch_ids.barcode
	INNER JOIN datamart_structures ON datamart_structures.id = datamart_batch_sets.datamart_structure_id
	WHERE datamart_structures.model = 'ViewAliquot'
	AND aliquot_masters.deleted <> 1);";
$batch_set_queries[] = "ALTER TABLE datamart_batch_sets DROP COLUMN `previous_id`;";
//$batch_set_queries[] = "DROP TABLE IF EXISTS procure_tmp_datamart_batch_sets;";
//$batch_set_queries[] = "DROP TABLE IF EXISTS procure_tmp_datamart_batch_ids;";
foreach($batch_set_queries as $new_query) customQuery($new_query);

//**********************************************************************************************************************************************************************************************
//
// CHECK DATA INTEGRITY
//
//**********************************************************************************************************************************************************************************************

// Duplicated PROCURE aliquot barcode

$query = "SELECT aliquot_masters.id, procure_created_by_banks, res.barcode
	FROM (
		SELECT GROUP_CONCAT(procure_created_by_bank) as procure_created_by_banks, barcode FROM aliquot_masters 
		WHERE deleted <> 1 AND id NOT IN (
			SELECT child_aliquot_master_id FROM realiquotings WHERE procure_central_is_transfer = '1'
		) GROUP BY barcode
	) res 
    INNER JOIN aliquot_masters ON res.barcode = aliquot_masters.barcode AND aliquot_masters.deleted <> 1
	WHERE procure_created_by_banks LIKE '%,%'
    ORDER BY barcode;";
$duplicated_barcodes = getSelectQueryResult($query);
$aliquot_master_ids = array();
foreach($duplicated_barcodes as $new_form_set) {
    $aliquot_master_ids[] = $new_form_set['id'];
}
if($aliquot_master_ids) {
    createBatchsetAndMessage(
        "Barcode Duplicated",
        $aliquot_master_ids,
        'ViewAliquot',
        'Aliquots',
        '@@ERROR@@',
        'Barcodes recorded into more than one ATiM (ATiM-Bank).');
}

// Participant flagged as 'Transferred participant' listed in only one bank

$merged_participant_ids = array_merge($merged_participant_ids, array('-1'));
$query = "SELECT id, participant_identifier, procure_last_modification_by_bank FROM participants WHERE deleted <> 1 AND procure_transferred_participant = 'y' AND id NOT IN (".implode(',', $merged_participant_ids).")";
$participant_ids = array();
foreach(getSelectQueryResult($query) as $new_particiant) {
    $participant_ids[] = $new_particiant['id'];
}
if($participant_ids) {
    createBatchsetAndMessage(
        "'Transferred Participant' in one bank",
        $participant_ids,
        'Participant',
        'Participants',
        '@@WARNING@@',
        "'Transferred Participants' recorded in only one ATiM (ATiM-Bank).");
}

// In stock values of transferred aliquots

$query = "SELECT BankAliquotMaster.id, BankAliquotMaster.barcode, BankAliquotMaster.procure_created_by_bank, PspAliquotMaster.id as psp_id
	FROM aliquot_masters BankAliquotMaster, realiquotings TransferLink, aliquot_masters PspAliquotMaster
	WHERE TransferLink.procure_central_is_transfer = '1' AND BankAliquotMaster.id = TransferLink.parent_aliquot_master_id AND PspAliquotMaster.id = TransferLink.child_aliquot_master_id 
	AND BankAliquotMaster.in_stock = 'yes - available' 
	AND PspAliquotMaster.in_stock IN ('yes - available', 'yes - not available')";
$barcodes = getSelectQueryResult($query);
$aliquot_ids = array();
foreach($barcodes as $new_aliquot) {
	$aliquot_ids[] = $new_aliquot['id'];
	$aliquot_ids[] = $new_aliquot['psp_id'];
}
if($aliquot_ids) {
    createBatchsetAndMessage(
        "'Transferred aliquot' with in stock data conflict",
        $aliquot_ids,
        'ViewAliquot',
        'Aliquots',
        '@@WARNING@@',
        "The transferred aliquots are flagged as 'In Stock' both in 'ATiM-PS3' and ATim of another bank.");
}

$query = "SELECT BankAliquotMaster.id, BankAliquotMaster.barcode, BankAliquotMaster.procure_created_by_bank
	FROM aliquot_masters BankAliquotMaster, realiquotings TransferLink, aliquot_masters PspAliquotMaster
	WHERE TransferLink.procure_central_is_transfer = '1' AND BankAliquotMaster.id = TransferLink.parent_aliquot_master_id AND PspAliquotMaster.id = TransferLink.child_aliquot_master_id 
	AND BankAliquotMaster.in_stock = 'yes - not available' 
	AND PspAliquotMaster.in_stock IN ('yes - available', 'yes - not available')";
$barcodes = getSelectQueryResult($query);
$aliquot_ids = array();
foreach($barcodes as $new_aliquot) {
    $aliquot_ids = $new_aliquot['id'];
}
if($aliquot_ids) {
    createBatchsetAndMessage(
        "'Transferred Aliquot' in stock warning",
        $aliquot_ids,
        'ViewAliquot',
        'Aliquots',
        '@@WARNING@@',
        "The transferred aliquots are flagged as 'In Stock' in 'ATiM-PS3' and 'In Stock but Not Available' in an ATiM of a bank.");
}

// Check all transferred aliquots are defined as 'sent to processing site' in bank

$query = "SELECT BankAliquotMaster.id, BankAliquotMaster.barcode, BankAliquotMaster.procure_created_by_bank
	FROM aliquot_masters BankAliquotMaster, realiquotings TransferLink
	WHERE TransferLink.procure_central_is_transfer = '1' AND BankAliquotMaster.id = TransferLink.parent_aliquot_master_id
	AND BankAliquotMaster.id NOT IN (SELECT aliquot_master_id FROM aliquot_internal_uses WHERE type = 'sent to processing site ps3' AND deleted <> 1)";
$barcodes = getSelectQueryResult($query);
$aliquot_ids = array();
foreach($barcodes as $new_aliquot) {
	$aliquot_ids[$new_aliquot['procure_created_by_bank']][] = $new_aliquot['id'];
}
if($aliquot_ids) {
    foreach($aliquot_ids as $bank_id => $aliquot_ids) {
        createBatchsetAndMessage(
            "Missing 'Sent to Processing Site' in PS$bank_id",
            $aliquot_ids,
            'ViewAliquot',
            'Aliquots',
            '@@WARNING@@',
            "Missing 'Sent to Processing Site' information in 'PS$bank_id-ATiM' for 'Transferred Aliquots'.");
    }
}

// Check all transferred aliquots are defined as 'received from bank' in processing site

$query = "SELECT PspAliquotMaster.id, PspAliquotMaster.barcode, PspAliquotMaster.procure_created_by_bank
	FROM aliquot_masters PspAliquotMaster, realiquotings TransferLink
	WHERE TransferLink.procure_central_is_transfer = '1' AND PspAliquotMaster.id = TransferLink.child_aliquot_master_id
	AND PspAliquotMaster.id NOT IN (SELECT aliquot_master_id FROM aliquot_internal_uses WHERE type = 'received from bank' AND deleted <> 1)";
$barcodes = getSelectQueryResult($query);
$aliquot_ids = array();
foreach($barcodes as $new_aliquot) {
	$aliquot_ids[$new_aliquot['procure_created_by_bank']][] = $new_aliquot['id'];
}
if($aliquot_ids) {
    foreach($aliquot_ids as $bank_id => $aliquot_ids) {
        createBatchsetAndMessage(
            "Missing ''Received From Bank' (PS$bank_id)",
            $aliquot_ids,
            'ViewAliquot',
            'Aliquots',
            '@@WARNING@@',
            "Missing 'Received From Bank' information in 'ATiM-PS3' for 'Transferred Aliquots' from PS$bank_id.");
    }
}

// Check only transferred aliquots are defined as 'sent to processing site' in bank

$query = "SELECT aliquot_masters.id, aliquot_masters.barcode, aliquot_masters.procure_created_by_bank
	FROM aliquot_internal_uses, aliquot_masters
	WHERE aliquot_masters.id = aliquot_internal_uses.aliquot_master_id 
	AND aliquot_internal_uses.type = 'sent to processing site ps3' 
	AND aliquot_masters.deleted <> 1 AND aliquot_internal_uses.deleted <> 1
	AND aliquot_masters.id NOT IN (
		SELECT BankAliquotMaster.id
		FROM aliquot_masters BankAliquotMaster, realiquotings TransferLink
		WHERE TransferLink.procure_central_is_transfer = '1' AND BankAliquotMaster.id = TransferLink.parent_aliquot_master_id)";	
$barcodes = getSelectQueryResult($query);
$aliquot_ids = array();
foreach($barcodes as $new_aliquot) {
	$aliquot_ids[$new_aliquot['procure_created_by_bank']][] = $new_aliquot['id'];
}
if($aliquot_ids) {
    foreach($aliquot_ids as $bank_id => $aliquot_ids) {
        if($bank_id != 3) {
            createBatchsetAndMessage(
                "Untransferred alq. flagged as 'transf.' in PS$bank_id",
                $aliquot_ids,
                'ViewAliquot',
                'Aliquots',
                '@@WARNING@@',
                "Aliquots are linked to an interal use 'Sent to Processing Site' in 'ATiM-PS$bank_id' but are not a 'Transferred Aliquots'.");
        }
    }
}

// Check only transferred aliquots are defined as 'received from bank' in processing site
// Note: Check done in bank

// Count the number of transferred aliquot available in bank

$query = "SELECT count(*) AS nbr, BankAliquotMaster.procure_created_by_bank, BankAliquotControl.databrowser_label
	FROM aliquot_masters BankAliquotMaster, aliquot_controls BankAliquotControl, realiquotings TransferLink
	WHERE TransferLink.procure_central_is_transfer = '1' 
	AND BankAliquotMaster.id = TransferLink.parent_aliquot_master_id
	AND BankAliquotControl.id = BankAliquotMaster.aliquot_control_id
	AND BankAliquotMaster.in_stock IN ('yes - available', 'yes - not available')
	GROUP BY BankAliquotMaster.procure_created_by_bank,  BankAliquotControl.databrowser_label
	ORDER BY BankAliquotMaster.procure_created_by_bank, BankAliquotControl.databrowser_label";
$available_transferred_aliquot_count = getSelectQueryResult($query);
foreach($available_transferred_aliquot_count as $new_count) {
	recordErrorAndMessage(
	    'Participants', 
		'@@WARNING@@', 
		"Nbr of 'Transferred Aliquots' flagged as 'In stock' in 'PS".$new_count['procure_created_by_bank']."'. Aliquot should not be in stock in bank.",
		$new_count['nbr'].' '.str_replace('|', ' ', $new_count['databrowser_label'])."' in 'PS".$new_count['procure_created_by_bank']."'");
}

//**********************************************************************************************************************************************************************************************
//
// FINAL PROCESSES
//
//**********************************************************************************************************************************************************************************************

$batch_set_queries = array();
$batch_set_queries[] = "DROP TABLE IF EXISTS procure_tmp_datamart_batch_sets;";
$batch_set_queries[] = "DROP TABLE IF EXISTS procure_tmp_datamart_batch_ids;";
foreach($batch_set_queries as $new_query) customQuery($new_query);

// Add site/bank as root to any root storages 

$query = "INSERT INTO storage_controls (storage_type, display_x_size, display_y_size, reverse_x_numbering, reverse_y_numbering, horizontal_increment, set_temperature, is_tma_block, flag_active, detail_form_alias, detail_tablename, databrowser_label, check_conflicts) VALUES
	('site', 0, 0, 0, 0, 1, 1, 0, 1, 'std_rooms', 'std_rooms', 'custom#storage types#site', 1);";
$storage_control_id = customQuery($query, true);
$atim_control_id = getSelectQueryResult("SELECT id FROM structure_permissible_values_custom_controls WHERE name = 'Storage Types'");
if(!($atim_control_id && $atim_control_id['0']['id'])) mergeDie('ERR_MISSING_STORAGE_TYPE_VALUES_CONTROL');
$atim_control_id = $atim_control_id['0']['id'];
$query = "INSERT INTO structure_permissible_values_customs (value, en, fr, use_as_input, control_id, created, created_by, modified, modified_by) 
    VALUES 
    ('site', 'Site', 'Site', 1, $atim_control_id, NOW(), 1, NOW(), 1)";
customQuery($query);

foreach($bank_databases as $site => $site_schema) {
	//New Bank
	$site_code = str_replace('PS', '', $site);
	$query = "INSERT INTO storage_masters (code,storage_control_id,short_label,created,created_by,modified,modified_by)  VALUES ('ps$site_code', $storage_control_id, '$site_code', '$import_date', $imported_by, '$import_date', $imported_by);";
	$storage_master_id = customQuery($query, true);
	$query = "INSERT INTO std_rooms (storage_master_id) VALUES ($storage_master_id);";
	customQuery($query, true);
	$query = "UPDATE storage_masters SET parent_id = $storage_master_id, modified = '$import_date', modified_by = $imported_by WHERE parent_id IS NULL AND code LIKE '$site_code#%'";
	customQuery($query, true);
	//NOTE: Won't update revs table
}

updateStorageLftRghtAndLabel();

// views update

$views = array(
	'view_collections' => $collection_table_query,
	'view_samples' => $sample_table_query,
	'view_aliquots' => $aliquot_table_query,
	'view_aliquot_uses' => $use_table_query);
foreach($views as $table_name => $table_query) {
	$all_table_queries = explode('UNION ALL', $table_query);
	customQuery("TRUNCATE $table_name;", true);
	foreach($all_table_queries as $new_query) {
		$new_query = str_replace('%%WHERE%%','',$new_query);
		customQuery("INSERT INTO $table_name ($new_query)");
	}
}

// End

$en_datetime = getSelectQueryResult("SELECT NOW() AS 'end_merge_process'");
$en_datetime = $en_datetime['0']['end_merge_process'];

customQuery("UPDATE procure_banks_data_merge_tries SET result = 'successful' WHERE datetime = '$import_date';");

dislayErrorAndMessage(true);

pr('<br>******************************************************************************************');
pr('PROCESS DONE '.$en_datetime);
pr('******************************************************************************************');

//**********************************************************************************************************************************************************************************************
//**********************************************************************************************************************************************************************************************

function createBatchsetAndMessage($batchset_title, $batchset_element_ids, $batchset_model, $msg_data_type, $msg_level, $msg_title) {
    $batchset_title = str_replace("'", "''", $batchset_title);
    customQuery("DELETE FROM procure_tmp_datamart_batch_ids WHERE set_id = (SELECT id FROM procure_tmp_datamart_batch_sets WHERE title = '$batchset_title')");
    customQuery("DELETE FROM procure_tmp_datamart_batch_sets WHERE title = '$batchset_title'");
    recordErrorAndMessage(
        $msg_data_type,
        $msg_level,
        $msg_title,
        "See ".sizeof($batchset_element_ids)." record(s) the batchset [$batchset_title]");
    createBatchSet($batchset_model, $batchset_title, $batchset_element_ids); 
}

function createTemporaryBatchsetAndMessage($batchset_title, $batchset_elements, $batchset_model, $msg_data_type, $msg_level, $msg_title) {
	global $imported_by;
	global $import_date;
	
    if(!empty($batchset_elements)) {
        if(!in_array($batchset_model, array('ViewAliquot', 'Participant'))) die('ERR createTemporaryPBatchsetAndMessage 74783883');
        $batchset_title = str_replace("'", "''", $batchset_title);
        customQuery("DELETE FROM procure_tmp_datamart_batch_ids WHERE set_id = (SELECT id FROM procure_tmp_datamart_batch_sets WHERE title = '$batchset_title')");
        customQuery("DELETE FROM procure_tmp_datamart_batch_sets WHERE title = '$batchset_title'");
        $procure_tmp_datamart_batch_set_max_id = getSelectQueryResult("SELECT MAX(id) AS id FROM procure_tmp_datamart_batch_sets;");
        $procure_tmp_datamart_batch_set_max_id = $procure_tmp_datamart_batch_set_max_id['0']['id'];
        $procure_tmp_datamart_batch_set_max_id++;
        $datamart_structure_id = getSelectQueryResult("SELECT id FROM datamart_structures WHERE model = '$batchset_model';");
        $datamart_structure_id = $datamart_structure_id['0']['id'];
        $batch_set_query = "INSERT INTO procure_tmp_datamart_batch_sets(`id`, `user_id`, `group_id`, `sharing_status`, `title`, `description`, `datamart_structure_id`, `created`, `created_by`, `modified`, `modified_by`)
            (SELECT $procure_tmp_datamart_batch_set_max_id, id, group_id, 'all', '$batchset_title', '### Merge Process BatchSet ###', $datamart_structure_id, '$import_date', $imported_by, '$import_date', $imported_by FROM users WHERE id = $imported_by);";
       customQuery($batch_set_query, true);
        foreach($batchset_elements as $new_element) {
            $new_element = str_replace("'", "''", $new_element);
            $query = "INSERT INTO procure_tmp_datamart_batch_ids (`set_id`, ".($batchset_model == 'Participant'? 'participant_identifier' : 'barcode').")
                VALUES ($procure_tmp_datamart_batch_set_max_id, '$new_element');";
            customQuery($query, true);
        } 
        recordErrorAndMessage(
            $msg_data_type,
            $msg_level,
            $msg_title,
            "See ".sizeof($batchset_elements)." record(s) into batchset [$batchset_title]");
    }
}

?>
		