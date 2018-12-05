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
// Collection cleanup: Delete all existing blocks (unused) plus merge collection
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$query = "SELECT count(*) tt FROM specimen_review_masters;";
$countRev = getSelectQueryResult($query);
if($countRev[0]['tt']) { die('ERR8584874338');}

// Blocks
//----------------------------------------------------------------------------------

$query = "SELECT COUNT(*) nbr_of_blocks
    FROM aliquot_masters
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
    AND deleted <> 1";
$atimNbrOfBlocks = getSelectQueryResult($query);
$atimNbrOfBlocks = $atimNbrOfBlocks[0]['nbr_of_blocks'];
$query = "SELECT COUNT(*) nbr_of_tubes
    FROM aliquot_masters
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-tube']['id']."
    AND deleted <> 1";
$atimNbrOfTissueTubes = getSelectQueryResult($query);
$atimNbrOfTissueTubes= $atimNbrOfTissueTubes[0]['nbr_of_tubes'];
$query = "SELECT COUNT(*) nbr_of_tissues
    FROM sample_masters
    WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    AND deleted <> 1";
$atimNbrOfTissues = getSelectQueryResult($query);
$atimNbrOfTissues = $atimNbrOfTissues[0]['nbr_of_tissues'];

$query = "SELECT COUNT(*) nbr_of_tissue_collections
    FROM collections
    WHERE id IN (SELECT collection_id FROM sample_masters WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']." AND deleted <> 1)
    AND deleted <> 1";
$atimNbrOfTissueCollections = getSelectQueryResult($query);
$atimNbrOfTissueCollections = $atimNbrOfTissueCollections[0]['nbr_of_tissue_collections'];

$queries = array(
    "UPDATE aliquot_masters 
    SET deleted = 1
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
    AND deleted <> 1
    AND id NOT IN (
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
    )",
    
    "UPDATE sample_masters
    SET deleted = 1
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
    AND deleted <> 1",
    
    "UPDATE Collections
    SET deleted = 1
    WHERE id NOT IN (
        SELECT collection_id FROM sample_masters WHERE deleted <> 1 
        UNION ALL
        SELECT collection_id FROM specimen_review_masters WHERE deleted <> 1
    ) AND deleted <> 1"
);
foreach($queries as $query)	{
    customQuery($query);
}

$query = "SELECT COUNT(*) nbr_of_blocks
    FROM aliquot_masters
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
    AND deleted <> 1";
$atimAfterNbrOfBlocks = getSelectQueryResult($query);
$atimAfterNbrOfBlocks = $atimAfterNbrOfBlocks[0]['nbr_of_blocks'];
$query = "SELECT COUNT(*) nbr_of_tubes
    FROM aliquot_masters
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-tube']['id']."
    AND deleted <> 1";
$atimAfterNbrOfTissueTubes = getSelectQueryResult($query);
$atimAfterNbrOfTissueTubes= $atimAfterNbrOfTissueTubes[0]['nbr_of_tubes'];
$query = "SELECT COUNT(*) nbr_of_tissues
    FROM sample_masters
    WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']."
    AND deleted <> 1";
$atimAfterNbrOfTissues = getSelectQueryResult($query);
$atimAfterNbrOfTissues = $atimAfterNbrOfTissues[0]['nbr_of_tissues'];

$query = "SELECT COUNT(*) nbr_of_tissue_collections
    FROM collections
    WHERE id IN (SELECT collection_id FROM sample_masters WHERE sample_control_id = ".$atim_controls['sample_controls']['tissue']['id']." AND deleted <> 1)
    AND deleted <> 1";
$atimAfterNbrOfTissueCollections = getSelectQueryResult($query);
$atimAfterNbrOfTissueCollections = $atimAfterNbrOfTissueCollections[0]['nbr_of_tissue_collections'];

recordErrorAndMessage(
    'Collections and blocks clean-up pre-migration',
    '@@WARNING@@',
    "Deletion of 'unused' ATiM blocks before migration.",
    "Deleted ".($atimNbrOfBlocks-$atimAfterNbrOfBlocks)."/$atimNbrOfBlocks blocks, ".($atimNbrOfTissues-$atimAfterNbrOfTissues)."/$atimNbrOfTissues tissues and ".($atimNbrOfTissueCollections-$atimAfterNbrOfTissueCollections)."/$atimNbrOfTissueCollections collections");

$query = "SELECT id, barcode, aliquot_label, patho_dpt_block_code
    FROM aliquot_masters
    INNER JOIN ".$atim_controls['aliquot_controls']['tissue-block']['detail_tablename']." ON id = aliquot_master_id
    WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-block']['id']."
    AND deleted <> 1";
$atimBlocks = getSelectQueryResult($query);
foreach($atimBlocks as $atimBlockKeep) {
    recordErrorAndMessage(
        'Collections and blocks clean-up pre-migration',
        '@@WARNING@@',
        "Undeleted block (because they are probably flagged as used into ATiM). Will try to link them to an Excel block. Please validate.",
        "Block TFRI# ".$atimBlockKeep['barcode']." (Aliquot TFRI Label : ".$atimBlockKeep['aliquot_label'].", Pathology number : ".$atimBlockKeep['patho_dpt_block_code']."). ");
}

// Collection fusion (pre-process)
//-----------------------------------------

$query = "SELECT GROUP_CONCAT(DISTINCT id  SEPARATOR ',' ) res_ids, GROUP_CONCAT(DISTINCT collection_notes SEPARATOR '#||#' ) res_notes, participant_id, collection_datetime, collection_datetime_accuracy
    FROM collections
    WHERE deleted <> 1
    AND participant_id IS NOT NULL
    GROUP BY participant_id, collection_datetime, collection_datetime_accuracy";
$atimCollectionsToMerge = getSelectQueryResult($query);
foreach($atimCollectionsToMerge as $new_collections_set) {
    if(preg_match('/,/', $new_collections_set['res_ids'])) {
        $all_ids = explode(',',$new_collections_set['res_ids']);
        $coll_counter = sizeof($all_ids);
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
            'Collections and blocks clean-up pre-migration',
            '@@WARNING@@',
            "Merged participant collections with same dates. Please validate.",
            "See Participant TFRI# ".$new_collections_set['participant_id'] .
            (strlen($new_collections_set['collection_datetime'])? " and collection date ".str_replace(' 00:00:00', '', $new_collections_set['collection_datetime'])."." : ""));
    }
}

//----------------------------------------------------

addToModifiedDatabaseTablesList('Collections', null);
addToModifiedDatabaseTablesList('sample_masters', $atim_controls['aliquot_controls']['tissue-block']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['sample_controls']['tissue']['detail_tablename']);

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Main Process
//--------------------------------------------------------------------------------------------------------------------------------------------------------

// Data match definition
//----------------------------------------------------

$latMatch = array(
    "Latérality block" => array("Tissue Source", "Tissue Type", "Laterality"),
    "unknown" => array("unknown", "unknown", "unknown"),
    "right" => array("", "    ", "right"),
    "ov left" => array("ovary", "", "left"),
    "left" => array("", "", "left"),
    "Cul de sac de Douglas" => array("", "", ""),
    "pelvis left" => array("", "", "left"),
    "mass annexe left" => array("", "", "left"),
    "ov right" => array("ovary", "", "right"),
    "omentum" => array("", "", ""),
    "left (ov ou tr)" => array("", "", "left"),
    "rectum " => array("", "", ""),
    "sigmoide" => array("", "", ""),
    "Ep" => array("", "", ""),
    "not applicable" => array("", "", ""),
    "G" => array("", "", "left"),
    "annexe left" => array("", "", "left"),
    "annexe right" => array("", "", "right"),
    "FT right" => array("", "", "right"),
    "masse pelvienne" => array("", "", ""),
    "péritoine" => array("", "", ""),
    "tr left" => array("", "", "left"),
    "ov D" => array("ovary", "", "right"),
    "peritoneum" => array("", "", ""),
    "ov G" => array("ovary", "", "left"),
    "Douglas" => array("", "", ""),
    "left(zone excroissance)" => array("", "", "left"),
    "OV-tr right" => array("ovary", "", "right"),
    "pelvic mass" => array("", "", ""),
    "FTube left" => array("", "", "left"),
    "Ov Gauche" => array("ovary", "", "left"),
    "grele" => array("", "", ""),
    "appendix" => array("", "", ""),
    "peritoneum pelvic left" => array("", "", "left"),
    "masse tumorale" => array("", "", ""),
    "paracolic nodule" => array("", "", ""),
    "FT left" => array("", "", "left"),
    "implant pelvien" => array("", "", ""),
    "intra pelvien" => array("", "", ""),
    "omentum mets mixte HGSC-EC" => array("", "", ""),
    "hepathic kystic  mass" => array("", "", ""),
    "FT" => array("", "", ""),
    "péritoeum, BX bassin" => array("", "", ""),
    "epiploon" => array("", "", ""),
    "ovarian mass" => array("ovary", "", ""),
    "mesenter" => array("", "", ""),
    "pelvic et sigmoide" => array("", "", ""),
    "annexe left +ut" => array("", "", "left"),
    "annexe nodule" => array("", "", ""),
    "uterus" => array("", "", ""),
    "ganglions lymph. Gauche" => array("", "", "left"),
    "ganglions lymph. Droit" => array("", "", "right"),
    "FT D" => array("", "", ""),
    "retroperitoneum" => array("", "", ""),
    "Lymph Node iliac left" => array("", "", "left"),
    "sac herniaire " => array("", "", ""),
    "small bowel" => array("", "", ""),
    "lymph node left" => array("", "", "left"),
    "FT distal" => array("", "", ""),
    " ileo-caeca" => array("", "", ""),
    "lymph node" => array("", "", ""),
    "ov L ou R?" => array("ovary", "", ""),
    "mesentere" => array("", "", ""),
    "epiplon" => array("", "", ""),
    "méso " => array("", "", ""),
    "bladder" => array("", "", ""),
    "unknown " => array("", "", ""),
    "right " => array("", "", "right"),
    "ovary" => array("ovary", "", ""),
    "0" => array("", "", ""),
    "#N/A" => array("", "", ""),
    "ovary right" => array("ovary", "", "right"),
    "ovary left" => array("ovary", "", "left"),
    "fallopian tub" => array("", "", ""));

// Create storage
//----------------------------------------------------

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

// Block migration - Main code
//----------------------------------------------------

$atimBlocks = getATiMBlocks();
$atimTissues = getATiMTissues();

$blocksControl = array();
$created_aliquot_counter = 0;
$created_sample_counter = 0;
$dataUpdateCreationSummary = array();

$file_name = $bank_excel_files['file'];
$worksheetName = "COEUR";
$file_name_for_summary = "file '<b>$file_name :: $worksheetName</b>";
while($exceldata = getNextExcelLineData($file_name, $worksheetName)) {
    list($excel_line_counter, $excel_line_block_data) = $exceldata;
    
    // Check participant
    //--------------------------------------------------------------------------------------------------------------------------------------------------------
    
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
       
    // Block Match
    //--------------------------------------------------------------------------------------------------------------------------------------------------------
    
    $excel_block_pathology_nbr = $excel_line_block_data['SampleID (Bloc pour TMA Lili)'];
    
    $atim_block_data = null;
    if(!isset($atimBlocks[$participantTfriNbr])) {
        // Participant block does not exist into ATiM (warning: no test on participant has been done at this level)
        // Keep aliquot_master_id to null to create a new one
    } else {
        // Participant block already exists into ATiM
        if(sizeof($atimBlocks[$participantTfriNbr]) > 1) {
            // ATiM participant is associated to many blocks with different pathology numbers
            die('ERR File ' . __FILE__ .' Line ' . __LINE__);   // Case to support
        } else {
            $pathoNbrs = array_keys($atimBlocks[$participantTfriNbr]);
            if(sizeof($pathoNbrs) > 1) {
                // Should never happen (see above)
                die('ERR File ' . __FILE__ .' Line ' . __LINE__);
            } else {
                // ATiM participant is associated to one block
                $pathoNbr = $pathoNbrs[0];
                if(sizeof($atimBlocks[$participantTfriNbr][$pathoNbr]) > 1) {
                    // ATiM participant is associated to many blocks with the same pathology number
                    die('ERR File ' . __FILE__ .' Line ' . __LINE__);   // Case to support
                } else {
                    // At this level: Excel participant TFRI# match an ATiM participant with only one block pathology number and only one block for this pathology number
                    // Compare pathology nbr of the excel block and the unique atim block
                    $aliquot_master_id = array_keys($atimBlocks[$participantTfriNbr][$pathoNbr]);
                    $aliquot_master_id = $aliquot_master_id[0];
                    $excel_block_pathology_nbr_for_preg_match = str_replace(array( '-', ' ', '/', "\\"), array('.{0,1}', '.{0,1}', '.{0,1}', '.{0,1}'), $excel_block_pathology_nbr);
                    $atim_patho_label = $atimBlocks[$participantTfriNbr][$pathoNbr][$aliquot_master_id]['patho_dpt_block_code'];
                    $patternNumber = null;
                    if(preg_match('/^((CBCF)|(OHRI))\-'.$excel_block_pathology_nbr_for_preg_match.'$/',$atim_patho_label)) {
                        $patternNumber = __LINE__;
                    } else if(preg_match('/^'.$excel_block_pathology_nbr_for_preg_match.'$/',$atim_patho_label)) {
                        $patternNumber = __LINE__ . " - Exact match";                      
                    } else if(preg_match('/^'.$excel_block_pathology_nbr_for_preg_match.'$/',$atim_patho_label)) {
                        $patternNumber = __LINE__;
                    } else if(preg_match('/^'.str_replace('SF', 'CBCF\-SF\-', $excel_block_pathology_nbr_for_preg_match).'(\ [AB]){0,1}$/',$atim_patho_label)) {
                        $patternNumber = __LINE__;
                    } else if(preg_match('/^'.str_replace('VOA', 'OVCARE\-', $excel_block_pathology_nbr_for_preg_match).'(\ [AB]){0,1}$/',$atim_patho_label)) {
                        $patternNumber = __LINE__;
                    } else if(strlen($excel_block_pathology_nbr) > 4 && preg_match('/'.$excel_block_pathology_nbr_for_preg_match.'$/',$atim_patho_label)) {
                        $patternNumber = __LINE__;
                    } else if(!strlen($atim_patho_label)) {
                        $patternNumber = __LINE__ . " - 1 block in ATiM with no pathology number";
                    } else if(preg_match('/^(.*)\.\{0\,1\}[A-Z][0-9]{1,2}$/', $excel_block_pathology_nbr_for_preg_match, $matches) && preg_match('/^'.$matches[1].'$/',$atim_patho_label)) {
                        $patternNumber = __LINE__;
                    } else if(preg_match('/^CHUM\-(.*)$/', $atim_patho_label, $matches) && preg_match('/'.str_replace(array('-', ' '),array('\-','\-'), $matches[1]).'$/',$excel_block_pathology_nbr)) {
                        $patternNumber = __LINE__;
                    } else if(preg_match('/'. str_replace(array(' ', '-', '/'), array('', '',''), $atim_patho_label) .'$/', str_replace(array(' ', '-'), array('', ''), $excel_block_pathology_nbr))) {
                        $patternNumber = __LINE__;
                    } else if(preg_match('/^'.$excel_block_pathology_nbr_for_preg_match.'/',$atim_patho_label)) {
                        $patternNumber = __LINE__;
                    } else if(preg_match('/^CHUM.*\-([0-9]+)\-([AZa-z0-9]+)$/', $atim_patho_label, $matches) && preg_match('/'.$matches[1].'.*'.$matches[2].'$/',$excel_block_pathology_nbr)) {
                        $patternNumber = __LINE__;
                    }
                    if($patternNumber) {
                        if($atimBlocks[$participantTfriNbr][$pathoNbr][$aliquot_master_id]['matched_excel_block']) {
                            // Match done previously on an other excel block
                            die('ERR File ' . __FILE__ .' Line ' . __LINE__);   // Case to support
                        } else {
                            // Match done
                            $atim_block_data = $atimBlocks[$participantTfriNbr][$pathoNbr][$aliquot_master_id];
                            $atimBlocks[$participantTfriNbr][$pathoNbr][$aliquot_master_id]['matched_excel_block'] = true;
                        }
                    } else {
                        $atimBlocksUnusedAtLeastOnce = $atimBlocks[$participantTfriNbr][$pathoNbr][$aliquot_master_id];
                        recordErrorAndMessage(
                            'ATiM and Excel block match',
                            '@@WARNING@@',
                            "The excel block pathology nbr does not match the unique ATiM block that already exists into ATiM. A second block will be created. Please validate and clean up data after the migration.",
                            "See excel block '<b>$excel_block_pathology_nbr</b>' and ATiM block ".$atimBlocksUnusedAtLeastOnce['barcode']." (Aliquot TFRI Label : ".$atimBlocksUnusedAtLeastOnce['aliquot_label']." / Pathology label <b>".$atimBlocksUnusedAtLeastOnce['patho_dpt_block_code']."</b>) for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
                    }
                }
            }
        }
    } 
    
    // Block Creation/update
    //--------------------------------------------------------------------------------------------------------------------------------------------------------
    
    // Collection date
    $excel_field = "Block date";
    
    list($excel_collection_date, $excel_collection_date_accuracy) = validateAndGetDateAndAccuracy(
        $excel_line_block_data[$excel_field],
        'Block creation/update',
        "The '$excel_field' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
        "See value [".$excel_line_block_data[$excel_field]."] for the Participant TFRI# '<b>$participantTfriNbr</b>' - line $excel_line_counter.");
    
    // Tissue laterality - source - type
    $excel_field = "Latérality block";
    
    $excel_tissue_source = null;
    $excel_qc_tf_tissue_type = null;
    $excel_tissue_laterality = null;
    $excel_laterality_msg = strlen($excel_line_block_data[$excel_field])? "Latérality block value in excel '".$excel_line_block_data[$excel_field]."'." : '';
    if($excel_line_block_data[$excel_field]) {
        if(isset($latMatch[$excel_line_block_data[$excel_field]])) {
            list($excel_tissue_source, $excel_qc_tf_tissue_type ,$excel_tissue_laterality) = $latMatch[$excel_line_block_data[$excel_field]];
        } else {
            recordErrorAndMessage(
                'Block creation/update',
                '@@ERROR@@',
                "The 'Latérality block' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
                "See value [".$excel_line_block_data[$excel_field]."].",
                $excel_line_block_data[$excel_field]);
        }
    }
    
    // Block in stock detail
    $excel_field = 'availability blocks';
    
    $in_stock = 'yes & available';
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

    // Process
    
    $participant_id = null;
    $collection_id = null;
    $sample_master_id = null;
    $aliquot_master_id = null;
    
    if($atim_block_data) {
        $participant_id = $atimTissues[$participantTfriNbr]['participant_id'];
        $collection_id = $atim_block_data['collection_id'];
        $sample_master_id = $atim_block_data['sample_master_id'];
        $aliquot_master_id = $atim_block_data['aliquot_master_id'];
        if(!isset($atimTissues[$participantTfriNbr]['collections'][$collection_id]) || !isset($atimTissues[$participantTfriNbr]['collections'][$collection_id]['tissues'][$sample_master_id])) {
            die('ERR File ' . __FILE__ .' Line ' . __LINE__);
        }
        $atimCollectionData = $atimTissues[$participantTfriNbr]['collections'][$collection_id];
        $atimDataUpdateMsg = array();
        // Compare collection data
        if($excel_collection_date && $excel_collection_date != $atimCollectionData['collection_datetime']) {
            $atimDataUpdateMsg['collection_datetime'] = "Collection date from '".$atimCollectionData['collection_datetime']."' to '$excel_collection_date'";
            updateTableData($collection_id, array(
                'collections' => array(
                    'collection_datetime' => $excel_collection_date,
                    'collection_datetime_accuracy' => $excel_collection_date_accuracy
                )
            ));
        }
        // Compare tissue data
        $tmp_properties = array(
            array('tissue_source', $excel_tissue_source, 'Tissue source'),
            array('qc_tf_tissue_type', $excel_qc_tf_tissue_type, 'Tissue type'),
            array('tissue_laterality', $excel_tissue_laterality, 'Tissue laterality'));
        $tissuedetailsToUpdate = array();
        foreach($tmp_properties as $tmp_property) {
            list($dbfield, $newvalue, $fieldmsg) = $tmp_property;
            if($newvalue != $atimTissues[$participantTfriNbr]['collections'][$collection_id]['tissues'][$sample_master_id][$dbfield]) {
                $tissuedetailsToUpdate[$dbfield] = $newvalue;
                $atimDataUpdateMsg[$dbfield] = "$fieldmsg from '".$atimTissues[$participantTfriNbr]['collections'][$collection_id]['tissues'][$sample_master_id][$dbfield]."' to '$newvalue'";
            }
        }
        if($tissuedetailsToUpdate) {
            updateTableData($sample_master_id, array(
                'sample_masters' => array(),
                $atim_controls['sample_controls']['tissue']['detail_tablename'] => $tissuedetailsToUpdate
            ));
        }
        // compare aliquot
        $atim_block_data['notes'] = str_replace("'", "''", $atim_block_data['notes']);
        $new_notes = array($atim_block_data['notes'], str_replace("'", "''", $excel_laterality_msg));
        $new_notes = array_filter($new_notes);
        $new_notes = implode('. ',$new_notes);
        $detaiTablename = $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'];
        $tmp_properties = array(
            array('aliquot_masters.storage_master_id', $storage_master_id, 'Block Storage#'),
            array('aliquot_masters.storage_coord_x', '', 'Block position x'),
            array('aliquot_masters.storage_coord_y', '', 'Block position y'),
            array('aliquot_masters.in_stock', $in_stock, 'Block in stock'),
            array('aliquot_masters.notes', $new_notes, 'Block notes'),
            array($detaiTablename.'.block_type', 'paraffin', 'Block type'),
            array($detaiTablename.'.patho_dpt_block_code', str_replace("'", "''", $excel_block_pathology_nbr), 'block patho# modified'),
            array($detaiTablename.'.qc_tf_cellularity', $qc_tf_cellularity, 'Block cellularity'),
            array($detaiTablename.'.qc_tf_quantity_available', $qc_tf_quantity_available, 'Block quantity'));
        $blockdataToUpdate = array();
        foreach($tmp_properties as $tmp_property) {
            list($dbfield, $newvalue, $fieldmsg) = $tmp_property;
            list($table ,$dbfield) = explode('.',$dbfield);
            if($newvalue != $atim_block_data[$dbfield]) {
                $blockdataToUpdate[$table][$dbfield] = $newvalue;
                $atimDataUpdateMsg[$dbfield] = "$fieldmsg from '".$atim_block_data[$dbfield]."' to '$newvalue'";
            }
        }
        if($blockdataToUpdate) {
            if(!isset($blockdataToUpdate['aliquot_masters'])) $blockdataToUpdate['aliquot_masters'] = array();
            if(!isset($blockdataToUpdate[$detaiTablename])) $blockdataToUpdate[$detaiTablename] = array();
            updateTableData($aliquot_master_id,$blockdataToUpdate);
        }
        if($atimDataUpdateMsg) {
            $precison = '';
            $mainMessage = "See updated data for block TFRI# '".$atim_block_data['aliquot_label']."' with %%patho%% of the Participant TFRI# '<b>$participantTfriNbr</b>' (line $excel_line_counter):";
            if(isset($atimDataUpdateMsg['patho_dpt_block_code'])) {
                $mainMessage = str_replace('%%patho%%', $atimDataUpdateMsg['patho_dpt_block_code'], $mainMessage);
                unset($atimDataUpdateMsg['patho_dpt_block_code']);
                $precison = ' including the pathology number';
            } else {
                $mainMessage = str_replace('%%patho%%', 'patho # '.$atim_block_data['patho_dpt_block_code'], $mainMessage);
            }
            if($atimDataUpdateMsg) {
                foreach($atimDataUpdateMsg as $newChange) {
                    $mainMessage .= "<br> ..... $newChange.";
                }
            } else {
                $mainMessage .= ' N/A.';
            }
            recordErrorAndMessage(
                'Tissue block update summary',
                '@@MESSAGE@@',
                "Existing tissue block has been updated. Please validate and clean up data after the migration$precison.",
                $mainMessage);
        }
    } else {
        $participant_id = $atimTissues[$participantTfriNbr]['participant_id'];
        $collection_id = customInsertRecord(array(
            'collections' => array(
                'participant_id' => $participant_id,
                'collection_property' => 'participant collection',
                'collection_datetime' => $excel_collection_date,
                'collection_datetime_accuracy' => $excel_collection_date_accuracy)));
        $created_sample_counter++;
        $sample_data = array(
            'sample_masters' => array(
                "sample_code" => 'tmp_tissue_'.$created_sample_counter,
                "sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
                "initial_specimen_sample_type" => 'tissue',
                "collection_id" => $collection_id),
            'specimen_details' => array(),
            $atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
                'tissue_source' => $excel_tissue_source,
                'qc_tf_tissue_type' => $excel_qc_tf_tissue_type,
                'tissue_laterality' => $excel_tissue_laterality));
        $sample_master_id = customInsertRecord($sample_data);
        $created_aliquot_counter++;
        $aliquot_data = array(
            'aliquot_masters' => array(
                "barcode" => 'tmp_'.$created_aliquot_counter,
                'aliquot_label' => "FFPE $participantTfriNbr",
                "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
                "collection_id" => $collection_id,
                "sample_master_id" => $sample_master_id,
                'storage_master_id' => $storage_master_id,
//                'storage_coord_x' => $storage_coord_y,
//                'storage_coord_y' => $storage_coord_x,
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
    }
    
    // reception information
    
    $excel_field = "Reception date";
    list($reception_date, $reception_date_accuracy) = validateAndGetDateAndAccuracy(
        $excel_line_block_data[$excel_field],
        'Block creation/update',
        $excel_field,
        "Value won't be used by migration process - see line $excel_line_counter.");
    $excel_field = "Received by";
    $reception_by = validateAndGetStructureDomainValue(
        str_replace(array("Cécile", "Liliane Meunier"), array("Cecile", "Liliane"), $excel_line_block_data[$excel_field]),
        'custom_laboratory_staff',
        'Block creation/update',
        "Reception by",
        "Value won't be used by migration process - see line $excel_line_counter.");
    $fromInfo = array();
    if($excel_line_block_data['Bank']) $fromInfo[] = $excel_line_block_data['Bank'];
    if($excel_line_block_data['Received by']) $fromInfo[] = $excel_line_block_data['Received by'];
    $fromInfo = implode(' / ', $fromInfo);
    if($fromInfo) $fromInfo = "From $fromInfo";
    if($reception_date.$reception_by.$fromInfo) {
        customInsertRecord(array(
            'aliquot_internal_uses' => array(
                'aliquot_master_id' => $aliquot_master_id, 
                'type' => 'reception (from bank)',
                'use_code' => $fromInfo,
                'use_datetime' => $reception_date,
                'use_datetime_accuracy' => $reception_date_accuracy)));
    } 
}

// List ATiM block not used
foreach($atimBlocks as $participantTfriNbr => $allBlocksLvl1) {
    foreach($allBlocksLvl1 as $pathoNbr => $allBlocksLvl2) {
        foreach($allBlocksLvl2 as $aliquot_master_id => $blockData) {
            if(!$blockData['matched_excel_block']) {
                recordErrorAndMessage(
                    'ATiM and Excel block match',
                    '@@WARNING@@',
                    "ATiM block not re-used (not found into excel). Please validate block should be keep into ATiM or if this one has been used as control then clean up data after the migration.",
                    "ATiM Block TFRI# ".$blockData['barcode']." (Aliquot TFRI Label : ".$blockData['aliquot_label']." / Pathology label <b>".$blockData['patho_dpt_block_code']."</b>).");
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
    GROUP BY participant_id, collection_datetime, collection_datetime_accuracy";
$atimCollectionsToMerge = getSelectQueryResult($query);
foreach($atimCollectionsToMerge as $new_collections_set) {
    if(preg_match('/,/', $new_collections_set['res_ids'])) {
        $all_ids = explode(',',$new_collections_set['res_ids']);
        $coll_counter = sizeof($all_ids);
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

// Block control
//-----------------------------------------

if($blocksControl) {
    $control_collection_id = customInsertRecord(array(
        'collections' => array(
            'collection_property' => 'independant collection',
            'collection_notes' => 'Controls')));
    
    foreach($blocksControl as $new_control) {
        $excel_line_counter = $new_control['line'];
        $excel_line_block_data = $new_control['excel_data'];
        
        // Tissue laterality - source - type
        $excel_field = "Latérality block";
        
        $excel_tissue_source = null;
        $excel_qc_tf_tissue_type = null;
        $excel_tissue_laterality = null;
        $excel_laterality_msg = strlen($excel_line_block_data[$excel_field])? "Latérality block value in excel '".$excel_line_block_data[$excel_field]."'." : '';
        if($excel_line_block_data[$excel_field]) {
            if(isset($latMatch[$excel_line_block_data[$excel_field]])) {
                list($excel_tissue_source, $excel_qc_tf_tissue_type ,$excel_tissue_laterality) = $latMatch[$excel_line_block_data[$excel_field]];
            } else {
                recordErrorAndMessage(
                    'Block control creation',
                    '@@ERROR@@',
                    "The 'Latérality block' excel value is not supported. Information won't be used by migration script. Please validate and clean up data after the migration.",
                    "See value [".$excel_line_block_data[$excel_field]."].",
                    $excel_line_block_data[$excel_field]);
            }
        }
        
        // Block in stock detail
        $excel_field = 'availability blocks';
        
        $in_stock = 'yes & available';
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
            $atim_controls['sample_controls']['tissue']['detail_tablename'] => array(
                'tissue_source' => $excel_tissue_source,
                'qc_tf_tissue_type' => $excel_qc_tf_tissue_type,
                'tissue_laterality' => $excel_tissue_laterality));
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
        
        // reception information
        
        $excel_field = "Reception date";
        list($reception_date, $reception_date_accuracy) = validateAndGetDateAndAccuracy(
            $excel_line_block_data[$excel_field],
            'Block control creation',
            $excel_field,
            "Value won't be used by migration process - see line $excel_line_counter.");
        $excel_field = "Received by";
        $reception_by = validateAndGetStructureDomainValue(
            str_replace(array("Cécile", "Liliane Meunier"), array("Cecile", "Liliane"), $excel_line_block_data[$excel_field]),
            'custom_laboratory_staff',
            'Block control creation',
            "Reception by",
            "Value won't be used by migration process - see line $excel_line_counter.");
        $fromInfo = array();
        if($excel_line_block_data['Bank']) $fromInfo[] = $excel_line_block_data['Bank'];
        if($excel_line_block_data['Received by']) $fromInfo[] = $excel_line_block_data['Received by'];
        $fromInfo = implode(' / ', $fromInfo);
        if($fromInfo) $fromInfo = "From $fromInfo";
        if($reception_date.$reception_by.$fromInfo) {
            customInsertRecord(array(
                'aliquot_internal_uses' => array(
                    'aliquot_master_id' => $aliquot_master_id,
                    'type' => 'reception (from bank)',
                    'use_code' => $fromInfo,
                    'use_datetime' => $reception_date,
                    'use_datetime_accuracy' => $reception_date_accuracy)));
        } 
    }
}

// Stat
//-----------------------------------------

recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Samples : '.$created_sample_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Aliquots : '.$created_aliquot_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Storages : '.$created_storage_counter);





$last_queries_to_execute = array(
    "UPDATE sample_masters SET sample_code=id WHERE sample_code LIKE 'tmp_';",
    "UPDATE sample_masters SET initial_specimen_sample_id=id WHERE parent_id IS NULL;",
    "UPDATE aliquot_masters SET barcode=id WHERE barcode LIKE 'tmp_';;",
    "UPDATE storage_masters SET code=id;",
    "UPDATE versions SET permissions_regenerated = 0;"
);
foreach($last_queries_to_execute as $query)	customQuery($query);

dislayErrorAndMessage(false);











//--------------------------------------------------------------------------------------------------------------------------------------------------------
//Functions
//--------------------------------------------------------------------------------------------------------------------------------------------------------

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
        $atim_blocks[$new_block['participant_identifier']][$new_block['patho_dpt_block_code']][$new_block['aliquot_master_id']]['matched_excel_block'] = false;
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
		