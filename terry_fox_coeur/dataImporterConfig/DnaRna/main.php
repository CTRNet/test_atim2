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
$fileName = $bank_excel_files[0];
global $unmigratedData;
$unmigratedData = array();
$createdRecordsCounter = array(
    'collections created' => 0,
    'blood samples created' => 0,
    'tissue samples created' => 0,
    'FFPE blocks created' => 0,
    'OCT blocks created' => 0,
    'tissue tubes created' => 0,
    'tissue cores created' => 0,
    'tissue slides created' => 0
);
global $dnaAmplifcations;
$dnaAmplifcations = array();
foreach(array('RNA FFPE', 'RNA FT', 'DNA FFPE tissues', 'DNA Normal', 'DNA FT') as $worksheetName) {
    while($exceldata = getNextExcelLineData($fileName, $worksheetName)) {
        list($excelLineCounter, $excelLineData) = $exceldata;
        // === Get ATiM Participant ===
        $participantId = getParticipantId($excelLineData, $worksheetName, $excelLineCounter);
        if($participantId) {
            list($participantId, $excelParticipantAtimNbr, $excelParticipantBankNbr) = $participantId;
            // === Manage data to display in summary ===
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
            $atimSourceAliquot = addCoreSlideAliquotSource($atimSourceAliquot, $excelSourceType, $excelAliquotName, $excelSampleLabel, $excelLineData, $worksheetName, $excelLineCounter, $participantId, $excelParticipantAtimNbr, $excelParticipantBankNbr, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg);
        
        
        

        
        } // End if participant id
    } // End new worksheet line
    //TODO
    if(isset($dnaAmplifcations[$worksheetName])) {
        pr("TODO dna extraction");
//        pr($dnaAmplifcations[$worksheetName]);
    }
}

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

dislayErrorAndMessage($commitAll);

echo "<br><FONT COLOR=\"red\">
=====================================================================<br>
<b>EXTRACTION NOT CREATED : TO REVIEW</b><br>
=====================================================================</FONT><br><br>";

foreach($unmigratedData AS $tmpWorkSheet => $allLinesData) {
    $firstRecord = true;
    foreach($allLinesData as $lineData) {
        if($firstRecord) {
            echo "<br><br>\"Worksheet : $tmpWorkSheet\"<br><br>";
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

exit;



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
            $errorTitle,
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
                $errorTitle,
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
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Participant Definition',
                        '@@WARNING@@',
                        "ATiM and Excel participants match on Participant ATiM # but the Participant Bank # values do not match. Data of the line will be migrated but please validate.",
                        "See Participant Bank # '$participantBankNbr'(excel) and '".$participant['qc_tf_bank_identifier']."'(ATIM) for Participant ATiM # '$participantAtimNbr' defined in sheet '$worksheetName' line $excelLineCounter.");
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
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Participant Definition',
                        '@@WARNING@@',
                        "ATiM and Excel participants match on Participant ATiM # but the Bank values do not match. Data of the line will be migrated but please validate.",
                        "See banks '$bank'(excel) and '".$participant['bank_name']."'(ATIM) for Participant ATiM# '$participantAtimNbr' ".($participantBankNbr? " and Participant Bank # $participantBankNbr": '')." defined in sheet '$worksheetName' line $excelLineCounter.");
                } else {
                    $validationOnBank = true;
                }
            }
            if(!$validationOnBank && !$validationOnparticipantBankNbr) {
                if(!$bank && !$participantBankNbr) {
                    $titlePrecision = "but both bank and Participant Bank # are not defined into Excel";
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Participant Definition',
                        '@@WARNING@@',
                        "ATiM and Excel participants match on Participant ATiM # $titlePrecision. Data of the line will be migrated but please validate.",
                        "See Participant ATiM # '$participantAtimNbr' ".($participantBankNbr? " and Participant Bank # $participantBankNbr": '').($bank? " and bank $bank": '')." defined in sheet '$worksheetName' line $excelLineCounter.");
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
                $errorTitle,
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
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Participant Definition',
                        '@@WARNING@@',
                        "ATiM and Excel participants match on Participant Bank # but the Bank values do not match. Data of the line will be migrated but please validate.",
                        "See banks '$bank'(excel) and '".$participant['bank_name']."'(ATIM) for Participant Bank # '$participantBankNbr' defined in sheet '$worksheetName' line $excelLineCounter.");
                }
            } else {
                recordErrorAndMessage($worksheetName .' :: ' .
                    'Participant Definition',
                    '@@WARNING@@',
                    "ATiM and Excel participants match on Participant Bank # but bank values can not be validated. Data of the line will be migrated but please validate.",
                    "See Participant ATiM# '$participantAtimNbr' ".($bank? " and bank $bank": '')." defined in sheet '$worksheetName' line $excelLineCounter.");
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
                $errorTitle,
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
            $sql = "SELECT barcode, aliquot_label, block_type, qc_tf_storage_solution, participant_id, AM.collection_id, sample_master_id, AM.id AS aliquot_master_id, initial_specimen_sample_id, initial_specimen_sample_type, parent_id, parent_sample_type
                FROM aliquot_masters AM
                INNER JOIN sample_masters SM ON SM.id = AM.sample_master_id
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
            // If buffy coat... special management
            $bfcSpecialKey = 'BFC###SPECIAL KEY ###'.__LINE__;
            if(!$aliquotSources && $typeOfSourceAliquotForMsg == 'Buffy Coat tube') {
                $sql = "SELECT null AS barcode, null AS aliquot_label, null AS block_type, null AS qc_tf_storage_solution, participant_id, SM.collection_id, SM.id AS sample_master_id, null AS aliquot_master_id, initial_specimen_sample_id, initial_specimen_sample_type, parent_id, parent_sample_type
                    FROM sample_masters SM
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
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Aliquot Source Definition',
                        '@@WARNING@@',
                        "No $typeOfSourceAliquotForMsg exists into ATiM for the participant selected by the script but a Buffy Coat sample already exists. No tube of Buffy coat will be created but extraction will be linked to this existing sample. (worksheet : $worksheetName)",
                        "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                    $aliquotSources = array($bfcSpecialKey => array($bfcs[0]));
                }
                if(!$aliquotSources) {
                    $sql = "SELECT null AS barcode, null AS aliquot_label, null AS block_type, null AS qc_tf_storage_solution, participant_id, SM.collection_id, SM.id AS sample_master_id, null AS aliquot_master_id, initial_specimen_sample_id, initial_specimen_sample_type, parent_id, parent_sample_type
                        FROM sample_masters SM
                        INNER JOIN collections COL ON COL.id = SM.collection_id
                        WHERE SM.deleted <> 1
                        AND sample_control_id = ".$atim_controls['sample_controls']['blood']['id'] ."
                        AND COL.participant_id = $participantId";
                    $bloods = array();
                    foreach(getSelectQueryResult($sql) as $newBlood) {
                        $bloods[] = $newBlood;
                    }
                    if(sizeof($bloods) == 1) {
                        $aliquotSources = array($bfcSpecialKey => array($bloods[0]));
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Aliquot Source Definition',
                            '@@WARNING@@',
                            "No $typeOfSourceAliquotForMsg exists into ATiM for the participant selected by the script but a Blood sample already exists. No tube of Buffy coat will be created but extraction will be linked to this blood sample. (worksheet : $worksheetName)",
                            "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                    } else {
                        // Create a new collection
                        $createdRecordsCounter['collections created']++;
                        $collection_id = customInsertRecord(array(
                            'collections' => array(
                                'participant_id' => $participantId,
                                'collection_property' => 'participant collection',
                                'collection_notes'=>'Created by script to track DNA/RNA blood from excel on '.substr($import_date, 0,10) .'.')));
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
                        $aliquotSources = array(
                            $bfcSpecialKey => array(array(
                                'barcode' => '',
                                'aliquot_label' => '',
                                'block_type' => '',
                                'qc_tf_storage_solution' => '',
                                'participant_id' => $participantId,
                                'collection_id' => $collection_id,
                                'sample_master_id' => $blood_sample_master_id,
                                'aliquot_master_id' => '',
                                'initial_specimen_sample_id' => $blood_sample_master_id,
                                'initial_specimen_sample_type' => 'blood', 
                                'parent_id' => '',
                                'parent_sample_type' => '')));
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Aliquot Source Definition',
                            '@@WARNING@@',
                            "No $typeOfSourceAliquotForMsg exists into ATiM for the participant selected by the script and more than one Blood sample already exists. New collection and blood sample will be created and extraction will be linked to this blood sample. (worksheet : $worksheetName)",
                            "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                    }
                }
            }            
            if(!$aliquotSources) {
                $errorTitle = "No $typeOfSourceAliquotForMsg exists into ATiM for the participant selected by the script. No data of the line will be migrated. Please confirm. (worksheet : $worksheetName)";
                recordErrorAndMessage($worksheetName .' :: ' .
                    'Aliquot Source Definition',
                    '@@ERROR@@',
                    $errorTitle,
                    "See excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
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
                            $selectedAliquotKey = array();
                            foreach($tmpAllAliquotLabels as $labelTotest) {
                                if(preg_match('/\-'.$pattern.'$/', $labelTotest)) {
                                    $selectedAliquotKey[] = $labelTotest;
                                }
                            }
                            if(sizeof($selectedAliquotKey) == 1) {
                                $selectedAliquotKey = $selectedAliquotKey[0];
                                recordErrorAndMessage($worksheetName .' :: ' .
                                    'Aliquot Source Definition',
                                    '@@WARNING@@',
                                    "More than one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant but the ATiM aliquot label match approximatively the Excel aliquot information. Data of the line will be migrated and linked to this $typeOfSourceAliquotForMsg but please validate.",
                                    "See ATiM aliquot label [$selectedAliquotKey] and Excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                            } else {
                                $selectedAliquotKey = '';
                            }
                        }
                    } else {
                        $selectedAliquotKey = $tmpAllAliquotLabels[0];
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Aliquot Source Definition',
                            '@@WARNING@@',
                            "Only one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant but the ATiM aliquot label does not match the Excel aliquot information. Data of the line will be migrated and linked to this $typeOfSourceAliquotForMsg but please validate.",
                            "See ATiM aliquot label [$selectedAliquotKey] and Excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                    }
                }
                if($selectedAliquotKey) {
                    $selectedAtimAliquotSource = null;
                    if(!isset($aliquotSources[$selectedAliquotKey])) {
                        die("ERR823798273927");
                    } else if(sizeof($aliquotSources[$selectedAliquotKey]) > 1) {
                        recordErrorAndMessage($worksheetName .' :: ' .
                            'Aliquot Source Definition',
                            '@@WARNING@@',
                            "More than one $typeOfSourceAliquotForMsg exists into ATiM for the selected participant and match the ATiM aliquot label . Data of the line will be migrated and linked to the first $typeOfSourceAliquotForMsg but please validate.",
                            "See ATiM aliquot label [$selectedAliquotKey] and Excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                        return $aliquotSources[$selectedAliquotKey][0];
                    } else {
                        return $aliquotSources[$selectedAliquotKey][0];
                    }
                } else {
                    /*
                    $errorTitle = "System is not able to define the $typeOfSourceAliquotForMsg source used for the extraction into ATiM. No data of the line will be migrated. Please confirm. (worksheet : $worksheetName)";
                    $aliquotSources = array_keys($aliquotSources);
                    $aliquotSources = implode (' && ', $aliquotSources);
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Aliquot Source Definition',
                        '@@ERROR@@',
                        $errorTitle,
                        "See $typeOfSourceAliquotForMsg ATiM aliquot(s) [$aliquotSources] and excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
                    addUnmigratedLine($excelLineData, $worksheetName, $excelLineCounter, $errorTitle);
                    return null;       
                    */
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
                    $warningTitle = "System is not able to define the $typeOfSourceAliquotForMsg source (form those of the participant) used for the extraction into ATiM. A new collection, tissue and block (with in stock no) will be created then linked to the extraction. Please confirm. (worksheet : $worksheetName)";
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
                                "sample_control_id" => $atim_controls['sample_controls']['blood']['id'],
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
                            'notes' => 'Created by script to track DNA/RNA blood from excel on '.substr($import_date, 0,10) .'.'),
                        $atim_controls['aliquot_controls'][$controltype]['detail_tablename'] => $detail_data);
                    $aliquotMasterId = customInsertRecord($aliquot_data);
                    $aliquotSources = array_keys($aliquotSources);
                    $aliquotSources = implode ('</b> & <b>', $aliquotSources);
                    recordErrorAndMessage($worksheetName .' :: ' .
                        'Aliquot Source Definition',
                        '@@WARNING@@',
                        $warningTitle,
                        "See $typeOfSourceAliquotForMsg ATiM aliquot(s) [<b>$aliquotSources</b>] and excel aliquot defined by $excelSourceAliquotInfoForMsg for $excelParticipantInfoForMsg in sheet '$worksheetName' line $excelLineCounter.");
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
                        'parent_id' => '',
                        'parent_sample_type' => '');
                }
            }
        }
    }
    die('ERR 467383390');
}

function addUnmigratedLine($excelLineData, $worksheetName, $excelLineCounter, $error) {
    global $unmigratedData;
    $unmigratedData[$worksheetName][] = array_merge($excelLineData, array('line' => $excelLineCounter, 'error' => $error));
}

function addCoreSlideAliquotSource($atimSourceAliquot, $excelSourceType, $excelAliquotName, $excelSampleLabel, $excelLineData, $worksheetName, $excelLineCounter, $participantId, $excelParticipantAtimNbr, $excelParticipantBankNbr, $excelParticipantInfoForMsg, $excelSourceAliquotInfoForMsg) {
    global $atim_controls ;
    global $createdRecordsCounter;
    global $dnaAmplifcations;
    global $import_date;

    if($atimSourceAliquot && $excelSourceType) {
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
        if($controltype && $atimSourceAliquot['sample_master_id'] == $atimSourceAliquot['initial_specimen_sample_id'] && $atimSourceAliquot['initial_specimen_sample_type'] == 'tissue') {
            $createdRecordsCounter[$counterKey]++;
            $aliquot_data = array(
                'aliquot_masters' => array(
                    "barcode" => 'tmp_core_'.$createdRecordsCounter[$counterKey],
                    'aliquot_label' => $atimSourceAliquot['aliquot_label'],
                    "aliquot_control_id" => $atim_controls['aliquot_controls'][$controltype]['id'],
                    "collection_id" => $atimSourceAliquot['collection_id'],
                    "sample_master_id" => $atimSourceAliquot['sample_master_id'],
                    'in_stock' => 'no',
                    'notes' => 'Created by script to track DNA/RNA blood from excel on '.substr($import_date, 0,10) .'.'),
                $atim_controls['aliquot_controls'][$controltype]['detail_tablename'] => array());
            $aliquotMasterId = customInsertRecord($aliquot_data);
            $realiquoting_data = array('realiquotings' => array(
                'parent_aliquot_master_id' => $atimSourceAliquot['aliquot_master_id'],
                'child_aliquot_master_id' => $aliquotMasterId));
            customInsertRecord($realiquoting_data);
            return array(
                'barcode' => '',
                'aliquot_label' => $atimSourceAliquot['aliquot_label'],
                'block_type' => '',
                'qc_tf_storage_solution' => '',
                'participant_id' => $atimSourceAliquot['participant_id'],
                'collection_id' => $atimSourceAliquot['collection_id'],
                'sample_master_id' => $atimSourceAliquot['sample_master_id'],
                'aliquot_master_id' => $aliquotMasterId,
                'initial_specimen_sample_id' => $atimSourceAliquot['initial_specimen_sample_id'],
                'initial_specimen_sample_type' => 'tissue',
                'parent_id' => '',
                'parent_sample_type' => '');
        }
    }
    return $atimSourceAliquot;
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
        recordErrorAndMessage($worksheetName .' :: ' .
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

global $parentAliquotAtimControlCollectionId;
$parentAliquotAtimControlCollectionId = null;

global $tmaBlocks;
$tmaBlocks = array();

$createdExcelCoresCounter = 0;
$excelCoresCounter = 0;
global $revisionCounter;
$revisionCounter = 0;

$coresNotCreated = array();
$blockToCoreWarning = array();

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
        recordErrorAndMessage($worksheetName .' :: ' .
            'Summary',
            '@@ERROR@@',
            "TMA not defined into the 'Replicat' file. Only one TMA block duplicat will be created. Please confirm.",
            "See TMA Block $tmaBlockName.");
    }
    
    recordErrorAndMessage($worksheetName .' :: ' .
        $tmaNameAndWorksheet,
        '@@MESSAGE@@',
        "Cores created",
        "$tmaNameAndWorksheet.");
    recordErrorAndMessage($worksheetName .' :: ' .
        $tmaNameAndWorksheet,
        '@@MESSAGE@@',
        "Cores created",
        "Number of duplicated TMA blocks created : $nbrOfTmaBlocksToCreate.");
    
    // Get TMA Block id
    
    $createdExcelWorksheetCoresCounter = 0;
    $excelWorksheetCoresCounter = 0;
    $headersDone = false;
    while($exceldata = getNextExcelLineData($fileName, $worksheetName)) {
        list($excelLineCounter, $excelLineData) = $exceldata;
        
        if(!$headersDone) {
            $headers = array_keys($excelLineData);
            $headers = implode( ' || ', $headers);
            recordErrorAndMessage($worksheetName .' :: ' .
                'Summary',
                '@@MESSAGE@@',
                "Parsed whorksheets : Headers",
                $tmaNameAndWorksheet . " : $headers");
        }        
        $headersDone = true;
        
        // New core to create : Get Excel Data

        $blockNbrKey = 'Numéro Bloc';
        if(!array_key_exists($blockNbrKey, $excelLineData)) {
            if(array_key_exists('Numero Bloc', $excelLineData)) {
                $blockNbrKey = 'Numero Bloc';
            } elseif(array_key_exists('numero bloc', $excelLineData)) {
                $blockNbrKey = 'numero bloc';
            }  elseif(array_key_exists('numéro bloc', $excelLineData)) {
                $blockNbrKey = 'numéro bloc';
            } 
        } 
        $coreNbrKey = 'Numéro Core';
        if(!array_key_exists($coreNbrKey, $excelLineData)) {
            if(array_key_exists('Numero Core', $excelLineData)) {
                $coreNbrKey = 'Numero Core';
            } elseif(array_key_exists('numero core', $excelLineData)) {
                $coreNbrKey = 'numero core';
            }  elseif(array_key_exists('numéro core', $excelLineData)) {
                $coreNbrKey = 'numéro core';
            } 
        }
        if(!(array_key_exists('TFRI', $excelLineData) && 
        array_key_exists($blockNbrKey, $excelLineData) && 
        array_key_exists($coreNbrKey, $excelLineData) && 
        array_key_exists('X', $excelLineData) && 
        array_key_exists('Y', $excelLineData) && 
        array_key_exists('TMA', $excelLineData))) {
            $tmpHeaders = array_keys($excelLineData);
            recordErrorAndMessage($worksheetName .' :: ' .
                $tmaNameAndWorksheet,
                '@@ERROR@@',
                "Worksheet headers are not these one the script expected [ TFRI | $blockNbrKey | $coreNbrKey | X | Y | TMA ]. Not data of the worksheet will be imported!",
                "See headers [ ".implode(' | ', $tmpHeaders)." ].",
                $tmaNameAndWorksheet);
            if(!((isset($excelLineData['TFRI']) && $excelLineData['TFRI'] == '.')
            || (isset($excelLineData[$blockNbrKey]) && $excelLineData[$blockNbrKey] == '.')
            || (isset($excelLineData[$coreNbrKey]) && $excelLineData[$coreNbrKey] == '.'))) {
                $excelWorksheetCoresCounter++;
                $excelCoresCounter++;
            }
            continue;
            
        }
        $participantIdentifier = $excelLineData['TFRI'];
        $blockAliquotLabel = $excelLineData[$blockNbrKey];
        $coreNbr = $excelLineData[$coreNbrKey];
        $storageCoordX = $excelLineData['X'];
        $storageCoordY = $excelLineData['Y'];
        if($tmaBlockName != $excelLineData['TMA']) {
            recordErrorAndMessage($worksheetName .' :: ' .
                $tmaNameAndWorksheet,
                '@@WARNING@@',
                "TMA bloc name is not consistant between the worksheet name and the line cell 'TMA'. TMA name from worksheet will be used but please validate.",
                "See [$tmaBlockName] != [".$excelLineData['TMA']."] on line $excelLineCounter (and more).",
                $tmaBlockName . '###' . $excelLineData['TMA']);
        }
        
        if(($participantIdentifier == '.' || $participantIdentifier == '') && ($blockAliquotLabel == '.' || $blockAliquotLabel == '') && ($coreNbr == '.' || $coreNbr == '')) continue;
                
        $excelWorksheetCoresCounter++;
        $excelCoresCounter++;
        
        $coreHasBeenCreated = false;
        
        // Get ATiM Tissue Block id
        list($atimBlockCollectionId, $atimBlockSampleMasterId, $atimBlockAliquotMasterId, $blockaliquotSelectedLabel, $warning_to_add_to_notes, $warning_to_add_to_notes_category) = getATiMBlock($participantIdentifier, $blockAliquotLabel, $coreNbr, $tmaNameAndWorksheet, $excelLineCounter);
        if(!$atimBlockAliquotMasterId) {
            // Error managed into getATiMBlock()
        } else {
            if($atimBlockCollectionId == $parentAliquotAtimControlCollectionId) {
                recordErrorAndMessage($worksheetName .' :: ' .
                    $tmaNameAndWorksheet,
                    '@@WARNING@@',
                    "Core created as a 'Control' (Linked to the collection of controls). Please validate.",
                    "See core [$blockAliquotLabel] on line $excelLineCounter.");
            }
            
            $createdExcelCoresCounter++;  
            $createdExcelWorksheetCoresCounter++;
            
            // Create core(s)
            $aliquotLabelSuffix = array();
            $zone = '';
            $rank = '';
            $notes = array();
            if($warning_to_add_to_notes) {
                $blockToCoreWarning[] = array(
                    $participantIdentifier,
                    $blockaliquotSelectedLabel,
                    $blockAliquotLabel,
                    $tmaBlockName,
                    $warning_to_add_to_notes_category,
                    "X$nbrOfTmaBlocksToCreate",
                    $tmaNameAndWorksheet,
                    $excelLineCounter
                );
                $notes[] = "A warning was generated by the script executed on '".substr($import_date, 0, 10)."' to create the core and the link between the core and the block. Please review migration summary for more details (I:\Inter_Equipe\MesMasson_AnneMarie\Projets_Inter_Equipe_Atim_IE\COEUR\OUT).";
            }
            if(isset($excelLineData['numero blocs avec Zone']) && strlen($excelLineData['numero blocs avec Zone']) && $excelLineData['numero blocs avec Zone'] != '.') {
                $regExp = str_replace('-', '\-', $blockAliquotLabel.'-');
                if(preg_match("/$regExp/", $excelLineData['numero blocs avec Zone'])) {
                    $zone = str_replace($blockAliquotLabel.'-', '', $excelLineData['numero blocs avec Zone']);;
                   $aliquotLabelSuffix[] = 'Z#' . $zone;
                   
                } else {
                    $zone = str_replace($blockAliquotLabel.'-', '', $excelLineData['numero blocs avec Zone']);
                    if(strlen($zone)) {
                        $aliquotLabelSuffix[] =  'Z#'  . $zone;
                    }
                }
            }
            if(!preg_match('/^[0-9]*$/', $zone)) {
                $notes[] = "Zone = '$zone'.";
                $zone = '';
            }          
            if(isset($excelLineData['Rang global']) && strlen($excelLineData['Rang global']) && $excelLineData['Rang global'] != '.') {
                $aliquotLabelSuffix[] =  'R#'  . $excelLineData['Rang global'];
                $rank = $excelLineData['Rang global'];
            }
            if(!preg_match('/^[0-9]*$/', $rank)) {
                $notes[] = "Rank = '$rank'.";
                $rank = '';
            } 
            if(isset($excelLineData['post chimio']) && strlen($excelLineData['post chimio']) && $excelLineData['post chimio'] != '.') {
                if($excelLineData['post chimio'] == '(post chimio)') {
                    $aliquotLabelSuffix =  'Post Chemo';
                    $notes[] = 'Post Chemo.';
                } else {
                    pr('ERR 823982379872 : '.$excelLineData['post chimio']);
                }
                
            }
            $aliquotLabelSuffix = implode(' ', $aliquotLabelSuffix);
            $blockAliquotLabel = "$blockAliquotLabel" . ((strlen($coreNbr) && $coreNbr != '.')? "#$coreNbr" : "") . ($aliquotLabelSuffix? ' ' .$aliquotLabelSuffix : '');
            
            $storageCoordX = $excelLineData['X'];
            $storageCoordY = $excelLineData['Y'];
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
                        'notes' => implode(' ', $notes)),
                    $atim_controls['aliquot_controls']['tissue-core']['detail_tablename'] => array(
                        'qc_tf_zone' => $zone,
                        'qc_tf_rank' => $rank
                    ));
                $coreAliquotMasterId = customInsertRecord($aliquot_data);
                $coreHasBeenCreated = true;
                
                $realiquoting_data = array('realiquotings' => array(
                    'parent_aliquot_master_id' => $atimBlockAliquotMasterId,
                    'child_aliquot_master_id' => $coreAliquotMasterId));
                customInsertRecord($realiquoting_data);
                // Revision
                if($tmaBlockSuffix == 1) createRevision($participantIdentifier, $blockAliquotLabel, $atimBlockCollectionId, $atimBlockSampleMasterId, $coreAliquotMasterId, $excelLineData, $excelLineCounter);
            }
        }
        if(!$coreHasBeenCreated) {
            $coresNotCreated[$tmaNameAndWorksheet][] = $excelLineData;
        }
    }
    recordErrorAndMessage($worksheetName .' :: ' .
        'Summary',
        '@@MESSAGE@@',
        "Cores created",
        "$tmaNameAndWorksheet : $createdExcelWorksheetCoresCounter/$excelWorksheetCoresCounter cores created (X$nbrOfTmaBlocksToCreate Blocks).");
    recordErrorAndMessage($worksheetName .' :: ' .
        $tmaNameAndWorksheet,
        '@@MESSAGE@@',
        "Cores created",
        "$tmaNameAndWorksheet : $createdExcelWorksheetCoresCounter/$excelWorksheetCoresCounter cores created (X$nbrOfTmaBlocksToCreate Blocks).");
}

if($tmaReplicatsInfo) {
    foreach($tmaReplicatsInfo AS $tmaBlockName => $tmp) {
        recordErrorAndMessage($worksheetName .' :: ' .
            'Summary',
            '@@ERROR@@',
            "TMA defined into the 'Replicat' file is not listed into the TMA data file. TMA won't be created. Please confirm.",
            "See TMA Block name $tmaBlockName.");
    }
}

recordErrorAndMessage($worksheetName .' :: ' .
    'Summary',
    '@@MESSAGE@@',
    "Cores created",
    "All TMAs : $createdExcelCoresCounter/$excelCoresCounter cores created.");
    
recordErrorAndMessage($worksheetName .' :: ' .
    'Summary',
    '@@MESSAGE@@',
    "Cores created",
    "$revisionCounter cores revisions have been created.");

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
    recordErrorAndMessage($worksheetName .' :: ' .
        'TMA Slides',
        '@@WARNING@@',
        "Renamed study linked to TMA slide. Please confirm.",
        "The study [$excelTitle] linked to the TMA slides will be renamed to/considered as study [$atimTitle].");
}

recordErrorAndMessage($worksheetName .' :: ' .
    'TMA Slides',
    '@@WARNING@@',
    "Renamed TMA block. Please confirm.",
    "The block [THT.16.015AV1] has been renamed to [THT Ovcare.A.1].");
recordErrorAndMessage($worksheetName .' :: ' .
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
        recordErrorAndMessage($worksheetName .' :: ' .
            'TMA Slides',
            '@@ERROR@@',
            "TMA block does not exist. All slides linked to these block won't be created.",
            "See TMA block [$block].",
            $block);
    } else {
        $tmaBlockStorageMasterId = $tmaBlocks[$block];
    }
    
    if($tmaBlockStorageMasterId) {
        $barcode = "$block #".str_pad($excelLineTmaSlideData['ID Section'], 3, "0", STR_PAD_LEFT);
        
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
                recordErrorAndMessage($worksheetName .' :: ' .
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

recordErrorAndMessage($worksheetName .' :: ' .
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

echo "<br><FONT COLOR=\"red\">
=====================================================================<br>
<b>CORE NOT CREATED : TO REVIEW</b><br>
=====================================================================</FONT><br><br>";

foreach($coresNotCreated AS $tmpWorkSheet => $cores) {
    $firstRecord = true;
    foreach($cores as $newCore) {
        if($firstRecord) {
            echo "<br><br>\"TMA : $tmpWorkSheet\"<br><br>";
            $newLineToDisplay = "\"";
            $headers = array_keys($newCore);
            $newLineToDisplay .= implode("\";\"", $headers);
            $newLineToDisplay .= "\"<br>";
            echo $newLineToDisplay;
        }
        $firstRecord = false;
        $newLineToDisplay = "\"";
        $newLineToDisplay .= implode("\";\"", $newCore);
        $newLineToDisplay .= "\"<br>";
        echo $newLineToDisplay;
    }
}

echo "<br><FONT COLOR=\"red\">
=====================================================================<br>
<b>Links created between excel core and atim block with warning: Treview</b><br>
=====================================================================</FONT><br><br>";

$headers = array(
    'Participant TFRI#',
    'ATiM block label selected by script to link core to block',
    'Excel block label defined as source of the core',
    'TMA',
    'Warning',
    "Nbr of TMAs duplicated",
    'Excel Worksheet',
    'Line'
);
$newLineToDisplay = "\"";
$newLineToDisplay .= implode("\";\"", $headers);
$newLineToDisplay .= "\"<br>";
echo $newLineToDisplay;
foreach($blockToCoreWarning as $newCore) {
    $firstRecord = false;
    $newLineToDisplay = "\"";
    $newLineToDisplay .= implode("\";\"", $newCore);
    $newLineToDisplay .= "\"<br>";
    echo $newLineToDisplay;
}


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
    global $parentAliquotAtimControlCollectionId;
    global $atim_controls;
    global $imported_by;
    $dateOfNewBlockCreation = '2019-02-12 01:01:01';
    
//    $excelBlockUniqueKey = $tmaNameAndWorksheet.'###'.$participantIdentifier.'###'.$blockAliquotLabel;
    $excelBlockUniqueKey = ($participantIdentifier == '.'? '' : $participantIdentifier).'###'.$blockAliquotLabel;
    
    if(!isset($atimBlockSelectionData[$excelBlockUniqueKey])) {
        $warning_to_add_to_notes = false;
        $warning_to_add_to_notes_category = '';
        $blockCollectionMasterId = null;
        $blockSampleMasterId = null;
        $blockAliquotMasterId = null;
        $blockaliquotLabel = '';
        if(($participantIdentifier == '.' || $participantIdentifier == '')) { // && ($coreNbr == '.' || $coreNbr == '')) {
            
            // We are looking for a control block
            if(!$parentAliquotAtimControlCollectionId) {
                $query = "SELECT id FROM collections WHERE collection_property = 'independent collection' AND collection_notes = 'Controls' AND deleted <> 1";
                $controlCollection = getSelectQueryResult($query);
                if(sizeof($controlCollection) != 1) die('ERR 287239237987');
                $parentAliquotAtimControlCollectionId = $controlCollection[0]['id'];
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
                AND Collection.id = $parentAliquotAtimControlCollectionId
                AND AliquotMaster.deleted <> 1
                AND AliquotMaster.aliquot_control_id = 8
                AND AliquotMaster.aliquot_label = 'CONTROL ".str_replace("'", "''", $blockAliquotLabel)."'";
            $parentAliquotAtimControlBlocks = getSelectQueryResult($query);
            if($parentAliquotAtimControlBlocks) {
                pr($parentAliquotAtimControlBlocks);
                pr($blockAliquotLabel);
                
                die('ERR 287239237987xxxx');
            }
            
            // Create a new block
            $sampleData = array(
                'sample_masters' => array(
                    "sample_code" => 'tmp_tissue_'.$blockAliquotLabel,
                    "sample_control_id" => $atim_controls['sample_controls']['tissue']['id'],
                    "initial_specimen_sample_type" => 'tissue',
                    "collection_id" => $parentAliquotAtimControlCollectionId),
                'specimen_details' => array(),
                $atim_controls['sample_controls']['tissue']['detail_tablename'] => array());
            $parentAliquotAtimControlTissueSampleMasterId = customInsertRecord($sampleData);
            $aliquot_data = array(
                'aliquot_masters' => array(
                    "barcode" => 'tmp_'.$blockAliquotLabel,
                    'aliquot_label' => "CONTROL ".str_replace("'", "''", $blockAliquotLabel),
                    "aliquot_control_id" => $atim_controls['aliquot_controls']['tissue-block']['id'],
                    "collection_id" => $parentAliquotAtimControlCollectionId,
                    "sample_master_id" => $parentAliquotAtimControlTissueSampleMasterId
                ),
                $atim_controls['aliquot_controls']['tissue-block']['detail_tablename'] => array(
                    'block_type' => 'paraffin',
                    'patho_dpt_block_code' => str_replace("'", "''", $blockAliquotLabel)
                ));
            $parentAliquotAtimControlAliquotMasterId = customInsertRecord($aliquot_data);
            recordErrorAndMessage($worksheetName .' :: ' .
                'Summary',
                '@@MESSAGE@@',
                "New Tissue block 'CONTROL' creation.",
                "Created tissue block as control : CONTROL $blockAliquotLabel");
            $blockCollectionMasterId = $parentAliquotAtimControlCollectionId;
            $blockSampleMasterId = $parentAliquotAtimControlTissueSampleMasterId;
            $blockAliquotMasterId = $parentAliquotAtimControlAliquotMasterId;
            $blockaliquotLabel =  $aliquot_data['aliquot_masters']['aliquot_label'];
            
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
                    recordErrorAndMessage($worksheetName .' :: ' .
                        $tmaNameAndWorksheet,
                        '@@WARNING@@',
                        "The ATiM tissue block can only be found based on an approximative match with participant TFRI# and pathology code. Core will be create but please validate.",
                        "See XLS tissue block with label <b>$blockAliquotLabel</b> and new ATIM tissue block with label <b>".$participantAtimBlocks[0]['aliquot_label']."</b> for participant TFRI# $participantIdentifier. Line $excelLineCounter.$additionalDetail");
                    $warning_to_add_to_notes_category = 'Label approximative match';
                    $warning_to_add_to_notes = true;
                } else if(sizeof($newParticipantBlockDetected) == 1) {
                    $participantAtimBlocks = $newParticipantBlockDetected;
                    recordErrorAndMessage($worksheetName .' :: ' .
                        $tmaNameAndWorksheet,
                        '@@WARNING@@',
                        "The ATiM tissue block selected to create the core has been selected because it's the only one created based on the new XLS file with tissue blocks created in 2019. Core will be create but match has clearly to be validated.",
                        "See XLS tissue block with label <b>$blockAliquotLabel</b> and XLS tissue block with label <b>".$participantAtimBlocks[0]['aliquot_label']."</b> for participant TFRI# $participantIdentifier. Line $excelLineCounter.$additionalDetail");
                    $warning_to_add_to_notes = true;
                    $warning_to_add_to_notes_category = 'No label match - Unique block selected';
                } else {
                    if(trim($participantIdentifier) == '.' || trim($participantIdentifier) == '' ) {
                        recordErrorAndMessage($worksheetName .' :: ' .
                            $tmaNameAndWorksheet,
                            '@@ERROR@@',
                            "The ATiM tissue block can not be found based on participant TFRI# and pathology code but please check core is not a control. Core won't be created. Create core manually into ATiM after the migration.",
                            "See tissue block with label <b>".((strlen($blockAliquotLabel) && $blockAliquotLabel != '.')? $blockAliquotLabel : 'no value').
                                "</b> created for participant TFRI# <b>".((strlen($participantIdentifier) && $participantIdentifier != '.')? $participantIdentifier : 'no value').
                                "</b> and core# <b>".((strlen($coreNbr) && $coreNbr != '.')? $coreNbr : 'no value').
                                "</b>. Line $excelLineCounter.$additionalDetail");
                    } else {
                        recordErrorAndMessage($worksheetName .' :: ' .
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
                    recordErrorAndMessage($worksheetName .' :: ' .
                        $tmaNameAndWorksheet,
                        '@@WARNING@@',
                        "More than one ATiM tissue block has been selected based on participant TFRI# and pathology code. Core will be created then linked to one of these ATiM tissue blocks but please validate into ATiM after the migration.",
                        "See XLS tissue block with label <b>$blockAliquotLabel</b> matching ATiM Tissue blocks <b>$atimLabels</b> created for participant TFRI# $participantIdentifier define on line $excelLineCounter.");
                    $warning_to_add_to_notes = true;
                    $warning_to_add_to_notes_category = 'More than one block matchs on label - First block used';
                    foreach($participantAtimBlocks as $key => $tmpBlock) {
                        if(!$firstBlockAvailableKey && $tmpBlock['in_stock'] != 'no') {
                            $firstBlockAvailableKey = $key;
                        } 
                    }
                }
                if(is_null($firstBlockAvailableKey)) $firstBlockAvailableKey = '0';
                if($participantAtimBlocks[$firstBlockAvailableKey]['in_stock'] == 'no') {
                    recordErrorAndMessage($worksheetName .' :: ' .
                        $tmaNameAndWorksheet,
                        '@@WARNING@@',
                        "The ATiM tissue block selected based on participant TFRI# and pathology code is defined as 'Not In Stock'. Core will be created then linked to this ATiM tissue block but please validate.",
                        "See ATiM tissue block with label <b>".$participantAtimBlocks[$firstBlockAvailableKey]['aliquot_label']."</b> matching XLS label <b>$blockAliquotLabel</b> and created for participant TFRI# $participantIdentifier. Line $excelLineCounter.");
                }
                $blockCollectionMasterId = $participantAtimBlocks[$firstBlockAvailableKey]['block_collection_id'];
                $blockSampleMasterId = $participantAtimBlocks[$firstBlockAvailableKey]['block_sample_master_id'];
                $blockAliquotMasterId = $participantAtimBlocks[$firstBlockAvailableKey]['block_aliquot_master_id'];
                $blockaliquotLabel = $participantAtimBlocks[$firstBlockAvailableKey]['aliquot_label'];
            }
        }
        
        $atimBlockSelectionData[$excelBlockUniqueKey] = array($blockCollectionMasterId, $blockSampleMasterId, $blockAliquotMasterId, $blockaliquotLabel, $warning_to_add_to_notes, $warning_to_add_to_notes_category); 
    } elseif(is_null($atimBlockSelectionData[$excelBlockUniqueKey][2])) {
        recordErrorAndMessage($worksheetName .' :: ' .
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

function createRevision($participantIdentifier, $blockAliquotLabel, $collection_id, $sample_master_id, $coreAliquotMasterId, $excelLineData, $excelLineCounter) {
    global $atim_controls;
    global $revisionCounter;

    $revisions = array();
    foreach(array('revision', 'sites', 'Sites', 'revision Rahimi juin2018') as $field) {
        if(isset($excelLineData[$field]) && strlen($excelLineData[$field]) && $excelLineData[$field] != '.') {
            if($field == 'revision Rahimi juin2018') {
                $revisions[] = array('2018=01-01', 'm', 'Dr Rahimi', $excelLineData[$field]);
            } else {
                $revisions[] = array('', '', '', $field. ' : ' . $excelLineData[$field]);
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
		