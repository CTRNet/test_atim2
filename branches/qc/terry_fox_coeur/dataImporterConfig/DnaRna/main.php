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

//TODO to remove
global $customValueToAdd;$customValueToAdd = array();

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
    'freezers created' => 0,
    'shelfs created' => 0,
    'rack16s created' => 0,
    'box81 1A-9Is created' => 0,
    'box81s created' => 0
);
global $dnaRnaExtractions;
$dnaRnaExtractions = array();
global $dnaAmplifcations;
$dnaAmplifcations = array();
global $allStorages;
$allStorage = getExistingStorage();
$worksheetnames= array('RNA FFPE', 'RNA FT', 'DNA FFPE tissues', 'DNA Normal', 'DNA FT');
$xls_empty_fields_to_validate = array(
    'RNA FFPE' => array('Column', 'Lane', 'Temperature', 'ARN aliquote uG', 'ARN aliquote uL', "Dilution (uL d'eau)", 'Volume shipped uL', 'Concentration shipped ug/uL', 'shipping date', 'contact shipping', 'ProjectID', 'adress shipping', 'Fedex'),#
    'RNA FT' => array('ARN aliquote uG')
    );
foreach($worksheetnames as $worksheetName) {
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
//if(!in_array($participantId, array('1', '3', '966', '777'))) continue;
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
            addAliquotSourceQuantityUsed($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot);
            // === Create DNA /RNA extraction
            $extractionSampleAliquotData = createExtraction($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot, $excelSourceType);
        } // End if participant id
    } // End new worksheet line
    if(isset($dnaAmplifcations[$worksheetName])) {
//        pr("TODO dna extraction");
//TODO        pr($dnaAmplifcations[$worksheetName]);
    }
    
    echo "<br><br><FONT COLOR=\"GREEN\" >
==========================================================================================================================================<br><br>
<b> Worksheet Migration Summary: $worksheetName</b> <br><br>
==========================================================================================================================================</FONT><br>";
    dislayErrorAndMessage();
    $import_summary = array();
}

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
addToModifiedDatabaseTablesList('source_aliquots', null);
addToModifiedDatabaseTablesList('orders', null);
addToModifiedDatabaseTablesList('order_items', null);
addToModifiedDatabaseTablesList('shipments', null);

if(!$commitAll) mysqli_rollback($db_connection);
dislayErrorAndMessage($commitAll);

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
            $errorTitle." [Message type #".__LINE__."]",
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
                $errorTitle." [Message type #".__LINE__."]",
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
                    $warningMessage = "ATiM and Excel participants match on Participant ATiM # but the Participant Bank # values do not match. Data of the line will be migrated but please validate."." [Message type #".__LINE__."]";
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
                    $warningMessage = "ATiM and Excel participants match on Participant ATiM # but the Bank values do not match. Data of the line will be migrated but please validate."." [Message type #".__LINE__."]";
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
                    $warningMessage ="ATiM and Excel participants match on Participant ATiM # $titlePrecision. Data of the line will be migrated but please validate."." [Message type #".__LINE__."]";
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
                $errorTitle." [Message type #".__LINE__."]",
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
                $warningMessage = "ATiM and Excel participants match on Participant Bank # but the Bank values do not match. Data of the line will be migrated but please validate."." [Message type #".__LINE__."]";
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
                $warningMessage = "ATiM and Excel participants match on Participant Bank # but bank values can not be validated. Data of the line will be migrated but please validate."." [Message type #".__LINE__."]";
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
                $errorTitle." [Message type #".__LINE__."]",
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
            $dnaAmplifcations[$worksheetName][$excelLineCounter] = $excelLineData;
            return null;
        } else {
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
                    $warningMessage = "No $typeOfSourceAliquotForMsg exists into ATiM for the participant but a Buffy Coat sample exists. No tube of Buffy coat will be created but extraction will be linked to this existing sample. (worksheet : $worksheetName)"." [Message type #".__LINE__."]";
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
                        $warningMessage = "No $typeOfSourceAliquotForMsg and sample exist into ATiM for the participant but a Blood sample already exists. A Buffy Coat sample will be created (with no tube) for this Blood and extraction will be linked to this buffy Coat sample. (worksheet : $worksheetName)"." [Message type #".__LINE__."]";
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
                        $warningMessage = "No $typeOfSourceAliquotForMsg exists into ATiM for the participant and more than one Blood sample already exists. New collection, blood and buffy coat sample will be created and extraction will be linked to this buffy coat sample. (worksheet : $worksheetName)"." [Message type #".__LINE__."]";
                        if(!$bloods) {
                            $warningMessage = "No $typeOfSourceAliquotForMsg and Blood sample exist into ATiM for the participant. New collection, blood and buffy coat sample will be created and extraction will be linked to this buffy coat sample. (worksheet : $worksheetName)"." [Message type #".__LINE__."]";
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
                    "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter."." [Message type #".__LINE__."]");
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
                                $warningMessage = "More than one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant but one ATiM aliquot label matches approximatively the Excel aliquot information. Data of the line will be migrated and linked to this $typeOfSourceAliquotForMsg but please validate."." [Message type #".__LINE__."]";
                                $warningDetail = "See ATiM aliquot label [$selectedAliquotKey] and Excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.";
                                recordErrorAndMessage($worksheetName .' :: ' .
                                    'Aliquot Source Definition',
                                    '@@WARNING@@',
                                    $warningMessage,
                                    "See migrated line to validate below.",
                                    "See migrated line to validate below.");
                                addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warningMessage, $warningDetail);
                            } elseif(sizeof($selectedAliquotKey)) {
                                $warningMessage = "More than one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant and the aliquot labels of more than one ATiM aliquot match approximatively the Excel aliquot information. Data of the line will be migrated and linked to the first one $typeOfSourceAliquotForMsg matching excel information but please validate."." [Message type #".__LINE__."]";
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
                        $warningMessage = "Only one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant but the ATiM aliquot label does not match the Excel aliquot information. Data of the line will be migrated and linked to this $typeOfSourceAliquotForMsg but please validate."." [Message type #".__LINE__."]";
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
                        $warningMessage = "More than one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant and match the ATiM aliquot label . Data of the line will be migrated and linked to the first $typeOfSourceAliquotForMsg but please validate."." [Message type #".__LINE__."]";
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
                            'notes' => 'Created by script to track Tissue DNA/RNA from excel on '.substr($import_date, 0,10) .'.'),
                        $atim_controls['aliquot_controls'][$controltype]['detail_tablename'] => $detail_data);
                    $aliquotMasterId = customInsertRecord($aliquot_data);
                    $aliquotSources = array_keys($aliquotSources);
                    $aliquotSources = implode ('</b> & <b>', $aliquotSources);
                    $warningMessage = $warningTitle." [Message type #".__LINE__."]";
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
    $unmigratedData[$worksheetName][] = array_merge(array('Line' => $excelLineCounter, 'Error' => $error), $excelLineData);
}

function addMigratedLineToValidate($excelLineData, $worksheetName, $excelLineCounter, $warning, $warning_detail = '') {
    global $migratedDataToValidate;
    $migratedDataToValidate[$worksheetName][] = array_merge(array('Line' => $excelLineCounter, 'Warning' => $warning, 'Warning Details' => str_replace(array('<b>' ,'</b>'), array('', ''), $warning_detail)), $excelLineData);
}

function addAliquotSourceQuantityUsed($excelLineData, $worksheetName, $excelLineCounter, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg, $atimSourceAliquot) {
    global $createdRecordsCounter;
    if($atimSourceAliquot) {
        foreach(array('qte source used (n=cores)', 'quantity source used for extraction', 'qty source used', 'qty source used') as $xls_field) {
            if(isset($excelLineData[$xls_field]) && strtolower($excelLineData[$xls_field]) != 'unknown') {
                if($atimSourceAliquot['aliquot_master_id']) {
                    $createdRecordsCounter['quantity source used for extraction']++;
                    customInsertRecord(array(
                        'aliquot_internal_uses' => array(
                            'aliquot_master_id' => $atimSourceAliquot['aliquot_master_id'],
                            'type' => 'quantity source used',
                            'use_code' => $excelLineData[$xls_field] . ($xls_field == 'qte source used (n=cores)'? ' cores': ''))));
                } else {
                    die('ERR23872372987238237');
                }
            }
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
        
        // Create extraction sample
        
        $derivative_details = array();
        foreach(array("Date d'extraction","Extraction date", "extraction date") as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                if(preg_match('/^(20[0-9]{2})-00-00$/', $excelLineData[$xls_field], $matches)) {
                    $derivative_details['creation_datetime'] = $matches[1].'-01-01';
                    $derivative_details['creation_datetime_accuracy'] = 'm';
                } else {
                    list($creationDate, $creationDateACc) = validateAndGetDateAndAccuracy($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
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
                $derivative_details['creation_by'] = validateAndGetStructureDomainValue($excelLineData[$xls_field], 'custom_laboratory_staff', $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
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
                $sample_details['qc_tf_extraction_method'] = validateAndGetStructureDomainValue($excelLineData[$xls_field], 'qc_tf_dna_rna_extraction_methods', $worksheetName .' :: ' .'Extraction creation', "See excel field 'Extraction Method'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
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
                $sample_details['qc_tf_deparafinization_method'] = validateAndGetStructureDomainValue($excelLineData[$xls_field], 'qc_tf_deparafinization_methods', $worksheetName .' :: ' .'Extraction creation', "See excel field 'deparafinization Method'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
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
                        break;
                    case 'FFPE-slide-tumor':
                    case 'FFPE-tumor':
                        $controltype = 'tissue-slide';
                        $counterKey = 'tissue slides created';
                        break;
                }
                if($controltype) {
                    $createdRecordsCounter[$counterKey]++;
                    $aliquot_data = array(
                        'aliquot_masters' => array(
                            "barcode" => 'tmp_core_'.$createdRecordsCounter[$counterKey],
                            'aliquot_label' => $atimSourceAliquot['aliquot_label'],
                            "aliquot_control_id" => $atim_controls['aliquot_controls'][$controltype]['id'],
                            "collection_id" => $atimSourceAliquot['collection_id'],
                            "sample_master_id" => $atimSourceAliquot['sample_master_id'],
                            'in_stock' => 'no',
                            'notes' => 'Created by script to track Tissue DNA/RNA from excel on '.substr($import_date, 0,10) .'.'),
                        $atim_controls['aliquot_controls'][$controltype]['detail_tablename'] => array());
                    $source_aliquot_master_id = customInsertRecord($aliquot_data);
                    $realiquoting_data = array('realiquotings' => array(
                        'parent_aliquot_master_id' => $atimSourceAliquot['aliquot_master_id'],
                        'child_aliquot_master_id' => $source_aliquot_master_id));
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
        
        // Create extraction aliquot
        
        $aliquot_label = array();
        foreach(array('Sample label', 'Aliquot Name', 'sample label', 'Sample FT source', 'Other name 2') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $aliquot_label[$excelLineData[$xls_field]] = $excelLineData[$xls_field];
            }
        }
        $aliquot_label = implode(' ', $aliquot_label);
        $xls_field = "Availability";
        $in_stock = '';
        if(isset($excelLineData[$xls_field])) {
            $in_stock = validateAndGetStructureDomainValue(str_replace(array('yes'), array('yes - available'), $excelLineData[$xls_field]), 'aliquot_in_stock_values', $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value will be replaced by 'yes - available'. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
        }
        if(!$in_stock) $in_stock = 'yes - available';
        $aliquot_notes = array('Created by script to track DNA/RNA blood from excel on '.substr($import_date, 0,10) .'.');
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
        $qc_tf_storage_solution = validateAndGetStructureDomainValue($qc_tf_storage_solution, 'qc_tf_dna_rna_storage_solutions', $worksheetName .' :: ' .'Extraction creation', "See excel field 'Storage Medium' or 'Buffer'. Value will be replaced by 'yes - available'. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
        $qc_tf_weight_ug_initial = '';
        foreach(array('Initial Quantity  (ng)', 'Initial Quantity  (ug)', 'Quantity initial (ug)', 'Quantity (ug) initial') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $qc_tf_weight_ug_initial = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                if($qc_tf_weight_ug_initial && $xls_field == 'Initial Quantity  (ng)') {
                    $qc_tf_weight_ug_initial = $qc_tf_weight_ug_initial/1000;
                    $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
                }
            }
        }
        $xls_field = 'Quantity used';
        if(isset($excelLineData[$xls_field]) && strlen($excelLineData[$xls_field])) {
            $aliquot_notes[] = $xls_field . " : " . $excelLineData[$xls_field];
        }
        $qc_tf_weight_ug = '';
        foreach(array('Quantity Available (ng)', 'Quantity Available (ug)', 'Qte total left (ng)', 'Quantity available') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $qc_tf_weight_ug = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                if($qc_tf_weight_ug && $xls_field == 'Quantity Available (ng)') {
                    $qc_tf_weight_ug = $qc_tf_weight_ug/1000;
                    $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
                }
            }
        }
        $initial_volume = null;
        foreach(array('Volume uL', 'volume1 initial  (ul)', 'volume initial uL') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $initial_volume = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
            }
        }
        $used_volume = null;
        foreach(array('Quantity used (ul)', 'volume used') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $used_volume = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
                $aliquot_notes[] = "Xls $xls_field : ".$excelLineData[$xls_field].'.';
            }
        }
        $current_volume = null;
        foreach(array('volume1 restant  (ul)', 'volume left uL', 'Volume available left') as $xls_field) {
            if(isset($excelLineData[$xls_field])) {
                $current_volume = validateAndGetDecimal($excelLineData[$xls_field], $worksheetName .' :: ' .'Extraction creation', "See excel field '$xls_field'. Value won't be migrated. [Message type #".__LINE__."]", "See data for $excelSourceAliquotInfoForMsg of the $excelParticipantInfoForMsg line $excelLineCounter ($worksheetName).");
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
                'aliquot_label' => $aliquot_label,
                "aliquot_control_id" => $atim_controls['aliquot_controls']["$sample_type-tube"]['id'],
                "collection_id" => $atimSourceAliquot['collection_id'],
                "sample_master_id" => $extraction_sample_master_id,
                'in_stock' => $in_stock,
                'initial_volume' => $initial_volume,
                'current_volume' => $initial_volume,
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
                    "Aliquot defined as not in stock but storage information and positions have been defined for the aliquot. Storage information and position won't be migrated. Please validate. [Message type #".__LINE__."]",
                    "See position information for aliquot defined by $excelSourceAliquotInfoForMsg for participant $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
            } else {
                $aliquot_data['aliquot_masters']['storage_master_id'] = $storage_master_id;
                if(strlen($storage_coord_x)) $aliquot_data['aliquot_masters']['storage_coord_x'] = $storage_coord_x;
                if(strlen($storage_coord_y)) $aliquot_data['aliquot_masters']['storage_coord_y'] = $storage_coord_y;
            }
        }
        $aliquotMasterId = customInsertRecord($aliquot_data);  
        if($volumeForInternalUse) {
            $createdRecordsCounter['quantity source used for extraction']++;
            customInsertRecord(array(
                'aliquot_internal_uses' => array(
                    'aliquot_master_id' => $aliquotMasterId,
                    'type' => 'internal use',
                    'used_volume' => $volumeForInternalUse,
                    'use_code' => 'From XLS file')));
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
                        "Wrong position definition for a 'box81 1A-9I'. Position won't be migrated. Please validate. [Message type #".__LINE__."]",
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
    } else if(strlen($storageDataFromExcel['x'].$storageDataFromExcel['y'].$storageDataFromExcel['Temperature'])) {
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

?>
		