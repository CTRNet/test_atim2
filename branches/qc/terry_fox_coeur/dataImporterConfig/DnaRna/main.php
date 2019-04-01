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

displayMigrationTitle('TFRI COEUR - DNA RNA Creation', $bank_excel_files);

if(!testExcelFile($bank_excel_files)) {
	dislayErrorAndMessage();
	exit;
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Main Code
//--------------------------------------------------------------------------------------------------------------------------------------------------------
global $allAtimStudies;
$allAtimStudies = array();
foreach(getSelectQueryResult("SELECT id, title from study_summaries WHERE deleted <> 1;") as $newStudy) {
    $allAtimStudies['complet'][strtolower($newStudy['title'])] = $newStudy['id'];
    if(preg_match('/(COEUR\-[0-9]+)/', $newStudy['title'], $matches)) {
        $allAtimStudies['partiel'][strtolower($matches[1])] = array($newStudy['id'], $newStudy['title']);
    }
}

$fileName = $bank_excel_files[0];
global $unmigratedData;
$unmigratedData = array();
global $migratedDataToValidate;
$migratedDataToValidate = array();
$createdRecordsCounter = array(
    'collections created' => 0,
    'blood samples created' => 0,
    'buffy coat samples created' => 0,
    'tissue samples created' => 0,
    'FFPE blocks created' => 0,
    'OCT blocks created' => 0,
    'tissue tubes created' => 0,
    'tissue cores created' => 0,
    'tissue slides created' => 0,
    'dna samples created' => 0,
    'rna samples created' => 0,
    'dna tubes created' => 0,
    'rna tubes created' => 0,
    'quantity source used for extraction' => 0,
    'DNA/RNA used' => 0,
    'freezers created' => 0,
    'shelfs created' => 0,
    'rack16s created' => 0,
    'box81 1A-9Is created' => 0,
    'box81s created' => 0,
    'QCs created' => 0
);
global $dnaRnaExtractions;
$dnaRnaExtractions = array();
global $dnaAmplifcations;
$dnaAmplifcations = array();
global $allStorages;
$allStorage = getExistingStorage();
global $allAliquotSourceQuantityUsedControl;
$allAliquotSourceQuantityUsedControl = array();
global $allShippingsToCreate;
$allShippingsToCreate = array();
$worksheetnames= array('RNA FFPE', 'RNA FT', 'DNA FFPE tissues', 'DNA Normal', 'DNA FT');
$xls_empty_fields_to_validate = array(
    'RNA FFPE' => array('Column', 'Lane', 'Temperature', 'ARN aliquote uG', 'ARN aliquote uL', "Dilution (uL d'eau)", 'Volume shipped uL', 'Concentration shipped ug/uL', 'shipping date', 'contact shipping', 'ProjectID', 'adress shipping', 'Fedex'),#
    'RNA FT' => array('ARN aliquote uG')
    );
foreach($worksheetnames as $worksheetName) {
    $extractionSampleAliquotDataFromParticipantId = array();
    while($exceldata = getNextExcelLineData($fileName, $worksheetName)) {
        list($excelLineCounter, $excelLineData) = $exceldata;
        if(isset($xls_empty_fields_to_validate[$worksheetName])) {
            foreach($xls_empty_fields_to_validate[$worksheetName] as $xls_field) {
                if(isset($excelLineData[$xls_field]) && strlen($excelLineData[$xls_field])) die('ERR238273982738' ."$worksheetName $xls_field $excelLineCounter");
            }
        }
        // === Get ATiM Participant ===
        $participantId = getParticipantId($excelLineData, $worksheetName, $excelLineCounter);      
        if($participantId) {
            list($participantId, $excelParticipantAtimNbr, $excelParticipantBankNbr) = $participantId;   // === Manage data to display in summary ===
//TODO
//if(!in_array($participantId, array('16', '177'))) continue;
            // Participant Info
            $excelParticipantInfoForMsg = array();
            if($excelParticipantAtimNbr) $excelParticipantInfoForMsg[] = "Participant ATiM# <b>$excelParticipantAtimNbr</b>";
            if($excelParticipantBankNbr) $excelParticipantInfoForMsg[] = "Participant Bank# <b>$excelParticipantBankNbr</b>";
            $excelParticipantInfoForMsg = 'Excel ' .implode(' and ', $excelParticipantInfoForMsg);
            // Manage data to display in summary : Participant Info
            $excelSampleLabel = isset($excelLineData['Sample label'])? $excelLineData['Sample label'] : '';
            $excelSampleFtSource = isset($excelLineData['Sample FT source'])? $excelLineData['Sample FT source'] : '';
            $excelAliquotName = isset($excelLineData['Aliquot Name'])? $excelLineData['Aliquot Name'] : '';
            $excelBlockId = isset($excelLineData['Bloc_ID'])? $excelLineData['Bloc_ID'] : (isset($excelLineData['BlockID'])? $excelLineData['BlockID'] : '');
            $excelSourceType = isset($excelLineData['source type'])? $excelLineData['source type'] : (isset($excelLineData['Source type'])? $excelLineData['Source type'] : '');
            $excelSourceAliquotInfoForMsg = array(
                "Sample <b>$excelSampleLabel</b>" => $excelSampleLabel,
                "Sample FT Source <b>$excelSampleFtSource</b>" => $excelSampleFtSource,
                "Aliquot <b>$excelAliquotName</b>" => $excelAliquotName,
                "Source type <b>$excelSourceType</b>" => $excelSourceType,
                "Bloc <b>$excelBlockId</b>" => $excelBlockId,
            );
            $excelSourceAliquotInfoForMsg = array_filter($excelSourceAliquotInfoForMsg, function($var){
                return (!($var == '' || is_null($var)));
            });
            $excelSourceAliquotInfoForMsg = array_keys($excelSourceAliquotInfoForMsg);
            $excelSourceAliquotInfoForMsg = implode(' and ', $excelSourceAliquotInfoForMsg);
            // === Get ATiM Aliquot/sample as source of the extraction ===
            $atimSourceAliquot = getAtimAliquotSource($excelLineData, $worksheetName, $excelLineCounter, $participantId, $excelParticipantAtimNbr, $excelParticipantBankNbr, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg);
            addHAndE($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot, $excelSourceType);
            // === Create DNA /RNA extraction
            $extractionSampleAliquotData = createExtraction($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot, $excelSourceType);
            if($extractionSampleAliquotData) $extractionSampleAliquotDataFromParticipantId[$participantId][] = $extractionSampleAliquotData;
            // === Create DNA /RNA Amplification
//
            // === Create DNA /RNA QC
            addQualityControls($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $extractionSampleAliquotData);
            // === Create DNA /RNA Shipping
            addOrderAndShipping($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $extractionSampleAliquotData);
        } // End if participant id
    } // End new worksheet line
    addAmplifications($dnaAmplifcations, $worksheetName, $extractionSampleAliquotDataFromParticipantId);

    echo "<br><br><FONT COLOR=\"GREEN\" >
==========================================================================================================================================<br><br>
<b> Worksheet Migration Summary: $worksheetName</b> <br><br>
==========================================================================================================================================</FONT><br>";
    dislayErrorAndMessage();
    $import_summary = array();
}

createShipping();

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// End of the process
//--------------------------------------------------------------------------------------------------------------------------------------------------------

duplciatedDnaRnaAnalysis();

foreach($createdRecordsCounter as $recordType => $value) {
    recordErrorAndMessage('Migration Summary', '@@MESSAGE@@', "Number of created records", $recordType .' : '.$value);
}

$lastQueriesToExecute = array(
    "UPDATE sample_masters SET sample_code=id WHERE sample_code LIKE 'tmp_%';",
    "UPDATE sample_masters SET initial_specimen_sample_id=id WHERE parent_id IS NULL;",
    "UPDATE aliquot_masters SET barcode=id WHERE barcode LIKE 'tmp_%';",
    "UPDATE storage_masters SET code=id;",
    "UPDATE versions SET permissions_regenerated = 0;"
);
foreach($lastQueriesToExecute as $query) customQuery($query);

//TODO complete

addToModifiedDatabaseTablesList('Collections', null);

addToModifiedDatabaseTablesList('sample_masters', $atim_controls['sample_controls']['tissue']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['tissue-block']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['tissue-core']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['tissue-tube']['detail_tablename']);
addToModifiedDatabaseTablesList('sample_masters', $atim_controls['sample_controls']['blood cell']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['blood cell-tube']['detail_tablename']);
addToModifiedDatabaseTablesList('sample_masters', $atim_controls['sample_controls']['dna']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['dna-tube']['detail_tablename']);
addToModifiedDatabaseTablesList('sample_masters', $atim_controls['sample_controls']['rna']['detail_tablename']);
addToModifiedDatabaseTablesList('aliquot_masters', $atim_controls['aliquot_controls']['rna-tube']['detail_tablename']);

addToModifiedDatabaseTablesList('storage_masters', $atim_controls['storage_controls']['freezer']['detail_tablename']);
addToModifiedDatabaseTablesList('storage_masters', $atim_controls['storage_controls']['rack16']['detail_tablename']);
addToModifiedDatabaseTablesList('storage_masters', $atim_controls['storage_controls']['shelf']['detail_tablename']);
addToModifiedDatabaseTablesList('storage_masters', $atim_controls['storage_controls']['box81']['detail_tablename']);
addToModifiedDatabaseTablesList('storage_masters', $atim_controls['storage_controls']['box81 1A-9I']['detail_tablename']);

addToModifiedDatabaseTablesList('aliquot_internal_uses', null);
addToModifiedDatabaseTablesList('realiquotings', null);
addToModifiedDatabaseTablesList('quality_ctrls', null);
addToModifiedDatabaseTablesList('source_aliquots', null);
addToModifiedDatabaseTablesList('orders', null);
addToModifiedDatabaseTablesList('order_items', null);
addToModifiedDatabaseTablesList('shipments', null);

if(!$commitAll) mysqli_rollback($db_connection);
dislayErrorAndMessage($commitAll);

mysqli_rollback($db_connection);
mysqli_close($db_connection);

//--------------------------------------------------------------------------------------------------------------------------------------------------------
// Build data for CSV creation
//--------------------------------------------------------------------------------------------------------------------------------------------------------

foreach($worksheetnames as $worksheetName) {

    echo "<br><br><FONT COLOR=\"GREEN\" >
==========================================================================================================================================<br><br>
<b> Unmigrated data or migrated data with warning to save in CSV for revision. Worksheet : $worksheetName</b> <br><br>
==========================================================================================================================================</FONT><br>";

    echo "<br><FONT COLOR=\"red\">
<b>EXTRACTION NOT CREATED : TO REVIEW</b><br>
----------------------------------------------------------------------<br></FONT><br>";
    
    if(isset($unmigratedData[$worksheetName])) {
        $firstRecord = true;
        foreach($unmigratedData[$worksheetName] as $lineData) {
            if($firstRecord) {
                $newLineToDisplay = "\"";
                $headers = array_keys($lineData);
                $newLineToDisplay .= implode("\";\"", $headers);
                $newLineToDisplay .= "\"<br>";
                echo $newLineToDisplay;
            }
            $firstRecord = false;
            $newLineToDisplay = "\"";
            $newLineToDisplay .= implode("\";\"", $lineData);
            $newLineToDisplay .= "\"<br>";
            echo $newLineToDisplay;
        }
    }

    echo "<br><br><FONT COLOR=\"orange\">
<b>EXTRACTION CREATED BUT TO VALIDATE</b><br>
----------------------------------------------------------------------<br></FONT><br>";
    
    if(isset($migratedDataToValidate[$worksheetName])) {
        $firstRecord = true;
        foreach($migratedDataToValidate[$worksheetName] as $lineData) {
            if($firstRecord) {
                $newLineToDisplay = "\"";
                $headers = array_keys($lineData);
                $newLineToDisplay .= implode("\";\"", $headers);
                $newLineToDisplay .= "\"<br>";
                echo $newLineToDisplay;
            }
            $firstRecord = false;
            $newLineToDisplay = "\"";
            $newLineToDisplay .= implode("\";\"", $lineData);
            $newLineToDisplay .= "\"<br>";
            echo $newLineToDisplay;
        }
    }
}

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
// Functions
//--------------------------------------------------------------------------------------------------------------------------------------------------------

function getParticipantId($excelLineData, $worksheetName, $excelLineCounter) {
    // Get Participant ATiM # from Excel
    $participantAtimNbr = '';
    $fieldFound = false;
    foreach(array('COEUR-TFRI ID', 'COEUR ID') as $field) {
        if(array_key_exists($field, $excelLineData)) {
            $participantAtimNbr = $excelLineData[$field];
            $fieldFound = true;
            break;
        }
    }
    if(!$fieldFound) die('ERR2327687236 ' . $worksheetName);
    // Get Participant Bank # from Excel
    $participantBankNbr = '';
    foreach(array('participantBank#', 'participantBank ID') as $field) {
        if(array_key_exists($field, $excelLineData) && strlen($excelLineData[$field])) {
            $participantBankNbr = $excelLineData[$field];
            break;
        }
    }
    if(!$participantAtimNbr && !$participantBankNbr) {
        // Identifiers are missing
        // ===============================================================
        $errorTitle = "Both Participant ATiM # and Participant Bank # are not defined into Excel. No data of the line will be migrated. Please confirm.";
        recordErrorAndMessage($worksheetName .' :: ' .
            'Participant Definition',
            '@@ERROR@@',
            $errorTitle." [Validation Message #".__LINE__."]",
            "See Participant defined in sheet '$worksheetName' line $excelLineCounter.");
        addUnmigratedLine($excelLineData, $worksheetName, $excelLineCounter, $errorTitle);
        return null;
    } else if($participantAtimNbr) {
        //  Participant ATiM Nbr defined into Excel
        // ===============================================================
        $query = "SELECT participants.id AS participant_id, participant_identifier, qc_tf_bank_identifier, banks.name AS bank_name
            FROM participants
            LEFT JOIN banks ON banks.id = participants.qc_tf_bank_id
            WHERE participant_identifier = '$participantAtimNbr'
            AND participants.deleted <> 1";
        $participant = getSelectQueryResult($query);
        if(!$participant) {
            $errorTitle = "Participant ATiM # defined into Excel does not match a participant into ATiM. No data of the line will be migrated. Please confirm.";
            recordErrorAndMessage($worksheetName .' :: ' .
                'Participant Definition',
                '@@ERROR@@',
                $errorTitle." [Validation Message #".__LINE__."]",
                "See Participant ATiM # '$participantAtimNbr' ".($participantBankNbr? " and Participant Bank # $participantBankNbr": '')." defined in sheet '$worksheetName' line $excelLineCounter.");
            addUnmigratedLine($excelLineData, $worksheetName, $excelLineCounter, $errorTitle);
            return null;
        } else if (sizeof($participant) > 1) {
            die('ERR 2872893723987');
        } else {
            $participant = $participant[0];
            // Validate the Participant Bank Nbr
            $validationOnparticipantBankNbr = false;
            if($participantBankNbr){
                if(strtolower($participantBankNbr) != strtolower($participant['qc_tf_bank_identifier'])) {
                    $warningMessage = "ATiM and Excel participants match on Participant ATiM # but the Participant Bank # values do not match. Data of the line will be migrated but please validate."." [Validation Message #".__LINE__."]";
                    $warningDetail = "See Participant Bank # '$participantBankNbr'(excel) and '".$participant['qc_tf_bank_identifier']."'(ATIM) for Participant ATiM # '$participantAtimNbr' defined in sheet '$worksheetName' line $excelLineCounter.";
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Participant Definition',
                        '@@WARNING@@',
                        $warningMessage,
                        "See migrated line to validate below.",
                        "See migrated line to validate below.");
                    addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                } else {
                    $validationOnparticipantBankNbr = true;
                }
            }
            // Validate the bank
            $validationOnBank = false;
            $bank = '';
            foreach(array('BankID', 'Bank') as $field) {
                if(array_key_exists($field, $excelLineData) && strlen($excelLineData[$field])) {
                    $bank = $excelLineData[$field];
                    if(preg_match('/^(.+)\-$/', $bank, $matches)) $bank = $matches[1];
                    break;
                }
            }
            if($bank) {
                if(strtolower($bank) != strtolower($participant['bank_name'])) {
                    $warningMessage = "ATiM and Excel participants match on Participant ATiM # but the Bank values do not match. Data of the line will be migrated but please validate."." [Validation Message #".__LINE__."]";
                    $warningDetail = "See banks '$bank'(excel) and '".$participant['bank_name']."'(ATIM) for Participant ATiM# '$participantAtimNbr' ".($participantBankNbr? " and Participant Bank # $participantBankNbr": '')." defined in sheet '$worksheetName' line $excelLineCounter.";
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Participant Definition',
                        '@@WARNING@@',
                        $warningMessage,
                        "See migrated line to validate below.",
                        "See migrated line to validate below.");
                    addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                } else {
                    $validationOnBank = true;
                }
            }
            if(!$validationOnBank && !$validationOnparticipantBankNbr) {
                if(!$bank && !$participantBankNbr) {
                    $titlePrecision = "but both bank and Participant Bank # are not defined into Excel";
                    $warningMessage ="ATiM and Excel participants match on Participant ATiM # $titlePrecision. Data of the line will be migrated but please validate."." [Validation Message #".__LINE__."]";
                    $warningDetail = "See Participant ATiM # '$participantAtimNbr' ".($participantBankNbr? " and Participant Bank # $participantBankNbr": '').($bank? " and bank $bank": '')." defined in sheet '$worksheetName' line $excelLineCounter.";
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Participant Definition',
                        '@@WARNING@@',
                        $warningMessage,
                        "See migrated line to validate below.",
                        "See migrated line to validate below.");
                    addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                } else if($participantBankNbr) {
                    // A message has already be recored
                } else {
                    // A message has already be recored
                }
            }
            return array($participant['participant_id'], $participantAtimNbr, $participantBankNbr);
        }
    } else {
        // Participant ATiM # not defined into excel 
        // but Participant Bank Number defined into excel :
        // Try to find participant based on Participant Bank Number 
        // ===============================================================
        $query = "SELECT participants.id AS participant_id, participant_identifier, qc_tf_bank_identifier, banks.name AS bank_name
            FROM participants
            LEFT JOIN banks ON banks.id = participants.qc_tf_bank_id
            WHERE participant_identifier = '$participantBankNbr'
            AND participants.deleted <> 1";
        $participant = getSelectQueryResult($query);
        if(sizeof($participant) > 1) {
            die('ERR 237623876287623');
        } else if(!sizeof($participant)) {
            $errorTitle = "Participant ATiM # is not defined into Excel and the participant can not be found based on the Participant Bank #. No data of the line will be migrated. Please confirm.";
            recordErrorAndMessage($worksheetName .' :: ' .
                'Participant Definition',
                '@@ERROR@@',
                $errorTitle." [Validation Message #".__LINE__."]",
                "See Participant Bank # '$participantBankNbr' defined in sheet '$worksheetName' line $excelLineCounter.");
            addUnmigratedLine($excelLineData, $worksheetName, $excelLineCounter, $errorTitle);
            return null;
        } else {
            $participant = $participant[0];
            // Validate the bank
            $bank = '';
            foreach(array('BankID', 'Bank') as $field) {
                if(array_key_exists($field, $excelLineData) && strlen($excelLineData[$field])) {
                    $bank = $excelLineData[$field];
                    if(preg_match('/^(.+)\-$/', $bank, $matches)) $bank = $matches[1];
                    break;
                }
            }
            if($bank) {
                if(strtolower($bank) != strtolower($participant['bank_name'])) {
                $warningMessage = "ATiM and Excel participants match on Participant Bank # but the Bank values do not match. Data of the line will be migrated but please validate."." [Validation Message #".__LINE__."]";
                $warningDetail = "See banks '$bank'(excel) and '".$participant['bank_name']."'(ATIM) for Participant Bank # '$participantBankNbr' defined in sheet '$worksheetName' line $excelLineCounter.";
                recordErrorAndMessage($worksheetName .' :: ' .
                        'Participant Definition',
                        '@@WARNING@@',
                        $warningMessage,
                        "See migrated line to validate below.",
                        "See migrated line to validate below.");
                addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                }
            } else {
                $warningMessage = "ATiM and Excel participants match on Participant Bank # but bank values can not be validated. Data of the line will be migrated but please validate."." [Validation Message #".__LINE__."]";
                $warningDetail = "See Participant ATiM# '$participantAtimNbr' ".($bank? " and bank $bank": '')." defined in sheet '$worksheetName' line $excelLineCounter.";
                recordErrorAndMessage($worksheetName .' :: ' .
                    'Participant Definition',
                    '@@WARNING@@',
                    $warningMessage,
                    "See migrated line to validate below.",
                    "See migrated line to validate below.");
                addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
            }
            return array($participant['participant_id'], $participantAtimNbr, $participantBankNbr);
        }
    }
    die('ERR2398729872');
}

function getAtimAliquotSource($excelLineData, $worksheetName, $excelLineCounter, $participantId, $excelParticipantAtimNbr, $excelParticipantBankNbr, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg) {
    global $atim_controls ;
    global $createdRecordsCounter;
    global $dnaAmplifcations; 
    global $import_date;
    
    // Get source aliquot control
    $parentAliquotAtimControl = null;
    $typeOfSourceAliquotForMsg = '';
    if(in_array($worksheetName, array('RNA FT', 'DNA FT'))) {
        // Worksheet
        //    - 'RNA FT'
        //    - 'DNA FT'
        if(in_array($excelLineData['source type'], array('OCT','Tissue block'))) {
            $parentAliquotAtimControl = $atim_controls['aliquot_controls']['tissue-block'];
            $typeOfSourceAliquotForMsg = 'OCT block';
        } else if (in_array($excelLineData['source type'], array('FT', 'frozen tissue', 'Frozen Tissue', ''))) {
            $parentAliquotAtimControl = $atim_controls['aliquot_controls']['tissue-tube'];
            $typeOfSourceAliquotForMsg = 'Tissue Tube';
        } else {
            die('ERR 4345278'.$excelLineData['source type'].'|');
        }
    } else if(in_array($worksheetName, array('RNA FFPE', 'DNA FFPE tissues'))) {
        // Worksheet
        //    - 'RNA FFPE'
        //    - 'DNA FFPE tissues'
        if(!in_array($excelLineData['source type'], array('FFPE-core-tumor', 'FFPE-slide-tumor', 'FFPE-tumor', ''))) die('ERR 12718761394 '.$excelLineData['source type']);
        $parentAliquotAtimControl = $atim_controls['aliquot_controls']['tissue-block'];
        $typeOfSourceAliquotForMsg = 'FFPE block';
    } else if($worksheetName == 'DNA Normal') {
        // Worksheet
        //    - 'DNA Normal'
        if($excelLineData['source type'] == 'Buffy coat') {
            $parentAliquotAtimControl = $atim_controls['aliquot_controls']['blood cell-tube'];
            $typeOfSourceAliquotForMsg = 'Buffy Coat tube';
        } else if (in_array($excelLineData['source type'], array('FFPE normal fallopian tube', 'FFPE normal falopian tube'))) {
            $parentAliquotAtimControl = $atim_controls['aliquot_controls']['tissue-block'];
            $typeOfSourceAliquotForMsg = 'FFPE block';
        } else if($excelLineData['source type'] == 'normal DNA') {
            $parentAliquotAtimControl = $atim_controls['aliquot_controls']['dna-tube'];
            $typeOfSourceAliquotForMsg = 'DNA tube';
        } else if($excelLineData['source type'] == '') {
            $errorTitle = "Script is not able to defined the type of the aliquot used for the extraction based on the worksheet name because the source type value is not defined. ($worksheetName)";
            recordErrorAndMessage($worksheetName .' :: ' .
                'Aliquot Source Definition',
                '@@ERROR@@',
                $errorTitle." [Validation Message #".__LINE__."]",
                "See excel aliquot defined by $excelSourceAliquotInfoForMsg for participant $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
            addUnmigratedLine($excelLineData, $worksheetName, $excelLineCounter, $errorTitle);
            return null;
        } else {
            die('ERR 53776556');
        }
    } else {
        die('ERR 999483873272'.$worksheetName);
    }
    if(!$parentAliquotAtimControl) {
        die('ERR 5377642222288556');
    } else {
        // Participant found and aliquot type define. Try to find the aliquot.
        if($typeOfSourceAliquotForMsg == 'DNA tube') {
            //DNA amplification
            $dnaAmplifcations[$worksheetName][] = array(
                'participant_id' => $participantId, 
                'excelLineCounter' => $excelLineCounter, 
                'data' => $excelLineData,
                'excelParticipantInfoForMsg' => $excelParticipantInfoForMsg, 
                'excelSourceAliquotInfoForMsg' => $excelSourceAliquotInfoForMsg
            );
            return null;
        } else {
            if(isset($excelLineData['amplification date']) && strlen($excelLineData['amplification date'])) die('ERR2347236872364872');
            if(isset($excelLineData['amplification methode']) && strlen($excelLineData['amplification methode'])) die('ERR234723687233333');
            // DNA or RNA extraction
            $sql = "SELECT barcode, aliquot_label, block_type, qc_tf_storage_solution, participant_id, AM.collection_id, sample_master_id, AM.id AS aliquot_master_id, initial_specimen_sample_id, initial_specimen_sample_type, sample_type
                FROM aliquot_masters AM
                INNER JOIN sample_masters SM ON SM.id = AM.sample_master_id
                INNER JOIN sample_controls SC ON SC.id = SM.sample_control_id
                INNER JOIN collections COL ON COL.id = AM.collection_id
                LEFT JOIN ad_blocks ad_blocks ON ad_blocks.aliquot_master_id = AM.id ".($typeOfSourceAliquotForMsg == 'FFPE block'? "AND block_type = 'paraffin' " : ($typeOfSourceAliquotForMsg == 'OCT block'? "AND block_type = 'OCT' " : '')) . "
                LEFT JOIN ad_tubes ad_tubes ON ad_tubes.aliquot_master_id = AM.id
                WHERE SM.deleted <> 1 AND AM.deleted <> 1
                AND aliquot_control_id = ".$parentAliquotAtimControl['id'] ."
                AND (in_stock_detail NOT LIKE 'wrong % (1st migration)' OR in_stock_detail IS NULL)
                AND COL.participant_id = $participantId";
            $aliquotSources = array();
            foreach(getSelectQueryResult($sql) as $newAliquot) {
                $aliquotSources[$newAliquot['aliquot_label']][] = $newAliquot;
            }
            // If source is buffy coat
            // script will create the buffy coat because 
            // all buffy coats have not initialy been migrated
            $bfcSpecialKey = 'BFC###SPECIAL KEY ###'.__LINE__;
            if(!$aliquotSources && $typeOfSourceAliquotForMsg == 'Buffy Coat tube') {
                $sql = "SELECT null AS barcode, null AS aliquot_label, null AS block_type, null AS qc_tf_storage_solution, participant_id, SM.collection_id, SM.id AS sample_master_id, null AS aliquot_master_id, initial_specimen_sample_id, initial_specimen_sample_type, sample_type
                    FROM sample_masters SM
                    INNER JOIN sample_controls SC ON SC.id = SM.sample_control_id
                    INNER JOIN collections COL ON COL.id = SM.collection_id
                    WHERE SM.deleted <> 1
                    AND sample_control_id = ".$atim_controls['sample_controls']['blood cell']['id'] ."
                    AND COL.participant_id = $participantId";
                $bfcs = array();
                foreach(getSelectQueryResult($sql) as $newBfc) {
                    $bfcs[] = $newBfc;
                }
                if($bfcs) {
                    if(sizeof($bfcs) != 1) die('ERR2382839723987');
                    $warningMessage = "No $typeOfSourceAliquotForMsg exists into ATiM for the participant but a Buffy Coat sample exists. No tube of Buffy coat will be created but extraction will be linked to this existing sample. (worksheet : $worksheetName)"." [Validation Message #".__LINE__."]";
                    $warningDetail = "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Aliquot Source Definition',
                        '@@WARNING@@',
                        $warningMessage,
                        "See migrated line to validate below.",
                        "See migrated line to validate below.");
                    addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                    $aliquotSources = array($bfcSpecialKey => array($bfcs[0]));
                }
                if(!$aliquotSources) {
                    $sql = "SELECT null AS barcode, null AS aliquot_label, null AS block_type, null AS qc_tf_storage_solution, participant_id, SM.collection_id, SM.id AS sample_master_id, null AS aliquot_master_id, initial_specimen_sample_id, initial_specimen_sample_type, sample_type
                        FROM sample_masters SM
                        INNER JOIN sample_controls SC ON SC.id = SM.sample_control_id
                        INNER JOIN collections COL ON COL.id = SM.collection_id
                        WHERE SM.deleted <> 1
                        AND sample_control_id = ".$atim_controls['sample_controls']['blood']['id'] ."
                        AND COL.participant_id = $participantId";
                    $bloods = array();
                    foreach(getSelectQueryResult($sql) as $newBlood) {
                        $bloods[] = $newBlood;
                    }
                    if(sizeof($bloods) == 1) {
                        $warningMessage = "No $typeOfSourceAliquotForMsg and sample exist into ATiM for the participant but a Blood sample already exists. A Buffy Coat sample will be created (with no tube) for this Blood and extraction will be linked to this buffy Coat sample. (worksheet : $worksheetName)"." [Validation Message #".__LINE__."]";
                        $warningDetail = "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Aliquot Source Definition',
                            '@@WARNING@@',
                            $warningMessage,
                            "See migrated line to validate below.",
                            "See migrated line to validate below.");
                        addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                        $createdRecordsCounter['buffy coat samples created']++;
                        $bcf_data = array(
                            'sample_masters' => array(
                                "sample_code" => 'tmp_blood cell_for_'.$createdRecordsCounter['buffy coat samples created'],
                                "sample_control_id" => $atim_controls['sample_controls']['blood cell']['id'],
                                "initial_specimen_sample_id" => $bloods[0]['sample_master_id'],
                                "initial_specimen_sample_type" => $bloods[0]['sample_type'],
                                "collection_id" => $bloods[0]['collection_id'],
                                "parent_id" => $bloods[0]['sample_master_id'],
                                "parent_sample_type" => $bloods[0]['sample_type']),
                            'derivative_details' => array(),
                            $atim_controls['sample_controls']['blood cell']['detail_tablename'] => array());
                        $bfc_sample_master_id = customInsertRecord($bcf_data);
                        $aliquotSources = array(
                            $bfcSpecialKey => array(array(
                                'barcode' => '',
                                'aliquot_label' => '',
                                'block_type' => '',
                                'qc_tf_storage_solution' => '',
                                'participant_id' => $participantId,
                                'collection_id' => $bloods[0]['collection_id'],
                                'sample_master_id' => $bfc_sample_master_id,
                                'aliquot_master_id' => '',
                                'initial_specimen_sample_id' => $bloods[0]['sample_master_id'],
                                'initial_specimen_sample_type' => $bloods[0]['sample_type'],
                                'sample_type' => 'blood cell')));
                    } else {
                        // Create a new collection
                        $createdRecordsCounter['collections created']++;
                        $collection_id = customInsertRecord(array(
                            'collections' => array(
                                'participant_id' => $participantId,
                                'collection_property' => 'participant collection',
                                'collection_notes'=>'Created by script to track Blood DNA/RNA from excel on '.substr($import_date, 0,10) .'.')));
                        $createdRecordsCounter['blood samples created']++;
                        $sample_data = array(
                            'sample_masters' => array(
                                "sample_code" => 'tmp_blood_'.$createdRecordsCounter['blood samples created'],
                                "sample_control_id" => $atim_controls['sample_controls']['blood']['id'],
                                "initial_specimen_sample_type" => 'blood',
                                "collection_id" => $collection_id),
                            'specimen_details' => array(),
                            $atim_controls['sample_controls']['blood']['detail_tablename'] => array());
                        $blood_sample_master_id = customInsertRecord($sample_data);
                        $createdRecordsCounter['buffy coat samples created']++;
                        $bcf_data = array(
                           'sample_masters' => array(
                                "collection_id" => $collection_id,
                                "sample_code" => 'tmp_blood cell_for_'.$createdRecordsCounter['buffy coat samples created'],
                                "sample_control_id" => $atim_controls['sample_controls']['blood cell']['id'],
                                "initial_specimen_sample_id" => $blood_sample_master_id,
                                "initial_specimen_sample_type" => 'blood',
                                "parent_id" => $blood_sample_master_id,
                                "parent_sample_type" => 'blood'),
                            'derivative_details' =>  array(),
                            $atim_controls['sample_controls']['blood cell']['detail_tablename'] => array());
                        $bfc_sample_master_id = customInsertRecord($bcf_data);
                        $aliquotSources = array(
                            $bfcSpecialKey => array(array(
                                'barcode' => '',
                                'aliquot_label' => '',
                                'block_type' => '',
                                'qc_tf_storage_solution' => '',
                                'participant_id' => $participantId,
                                'collection_id' => $collection_id,
                                'sample_master_id' => $bfc_sample_master_id,
                                'aliquot_master_id' => '',
                                'initial_specimen_sample_id' => $blood_sample_master_id,
                                'initial_specimen_sample_type' => 'blood',
                                'sample_type' => 'blood cell')));
                        $warningMessage = "No $typeOfSourceAliquotForMsg exists into ATiM for the participant and more than one Blood sample already exists. New collection, blood and buffy coat sample will be created and extraction will be linked to this buffy coat sample. (worksheet : $worksheetName)"." [Validation Message #".__LINE__."]";
                        if(!$bloods) {
                            $warningMessage = "No $typeOfSourceAliquotForMsg and Blood sample exist into ATiM for the participant. New collection, blood and buffy coat sample will be created and extraction will be linked to this buffy coat sample. (worksheet : $worksheetName)"." [Validation Message #".__LINE__."]";
                        }
                        $warningDetail = "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Aliquot Source Definition',
                            '@@WARNING@@',
                            $warningMessage,
                            "See migrated line to validate below.",
                            "See migrated line to validate below.");
                        addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                    }
                }
            }            
            if(!$aliquotSources) {
                $errorTitle = "No $typeOfSourceAliquotForMsg exists into ATiM for the participant. No data of the line will be migrated. Please confirm. (worksheet : $worksheetName)";
                recordErrorAndMessage($worksheetName .' :: ' .
                    'Aliquot Source Definition',
                    '@@ERROR@@',
                    $errorTitle,
                    "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter."." [Validation Message #".__LINE__."]");
                addUnmigratedLine($excelLineData, $worksheetName, $excelLineCounter, $errorTitle);
                return null;
            } else {
                // Try to match atim aliquot label with code of ATiM
                $selectedAliquotKey = '';
                $excelAliquotName = isset($excelLineData['Aliquot Name'])? $excelLineData['Aliquot Name'] : '';
                if(array_key_exists($bfcSpecialKey, $aliquotSources)) {
                    $selectedAliquotKey = $bfcSpecialKey;
                } else if($excelAliquotName && array_key_exists($excelAliquotName, $aliquotSources)) {
                    $selectedAliquotKey = $excelAliquotName;
                } else if($excelParticipantBankNbr && array_key_exists($excelParticipantBankNbr, $aliquotSources)) {
                    $selectedAliquotKey = $excelParticipantBankNbr;
                } else if($parentAliquotAtimControl == $atim_controls['aliquot_controls']['tissue-block'] && array_key_exists('FFPE '.$excelParticipantBankNbr, $aliquotSources)) {
                    $selectedAliquotKey = 'FFPE '.$excelParticipantBankNbr;
                } else if($parentAliquotAtimControl == $atim_controls['aliquot_controls']['tissue-block'] && array_key_exists('FFPE '.$excelParticipantAtimNbr, $aliquotSources)) {
                    $selectedAliquotKey = 'FFPE '.$excelParticipantAtimNbr;
                } else if($parentAliquotAtimControl == $atim_controls['aliquot_controls']['blood cell-tube'] && array_key_exists('BC '.$excelParticipantBankNbr, $aliquotSources)) {
                    $selectedAliquotKey = 'BC '.$excelParticipantBankNbr;
                } else if($parentAliquotAtimControl == $atim_controls['aliquot_controls']['blood cell-tube'] && array_key_exists('BC '.$excelParticipantAtimNbr, $aliquotSources)) {
                    $selectedAliquotKey = 'BC '.$excelParticipantAtimNbr;
                } else {
                    $tmpAllAliquotLabels = array_keys($aliquotSources);
                    if(sizeof($tmpAllAliquotLabels) != 1) {
                        $fieldNameForPattern = isset($excelLineData['Aliquot Name'])? 'Aliquot Name' : (isset($excelLineData['Sample label'])? 'Sample label' : (isset($excelLineData['sample label'])? 'sample label' : ''));
                        $pattern = '';
                        if(isset($fieldNameForPattern) && preg_match('/((([A-Z][0-9]{1,2})\-[0-9])|([A-Z][0-9]{1,2})|(\ ([0-9]{1,2})\-[0-9]{1,2}))$/', $excelLineData[$fieldNameForPattern], $matches)) {
                            $pattern = isset($matches[6])? $matches[6] : (isset($matches[4])? $matches[4] : (isset($matches[3])? $matches[3] : ''));   
                        }
                        if($pattern) {
                            $pattern = '[\-]'.$pattern;
                            if(preg_match('/^[A-Z]/', $pattern)) $pattern = '[\-\ ]'.$pattern;
                            $selectedAliquotKey = array();
                            foreach($tmpAllAliquotLabels as $labelTotest) {
                                if(preg_match('/'.$pattern.'$/', $labelTotest)) {
                                    $selectedAliquotKey[] = $labelTotest;
                                }
                            }
                            if(sizeof($selectedAliquotKey) == 1) {
                                $selectedAliquotKey = $selectedAliquotKey[0];
                                $warningMessage = "More than one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant but one ATiM aliquot label matches approximatively the Excel aliquot information. Data of the line will be migrated and linked to this $typeOfSourceAliquotForMsg but please validate."." [Validation Message #".__LINE__."]";
                                $warningDetail = "See ATiM aliquot label [$selectedAliquotKey] and Excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                                recordErrorAndMessage($worksheetName .' :: ' .
                                    'Aliquot Source Definition',
                                    '@@WARNING@@',
                                    $warningMessage,
                                    "See migrated line to validate below.",
                                    "See migrated line to validate below.");
                                addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                            } elseif(sizeof($selectedAliquotKey)) {
                                $warningMessage = "More than one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant and the aliquot labels of more than one ATiM aliquot match approximatively the Excel aliquot information. Data of the line will be migrated and linked to the first one $typeOfSourceAliquotForMsg matching excel information but please validate."." [Validation Message #".__LINE__."]";
                                $warningDetail = "See ATiM aliquot label [". implode(' & ', $selectedAliquotKey)."] and Excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                                recordErrorAndMessage($worksheetName .' :: ' .
                                    'Aliquot Source Definition',
                                    '@@WARNING@@',
                                    $warningMessage,
                                    "See migrated line to validate below.",
                                    "See migrated line to validate below.");
                                addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                                $selectedAliquotKey = $selectedAliquotKey[0];
                            } else {
                                $selectedAliquotKey = '';
                            }
                        }
                    } else {
                        $selectedAliquotKey = $tmpAllAliquotLabels[0];
                        $warningMessage = "Only one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant but the ATiM aliquot label does not match the Excel aliquot information. Data of the line will be migrated and linked to this $typeOfSourceAliquotForMsg but please validate."." [Validation Message #".__LINE__."]";
                        $warningDetail = "See ATiM aliquot label [$selectedAliquotKey] and Excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Aliquot Source Definition',
                            '@@WARNING@@',
                            $warningMessage,
                            "See migrated line to validate below.",
                            "See migrated line to validate below.");
                        addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                    }
                }
                if($selectedAliquotKey) {
                    $selectedAtimAliquotSource = null;
                    if(!isset($aliquotSources[$selectedAliquotKey])) {
                        die("ERR823798273927");
                    } else if(sizeof($aliquotSources[$selectedAliquotKey]) > 1) {
                        $warningMessage = "More than one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant and match the ATiM aliquot label . Data of the line will be migrated and linked to the first $typeOfSourceAliquotForMsg but please validate."." [Validation Message #".__LINE__."]";
                        $warningDetail = "See ATiM aliquot label [$selectedAliquotKey] and Excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Aliquot Source Definition',
                            '@@WARNING@@',
                            $warningMessage,
                            "See migrated line to validate below.",
                            "See migrated line to validate below.");
                        addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                        return $aliquotSources[$selectedAliquotKey][0];
                    } else {
                        return $aliquotSources[$selectedAliquotKey][0];
                    }
                } else {
                    $collectiondIdToLink = array();
                    $sampleMasterIdToLink = array();
                    $newSource = null;
                    foreach($aliquotSources as $newSources) {
                        foreach($newSources as $newSource) {
                            $collectiondIdToLink[$newSource['collection_id']] = $newSource['collection_id'] ;
                            $sampleMasterIdToLink[$newSource['sample_master_id']] = $newSource['sample_master_id'] ;
                        }
                    }
                    $collectiondIdToLink = sizeof($collectiondIdToLink) == 1? array_shift($collectiondIdToLink) : '';
                    $sampleMasterIdToLink = sizeof($sampleMasterIdToLink) == 1? array_shift($sampleMasterIdToLink) : '';
                    $warningTitle = "System is not able to define the ATiM $typeOfSourceAliquotForMsg source (from those of the participant) used for the extraction. A new collection, tissue and block (with in stock no) will be created then linked to the extraction. Please confirm. (worksheet : $worksheetName)";
                    if($sampleMasterIdToLink) {
                        $warningTitle = str_replace('collection, tissue and ', '', $warningTitle);
                    } elseif($collectiondIdToLink) {
                        $warningTitle = str_replace('collection, tissue and ', 'tissue and ', $warningTitle);
                    }
                    if(!$collectiondIdToLink) {
                        $createdRecordsCounter['collections created']++;
                        $collectiondIdToLink = customInsertRecord(array(
                            'collections' => array(
                                'participant_id' => $participantId,
                                'collection_property' => 'participant collection',
                                'collection_notes'=>'Created by script to track DNA/RNA blood from excel on '.substr($import_date, 0,10) .'.')));
                    }
                    if(!$sampleMasterIdToLink) {
                        $createdRecordsCounter['tissue samples created']++;
                        $sample_data = array(
                            'sample_masters' => array(
                                "sample_code" => 'tmp_blood_for_'.$createdRecordsCounter['tissue samples created'],
                                "sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
                                "initial_specimen_sample_type" => 'tissue',
                                "collection_id" => $collectiondIdToLink),
                            'specimen_details' => array(),
                            $atim_controls['sample_controls']['tissue']['detail_tablename'] => array());
                        $sampleMasterIdToLink = customInsertRecord($sample_data);
                    }   
                    $detail_data = array();
                    $controltype = 'tissue-tube';
                    $counterKey = '';
                    switch($typeOfSourceAliquotForMsg) {
                        case 'FFPE block':
                            $detail_data = array('block_type' => 'paraffin');
                            $controltype = 'tissue-block';
                            $counterKey = 'FFPE blocks created';
                            break;
                        case 'OCT block':
                            $detail_data = array('block_type' => 'OCT');
                            $controltype = 'tissue-block';
                            $counterKey = 'OCT blocks created';
                            break;
                        case 'Tissue Tube':
                            $detail_data = array('qc_tf_storage_solution' => 'OCT');
                            $controltype = 'tissue-tube';
                            $counterKey = 'tissue tubes created';
                            break;
                        default:
                            die('ERRR8482872897329 '.$typeOfSourceAliquotForMsg);
                    }
                    $createdRecordsCounter[$counterKey]++;
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => 'tmp_core_'.$createdRecordsCounter[$counterKey],
                            'aliquot_label' => 'Created by DNA/RNA migration script',
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$controltype]['id'],
                            "collection_id" => $collectiondIdToLink,
                            "sample_master_id" => $sampleMasterIdToLink,
                            'in_stock' => 'no',
                            'notes' => 'Created by script to track Tissue DNA/RNA from excel on '.substr($import_date, 0,10) ." (Worksheet '.$worksheetName' line '$excelLineCounter')."),
                        $atim_controls['aliquot_controls'][$controltype]['detail_tablename'] => $detail_data);
                    $aliquotMasterId = customInsertRecord($aliquot_data);
                    $aliquotSources = array_keys($aliquotSources);
                    $aliquotSources = implode ('</b> & <b>', $aliquotSources);
                    $warningMessage = $warningTitle." [Validation Message #".__LINE__."]";
                    $warningDetail = "See ATiM $typeOfSourceAliquotForMsg aliquot(s) [<b>$aliquotSources</b>] and excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Aliquot Source Definition',
                        '@@WARNING@@',
                        $warningMessage,
                        "See migrated line to validate below.",
                        "See migrated line to validate below.");
                    addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);                    
                    return array(
                        'barcode' => '',
                        'aliquot_label' => '',
                        'block_type' => '',
                        'qc_tf_storage_solution' => '',
                        'participant_id' => $participantId,
                        'collection_id' => $collectiondIdToLink,
                        'sample_master_id' => $sampleMasterIdToLink,
                        'aliquot_master_id' => $aliquotMasterId,
                        'initial_specimen_sample_id' => $sampleMasterIdToLink,
                        'initial_specimen_sample_type' => 'tissue',
                        'sample_type' => 'tissue');
                }
            }
        }
    }
    die('ERR 467383390');
}

function addUnmigratedLine($excelLineData, $worksheetName, $excelLineCounter, $error) {
    global $unmigratedData;
    $unmigratedData[$worksheetName][] = array_merge(
        array(
            'Line' => $excelLineCounter, 
            'Validation Message #' => (preg_match('/\[Validation Message\ #([0-9]+)\]/', $error, $matches)? $matches[1] : 'Unk'), 
            'Error' => $error), 
        $excelLineData);
}

function addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warning, $warning_detail = '') {
    global $migratedDataToValidate;
    
    $migratedDataToValidate[$worksheetName][] = array_merge(
        array(
            'Line' => $excelLineCounter, 
            'Validation Message #' => (preg_match('/\[Validation Message\ #([0-9]+)\]/', $warning, $matches)? $matches[1] : 'Unk'), 
            'Warning' => $warning, 
            'Warning Details' => str_replace(array('<b>' ,'</b>'), array('', ''), $warning_detail)), 
        $excelLineData);
}

function addAliquotSourceQuantityUsed($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot, $sample_type, $extraction_aliquot_label, $creation_datetime, $creation_datetime_accuracy, $typeOfSourceUsed) {
    global $createdRecordsCounter;
    global $allAliquotSourceQuantityUsedControl;
    
    if($atimSourceAliquot) {
        foreach(array('qte source used (n=cores)', 'quantity source used for extraction', 'qty source used', 'qty source used') as $xls_field) {
            if(isset($excelLineData[$xls_field]) && strtolower($excelLineData[$xls_field]) != 'unknown') {
                if($atimSourceAliquot['aliquot_master_id']) {
                    $use_code = $excelLineData[$xls_field] . 
                        (($xls_field == 'qte source used (n=cores)' || $typeOfSourceUsed == 'core')? ' cores': ($typeOfSourceUsed == 'slide'? ' slides' : '')) .
                        " for".(strlen($extraction_aliquot_label)? " '$extraction_aliquot_label'" : '')." " . strtoupper($sample_type) . " extraction.";
                    if(strlen($use_code)) {
                        $keyForControl = $atimSourceAliquot['aliquot_master_id'].'||'.$use_code.'||'.$creation_datetime.'||'.$creation_datetime_accuracy;
                        if(!isset($allAliquotSourceQuantityUsedControl[$keyForControl])) {
                            $createdRecordsCounter['quantity source used for extraction']++;
                            $aliquot_internal_use_data = array(
                                'aliquot_internal_uses' => array(
                                    'aliquot_master_id' => $atimSourceAliquot['aliquot_master_id'],
                                    'type' => 'quantity source used',
                                    'use_code' => $use_code));
                            if($creation_datetime) {
                                $aliquot_internal_use_data['aliquot_internal_uses']['use_datetime'] = $creation_datetime;
                                $aliquot_internal_use_data['aliquot_internal_uses']['use_datetime_accuracy'] = $creation_datetime_accuracy;
                            }
                            customInsertRecord($aliquot_internal_use_data); 
                            $allAliquotSourceQuantityUsedControl[$keyForControl] = 'Done';
                        }
                    }
                } else {
                    die('ERR23872372987238237');
                }
            }
        }
    }
}

function addHAndE($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot, $excelSourceType) {
    global $atim_controls ;
    global $createdRecordsCounter;
    global $import_date;
    global $dnaRnaExtractions;
    global $allStorages;
    
    if($atimSourceAliquot) {
        if(isset($excelLineData['H&E']) && strlen($excelLineData['H&E'])) {
            if($excelSourceType != 'Tissue block') die('ERR4345345345 '.$excelSourceType);
            $desciption =  $excelLineData['H&E'];
            $storage =  '[box]||['.$excelLineData['H&E Boite'].']';
            $position =  $excelLineData['H&E position'];            
            if(!isset($allStorages[$storage])) { die('ERR4345345345');}
            $controltype = 'tissue-slide';
            $counterKey = 'tissue slides created';
            $createdRecordsCounter[$counterKey]++;
            $aliquot_data = array(
                'aliquot_masters' => array(
                    "barcode" => 'tmp_core_'.$createdRecordsCounter[$counterKey],
                    'aliquot_label' => "H&E [TFRI#".$atimSourceAliquot['participant_id']."]",
                    "aliquot_control_id" => $atim_controls['aliquot_controls'][$controltype]['id'],
                    "collection_id" => $atimSourceAliquot['collection_id'],
                    "sample_master_id" => $atimSourceAliquot['sample_master_id'],
                    "storage_master_id" => $allStorages[$storage]['storage_master_id'],
                    'in_stock' => 'yes & available',
                    'notes' => $desciption.'. Created by script to track Tissue DNA/RNA from excel on '.substr($import_date, 0,10) ." (Worksheet '.$worksheetName' line '$excelLineCounter')."),
                $atim_controls['aliquot_controls'][$controltype]['detail_tablename'] => array(
                    'immunochemistry' => 'H&E'
                ));
                $child_aliquot_master_id = customInsertRecord($aliquot_data);
            $realiquoting_data = array('realiquotings' => array(
                'parent_aliquot_master_id' => $atimSourceAliquot['aliquot_master_id'],
                'child_aliquot_master_id' => $child_aliquot_master_id));
            customInsertRecord($realiquoting_data);
        }
    }
}

function createExtraction($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot, $excelSourceType) {
    global $atim_controls ;
    global $createdRecordsCounter;
    global $import_date;
    global $dnaRnaExtractions;
    
    if($atimSourceAliquot) {
        $sample_type = str_replace(array('RNA FFPE', 'RNA FT', 'DNA FFPE tissues', 'DNA Normal', 'DNA FT'),
            array('rna', 'rna', 'dna', 'dna', 'dna'),
            $worksheetName);
        if(!in_array($sample_type, array('dna', 'rna'))) die('ERR7478377987934');
        
        $extraction_aliquot_label = array();
        foreach(array('Sample label', 'Aliquot Name', 'sample label', 'Sample FT source', 'Other name 2') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $extraction_aliquot_label[$excelLineData[$xls_field]] = $excelLineData[$xls_field];
            }
        }
        $extraction_aliquot_label = implode(' ', $extraction_aliquot_label);
        
        // Create extraction sample
        
        $derivative_details = array();
        $typeOfSourceUsed = '';
        foreach(array("Date d'extraction","Extraction date", "extraction date") as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                if(preg_match('/^(20[0-9]{2})-00-00$/', $excelLineData[$xls_field], $matches)) {
                    $derivative_details['creation_datetime'] = $matches[1].'-01-01';
                    $derivative_details['creation_datetime_accuracy'] = 'm';
                } else {
                    list($creationDate, $creationDateACc) = validateAndGetDateAndAccuracy($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    if($creationDateACc == 'c') $creationDateACc = 'h';
                    if($creationDate) {
                        $derivative_details['creation_datetime'] = $creationDate;
                        $derivative_details['creation_datetime_accuracy'] = $creationDateACc;
                    }
                } 
            }
        }
        foreach(array("Extraction done by","extracted by", "Extrated by:") as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $arr1 = array('Nat + Lise', 'Liliane-Cecile', 'Doris', 'V. Barres', 'Cecile LP', 'Liliane Meunier');
                $arr2 = array('lise chum', 'Cecile', 'doris', 'Véronique', 'Cecile', 'Liliane');
                $excelLineData[$xls_field] = str_replace($arr1, $arr2, $excelLineData[$xls_field]);
                if($excelLineData[$xls_field] == 'Lise')$excelLineData[$xls_field] = 'lise chum';
                $derivative_details['creation_by'] = validateAndGetStructureDomainValue($excelLineData[$xls_field], 'custom_laboratory_staff', $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
            }
        }
        $sample_details = array();
        foreach(array("Extraction Methode", "Extraction Method") as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                if(preg_match('/^All prep DNA-RNA-FFPE/', $excelLineData[$xls_field])) {
                    $excelLineData[$xls_field] = 'All prep DNA-RNA-FFPE';
                }
                $arr1 = array();
                $arr2 = array();
                $excelLineData[$xls_field] = str_replace($arr1, $arr2, $excelLineData[$xls_field]);
                $sample_details['qc_tf_extraction_method'] = validateAndGetStructureDomainValue($excelLineData[$xls_field], 'qc_tf_dna_rna_extraction_methods', $worksheetName .' :: ' .'Extraction creation', "See excel field 'Extraction Method'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
            }
        }
        foreach(array("deparafinationMethod", "deparafinization Method") as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $excelLineData[$xls_field] = strtolower($excelLineData[$xls_field]);
                if(preg_match('/^(.*)xyl.{1,2}ne(.*)$/', $excelLineData[$xls_field], $matches)) {
                    $excelLineData[$xls_field] = (isset($matches[1])? $matches[1] : '').'xylene'.(isset($matches[2])? $matches[2] : '');
                }
                $arr1 = array();
                $arr2 = array();
                $excelLineData[$xls_field] = str_replace($arr1, $arr2, $excelLineData[$xls_field]);
                $sample_details['qc_tf_deparafinization_method'] = validateAndGetStructureDomainValue($excelLineData[$xls_field], 'qc_tf_deparafinization_methods', $worksheetName .' :: ' .'Extraction creation', "See excel field 'deparafinization Method'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
            }
        }
        $sampleKey = 
            $sample_type .
            $atimSourceAliquot['collection_id'] . '##' .
            $atimSourceAliquot['initial_specimen_sample_id'] . '##' .
            $atimSourceAliquot['sample_master_id'] . '##' .
            $atimSourceAliquot['aliquot_master_id'] . '##' .
            $excelSourceType;
        foreach($derivative_details as $tmValue) $sampleKey .= $tmValue;
        foreach($sample_details as $tmValue) $sampleKey .= $tmValue;
        $extraction_sample_master_id = null;
        if(isset($dnaRnaExtractions[$sampleKey])) {
            $extraction_sample_master_id = $dnaRnaExtractions[$sampleKey]['sample_masters']['id'];
            $sample_data = $dnaRnaExtractions[$sampleKey];
        } else {
            $createdRecordsCounter[$sample_type.' samples created']++;
            $sample_data = array(
                'sample_masters' => array(
                    "sample_code" => 'tmp_'.$sample_type.'_for_'.$createdRecordsCounter[$sample_type.' samples created'],
                    "sample_control_id" => $atim_controls['sample_controls'][$sample_type]['id'],
                    "initial_specimen_sample_id" => $atimSourceAliquot['initial_specimen_sample_id'],
                    "initial_specimen_sample_type" => $atimSourceAliquot['initial_specimen_sample_type'],
                    "collection_id" => $atimSourceAliquot['collection_id'],
                    "parent_id" => $atimSourceAliquot['sample_master_id'],
                    "parent_sample_type" => $atimSourceAliquot['sample_type']),
                'derivative_details' => $derivative_details,
                $atim_controls['sample_controls'][$sample_type]['detail_tablename'] => $sample_details);
            $extraction_sample_master_id = customInsertRecord($sample_data);
            // Define aliquot source            
            $source_aliquot_master_id = $atimSourceAliquot['aliquot_master_id'];
            if($atimSourceAliquot && $excelSourceType && $atimSourceAliquot['initial_specimen_sample_type'] == 'tissue' && $atimSourceAliquot['sample_master_id'] == $atimSourceAliquot['initial_specimen_sample_id']) {
                $controltype = '';
                $counterKey = '';
                switch($excelSourceType) {
                    case 'FFPE-core-tumor':
                        $controltype = 'tissue-core';
                        $counterKey = 'tissue cores created';
                        $typeOfSourceUsed = 'core';
                        break;
                    case 'FFPE-slide-tumor':
                    case 'FFPE-tumor':
                        $controltype = 'tissue-slide';
                        $counterKey = 'tissue slides created';
                        $typeOfSourceUsed = 'slide';
                        break;
                }
                if($controltype) {
                    $createdRecordsCounter[$counterKey]++;
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => 'tmp_core_'.$createdRecordsCounter[$counterKey],
                            'aliquot_label' => $extraction_aliquot_label,
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$controltype]['id'],
                            "collection_id" => $atimSourceAliquot['collection_id'],
                            "sample_master_id" => $atimSourceAliquot['sample_master_id'],
                            'in_stock' => 'no',
                            'notes' => 'Created by script to track Tissue DNA/RNA from excel on '.substr($import_date, 0,10) ." (Worksheet '.$worksheetName' line '$excelLineCounter')."),
                        $atim_controls['aliquot_controls'][$controltype]['detail_tablename'] => array());
                    $source_aliquot_master_id = customInsertRecord($aliquot_data);
                    $realiquoting_data = array('realiquotings' => array(
                        'parent_aliquot_master_id' => $atimSourceAliquot['aliquot_master_id'],
                        'child_aliquot_master_id' => $source_aliquot_master_id));
                    if(isset($derivative_details['creation_datetime'])) {
                        $realiquoting_data['realiquotings']['realiquoting_datetime'] = $derivative_details['creation_datetime'];
                        $realiquoting_data['realiquotings']['realiquoting_datetime_accuracy'] = $derivative_details['creation_datetime_accuracy'];
                    }
                    customInsertRecord($realiquoting_data);
                }
            }          
            if($source_aliquot_master_id) {
                $srce_data = array('source_aliquots' => array(
                    'sample_master_id' => $extraction_sample_master_id,
                    'aliquot_master_id' => $source_aliquot_master_id));
                customInsertRecord($srce_data);
            }
            $sample_data['sample_masters'] = array_merge(array('id' => $extraction_sample_master_id), $sample_data['sample_masters']);
            $dnaRnaExtractions[$sampleKey] = $sample_data;
        }
        
        // Add aliquot quantity used
        
        addAliquotSourceQuantityUsed($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot, $sample_type, $extraction_aliquot_label, (isset($derivative_details['creation_datetime'])? $derivative_details['creation_datetime'] : ''), (isset($derivative_details['creation_datetime_accuracy'])? $derivative_details['creation_datetime_accuracy'] : ''), $typeOfSourceUsed);
        
        // Create extraction aliquot
        
        $xls_field = "Availability";
        $in_stock = '';
        if(isset($excelLineData[$xls_field])) {
            $in_stock = validateAndGetStructureDomainValue(str_replace(array('yes'), array('yes - available'), $excelLineData[$xls_field]), 'aliquot_in_stock_values', $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value will be replaced by 'yes - available'. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
        }
        if(!$in_stock) $in_stock = 'yes - available';
        $aliquot_notes = array('Created by script to track DNA/RNA blood from excel on '.substr($import_date, 0,10) ." (Worksheet '.$worksheetName' line '$excelLineCounter').");
        foreach(array('Notes 1', 'Notes 2', 'Notes') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
            }
        }
        $qc_tf_storage_solution = array();
        foreach(array('storage medium', 'RNA storage medium', 'Storage medium', 'Buffer') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                if(preg_match('/^ATE/', $excelLineData[$xls_field])) {
                    $qc_tf_storage_solution[] = 'ATE';
                    $aliquot_notes[] = $xls_field . " : " . $excelLineData[$xls_field];
                } else {
                    $qc_tf_storage_solution[] = $excelLineData[$xls_field];
                }
            }
        }
        $qc_tf_storage_solution = implode(' + ', $qc_tf_storage_solution);
        $qc_tf_storage_solution = validateAndGetStructureDomainValue($qc_tf_storage_solution, 'qc_tf_dna_rna_storage_solutions', $worksheetName .' :: ' .'Extraction creation', "See excel field 'Storage Medium' or 'Buffer'. Value will be replaced by 'yes - available'. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
        $qc_tf_weight_ug_initial = '';
        foreach(array('Initial Quantity (ng)', 'Initial Quantity (ug)', 'Quantity initial (ug)', 'Quantity (ug) initial') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $qc_tf_weight_ug_initial = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                if($qc_tf_weight_ug_initial && $xls_field == 'Initial Quantity (ng)') {
                    $qc_tf_weight_ug_initial = $qc_tf_weight_ug_initial/1000;
                }
                $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
            }
        }
        $xls_field = 'Quantity used';
        if(isset($excelLineData[$xls_field]) && strlen($excelLineData[$xls_field])) {
            $aliquot_notes[] = $xls_field . " : " . $excelLineData[$xls_field];
        }
        $qc_tf_weight_ug = '';
        foreach(array('Quantity Available (ng)', 'Quantity Available (ug)', 'Qte total left (ng)', 'Quantity available') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
                if(preg_match('/^\-[0-9\.\,]+$/', $excelLineData[$xls_field])) {
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Aliquot Storage Definition',
                        '@@WARNING@@',
                        "Aliquot '$xls_field' is lower than 0. Value will be migrated as equal to 0. Please validate. [Validation Message #".__LINE__."]",
                        "See '$xls_field' euqal to '".$excelLineData[$xls_field]." for aliquot defined by $excelSourceAliquotInfoForMsg for participant $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                    $qc_tf_weight_ug = '0';
                } else {
                    $qc_tf_weight_ug = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                }
                if($qc_tf_weight_ug && $xls_field == 'Quantity Available (ng)' && $qc_tf_weight_ug != '0') {
                    $qc_tf_weight_ug = $qc_tf_weight_ug/1000;
                }
            }
        }
        $initial_volume = null;
        foreach(array('Volume uL', 'volume1 initial (ul)', 'volume initial uL') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $initial_volume = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
            }
        }
        $used_volume = null;
        foreach(array('Quantity used (ul)', 'volume used') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $used_volume = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
            }
        }
        $current_volume = null;
        foreach(array('volume1 restant (ul)', 'volume left uL', 'Volume available left') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $current_volume = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
            }
        }
        $volumeForInternalUse = null;
        if($initial_volume && $current_volume) {
            $volumeForInternalUse = $initial_volume - $current_volume;
            $current_volume = null;
        } else if($initial_volume && $used_volume) {
            $volumeForInternalUse = $used_volume;
        } else if($used_volume) {
            $volumeForInternalUse = $used_volume;
        }
        
        $createdRecordsCounter[$sample_type.' tubes created']++;
        $aliquot_data = array(
            'aliquot_masters' => array(
                "barcode" => 'tmp_core_'.$createdRecordsCounter[$sample_type.' tubes created'],
                'aliquot_label' => $extraction_aliquot_label,
                "aliquot_control_id" => $atim_controls['aliquot_controls']["$sample_type-tube"]['id'],
                "collection_id" => $atimSourceAliquot['collection_id'],
                "sample_master_id" => $extraction_sample_master_id,
                'in_stock' => $in_stock,
                'initial_volume' => $initial_volume,
                'current_volume' => ($volumeForInternalUse? ($initial_volume-$volumeForInternalUse) : $initial_volume),
                'notes' => implode(' ', $aliquot_notes)),
            $atim_controls['aliquot_controls']["$sample_type-tube"]['detail_tablename'] => array(
                'qc_tf_storage_solution' => $qc_tf_storage_solution,
                'qc_tf_weight_ug_initial' => $qc_tf_weight_ug_initial,
                'qc_tf_weight_ug' => $qc_tf_weight_ug
            ));
        list($storage_master_id, $storage_coord_x, $storage_coord_y , $newNotes) = getStorageInfo($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg);
        if($newNotes) {
            $aliquot_data['aliquot_masters']['notes'] = "$newNotes. ".$aliquot_data['aliquot_masters']['notes'];
        }
        if($storage_master_id) {
            if($in_stock == 'no' && $storage_master_id) {
                recordErrorAndMessage($worksheetName .' :: ' .
                    'Aliquot Storage Definition',
                    '@@WARNING@@',
                    "Aliquot defined as not in stock but storage information and positions have been defined for the aliquot. Storage information and position won't be migrated. Please validate. [Validation Message #".__LINE__."]",
                    "See position information for aliquot defined by $excelSourceAliquotInfoForMsg for participant $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
            } else {
                $aliquot_data['aliquot_masters']['storage_master_id'] = $storage_master_id;
                if(strlen($storage_coord_x)) $aliquot_data['aliquot_masters']['storage_coord_x'] = $storage_coord_x;
                if(strlen($storage_coord_y)) $aliquot_data['aliquot_masters']['storage_coord_y'] = $storage_coord_y;
            }
        }
        $aliquotMasterId = customInsertRecord($aliquot_data);  
        if(strlen($volumeForInternalUse) && $volumeForInternalUse != '0') {
            $createdRecordsCounter['DNA/RNA used']++;
            customInsertRecord(array(
                'aliquot_internal_uses' => array(
                    'aliquot_master_id' => $aliquotMasterId,
                    'type' => 'internal use',
                    'used_volume' => $volumeForInternalUse,
                    'use_code' => 'Extraction used (based on XLS file)')));
        }
        return array('sample_masters' => $sample_data['sample_masters'], 'aliquot_masters' => array_merge(array('id' => $aliquotMasterId), $aliquot_data['aliquot_masters']));
    }
    return null;
}

function getExistingStorage() {
    global $allStorages;
    $query = "select storage_masters.id as storage_master_id, parent_id, short_label, selection_label, storage_type 
        FROM storage_masters 
        LEFT JOIN storage_controls ON storage_controls.id = storage_control_id 
        WHERE flag_active = 1 AND storage_masters.deleted <> 1 AND parent_id IS NULL";
    foreach(getSelectQueryResult($query) as $newStorage) {
        $allStorages[$newStorage['storage_master_id']] = array_merge($newStorage, array('script_selection_label' => '['.$newStorage['storage_type'].']||['.$newStorage['short_label'].']'));
    }
    getExistingSubStorage(array_keys($allStorages));
    $tmpAllStorages = array();
    foreach($allStorages as $tmp) {
        if(array_key_exists($tmp['script_selection_label'], $tmpAllStorages)) die('ERR 23 2345t3452');
        $tmpAllStorages[$tmp['script_selection_label']] = $tmp;
    }
    $allStorages=$tmpAllStorages;
}

function getExistingSubStorage($parent_ids) {
    global $allStorages;
    if(!$parent_ids) return;
    $query = "select storage_masters.id as storage_master_id, parent_id, short_label, selection_label, storage_type
        FROM storage_masters
        LEFT JOIN storage_controls ON storage_controls.id = storage_control_id
        WHERE flag_active = 1 AND storage_masters.deleted <> 1 AND parent_id IN (".implode(',',$parent_ids).")";
    $newparentids = array();
    foreach(getSelectQueryResult($query) as $newStorage) {
        $newparentids[] = $newStorage['storage_master_id'];
        if(!isset($allStorages[$newStorage['parent_id']])) die('ERR8489393848');
        $allStorages[$newStorage['storage_master_id']] = array_merge($newStorage, array('script_selection_label' => $allStorages[$newStorage['parent_id']]['script_selection_label'].'--'.'['.$newStorage['storage_type'].']||['.$newStorage['short_label'].']'));
    }
    getExistingSubStorage($newparentids);
}

function getStorageInfo($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg) {
    global $atim_controls ;
    global $allStorages;
    global $createdRecordsCounter;
    global $dnaRnaExtractions;
    global $import_date;

    $storageDataFromExcel = array();
    $selection_label = '';
    $script_selection_label = '';
    $parent_id = null;
    $xlsFieldProperties = array(
        'freezer' => array('Storage	Freezer' ,'Frigo' ,'Fridge' ,'Freezer'),
        'shelf' => array('Shelve' ,'Self'),
        'rack16' => array('Rack'),
        'box81 1A-9I' => array('Box' ,'Box' ,' BoiteID' ,'Box' ,'Box')
    );
    foreach($xlsFieldProperties as $xlsFieldKey => $xlsFields) {
        $storageDataFromExcel[$xlsFieldKey] = '';
        foreach($xlsFields as $newField) {
            if(isset($excelLineData[$newField]) && strlen($excelLineData[$newField])) {
                $storageDataFromExcel[$xlsFieldKey] = $excelLineData[$newField];
            }
        }
        if(strlen($storageDataFromExcel[$xlsFieldKey])) {
            if($xlsFieldKey == 'box81 1A-9I' && in_array($storageDataFromExcel[$xlsFieldKey], array('ADN-11', 'ADN-12', 'ADN-13'))) {
                $previousXlsFieldKey = $xlsFieldKey;
                $xlsFieldKey = 'box81';
                $storageDataFromExcel[$xlsFieldKey] = $storageDataFromExcel[$previousXlsFieldKey];
                unset($storageDataFromExcel[$previousXlsFieldKey]);
            }
            $script_selection_label .= (strlen($script_selection_label)? '--' : '') . '['.$xlsFieldKey.']||['.$storageDataFromExcel[$xlsFieldKey].']';
            $selection_label .= (strlen($selection_label)? '-' : '') . $storageDataFromExcel[$xlsFieldKey];
            if(isset($allStorages[$script_selection_label])) {
                $parent_id =$allStorages[$script_selection_label]['storage_master_id'];
            } else {
                $createdRecordsCounter[$xlsFieldKey."s created"]++;
                $storage_data = array(
                    'storage_masters' => array(
                        "code" => 'tmp_'.$xlsFieldKey.'_'.$createdRecordsCounter[$xlsFieldKey."s created"],
                        "short_label" => $storageDataFromExcel[$xlsFieldKey],
                        "selection_label" => $selection_label,
                        "storage_control_id" => $atim_controls['storage_controls'][$xlsFieldKey]['id'],
                        "parent_id" => $parent_id,
                        'notes' => 'Created by script to track DNA/RNA extraction from excel on '.substr($import_date, 0,10) .'.'),
                    $atim_controls['storage_controls'][$xlsFieldKey]['detail_tablename'] => array());
                $parent_id = customInsertRecord($storage_data);
                $storage_data = $storage_data['storage_masters'];
                $storage_data['storage_master_id'] = $parent_id;
                $storage_data['storage_type'] = $xlsFieldKey;
                $storage_data['script_selection_label'] = $script_selection_label;
                $allStorages[$script_selection_label] = $storage_data;
            }   
        }
    }
    $xlsFieldProperties = array(
        'x' => array('Lane' ,'ligne' ,'Position #'),
        'y' => array('Column' ,'Colonne' ,'Position letter')
    );
    foreach($xlsFieldProperties as $xlsFieldKey => $xlsFields) {
        $storageDataFromExcel[$xlsFieldKey] = '';
        foreach($xlsFields as $newField) {
            if(isset($excelLineData[$newField]) && strlen($excelLineData[$newField])) {
                $storageDataFromExcel[$xlsFieldKey] = $excelLineData[$newField];
            }
        }
    }
    $xlsFieldProperties = array(
        'Temperature' => array('Temperature' ,'Temperature (2018-present)','Temperature (2014-2018)','temperature (2010-2014)')
    );
    foreach($xlsFieldProperties as $xlsFieldKey => $xlsFields) {
        $temperatures = array();
        foreach($xlsFields as $newField) {
            if(isset($excelLineData[$newField]) && strlen($excelLineData[$newField])) {
                $temperatures[] = "$newField : ".$excelLineData[$newField] .'.';
            }
        }
        $storageDataFromExcel[$xlsFieldKey] = implode(' ', $temperatures);
    }
    if($parent_id || $script_selection_label) {
        if($parent_id != $allStorages[$script_selection_label]['storage_master_id']) die('ERR23829872397');
        $tmpStorageOfTheAliquot = $allStorages[$script_selection_label];
        $x = null;$y = null;
        if(strlen($storageDataFromExcel['x'].$storageDataFromExcel['y'])) {
            if($tmpStorageOfTheAliquot['storage_type'] == 'box81 1A-9I') {
                if(!preg_match('/^[1-9]$/', $storageDataFromExcel['x']) || !preg_match('/^[A-I]$/', $storageDataFromExcel['y'])) {
                    $errorTitle = "Script is not able to defined the type of the aliquot used for the extraction based on the worksheet name because the source type value is not defined. ($worksheetName)";
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Aliquot Storage Definition',
                        '@@WARNING@@',
                        "Wrong position definition for a 'box81 1A-9I'. Position won't be migrated. Please validate. [Validation Message #".__LINE__."]",
                        "See position x=".$storageDataFromExcel['x']."/y=".$storageDataFromExcel['x']." for a aliquot defined by $excelSourceAliquotInfoForMsg for participant $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                    $storageDataFromExcel['x'] = '';
                    $storageDataFromExcel['y'] = '';
                }
                $x = $storageDataFromExcel['x'];
                $y = $storageDataFromExcel['y'];
            } elseif($tmpStorageOfTheAliquot['storage_type'] == 'box81') {
                if(!preg_match('/^(([1-9])|([1-8][0-9])|(81))$/', $storageDataFromExcel['x'])) {
                    die('ERR2-3244644333655623 3');
                }
                if(!preg_match('/^$/', $storageDataFromExcel['y'])) {
                    die('ERR2-7546657772345773623 4');
                }
                $x = $storageDataFromExcel['x'];
                $y = '';
            } else {
                die('ERR2-326444784644623 5');
            }
        }
        return array($parent_id, $x, $y, $storageDataFromExcel['Temperature']);
    } else if(strlen(trim($storageDataFromExcel['x'].$storageDataFromExcel['y']))) {
        die('ERR2-326387263544487623 6');
    }
    return array(null, null, null, null);

}

function duplciatedDnaRnaAnalysis() {
    global $import_date;
    
    $query = "SELECT Res2.participant_id, Res2.sample_type, collection_datetime, creation_datetime, sample_masters.created
        FROM (
          SELECT participant_id, sample_type, count(*) as nbr
          FROM (
            SELECT DISTINCT participant_id, sample_type, sample_masters.created
            FROM sample_masters INNER JOIN sample_controls ON sample_control_id = sample_controls.id AND sample_type IN ('dna', 'rna')
            INNER JOIN derivative_details ON sample_master_id  = sample_masters.id
            INNER JOIN collections ON collections.id = collection_id
            WHERE sample_masters.deleted <> 1 AND initial_specimen_sample_type = 'blood'
          ) Res1 GROUP BY participant_id, sample_type
        ) Res2
        INNER JOIN collections ON collections.participant_id = Res2.participant_id AND collections.deleted <> 1
        INNER JOIN sample_masters ON collections.id = collection_id AND sample_masters.deleted <> 1 AND initial_specimen_sample_type = 'blood'
        INNER JOIN sample_controls ON sample_control_id = sample_controls.id AND sample_controls.sample_type = Res2.sample_type
        INNER JOIN derivative_details ON sample_master_id  = sample_masters.id
        WHERE Res2.nbr > 1
        ORDER BY Res2.participant_id, Res2.sample_type, collection_datetime, creation_datetime, sample_masters.created; ";
    $participantId = null;
    $participantDnaRnaData= array();
    foreach(getSelectQueryResult($query) as $newRecord) {
        if(is_null($participantId)) {
            $participantId = $newRecord['participant_id'];
        }
        if($participantId != $newRecord['participant_id']) {
            foreach($participantDnaRnaData as $sampleType => $sampleTypeData) {
                $allCreatedDate = array_keys($sampleTypeData);
                if(in_array($import_date, $allCreatedDate)) {
                    recordErrorAndMessage(
                        'DNA/RNA Validation',
                        '@@WARNING@@',
                        "A new blood $sampleType extraction has been created by the script but at least another one has been created in the past into ATiM. Please validate these extractions are not the same.",
                        "See blood $sampleType extraction for participant ATiM # ".$sampleTypeData[$import_date]['participant_id'].".");
                }
            }
            $participantDnaRnaData = array();
        }
        $participantId = $newRecord['participant_id'];
        $participantDnaRnaData[$newRecord['sample_type']][$newRecord['created']] = $newRecord;
    }
}

function addQualityControls($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $extractionSampleAliquotData) {
    global $createdRecordsCounter; 
    global $import_date;
    
    if($extractionSampleAliquotData) {   
        $allQc = array();
        $allConc = array();
        // Initial concentration
        $xls_field = 'original concentration (ug/ul)';
        if(isset($excelLineData[$xls_field])) {
            $qcVal = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Quality Control', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
            if($qcVal) {
                $allQc[] = array(
                    'notes' => 'Original concentration',
                    'qc_tf_concentration' => $qcVal,
                    'qc_tf_concentration_unit' => 'ug/ul'
                );
                $allConc[] = array($qcVal, 'ug/ul');
            }
        }
        // PCR
        $pcr_notes = isset($excelLineData['PCR quality note'])? $excelLineData['PCR quality note'] : '';
        $pcr_score = isset($excelLineData['QA-PCR'])? $excelLineData['QA-PCR']: '';
        if(strlen($pcr_notes) && !strlen($pcr_score)) {
            $pcr_score = $pcr_notes;
            $pcr_notes = '';
        }
        $pcr_notes = (isset($excelLineData['PCR #']) && strlen($excelLineData['PCR #']))? ((strlen($pcr_notes)? $pcr_notes.'. PCR #' : 'PCR #').$excelLineData['PCR #']) : $pcr_notes;
        if(strlen($pcr_notes.$pcr_score)) {
            $allQc[] = array(
                'type' => 'pcr',
                'score' => $pcr_score,
                'notes' => $pcr_notes
            );
        }
        //picogreen / Nanodrop / qbit
        $loopData = array(
            'picogreen' => array('concentration (picogreen en ng/ul)' => 'ng/ul'),
            'nanodrop' => array('concentration Nanodrop (ng/ul)' => 'ng/ul', 'Concentration ng/uL NanoDrop' => 'ng/uL', 'Concentration ADN (ng/ml)nanodrop' => 'ng/ml', 'concentration (nanodrop, ug/ul)' => 'ug/ul', 'concentration (nanodrop, ng/ul)' => 'ng/ul)'),
            'qbit' => array(' Concentration ADN (ng/ml)qbit' => 'ng/ml', 'concentration (qbit en ng/ul)' => 'ng/ul')
        );
        foreach($loopData as $type => $allXlsFields) {
            foreach($allXlsFields as $xls_field => $unit) {
                if(isset($excelLineData[$xls_field])) {
                    $qcVal = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Quality Control', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    if($qcVal) {
                        $allQc[] = array(
                            'type' => $type,
                            'qc_tf_concentration' => $qcVal,
                            'qc_tf_concentration_unit' => $unit
                        );
                        $allConc[] = array($qcVal, $unit);
                    }
                }
            }
        }
        //spectrophotometer
        $loopData = array(
            'spectrophotometer' => array('Ratio (260/230)' => '260/230', 'ratio 260/230' => '260/230', 'Ratio (260/280)' => '260/280', 'ratio 260/280' => '260/280')
        );
        foreach($loopData as $type => $allXlsFields) {
            foreach($allXlsFields as $xls_field => $unit) {
                if(isset($excelLineData[$xls_field])) {
                    $qcVal = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Quality Control', "See excel field '$xls_field'. Value will be migrated as is but please validate. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    if(!strlen($qcVal)) {
                        $qcVal = $excelLineData[$xls_field];
                    }
                    $allQc[] = array(
                        'type' => $type,
                        'score' => $qcVal,
                        'unit' => $unit
                    );
                }
            }
        }
        //Bioanlayzer
        $notes = array();
        if(isset($excelLineData['# Bioanalyzer']) && strlen($excelLineData['# Bioanalyzer']))$notes[] = 'Bioanalyzer # '.$excelLineData['# Bioanalyzer'].'.';
        if(isset($excelLineData['RIN-MSKCC']) && strlen($excelLineData['RIN-MSKCC']))$notes[] = 'RIN-MSKCC : '.$excelLineData['RIN-MSKCC'].'.';
        $notes = implode(' ' ,$notes);
        $xls_field = 'RIN';
        $rin = (!isset($excelLineData[$xls_field]))? '' : validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Quality Control', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
        $xls_field = 'Concentration ng/uL (Bioanalyzer)';
        $qcConc = (!isset($excelLineData[$xls_field]))? '' : validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Quality Control', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
        $xls_field = '28s/18s';
        $ratios = (!isset($excelLineData[$xls_field]))? '' : validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Quality Control', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
        if(strlen($qcConc.$rin.$notes.$ratios)) {
            if(strlen($rin)) {
                $allQc[] = array(
                    'type' => 'bioanalyzer',
                    'score' => $rin,
                    'unit' => 'RIN',
                    'notes' => $notes,
                    'qc_tf_concentration' => $qcConc,
                    'qc_tf_concentration_unit' => 'ug/uL'
                );
            } 
            if(strlen($ratios)) {
                $allQc[] = array(
                    'type' => 'bioanalyzer',
                    'score' => $ratios,
                    'unit' => '28/18',
                    'notes' => $notes,
                    'qc_tf_concentration' => $qcConc,
                    'qc_tf_concentration_unit' => 'ug/uL'
                );
            }
            if(!strlen($ratios.$rin)) {
                $allQc[] = array(
                    'type' => 'bioanalyzer',
                    'notes' => $notes,
                    'qc_tf_concentration' => $qcConc,
                    'qc_tf_concentration_unit' => 'ug/uL'
                );
            }
            if($qcConc) {
                $allConc[] = array($qcVal, 'ug/uL');
            }
        }
        if($allQc) {
            foreach($allQc as $new_qc) {
                $new_qc['sample_master_id'] = $extractionSampleAliquotData['sample_masters']['id'];
                $new_qc['aliquot_master_id'] = $extractionSampleAliquotData['aliquot_masters']['id'];
                $new_qc['notes'] = 'Created by script to track Tissue DNA/RNA from excel on '.substr($import_date, 0,10) ." (Worksheet '.$worksheetName' line '$excelLineCounter''). " . (isset($new_qc['notes'])? $new_qc['notes'] : '');
                customInsertRecord(array('quality_ctrls' => $new_qc));
                $createdRecordsCounter['QCs created']++;
            }
        }
        if($extractionSampleAliquotData['aliquot_masters']['id'] && $allConc){
            while($newConc = array_shift($allConc)) {
                if(strlen($newConc[0])) break;
            }
            list($concentration, $concentration_unit) = $newConc;
            if(strlen($concentration)) {
                $query = "UPDATE ad_tubes SET concentration = '$concentration', concentration_unit = '$concentration_unit' WHERE aliquot_master_id = ".$extractionSampleAliquotData['aliquot_masters']['id'];
                customQuery($query);
            }
        }
    }
}

function addOrderAndShipping($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $extractionSampleAliquotData) {
    global $allShippingsToCreate;
    global $atimControls;
    global $allAtimStudies;
    
    if($extractionSampleAliquotData) {
        $loop_data = array(
            'aliquot_concentration' => array('Concentration shipped ug/uL'),
            'aliquot_volume' => array('Volume shipped uL', 'Volume shipped (ul)'),
            'aliquot_weight' => array('quantity shipped', 'quantity shipped (ug)'),
                'aliquot_notes' => array("Dilution (uL d'eau)", "ARN aliquote uL", "Medium dilution", "medium dilution"),
            'shipping_date' => array('shipping date', 'date of shipping'),
            'shipping_contact' => array('Contact person shipping', 'contact shipping'),
            'shipping_project' => array('ProjectID', 'Project#'),
            'shipping_address' => array('address shipping', 'adress shipping', 'Address Shipping'),
            'shipping_tracking_number' => array('Fedex#', 'shipper tracking number', 'Fedex shipping #'),
                'shipping_notes' => array('Shipping courrier'));
        foreach(array('', ' 1', ' 2', ' 3') as $shippping_counter) {
            $shipping_data_to_migrate = array();
            $xls_aliquot_data = array();
            $xls_shipping_data = array();
            foreach($loop_data as $data_field => $xls_fields) {
                foreach($xls_fields as $xls_field) {
                    $xls_field_to_work_on = $xls_field .$shippping_counter;
                    if($worksheetName == 'DNA Normal') {
                        if(preg_match('/^address shipping/', $xls_field_to_work_on)) $xls_field_to_work_on = $xls_field;
                        if(preg_match('/^Address Shipping/', $xls_field_to_work_on)) $xls_field_to_work_on = $xls_field;
                        if(preg_match('/^Shipping courrier/', $xls_field_to_work_on)) $xls_field_to_work_on = $xls_field;
                        if(preg_match('/^Fedex shipping #/', $xls_field_to_work_on)) $xls_field_to_work_on = $xls_field;
                    }
                    if(isset($excelLineData[$xls_field_to_work_on]) && strlen($excelLineData[$xls_field_to_work_on])) {
                        $shipping_data_to_migrate[$data_field][$xls_field] = $excelLineData[$xls_field_to_work_on];
                        if(preg_match('/^aliquot/', $data_field)) {
                            $xls_aliquot_data[] = "$xls_field : " . $excelLineData[$xls_field_to_work_on].'.';
                        } else {
                            $xls_shipping_data[] = "$xls_field : " . $excelLineData[$xls_field_to_work_on].'.';
                        }
                    }
                }
            }
            if($worksheetName == 'DNA Normal' && $shipping_data_to_migrate) {
                $tmp_shipping_data_to_migrate = $shipping_data_to_migrate;
                unset($tmp_shipping_data_to_migrate['shipping_notes']);
                unset($tmp_shipping_data_to_migrate['shipping_address']);
                unset($tmp_shipping_data_to_migrate['shipping_tracking_number']);
                if(empty($tmp_shipping_data_to_migrate)) $shipping_data_to_migrate = array();
            }
            if($shipping_data_to_migrate) {
                //qc_tf_weight_ug
                $sorted_data_to_migrate = array(
                    'Aliquot' => array(
                        'parent_aliquot_master_id'=> $extractionSampleAliquotData['aliquot_masters']['id'],
                        'collection_id' => $extractionSampleAliquotData['aliquot_masters']['collection_id'],
                        'sample_master_id'=> $extractionSampleAliquotData['sample_masters']['id'],
                        'aliquot_control_id'=> $extractionSampleAliquotData['aliquot_masters']['aliquot_control_id'],
                        'aliquot_label' => $extractionSampleAliquotData['aliquot_masters']['aliquot_label'],
                        'concentration' => '',
                        'concentration_unit' => '',
                        'initial_volume' => '',
                        'qc_tf_weight_ug' => '',
                        'notes' => implode(' ',$xls_aliquot_data)),
                    'Shipments' => array(
                        'datetime_shipped'=> '',
                        'datetime_shipped_accuracy'=> '',
                        'recipient' => '',
                        'delivery_street_address' => '',
                        'tracking' => '',
                        'delivery_notes' => implode(' ',$xls_shipping_data)),
                    'Order' => array(
                        'study' => ''
                ));
                // Order study
                $tmpKey = 'shipping_project';
                $tmpXlsStudyName = '';
                if(isset($shipping_data_to_migrate[$tmpKey])) {
                    $xlsField = array_keys($shipping_data_to_migrate[$tmpKey]);
                    if(sizeof($xlsField) > 1) {die('ERR2382397239823798 '.__LINE__);}
                    $xlsField = $xlsField[0];
                    $tmpXlsStudyName =  $sorted_data_to_migrate['Order']['study'] = $shipping_data_to_migrate[$tmpKey][$xlsField];
                    preg_match('/(COEUR\-[0-9]+)/', $tmpXlsStudyName, $matches);
                    if(isset($allAtimStudies['complet'][strtolower($sorted_data_to_migrate['Order']['study'])])) {
                        $sorted_data_to_migrate['Order']['study'] = $allAtimStudies['complet'][strtolower($sorted_data_to_migrate['Order']['study'])];
                    } elseif($matches && isset($allAtimStudies['partiel'][strtolower($matches[1])])) {
                        $sorted_data_to_migrate['Order']['study'] =$allAtimStudies['partiel'][strtolower($matches[1])][0];
                        $key = $tmpXlsStudyName."' matching ATIM study '".$allAtimStudies['partiel'][strtolower($matches[1])][1]."'. for field '$xlsField' ";
                        recordErrorAndMessage(
                            $worksheetName .' :: ' .'Shipping creation',
                            '@@WARNING@@',
                            "Study of the shipping matches approximatively an ATiM study. Order will be linked to this study but please validate. [Validation Message #".__LINE__."]",
                            "See study  '".$tmpXlsStudyName."' matching ATIM study '".$allAtimStudies['partiel'][strtolower($matches[1])][1]."'. for field '$xlsField' and $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter and more... ($worksheetName).",
                            $key);
                    } else {
                        recordErrorAndMessage(
                            $worksheetName .' :: ' .'Shipping creation',
                            '@@ERROR@@',
                            "Study of the shipping is unknown. Order won't be linked to this study. [Validation Message #".__LINE__."]",
                            "See study  '".$sorted_data_to_migrate['Order']['study']."' for field '$xlsField' and $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName) and more.",
                            $sorted_data_to_migrate['Order']['study']."//$xlsField//".$worksheetName);
                        $tmpWrongStudy = $sorted_data_to_migrate['Order']['study'];
                        $sorted_data_to_migrate['Order']['study'] = '';
                    }
                 }
                // aliquot_concentration
                $tmpKey = 'aliquot_concentration';
                if(isset($shipping_data_to_migrate[$tmpKey])) {
                    $xlsField = array_keys($shipping_data_to_migrate[$tmpKey]);
                    if(sizeof($xlsField) > 1) {die('ERR2382397239823798 '.__LINE__);}
                    $xlsField = $xlsField[0];
                    $sorted_data_to_migrate['Aliquot']['concentration'] = validateAndGetDecimal($shipping_data_to_migrate[$tmpKey][$xlsField], $worksheetName .' :: ' .'Shipping creation', "See excel field '$xlsField'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    $sorted_data_to_migrate['Aliquot']['concentration_unit'] = 'ug/ul';
                }
                // aliquot_volume
                $tmpKey = 'aliquot_volume';
                if(isset($shipping_data_to_migrate[$tmpKey])) {
                    $xlsField = array_keys($shipping_data_to_migrate[$tmpKey]);
                    if(sizeof($xlsField) > 1) {die('ERR2382397239823798 '.__LINE__);}
                    $xlsField = $xlsField[0];
                    $sorted_data_to_migrate['Aliquot']['initial_volume'] = validateAndGetDecimal($shipping_data_to_migrate[$tmpKey][$xlsField], $worksheetName .' :: ' .'Shipping creation', "See excel field '$xlsField'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                }                     
                // aliquot_weight
                $tmpKey = 'aliquot_weight';
                if(isset($shipping_data_to_migrate[$tmpKey])) {
                    $xlsField = array_keys($shipping_data_to_migrate[$tmpKey]);
                    if(sizeof($xlsField) > 1) {die('ERR2382397239823798 '.__LINE__);}
                    $xlsField = $xlsField[0];
                    if(preg_match('/[\ ]*([0-9]+)[\ ]*ng[\ ]*$/', $shipping_data_to_migrate[$tmpKey][$xlsField], $matches)) {
                        $shipping_data_to_migrate[$tmpKey][$xlsField] = ($matches[1])/1000;
                    } else if(preg_match('/[\ ]*([0-9]+)[\ ]*ug[\ ]*$/', $shipping_data_to_migrate[$tmpKey][$xlsField], $matches)) {
                        $shipping_data_to_migrate[$tmpKey][$xlsField] = $matches[1];
                    }
                    if($shipping_data_to_migrate[$tmpKey][$xlsField] == 'all') {
                        if($extractionSampleAliquotData['aliquot_masters']['in_stock'] != 'no') {
                            recordErrorAndMessage(
                                $worksheetName .' :: ' .'Shipping creation',
                                '@@WARNING@@',
                                "The quantity/wieght of a shipped aliquot has been defined as compltetly shipped (value equal 'all') but the status of this aliquot is defined as available into the Excel file. Please validate and clean up data after the migration. [Validation Message #".__LINE__."]",
                                "See Aliquot TFRI# ".$extractionSampleAliquotData['aliquot_masters']['id']." matching $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                        }
                    } else {
                        $sorted_data_to_migrate['Aliquot']['qc_tf_weight_ug'] = validateAndGetDecimal($shipping_data_to_migrate[$tmpKey][$xlsField], $worksheetName .' :: ' .'Shipping creation', "See excel field '$xlsField'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                
                    }
                }
                // datetime_shipped
                $tmpKey = 'shipping_date';
                if(isset($shipping_data_to_migrate[$tmpKey])) {
                    $xlsField = array_keys($shipping_data_to_migrate[$tmpKey]);
                    if(sizeof($xlsField) > 1) {die('ERR2382397239823798 '.__LINE__);}
                    $xlsField = $xlsField[0];
                    list($sorted_data_to_migrate['Shipments']['datetime_shipped'], $sorted_data_to_migrate['Shipments']['datetime_shipped_accuracy']) = validateAndGetDateAndAccuracy($shipping_data_to_migrate[$tmpKey][$xlsField], $worksheetName .' :: ' .'Shipping creation', "See excel field '$xlsField'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    $sorted_data_to_migrate['Shipments']['datetime_shipped_accuracy'] = 'h';
                }
                // recipient
                $tmpKey = 'shipping_contact';
                if(isset($shipping_data_to_migrate[$tmpKey])) {
                    $xlsField = array_keys($shipping_data_to_migrate[$tmpKey]);
                    if(sizeof($xlsField) > 1) {die('ERR2382397239823798 '.__LINE__);}
                    $xlsField = $xlsField[0];
                    $sorted_data_to_migrate['Shipments']['recipient'] = substr($shipping_data_to_migrate[$tmpKey][$xlsField], 0, 60);
                }
                // address
                $tmpKey = 'shipping_address';
                if(isset($shipping_data_to_migrate[$tmpKey])) {
                    $xlsField = array_keys($shipping_data_to_migrate[$tmpKey]);
                    if(sizeof($xlsField) > 1) {die('ERR2382397239823798 '.__LINE__);}
                    $xlsField = $xlsField[0];
                    $sorted_data_to_migrate['Shipments']['delivery_street_address'] = $shipping_data_to_migrate[$tmpKey][$xlsField];
                }
                // tracking_number
                $tmpKey = 'shipping_tracking_number';
                if(isset($shipping_data_to_migrate[$tmpKey])) {
                    $xlsField = array_keys($shipping_data_to_migrate[$tmpKey]);
                    if(sizeof($xlsField) > 1) {die('ERR2382397239823798 '.__LINE__);}
                    $xlsField = $xlsField[0];
                    $sorted_data_to_migrate['Shipments']['tracking'] = $shipping_data_to_migrate[$tmpKey][$xlsField];
                }
                // Add data to shipment to create
                $order_key = strlen($tmpXlsStudyName)? $tmpXlsStudyName: '';
                $shipment_key = $sorted_data_to_migrate['Shipments']['delivery_notes'];
                if(!$shipment_key) $shipment_key = 'Unknown';
                if(!$order_key) $order_key = $shipment_key;
                $allShippingsToCreate[$order_key]['order_data'] = $sorted_data_to_migrate['Order'];
                $allShippingsToCreate[$order_key]['shipments'][$shipment_key]['shipment_data'] = $sorted_data_to_migrate['Shipments'];
                $allShippingsToCreate[$order_key]['shipments'][$shipment_key]['order_items'][] = $sorted_data_to_migrate;     
            }
        }
    }
}

function createShipping() {
    global $createdRecordsCounter;
    global $allShippingsToCreate;
    global $import_date;
       
    // Create Order
    $createdRecordsCounter['orders created'] = 0;
    $createdRecordsCounter['shipments created'] = 0;
    $createdRecordsCounter['shipped aliquots created'] = 0;
    foreach($allShippingsToCreate as $orderKey => $newOrder) {
        $createdRecordsCounter['orders created']++;
        $orderData = array(
            'order_number' =>  'From Xls#' . $createdRecordsCounter['orders created'],
            'processing_status' => 'completed',
            'short_title' => substr($orderKey, 0, 45),
            'description' => 'Created by script to track Tissue DNA/RNA from excel on '.substr($import_date, 0,10) .'. ',
            'default_study_summary_id' => $newOrder['order_data']['study']
        );
        $orderId = customInsertRecord(array('orders' => $orderData));
        $shipmentCounter = 0;
        foreach($newOrder['shipments'] as $newShipment) {
            $createdRecordsCounter['shipments created']++;
            $shipId = customInsertRecord(array(
                'shipments' => array_merge(
                    array(
                        'order_id' => $orderId,
                        'shipment_code' =>  'XLS#' . $createdRecordsCounter['shipments created']),
                    $newShipment['shipment_data'])));
            foreach($newShipment['order_items'] as $new_item) {
                $new_item = $new_item['Aliquot'];
                $createdRecordsCounter['shipped aliquots created']++;
                $aliquot_data = array(
                    'aliquot_masters' => array(
                        "barcode" => 'tmp_order_item_'.$createdRecordsCounter['shipped aliquots created'],
                        'aliquot_label' => $new_item['aliquot_label'],
                        "aliquot_control_id" => $new_item['aliquot_control_id'],
                        "collection_id" => $new_item['collection_id'],
                        "sample_master_id" => $new_item['sample_master_id'],
                        'in_stock' => 'no',
                        'in_stock_detail' => 'shipped',
                        'initial_volume' => $new_item['initial_volume'],
                        'current_volume' => $new_item['initial_volume'],
                        'notes' => 'Created by script to track Tissue DNA/RNA from excel on '.substr($import_date, 0,10) .'. ' . $new_item['notes']),
                    'ad_tubes' => array(
                        'concentration' => $new_item['concentration'],
                        'concentration_unit' => $new_item['concentration_unit'],
                        'qc_tf_weight_ug' => $new_item['qc_tf_weight_ug']
                    ));
                $aliquotMasterId = customInsertRecord($aliquot_data);
                $realiquoting_data = array('realiquotings' => array(
                    'parent_aliquot_master_id' => $new_item['parent_aliquot_master_id'],
                    'child_aliquot_master_id' => $aliquotMasterId));
                customInsertRecord($realiquoting_data);
                $orderItemId = customInsertRecord(array(
                    'order_items' => array(
                        'order_id' => $orderId,
                        'aliquot_master_id' => $aliquotMasterId,
                        'status' => 'shipped',
                        'shipment_id' => $shipId)
                ));
            }
        }
    }
}

function addAmplifications($dnaAmplifcations, $worksheetName, $extractionSampleAliquotDataFromParticipantId) {
    global $createdRecordsCounter;
    global $import_date;
    global $atim_controls;
    
    if(isset($dnaAmplifcations[$worksheetName])) {
        // Create DNA Amplification
        foreach($dnaAmplifcations[$worksheetName] as $newAmplification) {
            $participantId = $newAmplification['participant_id'];
            $excelLineCounter = $newAmplification['excelLineCounter'];
            $amplificationExcelLineData = $newAmplification['data'];
            $excelParticipantInfoForMsg = $newAmplification['excelParticipantInfoForMsg'];
            $excelSourceAliquotInfoForMsg = $newAmplification['excelSourceAliquotInfoForMsg'];
            
            if(!isset($extractionSampleAliquotDataFromParticipantId[$participantId])) {
                recordErrorAndMessage($worksheetName .' :: ' .
                    'Dna Amplification creation',
                    '@@ERROR@@',
                    "A DNA amplifcation is defined but no DNA extraction has been previously defined into the file. Amplification won't be created. [Validation Message #".__LINE__."]",
                    "See data for participant $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                return;
            }
            if(sizeof($extractionSampleAliquotDataFromParticipantId[$participantId]) > 1) { die('ERR434343444343343'); };
            foreach(array('participantBank#', 'Bank', 'Date received', 'Fedex reception', 'Histopathology', 'extraction date') as $fieldToTest) {
                if(isset($amplificationExcelLineData[$fieldToTest]) && strlen($amplificationExcelLineData[$fieldToTest])) die('ERR43434344334334343');
            }
            $parentExtractionSampleAliquotData = $extractionSampleAliquotDataFromParticipantId[$participantId][0];
            
            // Create amplified aliquot
            
            $xls_field = "Availability";
            $in_stock = '';
            if(isset($amplificationExcelLineData[$xls_field])) {
                $in_stock = validateAndGetStructureDomainValue(str_replace(array('yes'), array('yes - available'), $amplificationExcelLineData[$xls_field]), 'aliquot_in_stock_values', $worksheetName .' :: ' .'Dna Amplification creation', "See excel field '$xls_field'. Value will be replaced by 'yes - available'. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
            }
            if(!$in_stock) $in_stock = 'yes - available';
            $aliquot_notes = array('Created by script to track DNA/RNA blood from excel on '.substr($import_date, 0,10) ." (Worksheet '.$worksheetName').");
            foreach(array('Notes 1', 'Notes 2', 'Notes') as $xls_field) {
                if(isset($amplificationExcelLineData[$xls_field])) {
                    $aliquot_notes[] = "Xls $xls_field : ".$amplificationExcelLineData[$xls_field].'.';
                }
            }
            $qc_tf_storage_solution = array();
            foreach(array('storage medium', 'RNA storage medium', 'Storage medium', 'Buffer') as $xls_field) {
                if(isset($amplificationExcelLineData[$xls_field])) {
                    if(preg_match('/^ATE/', $amplificationExcelLineData[$xls_field])) {
                        $qc_tf_storage_solution[] = 'ATE';
                        $aliquot_notes[] = $xls_field . " : " . $amplificationExcelLineData[$xls_field];
                    } else {
                        $qc_tf_storage_solution[] = $amplificationExcelLineData[$xls_field];
                    }
                }
            }
            $qc_tf_storage_solution = implode(' + ', $qc_tf_storage_solution);
            $qc_tf_storage_solution = validateAndGetStructureDomainValue($qc_tf_storage_solution, 'qc_tf_dna_rna_storage_solutions', $worksheetName .' :: ' .'Dna Amplification creation creation', "See excel field 'Storage Medium' or 'Buffer'. Value will be replaced by 'yes - available'. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
            $qc_tf_weight_ug_initial = '';
            foreach(array('Initial Quantity (ng)', 'Initial Quantity (ug)', 'Quantity initial (ug)', 'Quantity (ug) initial') as $xls_field) {
                if(isset($amplificationExcelLineData[$xls_field])) {
                    $qc_tf_weight_ug_initial = validateAndGetDecimal($amplificationExcelLineData[$xls_field], $worksheetName .' :: ' .'Dna Amplification creation creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    if($qc_tf_weight_ug_initial && $xls_field == 'Initial Quantity (ng)') {
                        $qc_tf_weight_ug_initial = $qc_tf_weight_ug_initial/1000;
                    }
                    $aliquot_notes[] = "Xls $xls_field : ".$amplificationExcelLineData[$xls_field].'.';
                }
            }
            $xls_field = 'Quantity used';
            if(isset($amplificationExcelLineData[$xls_field]) && strlen($amplificationExcelLineData[$xls_field])) {
                $aliquot_notes[] = $xls_field . " : " . $amplificationExcelLineData[$xls_field];
            }
            $qc_tf_weight_ug = '';
            foreach(array('Quantity Available (ng)', 'Quantity Available (ug)', 'Qte total left (ng)', 'Quantity available') as $xls_field) {
                if(isset($amplificationExcelLineData[$xls_field])) {
                    $aliquot_notes[] = "Xls $xls_field : ".$amplificationExcelLineData[$xls_field].'.';
                    if(preg_match('/^\-[0-9\.\,]+$/', $amplificationExcelLineData[$xls_field])) {
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Dna Amplification creation',
                            '@@WARNING@@',
                            "Aliquot '$xls_field' is lower than 0. Value will be migrated as equal to 0. Please validate. [Validation Message #".__LINE__."]",
                            "See '$xls_field' euqal to '".$amplificationExcelLineData[$xls_field]." for aliquot defined by $excelSourceAliquotInfoForMsg for participant $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                        $qc_tf_weight_ug = '0';
                    } else {
                        $qc_tf_weight_ug = validateAndGetDecimal($amplificationExcelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    }
                    if($qc_tf_weight_ug && $xls_field == 'Quantity Available (ng)' && $qc_tf_weight_ug != '0') {
                        $qc_tf_weight_ug = $qc_tf_weight_ug/1000;
                    }
                }
            }
            $initial_volume = null;
            foreach(array('Volume uL', 'volume1 initial (ul)', 'volume initial uL') as $xls_field) {
                if(isset($amplificationExcelLineData[$xls_field])) {
                    $initial_volume = validateAndGetDecimal($amplificationExcelLineData[$xls_field], $worksheetName .' :: ' .'Dna Amplification creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    $aliquot_notes[] = "Xls $xls_field : ".$amplificationExcelLineData[$xls_field].'.';
                }
            }
            $used_volume = null;
            foreach(array('Quantity used (ul)', 'volume used') as $xls_field) {
                if(isset($amplificationExcelLineData[$xls_field])) {
                    $used_volume = validateAndGetDecimal($amplificationExcelLineData[$xls_field], $worksheetName .' :: ' .'Dna Amplification creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    $aliquot_notes[] = "Xls $xls_field : ".$amplificationExcelLineData[$xls_field].'.';
                }
            }
            $current_volume = null;
            foreach(array('volume1 restant (ul)', 'volume left uL', 'Volume available left') as $xls_field) {
                if(isset($amplificationExcelLineData[$xls_field])) {
                    $current_volume = validateAndGetDecimal($amplificationExcelLineData[$xls_field], $worksheetName .' :: ' .'Dna Amplification creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                    $aliquot_notes[] = "Xls $xls_field : ".$amplificationExcelLineData[$xls_field].'.';
                }
            }
            $volumeForInternalUse = null;
            if($initial_volume && $current_volume) {
                $volumeForInternalUse = $initial_volume - $current_volume;
                $current_volume = null;
            } else if($initial_volume && $used_volume) {
                $volumeForInternalUse = $used_volume;
            } else if($used_volume) {
                $volumeForInternalUse = $used_volume;
            }
            
            $sample_type = 'dna';
            $createdRecordsCounter[$sample_type.' tubes created']++;
            $aliquot_data = array(
                'aliquot_masters' => array(
                    "barcode" => 'tmp_core_'.$createdRecordsCounter[$sample_type.' tubes created'],
                    'aliquot_label' => $amplificationExcelLineData['Aliquot Name'],
                    "aliquot_control_id" => $atim_controls['aliquot_controls']["$sample_type-tube"]['id'],
                    "collection_id" => $parentExtractionSampleAliquotData['aliquot_masters']['collection_id'],
                    "sample_master_id" => $parentExtractionSampleAliquotData['aliquot_masters']['sample_master_id'],
                    'in_stock' => $in_stock,
                    'initial_volume' => $initial_volume,
                    'current_volume' => ($volumeForInternalUse? ($initial_volume-$volumeForInternalUse) : $initial_volume),
                    'notes' => implode(' ', $aliquot_notes)),
                $atim_controls['aliquot_controls']["$sample_type-tube"]['detail_tablename'] => array(
                    'qc_tf_storage_solution' => $qc_tf_storage_solution,
                    'qc_tf_weight_ug_initial' => $qc_tf_weight_ug_initial,
                    'qc_tf_weight_ug' => $qc_tf_weight_ug
                ));
            list($storage_master_id, $storage_coord_x, $storage_coord_y , $newNotes) = getStorageInfo($amplificationExcelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg);
            if($newNotes) {
                $aliquot_data['aliquot_masters']['notes'] = "$newNotes. ".$aliquot_data['aliquot_masters']['notes'];
            }
            if($storage_master_id) {
                if($in_stock == 'no' && $storage_master_id) {
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Dna Amplification creation',
                        '@@WARNING@@',
                        "Aliquot defined as not in stock but storage information and positions have been defined for the aliquot. Storage information and position won't be migrated. Please validate. [Validation Message #".__LINE__."]",
                        "See position information for aliquot defined by $excelSourceAliquotInfoForMsg for participant $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                } else {
                    $aliquot_data['aliquot_masters']['storage_master_id'] = $storage_master_id;
                    if(strlen($storage_coord_x)) $aliquot_data['aliquot_masters']['storage_coord_x'] = $storage_coord_x;
                    if(strlen($storage_coord_y)) $aliquot_data['aliquot_masters']['storage_coord_y'] = $storage_coord_y;
                }
            }
            $amplificationAliquotMasterId = customInsertRecord($aliquot_data);
            
            if(strlen($volumeForInternalUse) && $volumeForInternalUse != '0') {
                $createdRecordsCounter['DNA/RNA used']++;
                customInsertRecord(array(
                    'aliquot_internal_uses' => array(
                        'aliquot_master_id' => $amplificationAliquotMasterId,
                        'type' => 'internal use',
                        'used_volume' => $volumeForInternalUse,
                        'use_code' => 'Extraction used (based on XLS file)')));
            }
            
            // add amplification info
            
            $xls_field = 'extracted by';
            $creation_by = validateAndGetStructureDomainValue($amplificationExcelLineData[$xls_field], 'custom_laboratory_staff', $worksheetName .' :: ' .'Dna Amplification creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
            $amplificationDate = '';
            $amplificationDateAcc = '';
            $xls_field = 'amplification date';
            if(isset($amplificationExcelLineData[$xls_field]) && $amplificationExcelLineData[$xls_field]) {
                list($amplificationDate, $amplificationDateAcc) = validateAndGetDateAndAccuracy($amplificationExcelLineData[$xls_field], $worksheetName .' :: ' .'Dna Amplification creation', "See excel field '$xls_field'. Value won't be migrated. [Validation Message #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                if($amplificationDate) { $amplificationDateAcc = 'h'; }
            }
            $amplificationMethode = isset($amplificationExcelLineData['amplification methode']) && strlen($amplificationExcelLineData['amplification methode'])? $amplificationExcelLineData['amplification methode'] : 'Unknown';
            $aliquot_internal_use_data = array(
                'aliquot_internal_uses' => array(
                    'aliquot_master_id' => $amplificationAliquotMasterId,
                    'type' => 'amplification',
                    'used_by' => $creation_by,
                    'use_code' => 'Methode : ' . $amplificationMethode,
                    'use_datetime' => $amplificationDate,
                    'use_datetime_accuracy' => $amplificationDateAcc));
            customInsertRecord($aliquot_internal_use_data);
            $realiquoting_data = array('realiquotings' => array(
                'parent_aliquot_master_id' => $parentExtractionSampleAliquotData['aliquot_masters']['id'],
                'child_aliquot_master_id' => $amplificationAliquotMasterId,
                'realiquoting_datetime' => $amplificationDate,
                'realiquoting_datetime_accuracy' => $amplificationDateAcc,
                'realiquoted_by' => $creation_by));
            customInsertRecord($realiquoting_data);

            $amplificationSampleAliquotData = array('sample_masters' => $parentExtractionSampleAliquotData['sample_masters'], 'aliquot_masters' => array_merge(array('id' => $amplificationAliquotMasterId), $aliquot_data['aliquot_masters']));  
            // === Create DNA /RNA QC
            addQualityControls($amplificationExcelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $amplificationSampleAliquotData);
            // === Create DNA /RNA Shipping
            addOrderAndShipping($amplificationExcelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $amplificationSampleAliquotData);
            
        }
    }
}
            
            
?>
		