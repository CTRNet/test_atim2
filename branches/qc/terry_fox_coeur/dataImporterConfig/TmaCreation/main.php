<?php    
    
// *******************************************************************************************************************************************************
//
//    TFRI-COEUR
//
// *******************************************************************************************************************************************************
//
//	Script created to create TMA block
//
// @created 2018-07-17
// @author Nicolas Luc
// *******************************************************************************************************************************************************

$is_serveur = false;
require_once ($is_serveur)? '/ATiM/atim-tfri/dataUpdate/coeur/ClinicalDataUpdate/system.php' : './system.php';

$commitAll = true;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $commitAll = false;   
    } else {
        die('ERR ARG : '.$argv[1].' (should be test or nothing)');
    }
}

displayMigrationTitle('TFRI COEUR - TMA Block Creation', $bank_excel_files);

if(!testExcelFile($bank_excel_files)) {
	dislayErrorAndMessage();
	exit;
}

$fileName = $bank_excel_files['file'];

// Get worksheets names
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$TmpXlsReader = new Spreadsheet_Excel_Reader();
$TmpXlsReader->read($excel_files_paths.$fileName);
//Set studied_excel_file_name_properties
$excelWorksheets = array();
foreach($TmpXlsReader->boundsheets as $key => $tmp) {
    if($tmp['name'] != utf8_decode('Légende')) {
        recordErrorAndMessage(
            'Summary',
            '@@MESSAGE@@',
            "Parsed whorksheets",
            $tmp['name']);
        $excelWorksheets[] = $tmp['name'];
    }
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Main Code
//--------------------------------------------------------------------------------------------------------------------------------------------------------

global $atimBlockSelectionData;
$atimBlockSelectionData = array();

$createdExcelCoresCounter = 0;
$excelCoresCounter = 0;
foreach($excelWorksheets as $worksheetName) {
    
    // New TMA Block
    
    $tmaBlockName = $worksheetName;
    if(preg_match('/^ATiM\ (.*)$/', $tmaBlockName, $matches)) {
        $tmaBlockName = trim($matches[1]);
    }
    $tmaNameAndWorksheet = "TMA : $tmaBlockName (<i>woksheet '$worksheetName'</i>)";
    
    recordErrorAndMessage(
        $tmaNameAndWorksheet,
        '@@MESSAGE@@',
        "Cores created",
        "TMA info -- $tmaNameAndWorksheet.");
    
    // Get TMA Block id
    
    $createdExcelWorksheetCoresCounter = 0;
    $excelWorksheetCoresCounter = 0;
    while($exceldata = getNextExcelLineData($fileName, $worksheetName)) {
        list($excelLineCounter, $excelLineCoreData) = $exceldata;
        
        // New core to create : Get Excel Data

        $blockNbrKey = 'Numéro Bloc';
        if(!array_key_exists($blockNbrKey, $excelLineCoreData)) {
            if(array_key_exists('Numero Bloc', $excelLineCoreData)) {
                $blockNbrKey = 'Numero Bloc';
            } elseif(array_key_exists('numero bloc', $excelLineCoreData)) {
                $blockNbrKey = 'numero bloc';
            }  elseif(array_key_exists('numéro bloc', $excelLineCoreData)) {
                $blockNbrKey = 'numéro bloc';
            } 
        } 
        $coreNbrKey = 'Numéro Core';
        if(!array_key_exists($coreNbrKey, $excelLineCoreData)) {
            if(array_key_exists('Numero Core', $excelLineCoreData)) {
                $coreNbrKey = 'Numero Core';
            } elseif(array_key_exists('numero core', $excelLineCoreData)) {
                $coreNbrKey = 'numero core';
            }  elseif(array_key_exists('numéro core', $excelLineCoreData)) {
                $coreNbrKey = 'numéro core';
            } 
        }
        if(!(array_key_exists('TFRI', $excelLineCoreData) && 
        array_key_exists($blockNbrKey, $excelLineCoreData) && 
        array_key_exists($coreNbrKey, $excelLineCoreData) && 
        array_key_exists('X', $excelLineCoreData) && 
        array_key_exists('Y', $excelLineCoreData) && 
        array_key_exists('TMA', $excelLineCoreData))) {
            $tmpHeaders = array_keys($excelLineCoreData);
            recordErrorAndMessage(
                $tmaNameAndWorksheet,
                '@@ERROR@@',
                "Worksheet headers are not these one the script expected [ TFRI | $blockNbrKey | $coreNbrKey | X | Y | TMA ]. Not data of the worksheet will be imported!",
                "See headers [ ".implode(' | ', $tmpHeaders)." ].",
                $tmaNameAndWorksheet);
            if(!((isset($excelLineCoreData['TFRI']) && $excelLineCoreData['TFRI'] == '.')
            || (isset($excelLineCoreData[$blockNbrKey]) && $excelLineCoreData[$blockNbrKey] == '.')
            || (isset($excelLineCoreData[$coreNbrKey]) && $excelLineCoreData[$coreNbrKey] == '.'))) {
                $excelWorksheetCoresCounter++;
                $excelCoresCounter++;
            }
            continue;
            
        }
        $participantIdentifier = $excelLineCoreData['TFRI'];
        $blockAliquotLabel = $excelLineCoreData[$blockNbrKey];
        $coreNbr = $excelLineCoreData[$coreNbrKey];
        $storageCoordX = $excelLineCoreData['X'];
        $storageCoordY = $excelLineCoreData['Y'];
        if($tmaBlockName != $excelLineCoreData['TMA']) {
            recordErrorAndMessage(
                $tmaNameAndWorksheet,
                '@@WARNING@@',
                "TMA bloc name is not consistant between the worksheet name and the line cell 'TMA'. TMA name from worksheet will be used but please validate.",
                "See [$tmaBlockName] != [".$excelLineCoreData['TMA']."] on line $excelLineCounter.");
        }
        
        if(($participantIdentifier == '.' || $participantIdentifier == '') && ($blockAliquotLabel == '.' || $blockAliquotLabel == '') && ($coreNbr == '.' || $coreNbr == '')) continue;
                
        $excelWorksheetCoresCounter++;
        $excelCoresCounter++;
        
        // Get ATiM Tissue Block id
        
         if(($participantIdentifier == '.' || $participantIdentifier == '') && ($coreNbr == '.' || $coreNbr == '')) {
             pr("COntrol [$blockAliquotLabel]");
         } else {
             $block_aliquot_master_id = getATiMBlock($participantIdentifier, $blockAliquotLabel, $tmaNameAndWorksheet, $excelLineCounter);
         }
         
        if(!$block_aliquot_master_id) {
            // Error managed into getATiMBlock()
        } else {
            $createdExcelCoresCounter++;
            $createdExcelWorksheetCoresCounter++;
            
            //TODO
        }
        
    }
    recordErrorAndMessage(
        'Summary',
        '@@MESSAGE@@',
        "Cores created",
        "$tmaNameAndWorksheet : $createdExcelWorksheetCoresCounter/$excelWorksheetCoresCounter cores created.");
    recordErrorAndMessage(
        $tmaNameAndWorksheet,
        '@@MESSAGE@@',
        "Cores created",
        "$tmaNameAndWorksheet : $createdExcelWorksheetCoresCounter/$excelWorksheetCoresCounter cores created.");
    
    if(false) {
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
    }
}

recordErrorAndMessage(
    'Summary',
    '@@MESSAGE@@',
    "Cores created",
    "All TMAs : $createdExcelCoresCounter/$excelCoresCounter cores created.");
    
dislayErrorAndMessage();
exit;




































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





// Stat
//-----------------------------------------

recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Collections : '.$created_collection_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Samples : '.$created_sample_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Blocks : '.$created_aliquot_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Slides : '.$created_slide_counter);
recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", 'Storages : '.$created_storage_counter);

$lastQueriesToExecute = array(
    "UPDATE sample_masters SET sample_code=id WHERE sample_code LIKE 'tmp_%';",
    "UPDATE sample_masters SET initial_specimen_sample_id=id WHERE parent_id IS NULL;",
    "UPDATE aliquot_masters SET barcode=id WHERE barcode LIKE 'tmp_%';",
    "UPDATE storage_masters SET code=id;",
    "UPDATE versions SET permissions_regenerated = 0;"
);
foreach($lastQueriesToExecute as $query)	customQuery($query);

dislayErrorAndMessage($commitAll);

//--------------------------------------------------------------------------------------------------------------------------------------------------------
//Functions
//--------------------------------------------------------------------------------------------------------------------------------------------------------

function getATiMBlock($participantIdentifier, $blockAliquotLabel, $tmaNameAndWorksheet, $excelLineCounter) {
    global $atimBlockSelectionData;
    global $imported_by;
    $dateOfNewBlockCreation = '2019-02-12 01:01:01';
    
    $excelBlockUniqueKey = $tmaNameAndWorksheet.'###'.$participantIdentifier.'###'.$blockAliquotLabel;
    
    if(!isset($atimBlockSelectionData[$excelBlockUniqueKey])) {
        $blocAliquotMasterId = null;
        
        // Select block created by the last import based on participant TFRI# and block pathology # 
        
        $query = "SELECT
            Participant.id as participant_id,
            Participant.qc_tf_bank_id,
            Participant.participant_identifier,
            Participant.qc_tf_bank_identifier,
            
            Collection.id AS block_collection_id,
            SampleMaster.id AS block_sample_master_id,        
            AliquotMaster.id AS block_aliquot_master_id,
            AliquotMaster.barcode,
            AliquotMaster.aliquot_label,
            AliquotMaster.in_stock
            
            FROM participants Participant
            INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
            INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
            INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
            INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id AND AliquotMaster.deleted <> 1
            INNER JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
            
            WHERE AliquotMaster.aliquot_control_id = 8
            AND Participant.participant_identifier = '".str_replace("'", "''", $participantIdentifier)."'
            AND AliquotMaster.aliquot_label = '".str_replace("'", "''", $blockAliquotLabel)."'
            AND AliquotMaster.created_by = $imported_by
            AND AliquotMaster.created > '$dateOfNewBlockCreation';";
        $participantAtimBlocks = getSelectQueryResult($query);
        
        if(!$participantAtimBlocks) {
            
            // No ATiM block(s) match
            
            $query = "SELECT
                Participant.id as participant_id,
                Participant.qc_tf_bank_id,
                Participant.participant_identifier,
                Participant.qc_tf_bank_identifier,
                
                Collection.id AS block_collection_id,
                SampleMaster.id AS block_sample_master_id,
                AliquotMaster.id AS block_aliquot_master_id,
                AliquotMaster.barcode,
                AliquotMaster.aliquot_label,
                AliquotMaster.in_stock,
                AliquotDetail.patho_dpt_block_code,
                AliquotMaster.created,
                AliquotMaster.created_by
                
                FROM participants Participant
                INNER JOIN collections Collection ON Collection.participant_id = Participant.id AND Collection.deleted <> 1
                INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
                INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
                INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id AND AliquotMaster.deleted <> 1
                INNER JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
                
                WHERE AliquotMaster.aliquot_control_id = 8
                AND Participant.participant_identifier = '".str_replace("'", "''", $participantIdentifier)."'
                ORDER by AliquotMaster.created DESC;";
            $blockAliquotLabelForRegexp = str_replace(array(' ', '|', '-', '/', '\\') , array('@@', '@@', '@@', '@@', '@@'), $blockAliquotLabel);
            $blockAliquotLabelForRegexp = explode('@@', $blockAliquotLabelForRegexp);
            if(sizeof($blockAliquotLabelForRegexp) > 1) {
                $blockAliquotLabelForRegexp = "/.*(" . implode(').*(', $blockAliquotLabelForRegexp).').*/i';
            } else {
                $blockAliquotLabelForRegexp = null;
            }
            $blockStatusForInfoMsg = array();
            $newParticipantBlockDetected = array();
            $newParticipantBlockDetectedAndMatchingOnRegexp = array();
            foreach(getSelectQueryResult($query) as $newOtherBlock) {
                if(($newOtherBlock['created'] >= $dateOfNewBlockCreation && $newOtherBlock['created_by'] == $imported_by)) {
                    // New block created in 2019 based on Christine tissue blocks 
                    $blockStatusForInfo = " (<font color='green'>new from christine xls</font>)";
                    $newParticipantBlockDetected[] = $newOtherBlock;
                    if($blockAliquotLabelForRegexp && preg_match($blockAliquotLabelForRegexp, $newOtherBlock['aliquot_label'])) {
                        $newParticipantBlockDetectedAndMatchingOnRegexp[] = $newOtherBlock;
                    }
                } else {
                    $blockStatusForInfo = " (<font color='red'>old - created before 2019</font>)";
                }
                $blockStatusForInfoMsg[] = "TFRI#[" . $newOtherBlock['aliquot_label'] . "] + bank#[" . $newOtherBlock['aliquot_label'] . "] + patho#[<b>" . $newOtherBlock['patho_dpt_block_code'] ."</b>]" . $blockStatusForInfo;
            }
            $additionalTitle = '';
            $additionalDetail = '';
            if($blockStatusForInfoMsg) {
                $additionalTitle = ' but participant ATiM tissue blocks exist';
                $additionalDetail = '. Here are all blocks of this participant existing into ATiM :<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; => ' . implode('<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; => ', $blockStatusForInfoMsg) .'.';
            } else {
                $additionalTitle = ' but please note that no participant ATiM tissue blocks exists';
            }
            if(sizeof($newParticipantBlockDetectedAndMatchingOnRegexp) == 1) {
                $participantAtimBlocks = $newParticipantBlockDetectedAndMatchingOnRegexp;
                recordErrorAndMessage(
                    $tmaNameAndWorksheet,
                    '@@WARNING@@',
                    "The ATiM tissue block can only be found based on an approximative match with participant TFRI# and pathology code. Core will be create but please validate.",
                    "See XLS tissue block with label <b>$blockAliquotLabel</b> and new ATIM tissue block with label <b>".$participantAtimBlocks[0]['aliquot_label']."</b> for participant TFRI# $participantIdentifier. Line $excelLineCounter.$additionalDetail");
            } else if(sizeof($newParticipantBlockDetected) == 1) {
                $participantAtimBlocks = $newParticipantBlockDetected;
                recordErrorAndMessage(
                    $tmaNameAndWorksheet,
                    '@@WARNING@@',
                    "The ATiM tissue block selected to create the core has been selected because it's the only one created based on the new XLS file with tissue blocks created in 2019. Core will be create but match has clearly to be calidated validate.",
                    "See XLS tissue block with label <b>$blockAliquotLabel</b> and XLS tissue block with label <b>".$participantAtimBlocks[0]['aliquot_label']."</b> for participant TFRI# $participantIdentifier. Line $excelLineCounter.$additionalDetail");
            } else {
                if(trim($participantIdentifier) == '.' || trim($participantIdentifier) == '' ) {
                    recordErrorAndMessage(
                        $tmaNameAndWorksheet,
                        '@@ERROR@@',
                        "The ATiM tissue block can not be found based on participant TFRI# and pathology code but please check core is not a control. Core won't be created. Create core manually into ATiM after the migration.",
                        "See tissue block with label <b>".((strlen($blockAliquotLabel) && $blockAliquotLabel != '.')? $blockAliquotLabel : 'no value').
                            "</b> created for participant TFRI# <b>".((strlen($participantIdentifier) && $participantIdentifier != '.')? $participantIdentifier : 'no value').
                            "</b> and core# <b>".((strlen($coreNbr) && $coreNbr != '.')? $coreNbr : 'no value').
                            "</b>. Line $excelLineCounter.$additionalDetail");
                } else {
                    recordErrorAndMessage(
                        $tmaNameAndWorksheet,
                        '@@ERROR@@',
                        "The ATiM tissue block can not be found based on participant TFRI# and pathology code $additionalTitle. Core won't be created. Create core manually into ATiM after the migration.",
                        "See tissue block with label <b>".((strlen($blockAliquotLabel) && $blockAliquotLabel != '.')? $blockAliquotLabel : 'no value').
                            "</b> created for participant TFRI# <b>".((strlen($participantIdentifier) && $participantIdentifier != '.')? $participantIdentifier : 'no value').
                            "</b> and core# <b>".((strlen($coreNbr) && $coreNbr != '.')? $coreNbr : 'no value').
                            "</b>. Line $excelLineCounter.$additionalDetail");
                }
            }
        }
        
        if($participantAtimBlocks) {
            
            // ATiM Block(s) match
            
            $firstBlockAvailableKey = null;
            if(sizeof($participantAtimBlocks) > 1) {
                $atimLabels = array();
                foreach($participantAtimBlocks as $tmpNew) {
                    $atimLabels[] = $tmpNew['aliquot_label'];
                }
                $atimLabels = implode(' & ' , $atimLabels);
                recordErrorAndMessage(
                    $tmaNameAndWorksheet,
                    '@@WARNING@@',
                    "More than one ATiM tissue block has been selected based on participant TFRI# and pathology code. Core will be created then linked to one of these ATiM tissue blocks but please validate into ATiM after the migration.",
                    "See XLS tissue block with label <b>$blockAliquotLabel</b> matching ATiM Tissue blocks <b>$atimLabels</b> created for participant TFRI# $participantIdentifier define on line $excelLineCounter.");
                foreach($participantAtimBlocks as $key => $tmpBlock) {
                    if(!$firstBlockAvailableKey && $tmpBlock['in_stock'] != 'no') {
                        $firstBlockAvailableKey = $key;
                    } 
                }
            }
            if(is_null($firstBlockAvailableKey)) $firstBlockAvailableKey = '0';
            if($participantAtimBlocks[$firstBlockAvailableKey]['in_stock'] == 'no') {
                recordErrorAndMessage(
                    $tmaNameAndWorksheet,
                    '@@WARNING@@',
                    "The ATiM tissue block selected based on participant TFRI# and pathology code is defined as 'Not In Stock'. Core will be created then linked to this ATiM tissue block but please validate.",
                    "See ATiM tissue block with label <b>".$participantAtimBlocks[$firstBlockAvailableKey]['aliquot_label']."</b> matching XLS label <b>$blockAliquotLabel</b> and created for participant TFRI# $participantIdentifier. Line $excelLineCounter.");
            }
            $blocAliquotMasterId = $participantAtimBlocks[$firstBlockAvailableKey]['block_aliquot_master_id'];
        }
        $atimBlockSelectionData[$excelBlockUniqueKey] = $blocAliquotMasterId;
        
    }
    
    return $atimBlockSelectionData[$excelBlockUniqueKey];
}

?>
		