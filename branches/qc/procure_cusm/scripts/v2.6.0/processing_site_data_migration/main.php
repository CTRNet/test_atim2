<?php

/**
 * Script developed to migrate data from PROCURE ATiM processing site to ATiM Cusm
 * 
 * @author Nicolas Luc
 */

//First Line of any main.php file
require_once 'system.php';
displayMigrationTitle('Data migration from ATiM ProcessingSite To ATiM CUSM', array());

$date_yyyy_mm_dd = substr($import_date, 0, 10);

$test_version = false;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $test_version = true;
        pr("<font color='red'>TEST VERSION</font>");
    } else {
        die('ERR ARG : '.$argv[1].' (should be test or nothing)');
    }
}

if($test_version) {
    
    $queries = array(
        "DELETE FROM view_aliquot_uses WHERE created LIKE '$date_yyyy_mm_dd%'",
        "DELETE FROM view_aliquot_uses WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM view_aliquots WHERE created LIKE '$date_yyyy_mm_dd%'",
        "DELETE FROM view_aliquots WHERE aliquot_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM view_collections WHERE created LIKE '$date_yyyy_mm_dd%'",
        "DELETE FROM view_collections WHERE collection_id IN (SELECT id FROM collections WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM view_samples WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM view_samples WHERE sample_master_id NOT IN (SELECT id FROM sample_masters)",
        
        "DELETE FROM order_items WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        "DELETE FROM shipments WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        "DELETE FROM orders WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        
        "DELETE FROM source_aliquots WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        "DELETE FROM aliquot_internal_uses WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        "DELETE FROM quality_ctrls WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        "DELETE FROM realiquotings WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        
        "DELETE FROM ad_tubes WHERE aliquot_master_id IN (SELECT id FROM aliquot_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM aliquot_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        
        "DELETE FROM derivative_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM specimen_details WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM sd_der_pbmcs WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM sd_der_dnas WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM sd_spe_bloods WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM sd_der_plasmas WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM sd_spe_urines WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM sd_der_urine_cents WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM sd_der_buffy_coats WHERE sample_master_id IN (SELECT id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        
        "UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        "DELETE FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        
        "DELETE FROM collections WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        
        "DELETE FROM view_storage_masters WHERE id IN (SELECT id FROM storage_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM std_boxs WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM std_racks WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "DELETE FROM std_rooms WHERE storage_master_id IN (SELECT id FROM storage_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')",
        "UPDATE storage_masters SET parent_id = null WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",
        "DELETE FROM storage_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",

        "DELETE FROM participants WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'",

        "DELETE FROM study_summaries WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'"

    );
    foreach($queries as $new_query) {
        customQuery($new_query);
    }
}

//=========================================================================================================================================
// Check Control Data
//=========================================================================================================================================

// Storrage

$query = "SELECT PsStorageControl.id PsStorageControl_id,
    PsStorageControl.storage_type PsStorageControl_storage_type,
    PsStorageControl.detail_tablename PsStorageControl_detail_tablename,
    CusmStorageControl.id CusmStorageControl_id,
    CusmStorageControl.storage_type CusmStorageControl_storage_type,
    CusmStorageControl.detail_tablename CusmStorageControl_detail_tablename
    FROM $processing_site_db_schema.storage_controls PsStorageControl
    LEFT JOIN $cusm_db_schema.storage_controls CusmStorageControl ON CusmStorageControl.storage_type = PsStorageControl.storage_type
    WHERE PsStorageControl.id IN (SELECT distinct storage_control_id FROM $processing_site_db_schema.storage_masters);";
foreach(getSelectQueryResult($query) as $new_storage_control) {
    if($new_storage_control['PsStorageControl_id'] != $new_storage_control['CusmStorageControl_id']
        || $new_storage_control['PsStorageControl_storage_type'] != $new_storage_control['CusmStorageControl_storage_type']
        || $new_storage_control['PsStorageControl_detail_tablename'] != $new_storage_control['CusmStorageControl_detail_tablename']) {
            pr($new_storage_control);
            die("ERR_LINE_".__LINE__);
        }
        if(!in_array($new_storage_control['PsStorageControl_detail_tablename'], array('std_boxs','std_racks'))) {
            // Only these 2 details tables  will be mirgated
            die("ERR_LINE_".__LINE__);
        }
}
$query = "SELECT DISTINCT PsStorageControl.detail_tablename
    FROM $processing_site_db_schema.storage_controls PsStorageControl
    INNER JOIN $processing_site_db_schema.storage_masters PsStorageMaster ON PsStorageMaster.storage_control_id = PsStorageControl.id
    WHERE PsStorageMaster.deleted <> 1";
foreach(getSelectQueryResult($query) as $new_storage_control_detail_tablename) {
    if(!in_array($new_storage_control_detail_tablename['detail_tablename'], array('std_boxs','std_racks'))) {
        // Only these 2 details tables  will be mirgated
        die("ERR_LINE_".__LINE__);
    }
}

// Sample

$query = "SELECT PsSampleControl.id PsSampleControl_id,
    PsSampleControl.sample_type PsSampleControl_sample_type,
    PsSampleControl.detail_tablename PsSampleControl_detail_tablename,
    CusmSampleControl.id CusmSampleControl_id,
    CusmSampleControl.sample_type CusmSampleControl_sample_type,
    CusmSampleControl.detail_tablename CusmSampleControl_detail_tablename
    FROM $processing_site_db_schema.sample_controls PsSampleControl
    LEFT JOIN $cusm_db_schema.sample_controls CusmSampleControl ON CusmSampleControl.sample_type = PsSampleControl.sample_type
    WHERE PsSampleControl.id IN (SELECT distinct sample_control_id FROM $processing_site_db_schema.sample_masters);";
foreach(getSelectQueryResult($query) as $new_sample_control) {
    if($new_sample_control['PsSampleControl_id'] != $new_sample_control['CusmSampleControl_id']
        || $new_sample_control['PsSampleControl_sample_type'] != $new_sample_control['CusmSampleControl_sample_type']
        || $new_sample_control['PsSampleControl_detail_tablename'] != $new_sample_control['CusmSampleControl_detail_tablename']) {
            pr($new_sample_control);
            die("ERR_LINE_".__LINE__);
    }
    if(!in_array($new_sample_control['PsSampleControl_detail_tablename'], array('sd_der_pbmcs', 'sd_der_dnas', 'sd_spe_bloods', 'sd_der_plasmas', 'sd_spe_urines', 'sd_der_urine_cents'))) {
        die("ERR_LINE_".__LINE__);
    }
}
$query = "SELECT DISTINCT PsSampleControl.detail_tablename
    FROM $processing_site_db_schema.sample_controls PsSampleControl
    INNER JOIN $processing_site_db_schema.sample_masters PsSampleMaster ON PsSampleMaster.sample_control_id = PsSampleControl.id
    WHERE PsSampleMaster.deleted <> 1";
foreach(getSelectQueryResult($query) as $new_sample_control_detail_tablename) {
    if(!in_array($new_sample_control_detail_tablename['detail_tablename'], array('sd_der_pbmcs', 'sd_der_dnas', 'sd_spe_bloods', 'sd_der_plasmas', 'sd_spe_urines', 'sd_der_urine_cents'))) {
        die("ERR_LINE_".__LINE__);
    }
}

// Aliquot

$query = "SELECT PsAliquotControl.id PsAliquotControl_id,
    PsAliquotControl.aliquot_type PsAliquotControl_aliquot_type,
    PsAliquotControl.detail_tablename PsAliquotControl_detail_tablename,
    PsAliquotControl.volume_unit PsAliquotControl_volume_unit,
    PsAliquotControl.flag_active PsAliquotControl_flag_active,
    CusmAliquotControl.id CusmAliquotControl_id,
    CusmAliquotControl.aliquot_type CusmAliquotControl_aliquot_type,
    CusmAliquotControl.detail_tablename CusmAliquotControl_detail_tablename,
    CusmAliquotControl.volume_unit CusmAliquotControl_volume_unit,
    CusmAliquotControl.flag_active CusmAliquotControl_flag_active
    FROM $processing_site_db_schema.aliquot_controls PsAliquotControl
    LEFT JOIN $cusm_db_schema.aliquot_controls CusmAliquotControl ON CusmAliquotControl.aliquot_type = PsAliquotControl.aliquot_type AND CusmAliquotControl.sample_control_id = PsAliquotControl.sample_control_id
    WHERE PsAliquotControl.id IN (SELECT distinct aliquot_control_id FROM $processing_site_db_schema.aliquot_masters);";
foreach(getSelectQueryResult($query) as $new_aliquot_control) {
    if($new_aliquot_control['PsAliquotControl_id'] != $new_aliquot_control['CusmAliquotControl_id']
        || $new_aliquot_control['PsAliquotControl_aliquot_type'] != $new_aliquot_control['CusmAliquotControl_aliquot_type']
        || $new_aliquot_control['PsAliquotControl_detail_tablename'] != $new_aliquot_control['CusmAliquotControl_detail_tablename']
        || $new_aliquot_control['PsAliquotControl_volume_unit'] != $new_aliquot_control['CusmAliquotControl_volume_unit']
        || $new_aliquot_control['PsAliquotControl_flag_active'] != $new_aliquot_control['CusmAliquotControl_flag_active']) {
            pr($new_aliquot_control);
            die("ERR_LINE_".__LINE__);
    }
    if(!in_array($new_aliquot_control['PsAliquotControl_detail_tablename'], array('ad_tubes'))) {
        // Only ad_tubes data will be transferred
        die("ERR_LINE_".__LINE__);  
    }
}

$query = "SELECT DISTINCT PsAliquotControl.detail_tablename
    FROM $processing_site_db_schema.aliquot_controls PsAliquotControl
    INNER JOIN $processing_site_db_schema.aliquot_masters PsAliquotMaster ON PsAliquotMaster.aliquot_control_id = PsAliquotControl.id
    WHERE PsAliquotMaster.deleted <> 1";
foreach(getSelectQueryResult($query) as $new_aliquot_control_detail_tablename) { 
    if(!in_array($new_aliquot_control_detail_tablename['detail_tablename'], array('ad_tubes'))) {
        // Only ad_tubes data will be transferred
        die("ERR_LINE_".__LINE__);  
    }
}
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "Storage control, sample control and aliquot control are compatible.");

//=========================================================================================================================================
// Create Processing Site Storage Into Cusm
//=========================================================================================================================================

$last_cusm_storage_master_id = getSelectQueryResult("SELECT MAX(id) FROM $cusm_db_schema.storage_masters;");
$last_cusm_storage_master_id = $last_cusm_storage_master_id[0]['MAX(id)'];
$last_cusm_storage_master_rght = getSelectQueryResult("SELECT MAX(rght) FROM $cusm_db_schema.storage_masters;");
$last_cusm_storage_master_rght = $last_cusm_storage_master_rght[0]['MAX(rght)'];
$last_ps_storage_master_rght = getSelectQueryResult("SELECT MAX(rght) FROM $processing_site_db_schema.storage_masters;");
$last_ps_storage_master_rght = $last_ps_storage_master_rght[0]['MAX(rght)'];

$room_short_label = 'P. Site';
$storage_data = array(
    'storage_masters' => array(
        'storage_control_id' => $atim_controls['storage_controls']['room']['id'],
        'code' => "tmp_0",
        'short_label' => $room_short_label,
        'selection_label' => $room_short_label,
        'lft' => ($last_cusm_storage_master_rght++),
        'rght' => ($last_cusm_storage_master_rght + $last_ps_storage_master_rght),
        'notes' => "Created by system to keep storagesof the 'Processing Site'"),
    $atim_controls['storage_controls']['room']['detail_tablename'] => array()
);
$room_storage_master_id = customInsertRecord($storage_data);
if($room_storage_master_id < $last_cusm_storage_master_id) die("ERR_LINE_".__LINE__);  
$value_to_increment_psp_storage_master_id = $room_storage_master_id;

$query = "INSERT INTO storage_masters (id, code, storage_control_id, parent_id, lft, rght,
    short_label, selection_label, storage_status, parent_storage_coord_x, parent_storage_coord_y, temperature, temp_unit, 
    notes, created, created_by, modified, modified_by)
    (SELECT (id+$value_to_increment_psp_storage_master_id), CONCAT('tmp_',code), storage_control_id, IFNULL((parent_id+$value_to_increment_psp_storage_master_id), $room_storage_master_id), (lft+$last_cusm_storage_master_rght), (rght+$last_cusm_storage_master_rght), 
    short_label, CONCAT('$room_short_label','-',selection_label), storage_status, parent_storage_coord_x, parent_storage_coord_y, temperature, temp_unit, 
    notes, '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.storage_masters);";
customQuery($query);
customQuery("INSERT INTO std_boxs (storage_master_id) (SELECT id FROM storage_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by' AND storage_control_id = ".$atim_controls['storage_controls']['box100']['id'].")");
customQuery("INSERT INTO std_racks (storage_master_id) (SELECT id FROM storage_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by' AND storage_control_id = ".$atim_controls['storage_controls']['rack20 (5X4)']['id'].")");
addToModifiedDatabaseTablesList('storage_masters', 'std_boxs');
addToModifiedDatabaseTablesList('storage_masters', 'std_racks');

$created_storages_nbr = getSelectQueryResult("SELECT count(*) as nbrst FROM storage_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_storages_nbr = $created_storages_nbr[0]['nbrst'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_storages_nbr storages");

//=========================================================================================================================================
// Import Processing Site Study Into Cusm
//=========================================================================================================================================

if(getSelectQueryResult("select * from study_summaries")) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No study exists into CUSM Site database. All new studies will be imported from Processing Site database.");

$query = "INSERT INTO study_summaries (id, title, deleted, created, created_by, modified, modified_by, procure_created_by_bank)
    (SELECT id, title, deleted, '$import_date', $imported_by, '$import_date', $imported_by, '$procure_cusm_ps_numer'
    FROM $processing_site_db_schema.study_summaries)";
customQuery($query);
addToModifiedDatabaseTablesList('study_summaries', null);

$created_recd_nbr = getSelectQueryResult("SELECT count(*) as nbrrcd FROM study_summaries WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_recd_nbr = $created_recd_nbr[0]['nbrrcd'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_recd_nbr studies");

//=========================================================================================================================================
// Import participants + collections of non-PS3 patients FROM Processing Site Study Into Cusm
//=========================================================================================================================================

// Check no participant != PS3 are in cusm

$query = "SELECT participant_identifier FROM $cusm_db_schema.participants WHERE deleted <> 1 AND participant_identifier NOT LIKE 'PS3%';";
if(getSelectQueryResult($query)) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No participant with PS number different than 3 exit into CUSM Site database. All new participant different than PS3 will be imported from Processing Site database.");

// Create non-PS3 participant

$value_to_increment_non_ps3_psp_participant_id = getSelectQueryResult("SELECT MAX(id) FROM $cusm_db_schema.participants;");
$value_to_increment_non_ps3_psp_participant_id = $value_to_increment_non_ps3_psp_participant_id[0]['MAX(id)'];

$query = "INSERT INTO participants(id, participant_identifier, last_modification, procure_transferred_participant, notes, 
    procure_last_modification_by_bank, procure_participant_attribution_number,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT (id+$value_to_increment_non_ps3_psp_participant_id), participant_identifier, '$import_date', 'n', 'Created by system to migrate data from ATiM Processing Site on $date_yyyy_mm_dd.', 
    '$procure_cusm_ps_numer', procure_participant_attribution_number,
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.participants
    WHERE participant_identifier NOT LIKE 'PS3%')";
customQuery($query);
addToModifiedDatabaseTablesList('participants', null);

$created_participant_nbr = getSelectQueryResult("SELECT count(*) as nbrp FROM participants WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_participant_nbr = $created_participant_nbr[0]['nbrp'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_participant_nbr participants");

// Create non-PS3 collections

$value_to_increment_psp_collection_id = getSelectQueryResult("SELECT MAX(id) FROM $cusm_db_schema.collections;");
$value_to_increment_psp_collection_id = $value_to_increment_psp_collection_id[0]['MAX(id)'];

$query = "INSERT INTO collections (id, participant_id, collection_notes, 
    collection_property, procure_visit, procure_collected_by_bank,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT (id+$value_to_increment_psp_collection_id), (participant_id+$value_to_increment_non_ps3_psp_participant_id), 'Created by system to migrate data from ATiM Processing Site on $date_yyyy_mm_dd.', 
    collection_property, procure_visit, procure_collected_by_bank,
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.collections 
    WHERE participant_id IN (SELECT id FROM $processing_site_db_schema.participants WHERE participant_identifier NOT LIKE 'PS3%'))";
customQuery($query);
addToModifiedDatabaseTablesList('collections', null);

$created_collections_nbr = getSelectQueryResult("SELECT count(*) as nbrp FROM collections WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_collections_nbr = $created_collections_nbr[0]['nbrp'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_collections_nbr collections");

//=========================================================================================================================================
// Update procure_participant_attribution_number of PS3 participants
//=========================================================================================================================================

// Check all PS3 participants in ProcessingSite are in Cusm

$query = "SELECT participant_identifier
FROM $processing_site_db_schema.participants
WHERE deleted <> 1
AND participant_identifier NOT IN (SELECT participant_identifier FROM $cusm_db_schema.participants WHERE deleted <> 1)
AND participant_identifier LIKE 'PS3%';";
if(getSelectQueryResult($query)) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "All PS3 participants of the Processing Site database exist into CUSM Site database.");

// Check all PS3 participants in ProcessingSite are in Cusm

$query = "UPDATE participants CusmParticipant, $processing_site_db_schema.participants ProcessingSiteParticipant
    SET CusmParticipant.procure_participant_attribution_number = ProcessingSiteParticipant.procure_participant_attribution_number,
    CusmParticipant.modified = '$import_date', 
    CusmParticipant.modified_by = $imported_by
    WHERE CusmParticipant.deleted <> 1
    AND ProcessingSiteParticipant.deleted <> 1
    AND CusmParticipant.participant_identifier = ProcessingSiteParticipant.participant_identifier
    AND ProcessingSiteParticipant.participant_identifier LIKE 'PS3%'
    AND ProcessingSiteParticipant.participant_identifier IS NOT NULL;";
customQuery($query);
addToModifiedDatabaseTablesList('participants', null);

$updated_attribution_number_nbr = getSelectQueryResult("SELECT count(*) as nbrp FROM participants WHERE deleted <> 1 AND participant_identifier LIKE 'PS3%' AND procure_participant_attribution_number IS NOT NULL");
$updated_attribution_number_nbr = $updated_attribution_number_nbr[0]['nbrp'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of updated elements.", "Updated $updated_attribution_number_nbr PS3 participants with the 'procure_participant_attribution_number'");

//=========================================================================================================================================
// Import collections of PS3 patients (check all collections are linked to participants)
//=========================================================================================================================================

// Check all collections in ProcessingSite are linked to participant

$query = "SELECT count(*) as nbr FROM $processing_site_db_schema.collections WHERE deleted <> 1 AND participant_id IS NULL;";
$counter = getSelectQueryResult($query);
if($counter[0]['nbr']) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "All collections of the Processing Site database are linked to a participant.");

$query = "INSERT INTO collections (id,
    collection_notes,
    collection_property, procure_visit, procure_collected_by_bank,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT (collections.id+$value_to_increment_psp_collection_id),
    CONCAT('Temporary collection created by system to migrate data from ATiM Processing Site on $date_yyyy_mm_dd.', CONCAT(' For participant ', participant_identifier, '.')),
    collection_property, procure_visit, procure_collected_by_bank,
    collections.deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.collections LEFT JOIN $processing_site_db_schema.participants ON participants.id = collections.participant_id
    WHERE participant_id IN (SELECT id FROM $processing_site_db_schema.participants WHERE participant_identifier LIKE 'PS3%'))";
customQuery($query);
addToModifiedDatabaseTablesList('collections', null);

$created_collections_nbr = getSelectQueryResult("SELECT count(*) as nbrp FROM collections WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by' AND collection_notes LIKE 'Temporary collection created by system to migrate data from AT%'");
$created_collections_nbr = $created_collections_nbr[0]['nbrp'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_collections_nbr temprorary PS3 collections");

//=========================================================================================================================================
// Import all samples
//=========================================================================================================================================

$value_to_increment_psp_sample_master_id = getSelectQueryResult("SELECT MAX(id) FROM $cusm_db_schema.sample_masters;");
$value_to_increment_psp_sample_master_id = $value_to_increment_psp_sample_master_id[0]['MAX(id)'];

customQuery("UPDATE $processing_site_db_schema.sample_masters SET procure_created_by_bank = 's' WHERE procure_created_by_bank IN ('1', '2', '3', '4')");
    
$query = "INSERT INTO sample_masters(id, sample_code, sample_control_id, initial_specimen_sample_id, initial_specimen_sample_type,
    collection_id, parent_id, parent_sample_type, notes,
    procure_created_by_bank,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT (id+$value_to_increment_psp_sample_master_id), CONCAT('tmp_',sample_code), sample_control_id, (initial_specimen_sample_id+$value_to_increment_psp_sample_master_id), initial_specimen_sample_type,
    (collection_id+$value_to_increment_psp_collection_id), (parent_id+$value_to_increment_psp_sample_master_id), parent_sample_type, IFNULL(CONCAT('Data from ATiM Processing Site on $date_yyyy_mm_dd. ', notes), 'Data from ATiM Processing Site on $date_yyyy_mm_dd.'),
    procure_created_by_bank,
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.sample_masters)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', null);

$query = "INSERT INTO specimen_details(sample_master_id, supplier_dept, time_at_room_temp_mn, reception_by, reception_datetime, reception_datetime_accuracy, procure_refrigeration_time)
(SELECT (sample_master_id+$value_to_increment_psp_sample_master_id), supplier_dept, time_at_room_temp_mn, reception_by, reception_datetime, reception_datetime_accuracy, procure_refrigeration_time
FROM $processing_site_db_schema.specimen_details)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', 'specimen_details');

$query = "INSERT INTO derivative_details(sample_master_id, creation_site, creation_by, creation_datetime, creation_datetime_accuracy)
(SELECT (sample_master_id+$value_to_increment_psp_sample_master_id), creation_site, creation_by, creation_datetime, creation_datetime_accuracy
FROM $processing_site_db_schema.derivative_details)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', 'derivative_details');

$query = "INSERT INTO sd_spe_bloods (sample_master_id, blood_type, collected_tube_nbr, collected_volume, collected_volume_unit, procure_collection_site, procure_deprecated_field_collection_without_incident, procure_deprecated_field_tubes_inverted_8_10_times, procure_deprecated_field_tubes_correclty_stored)
(SELECT (sample_master_id+$value_to_increment_psp_sample_master_id), blood_type, collected_tube_nbr, collected_volume, collected_volume_unit, procure_collection_site, procure_collection_without_incident, procure_tubes_inverted_8_10_times, procure_tubes_correclty_stored
FROM $processing_site_db_schema.sd_spe_bloods)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', 'sd_spe_bloods');

$query = "INSERT INTO sd_der_pbmcs (sample_master_id)
(SELECT (sample_master_id+$value_to_increment_psp_sample_master_id)
FROM $processing_site_db_schema.sd_der_pbmcs)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', 'sd_der_pbmcs');

$query = "INSERT INTO sd_der_plasmas (sample_master_id)
(SELECT (sample_master_id+$value_to_increment_psp_sample_master_id)
FROM $processing_site_db_schema.sd_der_plasmas)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', 'sd_der_plasmas');

$query = "INSERT INTO sd_der_dnas (sample_master_id)
(SELECT (sample_master_id+$value_to_increment_psp_sample_master_id)
FROM $processing_site_db_schema.sd_der_dnas)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', 'sd_der_dnas');

$query = "INSERT INTO sd_spe_urines (sample_master_id, urine_aspect, collected_volume, collected_volume_unit, pellet_signs, pellet_volume, pellet_volume_unit, procure_other_urine_aspect, procure_hematuria, procure_collected_via_catheter)
(SELECT (sample_master_id+$value_to_increment_psp_sample_master_id), urine_aspect, collected_volume, collected_volume_unit, pellet_signs, pellet_volume, pellet_volume_unit, procure_other_urine_aspect, procure_hematuria, procure_collected_via_catheter
FROM $processing_site_db_schema.sd_spe_urines)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', 'sd_spe_urines');

$query = "INSERT INTO sd_der_urine_cents (sample_master_id, procure_deprecated_field_processed_at_reception, procure_deprecated_field_conserved_at_4, procure_deprecated_field_time_at_4, procure_deprecated_field_aspect_after_refrigeration,
procure_deprecated_field_other_aspect_after_refrigeration, procure_deprecated_field_aspect_after_centrifugation, procure_deprecated_field_other_aspect_after_centrifugation,
procure_pellet_aspect_after_centrifugation, procure_other_pellet_aspect_after_centrifugation, procure_approximatif_pellet_volume_ml,
procure_deprecated_field_procure_pellet_volume_ml, procure_concentrated)
(SELECT (sample_master_id+$value_to_increment_psp_sample_master_id), procure_processed_at_reception, procure_conserved_at_4, procure_time_at_4, procure_aspect_after_refrigeration,
procure_other_aspect_after_refrigeration, procure_aspect_after_centrifugation, procure_other_aspect_after_centrifugation,
procure_pellet_aspect_after_centrifugation, procure_other_pellet_aspect_after_centrifugation, procure_approximatif_pellet_volume_ml,
procure_pellet_volume_ml, procure_concentrated
FROM $processing_site_db_schema.sd_der_urine_cents)";
customQuery($query);
addToModifiedDatabaseTablesList('sample_masters', 'sd_der_urine_cents');

$created_samples_nbr = getSelectQueryResult("SELECT count(*) as nbrp FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_samples_nbr = $created_samples_nbr[0]['nbrp'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_samples_nbr samples");

//=========================================================================================================================================
// Import Aliquots + QC + ....
//=========================================================================================================================================

$value_to_increment_non_ps3_psp_aliquot_master_id = getSelectQueryResult("SELECT MAX(id) FROM $cusm_db_schema.aliquot_masters;");
$value_to_increment_non_ps3_psp_aliquot_master_id = $value_to_increment_non_ps3_psp_aliquot_master_id[0]['MAX(id)'];

$query = "INSERT INTO aliquot_masters(id, barcode, aliquot_label, aliquot_control_id, collection_id, sample_master_id, sop_master_id,
    initial_volume, current_volume, in_stock, in_stock_detail, use_counter,
    study_summary_id, storage_datetime, storage_datetime_accuracy, storage_master_id, storage_coord_x, storage_coord_y, product_code,
    notes, procure_created_by_bank,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT (id+$value_to_increment_non_ps3_psp_aliquot_master_id), barcode, aliquot_label, aliquot_control_id, (collection_id+$value_to_increment_psp_collection_id), (sample_master_id+$value_to_increment_psp_sample_master_id), sop_master_id,
    initial_volume, current_volume, in_stock, in_stock_detail, use_counter,
    study_summary_id, storage_datetime, storage_datetime_accuracy, (storage_master_id+$value_to_increment_psp_storage_master_id), storage_coord_x, storage_coord_y, product_code,
    IFNULL(CONCAT('Data from ATiM Processing Site on $date_yyyy_mm_dd. ', notes), 'Data from ATiM Processing Site on $date_yyyy_mm_dd.'), procure_created_by_bank,
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.aliquot_masters)";
customQuery($query);
addToModifiedDatabaseTablesList('aliquot_masters', '');

$query = "INSERT INTO ad_tubes(aliquot_master_id, lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, procure_deprecated_field_expiration_date,
    procure_tube_weight_gr, procure_total_quantity_ug, procure_concentration_nanodrop, procure_concentration_unit_nanodrop, procure_total_quantity_ug_nanodrop)
    (SELECT (aliquot_master_id+$value_to_increment_non_ps3_psp_aliquot_master_id), lot_number, concentration, concentration_unit, cell_count, cell_count_unit, cell_viability, hemolysis_signs, procure_expiration_date,
    procure_tube_weight_gr, procure_total_quantity_ug, procure_concentration_nanodrop, procure_concentration_unit_nanodrop, procure_total_quantity_ug_nanodrop
    FROM $processing_site_db_schema.ad_tubes)";
customQuery($query);
addToModifiedDatabaseTablesList('aliquot_masters', 'ad_tubes');

$created_recd_nbr = getSelectQueryResult("SELECT count(*) as nbrrcd FROM aliquot_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_recd_nbr = $created_recd_nbr[0]['nbrrcd'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_recd_nbr aliquots");

$query = "INSERT INTO realiquotings(parent_aliquot_master_id, child_aliquot_master_id, parent_used_volume, realiquoting_datetime, realiquoting_datetime_accuracy,
    realiquoted_by, lab_book_master_id, sync_with_lab_book, procure_central_is_transfer,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT (parent_aliquot_master_id+$value_to_increment_non_ps3_psp_aliquot_master_id), (child_aliquot_master_id+$value_to_increment_non_ps3_psp_aliquot_master_id), parent_used_volume, realiquoting_datetime, realiquoting_datetime_accuracy,
    realiquoted_by, lab_book_master_id, sync_with_lab_book, procure_central_is_transfer,
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM  $processing_site_db_schema.realiquotings)";
customQuery($query);
addToModifiedDatabaseTablesList('realiquotings', null);

$query = "INSERT INTO source_aliquots(sample_master_id, aliquot_master_id, used_volume,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT (sample_master_id+$value_to_increment_psp_sample_master_id), (aliquot_master_id+$value_to_increment_non_ps3_psp_aliquot_master_id), used_volume,
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM  $processing_site_db_schema.source_aliquots)";
customQuery($query);
addToModifiedDatabaseTablesList('source_aliquots', null);

$query = "INSERT INTO aliquot_internal_uses (aliquot_master_id, type, use_code, use_details, used_volume, use_datetime, use_datetime_accuracy, duration,
    duration_unit, used_by, study_summary_id, procure_created_by_bank,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT (aliquot_master_id+$value_to_increment_non_ps3_psp_aliquot_master_id), type, use_code, IFNULL(CONCAT('Data from ATiM Processing Site on $date_yyyy_mm_dd. ', use_details), 'Data from ATiM Processing Site on $date_yyyy_mm_dd.'), used_volume, use_datetime, use_datetime_accuracy, duration,
    duration_unit, used_by, study_summary_id, '$procure_cusm_ps_numer',
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM  $processing_site_db_schema.aliquot_internal_uses)";
customQuery($query);
addToModifiedDatabaseTablesList('aliquot_internal_uses', null);

$created_recd_nbr = getSelectQueryResult("SELECT count(*) as nbrrcd FROM aliquot_internal_uses WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_recd_nbr = $created_recd_nbr[0]['nbrrcd'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_recd_nbr aliquot uses/events");

$query = "INSERT INTO quality_ctrls(qc_code, sample_master_id, type, qc_type_precision, tool,
    run_id, run_by, date, date_accuracy, score, unit, conclusion, notes, aliquot_master_id, used_volume, procure_appended_spectras, procure_analysis_by, procure_created_by_bank, procure_concentration, procure_concentration_unit,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT CONCAT('tmp_',qc_code), (sample_master_id+$value_to_increment_psp_sample_master_id), type, qc_type_precision, tool,
    run_id, run_by, date, date_accuracy, score, unit, conclusion, IFNULL(CONCAT('Data from ATiM Processing Site on $date_yyyy_mm_dd. ', notes), 'Data from ATiM Processing Site on $date_yyyy_mm_dd.'),
    (aliquot_master_id+$value_to_increment_non_ps3_psp_aliquot_master_id), used_volume, procure_appended_spectras, procure_analysis_by, '$procure_cusm_ps_numer', procure_concentration, procure_concentration_unit,
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM  $processing_site_db_schema.quality_ctrls)";
customQuery($query);
addToModifiedDatabaseTablesList('quality_ctrls', null);

$created_recd_nbr = getSelectQueryResult("SELECT count(*) as nbrrcd FROM quality_ctrls WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_recd_nbr = $created_recd_nbr[0]['nbrrcd'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_recd_nbr quality controls");

$query = "SELECT count(*) nbr FROM specimen_review_masters;";
$counter = getSelectQueryResult($query);
if($counter[0]['nbr']) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No Specimen Review exists into the Processing Site database.");

$query = "SELECT count(*) nbr FROM aliquot_review_masters;";
$counter = getSelectQueryResult($query);
if($counter[0]['nbr']) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No Aliquot Review exists into the Processing Site database.");

$query = "SELECT count(*) nbr FROM tma_slides;";
$counter = getSelectQueryResult($query);
if($counter[0]['nbr']) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No TMA Slide exists into the Processing Site database.");

//=========================================================================================================================================
// Import Order
//=========================================================================================================================================

if(getSelectQueryResult("select * from orders")) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No order exists into the CUSM Site database.");

$query = "INSERT INTO orders (id, order_number, short_title, description, date_order_placed, date_order_placed_accuracy, date_order_completed,
    date_order_completed_accuracy, processing_status,
    comments,
    default_study_summary_id, institution, contact, default_required_date, default_required_date_accuracy, procure_created_by_bank,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT id, order_number, short_title, description, date_order_placed, date_order_placed_accuracy, date_order_completed,
    date_order_completed_accuracy, processing_status,
    IFNULL(CONCAT('Data from ATiM Processing Site on $date_yyyy_mm_dd. ', comments), 'Data from ATiM Processing Site on $date_yyyy_mm_dd.'),
    default_study_summary_id, institution, contact, default_required_date, default_required_date_accuracy, '$procure_cusm_ps_numer',
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.orders)";
customQuery($query);
addToModifiedDatabaseTablesList('orders', null);

$query = "INSERT INTO shipments (id, shipment_code, recipient, facility, delivery_street_address, delivery_city,
    delivery_province, delivery_postal_code, delivery_country, delivery_phone_number, delivery_department_or_door,
    delivery_notes, shipping_company, shipping_account_nbr, tracking, datetime_shipped, datetime_shipped_accuracy,
    datetime_received, datetime_received_accuracy, shipped_by, procure_shipping_conditions, procure_created_by_bank, order_id,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT id, shipment_code, recipient, facility, delivery_street_address, delivery_city,
    delivery_province, delivery_postal_code, delivery_country, delivery_phone_number, delivery_department_or_door,
    delivery_notes, shipping_company, shipping_account_nbr, tracking, datetime_shipped, datetime_shipped_accuracy,
    datetime_received, datetime_received_accuracy, shipped_by, procure_shipping_conditions, '$procure_cusm_ps_numer', order_id,
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.shipments)";
customQuery($query);
addToModifiedDatabaseTablesList('shipments', null);

$query = "INSERT INTO order_items (id, date_added, date_added_accuracy, added_by, status, order_line_id,
    shipment_id, aliquot_master_id, order_id, procure_shipping_aliquot_label,
    procure_created_by_bank,
    deleted,
    created, created_by, modified, modified_by)
    (SELECT id, date_added, date_added_accuracy, added_by, status, order_line_id,
    shipment_id, (aliquot_master_id+$value_to_increment_non_ps3_psp_aliquot_master_id), order_id, procure_shipping_aliquot_label,
    '$procure_cusm_ps_numer',
    deleted,
    '$import_date', $imported_by, '$import_date', $imported_by
    FROM $processing_site_db_schema.order_items)";
    customQuery($query);
addToModifiedDatabaseTablesList('order_items', null);

$created_recd_nbr = getSelectQueryResult("SELECT count(*) as nbrrcd FROM orders WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_recd_nbr = $created_recd_nbr[0]['nbrrcd'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_recd_nbr orders");

$created_recd_nbr = getSelectQueryResult("SELECT count(*) as nbrrcd FROM shipments WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'");
$created_recd_nbr = $created_recd_nbr[0]['nbrrcd'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_recd_nbr shipments");

//=========================================================================================================================================
// Change Processing Site sample type 'pbmc' to 'buffy coat' (revs table don't have to be managed at this level)
//=========================================================================================================================================

$bfc_sample_control_id = getSelectQueryResult("SELECT id FROM sample_controls WHERE sample_type = 'buffy coat'");
$bfc_sample_control_id = $bfc_sample_control_id[0]['id'];
$pbmc_sample_control_id = getSelectQueryResult("SELECT id FROM sample_controls WHERE sample_type = 'pbmc'");
$pbmc_sample_control_id = $pbmc_sample_control_id[0]['id'];
if(!$bfc_sample_control_id || !$pbmc_sample_control_id) die("ERR_LINE_".__LINE__);

$counter = getSelectQueryResult("SELECT count(*) as nbr
    FROM sample_masters SampleMasterFromProcessingSite
    WHERE SampleMasterFromProcessingSite.deleted <> 1
    AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
    AND SampleMasterFromProcessingSite.created_by = '$imported_by'
    AND SampleMasterFromProcessingSite.sample_control_id = $bfc_sample_control_id;");
$counter = $counter[0]['nbr'];
if($counter) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No buffy coat sample exists into the Processing Site database: PBMC samples recorded into Processing Site database will be mirgated as Buffy Coat into CUSM database.");
$counter = getSelectQueryResult("SELECT count(*) as nbr
    FROM sample_masters SampleMasterFromProcessingSite
    WHERE SampleMasterFromProcessingSite.deleted <> 1
    AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
    AND SampleMasterFromProcessingSite.created_by = '$imported_by'
    AND SampleMasterFromProcessingSite.sample_control_id = $pbmc_sample_control_id;");
$initial_processing_site_pbmc_counter = $counter[0]['nbr'];
$procure_blood_volume_used_ml = getSelectQueryResult("SELECT DISTINCT procure_blood_volume_used_ml from sd_der_pbmcs where procure_blood_volume_used_ml is not null AND sample_master_id IN (
    SELECT id FROM sample_masters SampleMasterFromProcessingSite
    WHERE SampleMasterFromProcessingSite.deleted <> 1
    AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
    AND SampleMasterFromProcessingSite.created_by = '$imported_by'
    AND SampleMasterFromProcessingSite.sample_control_id = $pbmc_sample_control_id);");
if($procure_blood_volume_used_ml) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No 'Blood volume' has been recorded into the Processing Site database for PBMC. Field won't be mirgated when script will create Buffy Coat from PBMC.");
    
$query = "INSERT INTO sd_der_buffy_coats (sample_master_id) 
    (SELECT sample_master_id 
    FROM sd_der_pbmcs
    WHERE sample_master_id IN (
        SELECT id FROM sample_masters SampleMasterFromProcessingSite
        WHERE SampleMasterFromProcessingSite.deleted <> 1
        AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
        AND SampleMasterFromProcessingSite.created_by = '$imported_by'
        AND SampleMasterFromProcessingSite.sample_control_id = $pbmc_sample_control_id
    ));";
customQuery($query);
$query = "DELETE FROM sd_der_pbmcs
    WHERE sample_master_id IN (
        SELECT id FROM sample_masters SampleMasterFromProcessingSite
        WHERE SampleMasterFromProcessingSite.deleted <> 1
        AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
        AND SampleMasterFromProcessingSite.created_by = '$imported_by'
        AND SampleMasterFromProcessingSite.sample_control_id = $pbmc_sample_control_id
    );";
customQuery($query);
$query = "UPDATE sample_masters
    SET sample_control_id = $bfc_sample_control_id
    WHERE sample_control_id = $pbmc_sample_control_id
    AND deleted <> 1
    AND created LIKE '$date_yyyy_mm_dd%'
    AND created_by = '$imported_by'";
customQuery($query);
$query = "UPDATE aliquot_masters
    SET aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'buffy coat' AND aliquot_type = 'tube')
    WHERE aliquot_control_id = (SELECT AlCt.id FROM sample_controls SpCt INNER JOIN aliquot_controls AlCt ON AlCt.sample_control_id = SpCt.id WHERE sample_type = 'pbmc' AND aliquot_type = 'tube')
    AND sample_master_id IN (
        SELECT id FROM sample_masters SampleMasterFromProcessingSite
        WHERE SampleMasterFromProcessingSite.deleted <> 1
        AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
        AND SampleMasterFromProcessingSite.created_by = '$imported_by'
        AND SampleMasterFromProcessingSite.sample_control_id = $bfc_sample_control_id
    );";
customQuery($query);
$query = "UPDATE sample_masters SET parent_sample_type = 'buffy coat' WHERE parent_id IN (
    SELECT tmp.id FROM (
            SELECT id FROM sample_masters SampleMasterFromProcessingSite
            WHERE SampleMasterFromProcessingSite.deleted <> 1
            AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
            AND SampleMasterFromProcessingSite.created_by = '$imported_by'
            AND SampleMasterFromProcessingSite.sample_control_id = $bfc_sample_control_id
        ) tmp
    )";
customQuery($query);

$counter = getSelectQueryResult("SELECT count(*) as nbr
    FROM sample_masters SampleMasterFromProcessingSite
    WHERE SampleMasterFromProcessingSite.deleted <> 1
    AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
    AND SampleMasterFromProcessingSite.created_by = '$imported_by'
    AND SampleMasterFromProcessingSite.sample_control_id = $bfc_sample_control_id;");
$counter = $counter[0]['nbr'];
if($counter != $initial_processing_site_pbmc_counter) die("ERR_LINE_".__LINE__);
$counter = getSelectQueryResult("SELECT count(*) as nbr
    FROM sample_masters SampleMasterFromProcessingSite
    WHERE SampleMasterFromProcessingSite.deleted <> 1
    AND SampleMasterFromProcessingSite.created LIKE '$date_yyyy_mm_dd%'
    AND SampleMasterFromProcessingSite.created_by = '$imported_by'
    AND SampleMasterFromProcessingSite.sample_control_id = $pbmc_sample_control_id;");
$counter = $counter[0]['nbr'];
if($counter) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "$initial_processing_site_pbmc_counter PBMC samples of the Processing Site database will be migrated as Buffy Coat into CUSM database.");

//=========================================================================================================================================
// Merge PS3 aliquots previously sent to the processing site
//=========================================================================================================================================

$query = "UPDATE collections CollectionProcessing, aliquot_masters AliquotMasterProcessing, sample_masters SampleMasterProcessing
    SET AliquotMasterProcessing.procure_created_by_bank = 'x'
    WHERE CollectionProcessing.deleted <> 1
    AND CollectionProcessing.participant_id IS NULL
    AND CollectionProcessing.collection_notes LIKE '%Temporary collection created by system to migrate data from ATiM Processing Site on $date_yyyy_mm_dd%'
    AND CollectionProcessing.created LIKE '$date_yyyy_mm_dd%'
    AND CollectionProcessing.created_by = '$imported_by'
    AND SampleMasterProcessing.procure_created_by_bank = 's'
    AND AliquotMasterProcessing.sample_master_id = SampleMasterProcessing.id
    AND AliquotMasterProcessing.collection_id = CollectionProcessing.id
    AND AliquotMasterProcessing.deleted <> 1
    AND AliquotMasterProcessing.created LIKE '$date_yyyy_mm_dd%'
    AND AliquotMasterProcessing.created_by = '$imported_by'
    AND AliquotMasterProcessing.procure_created_by_bank = '$procure_cusm_ps_numer'";
customQuery($query);

// All processing site aliquots received from PS3 are linked to an internaluse euqals to 'received from bank PS3'
$counter = getSelectQueryResult("SELECT count(*) as nbr
    FROM aliquot_masters
    WHERE procure_created_by_bank = 'x'
    AND id NOT IN (SELECT aliquot_master_id FROM aliquot_internal_uses WHERE deleted <> 1 AND type = 'received from bank' AND use_code = 'PS3')");
if($counter[0]['nbr']) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "All aliquots of the PS3 participants of Processing Site database and migrated into CUSM database are linked to an 'event' equal to 'received from bank PS3'.");

// All processing site aliquots received from PS3 are not in stock
$counter = getSelectQueryResult("SELECT count(*) as nbr
    FROM aliquot_masters AliquotMasterProcessing
    WHERE AliquotMasterProcessing.deleted <> 1
    AND AliquotMasterProcessing.procure_created_by_bank = 'x'
    AND AliquotMasterProcessing.in_stock != 'no'");
if($counter[0]['nbr']) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "All aliquots of the PS3 participants of Processing Site database and migrated into CUSM database have an in stock status equal to 'no'.");

// All processing site aliquots received from PS3 are not linked to a study
$counter = getSelectQueryResult("SELECT count(*) as nbr
    FROM aliquot_masters AliquotMasterProcessing
    WHERE AliquotMasterProcessing.deleted <> 1
    AND AliquotMasterProcessing.procure_created_by_bank = 'x'
    AND AliquotMasterProcessing.study_summary_id IS NOT NULL;");
if($counter[0]['nbr']) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "No aliquot of the PS3 participants of Processing Site database is linked to a study.");

// Two processing site aliquots received from PS3 are not linked to the same sample_master_id
$counter = getSelectQueryResult("SELECT count(*) as nbr2
    FROM (
        SELECT sample_master_id, count(*) as nbr
        FROM aliquot_masters AliquotMasterProcessing
        WHERE AliquotMasterProcessing.deleted <> 1
        AND AliquotMasterProcessing.procure_created_by_bank = 'x'
        GROUP BY sample_master_id
    ) Res
    WHERE Res.nbr > 1");
if($counter[0]['nbr2']) die("ERR_LINE_".__LINE__);
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Check(s) done.", "One sample has been created per aliquot of the PS3 participants of Processing Site database.");

// Merge code
$counter = getSelectQueryResult("SELECT count(*) as nbr
    FROM aliquot_masters
    WHERE procure_created_by_bank = 'x'");
$processing_site_ps3_aliquot_counter = $counter[0]['nbr'];
$merged_ps3_aliquot_counter = 0; 
$query = "SELECT AliquotMasterProcessing.collection_id as processing_collection_id, 
    AliquotMasterProcessing.sample_master_id as processing_sample_master_id,
    AliquotMasterProcessing.id as processing_aliquot_master_id,
    AliquotMasterProcessing.barcode as processing_barcode, 
    AliquotMasterProcessing.in_stock as processing_in_stock,
    AliquotMasterCusm.collection_id as cusm_collection_id, 
    SampleMasterCusm.initial_specimen_sample_id as cusm_initial_specimen_sample_id,
    SampleMasterCusm.initial_specimen_sample_type as cusm_initial_specimen_sample_type,
    AliquotMasterCusm.sample_master_id as cusm_sample_master_id, 
    SampleControlCusm.sample_type as cusm_sample_type, 
    AliquotMasterCusm.id as cusm_aliquot_master_id,
    AliquotMasterCusm.barcode as cusm_barcode, 
    AliquotMasterCusm.in_stock as cusm_in_stock
    FROM aliquot_masters AliquotMasterProcessing
    INNER JOIN aliquot_masters AliquotMasterCusm
        ON AliquotMasterCusm.deleted <> 1
        AND AliquotMasterCusm.procure_created_by_bank = '$procure_cusm_ps_numer'
        AND AliquotMasterProcessing.barcode = AliquotMasterCusm.barcode
        AND AliquotMasterProcessing.aliquot_control_id = AliquotMasterCusm.aliquot_control_id
    INNER JOIN sample_masters SampleMasterCusm
        ON SampleMasterCusm.id = AliquotMasterCusm.sample_master_id
        AND SampleMasterCusm.deleted <> 1
    INNER JOIN sample_controls SampleControlCusm
        ON SampleControlCusm.id = SampleMasterCusm.sample_control_id
    WHERE AliquotMasterProcessing.deleted <> 1
    AND AliquotMasterProcessing.procure_created_by_bank = 'x'";
foreach(getSelectQueryResult($query) as $new_aliquot_match) {
    // set variables
    $processing_collection_id = $new_aliquot_match['processing_collection_id'];
    $processing_sample_master_id = $new_aliquot_match['processing_sample_master_id'];
    $processing_aliquot_master_id = $new_aliquot_match['processing_aliquot_master_id'];
    $processing_barcode = $new_aliquot_match['processing_barcode'];
    $processing_in_stock = $new_aliquot_match['processing_in_stock'];
    
    $cusm_collection_id = $new_aliquot_match['cusm_collection_id'];
    $cusm_initial_specimen_sample_id = $new_aliquot_match['cusm_initial_specimen_sample_id'];
    $cusm_initial_specimen_sample_type = $new_aliquot_match['cusm_initial_specimen_sample_type'];
    $cusm_sample_master_id = $new_aliquot_match['cusm_sample_master_id'];
    $cusm_sample_type = $new_aliquot_match['cusm_sample_type'];
    $cusm_aliquot_master_id = $new_aliquot_match['cusm_aliquot_master_id'];
    $cusm_barcode = $new_aliquot_match['cusm_barcode'];
    $cusm_in_stock = $new_aliquot_match['cusm_in_stock'];

    // Manage processing site aliquot
    
    $queries = array(
        //All aliquots linked to the sample of the PS3 aliquot of the processing site will be linked to the cusm sample
        "UPDATE aliquot_masters SET collection_id = $cusm_collection_id, sample_master_id = $cusm_sample_master_id WHERE sample_master_id = $processing_sample_master_id;",
        "UPDATE quality_ctrls SET sample_master_id = $cusm_sample_master_id WHERE sample_master_id = $processing_sample_master_id;",
        "UPDATE quality_ctrls SET aliquot_master_id = $cusm_aliquot_master_id WHERE aliquot_master_id = $processing_aliquot_master_id;",
        "UPDATE realiquotings SET parent_aliquot_master_id = $cusm_aliquot_master_id WHERE parent_aliquot_master_id = $processing_aliquot_master_id;",
        "UPDATE realiquotings SET child_aliquot_master_id = $cusm_aliquot_master_id WHERE child_aliquot_master_id = $processing_aliquot_master_id;",
        "UPDATE order_items SET aliquot_master_id = $cusm_aliquot_master_id WHERE aliquot_master_id = $processing_aliquot_master_id;",
        "UPDATE aliquot_internal_uses SET aliquot_master_id = $cusm_aliquot_master_id WHERE aliquot_master_id = $processing_aliquot_master_id;",
        "UPDATE source_aliquots SET aliquot_master_id = $cusm_aliquot_master_id WHERE aliquot_master_id = $processing_aliquot_master_id;");
    foreach($queries as $tmp_query) customQuery($tmp_query);
    updateDerivatvieSamplesAndAliquots($cusm_collection_id, $cusm_initial_specimen_sample_id, $cusm_initial_specimen_sample_type, $processing_sample_master_id);
    customQuery("UPDATE sample_masters SET parent_id = $cusm_sample_master_id, parent_sample_type = '$cusm_sample_type' WHERE parent_id = $processing_sample_master_id;");
    customQuery("DELETE FROM ad_tubes WHERE aliquot_master_id = $processing_aliquot_master_id;");
    customQuery("DELETE FROM aliquot_masters WHERE id = $processing_aliquot_master_id;");
    $merged_ps3_aliquot_counter++;
}
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "$merged_ps3_aliquot_counter/$processing_site_ps3_aliquot_counter PS3 aliquots of the Processing Site database CUSM have been merged with aliquot of the CUSM database.");

// Add aliquot events 'Sent to Processing Site' for PS3 aliquots linked to the cusm
$query = "INSERT INTO aliquot_internal_uses (aliquot_master_id, type, use_code, use_details, created, created_by, modified, modified_by, procure_created_by_bank)
    (SELECT id, 'sent to processing site', 'N/A', 'Data created by Processing Site Data merge script on $date_yyyy_mm_dd.', '$import_date', $imported_by, '$import_date', $imported_by, '$procure_cusm_ps_numer'
    FROM aliquot_masters
    WHERE procure_created_by_bank = '$procure_cusm_ps_numer'
    AND id IN (SELECT aliquot_master_id FROM aliquot_internal_uses WHERE deleted <> 1 AND type = 'received from bank' AND use_code = 'PS3')
    AND id NOT IN (SELECT aliquot_master_id FROM aliquot_internal_uses WHERE deleted <> 1 AND type = 'sent to processing site' AND use_code = 'PS3'))";
customQuery($query);
addToModifiedDatabaseTablesList('aliquot_internal_uses', null);
$created_uses_nbr = getSelectQueryResult("SELECT count(*) as nbrst 
    FROM aliquot_internal_uses 
    WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by'
    AND type = 'sent to processing site'");
$created_uses_nbr = $created_uses_nbr[0]['nbrst'];
recordErrorAndMessage("Migration Summary", '@@MESSAGE@@', "Number of created/used elements.", "Created $created_uses_nbr aliquot events 'Sent to Processing Site'.");

// Set aliquot in stock to no if shipped to processing site
$query = "SELECT count(*) as nbr 
    FROM aliquot_masters
    WHERE deleted <> 1
    AND in_stock != 'no'
    AND id IN (SELECT aliquot_master_id FROM aliquot_internal_uses WHERE deleted <> 1 AND type = 'received from bank' AND use_code = 'PS3')";
$al_counter = getSelectQueryResult($query);
$al_counter = $al_counter[0]['nbr'];
recordErrorAndMessage("Migration Summary", '@@WARNING@@', "Number of created/used elements.", "Updated $al_counter PS3 aliquot sent to Processing Site to set the 'In Stock' value to 'no'.");
$query = "UPDATE aliquot_masters 
    SET in_stock = 'no', storage_master_id = null, storage_coord_x = '', storage_coord_y = '', modified = '$import_date', modified_by  = $imported_by
    WHERE deleted <> 1
    AND in_stock != 'no'
    AND id IN (SELECT aliquot_master_id FROM aliquot_internal_uses WHERE deleted <> 1 AND type = 'received from bank' AND use_code = 'PS3')";
customQuery($query);
addToModifiedDatabaseTablesList('aliquot_masters', null);

//=========================================================================================================================================
// Delete collections created by the process with no more aliquot 
// (PS3 aliquots previously sent to the processing site and merged with cusm collections)
//=========================================================================================================================================

$query = "SELECT SampleMaster.id AS sample_master_id
    FROM sample_masters SampleMaster
    WHERE SampleMaster.deleted <> 1
    AND SampleMaster.created LIKE '$date_yyyy_mm_dd%'
    AND SampleMaster.created_by = '$imported_by'
    AND SampleMaster.collection_id IN (SELECT Collection.id FROM collections Collection WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by' AND Collection.collection_notes LIKE 'Temporary collection created by system to migrate data from AT%')
    AND SampleMaster.id NOT IN (SELECT DISTINCT parent_id FROM sample_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by' AND parent_id IS NOT NULL)
    AND SampleMaster.id NOT IN (SELECT DISTINCT sample_master_id FROM aliquot_masters WHERE created LIKE '$date_yyyy_mm_dd%' AND created_by = '$imported_by')";
$sample_to_delete = getSelectQueryResult($query);
while($sample_to_delete) {
    $sample_master_ids_to_delete = array('-1');    
    foreach($sample_to_delete as $new_sample) {
        $sample_master_ids_to_delete[] = $new_sample['sample_master_id'];
    }
    $sample_master_ids_to_delete = implode(',', $sample_master_ids_to_delete);
    $sql_delete_queries = array(
        "DELETE FROM derivative_details WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "DELETE FROM specimen_details WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "DELETE FROM sd_der_pbmcs WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "DELETE FROM sd_der_dnas WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "DELETE FROM sd_spe_bloods WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "DELETE FROM sd_der_plasmas WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "DELETE FROM sd_spe_urines WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "DELETE FROM sd_der_urine_cents WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "DELETE FROM sd_der_buffy_coats WHERE sample_master_id IN ($sample_master_ids_to_delete)",
        "UPDATE sample_masters SET initial_specimen_sample_id = null WHERE id IN ($sample_master_ids_to_delete)",
        "DELETE FROM sample_masters WHERE id IN ($sample_master_ids_to_delete);"
    );
    foreach($sql_delete_queries as $custom_query) {
        customQuery($custom_query);
    }
    $sample_to_delete = getSelectQueryResult($query);
}

$query = "DELETE FROM collections 
    WHERE  created LIKE '$date_yyyy_mm_dd%' 
    AND created_by = '$imported_by' 
    AND collection_notes LIKE 'Temporary collection created by system to migrate data from AT%'
    AND id NOT IN (SELECT SampleMaster.collection_id AS sample_master_id
        FROM sample_masters SampleMaster
        WHERE SampleMaster.deleted <> 1
        AND SampleMaster.created LIKE '$date_yyyy_mm_dd%'
        AND SampleMaster.created_by = '$imported_by');";
customQuery($query);

//=========================================================================================================================================
// List PS3 aliquots found into processing site not merged with a real Ps3 aliquot 
//=========================================================================================================================================

// All processing site aliquots received from PS3 are linked to an internaluse euqals to 'received from bank PS3'
$query = "SELECT aliquot_masters.barcode
    FROM aliquot_masters
    WHERE procure_created_by_bank = 'x'";
foreach(getSelectQueryResult($query) as $ps3_aliquot) {
    recordErrorAndMessage("Migration Summary", 
        '@@ERROR@@', 
        "PS3 aliquots existing into the Processing Site database that do not match aliquot into CUSM Site database. Clean up to do after migration.", 
        "See aliquot '".$ps3_aliquot['barcode']."'");  
}

if($test_version) viewUpdate($date_yyyy_mm_dd, $imported_by);

$final_queries = array(
    "UPDATE sample_masters SET procure_created_by_bank = '$procure_cusm_ps_numer' WHERE procure_created_by_bank IN ('p', 'x');",
    "UPDATE aliquot_masters SET procure_created_by_bank = '$procure_cusm_ps_numer' WHERE procure_created_by_bank IN ('p', 'x');",
    "UPDATE storage_masters SET code = id WHERE code LIKE 'tmp_%';",
    "UPDATE sample_masters SET initial_specimen_sample_id = id WHERE parent_id IS NULL;",
    "UPDATE sample_masters SET sample_code = id WHERE sample_code LIKE 'tmp_%';",
    "UPDATE quality_ctrls SET qc_code = id WHERE qc_code LIKE 'tmp_%';",
    "UPDATE collections SET collection_property = 'participant collection' WHERE collection_property IS NULL AND created = '$import_date' AND created_by = $imported_by"
);	
if(!$test_version) $final_queries[] = "UPDATE versions SET permissions_regenerated = 0;";
foreach($final_queries as $new_query) customQuery($new_query);

if(!$test_version) insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(true);

//=========================================================================================================================================
// Functions
//=========================================================================================================================================

function updateDerivatvieSamplesAndAliquots($cusm_collection_id, $cusm_initial_specimen_sample_id, $cusm_initial_specimen_sample_type, $parent_sample_master_ids) {
    $query = "SELECT IFNULL(GROUP_CONCAT( DISTINCT id SEPARATOR ','), '') as sample_master_ids FROM sample_masters WHERE deleted <> 1 AND parent_id IN ($parent_sample_master_ids);";
    $sample_master_ids = getSelectQueryResult($query);
    if($sample_master_ids[0]['sample_master_ids']) {
        customQuery("UPDATE sample_masters 
            SET collection_id = $cusm_collection_id, initial_specimen_sample_id = $cusm_initial_specimen_sample_id, initial_specimen_sample_type = '$cusm_initial_specimen_sample_type' 
            WHERE id IN (".$sample_master_ids[0]['sample_master_ids'].");");
        customQuery("UPDATE aliquot_masters SET collection_id = $cusm_collection_id WHERE sample_master_id IN (".$sample_master_ids[0]['sample_master_ids'].");");
        updateDerivatvieSamplesAndAliquots($cusm_collection_id, $cusm_initial_specimen_sample_id, $cusm_initial_specimen_sample_type, $sample_master_ids[0]['sample_master_ids']);
    }
}

function viewUpdate($date_yyyy_mm_dd, $imported_by) {
    $insert = false;
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_storage_masters (
        SELECT StorageMaster.*, 
    		StorageControl.is_tma_block,
    		IF(coord_x_size IS NULL AND coord_y_size IS NULL, NULL, IFNULL(coord_x_size, 1) * IFNULL(coord_y_size, 1) - COUNT(AliquotMaster.id) - COUNT(TmaSlide.id) - COUNT(ChildStorageMaster.id)) AS empty_spaces 
    		FROM storage_masters AS StorageMaster
    		INNER JOIN storage_controls AS StorageControl ON StorageMaster.storage_control_id=StorageControl.id
    		LEFT JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.storage_master_id=StorageMaster.id AND AliquotMaster.deleted=0
    		LEFT JOIN tma_slides AS TmaSlide ON TmaSlide.storage_master_id=StorageMaster.id AND TmaSlide.deleted=0
    		LEFT JOIN storage_masters AS ChildStorageMaster ON ChildStorageMaster.parent_id=StorageMaster.id AND ChildStorageMaster.deleted=0
    		WHERE StorageMaster.deleted=0 AND StorageMaster.created LIKE '$date_yyyy_mm_dd%' AND StorageMaster.created_by = '$imported_by' 
    		GROUP BY StorageMaster.id, 
    		StorageMaster.code, 
    		StorageMaster.storage_control_id, 
    		StorageMaster.parent_id, 
    		StorageMaster.lft, 
    		StorageMaster.rght, 
    		StorageMaster.barcode, 
    		StorageMaster.short_label, 
    		StorageMaster.selection_label, 
    		StorageMaster.storage_status, 
    		StorageMaster.parent_storage_coord_x, 
    		StorageMaster.parent_storage_coord_y, 
    		StorageMaster.temperature, 
    		StorageMaster.temp_unit, 
    		StorageMaster.notes,
    		StorageMaster.created,
    		StorageMaster.created_by,
    		StorageMaster.modified,
    		StorageMaster.modified_by,
    		StorageMaster.deleted,
    		StorageControl.is_tma_block,
    		StorageControl.coord_x_size,
    		StorageControl.coord_y_size);";
    customQuery($query);
    
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_collections (
        SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
Collection.procure_visit AS procure_visit,
Collection.procure_collected_by_bank AS procure_collected_by_bank,
		Participant.participant_identifier AS participant_identifier,
Participant.procure_participant_attribution_number,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
		WHERE Collection.deleted <> 1 AND Collection.created LIKE '$date_yyyy_mm_dd%' AND Collection.created_by = '$imported_by');";
    customQuery($query);
    
    $query = 'REPLACE INTO view_samples (
        SELECT SampleMaster.id AS sample_master_id,
        SampleMaster.parent_id AS parent_id,
        SampleMaster.initial_specimen_sample_id,
        SampleMaster.collection_id AS collection_id,
        
        Collection.bank_id,
        Collection.sop_master_id,
        Collection.participant_id,
        
        Participant.participant_identifier,
        Participant.procure_participant_attribution_number,
        
        Collection.acquisition_label,
        Collection.procure_visit AS procure_visit,
        
        SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
        SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
        ParentSampleControl.sample_type AS parent_sample_type,
        ParentSampleMaster.sample_control_id AS parent_sample_control_id,
        SampleControl.sample_type,
        SampleMaster.sample_control_id,
        SampleMaster.sample_code,
        SampleControl.sample_category,
        SampleMaster.procure_created_by_bank,

        IF(SpecimenDetail.reception_datetime IS NULL, NULL,
        IF(Collection.collection_datetime IS NULL, -1,
        IF(Collection.collection_datetime_accuracy != "c" OR SpecimenDetail.reception_datetime_accuracy != "c", -2,
        IF(Collection.collection_datetime > SpecimenDetail.reception_datetime, -3,
        TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, SpecimenDetail.reception_datetime))))) AS coll_to_rec_spent_time_msg,

        IF(DerivativeDetail.creation_datetime IS NULL, NULL,
        IF(Collection.collection_datetime IS NULL, -1,
        IF(Collection.collection_datetime_accuracy != "c" OR DerivativeDetail.creation_datetime_accuracy != "c", -2,
        IF(Collection.collection_datetime > DerivativeDetail.creation_datetime, -3,
        TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg

        FROM sample_masters AS SampleMaster
        INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
        INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
        LEFT JOIN specimen_details AS SpecimenDetail ON SpecimenDetail.sample_master_id=SampleMaster.id
        LEFT JOIN derivative_details AS DerivativeDetail ON DerivativeDetail.sample_master_id=SampleMaster.id
        LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
        LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
        LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
        LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
        LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1'.
       " WHERE SampleMaster.deleted != 1 AND SampleMaster.created LIKE '$date_yyyy_mm_dd%' AND SampleMaster.created_by = '$imported_by');";
    customQuery($query);
 
    $query = 'REPLACE INTO view_aliquots (
        SELECT
        AliquotMaster.id AS aliquot_master_id,
        AliquotMaster.sample_master_id AS sample_master_id,
        AliquotMaster.collection_id AS collection_id,
        Collection.bank_id,
        AliquotMaster.storage_master_id AS storage_master_id,
        Collection.participant_id,
        
        Participant.participant_identifier,
        Participant.procure_participant_attribution_number,
        
        Collection.acquisition_label,
        Collection.procure_visit AS procure_visit,
        
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
        AliquotMaster.in_stock_detail,
        StudySummary.title AS study_summary_title,
        StudySummary.id AS study_summary_id,
        AliquotMaster.procure_created_by_bank,
        
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
        
        IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes
        
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
        LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1'.
        " WHERE AliquotMaster.deleted != 1 AND AliquotMaster.created LIKE '$date_yyyy_mm_dd%' AND AliquotMaster.created_by = '$imported_by');";
    customQuery($query);
    
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_aliquot_uses (SELECT CONCAT(AliquotInternalUse.id,6) AS id,
		AliquotMaster.id AS aliquot_master_id,
		AliquotInternalUse.type AS use_definition,
		AliquotInternalUse.use_code AS use_code,
		AliquotInternalUse.use_details AS use_details,
		AliquotInternalUse.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		AliquotInternalUse.use_datetime AS use_datetime,
		AliquotInternalUse.use_datetime_accuracy AS use_datetime_accuracy,
		AliquotInternalUse.duration AS duration,
		AliquotInternalUse.duration_unit AS duration_unit,
		AliquotInternalUse.used_by AS used_by,
		AliquotInternalUse.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detailAliquotInternalUse/',AliquotMaster.id,'/',AliquotInternalUse.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		StudySummary.id AS study_summary_id,
		StudySummary.title AS study_title,
AliquotInternalUse.procure_created_by_bank AS procure_created_by_bank
		FROM aliquot_internal_uses AS AliquotInternalUse
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotInternalUse.study_summary_id AND StudySummary.deleted != 1
		WHERE AliquotInternalUse.deleted <> 1 AND AliquotInternalUse.created LIKE '$date_yyyy_mm_dd%' AND AliquotInternalUse.created_by = '$imported_by')";
    customQuery($query);
    
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_aliquot_uses (SELECT CONCAT(SourceAliquot.id,1) AS `id`,
		AliquotMaster.id AS aliquot_master_id,
		CONCAT('sample derivative creation#', SampleMaster.sample_control_id) AS use_definition,
		SampleMaster.sample_code AS use_code,
		'' AS `use_details`,
		SourceAliquot.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		DerivativeDetail.creation_datetime AS use_datetime,
		DerivativeDetail.creation_datetime_accuracy AS use_datetime_accuracy,
		NULL AS `duration`,
		'' AS `duration_unit`,
		DerivativeDetail.creation_by AS used_by,
		SourceAliquot.created AS created,
		CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
		SampleMaster2.id AS sample_master_id,
		SampleMaster2.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title,
SampleMaster.procure_created_by_bank AS procure_created_by_bank
		FROM source_aliquots AS SourceAliquot
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
		JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
		WHERE SourceAliquot.deleted <> 1 AND SourceAliquot.created LIKE '$date_yyyy_mm_dd%' AND SourceAliquot.created_by = '$imported_by')";
    customQuery($query);
    
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_aliquot_uses (SELECT CONCAT(Realiquoting.id ,2) AS id,
		AliquotMaster.id AS aliquot_master_id,
IF(Realiquoting.procure_central_is_transfer = '1', '###system_transfer_flag###', 'realiquoted to') AS use_definition,
		AliquotMasterChild.barcode AS use_code,
		'' AS use_details,
		Realiquoting.parent_used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		Realiquoting.realiquoting_datetime AS use_datetime,
		Realiquoting.realiquoting_datetime_accuracy AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title,
AliquotMasterChild.procure_created_by_bank AS procure_created_by_bank
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1 AND Realiquoting.created LIKE '$date_yyyy_mm_dd%' AND Realiquoting.created_by = '$imported_by')";
    customQuery($query);
    
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_aliquot_uses (SELECT CONCAT(QualityCtrl.id,3) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'quality control' AS use_definition,
		QualityCtrl.qc_code AS use_code,
		'' AS use_details,
		QualityCtrl.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		QualityCtrl.date AS use_datetime,
		QualityCtrl.date_accuracy AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		QualityCtrl.run_by AS used_by,
		QualityCtrl.created AS created,
		CONCAT('/InventoryManagement/QualityCtrls/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',QualityCtrl.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title,
QualityCtrl.procure_created_by_bank AS procure_created_by_bank
		FROM quality_ctrls AS QualityCtrl
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE QualityCtrl.deleted <> 1 AND QualityCtrl.created LIKE '$date_yyyy_mm_dd%' AND QualityCtrl.created_by = '$imported_by')";
    customQuery($query);
    
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_aliquot_uses (SELECT CONCAT(OrderItem.id, 4) AS id,
		AliquotMaster.id AS aliquot_master_id,
		IF(OrderItem.shipment_id, 'aliquot shipment', 'order preparation') AS use_definition,
		IF(OrderItem.shipment_id, Shipment.shipment_code, Order.order_number) AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		IF(OrderItem.shipment_id, Shipment.datetime_shipped, OrderItem.date_added) AS use_datetime,
		IF(OrderItem.shipment_id, Shipment.datetime_shipped_accuracy, IF(OrderItem.date_added_accuracy = 'c', 'h', OrderItem.date_added_accuracy)) AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		IF(OrderItem.shipment_id, Shipment.shipped_by, OrderItem.added_by) AS used_by,
		IF(OrderItem.shipment_id, Shipment.created, OrderItem.created) AS created,
		IF(OrderItem.shipment_id,
				CONCAT('/Order/Shipments/detail/',OrderItem.order_id,'/',OrderItem.shipment_id),
				IF(OrderItem.order_line_id,
						CONCAT('/Order/OrderLines/detail/',OrderItem.order_id,'/',OrderItem.order_line_id),
						CONCAT('/Order/Orders/detail/',OrderItem.order_id))
		) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id,
		IF(OrderLine.study_summary_id, OrderLineStudySummary.title, OrderStudySummary.title) AS study_title,
OrderItem.procure_created_by_bank
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		LEFT JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		LEFT JOIN study_summaries AS OrderLineStudySummary ON OrderLineStudySummary.id = OrderLine.study_summary_id AND OrderLineStudySummary.deleted != 1
		JOIN `orders` AS `Order` ON  Order.id = OrderItem.order_id
		LEFT JOIN study_summaries AS OrderStudySummary ON OrderStudySummary.id = Order.default_study_summary_id AND OrderStudySummary.deleted != 1
		WHERE OrderItem.deleted <> 1 AND OrderItem.created LIKE '$date_yyyy_mm_dd%' AND OrderItem.created_by = '$imported_by')";
    customQuery($query);
    
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_aliquot_uses (SELECT CONCAT(OrderItem.id, 7) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'shipped aliquot return' AS use_definition,
		Shipment.shipment_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		OrderItem.date_returned AS use_datetime,
		IF(OrderItem.date_returned_accuracy = 'c', 'h', OrderItem.date_returned_accuracy) AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		OrderItem.reception_by AS used_by,
		OrderItem.modified AS created,
		CONCAT('/Order/Shipments/detail/',OrderItem.order_id,'/',OrderItem.shipment_id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id,
		IF(OrderLine.study_summary_id, OrderLineStudySummary.title, OrderStudySummary.title) AS study_title,
OrderItem.procure_created_by_bank
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		LEFT JOIN study_summaries AS OrderLineStudySummary ON OrderLineStudySummary.id = OrderLine.study_summary_id AND OrderLineStudySummary.deleted != 1
		JOIN `orders` AS `Order` ON  Order.id = OrderItem.order_id
		LEFT JOIN study_summaries AS OrderStudySummary ON OrderStudySummary.id = Order.default_study_summary_id AND OrderStudySummary.deleted != 1
		WHERE OrderItem.deleted <> 1 AND OrderItem.status = 'shipped & returned' AND OrderItem.created LIKE '$date_yyyy_mm_dd%' AND OrderItem.created_by = '$imported_by')";
    customQuery($query);
    
    $query = ($insert? "INSERT" : "REPLACE")." INTO view_aliquot_uses (SELECT CONCAT(AliquotReviewMaster.id,5) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'specimen review' AS use_definition,
		SpecimenReviewMaster.review_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		SpecimenReviewMaster.review_date AS use_datetime,
		SpecimenReviewMaster.review_date_accuracy AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		'' AS used_by,
		AliquotReviewMaster.created AS created,
		CONCAT('/InventoryManagement/SpecimenReviews/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',SpecimenReviewMaster.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title,
AliquotReviewMaster.procure_created_by_bank
		FROM aliquot_review_masters AS AliquotReviewMaster
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
		JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotReviewMaster.deleted <> 1 AND AliquotReviewMaster.created LIKE '$date_yyyy_mm_dd%' AND AliquotReviewMaster.created_by = '$imported_by');";
    customQuery($query);
    
}

?>
		