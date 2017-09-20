<?php

// *******************************************************************************************************************************************************
//
//    TFRI-COEUR
//
// *******************************************************************************************************************************************************
//
//	Script created to update the clinical data absed on the bank submitted files in 2017-05-17.
//  This script is supposed to be re-used in winter 2018 for the last update.
// 
//  Here are the list of fields updated:
//
//  ** Profile
//   -  Death
//   -  Registered Date of Death
//   -  Suspected Date of Death
//   -  Date of Last Contact
//   -  BRCA status
//   -  Family History
//   -  notes
//
//  ** EOC Diagnosis : 
//   -  FIGO
//   -  Progression status
//   -  Date of Progression/Recurrence
//   -  Site 1 of Primary Tumor Progression (metastasis)  If Applicable
//   -  Site 2 of Primary Tumor Progression (metastasis)  If applicable 
//   -  Date of Progression of CA125 [Comparison to progression still recorded into ATiM can only be done based on date. If another progression exists into ATiM at another date, the comparison to this other record can not be done.]
//   -  CA125 progression time (months) [calculated and populated by the migration process]
//   -  progression time (months) [calculated and populated by the migration process]
//   -  Follow-up from ovarectomy (months) [calculated and populated by the migration process]
//   -  Survival from diagnosis (months) [calculated and populated by the migration process]
//
//  ** Other Diagnosis :
//   No data 
//
//  ** EOC Treatment : 
//   All treatment  
//
// @created 2017-05-17
// @author Nicolas Luc
// *******************************************************************************************************************************************************

require_once 'system.php';

$excel_file_names = array();
foreach($bank_excel_files as $new_bank_file) { 
	if($new_bank_file['file']) {
	    $excel_file_names_for_title[] = $new_bank_file['file'].(strlen($new_bank_file['label_for_summary'])? ' ['.$new_bank_file['label_for_summary'].']' : '');
	    $excel_file_names[] = $new_bank_file['file'];
	}
}

displayMigrationTitle('TFRI COEUR - Clinical Data Update', $excel_file_names_for_title);

if(!testExcelFile($excel_file_names)) {
	dislayErrorAndMessage();
	exit;
}

foreach($bank_excel_files as $new_bank_file) { 
	
	// New Bank File
	
	$file_name = $new_bank_file['file'];
	$file_label_for_summary = strlen($new_bank_file['label_for_summary'])? $new_bank_file['label_for_summary'] : substr($new_bank_file['file'], 0, 10).'...xls';
	list($profile_worksheet_name, $treatment_worksheet_name) = $new_bank_file['worksheets'];
	$parser_function_suffix = $new_bank_file['parser_function'];
	$file_xls_offset = $new_bank_file['file_xls_offset'];
	
	// Update bank clinical data
	
	$file_parser_function = 'getProfile'.$parser_function_suffix.'Parser';
	while($excel_line_clinical_data = $file_parser_function($file_name, $file_label_for_summary, $profile_worksheet_name, $file_xls_offset)) {
		
		
		pr($excel_line_clinical_data);
		exit;
	}
	
	
	
	
	
	pr('ici');
	exit;
	

	

	
	
	
	
	
}





pr('ici');
dislayErrorAndMessage();
exit;


//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

// Get Profile Data
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function getProfileGeneralParser($excel_file_name, $excel_file_label_for_summary, $worksheet_name, $file_xls_offset) {
	
	list($excel_line_counter, $next_excel_line_clinical_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 1, $file_xls_offset);
	
	
	pr($next_excel_line_clinical_data);exit;
	
	if(!$next_excel_line_clinical_data) return null;
	
	list($line_number, $excel_line_data) = $next_excel_line_clinical_data;
	
	$atim_field_to_excel_field = array();
	$atim_participant_data = array();
		
	// TFRI Participant #
	$excel_field = 'TFRI';
	$atim_field = 'participant_identifier';
	$atim_field_to_excel_field[$atim_field] = $excel_field;
	$atim_participant_data[$atim_field] = $excel_line_data[$excel_field];

	// Bank Participant #
	$excel_field = 'participantBank';
	$atim_field = 'qc_tf_bank_identifier';
	$atim_field_to_excel_field[$atim_field] = $excel_field;
	$atim_participant_data[$atim_field] = $excel_line_data[$excel_field];
	
	
	
	
	
	
	
	
	
	
	
	//  Death
	$excel_field = 'Vital Status';
	$atim_field = 'vital_status';
	$atim_field_to_excel_field[$atim_field] = $excel_field;
	$atim_participant_data[$atim_field] = $excel_line_data[$excel_field];
	
	//  Registered Date of Death
	$excel_field = 'Date du décès';
	$atim_field = 'date_of_death';
	$atim_field_to_excel_field[$atim_field] = $excel_field;
	$atim_participant_data[$atim_field] = $excel_line_data[$excel_field];
	$atim_participant_data[$atim_field.'_accuracy'] = 'c';
	
	//  Suspected Date of Death
	// None
	
	//  Date of Last Contact
	$excel_field = 'Date dernier contact';
	$atim_field = 'qc_tf_last_contact';
	$atim_field_to_excel_field[$atim_field] = $excel_field;
	$atim_participant_data[$atim_field] = $excel_line_data[$excel_field];
	$atim_participant_data[$atim_field.'_accuracy'] = 'c';
	
	//  BRCA status
	$excel_field = 'BRCA status';
	$atim_field = 'qc_tf_brca_status';
	$atim_field_to_excel_field[$atim_field] = $excel_field;
	$atim_participant_data[$atim_field] = $excel_line_data[$excel_field];
	
	//  Family History
	$excel_field = 'Family History';
	$atim_field = 'qc_tf_family_history';
	$atim_field_to_excel_field[$atim_field] = $excel_field;
	$atim_participant_data[$atim_field] = $excel_line_data[$excel_field];
	
	//  Notes
	$excel_field = 'Notes 1 & Notes 2';
	$atim_field = 'notes';
	$atim_field_to_excel_field[$atim_field] = $excel_field;
	$atim_participant_data[$atim_field] = $excel_line_data[$excel_field];
	
	

	
	
	pr("Line = ".$line_number);
	pr($excel_line_data);
	return array($line_number, $excel_line_data, 'toto');


	
}





// Other Function
//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function getDataToUpdate($atim_data, $excel_data) {
	$data_to_update = array();
	foreach($excel_data as $key => $value) {
		if(!array_key_exists($key, $atim_data)) die('ERR_8837282882:'.$key);
		if(strlen($value) && $value != $atim_data[$key]) $data_to_update[$key] = $value;
	}
	return $data_to_update;
}

function addUpdatedDataToSummary($bank, $qc_tf_bank_participant_identifier, $data_type, $data_to_update) {
	if($data_to_update) {
		$updates = array();
		foreach($data_to_update as $field => $value) $updates[] = "[$field = $value]";
		recordErrorAndMessage('Updated Data Summary', '@@MESSAGE@@', "Patient# $qc_tf_bank_participant_identifier ($bank)", "$data_type : ".implode(' + ', $updates));
	}
}



































//First Line of any main.php file

$excel_file_name = 'file_atim_data.xls';

// ***********************************************************************
// Example: Display variable content (html format)
// ***********************************************************************
pr($excel_file_name);

// ***********************************************************************
// Example: Display the title of the migration in html format
// ***********************************************************************

// ***********************************************************************
// Example: Record an error or message, etc
// ***********************************************************************
recordErrorAndMessage('Patient Profile', '@@ERROR@@', "Bank patient unknown", "No ATim Patient matches excel patient ".$expecl_patient_identifier);
recordErrorAndMessage('Patient Profile', '@@WARNING@@', "Patient Vital Status Unsupported", "The vital status value '".$excel_patient_vital_status."' is not supported.", $excel_patient_vital_status);
// ***********************************************************************
// Example: Dispaly error and message
// ***********************************************************************
dislayErrorAndMessage(true);

// ***********************************************************************
// Example: Test excel file
// ***********************************************************************
if(!testExcelFile(array($excel_file_name))) {
	dislayErrorAndMessage();
	exit;
}
// ***********************************************************************
// Example: Parse excel file
// ***********************************************************************
$worksheet_name = 'Profile';
while(list($line_number, $excel_line_data) = getNextExcelLineData($excel_file_name, $worksheet_name, 2)) {
	//.....
}

// ***********************************************************************
// Example: Execute a specific query
// ***********************************************************************
customQuery("UPDATE drugs SET deleted = 1, modified = '$imported', modified_by = '$imported_by';");
// ***********************************************************************
// Example: Execute a select query
// ***********************************************************************
$atim_patient_data = getSelectQueryResult("SELECT p.* FROM participants p WHERE ....;");
// ***********************************************************************
// Example: Create a new diagnosis
// ***********************************************************************
$secondary_data = array(
	'diagnosis_masters' => array(
			'participant_id' => $atim_participant_id,
			'diagnosis_control_id' => $atim_controls['diagnosis_controls']['secondary-other']['id'],
			'primary_id' => $diagnosis_master_id,
			'parent_id' => $diagnosis_master_id,
			'dx_date' => $excel_metastasis_data['dx_date'],
			'dx_date_accuracy' => $excel_metastasis_data['dx_date_accuracy']),
	$atim_controls['diagnosis_controls']['secondary-other']['detail_tablename'] => array(
			'site' => $excel_metastasis_data['site']));
customInsertRecord($secondary_data);
// ***********************************************************************
// Example: Update a diagnosis
// ***********************************************************************
$diagnosis_data_to_update = array(
	'diagnosis_masters' => array(), //Nothing to update
	$atim_controls['diagnosis_controls']['primary-blood']['detail_tablename'] => array('text_field' => '...'));
updateTableData($atim_diagnosis_master_id, $diagnosis_data_to_update);
// ***********************************************************************
// Example: Insert into revs
// ***********************************************************************
insertIntoRevsBasedOnModifiedValues('drugs');
insertIntoRevsBasedOnModifiedValues();

// ***********************************************************************
// Example: Functions to validate values to created
// ***********************************************************************
//Value
$excel_patient_data['vital_status'] = validateAndGetStructureDomainValue(str_replace(array('dead'), array('deceased')), $excel_vital_status, 'health_status', 'Participant profile', "$worksheet_name::$excel_field:", "See Line:$line_number");
$yes_no_excel_values_list = array('unknown' => '', '?' => '', 'yes' => 'y', 'y' => 'y', 'oui' => 'y', 'no' => 'n', 'non' => 'n');
//Value
$excel_patient_data['qc_tf_death_from_prostate_cancer'] = validateAndGetExcelValueFromList($excel_line_data[$excel_field], $yes_no_excel_values_list, true, 'Participant profile', "$worksheet_name::$excel_field:", "See Line:$line_number");
//Date
$empty_date_time_values = array('-', 'n/a', 'x', '??', 'nd');
list($date_of_death, $date_of_death_accuracy) = validateAndGetDateAndAccuracy($excel_date_of_death, 'Participant profile', "$worksheet_name::$excel_field:", "See Line:$line_number");
list($date_of_collection, $date_of_collection_accuracy) =validateAndGetDatetimeAndAccuracy($excel_date, $excel_time, 'Collection', "$worksheet_name::$excel_field:", "See Line:$line_number");
//Number
$empty_number_values = array('-', 'n/a', 'x', '??', 'nd');
$height = validateAndGetDecimal($excel_height, 'Participant profile', "$worksheet_name::$excel_field:", "See Line:$line_number");
$age = validateAndGetInteger($excel_age, 'Participant profile', "$worksheet_name::$excel_field:", "See Line:$line_number");

//==================================================================================================================================================================================
// CUSTOM FUNCTIONS
//==================================================================================================================================================================================

//TODO: Section for custom functions if required
	
?>
		