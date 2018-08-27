<?php
require_once __DIR__.'/system.php';

$is_test_import_process = false;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $is_test_import_process = true;   //Load in db + commit + truncate data imported the today
    } else {
        die('ERR ARG : '.$argv[1].' (should be test)');
    }
}

if($is_test_import_process) truncate();

//==============================================================================================
// Main Code
//==============================================================================================
ini_set('memory_limit', '2048M');

$excel_file_names = $excel_file_names['aliquot_uses'];

if(!testExcelFile($excel_file_names)) {
    dislayErrorAndMessage();
    exit;
}

displayMigrationTitle("MUHC - Transplant Aliquots Migration - Step 2 : Aliquot Uses Creation", $excel_file_names);

$worksheet_name = 'Feuil1';

$aliquot_use_counter = 0;
$aliquot_not_found_counter = 0;
foreach($excel_file_names as $new_file_name) {
    while(list($line_number, $excel_line_data) = getNextExcelLineData($new_file_name, $worksheet_name, 2)) {
        $receveur = str_replace('CHU', '00', $excel_line_data['Receveur']);
        $donneur = str_replace('CHU', '00', $excel_line_data['Donneur']);
        if(strlen($receveur) && strlen($donneur)) {
            pr('TODO 23872837682736 Line : '.$line_number);
            pr($excel_line_data);
        } else if(!strlen($receveur) && !strlen($donneur)) {
            pr('TODO 238722323232736 Line : '.$line_number);
            pr($excel_line_data);
        } else{
            $isReceveur = strlen($receveur)? true : false;
            $participantType = $isReceveur? 'Receveur' : 'Donor';
            $participant_identifier = $receveur.$donneur;
            for($useId = 1; $useId < 4; $useId++) {
                if(!strlen($excel_line_data["use $useId Position"])) {
                    if(strlen($excel_line_data["use $useId Boite"]) || strlen($excel_line_data["use $useId freezer"]) || strlen($excel_line_data["use $useId Quantité retirée (µL)"])) {
                        pr('TODO saew2342 3 Line : '.$line_number);
                        pr($excel_line_data);
                    }
                } else {
                    if(!strlen($excel_line_data["use $useId Boite"]) || !strlen($excel_line_data["use $useId freezer"]) || !strlen($excel_line_data["use $useId Quantité retirée (µL)"])) {
                        pr('TODO 23 23 34t3453 Line : '.$line_number);
                        pr($excel_line_data);
                    } else {
                        $freezer = $excel_line_data["use $useId freezer"];
                        $box = $excel_line_data["use $useId Boite"];
                        $position = $excel_line_data["use $useId Position"];
                        $query = "SELECT * from view_aliquots ViewAliquot INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.id = ViewAliquot.aliquot_master_id
                            WHERE ViewAliquot.selection_label LIKE '$freezer-%-$box' AND ViewAliquot.storage_coord_x = '$position' AND ViewAliquot.storage_coord_y IS NULL;";
                        $atim_data = getSelectQueryResult($query);
                        if(sizeof($atim_data) > 1) {
                            pr('TODO 3343434t3453 Line : '.$line_number);
                            pr($excel_line_data);
                            pr($atim_data);
                            $aliquot_not_found_counter++;
                        } else if(sizeof($atim_data) == 0) {  
                            recordErrorAndMessage('Participant Aliquot Definition', 
                                '@@ERROR@@', 
                                "No aliquot found into ATiM based on position. No aliquot use will be created. Please validate.", 
                                "The aliquot of the participant '$participant_identifier' defined as stored into freezer '$freezer', box '$box' and position '$position' does not exist into ATiM. See line $line_number.");
                            $aliquot_not_found_counter++;
                            
                        } else {
                            $atim_data = $atim_data[0];
                            if($participant_identifier != $atim_data['identifier_value'])
                            {
                                recordErrorAndMessage('Participant Aliquot Definition', 
                                    '@@ERROR@@', 
                                    "Wrong participant of a listed aliquot found into ATiM based on position. No aliquot use will be created. Please validate.", 
                                    "The aliquot found into ATiM [barcode='".$atim_data['barcode']."] based on freezer '$freezer', box '$box' and position '$position' is defined as the aliquot of participant '".$atim_data['identifier_value']."' but in excel the participant is defined as '$participant_identifier'. The position of the ATiM aliquot into the specimen xls file was '".$atim_data['notes']." for information. See line $line_number.");
                                $aliquot_not_found_counter++;
                            } else {
                                $aliquot_use_counter++;
                                $aliquot_use_data = array(
                                    'aliquot_internal_uses' => array(
                                        'type' => 'internal use',
                                        'use_code' => 'Imported from Excel File',
                                        'use_details' => "Created on ".substr($import_date, 0, 10)." from excel file '$new_file_name' line '$line_number'.",
                                        'aliquot_master_id' => $atim_data['aliquot_master_id']));
                                if(strlen($excel_line_data["use $useId Quantité retirée (µL)"])) {
                                    $used_volume = str_replace(',','.',$excel_line_data["use $useId Quantité retirée (µL)"]);
                                    if(preg_match('/^[0-9]+(\.[0-9]+){0,1}$/', $used_volume)) {
                                        $aliquot_use_data['aliquot_internal_uses']['used_volume'] = $used_volume/1000;
                                        if(!strlen($atim_data['initial_volume'])) {
                                            recordErrorAndMessage('Participant Aliquot Definition',
                                                '@@ERROR@@',
                                                "Use of an aliquot with no current volume defined. Used volume won't be recorded. Please validate.",
                                                "The ".$atim_data['sample_type']."-".$atim_data['aliquot_type']." found into ATiM [barcode='".$atim_data['barcode']."] based on freezer '$freezer', box '$box' and position '$position' is defined as used with a used volume value but no current volume exists into ATim for this aliquot. See line $line_number.");
                                        } else {
                                            $current_volume = $atim_data['current_volume'] - ($used_volume/1000);
                                            if($current_volume <= 0) {
                                                $current_volume = 0;
                                                recordErrorAndMessage('Participant Aliquot Definition',
                                                    '@@WARNING@@',
                                                    "Current volume of an aliquot is set to 0. Please validate and update the in stock value to 'No' after the migration into ATim.",
                                                    "The ".$atim_data['sample_type']."-".$atim_data['aliquot_type']." found into ATiM [barcode='".$atim_data['barcode']."] based on freezer '$freezer', box '$box' and position '$position' is defined as used and now as empty. See line $line_number.");
                                            }
                                            updateTableData($atim_data['aliquot_master_id'], array('aliquot_masters' => array('current_volume' => $current_volume)));
                                        }
                                    } else {
                                        pr('TODO 33434121111453 Line : '.$line_number);
                                        pr($excel_line_data);
                                        pr($atim_data);
                                    }                                    
                                }
                                customInsertRecord($aliquot_use_data);
                            }
                        }
                    }
                }
            }
        }
    } 
}

recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$aliquot_use_counter aliquot uses created.");
recordErrorAndMessage('Summary', '@@MESSAGE@@', "Data Creation Counter", "$aliquot_not_found_counter aliquot not found.");

$final_queries = array();


if(!$is_test_import_process) {
    $final_queries[] = "UPDATE versions SET permissions_regenerated = 0;";
} else {
    addViewUpdate($final_queries);
}


foreach($final_queries as $new_query) customQuery($new_query);
//TODO
pr("TODO remove line is_test_import_process = false;");
$is_test_import_process = false;

insertIntoRevsBasedOnModifiedValues();
dislayErrorAndMessage(!$is_test_import_process);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

function truncate() {
    global $migration_user_id;
    global $import_date;

    $truncate_date_limit = substr($import_date, 0, 10);

    $truncate_queries = array(
        "SET FOREIGN_KEY_CHECKS=0;",
        
      "TRUNCATE aliquot_internal_uses ;",
      "TRUNCATE aliquot_internal_uses_revs;",
        
        "UPDATE aliquot_masters SET  current_volume = initial_volume;",
        
        "TRUNCATE view_aliquot_uses;",
        
        "SET FOREIGN_KEY_CHECKS=1;"       
    );

    foreach($truncate_queries as $query) {
        pr($query);
        customQuery($query, __FILE__, __LINE__);
    }
}

function addViewUpdate(&$final_queries) {

    $final_queries[] = "INSERT INTO view_aliquot_uses (
        SELECT CONCAT(SourceAliquot.id,1) AS `id`,
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
    '' AS study_title
    FROM source_aliquots AS SourceAliquot
    JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
    JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
    JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
    JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
    JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
    WHERE SourceAliquot.deleted <> 1
    )";

    $final_queries[] = "INSERT INTO view_aliquot_uses (
      SELECT CONCAT(Realiquoting.id ,2) AS id,
    AliquotMaster.id AS aliquot_master_id,
    'realiquoted to' AS use_definition,
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
    '' AS study_title
    FROM realiquotings AS Realiquoting
    JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
    JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
    JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
    JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
    WHERE Realiquoting.deleted <> 1

    )";

    $final_queries[] = "INSERT INTO view_aliquot_uses (

    SELECT CONCAT(AliquotInternalUse.id,6) AS id,
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
    StudySummary.title AS study_title
    FROM aliquot_internal_uses AS AliquotInternalUse
    JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
    JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
    JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
    LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotInternalUse.study_summary_id AND StudySummary.deleted != 1
    WHERE AliquotInternalUse.deleted <> 1

    )";
}