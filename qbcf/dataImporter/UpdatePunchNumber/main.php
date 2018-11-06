<?php

/**
 * Script to dowload all block slide reviews into ATiM QBCF.
 *
 * Notes:
 *   - No collection, sample, block and slide will be created by the script.
 *   - Path review data will be created if the system is able to find a tissue block into ATiM matching bank, pathology id and block code then block slide.
 *   - No Path review will be created if an existing one already exists for the tissue block.
 */
 
require_once 'system.php';

//==============================================================================================
// Main Code
//==============================================================================================

$commit_all = true;
if(isset($argv[1])) {
    if($argv[1] == 'test') {
        $commit_all = false;
    } else {
        die('ERR ARG : '.$argv[1].' (should be test or nothing)');
    }
}

$tmp_files_names_list = array();

foreach($excel_files_names as $file_data) {
	list($excel_file_name, $excel_xls_offset) = $file_data;
	$tmp_files_names_list[] = $excel_file_name;
}

displayMigrationTitle('QBCF Update Number Of Possible Punch');

if(!testExcelFile($tmp_files_names_list)) {
	dislayErrorAndMessage();
	exit;
}

// *** PARSE EXCEL FILES ***

$file_counter = 0;
foreach($excel_files_names as $file_data) {
	$file_counter++;
	
	// New Excel File
	
	list($excel_file_name, $excel_xls_offset) = $file_data;
	$excel_file_name_for_ref = "File#$file_counter - ".((strlen($excel_file_name) > 30)? substr($excel_file_name, '0', '30')."...xls" : $excel_file_name);
	
	recordErrorAndMessage('Files', '@@MESSAGE@@', "Excel Files Parsed", "File#$file_counter - $excel_file_name");
	
	$worksheet_name = 'number_possible_punchs_14082018';
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $excel_xls_offset)) {
		if($line_number > 1)  {
		    $aliquot_master_id = $excel_line_data['Aliquot QBCF#'];
		    $aliquot_label = $excel_line_data['Aliquot Bank Label'];
		    $punches = $excel_line_data['Possible Punches'];
		    
		    $query = "SELECT Bank.name AS bank_name, Participant.participant_identifier AS atim_participant_nbr, Participant.qbcf_bank_participant_identifier, AliquotMaster.id AS aliquot_master_id, AliquotMaster.aliquot_label, AliquotReviewMaster.id AS aliquot_review_master_id, AliquotReviewDetail.possible_punches
    		    FROM aliquot_masters AliquotMaster
		        INNER JOIN collections Collection ON Collection.id = AliquotMaster.collection_id AND Collection.deleted <> 1
		        INNER JOIN participants Participant ON Participant.id = Collection.participant_id AND Participant.deleted <> 1
		        LEFT JOIN banks Bank ON Bank.id = Participant.qbcf_bank_id AND Bank.deleted <> 1
    		    LEFT JOIN aliquot_review_masters AliquotReviewMaster ON AliquotReviewMaster.aliquot_master_id = AliquotMaster.id AND AliquotReviewMaster.deleted <> 1
    		    LEFT JOIN ". $atim_controls['specimen_review_controls']['tissue block review']['aliquot_review_detail_tablename']." AliquotReviewDetail ON AliquotReviewDetail.aliquot_review_master_id = AliquotReviewMaster.id
    		    WHERE AliquotMaster.id = $aliquot_master_id
    		    AND AliquotMaster.deleted <> 1;";
		    $pathReviewData = getSelectQueryResult($query);
		    if(empty($pathReviewData)) {
		        recordErrorAndMessage('Punches Update', '@@ERROR@@', "Aliquot not found based on Aliquot QBCF#. No punches nbr will be updated.", "Aliquot QBCF# $aliquot_master_id with label '$aliquot_label'. See line $line_number.");	
		    } elseif(sizeof($pathReviewData) > 1) {
		        recordErrorAndMessage('Punches Update', '@@ERROR@@', "More than one revision exists for the Aliquot QBCF#. System is unable to define the good one to update the nbr of punches. No punches nbr will be updated.", "Update manually the number of punches (= $punches) into ATiM for aliquot QBCF# $aliquot_master_id with label '$aliquot_label'. See line $line_number.");	
		    } elseif($pathReviewData[0]['aliquot_label'] != $aliquot_label) {
		      recordErrorAndMessage('Punches Update', '@@ERROR@@', "'Aliquot Bank Label' does not match the label of the aliquot found into the database based on Aliquot QBCF#. No punches nbr will be updated.", "Update manually the number of punches (= $punches) into ATiM for aliquot QBCF# $aliquot_master_id with label '$aliquot_label'. See line $line_number.");	
		    } else {
		        $participant_match = true;
		        $matchFields = array(
		            'bank_name' => 'Bank',
		            'atim_participant_nbr' => 'ATiM Participant #',
		            'qbcf_bank_participant_identifier' => 'Bank Patient #'
		        );
		        foreach($matchFields as $atimFied => $excelField) {
		           if($pathReviewData[0][$atimFied] != $excel_line_data[$excelField]) {
		               $participant_match = false;
		           }
		        }
		        if(!$participant_match) {
		            pr('ERR 238764827364897263');
		            pr($pathReviewData);
		              pr($excel_line_data);
		        } else {
		            if($pathReviewData[0]['possible_punches']) {
		                if($pathReviewData[0]['possible_punches'] == $punches) {
		                recordErrorAndMessage('Punches Update',
		                    '@@MESSAGE@@',
		                    "Possible punches number is already sets and is equal both in excel and atim. No punches nbr will be updated.",
		                    "See the number of punches (= $punches) into Excel for aliquot QBCF# $aliquot_master_id with label '$aliquot_label' and existing nbr of punches value equals to '".$pathReviewData[0]['possible_punches']."'. See line $line_number.");
		                } else {
		                    recordErrorAndMessage('Punches Update',
		                        '@@ERROR@@',
		                        "Possible punches number is already sets but are different into excel and atim. No punches nbr will be updated.",
		                        "Update manually the number of punches (= $punches) into ATiM for aliquot QBCF# $aliquot_master_id with label '$aliquot_label' and existing nbr of punches value equals to '".$pathReviewData[0]['possible_punches']."'. See line $line_number.");
		                }		                
	                } else {
		                $excel_nbr_of_punches = validateAndGetStructureDomainValue($punches, 'qbcf_path_review_possible_punches', 'Punches Update', 'Possible Punches', "See aliquot QBCF# $aliquot_master_id with label '$aliquot_label' at line $line_number.");
		                if($excel_nbr_of_punches) {
		                    updateTableData(
		                        $pathReviewData[0]['aliquot_review_master_id'],
		                        array(
		                            'aliquot_review_masters' => array(),
		                            $atim_controls['specimen_review_controls']['tissue block review']['aliquot_review_detail_tablename'] => array('possible_punches' => $excel_nbr_of_punches)));
		                    recordErrorAndMessage('Punches Update List',
		                        '@@MESSAGE@@',
		                        "Punches number updated.",
		                        "See the number of punches updated to '$punches' for aliquot QBCF# $aliquot_master_id with label '$aliquot_label'. See line $line_number.");
		                    
		                }
		            }
		            
		        }
		    }
		}
	} 
}
	
insertIntoRevsBasedOnModifiedValues('aliquot_review_masters', $atim_controls['specimen_review_controls']['tissue block review']['aliquot_review_detail_tablename']);
dislayErrorAndMessage($commit_all, 'Update Summary');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================
	
?>
		