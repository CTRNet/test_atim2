<?php    
    
// *******************************************************************************************************************************************************
//
//    TFRI-COEUR
//
// *******************************************************************************************************************************************************
//
//	Script created to update the block data
//
// @created 2018-07-17
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

displayMigrationTitle('TFRI COEUR - Block Data Update', $bank_excel_files);

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

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Collection cleanup: Set block in stock value to no plus merge collection
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$query = "SELECT count(*) tt FROM specimen_review_masters;";
$countRev = getSelectQueryResult($query);
if($countRev[0]['tt']) { die('ERR8584874338');}

$query = "select count(*) tt  from aliquot_masters WHERE study_summary_id is not  null;";
$countRev = getSelectQueryResult($query);
if($countRev[0]['tt']) { pr($countRev);die('ERR8584211274338');}

// Blocks
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$query = "SELECT id, barcode, aliquot_label
	FROM aliquot_masters	
	WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
    AND deleted <> 1
	AND in_stock = 'no';";
foreach(getSelectQueryResult($query) as $newRecord) {
    recordErrorAndMessage(
        'Collections, tissues samples and blocks clean-up :: pre-migration',
        '@@WARNING@@',
        "Block defined as not in stock before migration. Block information (including the reason) won't be copied then past to the new created block. To migrate manually after the migration if required.",
        "Block TFRI# ".$newRecord['barcode']." (Aliquot TFRI Label : ".$newRecord['aliquot_label'].").");
}

$query = "SELECT id, barcode, aliquot_label
	FROM aliquot_masters
	WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
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
        'Collections, tissues samples and blocks clean-up :: pre-migration',
        '@@WARNING@@',
        "Block defined as used before migration. Block uses data won't be copied then past to the new created block. To migrate manually after the migration if required.",
        "Block TFRI# ".$newRecord['barcode']." (Aliquot TFRI Label : ".$newRecord['aliquot_label'].").");
}

$query = "SELECT COUNT(*) nbr_of_blocks
    FROM aliquot_masters
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
    AND deleted <> 1
    AND in_stock != 'no'";
$atimNbrOfBlocks = getSelectQueryResult($query);
$atimNbrOfBlocks = $atimNbrOfBlocks[0]['nbr_of_blocks'];
recordErrorAndMessage(
    'Collections, tissues samples and blocks clean-up :: pre-migration',
    '@@WARNING@@',
    "Changed the in stock value to 'no' for all existing blocks migrated before 2019 and that should be replaced by the data of the current migration.",
    "$atimNbrOfBlocks blocks updated");

$query = "UPDATE aliquot_masters
    SET in_stock = 'no',
    in_stock_detail = 'wrong block (1st migration)',
    storage_master_id = null,
    storage_coord_x = null,
    storage_coord_y = null,
    notes = CONCAT('Created by the 1st blocks migration script (before 2019) and supposed to be replaced by the new migration of blocks on ".$import_date.". ', IFNULL(notes, '')),
    modified = '".$import_date."',
    modified_by = ".$imported_by."
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
    AND deleted <> 1
    AND (in_stock_detail IS NULL OR in_stock_detail = '')
    AND in_stock != 'no'";
customQuery($query);    

$query = "UPDATE aliquot_masters
    SET in_stock = 'no',
    storage_master_id = null,
    storage_coord_x = null,
    storage_coord_y = null,
    notes = CONCAT('Created by the 1st blocks migration script (before 2019) and supposed to be replaced by the new migration of blocks on ".$import_date.". ', IFNULL(notes, '')),
    modified = '".$import_date."',
    modified_by = ".$imported_by."
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
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
            'Collections, tissues samples and blocks clean-up :: pre-migration',
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
        $sampleMsg = array();
        if($new_samples_set['tissue_source']) $sampleMsg[] = "tissue source = '".$new_samples_set['tissue_source']."'";
        if($new_samples_set['qc_tf_tissue_type']) $sampleMsg[] = "tissue type = '".$new_samples_set['qc_tf_tissue_type']."'";
        if($new_samples_set['tissue_laterality']) $sampleMsg[] = "tissue laterality = '".$new_samples_set['tissue_laterality']."'";
        if(!$sampleMsg) $sampleMsg[] = 'with no tissue property';
        $sampleMsg = implode(' ', $sampleMsg);
        recordErrorAndMessage(
            'Collections, tissues samples and blocks clean-up :: pre-migration',
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
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['tissue-block']['detail_tablename']);
addToModifiedDatabaseTablesList('source_aliquots', null);
addToModifiedDatabaseTablesList('quality_ctrls', null);

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Main Process
//--------------------------------------------------------------------------------------------------------------------------------------------------------

// Create storage
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$created_storage_counter = 0;
$created_storage_counter++;
$storage_controls = $atim_controls['storage_controls']['cupboard'];
$storage_data = array(
    'storage_masters' => array(
        "code" => 'tmp'.$created_storage_counter,
        "short_label" => 'TF 12e',
        "selection_label" => 'TF 12e',
        "storage_control_id" => $storage_controls['id'],
        "parent_id" => null),
    $storage_controls['detail_tablename'] => array());
$cupboard_storage_master_id = customInsertRecord($storage_data);

$atim_storage_key_to_storage_master_id = array();
$storageProperties = array(
    'tiroir chum' => 'CHUM', 
    'tiroir-3 chuq (chuq)' => '3#CHUQ', 
    'tiroir-5 voa;toronto;victoria (ovcare ; uhn ; ttr)' => '5#V.O.U.T',
    'tiroir-4 alberta (cbcf)' => '4#Alberta',
    'tiroir chus' => 'CHUS',
    'tiroir mcgill' => 'McGill',
    'tiroir chum_2 et winnipeg' => 'CHUM2/Win',
    'tiroir ohri' => 'OHRI',
    'tiroir-1 ottawa (ohri) et otb' => '1#Ohri.Otb',
    'tiroir ttr' => 'TTR'
);
$storage_controls = $atim_controls['storage_controls']['shelf'];
foreach($storageProperties as $excelField => $short_label) {
    $created_storage_counter++;
    $storage_data = array(
        'storage_masters' => array(
            "code" => 'tmp'.$created_storage_counter,
            "short_label" => $short_label,
            "selection_label" => 'TF 12e-'.$short_label,
            "storage_control_id" => $storage_controls['id'],
            "parent_id" => $cupboard_storage_master_id),
        $storage_controls['detail_tablename'] => array());
    $atim_storage_key_to_storage_master_id[$excelField] = customInsertRecord($storage_data);
}

$created_storage_counter++;
$storage_controls = $atim_controls['storage_controls']['room'];
$storage_data = array(
    'storage_masters' => array(
        "code" => 'tmp'.$created_storage_counter,
        "short_label" => 'R12.118',
        "selection_label" => 'R12.118',
        "storage_control_id" => $storage_controls['id'],
        "parent_id" => null),
    $storage_controls['detail_tablename'] => array());
$r12_118_storage_master_id = customInsertRecord($storage_data);

$created_storage_counter++;
$storage_controls = $atim_controls['storage_controls']['room'];
$storage_data = array(
    'storage_masters' => array(
        "code" => 'tmp'.$created_storage_counter,
        "short_label" => 'R12.112',
        "selection_label" => 'R12.112',
        "storage_control_id" => $storage_controls['id'],
        "parent_id" => null),
    $storage_controls['detail_tablename'] => array());
$r12_112_storage_master_id = customInsertRecord($storage_data);

// Block migration - Main code
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$atimBlocks = getATiMBlocks();
$atimTissues = getATiMTissues();

$blocksControl = array();
$created_collection_counter = 0;
$created_sample_counter = 0;
$created_aliquot_counter = 0;
$created_slide_counter = 0;
$dataUpdateCreationSummary = array();

$file_name = $bank_excel_files['file'];
$worksheetName = "COEUR";
$file_name_for_summary = "file '<b>$file_name :: $worksheetName</b>";
while($exceldata = getNextExcelLineData($file_name, $worksheetName)) {
    list($excel_line_counter, $excel_line_block_data) = $exceldata;
    
    // Check participant (if exists)
    // If not, next line.
    //--------------------------------------------------
    
    if($excel_line_block_data['availability blocks'] == 'control') {
        $blocksControl[] = array('line' => $excel_line_counter, 'excel_data' => $excel_line_block_data);
        continue;
    }
    $participantTfriNbr = $excel_line_block_data['COEUR-TFRI'];
    if(!isset($atimTissues[$participantTfriNbr])) {
        recordErrorAndMessage(
            'Participant definition',
            '@@ERROR@@',
            "Excel participant not found into ATiM based on Participant TFRI#. No data of the line will be migrated.",
            "See excel participant with Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        continue;
    }
    if(empty($excel_line_block_data['Biobank participant'])) {
        recordErrorAndMessage(
            'Participant definition',
            '@@WARNING@@',
            "The Participant Bank# is not completed into Excel. The identity of the participant can not be validated but data of the line will be migrated based on Participant TFRI# (only). Please validate match after the migration",
            "See excel participant with Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        
    } elseif($excel_line_block_data['Biobank participant'] != $atimTissues[$participantTfriNbr]['qc_tf_bank_identifier']) {
        recordErrorAndMessage(
            'Participant definition',
            '@@ERROR@@',
            "Excel and ATiM participants match on Participant TFRI# but are different based on Participant Bank#. The identity of the participant can not be validated. No data of the line will be migrated.",
            "For Participant TFRI# '<b>$participantTfriNbr</b>' on line $excel_line_counter, check the different Participant Bank# : (xls) ".$excel_line_block_data['Biobank participant']." != (atim) ".$atimTissues[$participantTfriNbr]['qc_tf_bank_identifier']." - line $excel_line_counter.");
        continue;
        
    }
    $atim_qc_tf_bank_id = null;
    if(!isset($atim_qc_tf_bank_id_from_name[$excel_line_block_data['Bank']])) {
        recordErrorAndMessage(
            'Participant definition',
            '@@ERROR@@',
            "Bank defined into Excel is unknwon. No data of the line will be migrated.",
            "See excel banq '<b>".$excel_line_block_data['Bank']."</b>' associated to the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        continue;
    } else {
        $atim_qc_tf_bank_id = $atim_qc_tf_bank_id_from_name[$excel_line_block_data['Bank']];
    }
    if($atim_qc_tf_bank_id != $atimTissues[$participantTfriNbr]['qc_tf_bank_id']) {
        recordErrorAndMessage(
            'Participant definition',
            '@@ERROR@@',
            "Participant match on Participant TFRI# but bank is different in ATiM and Excel. No data of the line will be migrated.",
            "See excel banq '<b>".$excel_line_block_data['Bank']."</b>' and ATiM bank '".$atim_qc_tf_bank_name_from_id[$atimTissues[$participantTfriNbr]['qc_tf_bank_id']]."' defined for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        continue;
    }
    
    // Participant found
    $participant_id = $atimTissues[$participantTfriNbr]['participant_id'];
       
    // Block Match : Try to match block with a block in ATiM based on the pathology nbr
    // $atim_blocks structure:
    //    - $atim_blocks[$new_block['participant_identifier']][$new_block['patho_dpt_block_code']][$new_block['aliquot_master_id']] = $new_block;
    //    - $atim_blocks[$new_block['participant_identifier']][$new_block['patho_dpt_block_code']][$new_block['aliquot_master_id']]['matched_excel_block_on_patho_nbr'] = false;
    //--------------------------------------------------------------------------------------------------------------------------------------------------------
    
    $excel_block_pathology_nbr = $excel_line_block_data['SampleID (Bloc pour TMA Lili)'];

    $tissue_sample_master_ids = array();
    $tissue_collection_ids = array();
    $all_atim_block_pathology_nbrs = array();
    if(isset($atimBlocks[$participantTfriNbr]) && strlen(trim($excel_block_pathology_nbr))) {
        $aliquot_master_id = null;
        foreach($atimBlocks[$participantTfriNbr] as $atim_aliquot_patho_dpt_block_code => $all_aliquots) {
            if(strlen($atim_aliquot_patho_dpt_block_code)) {
                $all_atim_block_pathology_nbrs[] = $atim_aliquot_patho_dpt_block_code;
                $excel_block_pathology_nbr_for_preg_match = str_replace(array( '-', ' ', '/', "\\"), array('.{0,1}', '.{0,1}', '.{0,1}', '.{0,1}'), $excel_block_pathology_nbr);
                $patternNumber = null;
                if(preg_match('/^((CBCF)|(OHRI))\-'.$excel_block_pathology_nbr_for_preg_match.'$/',$atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__;
                } else if(preg_match('/^'.$excel_block_pathology_nbr_for_preg_match.'$/',$atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__ . " - Exact match";
                } else if(preg_match('/^'.$excel_block_pathology_nbr_for_preg_match.'$/',$atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__;
                } else if(preg_match('/^'.str_replace('SF', 'CBCF\-SF\-', $excel_block_pathology_nbr_for_preg_match).'(\ [AB]){0,1}$/',$atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__;
                } else if(preg_match('/^'.str_replace('VOA', 'OVCARE\-', $excel_block_pathology_nbr_for_preg_match).'(\ [AB]){0,1}$/',$atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__;
                } else if(strlen($excel_block_pathology_nbr) > 4 && preg_match('/'.$excel_block_pathology_nbr_for_preg_match.'$/',$atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__;
                } else if(!strlen($atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__ . " - 1 block in ATiM with no pathology number";
                } else if(preg_match('/^(.*)\.\{0\,1\}[A-Z][0-9]{1,2}$/', $excel_block_pathology_nbr_for_preg_match, $matches) && preg_match('/^'.$matches[1].'$/',$atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__;
                } else if(preg_match('/^CHUM\-(.*)$/', $atim_aliquot_patho_dpt_block_code, $matches) && preg_match('/'.str_replace(array('-', ' '),array('\-','\-'), $matches[1]).'$/',$excel_block_pathology_nbr)) {
                    $patternNumber = __LINE__;
                } else if(preg_match('/'. str_replace(array(' ', '-', '/'), array('', '',''), $atim_aliquot_patho_dpt_block_code) .'$/', str_replace(array(' ', '-'), array('', ''), $excel_block_pathology_nbr))) {
                    $patternNumber = __LINE__;
                } else if(preg_match('/^'.$excel_block_pathology_nbr_for_preg_match.'/',$atim_aliquot_patho_dpt_block_code)) {
                    $patternNumber = __LINE__;
                } else if(preg_match('/^CHUM.*\-([0-9]+)\-([AZa-z0-9]+)$/', $atim_aliquot_patho_dpt_block_code, $matches) && preg_match('/'.$matches[1].'.*'.$matches[2].'$/',$excel_block_pathology_nbr)) {
                    $patternNumber = __LINE__;
                }
                if(!$patternNumber) {
                    // Pas de match avec le pathologi nbr.... message?
                    recordErrorAndMessage(
                        'Collection/Tissue/block definition',
                        '@@WARNING@@',
                        "No match between ATiM participant block and Excel block can be done on pathology number. Please confirm no match should be done.",
                        "See ATiM participant tissue linked to block with pathology nbr <b>$atim_aliquot_patho_dpt_block_code</b> and the excel block pathology nbr <b>$excel_block_pathology_nbr</b> ".
                        "for Participant TFRI# '<b>$participantTfriNbr</b>' on line $excel_line_counter.");
                } else {
                    foreach($all_aliquots as $atim_aliquot_master_id => $aliquot_data) {
                        $tissue_sample_master_ids[$aliquot_data['sample_master_id']] = $aliquot_data['sample_master_id'];
                        $tissue_collection_ids[$aliquot_data['collection_id']] = $aliquot_data['collection_id'];
                        $atimBlocks[$participantTfriNbr][$atim_aliquot_patho_dpt_block_code][$atim_aliquot_master_id]['matched_excel_block_on_patho_nbr'] = true;
                    }
                    recordErrorAndMessage(
                        'Collection/Tissue/block definition',
                        '@@MESSAGE@@',
                        "Match between ATiM participant block and Excel block can be done on pathology number. Please confirm.",
                        "See ATiM participant tissue linked to block with pathology nbr <b>$atim_aliquot_patho_dpt_block_code</b> and the excel block pathology nbr <b>$excel_block_pathology_nbr</b> ".
                        "for Participant TFRI# '<b>$participantTfriNbr</b>' on line $excel_line_counter.");
                }
            }   
        }
    } 
    
    $collection_id = null;
    $tissue_sample_master_id = null;
    if($tissue_sample_master_ids) {
        if(sizeof($tissue_sample_master_ids) > 1) {
            die('ERR 8388383838 - To support but should never happen');
        } else {
            // Perfect match
            $collection_id = array_shift($tissue_collection_ids);
            $tissue_sample_master_id = array_shift($tissue_sample_master_ids);
        }     
    } elseif(sizeof($atimTissues[$participantTfriNbr]['collections']) == 1) {

        // Block Match : Try to match block with a tissue in ATiM 
        //--------------------------------------------------------------------------------------------------------------------------------------------------------

        $keys = array_keys($atimTissues[$participantTfriNbr]['collections']);
        if(sizeof($atimTissues[$participantTfriNbr]['collections'][$keys[0]]['tissues']) == 1) {
            $keys2 = array_keys($atimTissues[$participantTfriNbr]['collections'][$keys[0]]['tissues']);
            $collection_id = $atimTissues[$participantTfriNbr]['collections'][$keys[0]]['tissues'][$keys2[0]]['collection_id'];
            $tissue_sample_master_id = $atimTissues[$participantTfriNbr]['collections'][$keys[0]]['tissues'][$keys2[0]]['sample_master_id'];
            recordErrorAndMessage(
                'Collection/Tissue/block definition',
                '@@ERROR@@',
                "No match between ATiM participant block and Excel block can be done on pathology number but only one ATiM tissue exists into ATiM. New block created from excel will be linked to this unique ATiM tissue.",
                "See unique ATiM participant tissue linked to block with ".(empty($all_atim_block_pathology_nbrs)? "no pathology nbr" : "pathology nbrs ". implode(' & ', $all_atim_block_pathology_nbrs)).
                " and Excel block with ".(empty($excel_block_pathology_nbr)? "<b>no pathology nbr</b>" : "pathology nbr <b>$excel_block_pathology_nbr</b>")." for Participant TFRI# '<b>$participantTfriNbr</b>' on line $excel_line_counter.");
        } else {
            recordErrorAndMessage(
                'Collection/Tissue/block definition',
                '@@WARNING@@',
                "No match between ATiM participant block and Excel block can be done on pathology number. Only one tissue colllection exists but many ATiM collection tissues exist into this ATiM collection. New block created from excel will be linked to this unique ATiM tissue collection but to a new created tissue.",
                "See unique ATiM participant tissue linked to block with ".(empty($all_atim_block_pathology_nbrs)? "no pathology nbr" : "pathology nbrs ". implode(' & ', $all_atim_block_pathology_nbrs)).
                " and Excel block with ".(empty($excel_block_pathology_nbr)? "<b>no pathology nbr</b>" : "pathology nbr <b>$excel_block_pathology_nbr</b>")." for Participant TFRI# '<b>$participantTfriNbr</b>' on line $excel_line_counter.");
        }
    } else {
        recordErrorAndMessage(
            'Collection/Tissue/block definition',
            '@@WARNING@@',
            "No match between ATiM participant block and Excel block can be done on pathology number and many tissue colllections exists. New block created from excel will be linked to a new ATiM tissue collection and a new created tissue.",
            "See unique ATiM participant tissue linked to block with ".(empty($all_atim_block_pathology_nbrs)? "no pathology nbr" : "pathology nbrs ". implode(' & ', $all_atim_block_pathology_nbrs)).
            " and Excel block with ".(empty($excel_block_pathology_nbr)? "<b>no pathology nbr</b>" : "pathology nbr <b>$excel_block_pathology_nbr</b>")." for Participant TFRI# '<b>$participantTfriNbr</b>' on line $excel_line_counter.");
    }
    
    // Excel Block Data Validation
    //--------------------------------------------------------------------------------------------------------------------------------------------------------
    
    // Collection date
    $excel_field = "Block date";
    $excel_collection_date = null;
    $excel_collection_date_accuracy = '';
    if($excel_line_block_data[$excel_field] && preg_match('/^((19)|(20))[0-9]{2}$/', $excel_line_block_data[$excel_field])) {
        $excel_collection_date = $excel_line_block_data[$excel_field];
        $excel_collection_date_accuracy = 'm';
        if($collection_id && !preg_match("/^$excel_collection_date/", $atimTissues[$participantTfriNbr]['collections'][$collection_id]['collection_datetime'])) {
            recordErrorAndMessage(
                'Collection/Tissue/block definition',
                '@@WARNING@@',
                "Collection date between a selected collection and the excel block collection date are different. New collection will be created.",
                "See excel collection on '$excel_collection_date' and ATiM collection on ".$atimTissues[$participantTfriNbr]['collections'][$collection_id]['collection_datetime']." for Participant TFRI# '<b>$participantTfriNbr</b>' on line $excel_line_counter."); 
            $collection_id = null;
            $tissue_sample_master_id = null;
        }
        $excel_collection_date .= '-01-01 01:01:01';
    } else if($excel_line_block_data[$excel_field]) {
        die('ERR237862378236');
        list($excel_collection_date, $excel_collection_date_accuracy) = validateAndGetDateAndAccuracy(
            $excel_line_block_data[$excel_field],
            'Block creation/update',
            "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
            "See value [".$excel_line_block_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    }
    
    // Tissue laterality - source - type
    $excel_field = "Latérality block";
    
    $excel_laterality_msg = strlen($excel_line_block_data[$excel_field])? "Latérality block value in excel [".$excel_line_block_data[$excel_field]."]." : '';

    // Block in stock detail
    $excel_field = 'availability blocks';
    
    $in_stock = 'yes - available';
    if($excel_line_block_data[$excel_field] == 'no') {
        $in_stock = 'no';
    } elseif($excel_line_block_data[$excel_field] != 'yes')  {
        recordErrorAndMessage(
            'Block creation/update',
            '@@ERROR@@',
            "The 'availability blocks' excel value is not supported. Please validate and clean up data after the migration.",
            "See value [".$excel_line_block_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    }
    
    // Block in stock detail
    $storageA = strtolower(str_replace('.', '', $excel_line_block_data['Emplacement-A']));
    $storageB = strtolower(str_replace('.', '', $excel_line_block_data['Emplacement-B']));
    
    $storage_master_id = null;
    $shipping_summary = '';
    if($storageA == 'armoire tf 12e') {
        if(isset($atim_storage_key_to_storage_master_id[$storageB])) {
            $storage_master_id = $atim_storage_key_to_storage_master_id[$storageB];
        } else {
            recordErrorAndMessage(
                'Block creation/update - storage definition',
                '@@ERROR@@',
                "The excel 'Emplacement-B' value does not match a CRCHUM cupboard shelf value expected and the 'Emplacement-A' is equalt to 'Armoire TF 12e'. Aliquot won't be defined as stored into a storage. Please validate and clean up data after the migration.",
                "See storage values [A = '$storageA' & B = '$storageB'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        }        
    } elseif(strlen($storageA.$storageB)) {
        // Check B
        if(isset($atim_storage_key_to_storage_master_id[$storageB])) {
            recordErrorAndMessage(
                'Block creation/update - storage definition',
                '@@ERROR@@',
                "The excel 'Emplacement-B' value match a CRCHUM cupboard shelf value but the 'Emplacement-A' is not equal to 'Armoire TF 12e'. Aliquot won't be defined as stored into a storage. Please validate and clean up data after the migration.",
                "See storage values [A = '$storageA' & B = '$storageB'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        } elseif(strlen($storageB)) {
            die('ERR File ' . __FILE__ .' Line ' . __LINE__);   // Case to support
        }
        // Check A
        if($storageA == 'A remettre a la biobanque') {
            recordErrorAndMessage(
                'Block creation/update - storage definition',
                '@@WARNING@@',
                "The 'Emplacement-A' is equal to 'A remettre a la biobanque'. Information won't be migrated. Aliquot won't be defined as stored into a storage. Please validate and clean up data after the migration.",
                "See storage values [A = '$storageA' & B = '$storageB'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        } elseif(strlen($storageA)) {
            $shipping_summary = $storageA;
            recordErrorAndMessage(
                'Block creation/update - storage definition',
                '@@MESSAGE@@',
                "Created a shipping message from 'Emplacement-A'. Please validate and clean up data after the migration.",
                "See shipping message '$shipping_summary' from storage values [A = '$storageA' & B = '$storageB']",
                "$storageA // $storageB");
        }
    } else {
        // No position
    }
    
    if($in_stock == 'no' && $storage_master_id) {
        recordErrorAndMessage(
            'Block creation/update - storage definition',
            '@@ERROR@@',
            "The 'availability blocks' value set to 'no' but storage position is defined based on 'Emplacement-A & B' values. Aliquot won't be defined as stored into a storage. Please validate and clean up data after the migration.",
            "See storage value [A = '$storageA' & B = '$storageB'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        $storage_master_id = null;
    }
    if($in_stock != 'no' && $shipping_summary) {
        recordErrorAndMessage(
            'Block creation/update - storage definition',
            '@@ERROR@@',
            "The 'availability blocks' value set to 'available' but shipping info exists (based on 'Emplacement-A & B'). Please validate and clean up data after the migration.",
            "See value '$shipping_summary' from storage value [A = '$storageA' & B = '$storageB'] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    }
    
    // Block other fields
    $excel_field= 'cellularity';
    $qc_tf_cellularity = validateAndGetInteger(
        str_replace(array('N/A', '#N/A'), array('',''), $excel_line_block_data[$excel_field]),
        'Block creation/update',
        "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
        "See value [".$excel_line_block_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    
    $excel_field= 'Quantity available';
    $qc_tf_quantity_available = validateAndGetStructureDomainValue(
        $excel_line_block_data[$excel_field],
        'qc_tf_quantity_available',
        'Block creation/update',
        "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
        "See value [".$excel_line_block_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");

    // Block Creation
    //--------------------------------------------------------------------------------------------------------------------------------------------------------
    
    if(!$collection_id) {
        $created_collection_counter++;
        $collection_id = customInsertRecord(array(
            'collections' => array(
                'participant_id' => $participant_id,
                'collection_property' => 'participant collection',
                'collection_datetime' => $excel_collection_date,
                'collection_datetime_accuracy' => $excel_collection_date_accuracy)));
    }
    
    if(!$tissue_sample_master_id) {
        $created_sample_counter++;
        $sample_data = array(
            'sample_masters' => array(
                "sample_code" => 'tmp_tissue_'.$created_sample_counter,
                "sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
                "initial_specimen_sample_type" => 'tissue',
                "collection_id" => $collection_id),
            'specimen_details' => array(),
            $atim_controls['sample_controls']['tissue']['detail_tablename'] => array());
        $tissue_sample_master_id = customInsertRecord($sample_data);
    }

    $created_aliquot_counter++;
    $new_notes = array(
        str_replace("'", "''", $excel_laterality_msg),
        str_replace("'", "''", $excel_line_block_data['notes from biobank']),
        str_replace("'", "''", $excel_line_block_data['NOTES (other)'])
    );
    if(strlen($excel_line_block_data['Block number'])) $new_notes[] = "Block number from XLS file : " . $excel_line_block_data['Block number'];
    
    $new_notes = array_filter($new_notes);
    $new_notes = implode('. ',$new_notes);
    if($new_notes) $new_notes .='.';
    $aliquot_data = array(
        'aliquot_masters' => array(
            "barcode" => 'tmp_'.$created_aliquot_counter,
            'aliquot_label' => str_replace("'", "''", $excel_block_pathology_nbr), //"FFPE $participantTfriNbr",
            "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
            "collection_id" => $collection_id,
            "sample_master_id" => $tissue_sample_master_id,
            'storage_master_id' => $storage_master_id,
            'in_stock' => $in_stock,
            'in_stock_detail' => '',
            'notes' => $new_notes
        ),
        $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
            'block_type' => 'paraffin',
            'patho_dpt_block_code' => str_replace("'", "''", $excel_block_pathology_nbr),
            'qc_tf_cellularity' => $qc_tf_cellularity,
            'qc_tf_quantity_available' => $qc_tf_quantity_available,
        ));
    $aliquot_master_id = customInsertRecord($aliquot_data);
    
    completeBlockEvents($excel_line_block_data, $excel_line_counter, $participantTfriNbr, $collection_id, $tissue_sample_master_id, $aliquot_master_id, $r12_112_storage_master_id, $r12_118_storage_master_id, $created_slide_counter, $shipping_summary, $in_stock);
}

// List ATiM block not used
foreach($atimBlocks as $participantTfriNbr => $allBlocksLvl1) {
    foreach($allBlocksLvl1 as $pathoNbr => $allBlocksLvl2) {
        foreach($allBlocksLvl2 as $aliquot_master_id => $blockData) {
            if(!$blockData['matched_excel_block_on_patho_nbr']) {
                if($blockData['patho_dpt_block_code']) {
                    recordErrorAndMessage(
                        'ATiM and Excel block match',
                        '@@WARNING@@',
                        "ATiM block not re-used (not found into excel) based on patho nbr. Please validate block should be keep into ATiM or if this one has been used as control then clean up data after the migration.",
                        "ATiM Block TFRI# ".$blockData['barcode']." (Aliquot TFRI Label : ".$blockData['aliquot_label']." / Pathology label <b>".$blockData['patho_dpt_block_code']."</b>).");
                } else {
                    recordErrorAndMessage(
                        'ATiM and Excel block match',
                        '@@WARNING@@',
                        "ATiM block not re-used (not found into excel) based on patho nbr cause this one is unknown. Please validate block should be keep into ATiM or if this one has been used as control then clean up data after the migration.",
                        "ATiM Block TFRI# ".$blockData['barcode']." (Aliquot TFRI Label : ".$blockData['aliquot_label']." / Pathology label <b>".$blockData['patho_dpt_block_code']."</b>).");
                }
            }
        }
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

// Block control
//-----------------------------------------

if($blocksControl) {
    $control_collection_id = customInsertRecord(array(
        'collections' => array(       
            'collection_property' => 'independent collection',
            'collection_notes' => 'Controls')));
    
    foreach($blocksControl as $new_control) {
        $excel_line_counter = $new_control['line'];
        $excel_line_block_data = $new_control['excel_data'];
        
        // Tissue laterality - source - type
        $excel_field = "Latérality block";

        $excel_laterality_msg = strlen($excel_line_block_data[$excel_field])? "Latérality block value in excel '".$excel_line_block_data[$excel_field]."'." : '';
        
        // Block in stock detail
        $excel_field = 'availability blocks';
        
        $in_stock = 'yes - available';
        if($excel_line_block_data[$excel_field] != 'control') {
            die('ERR File ' . __FILE__ .' Line ' . __LINE__);
        }
        
        // Block in stock detail
        $storageA = strtolower(str_replace('.', '', $excel_line_block_data['Emplacement-A']));
        $storageB = strtolower(str_replace('.', '', $excel_line_block_data['Emplacement-B']));
        
        $storage_master_id = null;
        $shipping_summary = '';
        if($storageA == 'armoire tf 12e') {
            if(isset($atim_storage_key_to_storage_master_id[$storageB])) {
                $storage_master_id = $atim_storage_key_to_storage_master_id[$storageB];
            } else {
                die('ERR File ' . __FILE__ .' Line ' . __LINE__);
            }
        } elseif(strlen($storageA.$storageB)) {
            die('ERR File ' . __FILE__ .' Line ' . __LINE__);
        }
        
        // Block other fields
        $excel_field= 'cellularity';
        $qc_tf_cellularity = validateAndGetInteger(
            str_replace(array('N/A', '#N/A'), array('',''), $excel_line_block_data[$excel_field]),
            'Block creation/update',
            "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
            "See value [".$excel_line_block_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        
        $excel_field= 'Quantity available';
        $qc_tf_quantity_available = validateAndGetStructureDomainValue(
            $excel_line_block_data[$excel_field],
            'qc_tf_quantity_available',
            'Block creation/update',
            "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
            "See value [".$excel_line_block_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        
        $created_sample_counter++;
        $sample_data = array(
            'sample_masters' => array(
                "sample_code" => 'tmp_tissue_'.$created_sample_counter,
                "sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
                "initial_specimen_sample_type" => 'tissue',
                "collection_id" => $control_collection_id),
            'specimen_details' => array(),
            $atim_controls['sample_controls']['tissue']['detail_tablename'] => array());
        
        $sample_master_id = customInsertRecord($sample_data);
        $created_aliquot_counter++;
        $excel_block_pathology_nbr = $excel_line_block_data['SampleID (Bloc pour TMA Lili)'];
        $aliquot_data = array(
            'aliquot_masters' => array(
                "barcode" => 'tmp_'.$created_aliquot_counter,
                'aliquot_label' => "CONTROL ".str_replace("'", "''", $excel_block_pathology_nbr),
                "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
                "collection_id" => $control_collection_id,
                "sample_master_id" => $sample_master_id,
                'storage_master_id' => $storage_master_id,
                'in_stock' => $in_stock,
                'in_stock_detail' => '',
                'notes' => str_replace("'", "''", $excel_laterality_msg)
            ),
            $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
                'block_type' => 'paraffin',
                'patho_dpt_block_code' => str_replace("'", "''", $excel_block_pathology_nbr),
                'qc_tf_cellularity' => $qc_tf_cellularity,
                'qc_tf_quantity_available' => $qc_tf_quantity_available,
            ));
        $aliquot_master_id = customInsertRecord($aliquot_data);
        
        recordErrorAndMessage(
            'Block control creation',
            '@@MESSAGE@@',
            "Block Control Creation.",
            "Created ["."CONTROL ".str_replace("'", "''", $excel_block_pathology_nbr)."] from line $excel_line_counter.");
        

        completeBlockEvents($excel_line_block_data, $excel_line_counter, 'CONTROL', $control_collection_id, $sample_master_id, $aliquot_master_id, $r12_112_storage_master_id, $r12_118_storage_master_id, $created_slide_counter, $shipping_summary, $in_stock);
    }
}

// Stat
//-----------------------------------------

recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Collections : '.$created_collection_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Samples : '.$created_sample_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Blocks : '.$created_aliquot_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Slides : '.$created_slide_counter);
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

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//Functions
//--------------------------------------------------------------------------------------------------------------------------------------------------------


function completeBlockEvents($excel_line_block_data, $excel_line_counter, $participantTfriNbr, $collection_id, $sample_master_id, $aliquot_master_id, $r12_112_storage_master_id, $r12_118_storage_master_id, &$created_slide_counter, $shipping_summary, $in_stock) {
    global $atim_controls;
    
    // reception information

    $excel_field = "Reception date";
    list($reception_date, $reception_date_accuracy) = validateAndGetDateAndAccuracy(
        $excel_line_block_data[$excel_field],
        'Block Events and Slides Creation',
        $excel_field,
        "Value won't be used by migration process - see line $excel_line_counter.");
    $excel_field = "Received by";
    $reception_by = validateAndGetStructureDomainValue(
        str_replace(array("Cécile", "Liliane Meunier"), array("Cecile", "Liliane"), $excel_line_block_data[$excel_field]),
        'custom_laboratory_staff',
        'Block Events and Slides Creation',
        "Reception by",
        "Value won't be used by migration process - see line $excel_line_counter.");
    $fromInfo = array();
    if($excel_line_block_data['Bank']) $fromInfo[] = $excel_line_block_data['Bank'];
    if($excel_line_block_data['Contact name']) $fromInfo[] = $excel_line_block_data['Contact name'];
    $fromInfo = implode(' / ', $fromInfo);
    if($fromInfo) $fromInfo = "From $fromInfo";
    if($reception_date.$reception_by.$fromInfo) {
        customInsertRecord(array(
            'aliquot_internal_uses' => array(
                'aliquot_master_id' => $aliquot_master_id,
                'type' => 'reception (from bank)',
                'use_code' => $fromInfo,
                'used_by' => $reception_by,
                'use_datetime' => $reception_date,
                'use_datetime_accuracy' => $reception_date_accuracy)));
    }

    // H&E slide

    $slide_notes = array();
    if(strlen($excel_line_block_data['H&E done by']))  $slide_notes[] = 'Done by : ' . $excel_line_block_data['H&E done by'];
    if(strlen($excel_line_block_data['H&E vérified by']))  $slide_notes[] = 'Checked by : ' . $excel_line_block_data['H&E vérified by'];
    if(strlen($excel_line_block_data['H&E available']))  $slide_notes[] = 'Availability : ' . $excel_line_block_data['H&E available'];
    $slide_notes = str_replace("'", "''", implode('. ', $slide_notes).'.');

    if(strlen($slide_notes.$excel_line_block_data['H&E date'])) {
        $slide_storage_master_id = null;
        if(preg_match('/R12\.112/', $excel_line_block_data['H&E available'])) {
            $slide_storage_master_id = $r12_112_storage_master_id;
        } else if(preg_match('/R12\.118/', $excel_line_block_data['H&E available'])) {
            $slide_storage_master_id = $r12_118_storage_master_id;
        }
        $created_slide_counter++;
        $aliquot_data = array(
            'aliquot_masters' => array(
                "barcode" => 'tmp_core_'.$created_slide_counter,
                'aliquot_label' => "H&E [TFRI#$participantTfriNbr]",
                "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-slide']['id'],
                "collection_id" => $collection_id,
                "sample_master_id" => $sample_master_id,
                'storage_master_id' => $slide_storage_master_id,
                'in_stock' => ($slide_storage_master_id? 'yes - available' : 'no'),
                'notes' => $slide_notes),
            $atim_controls['aliquot_controls']['tissue-slide']['detail_tablename'] => array(
                'immunochemistry' => 'H&E',));
        $he_slide_aliquot_master_id = customInsertRecord($aliquot_data);

        $excel_field = 'H&E date';
        list($realiquoting_datetime, $realiquoting_datetime_accuracy) = validateAndGetDateAndAccuracy($excel_line_block_data[$excel_field], 'Block Events and Slides Creation', $excel_field, "Value won't be used by migration process - see line $excel_line_counter.");

        $realiquoting_data = array('realiquotings' => array(
            'parent_aliquot_master_id' => $aliquot_master_id,
            'child_aliquot_master_id' => $he_slide_aliquot_master_id,
            'realiquoting_datetime' => $realiquoting_datetime,
            'realiquoting_datetime_accuracy' => $realiquoting_datetime_accuracy));

        customInsertRecord($realiquoting_data);
    }

    // Slide revisions
    
    if(strlen($excel_line_block_data['Révision date at the CHUM'].$excel_line_block_data['Notes by Dr Rahimi'])) {
        $use_details = array($excel_line_block_data['Notes by Dr Rahimi']);
        $excel_field = 'Révision date at the CHUM';
        list($use_datetime, $use_datetime_accuracy) = validateAndGetDateAndAccuracy(
            $excel_line_block_data[$excel_field],
            'Block Events and Slides Creation',
            $excel_field,
            "Value won't be used by migration process - see line $excel_line_counter.");
        if($excel_line_block_data[$excel_field] && !$use_datetime) {
            $use_details[] = 'Date info : '.$excel_line_block_data[$excel_field];
        }
        customInsertRecord(array(
            'aliquot_internal_uses' => array(
                'aliquot_master_id' => $aliquot_master_id,
                'type' => 'slide revision',
                'use_code' => 'H&E Slide',
                'used_by' => 'dr rahimi',
                'use_datetime' => $use_datetime,
                'use_datetime_accuracy' => $use_datetime_accuracy,
                'use_details' => str_replace("'", "''", implode('. ', $use_details)))));
    }
    
    //return to bank
    if(strlen($excel_line_block_data['Shipping to'].$excel_line_block_data['Shipping by'].$excel_line_block_data['Shipping date'].$excel_line_block_data['Shipping fedex #'])) {
        $excel_field = 'Shipping date';
        $newdate = '';
        switch($excel_line_block_data[$excel_field]) {
            case 'janvier 2014':
                $newdate = '2014-01-xx';
                break;
            case 'septembre 2013':
                $newdate = '2013-09-xx';
                break;
            case '20 janvier 2016':
                $newdate = '2016-01-20';
                break;
            case 'septembre 2014':
                $newdate = '2014-09-xx';
                break;
            case 'Aout 2018':
                $newdate = '2018-08-xx';
                break;
            case 'juillet 2012':
                $newdate = '2012-07-xx';
                break;
            case '7/2012':
                $newdate = '2012-07-xx';
                break;
            case 'fev 2012':
                $newdate = '2012-02-xx';
                break;
            case '12-06-218':
                $newdate = '2018-06-12';
                break;
        }
        if($newdate) {
            recordErrorAndMessage(
                'Block Events and Slides Creation',
                '@@WARNING@@',
                "Changed wrong $excel_field format to a good one. Please validate",
                "See value '".$excel_line_block_data[$excel_field]."' changed to '$newdate'",
                $excel_line_block_data[$excel_field]);
             $excel_line_block_data[$excel_field]=$newdate;
        }
        list($ship_date, $ship_date_accuracy) = validateAndGetDateAndAccuracy(
            $excel_line_block_data[$excel_field],
            'Block Events and Slides Creation',
            $excel_field,
            "Value won't be used by migration process - see line $excel_line_counter.");

        $excel_field = 'Shipping by';
        $ship_by = validateAndGetStructureDomainValue(
            str_replace(
                array('Cecile et Jason' , 'Cecile LePage' , "Cécile", "Liliane Meunier","Cecile Lepage", "Isabelle Clément", 'Cecile LePage et Jason'), 
                array("Cecile", "Cecile", "Cecile", "Liliane","Cecile", "Isabelle","Cecile"), $excel_line_block_data[$excel_field]),
            'custom_laboratory_staff',
            'Block Events and Slides Creation',
            $excel_field,
            "Value won't be used by migration process - see line $excel_line_counter.");
        customInsertRecord(array(
            'aliquot_internal_uses' => array(
                'aliquot_master_id' => $aliquot_master_id,
                'type' => 'returned (to bank)',
                'use_code' => 'To '.(strlen($excel_line_block_data['Shipping to'])? $excel_line_block_data['Shipping to'] : '?').($shipping_summary? ' / ' .$shipping_summary : ''),
                'used_by' => $ship_by,
                'use_datetime' => $ship_date,
                'use_datetime_accuracy' => $ship_date_accuracy,
                'use_details' => (strlen($excel_line_block_data['Shipping fedex #'])? 'Fedex : ' .$excel_line_block_data['Shipping fedex #'] : '')))); 
        if($in_stock != 'no') {
            recordErrorAndMessage(
                'Block Events and Slides Creation',
                '@@ERROR@@',
                "The block has been defined as returned to biobank but in stock value is different than 'no'. Please validate and clean up/create data after the migration.",
                "See block  for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
        }
    }
    
    // other slide
    if(strlen($excel_line_block_data['Biomarker']) < 6 || preg_match('/,/', $excel_line_block_data['Biomarker'])) {
        $biomarkers = explode(',', str_replace(' ', '', $excel_line_block_data['Biomarker']));
        $biomarkers = array_filter($biomarkers);
        foreach($biomarkers as $new_marker) {
            $created_slide_counter++;
            $aliquot_data = array(
                'aliquot_masters' => array(
                    "barcode" => 'tmp_core_'.$created_slide_counter,
                    'aliquot_label' => "$new_marker [TFRI#$participantTfriNbr]",
                    "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-slide']['id'],
                    "collection_id" => $collection_id,
                    "sample_master_id" => $sample_master_id,
                    'in_stock' => 'yes - available',
                    'notes' => ''),
                $atim_controls['aliquot_controls']['tissue-slide']['detail_tablename'] => array(
                    'immunochemistry' => $new_marker,));
            $other_slide_aliquot_master_id = customInsertRecord($aliquot_data);

            $realiquoting_data = array('realiquotings' => array(
                'parent_aliquot_master_id' => $aliquot_master_id,
                'child_aliquot_master_id' => $other_slide_aliquot_master_id));

            customInsertRecord($realiquoting_data);

            recordErrorAndMessage(
               'Block Events and Slides Creation',
                '@@ERROR@@',
                "Created other marker slide.",
                "See value '$new_marker'",
                $new_marker);
        }
    } else if(strlen($excel_line_block_data['Biomarker'])) {
        recordErrorAndMessage(
            'Block Events and Slides Creation',
            '@@ERROR@@',
            "The 'Biomarker' value is not supported. Please validate and clean up/create data after the migration.",
            "See value '".$excel_line_block_data['Biomarker']."' for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    }
}

function getATiMBlocks() {
    $query = "SELECT Participant.id as participant_id,
        Participant.qc_tf_bank_id,
        Participant.participant_identifier,
        Participant.qc_tf_bank_identifier,
        
        Collection.id AS collection_id,
        Collection.collection_datetime,
        Collection.collection_datetime_accuracy,
        
        SampleMaster.id AS sample_master_id,
        
        SampleDetail.tissue_source,
        SampleDetail.qc_tf_tissue_type,
        SampleDetail.tissue_laterality,
        
        SpecimenDetail.reception_by,
        SpecimenDetail.reception_datetime,
        SpecimenDetail.reception_datetime_accuracy,
        
        AliquotMaster.id AS aliquot_master_id,
        AliquotMaster.barcode,
        AliquotMaster.aliquot_label,
        AliquotMaster.aliquot_control_id,
        AliquotMaster.notes,
        AliquotMaster.in_stock,
        AliquotMaster.storage_master_id,
        AliquotMaster.storage_coord_x,
        AliquotMaster.storage_coord_y,
        
        AliquotDetail.block_type,
        AliquotDetail.patho_dpt_block_code,
        AliquotDetail.qc_tf_cellularity,
        AliquotDetail.qc_tf_quantity_available
        
        FROM participants Participant
        INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
        INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
        INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
        INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
        INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id AND AliquotMaster.deleted <> 1
        INNER JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
        
        WHERE AliquotMaster.aliquot_control_id = 8;";
    
    $atim_blocks = array();
    foreach(getSelectQueryResult($query) as $new_block) {
        $atim_blocks[$new_block['participant_identifier']][$new_block['patho_dpt_block_code']][$new_block['aliquot_master_id']] = $new_block; 
        $atim_blocks[$new_block['participant_identifier']][$new_block['patho_dpt_block_code']][$new_block['aliquot_master_id']]['matched_excel_block_on_patho_nbr'] = false;
    }
    return $atim_blocks;
}

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
		