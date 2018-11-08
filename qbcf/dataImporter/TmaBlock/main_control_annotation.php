<?php

/**
 * Script to dowload TMA block control annotation
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

foreach($excel_files_names_control_annotation as $file_data) {
	list($excel_file_name, $tmp) = $file_data;
	$tmp_files_names_list[] = $excel_file_name;
}

displayMigrationTitle('QBCF TMA Block Control Annotation');

if(!testExcelFile($tmp_files_names_list)) {
	dislayErrorAndMessage();
	exit;
}

// *** GET CONTROL SAMPLE ***

$query = "SELECT id FROM collections WHERE deleted <> 1 AND qbcf_pathology_id = 'Control' AND collection_property = 'independent collection';";
$query_data = getSelectQueryResult($query);
if(!$query_data) die("Create frist a 'Control' collection with patholodgy id = 'Control'!");
if(sizeof($query_data) > 1) die("Merge 'Control' collections with patholodgy id = 'Control'!");
$control_collection_id = $query_data[0]['id'];

$atim_controls_samples_data = array();
$tissue_sample_detail_tablename = $atim_controls['sample_controls']['tissue']['detail_tablename'];
$query = "SELECT SampleMaster.collection_id,
	SampleMaster.id AS sample_master_id,
	SampleMaster.qbcf_tma_sample_control_code,
	SampleDetail.tissue_source,
	SampleDetail.qbcf_control_er_overall,
	SampleDetail.qbcf_control_pr_overall,
	SampleDetail.qbcf_control_her_2_status,
	SampleDetail.qbcf_control_tnbc
	FROM sample_masters SampleMaster
	INNER JOIN $tissue_sample_detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
	WHERE SampleMaster.collection_id = $control_collection_id
	AND SampleMaster.deleted <> 1 AND SampleMaster.sample_control_id = ".$atim_controls['sample_controls']['tissue']['id'];
foreach(getSelectQueryResult($query) as $new_sample_flagged_control) {
	$sample_key = trim($new_sample_flagged_control['qbcf_tma_sample_control_code']).'--'.$new_sample_flagged_control['tissue_source'];
	$atim_controls_samples_data[$sample_key] = $new_sample_flagged_control;
}

// *** PARSE EXCEL FILES ***

$file_counter = 0;
foreach($excel_files_names_control_annotation as $file_data) {
	$file_counter++;
	
	// New Excel File
	
	list($excel_file_name, $worksheet_name) = $file_data;
	$excel_file_name_for_ref = "File#$file_counter - ".((strlen($excel_file_name) > 30)? substr($excel_file_name, '0', '30')."...xls" : $excel_file_name);
	
	recordErrorAndMessage('Files', '@@MESSAGE@@', "Excel Files Parsed", "File#$file_counter - $excel_file_name");
	
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1)) {
		if($line_number > 1) {
			foreach($excel_line_data as &$new_val) if(preg_match('/^\.$/', $new_val)) $new_val = '';
			$excel_data_references = "Excel '<b>$excel_file_name_for_ref</b>', Worksheet '<b>$worksheet_name</b>', Line '<b>$line_number</b>'";
			$sample_key = $excel_line_data['Control Code'].'--'.$excel_line_data['Tissue Source'];
			if(strlen($sample_key) && $sample_key != '--') {
			    $excel_data_references = "sample control <b>$sample_key</b> listed in $excel_data_references";
			    if(isset($atim_controls_samples_data[$sample_key])) {
			        $sample_master_id = $atim_controls_samples_data[$sample_key]['sample_master_id'];
			        $annotationsExcelToAtimFields = array(
			            'ER_status' => array('qbcf_control_er_overall', 'qbcf_er_overall'),
			            'PR_status' => array('qbcf_control_pr_overall', 'qbcf_pr_overall'),
			            'HER2_status' => array('qbcf_control_her_2_status', 'qbcf_her_2_status'),
			            'TNBC_status' => array('qbcf_control_tnbc', 'qbcf_tnbc')
			        );
			        $dataConflict = array();
			        $dataToUpdate = array();
			        $dataToUpdateMsg = array();
			        foreach($annotationsExcelToAtimFields as $excelField => $AtimFieldData) {
			            list($AtimField, $AtimDropDownList) = $AtimFieldData;
			            if(strlen($excel_line_data[$excelField])) {
			                // An excel value is set
			                $atimFieldValueFromExcelToUpdate = validateAndGetStructureDomainValue($excel_line_data[$excelField], $AtimDropDownList, "TMA Controls Annotations File ($excel_file_name :: $worksheet_name)", $excelField, "See $excel_data_references.");
			                if(strlen($atimFieldValueFromExcelToUpdate)) {
			                   //Excel data can be use (validated) for update
			                    if(!strlen($atim_controls_samples_data[$sample_key][$AtimField])) {
			                        $dataToUpdate[$AtimField] = $atimFieldValueFromExcelToUpdate;
			                        $dataToUpdateMsg[] = "'$excelField' = '$atimFieldValueFromExcelToUpdate'";
			                    } elseif($atimFieldValueFromExcelToUpdate != $atim_controls_samples_data[$sample_key][$AtimField]) {
			                        $dataConflict[] = "<b>'$excelField'</b> value in excel '$atimFieldValueFromExcelToUpdate' being different than value in ATiM '".$atim_controls_samples_data[$sample_key][$AtimField]."'";
			                    }
			                }
			            }
			        }
			        if($dataConflict) {
			            //No update : data conflict
			            recordErrorAndMessage("TMA Controls Annotations File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "At least one conflict exists between excel data and ATiM data. Data of the line won't be imported.Please confirm.", "See conflict on ".implode("', '", $dataConflict)." for $excel_data_references.");
			        } else if($dataToUpdate){
			            //Update data
			            $atim_controls_samples_data[$sample_key] = array_merge($atim_controls_samples_data[$sample_key], $dataToUpdate);
			            updateTableData($sample_master_id, array('sample_masters' => array(), $tissue_sample_detail_tablename => $dataToUpdate));
			            recordErrorAndMessage("TMA Controls Annotations File ($excel_file_name :: $worksheet_name)", '@@MESSAGE@@', "Update new tissue control data.", "See updated data ".implode(", ", $dataToUpdateMsg)." for $excel_data_references.");
			        }
			    } else {
			        recordErrorAndMessage("TMA Controls Annotations File ($excel_file_name :: $worksheet_name)", '@@ERROR@@', "Tissue control is not a control recorded into ATiM. Data of the line won't be imported.Please confirm.", "See '$sample_key' Control Tissue for $excel_data_references."); 
			    }
		    } else {
		        recordErrorAndMessage("TMA Controls Annotations File ($excel_file_name :: $worksheet_name)", '@@MESSAGE@@', "No line data to import. Please confirm.", "See $excel_data_references.");
		    }
		}
	}  //End new line
}

dislayErrorAndMessage($commit_all, 'Creation/Update Summary');

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

	
?>
		