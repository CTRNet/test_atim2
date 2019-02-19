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

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Main Code :: TMA Block
//--------------------------------------------------------------------------------------------------------------------------------------------------------

// TMA Replicat
//--------------------------------------------------------------------------------------------------------------------------------------------------------


$tmaReplicatsInfo = array();

$fileName = $bank_excel_files['tma'];
while($exceldata = getNextExcelLineData($fileName, 'Feuil1')) {
    list($excelLineCounter, $excelLineData) = $exceldata;
    $tmaReplicatsInfo[trim($excelLineData['TMA'])] = $excelLineData['replicat'];
}

// Get worksheets names
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$fileName = $bank_excel_files['block'];

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

// Create blocks
//--------------------------------------------------------------------------------------------------------------------------------------------------------

global $atimBlockSelectionData;
$atimBlockSelectionData = array();

global $atimControlCollectionId;
$atimControlCollectionId = null;

global $tmaBlocks;
$tmaBlocks = array();

$createdExcelCoresCounter = 0;
$excelCoresCounter = 0;
global $revisionCounter;
$revisionCounter = 0;

//TODO
if(true) {

foreach($excelWorksheets as $worksheetName) {
    
    // New TMA Block
    
    $tmaBlockName = $worksheetName;
    if(preg_match('/^ATiM\ (.*)$/', $tmaBlockName, $matches)) {
        $tmaBlockName = trim($matches[1]);
    }
    $tmaNameAndWorksheet = "TMA : $tmaBlockName (<i>woksheet '$worksheetName'</i>)";
    
    $nbrOfTmaBlocksToCreate = 1;
    if(isset($tmaReplicatsInfo[$tmaBlockName])) {
        $nbrOfTmaBlocksToCreate = $tmaReplicatsInfo[$tmaBlockName];
        unset($tmaReplicatsInfo[$tmaBlockName]);
    } else {
        recordErrorAndMessage(
            'Summary',
            '@@ERROR@@',
            "TMA not defined into the 'Replicat' file. Only one TMA block duplicat will be created. Please confirm.",
            "See TMA Block $tmaBlockName.");
    }
    
    recordErrorAndMessage(
        $tmaNameAndWorksheet,
        '@@MESSAGE@@',
        "Cores created",
        "$tmaNameAndWorksheet.");
    recordErrorAndMessage(
        $tmaNameAndWorksheet,
        '@@MESSAGE@@',
        "Cores created",
        "Number of duplicated TMA blocks created : $nbrOfTmaBlocksToCreate.");
    
    // Get TMA Block id
    
    $createdExcelWorksheetCoresCounter = 0;
    $excelWorksheetCoresCounter = 0;
    $headersDone = false;
    while($exceldata = getNextExcelLineData($fileName, $worksheetName)) {
        list($excelLineCounter, $excelLineCoreData) = $exceldata;
        
        if(!$headersDone) {
            $headers = array_keys($excelLineCoreData);
            $headers = implode( ' || ', $headers);
            recordErrorAndMessage(
                'Summary',
                '@@MESSAGE@@',
                "Parsed whorksheets : Headers",
                $tmaNameAndWorksheet . " : $headers");
        }        
        $headersDone = true;
        
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
                "See [$tmaBlockName] != [".$excelLineCoreData['TMA']."] on line $excelLineCounter (and more).",
                $tmaBlockName . '###' . $excelLineCoreData['TMA']);
        }
        
        if(($participantIdentifier == '.' || $participantIdentifier == '') && ($blockAliquotLabel == '.' || $blockAliquotLabel == '') && ($coreNbr == '.' || $coreNbr == '')) continue;
                
        $excelWorksheetCoresCounter++;
        $excelCoresCounter++;
        
        // Get ATiM Tissue Block id
        list($atimBlockCollectionId, $atimBlockSampleMasterId, $atimBlockAliquotMasterId) = getATiMBlock($participantIdentifier, $blockAliquotLabel, $coreNbr, $tmaNameAndWorksheet, $excelLineCounter);
        if(!$atimBlockAliquotMasterId) {
            // Error managed into getATiMBlock()
        } else {
            if($atimBlockCollectionId == $atimControlCollectionId) {
                recordErrorAndMessage(
                    $tmaNameAndWorksheet,
                    '@@WARNING@@',
                    "Core created as a 'Control' (Linked to the collection of controls). Please validate.",
                    "See core [$blockAliquotLabel] on line $excelLineCounter.");
            }
            
            $createdExcelCoresCounter++;  
            $createdExcelWorksheetCoresCounter++;
            
            // Create core(s)
            $aliquotLabelSuffix = array();
            if(isset($excelLineCoreData['numero blocs avec Zone']) && strlen($excelLineCoreData['numero blocs avec Zone']) && $excelLineCoreData['numero blocs avec Zone'] != '.') {
                $regExp = str_replace('-', '\-', $blockAliquotLabel.'-');
                if(preg_match("/$regExp/", $excelLineCoreData['numero blocs avec Zone'])) {
                   $aliquotLabelSuffix[] = 'Z#' . str_replace($blockAliquotLabel.'-', '', $excelLineCoreData['numero blocs avec Zone']);
                } else {
                    $zone = str_replace($blockAliquotLabel.'-', '', $excelLineCoreData['numero blocs avec Zone']);
                    if(strlen($zone)) {
                        $aliquotLabelSuffix[] =  'Z#'  . $zone;
                    }
                }
            }
            if(isset($excelLineCoreData['Rang global']) && strlen($excelLineCoreData['Rang global']) && $excelLineCoreData['Rang global'] != '.') {
                $aliquotLabelSuffix[] =  'R#'  . $excelLineCoreData['Rang global'];
            }
            if(isset($excelLineCoreData['post chimio']) && strlen($excelLineCoreData['post chimio']) && $excelLineCoreData['post chimio'] != '.') {
                if($excelLineCoreData['post chimio'] == '(post chimio)') {
                    $aliquotLabelSuffix =  'Post Chemo';
                } else {
                    pr('ERR 823982379872 : '.$excelLineCoreData['post chimio']);
                }
                
            }
            $aliquotLabelSuffix = implode(' ', $aliquotLabelSuffix);
            $blockAliquotLabel = "$blockAliquotLabel" . ((strlen($coreNbr) && $coreNbr != '.')? "#$coreNbr" : "") . ($aliquotLabelSuffix? ' ' .$aliquotLabelSuffix : '');
            
            $storageCoordX = $excelLineCoreData['X'];
            $storageCoordY = $excelLineCoreData['Y'];
            if($storageCoordX > 29) pr('ERR#7859090234');
            if($storageCoordY > 21) pr('ERR#7859090233');
            for($tmaBlockSuffix = 1; $tmaBlockSuffix <= $nbrOfTmaBlocksToCreate; $tmaBlockSuffix++) {
                // Core                
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => 'tmp_core_'.$createdExcelCoresCounter,
                        'aliquot_label' => $blockAliquotLabel,
                        "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-core']['id'],
                        "collection_id" => $atimBlockCollectionId,
                        "sample_master_id" => $atimBlockSampleMasterId,
                        'in_stock' => 'yes - available',
                        'storage_master_id' => getATiMTmaBlock($tmaBlockName.($nbrOfTmaBlocksToCreate == 1? '' : ".$tmaBlockSuffix")),
                        'storage_coord_x' => $storageCoordX,
                        'storage_coord_y' => $storageCoordY,
                        'notes' => ''),
                    $atim_controls['aliquot_controls']['tissue-core']['detail_tablename'] => array());
                $coreAliquotMasterId = customInsertRecord($aliquot_data);
                $realiquoting_data = array('realiquotings' => array(
                    'parent_aliquot_master_id' => $atimBlockAliquotMasterId,
                    'child_aliquot_master_id' => $coreAliquotMasterId));
                customInsertRecord($realiquoting_data);
                // Revision
                if($tmaBlockSuffix == 1) createRevision($participantIdentifier, $blockAliquotLabel, $atimBlockCollectionId, $atimBlockSampleMasterId, $coreAliquotMasterId, $excelLineCoreData, $excelLineCounter);
            }
        }
    }
    recordErrorAndMessage(
        'Summary',
        '@@MESSAGE@@',
        "Cores created",
        "$tmaNameAndWorksheet : $createdExcelWorksheetCoresCounter/$excelWorksheetCoresCounter cores created (X$nbrOfTmaBlocksToCreate Blocks).");
    recordErrorAndMessage(
        $tmaNameAndWorksheet,
        '@@MESSAGE@@',
        "Cores created",
        "$tmaNameAndWorksheet : $createdExcelWorksheetCoresCounter/$excelWorksheetCoresCounter cores created (X$nbrOfTmaBlocksToCreate Blocks).");  
}

if($tmaReplicatsInfo) {
    foreach($tmaReplicatsInfo AS $tmaBlockName => $tmp) {
        recordErrorAndMessage(
            'Summary',
            '@@ERROR@@',
            "TMA defined into the 'Replicat' file is not listed into the TMA data file. TMA won't be created. Please confirm.",
            "See TMA Block name $tmaBlockName.");
    }
}

recordErrorAndMessage(
    'Summary',
    '@@MESSAGE@@',
    "Cores created",
    "All TMAs : $createdExcelCoresCounter/$excelCoresCounter cores created.");
    
recordErrorAndMessage(
    'Summary',
    '@@MESSAGE@@',
    "Cores created",
    "$revisionCounter cores revisions have been created.");

//TODO
}//tmp false

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Main Code :: TMA Slide
//--------------------------------------------------------------------------------------------------------------------------------------------------------

$fileName = $bank_excel_files['slide'];
$worksheetName = 'Feuil1';

$allStudies = array();
foreach(getSelectQueryResult("SELECT title, id FROM study_summaries WHERE deleted <> 1") as $newStudy) {
    $allStudies[$newStudy['title']] = $newStudy['id'];
}

$additionalMatches = array(
        'COEUR-35-BW1' => 'COEUR-35-BV#1',
        'COEUR47' => 'COEUR-47-DH#4',
        'COEUR44-kobel#5' => 'COEUR-44-MK#5',
        'COEUR-39-DH#2' => 'COEUR-39-IC#2',
        'COEUR19' => 'COEUR-19-BT#1',
        'COEUR43' => 'COEUR-43-AMM#6',
        'COEUR51' => 'COEUR-51-AMM#7',
        'COEUR44' => 'COEUR-44-MK#5',
        'COEUR-11-AM2' => 'COEUR-11-AMM#2',
        'COEUR19' => 'COEUR-19-BT#1',
        'COEUR-04-MK#1/COEUR-05-MK#2.0' => 'COEUR-04-MK#1',
        'COEUR-04-MK#2' => 'COEUR-04-MK#1',
        'COEUR-04-MK#3' => 'COEUR-04-MK#1',
        'COEUR-04-MK#4' => 'COEUR-04-MK#1',
        'COEUR-04-MK#5' => 'COEUR-04-MK#1',
        'COEUR48' => 'COEUR-48-EG#1',
        'THT' => 'central activity',
        'SATB2 and CDX2 in endometrioid ovarian cancer' => 'COEUR-54-SATB2 and CDX2'
    );
foreach($additionalMatches as $excelTitle => $atimTitle) {
    if(!isset($allStudies[$atimTitle])) die('ERR 23 23 23 ' . $atimTitle);
    $allStudies[$excelTitle] = $allStudies[$atimTitle];
    recordErrorAndMessage(
        'TMA Slides',
        '@@WARNING@@',
        "Renamed study linked to TMA slide. Please confirm.",
        "The study [$excelTitle] linked to the TMA slides will be renamed to/considered as study [$atimTitle].");
}

recordErrorAndMessage(
    'TMA Slides',
    '@@WARNING@@',
    "Renamed TMA block. Please confirm.",
    "The block [THT.16.015AV1] has been renamed to [THT Ovcare.A.1].");
recordErrorAndMessage(
    'TMA Slides',
    '@@WARNING@@',
    "Renamed TMA block. Please confirm.",
    "The block [THT.16.015AV2] has been renamed to [THT Ovcare.A.2].");

$shipments = array();
while($exceldata = getNextExcelLineData($fileName, $worksheetName, 1, $mac_xls_offset)) {
    list($excelLineCounter, $excelLineTmaSlideData) = $exceldata;
    
    $block = $excelLineTmaSlideData['block'];
    $block = str_replace(array('THT.16.015AV1', 'THT.16.015AV2'), array('THT Ovcare.A.1', 'THT Ovcare.A.2'), $block);
    
    $tmaBlockStorageMasterId = null;
    if(!isset($tmaBlocks[$block])) {
        recordErrorAndMessage(
            'TMA Slides',
            '@@ERROR@@',
            "TMA block does not exist. All slides linked to these block won't be created.",
            "See TMA block [$block].",
            $block);
    } else {
        $tmaBlockStorageMasterId = $tmaBlocks[$block];
    }
    
    if($tmaBlockStorageMasterId) {
        $barcode = "$block #".$excelLineTmaSlideData['ID Section'];
        
        $parrafinProtection = '';
        switch($excelLineTmaSlideData['parrafin protection']) {
            case 'yes':
            case 'Yes':
                $parrafinProtection = 'y';
                break;
            case 'no':
            case 'No':
                $parrafinProtection = 'n';
                break;
            default:
                if(strlen($excelLineTmaSlideData['parrafin protection'])) pr('ERR 52452523'.$excelLineTmaSlideData['parrafin protection']);
        }
        
        $qualityAssessment = trim($excelLineTmaSlideData['Quality Assessment']);
        if(!in_array($qualityAssessment, array('', '1', '2', '3', '?'))) pr('ERR 52452333333'.$excelLineTmaSlideData['Quality Assessment']);
        
        list($sectionningDate, $sectionningDateACc) = validateAndGetDateAndAccuracy($excelLineTmaSlideData['Sectionning Date'], 'TMA Slides', 'Sectionning Date', "See slide $barcode line $excelLineCounter");
        
        $doneBy = validateAndGetStructureDomainValue($excelLineTmaSlideData['Coupé par'], 'custom_laboratory_staff', 'TMA Slides', 'Coupé par', "Line $excelLineCounter");
        
        $studyId = '';
        if($excelLineTmaSlideData['Project ID']) {
            if(isset($allStudies[$excelLineTmaSlideData['Project ID']])) {
                $studyId = $allStudies[$excelLineTmaSlideData['Project ID']];
            } else {
                recordErrorAndMessage(
                    'TMA Slides',
                    '@@ERROR@@',
                    "Study linked to a TMA slide does not exist. TMA slide won't be linked to the study. Please check data and correct data after the migration",
                    "See study [".$excelLineTmaSlideData['Project ID']."].");
            }
        }
        
        $inStock = str_replace(array('yes'), array('yes - available'), $excelLineTmaSlideData['In Stock']);
        if(!in_array($inStock, array('', 'yes - available', 'no'))) pr('ERR 23ssssss2 '.$excelLineTmaSlideData['In Stock']);
        
        $notes = array($excelLineTmaSlideData['Notes']);
        if(strlen($excelLineTmaSlideData['Publié?'])) {
            $notes[] = "Publie : " . $excelLineTmaSlideData['Publié?'];
        }
        $notes = array_filter($notes);
        $notes = implode(' & ', $notes);
        
        $sentTo = $excelLineTmaSlideData['Distribué à'];
        $shippingDate = $excelLineTmaSlideData['Shipping date'];
        $inStockDetail = '';
        if(strlen($sentTo.$shippingDate)) {
            $inStockDetail = 'shipped';
            $inStock = 'no';
        }
        list($shippingDate, $shippingDateAccuracy) = validateAndGetDateAndAccuracy($shippingDate, 'TMA Slides', 'Shipping Date', "See slide $barcode line $excelLineCounter");
        
        $slideData = array('tma_slides' => array(
            'tma_block_storage_master_id' => $tmaBlockStorageMasterId,
            'barcode' => $barcode,
            'qc_tf_qc_tf_parrafin_protection' => $parrafinProtection,
            'qc_tf_quality_assessment' => $qualityAssessment,
            'qc_tf_sectionning_date' => $sectionningDate,
            'qc_tf_sectionning_date_accuracy' => $sectionningDateACc,
            'qc_tf_sectionning_done_by' => $doneBy,
            'study_summary_id' => $studyId,
            'in_stock' => $inStock,
            'in_stock_detail' => $inStockDetail,
            'qc_tf_notes' => $notes,
            'immunochemistry' => $excelLineTmaSlideData['Study/Marker']));
        $tmaSlideId = customInsertRecord($slideData);
        
        if($inStockDetail == 'shipped') {
            
            if(!isset($shipments[$sentTo.'//'.$shippingDate.'//'.$shippingDateAccuracy])) {
                $orderData = array(
                    'order_number' =>  $sentTo? $sentTo : '?',
                    'date_order_completed' => $shippingDate,
                    'date_order_completed_accuracy' => $shippingDateAccuracy,
                    'processing_status' => 'completed'
                );
                $orderId = customInsertRecord(array('orders' => $orderData));
                $shipId = customInsertRecord(array(
                    'shipments' => array(
                        'order_id' => $orderId,
                        'shipment_code' =>  $sentTo? $sentTo : '?',
                        'datetime_shipped' => $shippingDate,
                        'datetime_shipped_accuracy' => ($shippingDateAccuracy == 'c'? 'h' : $shippingDateAccuracy))
                ));
                $shipments[$sentTo.'//'.$shippingDate.'//'.$shippingDateAccuracy] = array($orderId, $shipId);
                
            }
            list($orderId, $shipId) = $shipments[$sentTo.'//'.$shippingDate.'//'.$shippingDateAccuracy];
            $orderItemId = customInsertRecord(array(
                'order_items' => array(
                    'order_id' => $orderId,
                    'tma_slide_id' => $tmaSlideId, 
                    'status' => 'shipped', 
                    'shipment_id' => $shipId)
            ));
        }
    }
}

recordErrorAndMessage(
    'Summary',
    '@@MESSAGE@@',
    "Shipments created",
    sizeof($shipments)." shipments have been created.");

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// End of the process
//--------------------------------------------------------------------------------------------------------------------------------------------------------

addToModifiedDatabaseTablesList('Collections', null);
addToModifiedDatabaseTablesList('sample_masters', $atim_controls['sample_controls']['tissue']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['tissue-block']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['tissue-core']['detail_tablename']);
addToModifiedDatabaseTablesList('specimen_review_masters', $atim_controls['specimen_review_controls']['core review']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_review_masters', $atim_controls['specimen_review_controls']['core review']['aliquot_review_detail_tablename']);
addToModifiedDatabaseTablesList('storage_masters', $atim_controls['storage_controls']['TMA-blc 29X21']['detail_tablename']);
addToModifiedDatabaseTablesList('realiquotings', null);
addToModifiedDatabaseTablesList('orders', null);
addToModifiedDatabaseTablesList('order_items', null);
addToModifiedDatabaseTablesList('shipments', null);
addToModifiedDatabaseTablesList('tma_slides', null);


/*
SET @created = (SELECT created FROM aliquot_masters WHERE created_by = 2 ORDER BY ID DESC LIMIT 0,1);



UPDATE Collections SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE sample_masters SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE aliquot_masters SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE aliquot_masters SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE specimen_review_masters SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE aliquot_review_masters SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE storage_masters SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE realiquotings SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE orders SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE order_items SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE shipments SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE tma_slides SET deleted = 1 WHERE created_by = 2 AND created = @created;
UPDATE tma_slides SET barcode = id WHERE deleted = 1;
UPDATE versions SET permissions_regenerated = 0;
*/

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// End of the Process
//--------------------------------------------------------------------------------------------------------------------------------------------------------

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

function getATiMTmaBlock($tmaBlockName) {
    global $atim_controls;
    global $tmaBlocks;
    
    if(!isset($tmaBlocks[$tmaBlockName])) {
        $storage_controls = $atim_controls['storage_controls']['TMA-blc 29X21'];
        $storage_data = array(
            'storage_masters' => array(
                "code" => 'tmp'.$tmaBlockName,
                "short_label" => $tmaBlockName,
                "selection_label" => $tmaBlockName,
                "storage_control_id" => $storage_controls['id'],
                "parent_id" => null),
            $storage_controls['detail_tablename'] => array());
        $tmaBlocks[$tmaBlockName] = customInsertRecord($storage_data);
    }
    return $tmaBlocks[$tmaBlockName];
}

function getATiMBlock($participantIdentifier, $blockAliquotLabel, $coreNbr, $tmaNameAndWorksheet, $excelLineCounter) {
    global $atimBlockSelectionData;
    global $atimControlCollectionId;
    global $atim_controls;
    global $imported_by;
    $dateOfNewBlockCreation = '2019-02-12 01:01:01';
    
//    $excelBlockUniqueKey = $tmaNameAndWorksheet.'###'.$participantIdentifier.'###'.$blockAliquotLabel;
    $excelBlockUniqueKey = ($participantIdentifier == '.'? '' : $participantIdentifier).'###'.$blockAliquotLabel;
    
    if(!isset($atimBlockSelectionData[$excelBlockUniqueKey])) {
        $blockCollectionMasterId = null;
        $blockSampleMasterId = null;
        $blockAliquotMasterId = null;
        if(($participantIdentifier == '.' || $participantIdentifier == '') && ($coreNbr == '.' || $coreNbr == '')) {
            
            // We are looking for a control block
            if(!$atimControlCollectionId) {
                $query = "SELECT id FROM collections WHERE collection_property = 'independent collection' AND collection_notes = 'Controls' AND deleted <> 1";
                $controlCollection = getSelectQueryResult($query);
                if(sizeof($controlCollection) != 1) die('ERR 287239237987');
                $atimControlCollectionId = $controlCollection[0]['id'];
            }
            $query = "SELECT
                Collection.id AS block_collection_id,
                SampleMaster.id AS block_sample_master_id,
                AliquotMaster.id AS block_aliquot_master_id,
                AliquotMaster.barcode,
                AliquotMaster.aliquot_label,
                AliquotMaster.in_stock
            
                FROM collections Collection
                INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id AND SampleMaster.deleted <> 1
                INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
                INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.sample_master_id = SampleMaster.id AND AliquotMaster.deleted <> 1
                INNER JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
            
                WHERE Collection.deleted <> 1
                AND Collection.id = $atimControlCollectionId
                AND AliquotMaster.aliquot_control_id = 8
                AND AliquotMaster.aliquot_label = 'CONTROL ".str_replace("'", "''", $blockAliquotLabel)."'";
            $atimControlBlocks = getSelectQueryResult($query);
            if($atimControlBlocks) {
                pr($atimControlBlocks);
                pr($blockAliquotLabel);
                
                die('ERR 287239237987xxxx');
            }
            
            // Create a new block
            $sampleData = array(
                'sample_masters' => array(
                    "sample_code" => 'tmp_tissue_'.$blockAliquotLabel,
                    "sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
                    "initial_specimen_sample_type" => 'tissue',
                    "collection_id" => $atimControlCollectionId),
                'specimen_details' => array(),
                $atim_controls['sample_controls']['tissue']['detail_tablename'] => array());
            $atimControlTissueSampleMasterId = customInsertRecord($sampleData);
            $aliquot_data = array(
                'aliquot_masters' => array(
                    "barcode" => 'tmp_'.$blockAliquotLabel,
                    'aliquot_label' => "CONTROL ".str_replace("'", "''", $blockAliquotLabel),
                    "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
                    "collection_id" => $atimControlCollectionId,
                    "sample_master_id" => $atimControlTissueSampleMasterId
                ),
                $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
                    'block_type' => 'paraffin',
                    'patho_dpt_block_code' => str_replace("'", "''", $blockAliquotLabel)
                ));
            $atimControlAliquotMasterId = customInsertRecord($aliquot_data);
            recordErrorAndMessage(
                'Summary',
                '@@MESSAGE@@',
                "New Tissue block 'CONTROL' creation.",
                "Created tissue block as control : CONTROL $blockAliquotLabel");
            $blockCollectionMasterId = $atimControlCollectionId;
            $blockSampleMasterId = $atimControlTissueSampleMasterId;
            $blockAliquotMasterId = $atimControlAliquotMasterId;
            
        } else {
            
            // We are looking for a participant block
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
                        "The ATiM tissue block selected to create the core has been selected because it's the only one created based on the new XLS file with tissue blocks created in 2019. Core will be create but match has clearly to be validated.",
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
                $blockCollectionMasterId = $participantAtimBlocks[$firstBlockAvailableKey]['block_collection_id'];
                $blockSampleMasterId = $participantAtimBlocks[$firstBlockAvailableKey]['block_sample_master_id'];
                $blockAliquotMasterId = $participantAtimBlocks[$firstBlockAvailableKey]['block_aliquot_master_id'];
            }
        }
        
        $atimBlockSelectionData[$excelBlockUniqueKey] = array($blockCollectionMasterId, $blockSampleMasterId, $blockAliquotMasterId);
    } elseif(is_null($atimBlockSelectionData[$excelBlockUniqueKey][2])) {
        recordErrorAndMessage(
            $tmaNameAndWorksheet,
            '@@ERROR@@',
            "The ATiM tissue block has not be found based on participant TFRI# and pathology code listed on a previous line (see ERRORs above). Core won't be created. Create core manually into ATiM after the migration.",
            "See tissue block with label <b>".((strlen($blockAliquotLabel) && $blockAliquotLabel != '.')? $blockAliquotLabel : 'no value').
            "</b> created for participant TFRI# <b>".((strlen($participantIdentifier) && $participantIdentifier != '.')? $participantIdentifier : 'no value').
            "</b> and core# <b>".((strlen($coreNbr) && $coreNbr != '.')? $coreNbr : 'no value').
            "</b>. Line $excelLineCounter.");
    }
    
    return $atimBlockSelectionData[$excelBlockUniqueKey];
}

function createRevision($participantIdentifier, $blockAliquotLabel, $collection_id, $sample_master_id, $coreAliquotMasterId, $excelLineCoreData, $excelLineCounter) {
    global $atim_controls;
    global $revisionCounter;

    $revisions = array();
    foreach(array('revision', 'sites', 'Sites', 'revision Rahimi juin2018') as $field) {
        if(isset($excelLineCoreData[$field]) && strlen($excelLineCoreData[$field]) && $excelLineCoreData[$field] != '.') {
            if($field == 'revision Rahimi juin2018') {
                $revisions[] = array('2018=01-01', 'm', 'Dr Rahimi', $excelLineCoreData[$field]);
            } else {
                $revisions[] = array('', '', '', $field. ' : ' . $excelLineCoreData[$field]);
            }
        }
    }
    foreach($revisions as $newRevision) {
        $revisionCounter++;
        list ($date, $dateAcc, $pathologist, $revValue) = $newRevision;
        //Create path review
        $specimen_review_data = array(
            'specimen_review_masters' => array(
                'collection_id' => $collection_id,
                'sample_master_id' => $sample_master_id,
                'specimen_review_control_id' => $atim_controls['specimen_review_controls']['core review']['id'],
                'review_date' => $date,
                'review_date_accuracy' => $dateAcc,
                'pathologist' => $pathologist),
            $atim_controls['specimen_review_controls']['core review']['detail_tablename'] => array());
        $specimen_review_master_id = customInsertRecord($specimen_review_data);
        $aliquot_review_data = array(
            'aliquot_review_masters' => array(
                'aliquot_master_id' => $coreAliquotMasterId,
                'aliquot_review_control_id' => $atim_controls['specimen_review_controls']['core review']['aliquot_review_control_id'],
                'specimen_review_master_id' => $specimen_review_master_id),
            $atim_controls['specimen_review_controls']['core review']['aliquot_review_detail_tablename'] => array(
                'site_revision' => $revValue));
        customInsertRecord($aliquot_review_data);
    }
}

?>
		