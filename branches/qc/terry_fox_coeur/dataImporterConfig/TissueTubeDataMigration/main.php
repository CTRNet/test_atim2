<?php    
    
// *******************************************************************************************************************************************************
//
//    TFRI-COEUR
//
// *******************************************************************************************************************************************************
//
//	Script created to create tissue tube
//
// @created 2019-03-13
// @author Nicolas Luc
// *******************************************************************************************************************************************************

$is_serveur = false;
require_once ($is_serveur)? '/ATiM/atim-tfri/dataUpdate/coeur/ClinicalDataUpdate/system.php' : './system.php';

$commit_all = true;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $commit_all = false;   
    } else {
        die('ERR ARG : '.$argv[1].' (should be test or nothing)');
    }
}

displayMigrationTitle('TFRI COEUR - Tissue Tubes Creation', $bank_excel_files);

if(!testExcelFile($bank_excel_files)) {
	dislayErrorAndMessage();
	exit;
}

$atim_qc_tf_bank_data = getSelectQueryResult("SELECT id, name FROM banks WHERE deleted <>1");
$atim_qc_tf_bank_id_from_name = array();
$atim_qc_tf_bank_name_from_id = array();
foreach($atim_qc_tf_bank_data as $new_bank_data) {
    $atim_qc_tf_bank_id_from_name[$new_bank_data['name']] = $new_bank_data['id'];
    $atim_qc_tf_bank_name_from_id[$new_bank_data['id']] = $new_bank_data['name'];
}

pr("<font color='red'>Validate rack used = rack16</font>");
pr("<font color='red'>Validate no block OCT exists</font>");

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Collection cleanup: Set tube in stock value to no plus merge collection
//--------------------------------------------------------------------------------------------------------------------------------------------------------

// Tubes
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$query = "SELECT id, barcode, aliquot_label
	FROM aliquot_masters	
	WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-tube']['id']."
    AND deleted <> 1
	AND in_stock = 'no';";
foreach(getSelectQueryResult($query) as $newRecord) {
    recordErrorAndMessage(
        'Collections, tissues samples and tubes clean-up :: pre-migration',
        '@@WARNING@@',
        "Tissue tube defined as not in stock before migration. Tube information (including the reason) won't be copied then past to the new created tube. To migrate manually after the migration if required.",
        "Tissue tube TFRI# ".$newRecord['barcode']." (Aliquot TFRI Label : ".$newRecord['aliquot_label'].").");
}

$query = "SELECT id, barcode, aliquot_label
	FROM aliquot_masters
	WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-tube']['id']."
    AND deleted <> 1
	AND id IN (
        SELECT aliquot_master_id FROM (
            SELECT aliquot_master_id FROM aliquot_internal_uses WHERE deleted <> 1
            UNION ALL
            SELECT aliquot_master_id FROM source_aliquots WHERE deleted <> 1
            UNION ALL
            SELECT child_aliquot_master_id FROM realiquotings WHERE deleted <> 1
            UNION ALL
            SELECT parent_aliquot_master_id FROM realiquotings WHERE deleted <> 1
            UNION ALL
            SELECT aliquot_master_id FROM quality_ctrls WHERE deleted <> 1
            UNION ALL
            SELECT aliquot_master_id FROM order_items WHERE deleted <> 1
            UNION ALL
            SELECT aliquot_master_id FROM aliquot_review_masters WHERE deleted <> 1
        ) res
    )";
foreach(getSelectQueryResult($query) as $newRecord) {
    recordErrorAndMessage(
        'Collections, tissues samples and tubes clean-up :: pre-migration',
        '@@WARNING@@',
        "Tissue tube defined as used before migration. Tube uses data won't be copied then past to the new created tube. To migrate manually after the migration if required.",
        "Tissue tube TFRI# ".$newRecord['barcode']." (Aliquot TFRI Label : ".$newRecord['aliquot_label'].").");
}

$query = "SELECT COUNT(*) nbr_of_tissue_tubes
    FROM aliquot_masters
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-tube']['id']."
    AND deleted <> 1
    AND in_stock != 'no'";
$atimNbrOfTubes = getSelectQueryResult($query);
$atimNbrOfTubes = $atimNbrOfTubes[0]['nbr_of_tissue_tubes'];
recordErrorAndMessage(
    'Collections, tissues samples and tubes clean-up :: pre-migration',
    '@@WARNING@@',
    "Changed the in stock value to 'no' for all existing tissue tube migrated before 2019 and that should be replaced by the data of the current migration.",
    "$atimNbrOfTubes tissue tubes updated");

$query = "UPDATE aliquot_masters
    SET in_stock = 'no',
    in_stock_detail = 'wrong tube (1st migration)',
    storage_master_id = null,
    storage_coord_x = null,
    storage_coord_y = null,
    notes = CONCAT('Created by the 1st tissue tubes migration script (before 2019) and supposed to be replaced by the new migration of tissue tubes on ".$import_date.". ', IFNULL(notes, '')),
    modified = '".$import_date."',
    modified_by = ".$imported_by."
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-tube']['id']."
    AND deleted <> 1
    AND (in_stock_detail IS NULL OR in_stock_detail = '')
    AND in_stock != 'no'";
customQuery($query);    

$query = "UPDATE aliquot_masters
    SET in_stock = 'no',
    storage_master_id = null,
    storage_coord_x = null,
    storage_coord_y = null,
    notes = CONCAT('Created by the 1st tissue tubes migration script (before 2019) and supposed to be replaced by the new migration of tissue tubes on ".$import_date.". ', IFNULL(notes, '')),
    modified = '".$import_date."',
    modified_by = ".$imported_by."
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-tube']['id']."
    AND deleted <> 1
    AND (in_stock_detail IS NOT NULL AND in_stock_detail != '')
    AND in_stock != 'no'";
customQuery($query);
    
$query = "UPDATE sample_masters
    SET deleted = 1,
    modified = '".$import_date."',
    modified_by = ".$imported_by."
    WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    AND id NOT IN (
        SELECT sample_master_id FROM (
            SELECT sample_master_id FROM aliquot_masters WHERE deleted <> 1
            UNION ALL
            SELECT sample_master_id FROM quality_ctrls WHERE deleted <> 1 
    		UNION ALL
            SELECT sample_master_id FROM specimen_review_masters WHERE deleted <> 1
    		UNION ALL
            SELECT parent_id FROM sample_masters WHERE deleted <> 1 AND parent_id IS NOT NULL
        ) res
    ) 
    AND deleted <> 1";
customQuery($query);
    
$query = "UPDATE collections
    SET deleted = 1,
    modified = '".$import_date."',
    modified_by = ".$imported_by."
    WHERE id NOT IN (
        SELECT collection_id FROM sample_masters WHERE deleted <> 1 
        UNION ALL
        SELECT collection_id FROM specimen_review_masters WHERE deleted <> 1
    ) AND deleted <> 1";
customQuery($query);

// Collection fusion (pre-process)
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$query = "SELECT GROUP_CONCAT(DISTINCT id  SEPARATOR ',' ) res_ids, GROUP_CONCAT(DISTINCT collection_notes SEPARATOR '#||#' ) res_notes, participant_id, collection_datetime, collection_datetime_accuracy
    FROM collections
    WHERE deleted <> 1
    AND participant_id IS NOT NULL
--    AND collection_datetime IS NOT NULL
    AND id IN 
    (
       SELECT DISTINCT Collection.id
       FROM collections Collection
       INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
       INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
       WHERE Collection.deleted <> 1
       AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    )
    GROUP BY participant_id, collection_datetime, collection_datetime_accuracy";
$atimCollectionsToMerge = getSelectQueryResult($query);
foreach($atimCollectionsToMerge as $new_collections_set) {
    if(preg_match('/,/', $new_collections_set['res_ids'])) {
        $all_ids = explode(',',$new_collections_set['res_ids']);
        $collection_id_to_keep = array_shift($all_ids);
        $collection_ids_to_delete = implode(',',$all_ids);
        $notes = explode('#||#', $new_collections_set['res_notes']);
        $notes = array_filter($notes);
        $notes = implode('. ', $notes);
        customQuery("UPDATE collections         
            SET deleted = 1,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE id IN ($collection_ids_to_delete) AND deleted <> 1");
        if(strlen($notes)) {
            customQuery("UPDATE collections
                SET collection_notes = '".str_replace("'", "''", $notes)."',
                modified = '".$import_date."',
                modified_by = ".$imported_by."
                WHERE id = $collection_id_to_keep AND deleted <> 1");
        }
        customQuery("UPDATE sample_masters
            SET collection_id = $collection_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE collection_id IN ($collection_ids_to_delete) AND deleted <> 1");
        customQuery("UPDATE aliquot_masters
            SET collection_id = $collection_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE collection_id IN ($collection_ids_to_delete) AND deleted <> 1");
        recordErrorAndMessage(
            'Collections, tissues samples and tubes clean-up :: pre-migration',
            '@@MESSAGE@@',
            "Merged participant collections with same dates. Please validate.",
            "See Participant TFRI# ".$new_collections_set['participant_id'] .
            (strlen($new_collections_set['collection_datetime'])? " and collection date ".str_replace(' 00:00:00', '', $new_collections_set['collection_datetime'])."." : " and collection with no date."));
    }
}

// Sample Tissue fusion (pre-process)
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$query = "SELECT 
    Collection.participant_id,
    Collection.collection_datetime,
    Collection.collection_datetime_accuracy,
    SampleMaster.collection_id, 
    GROUP_CONCAT(DISTINCT SampleMaster.id  SEPARATOR ',' ) sample_master_ids, 
    SampleDetail.tissue_source,
    SampleDetail.qc_tf_tissue_type,
    SampleDetail.tissue_laterality
    FROM collections Collection
    INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
    INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
    WHERE Collection.participant_id IS NOT NULL
    AND SampleMaster.deleted <> 1
    AND Collection.deleted <> 1
    AND sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    GROUP BY SampleMaster.collection_id, 
    Collection.participant_id,
    Collection.collection_datetime,
    Collection.collection_datetime_accuracy,
    SampleDetail.tissue_source,
    SampleDetail.qc_tf_tissue_type,
    SampleDetail.tissue_laterality;";

$atimSamplesToMerge = getSelectQueryResult($query);
foreach($atimSamplesToMerge as $new_samples_set) {
    if(preg_match('/,/', $new_samples_set['sample_master_ids'])) {pr($new_samples_set);
        $all_ids = explode(',',$new_samples_set['sample_master_ids']);
        $sample_id_to_keep = array_shift($all_ids);
        $sample_ids_to_delete = implode(',',$all_ids);
        customQuery("UPDATE sample_masters
            SET deleted = 1,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE id IN ($sample_ids_to_delete) AND deleted <> 1");
        customQuery("UPDATE sample_masters
            SET parent_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE parent_id IN ($sample_ids_to_delete) AND deleted <> 1");
        customQuery("UPDATE sample_masters
            SET initial_specimen_sample_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE initial_specimen_sample_id IN ($sample_ids_to_delete) AND deleted <> 1");
        customQuery("UPDATE aliquot_masters
            SET sample_master_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1");
        $query = "SELECT count(*) tt from quality_ctrls WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1";
        $countRes = getSelectQueryResult($query);
        $andQualtyCtrlMsg = ($countRes[0]['tt'])? " plus quality controls " : "";
        customQuery("UPDATE quality_ctrls
            SET sample_master_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1");
        $query = "SELECT count(*) tt from source_aliquots WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1";
        $countRes = getSelectQueryResult($query);
        if($countRes[0]['tt']) die('ERR 93939383');
        customQuery("UPDATE source_aliquots
            SET sample_master_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1");
        $sampleMsg = array();
        if($new_samples_set['tissue_source']) $sampleMsg[] = "tissue source = '".$new_samples_set['tissue_source']."'";
        if($new_samples_set['qc_tf_tissue_type']) $sampleMsg[] = "tissue type = '".$new_samples_set['qc_tf_tissue_type']."'";
        if($new_samples_set['tissue_laterality']) $sampleMsg[] = "tissue laterality = '".$new_samples_set['tissue_laterality']."'";
        if(!$sampleMsg) $sampleMsg[] = 'with no tissue property';
        $sampleMsg = implode(' ', $sampleMsg);
        recordErrorAndMessage(
            'Collections, tissues samples and tubes clean-up :: pre-migration',
            '@@MESSAGE@@',
            "Merged tissue samples $andQualtyCtrlMsg for tissue of the same collection with same source, laterality and type. Please validate.",
            "See Participant TFRI# ".$new_samples_set['participant_id'] .
            (strlen($new_samples_set['collection_datetime'])? ", collection date ".str_replace(' 00:00:00', '', $new_collections_set['collection_datetime'])."." : ", collection with no date ".
            "and tissue sample with $sampleMsg."));
    }
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------

addToModifiedDatabaseTablesList('Collections', null);
addToModifiedDatabaseTablesList('sample_masters', $atim_controls['sample_controls']['tissue']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['tissue-tube']['detail_tablename']);
addToModifiedDatabaseTablesList('source_aliquots', null);
addToModifiedDatabaseTablesList('quality_ctrls', null);

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Main Process
//--------------------------------------------------------------------------------------------------------------------------------------------------------

// Tube migration - Main code
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$atimTissues = getATiMTissues();

$created_collection_counter = 0;
$created_sample_counter = 0;
$created_aliquot_counter = 0;
$created_storage_counter = 0;

$storageIds = array();
$boxeParentIdCheck = array();

$file_name = $bank_excel_files['0'];
$worksheetName = "inventaire";
$file_name_for_summary = "file '<b>$file_name :: $worksheetName</b>";
$aliquotNotMigrated = array();
while($exceldata = getNextExcelLineData($file_name, $worksheetName)) {
    list($excel_line_counter, $excel_line_tube_data) = $exceldata;
    
    if(empty($aliquotNotMigrated)) {
        $headers = array_keys($excel_line_tube_data);
        $headers[] = 'Excel Line';
        $aliquotNotMigrated[] = $headers;
    }
    // Check participant (if exists)
    // If not, next line.
    //--------------------------------------------------
        
    $participantTfriNbr = $excel_line_tube_data['COEURI ID'];
    if(!isset($atimTissues[$participantTfriNbr])) {
        recordErrorAndMessage(
            'Participant definition',
            '@@ERROR@@',
            "Excel participant not found into ATiM based on Participant TFRI#. No data of the line will be migrated.",
            "See excel participant with Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        $allValues = array_values($excel_line_tube_data);
        $allValues[] = $excel_line_counter;
        $aliquotNotMigrated[] = $allValues;
        continue;
    }
    if(empty($excel_line_tube_data['participantBank#'])) {
        recordErrorAndMessage(
            'Participant definition',
            '@@WARNING@@',
            "The Participant Bank# is not completed into Excel. The identity of the participant can not be validated but data of the line will be migrated based on Participant TFRI# (only). Please validate match after the migration",
            "See excel participant with Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        
    } elseif($excel_line_tube_data['participantBank#'] != $atimTissues[$participantTfriNbr]['qc_tf_bank_identifier']) {
        recordErrorAndMessage(
            'Participant definition',
            '@@ERROR@@',
            "Excel and ATiM participants match on Participant TFRI# but are different based on Participant Bank#. The identity of the participant can not be validated but data of the line will be migrated based on Participant TFRI# (only). Please validate match after the migration",
            "For Participant TFRI# '<b>$participantTfriNbr</b>' on line $excel_line_counter, check the different Participant Bank# : (xls) ".$excel_line_tube_data['participantBank#']." != (atim) ".$atimTissues[$participantTfriNbr]['qc_tf_bank_identifier']." - line $excel_line_counter.");
//         $allValues = array_values($excel_line_tube_data);
//         $allValues[] = $excel_line_counter;
//         $aliquotNotMigrated[] = $allValues;
//         continue;
        
    }
    $atim_qc_tf_bank_id = null;
    if($excel_line_tube_data['Bank'] != 'UHN - Not to Used') {
        $excel_line_tube_data['Bank'] = str_replace(
            array("CBCF-", "CHUQ-", "CHUS-", "MOBP-", "OHRI-", "OVCARE", "MCGILL", 'UHN'),
            array("CBCF", "CHUQ", "CHUS", "MOBP", "OHRI", "OVCare", "McGill", "UHN-Sunnybrook"),
            $excel_line_tube_data['Bank']);
    }
    if(!isset($atim_qc_tf_bank_id_from_name[$excel_line_tube_data['Bank']])) {
        recordErrorAndMessage(
            'Participant definition',
            '@@ERROR@@',
            "Bank defined into Excel is unknwon. No data of the line will be migrated.",
            "See excel banq '<b>".$excel_line_tube_data['Bank']."</b>' associated to the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        $allValues = array_values($excel_line_tube_data);
        $allValues[] = $excel_line_counter;
        $aliquotNotMigrated[] = $allValues;
        continue;
    } else {
        $atim_qc_tf_bank_id = $atim_qc_tf_bank_id_from_name[$excel_line_tube_data['Bank']];
    }
    if(($atim_qc_tf_bank_id != $atimTissues[$participantTfriNbr]['qc_tf_bank_id']) && ($atim_qc_tf_bank_id_from_name['UHN-PMH'] == $atimTissues[$participantTfriNbr]['qc_tf_bank_id'])) {
        $excel_line_tube_data['Bank'] = 'UHN-PMH';
        $atim_qc_tf_bank_id = $atim_qc_tf_bank_id_from_name[$excel_line_tube_data['Bank']];
    }
    if($atim_qc_tf_bank_id != $atimTissues[$participantTfriNbr]['qc_tf_bank_id']) {
        recordErrorAndMessage(
            'Participant definition',
            '@@ERROR@@',
            "Participant match on Participant TFRI# but bank is different in ATiM and Excel. No data of the line will be migrated.",
            "See excel banq '<b>".$excel_line_tube_data['Bank']."</b>' and ATiM bank '".$atim_qc_tf_bank_name_from_id[$atimTissues[$participantTfriNbr]['qc_tf_bank_id']]."' defined for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        $allValues = array_values($excel_line_tube_data);
        $allValues[] = $excel_line_counter;
        $aliquotNotMigrated[] = $allValues;
        continue;
    }
    
    // Participant found
    $participant_id = $atimTissues[$participantTfriNbr]['participant_id'];
    list($excel_collection_date, $excel_collection_date_accuracy) = array('', '');
    $excel_field = 'Collection date';
    if(preg_match('/^((200[1-9])|(201[0-9]))$/', $excel_line_tube_data[$excel_field])) {
        list($excel_collection_date, $excel_collection_date_accuracy) = array($excel_line_tube_data[$excel_field].'-01-01', 'm');
    } else {
        list($excel_collection_date, $excel_collection_date_accuracy) = validateAndGetDateAndAccuracy(
            $excel_line_tube_data[$excel_field],
            'Tube creation/update',
            "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
            "See value [".$excel_line_tube_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        if($excel_collection_date_accuracy == 'c') $excel_collection_date_accuracy = 'h';
    }
    
    $collection_ids = array();
    $collection_id = null;
    foreach($atimTissues[$participantTfriNbr]['collections'] as $tmp_collection_id => $collectionData) {
        if($excel_collection_date && $excel_collection_date == substr($collectionData['collection_datetime'], 0, 10)) {
            $collection_id = $tmp_collection_id;
        }        
    }
    
    if(!$collection_id) {
        $created_collection_counter++;
        $collection_id = customInsertRecord(array(
            'collections' => array(
                'participant_id' => $participant_id,
                'collection_property' => 'participant collection',
                'collection_datetime' => $excel_collection_date,
                'collection_datetime_accuracy' => $excel_collection_date_accuracy)));
    }
    
    $excel_field = 'laterality';
    $tissue_laterality  = validateAndGetStructureDomainValue(
        $excel_line_tube_data[$excel_field],
        'tissue_laterality',
        'Tube creation/update',
        "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
        "See value [".$excel_line_tube_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    
    $excel_field = 'tissue type';
    $tissue_source  = validateAndGetStructureDomainValue(
        $excel_line_tube_data[$excel_field],
        'tissue_source_list',
        'Tube creation/update',
        "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
        "See value [".$excel_line_tube_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    
    $created_sample_counter++;
    $sample_data = array(
        'sample_masters' => array(
            "sample_code" => 'tmp_tissue_'.$created_sample_counter,
            "sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
            "initial_specimen_sample_type" => 'tissue',
            "collection_id" => $collection_id,
            'notes' => ''),
        'specimen_details' => array(),
        $atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
            'tissue_source' => $tissue_source,
            'tissue_laterality' => $tissue_laterality
        ));
    $tissue_sample_master_id = customInsertRecord($sample_data);
    
    // Aliquot creation
    
    $aliquot_label = $excel_line_tube_data['Aliquot label'];
    if(!strlen($aliquot_label)) $aliquot_label = '?';
     
    $excel_field = 'Availability';
    $in_stock = 'yes - available';
    if($excel_line_tube_data[$excel_field] == 'no') {
        $in_stock = 'no';
    } elseif($excel_line_tube_data[$excel_field] == 'not' || $excel_line_tube_data[$excel_field] == 'excluded')  {
        recordErrorAndMessage(
            'Tube creation/update',
            '@@WARNING@@',
            "The 'availability tubes' excel value is not supported. Value will be migrated as 'no' (not in stock). Please validate and clean up data after the migration.",
            "See value [".$excel_line_tube_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    } elseif($excel_line_tube_data[$excel_field] != 'yes')  {
        recordErrorAndMessage(
            'Tube creation/update',
            '@@ERROR@@',
            "The 'availability tubes' excel value is not supported. Value will be migrated as 'yes - available'. Please validate and clean up data after the migration.",
            "See value [".$excel_line_tube_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    }
    
    //- Storage -----------------------------------------------------------------------
    
    $parent_id = null;
    $selection_labels = '';
    $storageIdKey = '';
    $excel_field = 'Position #';
    $storage_coord_x = $excel_line_tube_data[$excel_field];
    $excel_field = 'Position letter';
    $storage_coord_y = $excel_line_tube_data[$excel_field];
    $boxType  = ((!strlen($storage_coord_y) || ($storage_coord_y == '-')) && preg_match('/^(([1-9])|([1-7][0-9])|(8[0-1]))$/', $storage_coord_x))? 'box81' : 'box81 1A-9I';
    if($boxType == 'box81') {
        recordErrorAndMessage(
            'Tube creation/update',
            '@@WARNING@@',
            "The format of the box used to store aliquot is a 81 Box (1 to 81). Please validate and clean up data after the migration.",
            "See box [".$excel_line_tube_data['Box']."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    }
    foreach(array('Freezer' => 'freezer', 'Self' => 'shelf', 'Rack' => 'rack16', 'Box' => $boxType) as $excel_field => $storage_control_type) {
        if(strlen($excel_line_tube_data[$excel_field]) && '-' != $excel_line_tube_data[$excel_field]) {
            $selection_labels = $selection_labels . (strlen($selection_labels)? '-': ''). $excel_line_tube_data[$excel_field];
            $storageIdKey = $storageIdKey . (strlen($storageIdKey)? ' - ': ''). $storage_control_type.'#<b>'.$excel_line_tube_data[$excel_field].'</b>';
            if(!isset($storageIds[$storageIdKey])) {
                $storage_controls = $atim_controls['storage_controls'][$storage_control_type];
                $storage_data = array(
                    'storage_masters' => array(
                        "code" => 'tmp'.$created_storage_counter,
                        "short_label" => $excel_line_tube_data[$excel_field],
                        "selection_label" => $selection_labels,
                        "storage_control_id" => $storage_controls['id'],
                        "parent_id" => $parent_id),
                    $storage_controls['detail_tablename'] => array());
                $parent_id = customInsertRecord($storage_data);
                $created_storage_counter++;
                $storageIds[$storageIdKey] = $parent_id;
            }
            $parent_id = $storageIds[$storageIdKey];
        }
    }
    
    $excel_field = 'Box';
    $storage_master_id = null;
    $storage_data_for_notes = '';
    if(strlen($excel_line_tube_data[$excel_field]) && '-' != $excel_line_tube_data[$excel_field]) {
        $storage_master_id = $parent_id;
        if(!$storage_master_id) {
            die('ERR 84893938289292');
        }
        // Check box name is always linke to the same troage_master_id
        if(!isset($boxeParentIdCheck[$excel_line_tube_data[$excel_field]])) {
            $boxeParentIdCheck[$excel_line_tube_data[$excel_field]] = array('id' => $storage_master_id, 'detail' => $storageIdKey);
        } else if($boxeParentIdCheck[$excel_line_tube_data[$excel_field]]['id'] != $storage_master_id) {
            // Box not always defined into the same position
            recordErrorAndMessage(
                'Tube creation/update',
                '@@ERROR@@',
                "A same box is defined as stored into 2 different freezer or/and rack or/and shelf. Box will be created twice. Please validate and clean up data after the migration.",
                "See storage '$storageIdKey' && '".$boxeParentIdCheck[$excel_line_tube_data[$excel_field]]['detail']."' for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        }
        if($in_stock == 'no') {
            recordErrorAndMessage(
                'Tube creation/update - storage definition',
                '@@WARNING@@',
                "The 'availability tubes' value set to 'no' but storage and positions are defined based on excel values. Aliquot won't be defined as stored into a storage. Positions will be added to aliquot notes. Please validate and clean up data after the migration.",
                "See storage '$storageIdKey' and positions ['$storage_coord_x'-'$storage_coord_y'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
            $storage_data_for_notes = "Aliquot storage was defined as '$storageIdKey' and positions ['$storage_coord_x'-'$storage_coord_y'] in excel";
            $storage_master_id = null;
            $storage_coord_x = null;
            $storage_coord_y = null;
        } elseif($boxType != 'box81') {
            if((!$storage_coord_x && $storage_coord_y) || ($storage_coord_x && !$storage_coord_y)) {
                recordErrorAndMessage(
                    'Tube creation/update - storage definition',
                    '@@ERROR@@',
                    "Wrong box positions (1 postion missing) are defined based on excel values. Aliquot will be defined as stored into a storage with no position. Positions will be added to aliquot notes. Please validate and clean up data after the migration.",
                    "See storage '$storageIdKey' and positions ['$storage_coord_x'-'$storage_coord_y'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
                $storage_data_for_notes = "Aliquot positions were defined as ['$storage_coord_x'-'$storage_coord_y'] in excel";
                $storage_coord_x = null;
                $storage_coord_y = null;
            } elseif($storage_coord_x && (!preg_match('/^[0-9]$/', $storage_coord_x) || !preg_match('/^[A-I]$/', $storage_coord_y))) {
                recordErrorAndMessage(
                    'Tube creation/update - storage definition',
                    '@@ERROR@@',
                    "Wrong box positions are defined based on excel values. Aliquot will be defined as stored into a storage with no position. Positions will be added to aliquot notes. Please validate and clean up data after the migration.",
                    "See storage '$storageIdKey' and positions ['$storage_coord_x'-'$storage_coord_y'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
                $storage_data_for_notes = "Aliquot positions were defined as ['$storage_coord_x'-'$storage_coord_y'] in excel";
                $storage_coord_x = null;
                $storage_coord_y = null;
            }
        }
    } else{
        if($in_stock != 'no') {
            if($parent_id) {
                recordErrorAndMessage(
                    'Tube creation/update - storage definition',
                    '@@ERROR@@',
                    "Aliquot is defined as stored in a storage different than box based on excel values. Aliquot will be defined as not stored into a storage. Positions data will be lost. Please validate and clean up data after the migration.",
                    "See storage '$storageIdKey' and positions ['$storage_coord_x'-'$storage_coord_y'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
            } else {
                if(strlen($storage_coord_x.$storage_coord_y)) {
                    recordErrorAndMessage(
                        'Tube creation/update - storage definition',
                        '@@ERROR@@',
                        "Aliquot positions are defined but the storage/box is not defined. Aliquot will be defined as not stored into a storage. Positions data will be lost. Please validate and clean up data after the migration.",
                        "See storage '$storageIdKey' and positions ['$storage_coord_x'-'$storage_coord_y'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
                }
            }
        }
        $storage_master_id = null;
        $storage_coord_x = null;
        $storage_coord_y = null;
    }    
    //- End Storage -----------------------------------------------------------------------
    
    $qc_tf_weight_mg = '';
    $qc_tf_weight_mg_details = '';
    $qc_tf_size_mm3 = '';
    $qc_tf_size_mm3_details = '';
    $new_notes = array();
    if(preg_match('/mg/', $excel_line_tube_data['Quantity/Size'] )) {
        $qc_tf_weight_mg_details = $excel_line_tube_data['Quantity/Size'];
    } else if(preg_match('/mm/', $excel_line_tube_data['Quantity/Size'] )) {
        $qc_tf_size_mm3_details = $excel_line_tube_data['Quantity/Size'];
    } elseif(strlen($excel_line_tube_data['Quantity/Size'])) {
        $new_notes[] = 'Quantity/Size:'.$excel_line_tube_data['Quantity/Size'];
    }
    if($storage_data_for_notes) {
        $new_notes[] = $storage_data_for_notes;
    }
    foreach(array('Other name', 'Sample. number', 'histology') AS $excel_field) {
        if(strlen($excel_line_tube_data[$excel_field])) $new_notes[] = "$excel_field : ".$excel_line_tube_data[$excel_field];
    }
    if($new_notes) {
        $new_notes = 'Excel note(s) : ' . implode('. ', $new_notes).'.';
    } else {
        $new_notes = '';
    }
       
    $aliquot_master_id = null;
    if(strtolower($excel_line_tube_data['Format (uL)']) == 'block') {
        $aliquot_type = 'block';
        recordErrorAndMessage(
            'Tube creation/update - storage definition',
            '@@MESSAGE@@',
            "Aliquot is defined as block. Block will be created. Please validate and clean up data after the migration.",
            "See storage for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        if($excel_line_tube_data['Medium'] != 'OCT' && $excel_line_tube_data['Storage'] != 'Frozen') {
            die('ERR 237628762378623');
        }
        $aliquot_data = array(
            'aliquot_masters' => array(
                "barcode" => 'tmp_'.$created_aliquot_counter,
                'aliquot_label' => $aliquot_label,
                "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
                "collection_id" => $collection_id,
                "sample_master_id" => $tissue_sample_master_id,
                'storage_master_id' => $storage_master_id,
                'in_stock' => $in_stock,
                'in_stock_detail' => '',
                'storage_master_id' => $storage_master_id,
                'storage_coord_x' => $storage_coord_x,
                'storage_coord_y' => $storage_coord_y,
                'notes' => $new_notes
            ),
            $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
                'block_type' => 'OCT',
                'qc_tf_weight_mg' => $qc_tf_weight_mg,
                'qc_tf_weight_mg_details' => $qc_tf_weight_mg_details,
                'qc_tf_size_mm3' => $qc_tf_size_mm3,
                'qc_tf_size_mm3_details' => $qc_tf_size_mm3_details
            ));
        $created_aliquot_counter++;
        $aliquot_master_id = customInsertRecord($aliquot_data);
    } else {
        
        $excel_field = 'Medium';
        $qc_tf_storage_solution  = validateAndGetStructureDomainValue(
            $excel_line_tube_data[$excel_field],
            'qc_tf_tissue_storage_solution',
            'Tube creation/update',
            "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
            "See value [".$excel_line_tube_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        
        $excel_field = 'Storage';
        $qc_tf_storage_method  = validateAndGetStructureDomainValue(
            $excel_line_tube_data[$excel_field],
            'qc_tf_tissue_storage_method',
            'Tube creation/update',
            "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
            "See value [".$excel_line_tube_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        
        $new_notes = '';
        $aliquot_data = array(
            'aliquot_masters' => array(
                "barcode" => 'tmp_'.$created_aliquot_counter,
                'aliquot_label' => $aliquot_label, //"FFPE $participantTfriNbr",
                "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-tube']['id'],
                "collection_id" => $collection_id,
                "sample_master_id" => $tissue_sample_master_id,
                'storage_master_id' => $storage_master_id,
                'in_stock' => $in_stock,
                'in_stock_detail' => '',
                'storage_master_id' => $storage_master_id,
                'storage_coord_x' => $storage_coord_x,
                'storage_coord_y' => $storage_coord_y,
                'notes' => $new_notes
            ),
            $atim_controls['aliquot_controls']['tissue-tube']['detail_tablename'] => array(
                'qc_tf_storage_solution' => $qc_tf_storage_solution,
                'qc_tf_storage_method' => $qc_tf_storage_method,
                'qc_tf_weight_mg' => $qc_tf_weight_mg,    
                'qc_tf_weight_mg_details' => $qc_tf_weight_mg_details,    
                'qc_tf_size_mm3' => $qc_tf_size_mm3,    
                'qc_tf_size_mm3_details' => $qc_tf_size_mm3_details
            ));
        $created_aliquot_counter++;
        $aliquot_master_id = customInsertRecord($aliquot_data);
    }
    
    $aliquot_uses = array();
    if(strlen($excel_line_tube_data['number of defreezing time'])) {
        $aliquot_uses[] = array('aliquot_master_id' => $aliquot_master_id,
            'use_code' => $excel_line_tube_data['number of defreezing time'],
            'type' => 'number of defreezing time'
        );
    }
    if(strlen($excel_line_tube_data['Contact'].$excel_line_tube_data['Reception date'])) {
        $excel_field = 'Reception date';
        if(preg_match('/^((200[1-9])|(201[0-9]))$/', $excel_line_tube_data[$excel_field])) {
            list($excel_use_date, $excel_use_date_accuracy) = array($excel_line_tube_data[$excel_field].'-01-01', 'm');
        } else {
            list($excel_use_date, $excel_use_date_accuracy) = validateAndGetDateAndAccuracy(
                $excel_line_tube_data[$excel_field],
                'Tube creation/update',
                "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
                "See value [".$excel_line_tube_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
            if($excel_use_date_accuracy == 'c') $excel_use_date_accuracy = 'h';        
            $aliquot_uses[] = array('aliquot_master_id' => $aliquot_master_id,
                'use_code' => 'From : '. ($excel_line_tube_data['Contact']? $excel_line_tube_data['Contact'] : '?'),
                'type' => 'reception at the CRCHUM',
                'use_datetime' => $excel_use_date,
                'use_datetime_accuracy' => $excel_use_date_accuracy
            );
        }
    }
    foreach($aliquot_uses as $new_use) {
        $new_use['aliquot_master_id'] = $aliquot_master_id;
        customInsertRecord(array('aliquot_internal_uses' => $new_use));
        
    }
    
}

// Collection fusion (post-process)
//-----------------------------------------

$query = "SELECT GROUP_CONCAT(DISTINCT id  SEPARATOR ',' ) res_ids, GROUP_CONCAT(DISTINCT collection_notes SEPARATOR '#||#' ) res_notes, participant_id, collection_datetime, collection_datetime_accuracy
    FROM collections
    WHERE deleted <> 1
    AND participant_id IS NOT NULL    
    AND id IN 
    (
       SELECT DISTINCT Collection.id
       FROM collections Collection
       INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
       INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
       WHERE Collection.deleted <> 1
       AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    )
    GROUP BY participant_id, collection_datetime, collection_datetime_accuracy";
$atimCollectionsToMerge = getSelectQueryResult($query);
foreach($atimCollectionsToMerge as $new_collections_set) {
    if(preg_match('/,/', $new_collections_set['res_ids'])) {
        $all_ids = explode(',',$new_collections_set['res_ids']);
        $collection_id_to_keep = array_shift($all_ids);
        $collection_ids_to_delete = implode(',',$all_ids);
        $notes = explode('#||#', $new_collections_set['res_notes']);
        $notes = array_filter($notes);
        $notes = implode('. ', $notes);
        customQuery("UPDATE collections
            SET deleted = 1,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE id IN ($collection_ids_to_delete) AND deleted <> 1");
        if(strlen($notes)) {
            customQuery("UPDATE collections
                SET collection_notes = '".str_replace("'", "''", $notes)."',
                modified = '".$import_date."',
                modified_by = ".$imported_by."
                WHERE id = $collection_id_to_keep AND deleted <> 1");
        }
        customQuery("UPDATE sample_masters
            SET collection_id = $collection_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE collection_id IN ($collection_ids_to_delete) AND deleted <> 1");
        customQuery("UPDATE aliquot_masters
            SET collection_id = $collection_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE collection_id IN ($collection_ids_to_delete) AND deleted <> 1");
    }
}

// Sample fusion (post-process)
//-----------------------------------------

$query = "SELECT
    Collection.participant_id,
    Collection.collection_datetime,
    Collection.collection_datetime_accuracy,
    SampleMaster.collection_id,
    GROUP_CONCAT(DISTINCT SampleMaster.id  SEPARATOR ',' ) sample_master_ids,
    SampleDetail.tissue_source,
    SampleDetail.qc_tf_tissue_type,
    SampleDetail.tissue_laterality
    FROM collections Collection
    INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
    INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
    WHERE SampleMaster.deleted <> 1
    AND Collection.deleted <> 1
    AND sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    GROUP BY SampleMaster.collection_id,
    Collection.participant_id,
    Collection.collection_datetime,
    Collection.collection_datetime_accuracy,
    SampleDetail.tissue_source,
    SampleDetail.qc_tf_tissue_type,
    SampleDetail.tissue_laterality;";
$atimSamplesToMerge = getSelectQueryResult($query);
foreach($atimSamplesToMerge as $new_samples_set) {
    if(preg_match('/,/', $new_samples_set['sample_master_ids'])) {
        $all_ids = explode(',',$new_samples_set['sample_master_ids']);
        $sample_id_to_keep = array_shift($all_ids);
        $sample_ids_to_delete = implode(',',$all_ids);
        customQuery("UPDATE sample_masters
            SET deleted = 1,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE id IN ($sample_ids_to_delete) AND deleted <> 1");
        customQuery("UPDATE sample_masters
            SET parent_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE parent_id IN ($sample_ids_to_delete) AND deleted <> 1");
        customQuery("UPDATE sample_masters
            SET initial_specimen_sample_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE initial_specimen_sample_id IN ($sample_ids_to_delete) AND deleted <> 1");
        customQuery("UPDATE aliquot_masters
            SET sample_master_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1");
        $query = "SELECT count(*) tt from quality_ctrls WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1";
        $countRes = getSelectQueryResult($query);
        $andQualtyCtrlMsg = ($countRes[0]['tt'])? " plus quality controls " : "";
        customQuery("UPDATE quality_ctrls
            SET sample_master_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1");
        $query = "SELECT count(*) tt from source_aliquots WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1";
        $countRes = getSelectQueryResult($query);
        if($countRes[0]['tt']) die('ERR 93939383');
        customQuery("UPDATE source_aliquots
            SET sample_master_id = $sample_id_to_keep,
            modified = '".$import_date."',
            modified_by = ".$imported_by."
            WHERE sample_master_id IN ($sample_ids_to_delete) AND deleted <> 1");
    }
}

// Stat
//-----------------------------------------

recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Collections : '.$created_collection_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Samples : '.$created_sample_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Tubes : '.$created_aliquot_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Storages : '.$created_storage_counter);

$last_queries_to_execute = array(
    "UPDATE sample_masters SET sample_code=id WHERE sample_code LIKE 'tmp_%';",
    "UPDATE sample_masters SET initial_specimen_sample_id=id WHERE parent_id IS NULL;",
    "UPDATE aliquot_masters SET barcode=id WHERE barcode LIKE 'tmp_%';",
    "UPDATE storage_masters SET code=id;",
    "UPDATE versions SET permissions_regenerated = 0;"
);
foreach($last_queries_to_execute as $query)	customQuery($query);

dislayErrorAndMessage($commit_all);

echo "<br><FONT COLOR=\"blue\">
=====================================================================<br>
<b>TISSUE NOT CREATED : TO REVIEW</b><br>
=====================================================================</FONT><br><br>";
$firstRecord = true;
foreach($aliquotNotMigrated AS $aliquotData) {
    if($firstRecord) {
        $newLineToDisplay = "\"";
        $newLineToDisplay .= implode("\";\"", $aliquotData);
        $newLineToDisplay .= "\"<br>";
        echo $newLineToDisplay;
    }
    $firstRecord = false;
    $newLineToDisplay = "\"";
    $newLineToDisplay .= implode("\";\"", $aliquotData);
    $newLineToDisplay .= "\"<br>";
    echo $newLineToDisplay;
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//Functions
//--------------------------------------------------------------------------------------------------------------------------------------------------------

function getATiMTissues() {
    $query = "SELECT Participant.id as participant_id,
        Participant.qc_tf_bank_id,
        Participant.participant_identifier,
        Participant.qc_tf_bank_identifier,

        TissueCollection.collection_id,
        TissueCollection.collection_datetime,
        TissueCollection.collection_datetime_accuracy,

        TissueCollection.sample_master_id,

        TissueCollection.tissue_source,
        TissueCollection.qc_tf_tissue_type,
        TissueCollection.tissue_laterality

        FROM participants Participant
        LEFT JOIN (
            SELECT 
            Collection.participant_id,
            Collection.id AS collection_id,
            Collection.collection_datetime,
            Collection.collection_datetime_accuracy,
    
            SampleMaster.id AS sample_master_id,
    
            SampleDetail.tissue_source,
            SampleDetail.qc_tf_tissue_type,
            SampleDetail.tissue_laterality,
    
            SpecimenDetail.reception_by,
            SpecimenDetail.reception_datetime,
            SpecimenDetail.reception_datetime_accuracy
        
            FROM collections Collection
            INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
            INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
            INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
    
            WHERE Collection.deleted <> 1
        
        ) TissueCollection ON TissueCollection.participant_id = Participant.id
        WHERE Participant.deleted <> 1;";
     
    $atim_tissue_collections = array();
    foreach(getSelectQueryResult($query) as $new_collection) {
        if(!isset($atim_tissue_collections[$new_collection['participant_identifier']])) {
            $atim_tissue_collections[$new_collection['participant_identifier']] = array(
                'participant_id' => $new_collection['participant_id'],
                'qc_tf_bank_id' => $new_collection['qc_tf_bank_id'],
                'participant_identifier' => $new_collection['participant_identifier'],
                'qc_tf_bank_identifier' => $new_collection['qc_tf_bank_identifier'],
                'collections' => array()                
            );
        }
        if($new_collection['collection_id']) {
            if(!isset($atim_tissue_collections[$new_collection['participant_identifier']]['collections'][$new_collection['collection_id']])) {
                $atim_tissue_collections[$new_collection['participant_identifier']]['collections'][$new_collection['collection_id']] = array(
                    'collection_id' => $new_collection['collection_id'],
                    'collection_datetime' => $new_collection['collection_datetime'],
                    'collection_datetime_accuracy' => $new_collection['collection_datetime_accuracy'],
                    'tissues' => array()
                );
            }
            $atim_tissue_collections[$new_collection['participant_identifier']]['collections'][$new_collection['collection_id']]['tissues'][$new_collection['sample_master_id']] = $new_collection;
        }
    }
    return $atim_tissue_collections;
}

?>
		