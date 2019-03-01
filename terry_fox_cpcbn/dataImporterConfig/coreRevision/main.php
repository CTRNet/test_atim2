<?php

//First Line of any main.php file
require_once 'system.php';

//==============================================================================================
// Custom Require Section
//==============================================================================================

//==============================================================================================
// Custom Variables
//==============================================================================================

//==============================================================================================
// Main Code
//==============================================================================================

displayMigrationTitle('CPCBN TMA Block Core Revision Record');

//---------------------------------------------------------------------------------------------
// Parse File
//---------------------------------------------------------------------------------------------
$windows_xls_offset = 36526;
$mac_xls_offset = 35064;

//recordErrorAndMessage('Core Creation', '@@MESSAGE@@', "ID ATiM value won't be take in consideration", "n/a.");
$coreCreated = 0;
$noRevisionMsg = array();
foreach($excel_files as $excel_data) {
    list($excel_file_name, $worksheet_name) = $excel_data;
    recordErrorAndMessage('Summary', '@@MESSAGE@@', "Files Names", "FILE : $excel_file_name");
    $coreCreated = 0;
	while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $mac_xls_offset)) {
	    $barcode = $excel_line_data['Aliquot TFRI'];
	    if(!$barcode || $barcode == '.') {
	        if((strlen($excel_line_data['NOTES']) && $excel_line_data['NOTES'] != '.') || (strlen($excel_line_data['2e revision']) && $excel_line_data['2e revision'] != '.')) {
	           recordErrorAndMessage($excel_file_name, '@@ERROR@@', "Barcode not defined but either fields 'notes' or 'revision' is not empty. No core revision imported.", "See notes = '".$excel_line_data['NOTES']."' and revision '".$excel_line_data['2e revision']."' line : $line_number.");
	        }
	        continue;
	    }
	    if(!$excel_line_data['2e revision'] || $excel_line_data['2e revision'] == '.') {
	        if(strlen($excel_line_data['NOTES'])) {
	            recordErrorAndMessage($excel_file_name, '@@WARNING@@', "Revision not defined but note exists. No core revision imported.", "See core '$barcode' with note '".$excel_line_data['NOTES']."' line : $line_number.");         
	        } else {
	            $noRevisionMsg[] = "See core '$barcode' on '$excel_file_name' line : $line_number.";  
	        }
	        continue;
	    }
	    $query = "SELECT id AS aliquot_master_id, sample_master_id, collection_id FROM aliquot_masters WHERE aliquot_control_id = ".$atim_controls['aliquot_controls']['tissue-core']['id']." AND barcode LIKE '$barcode' AND deleted <> 1;";
	    $aliquots = getSelectQueryResult($query);
	    if(sizeof($aliquots) != 1) {
	        die('ERR8499338 : ' . $barcode);
	    }
	    $notes = array($excel_line_data['NOTES']);
	    list($review_date, $review_date_accuracy) = validateAndGetDateAndAccuracy($excel_line_data['Date'], "$excel_file_name", "Wrong date", "See line : $line_number.");
	    $grade = '';
	    if(preg_match('/^[0-9\+]+$/', $excel_line_data['2e revision'])) {
	        $grade = validateAndGetStructureDomainValue($excel_line_data['2e revision'], 'qc_tf_core_review_grade', $excel_file_name, "Wrong Grade value ('2e revision' field)", "See line : $line_number.");
	        $excel_line_data['2e revision'] = '';
	    }
	    $revised_nature = validateAndGetStructureDomainValue($excel_line_data['2e revision'], 'qc_tf_tissue_core_nature', $excel_file_name, "Wrong Nature value ('2e revision' field)", "See line : $line_number.");
	    if(strlen($excel_line_data['2e revision']) && $excel_line_data['2e revision'] != '.' && !strlen($revised_nature)) {
	        $notes[] = $excel_line_data['2e revision'];
	    }
	    $notes = implode('. ', $notes).'.';
	    //Create path review	    
	    $specimen_review_data = array(
	        'specimen_review_masters' => array(
	            'collection_id' => $aliquots[0]['collection_id'],
	            'sample_master_id' => $aliquots[0]['sample_master_id'],
	            'specimen_review_control_id' => $atim_controls['specimen_review_controls']['core review']['id']),
	        $atim_controls['specimen_review_controls']['core review']['detail_tablename'] => array());
	    if($review_date) {
	        $specimen_review_data['specimen_review_masters']['review_date'] = (($review_date == '2017-09-28')? '2017-09-27' : $review_date);
	        $specimen_review_data['specimen_review_masters']['review_date_accuracy'] = 'h';
	    }
	    $specimen_review_master_id = customInsertRecord($specimen_review_data);
	    $aliquot_review_data = array(
	        'aliquot_review_masters' => array(
	            'aliquot_master_id' => $aliquots[0]['aliquot_master_id'],
	            'aliquot_review_control_id' => $atim_controls['specimen_review_controls']['core review']['aliquot_review_control_id'],
	            'specimen_review_master_id' => $specimen_review_master_id),
	        $atim_controls['specimen_review_controls']['core review']['aliquot_review_detail_tablename'] => array(
	            'revised_nature' => $revised_nature,
	            'grade' => $grade,
	            'notes' => $notes));
	    customInsertRecord($aliquot_review_data);
	    $coreCreated++;
	}
	recordErrorAndMessage($excel_file_name, '@@WARNING@@', "Number of core revisions created.", $coreCreated);
}
foreach($noRevisionMsg as $newMsg) {
    recordErrorAndMessage('Unmigrated lines', '@@MESSAGE@@', "Revision not defined. No core revision imported.", $newMsg);
}


customQuery("UPDATE versions SET permissions_regenerated = 0;");

dislayErrorAndMessage(true);

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================
		
?>
		