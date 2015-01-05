<?php

require_once 'config.php';
require_once './SourceCode/profile.php';
require_once './SourceCode/diagnosis.php';
require_once './SourceCode/other_diagnosis.php';

set_time_limit('3600');

//-- EXCEL FILE ---------------------------------------------------------------------------------------------------------------------------

require_once './SourceCode/Excel/reader.php';
$tmp_xls_reader = new Spreadsheet_Excel_Reader();
$tmp_xls_reader->read($excel_file_name );
$sheets_keys = array();
foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_keys[$tmp['name']] = $key;

//-- DB CONNECTION ---------------------------------------------------------------------------------------------------------------------------

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(empty($db_port)? '' : ":").$db_port,
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed");
mysqli_autocommit($db_connection, false);

//-- GLOBAL VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------

global $modified_by;
$modified_by = '9';

global $modified;
$query = "SELECT NOW() as modified FROM study_summaries;";
$modified_res = mysqli_query($db_connection, $query) or die("query failed [".$query."]: " . mysqli_error($db_connection)."]");
$modified = mysqli_fetch_assoc($modified_res);
if($modified) {
	$modified = $modified['modified'];
} else {
	die('ERR 9993999399');
}

global $summary_msg;
$summary_msg = array();

global $voas_to_participant_id;
$voas_to_participant_id = array();

//===========================================================================================================================================================
//===========================================================================================================================================================

echo "<br><FONT COLOR=\"green\" >
=====================================================================<br>
OVCARE TFRI DATA EXPORT PROCESS<br>
source_file = $excel_file_name<br>
Date: $modified<br>
<br>=====================================================================</FONT><br><br>";

// **** START ********************************************************

$atim_controls = loadATiMControlData();
setVoaToParticipantIds($atim_controls);

// **** EXCEL DATA EXTRACTION ****************************************

list($all_patients_worksheet_voas, $participant_ids_to_skip) = updateProfile($tmp_xls_reader->sheets, $sheets_keys, 'Patients', $atim_controls);
updateOvaryEndometriumDiagnosis($tmp_xls_reader->sheets, $sheets_keys, 'EOC - Diagnosis', 'EOC-  Event', $atim_controls, $all_patients_worksheet_voas, $participant_ids_to_skip);
updateOtherDiagnosis($tmp_xls_reader->sheets, $sheets_keys, 'Other Primary Cancer -Diagnosis', 'Other Primary Cancer - Event', $atim_controls, $all_patients_worksheet_voas, $participant_ids_to_skip);

// **** END ********************************************************

$query = "SELECT DiagnosisMaster.participant_id,DiagnosisMaster.id, Participant.participant_identifier
	FROM diagnosis_masters DiagnosisMaster
	INNER JOIN participants Participant ON Participant.id = DiagnosisMaster.participant_id
	WHERE DiagnosisMaster.diagnosis_control_id = 15
	AND DiagnosisMaster.id NOT IN (SELECT diagnosis_master_id FROM treatment_masters WHERE deleted <> 1 AND diagnosis_master_id IS NOT NULL)
	AND DiagnosisMaster.id NOT IN (SELECT diagnosis_master_id FROM event_masters WHERE deleted <> 1 AND diagnosis_master_id IS NOT NULL)
	AND DiagnosisMaster.id NOT IN (SELECT diagnosis_master_id FROM collections WHERE deleted <> 1 AND diagnosis_master_id IS NOT NULL)
	AND DiagnosisMaster.id NOT IN (SELECT parent_id FROM diagnosis_masters WHERE deleted <> 1 AND parent_id IS NOT NULL);";
$results = mysqli_query($db_connection, $query) or die("unknown Dx [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
while($row = $results->fetch_assoc()) {
	$summary_msg['Unknown Diagnosis']['@@WARNING@@']["Unknown diagnosis alone"][] = "An 'Unknown Pimary Diagnosis' is linked to any record (secondary, collection, treatment, event). Check this one can be removed. Patient ID ".$row['participant_identifier']." (participant_id=".$row['participant_id'].").";
}

// Work on surgery/biopsy data: Age at surgery/biopsy

$query = "UPDATE ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename']." SET ovcare_age_at_surgery = null, ovcare_age_at_surgery_precision = null;";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
$query = "UPDATE ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename']."_revs SET ovcare_age_at_surgery = null, ovcare_age_at_surgery_precision = null;";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
$query = "SELECT TreatmentMaster.id AS treatment_master_id,
	Participant.date_of_birth, 
	Participant.date_of_birth_accuracy,
	TreatmentMaster.start_date,
	TreatmentMaster.start_date_accuracy,
	TreatmentDetail.ovcare_age_at_surgery,
	TreatmentDetail.ovcare_age_at_surgery_precision
	FROM participants Participant
	INNER JOIN treatment_masters TreatmentMaster ON TreatmentMaster.participant_id = Participant.id
	INNER JOIN ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename']." TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
	WHERE Participant.deleted <> 1 AND TreatmentMaster.deleted <> 1 
	AND Participant.date_of_birth IS NOT NULL 
	AND TreatmentMaster.start_date IS NOT NULL 
	AND TreatmentMaster.treatment_control_id = ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['treatment_control_id'].";";
$results = mysqli_query($db_connection, $query) or die("Dx Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
while($row = $results->fetch_assoc()) {
	$treatment_master_id = $row['treatment_master_id'];
	$procedure_date = $row['start_date'];
	$procedure_date_accuracy = $row['start_date_accuracy'];
	$DateOfBirthObj = new DateTime($row['date_of_birth']);
	$ProcedureDateObj = new DateTime($row['start_date']);
	$interval = $DateOfBirthObj->diff($ProcedureDateObj);
	$new_ovcare_age_at_surgery = $interval->format('%r%y');
	if($new_ovcare_age_at_surgery < 0) {
		$new_ovcare_age_at_surgery = '';
		$new_ovcare_age_at_surgery_precision = "date error";
	} else if(!(in_array($row['start_date_accuracy'], array('c')) && in_array($row['date_of_birth_accuracy'], array('c')))) {
		$new_ovcare_age_at_surgery_precision = "approximate";
	} else {
		$new_ovcare_age_at_surgery_precision = "exact";
	}
	$query = "UPDATE treatment_masters SET modified = '".$modified."', modified_by = '".$modified_by."' WHERE id = $treatment_master_id";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$query = "UPDATE ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename']." SET ovcare_age_at_surgery = '".$new_ovcare_age_at_surgery."', ovcare_age_at_surgery_precision = '".$new_ovcare_age_at_surgery_precision."' WHERE treatment_master_id = $treatment_master_id";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
}
// Link collection to patient Dx when patient is linked to one dx

$query = "UPDATE collections Collection, diagnosis_masters DiagnosisMaster
	SET Collection.diagnosis_master_id = DiagnosisMaster.id, Collection.modified = '$modified', Collection.modified_by = '$modified_by'
	WHERE Collection.deleted <> 1
	AND DiagnosisMaster.deleted <> 1
	AND Collection.participant_id = DiagnosisMaster.participant_id
	AND Collection.participant_id IN (SELECT participant_id FROM (SELECT count(*) as dx_nbr, participant_id FROM diagnosis_masters WHERE deleted <> 1 GROUP BY participant_id) AS res WHERE res.dx_nbr = 1)
	AND Collection.diagnosis_master_id IS NULL;";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
$query = "INSERT INTO collections_revs (id,acquisition_label,bank_id,collection_site,collection_datetime,collection_datetime_accuracy,ovcare_collection_type,sop_master_id,collection_property,collection_notes,participant_id,diagnosis_master_id,
	consent_master_id,treatment_master_id,event_master_id,ovcare_collection_voa_nbr,modified_by,version_created) 
	(SELECT id,acquisition_label,bank_id,collection_site,collection_datetime,collection_datetime_accuracy,ovcare_collection_type,sop_master_id,collection_property,collection_notes,participant_id,diagnosis_master_id,
	consent_master_id,treatment_master_id,event_master_id,ovcare_collection_voa_nbr,modified_by,modified FROM collections WHERE modified = '$modified' AND modified_by = '$modified_by');";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));

// Add missing revs records

$query = "INSERT INTO treatment_masters_revs (id,treatment_control_id,participant_id,diagnosis_master_id,notes ,start_date,start_date_accuracy, modified_by, version_created)
(SELECT id,treatment_control_id,participant_id,diagnosis_master_id,notes ,start_date,start_date_accuracy, modified_by, modified FROM treatment_masters WHERE modified = '$modified' AND modified_by = '$modified_by' AND treatment_control_id =".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['treatment_control_id'].");";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
$query = "INSERT INTO ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename']."_revs (path_num, ovcare_age_at_surgery, ovcare_residual_disease, `primary`, treatment_master_id, ovcare_neoadjuvant_chemotherapy, ovcare_adjuvant_radiation, ovcare_age_at_surgery_precision, ovcare_prior_radiation, version_created)
	(SELECT TreatmentDetail.path_num, TreatmentDetail.ovcare_age_at_surgery, TreatmentDetail.ovcare_residual_disease, TreatmentDetail.primary, TreatmentDetail.treatment_master_id, TreatmentDetail.ovcare_neoadjuvant_chemotherapy, TreatmentDetail.ovcare_adjuvant_radiation, TreatmentDetail.ovcare_age_at_surgery_precision, TreatmentDetail.ovcare_prior_radiation, TreatmentMaster.modified
	FROM treatment_masters TreatmentMaster INNER JOIN ".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['detail_tablename']." TreatmentDetail ON TreatmentDetail.treatment_master_id = TreatmentMaster.id
	WHERE TreatmentMaster.modified = '$modified' AND TreatmentMaster.modified_by = '$modified_by' AND TreatmentMaster.treatment_control_id =".$atim_controls['treatment_controls']['procedure - surgery and biopsy']['treatment_control_id'].");";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
$query = "INSERT INTO diagnosis_masters_revs (id, participant_id, primary_id , parent_id, diagnosis_control_id, dx_date, dx_date_accuracy, tumour_grade, notes, ovcare_clinical_history, ovcare_clinical_diagnosis, ovcare_tumor_site, survival_time_months_precision, ovcare_path_review_type, modified_by, version_created)
	(SELECT id, participant_id, primary_id , parent_id, diagnosis_control_id, dx_date, dx_date_accuracy, tumour_grade, notes, ovcare_clinical_history, ovcare_clinical_diagnosis, ovcare_tumor_site, survival_time_months_precision, ovcare_path_review_type, modified_by, modified
	FROM diagnosis_masters WHERE diagnosis_control_id = ".$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['id']." AND modified = '$modified' AND modified_by = '$modified_by');";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
$query = "INSERT INTO ovcare_dxd_ovaries_endometriums_revs (diagnosis_master_id, initial_surgery_date_accuracy, initial_recurrence_date_accuracy, figo, laterality, censor, ovarian_histology, uterine_histology, histopathology, benign_lesions_precursor_presence, fallopian_tube_lesions, progression_status, version_created)
	(SELECT diagnosis_master_id, initial_surgery_date_accuracy, initial_recurrence_date_accuracy, figo, laterality, censor, ovarian_histology, uterine_histology, histopathology, benign_lesions_precursor_presence, fallopian_tube_lesions, progression_status, modified
	FROM diagnosis_masters
	INNER JOIN ovcare_dxd_ovaries_endometriums ON id = diagnosis_master_id
	WHERE diagnosis_control_id = ".$atim_controls['diagnosis_control_ids']['primary']['ovary or endometrium tumor']['id']." AND modified = '$modified' AND modified_by = '$modified_by');";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
$query = "INSERT INTO participants_revs (id,first_name,last_name ,date_of_birth,date_of_birth_accuracy ,vital_status,ovcare_last_followup_date,ovcare_last_followup_date_accuracy,notes,
	date_of_death,date_of_death_accuracy,participant_identifier,last_modification,last_modification_ds_id,version_created,modified_by)
	(SELECT id,first_name,last_name ,date_of_birth,date_of_birth_accuracy ,vital_status,ovcare_last_followup_date,ovcare_last_followup_date_accuracy,notes,
	date_of_death,date_of_death_accuracy,participant_identifier,last_modification,last_modification_ds_id,modified,modified_by FROM participants WHERE modified = '$modified' AND modified_by = '$modified_by');";
mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));

// **** EXTRA TASK  ********************************************************

// Set empty diagnosis date using first treatment date

$query = "SELECT DiagnosisMaster.id as diagnosis_master_id, DiagnosisControl.category, DiagnosisControl.controls_type, DiagnosisMaster.participant_id, DiagnosisMaster.dx_date, DiagnosisMaster.dx_date_accuracy, DiagnosisMaster.diagnosis_control_id, DiagnosisMaster.notes, TreatmentControl.tx_method, TreatmentMaster.start_date, TreatmentMaster.start_date_accuracy, TreatmentMaster.treatment_control_id
	FROM diagnosis_masters DiagnosisMaster
	INNER JOIN diagnosis_controls DiagnosisControl ON DiagnosisControl.id = DiagnosisMaster.diagnosis_control_id
	INNER JOIN treatment_masters TreatmentMaster ON DiagnosisMaster.id = TreatmentMaster.diagnosis_master_id
	INNER JOIN treatment_controls TreatmentControl ON TreatmentControl.id = TreatmentMaster.treatment_control_id
	WHERE DiagnosisMaster.deleted <> 1 AND TreatmentMaster.deleted <> 1
	AND (DiagnosisMaster.dx_date IS NULL OR DiagnosisMaster.dx_date LIKE '')
	AND TreatmentMaster.start_date IS NOT NULL AND TreatmentMaster.start_date NOT LIKE ''
	AND DiagnosisControl.category IN ('primary','secondary')
	ORDER BY DiagnosisMaster.participant_id ASC, TreatmentMaster.start_date DESC;";
$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
$participant_id = null;
$updated_counter = array();
$ids_to_update = array();
while($row = $results->fetch_assoc()){
	if(!$participant_id || $participant_id != $row['participant_id']) {
		$participant_id = $row['participant_id'];
		$notes = "'Diagnosis Date set by migration process using first treatment date.'";
		$notes = strlen($row['notes'])? "CONCAT(notes, ' ', $notes)" : $notes;
		$query = "UPDATE diagnosis_masters SET dx_date = '".$row['start_date']."', dx_date_accuracy = '".$row['start_date_accuracy']."', notes = $notes, modified = '$modified', modified_by = '$modified_by' WHERE id = ".$row['diagnosis_master_id'].";";
		mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		if(!isset($ids_to_update[$row['category']]) || !isset($ids_to_update[$row['category']][$row['controls_type']])) {
			$ids_to_update[$row['category']][$row['controls_type']] = array();
		}
		$ids_to_update[$row['category']][$row['controls_type']][] = $row['diagnosis_master_id'];
		if(!isset($updated_counter[$row['category'].' - '.$row['controls_type']]) || !isset($updated_counter[$row['category'].' - '.$row['controls_type']][$row['tx_method']])) {
			$updated_counter[$row['category'].' - '.$row['controls_type']][$row['tx_method']] = 0;
		}
		$updated_counter[$row['category'].' - '.$row['controls_type']][$row['tx_method']]++;
	}
}
foreach($updated_counter as $dx_type => $count_data) {
	foreach($count_data as $tx_method => $count) {
		$summary_msg['Extra-Tasks']['@@MESSAGE@@']["Empty Diagnosis Date Set"][] = "Set diagnosis date for <b>$count</b> diagnosis defined as <b>'$dx_type'</b> based on treatment date of a <b>'$tx_method'</b>.";
	}
}
foreach($ids_to_update as $dx_cat => $dx_data) {
	foreach($dx_data as $dx_type => $dx_ids) {
		$query = "INSERT INTO diagnosis_masters_revs (id, participant_id, primary_id , parent_id, diagnosis_control_id, dx_date, dx_date_accuracy, dx_nature, tumour_grade, notes, ovcare_clinical_history, ovcare_clinical_diagnosis, ovcare_tumor_site, survival_time_months_precision, ovcare_path_review_type, modified_by, version_created)
			(SELECT id, participant_id, primary_id , parent_id, diagnosis_control_id, dx_date, dx_date_accuracy, dx_nature, tumour_grade, notes, ovcare_clinical_history, ovcare_clinical_diagnosis, ovcare_tumor_site, survival_time_months_precision, ovcare_path_review_type, modified_by, modified
			FROM diagnosis_masters WHERE diagnosis_control_id = ".$atim_controls['diagnosis_control_ids'][$dx_cat][$dx_type]['id']." AND modified = '$modified' AND modified_by = '$modified_by' AND id IN (".implode(',',$dx_ids)."));";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		switch($atim_controls['diagnosis_control_ids'][$dx_cat][$dx_type]['detail_tablename']) {
			case 'ovcare_dxd_ovaries_endometriums':
				$query = "INSERT INTO ovcare_dxd_ovaries_endometriums_revs (diagnosis_master_id, initial_surgery_date_accuracy, initial_recurrence_date_accuracy, figo, laterality, censor, ovarian_histology, uterine_histology, histopathology, benign_lesions_precursor_presence, fallopian_tube_lesions, progression_status, version_created)
					(SELECT diagnosis_master_id, initial_surgery_date_accuracy, initial_recurrence_date_accuracy, figo, laterality, censor, ovarian_histology, uterine_histology, histopathology, benign_lesions_precursor_presence, fallopian_tube_lesions, progression_status, modified
					FROM diagnosis_masters
					INNER JOIN ovcare_dxd_ovaries_endometriums ON id = diagnosis_master_id
					WHERE diagnosis_control_id = ".$atim_controls['diagnosis_control_ids'][$dx_cat][$dx_type]['id']." AND modified = '$modified' AND modified_by = '$modified_by');";
				mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				break;
			case 'ovcare_dxd_others':
				$query = "INSERT INTO ovcare_dxd_others_revs (diagnosis_master_id, laterality, stage, histopathology, version_created)
					(SELECT diagnosis_master_id, laterality, stage, histopathology, modified
					FROM diagnosis_masters
					INNER JOIN ovcare_dxd_others ON id = diagnosis_master_id
					WHERE diagnosis_control_id = ".$atim_controls['diagnosis_control_ids'][$dx_cat][$dx_type]['id']." AND modified = '$modified' AND modified_by = '$modified_by');";
				mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				break;
			case 'dxd_secondaries':
			case 'dxd_primaries':
				$detail_tablename = $atim_controls['diagnosis_control_ids'][$dx_cat][$dx_type]['detail_tablename'];
				$query = "INSERT INTO ".$detail_tablename."_revs (diagnosis_master_id, version_created)
					(SELECT diagnosis_master_id, modified
					FROM diagnosis_masters
					INNER JOIN $detail_tablename ON id = diagnosis_master_id
					WHERE diagnosis_control_id = ".$atim_controls['diagnosis_control_ids'][$dx_cat][$dx_type]['id']." AND modified = '$modified' AND modified_by = '$modified_by');";
				mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				break;
			default:
				die('ERR238 728378732');
		}
	}
}

// Merge Blood & Tissue

mergeBloodAndTissue();

// Set Tissue Tube Position

$updated_aliquot_master_ids = loadTissuePosition($tmp_xls_reader->sheets, $sheets_keys, 'Inventory');

// Add Ischemia Time

addIschemiaTime();

// UPDATE MFPE Blocks

$updated_aliquot_master_ids = updateMFPEBlocks($tmp_xls_reader->sheets, $sheets_keys, 'MFPE Blocks', $updated_aliquot_master_ids);

//UPDATE normal tissu

updateNormalTissues($tmp_xls_reader->sheets, $sheets_keys, 'Normal Tumour');

//UPdate path review

updatePathReviews($tmp_xls_reader->sheets, $sheets_keys, 'path review_date_name');

//Final Aliquot Update 
// Set hemolysis Sign to no + Set storage method to snap frozen for tissue tube + Set inital storage datetime (if required)

$updated_aliquot_master_ids = updateFinalAliquotData($updated_aliquot_master_ids);

// Add tissue tube and block tissue section

$updated_aliquot_master_ids = updateTissueSection($updated_aliquot_master_ids);

// Aliquot Revs Table Update

finalAliquotMasterRevsInsert($updated_aliquot_master_ids);

// Set collecte volume and nbr of tube for blood tube received

updateCollectedBloodTubeInfo();

$query = "UPDATE versions SET permissions_regenerated = 0;";
mysqli_query($db_connection, $query) or die("Error [$query] ");

$ccl = 'but not committed!';
if(displayErrorAndMessage()) {
	mysqli_commit($db_connection);
	$ccl = 'and committed!';
}

echo "<br><FONT COLOR=\"green\" >
=====================================================================<br>
Migration Process done $ccl<br>
<br>=====================================================================</FONT><br><br>";

//===========================================================================================================================================================
// START functions
//===========================================================================================================================================================

function loadATiMControlData(){
	global $db_connection;
	$controls = array();
	// MiscIdentifier
	$query = "select id, misc_identifier_name, flag_unique FROM misc_identifier_controls WHERE flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['misc_identifier_controls'][$row['misc_identifier_name']] = array('id' => $row['id'], 'flag_unique' => $row['flag_unique']);
	}
	//dx
	$query = "SELECT id, category, controls_type, detail_tablename FROM diagnosis_controls WHERE flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die("Dx Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		$controls['diagnosis_control_ids'][$row['category']][$row['controls_type']] = array('id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	//event
	$query = "select id,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['event_controls'][$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	//trt
	$query = "select tc.id, tc.tx_method, tc.detail_tablename, te.id as te_id, te.detail_tablename as te_detail_tablename
		from treatment_controls tc
		LEFT JOIN treatment_extend_controls te ON tc.treatment_extend_control_id = te.id AND te.flag_active = '1'
		where tc.flag_active = '1';";
	$results = mysqli_query($db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		$controls['treatment_controls'][$row['tx_method']] = array(
			'treatment_control_id' => $row['id'], 
			'detail_tablename' => $row['detail_tablename'],
       		'te_treatment_control_id' => $row['te_id'],
			'te_detail_tablename' => $row['te_detail_tablename'],
		);
	}
	return $controls;
}

function setVoaToParticipantIds($atim_controls){
	global $db_connection;
	global $voas_to_participant_id;
	$voas_to_participant_id = array();
	//1
	$query = "SELECT participant_id, ovcare_collection_voa_nbr FROM collections;";
	$results = mysqli_query($db_connection, $query) or die("Main [line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		if(isset($voas_to_participant_id[$row['ovcare_collection_voa_nbr']])) {
			if($voas_to_participant_id[$row['ovcare_collection_voa_nbr']] != $row['participant_id']) {
				$summary_msg['VOA to Participant ID']['@@ERROR@@']["Voa linked to more than one participant"][] = "See V0A# ".$row['ovcare_collection_voa_nbr']." Linke to ATiM participant id :".$voas_to_participant_id[$row['ovcare_collection_voa_nbr']]." and ".$row['participant_id'];
			}
		} else {
			$voas_to_participant_id[$row['ovcare_collection_voa_nbr']] = $row['participant_id'];
		}
	}
	//2
	$query = "SELECT participant_id, identifier_value FROM misc_identifiers WHERE misc_identifier_control_id = ".$atim_controls['misc_identifier_controls']['unassigned VOA#']['id'].";";
	$results = mysqli_query($db_connection, $query) or die("Main [line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		if(isset($voas_to_participant_id[$row['identifier_value']])) {
			if($voas_to_participant_id[$row['identifier_value']] != $row['participant_id']) {
				$summary_msg['VOA to Participant ID']['@@ERROR@@']["Voa linked to more than one participant"][] = "See V0A# ".$row['identifier_value']." Linke to ATiM participant id :".$voas_to_participant_id[$row['identifier_value']]." and ".$row['participant_id'];
			}
		} else {
			$voas_to_participant_id[$row['identifier_value']] = $row['participant_id'];
		}
	}
}

//===========================================================================================================================================================
// End functions
//===========================================================================================================================================================

function mergeBloodAndTissue() {
	global $db_connection;
	global $summary_msg;
	
	// Tissue
	$query = "SELECT id, detail_tablename FROM sample_controls WHERE sample_type = 'tissue';";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$row = $results->fetch_assoc();
	$sample_control_id = $row['id'];
	$detail_tablename = $row['detail_tablename'];
	$query = "SELECT SampleMaster.id,collection_id,notes,participant_id,ovcare_collection_voa_nbr,
		supplier_dept, reception_by, reception_datetime, reception_datetime_accuracy, time_at_room_temp_mn, 
		ovcare_ischemia_time_mn, ovcare_tissue_type, tissue_source, ovcare_tissue_source_precision, tissue_laterality, ovcare_xenograft_collected
		FROM sample_masters SampleMaster
		INNER JOIN collections Collection ON Collection.id = SampleMaster.collection_id
		INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
		INNER JOIN $detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
		WHERE SampleMaster.deleted <> 1 AND sample_control_id = $sample_control_id ORDER BY collection_id;";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$previous_collection_id = null;
	$collection_tissues = array();
	while($row = $results->fetch_assoc()) {
		if($previous_collection_id && $previous_collection_id != $row['collection_id']) {
			mergeSpecimens($collection_tissues, 'tissue');
			$collection_tissues = array();
		}
		$collection_tissues[] = $row;
		$previous_collection_id = $row['collection_id'];
	}
	mergeSpecimens($collection_tissues, 'tissue');
		
	// Blood
	$query = "SELECT id, detail_tablename FROM sample_controls WHERE sample_type = 'blood';";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$row = $results->fetch_assoc();
	$sample_control_id = $row['id'];
	$detail_tablename = $row['detail_tablename'];
	$query = "SELECT SampleMaster.id,collection_id,notes,participant_id,ovcare_collection_voa_nbr,
		supplier_dept, time_at_room_temp_mn, reception_by, reception_datetime, reception_datetime_accuracy,
		blood_type, collected_tube_nbr, collected_volume, collected_volume_unit
		FROM sample_masters SampleMaster
		INNER JOIN collections Collection ON Collection.id = SampleMaster.collection_id
		INNER JOIN specimen_details SpecimenDetail ON SpecimenDetail.sample_master_id = SampleMaster.id
		INNER JOIN $detail_tablename SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
		WHERE SampleMaster.deleted <> 1 AND sample_control_id = $sample_control_id ORDER BY collection_id;";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$previous_collection_id = null;
	$collection_bloods = array();
	while($row = $results->fetch_assoc()) {
		if($previous_collection_id && $previous_collection_id != $row['collection_id']) {
			mergeSpecimens($collection_bloods, 'blood');
			$collection_bloods = array();
		}
		$collection_bloods[] = $row;
		$previous_collection_id = $row['collection_id'];
	}
	mergeSpecimens($collection_bloods, 'blood');
}

function mergeSpecimens($collection_specimens, $specimen_type) {
	global $db_connection;
	global $summary_msg;
	
	if(empty($collection_specimens) || sizeof($collection_specimens) == 1) return;
	
	$merged_specimen = array();	
	foreach($collection_specimens as $new_specimen) {	
		$sample_master_id = $new_specimen['id'];
		$notes = trim($new_specimen['notes']);
		$tmp_new_specimen = $new_specimen;	
		unset($tmp_new_specimen['id']);
		unset($tmp_new_specimen['notes']);
		$merged_specimen_key = '';		
		foreach($tmp_new_specimen as $key => $val) $merged_specimen_key .= $key.$val;
		$merged_specimen_key = md5($merged_specimen_key);
		if(!isset($merged_specimen[$merged_specimen_key])) {
			$merged_specimen[$merged_specimen_key] = array(
				'participant_id' => $new_specimen['participant_id'],
				'collection_id' => $new_specimen['collection_id'],
				'ovcare_collection_voa_nbr' => $new_specimen['ovcare_collection_voa_nbr'],
				'specimen_ids' => array(),
				'id_to_keep' => $sample_master_id,
				'specimen_type_precision' => ($specimen_type == 'blood')? $new_specimen['blood_type'] : $new_specimen['tissue_source'],
				'notes' => array());
		}
		$merged_specimen[$merged_specimen_key]['specimen_ids'][] = $sample_master_id;
		if(strlen($notes)) $merged_specimen[$merged_specimen_key]['notes'][] = $notes;
	}	
	foreach($merged_specimen as $new_merge_definition) {
		if(sizeof($new_merge_definition['specimen_ids']) > 1) {
			$sample_master_id_to_keep = $new_merge_definition['id_to_keep'];
			$deleted_sample_master_ids = array();
			foreach($new_merge_definition['specimen_ids'] as $sample_master_id_to_delete) {
				if($sample_master_id_to_delete != $sample_master_id_to_keep) {
					$deleted_sample_master_ids[] = $sample_master_id_to_delete;
					$queries = array(
						"UPDATE sample_masters SET parent_id = $sample_master_id_to_keep WHERE parent_id = $sample_master_id_to_delete;",
						"UPDATE sample_masters_revs SET parent_id = $sample_master_id_to_keep WHERE parent_id = $sample_master_id_to_delete;",
						"UPDATE sample_masters SET initial_specimen_sample_id = $sample_master_id_to_keep WHERE initial_specimen_sample_id = $sample_master_id_to_delete;",
						"UPDATE sample_masters_revs SET initial_specimen_sample_id = $sample_master_id_to_keep WHERE initial_specimen_sample_id = $sample_master_id_to_delete;",
						"UPDATE quality_ctrls SET sample_master_id = $sample_master_id_to_keep WHERE sample_master_id = $sample_master_id_to_delete",
						"UPDATE quality_ctrls_revs SET sample_master_id = $sample_master_id_to_keep WHERE sample_master_id = $sample_master_id_to_delete",
						"UPDATE specimen_review_masters SET sample_master_id = $sample_master_id_to_keep WHERE sample_master_id = $sample_master_id_to_delete",
						"UPDATE specimen_review_masters_revs SET sample_master_id = $sample_master_id_to_keep WHERE sample_master_id = $sample_master_id_to_delete",
						"UPDATE aliquot_masters SET sample_master_id = $sample_master_id_to_keep WHERE sample_master_id = $sample_master_id_to_delete",
						"UPDATE aliquot_masters_revs SET sample_master_id = $sample_master_id_to_keep WHERE sample_master_id = $sample_master_id_to_delete",					
						"DELETE FROM ".(($specimen_type == 'blood')? 'sd_spe_bloods' : 'sd_spe_tissues')." WHERE sample_master_id = $sample_master_id_to_delete;",
						"DELETE FROM ".(($specimen_type == 'blood')? 'sd_spe_bloods' : 'sd_spe_tissues')."_revs WHERE sample_master_id = $sample_master_id_to_delete;",
						"DELETE FROM specimen_details WHERE sample_master_id = $sample_master_id_to_delete;",
						"DELETE FROM specimen_details_revs WHERE sample_master_id = $sample_master_id_to_delete;",
						"UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null WHERE id = $sample_master_id_to_delete;",
						"UPDATE sample_masters_revs SET parent_id = null, initial_specimen_sample_id = null WHERE id = $sample_master_id_to_delete;",
						"DELETE FROM sample_masters WHERE id = $sample_master_id_to_delete;",
						"DELETE FROM sample_masters_revs WHERE id = $sample_master_id_to_delete;");
					foreach($queries as $query)	mysqli_query($db_connection, $query) or die("Main [line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				}
			}
			$summary_msg['Data Creation/Update Summary'][$new_merge_definition['participant_id']]["Merged $specimen_type specimens"][] = "Merged ".sizeof($new_merge_definition['specimen_ids']).' '.$new_merge_definition['specimen_type_precision']." $specimen_type specimens of the same collection (collection_id = '".$new_merge_definition['collection_id']."' / voA#".$new_merge_definition['ovcare_collection_voa_nbr'].") into specimen with code $sample_master_id_to_keep. (Deleted specimens with codes {". implode(',',$deleted_sample_master_ids).'})';	
			if(!empty($new_merge_definition['notes'])) {
				$notes = str_replace("'", "''", implode('. ', $new_merge_definition['notes']).'.');
				$queries = array(
					"UPDATE sample_masters SET notes = '$notes' WHERE id = $sample_master_id_to_keep;",
					"UPDATE sample_masters_revs SET notes = '$notes' WHERE id = $sample_master_id_to_keep;");
				foreach($queries as $query)	mysqli_query($db_connection, $query) or die("Main [line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				$summary_msg['Data Creation/Update Summary'][$new_merge_definition['participant_id']]["Merged $specimen_type specimens notes"][] = "Merged notes '$notes' of the merged specimens";
			}
		}
	}
}

function loadTissuePosition(&$wroksheetcells, $sheets_keys, $worksheet_name) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	
	$query = "SELECT storage_type, id, detail_tablename FROM storage_controls WHERE flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$storage_type_to_control_data = array();
	while($row = $results->fetch_assoc()) $storage_type_to_id[$row['storage_type']] = array($row['id'], $row['detail_tablename']);
	
	$query = "SELECT max(id) AS last_storage_master_id FROM storage_masters;";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$row = $results->fetch_assoc();
	$last_storage_master_id = $row['last_storage_master_id'];
	
	$box_control = array(
		'1' => '1 2 3 4 5 6 7 8 9',
		'2' => '10 11 12 13 14 15 16 17 18',
		'3' => '19 20 21 22 23 24 25 26 27',
		'4' => '28 29 30 31 32 33 34 35 36',
		'5' => '37 38 39 40 41 42 43 44 45',
		'6' => '46 47 48 49 50 51 52 53 54',
		'7' => '55 56 57 58 59 60 61 62 63',
		'8' => '64 65 66 67 68 69 70 71 72',
		'9' => '73 74 75 76 77 78 79 80 81');
	$aliquot_label_to_storage_data = array();
	$created_storages = array();	
	$first_box_row_excel_line_counter = 0;
	$positions = array();
	$box_data = array('worksheet' => $worksheet_name, 'freezer' => '', 'shelf' => '', 'rack14' => '', 'rack16' => '', 'box81' => '', 'aliquot_positions' => array());
	if(!isset($sheets_keys[$worksheet_name])) die('ERR 2387 3287 32 '.$worksheet_name);
	foreach($wroksheetcells[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if(!$first_box_row_excel_line_counter) {
			//Looking for new box labels
			$imploded_new_line = implode(' ', $new_line);
			if(preg_match('/Freezer\ #([0-9]+)/', $imploded_new_line, $matches)) $box_data['freezer'] = $matches[1];
			if(preg_match('/Shelf[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['shelf'] = $matches[1];
			if(preg_match('/Tower[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['rack14'] = $matches[1];
			if(preg_match('/Rack[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['rack16'] = $matches[1];
			if(preg_match('/Box[:\ #]{1,3}(.+)/', $imploded_new_line, $matches)) $box_data['box81'] = $matches[1];
			if(preg_match('/Freezer Box Name:\ (.+)$/', $imploded_new_line, $matches)) $box_data['box81'] = str_replace(array('Gyne Tumour Bank, '), array(''), $matches[1]);
			if($imploded_new_line == $box_control[1]) {
				if(implode('', array_keys($new_line)) != '2345678910') die('ERR23732732832832');
				$first_box_row_excel_line_counter = $excel_line_counter;
			}
		}
		if($first_box_row_excel_line_counter) {
			//Parsing box layout
			$diff = $excel_line_counter - $first_box_row_excel_line_counter;
			if(in_array($diff, array(0,2,4,6,8,10,12,14,16))) {
				//Positions
				if(implode(' ', $new_line) !== $box_control[(($diff/2)+1)]) die('WRONG BOX LAYOUT  : (in excel)['.implode(' ', $new_line)."] != (expected)[".$box_control[(($diff/2)+1)]."] Sheet $worksheet_name line $excel_line_counter");
				$positions = $new_line;
			} else if(in_array($diff, array(1,3,5,7,9,11,13,15,17))) {
				//$aliquots
				foreach($positions as $excel_column => $storage_coordinate_x) {
					if(isset($new_line[$excel_column]) && strlen($new_line[$excel_column])) {
						$box_data['aliquot_positions'][$storage_coordinate_x] = str_replace("\n", ' ', $new_line[$excel_column]);
					}
				}
			}
			if($diff > 16) {
				//End Of The Box
				recordNewBox($aliquot_label_to_storage_data, $created_storages, $box_data, $storage_type_to_id, $last_storage_master_id);
				//Reset data
				$first_box_row_excel_line_counter = 0;
				$positions = array();
				$box_data = array('worksheet' => $worksheet_name, 'freezer' => '', 'shelf' => '', 'rack14' => '', 'rack16' => '', 'box81' => '', 'aliquot_positions' => array());
				//In case last box row was empty and system was redeaing line with freezer info ,etc..
				$imploded_new_line = implode(' ', $new_line);
				if(preg_match('/Freezer\ #([0-9]+)/', $imploded_new_line, $matches)) $box_data['freezer'] = $matches[1];
				if(preg_match('/Shelf[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['shelf'] = $matches[1];
				if(preg_match('/Rack[:\ #]{1,3}([0-9]+)/', $imploded_new_line, $matches)) $box_data['rack16'] = $matches[1];
				if(preg_match('/Freezer Box Name:\ (.+)$/', $imploded_new_line, $matches)) $box_data['box81'] = str_replace(array('Gyne Tumour Bank, '), array(''), $matches[1]);
				if($imploded_new_line == '1 2 3 4 5 6 7 8 9') die('ERR 2378 327823782 7');
			}
		}
	}
	if($box_data['aliquot_positions']) {
		recordNewBox($aliquot_label_to_storage_data, $created_storages, $box_data, $storage_type_to_id, $last_storage_master_id);
	}
	
	//Update aliquot master data
	
	$nbr_of_aliquots_listed = sizeof($aliquot_label_to_storage_data);
	$query = "SELECT aliquot_label FROM (SELECT count(*) as nbr, aliquot_label FROM aliquot_masters 
		WHERE deleted <> 1 AND BINARY aliquot_label IN ('".implode("','", array_keys($aliquot_label_to_storage_data))."') GROUP BY aliquot_label) AS res WHERE res.nbr > 1";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		$aliquot_label = $row['aliquot_label'];
		$summary_msg['Aliquot Position Definition']['@@WARNING@@']["More than one aliquot"][] = "The aliquot label '$aliquot_label' listed in box ".$aliquot_label_to_storage_data[$aliquot_label]['box_name']." matches more than one aliquot into ATiM. Data has to be checked and position has then to be set manually after the process."; 
		unset($aliquot_label_to_storage_data[$aliquot_label]);
	}
	$all_aliquot_control_ids = array();
	$query = "SELECT AliquotMaster.id, AliquotMaster.aliquot_label, AliquotMaster.aliquot_control_id, AliquotMaster.in_stock, AliquotMaster.storage_master_id, StorageMaster.selection_label
		FROM aliquot_masters AliquotMaster
		LEFT JOIN storage_masters StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id 
		WHERE AliquotMaster.deleted <> 1 AND BINARY AliquotMaster.aliquot_label IN ('".implode("','", array_keys($aliquot_label_to_storage_data))."') ORDER BY aliquot_label";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$position_set_count = 0;
	$updated_aliquot_master_ids = array();
	while($row = $results->fetch_assoc()) {
		$aliquot_label = $row['aliquot_label'];
		if(!array_key_exists($aliquot_label, $aliquot_label_to_storage_data)) die('ERR 2387873287328732 '.$aliquot_label);
		if(strlen($row['storage_master_id'])) {
			$summary_msg['Aliquot Position Definition']['@@WARNING@@']["Aliquot postion already set"][] = "The aliquot '$aliquot_label' listed in box ".$aliquot_label_to_storage_data[$aliquot_label]['box_name']." is already positioned in ATiM into box '".$row['selection_label']."' (position ".$row['storage_coord_x']."). Data won't be updated.";
		} else if($row['in_stock'] == 'no') {
			$summary_msg['Aliquot Position Definition']['@@ERROR@@']["Aliquot not in stock"][] = "The aliquot '$aliquot_label' listed in box ".$aliquot_label_to_storage_data[$aliquot_label]['box_name']." is defined as not in stock in ATiM. Data won't be updated.";
		} else {
			$position_set_count++;
			$query = "UPDATE aliquot_masters SET storage_master_id = ".$aliquot_label_to_storage_data[$aliquot_label]['storage_master_id'].", storage_coord_x = '".$aliquot_label_to_storage_data[$aliquot_label]['storage_coord_x']."', modified_by = '$modified_by', modified = '$modified' WHERE id = ".$row['id'].";";
			mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
			$all_aliquot_control_ids[$row['aliquot_control_id']] = $row['aliquot_control_id'];	
			$updated_aliquot_master_ids[$row['id']] = $row['id'];
		}
		unset($aliquot_label_to_storage_data[$aliquot_label]);
	}
	foreach($aliquot_label_to_storage_data as $aliquot_label => $position_data) {
		$summary_msg['Aliquot Position Definition']['@@WARNING@@']["Aliquot not found"][] = "The aliquot label '$aliquot_label' listed in box ".$aliquot_label_to_storage_data[$aliquot_label]['box_name']." has not been found into ATiM. Data has to be checked and position has then to be set manually after the process.";
	}
	$summary_msg['Aliquot Position Definition']['@@MESSAGE@@']["Aliquot position set"][] = "The positions of $position_set_count/$nbr_of_aliquots_listed aliquots have been set.";
	//Update revs table
	$query = "SELECT detail_tablename FROM aliquot_controls WHERE id IN (".implode(',', $all_aliquot_control_ids).");";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) {
		if(!in_array($row['detail_tablename'], array('ad_tubes','ad_blocks'))) die('ERR32873287328 7'.$row['detail_tablename']);
	}
	
	return $updated_aliquot_master_ids;
}

function recordNewBox(&$aliquot_label_to_storage_data, &$created_storages, $box_data, $storage_type_to_id, &$last_storage_master_id){
	global $summary_msg;
	if(!strlen($box_data['box81'])) die('ERR 327328 7287eeeeeqqw2');
	if($box_data['box81'] == '#') $box_data['box81'] = 'Box?';
	//Manage
	$parent_storage_master_id = null;
	$parent_selection_label = '';
	foreach(array('freezer', 'shelf', 'rack14', 'rack16', 'box81') as $storage_type) {
		$box_data[$storage_type] = trim(preg_replace('/([0-9]+)(to)/' , '$1-', preg_replace('/(\ )+/', '', str_replace(array('Samples','Box'), array('',''), $box_data[$storage_type]))));
		if(strlen($box_data[$storage_type])) {
			$storage_key = "$storage_type#".$box_data[$storage_type];
			if(isset($created_storages[$storage_key])) {
				if($storage_type == 'box81') {
					$summary_msg['Aliquot Position Definition']['@@ERROR@@']['Box already created'][] = "Box [".$box_data['box81']."] has already been parsed. The box won't be created twice. See worksheet [".$box_data['worksheet']."].";
					return;
				}
				list($parent_storage_master_id, $parent_selection_label) = $created_storages[$storage_key];
			} else {
				if(strlen($box_data[$storage_type]) > 20) {
					$summary_msg['Aliquot Position Definition']['@@WARNING@@']["Storage 'Short Label' Too Long"][] = "The $storage_type short label [".$box_data[$storage_type]."] is too long and will be changed to [".substr($box_data[$storage_type], 0, 20)."]";
					$box_data[$storage_type] = substr($box_data[$storage_type], 0, 20);	
				}
				$parent_selection_label .= (empty($parent_selection_label)? '' : '-').$box_data[$storage_type];
				if(strlen($parent_selection_label) > 60) die('ERR3732773272733');
				$storage_controls_data = $storage_type_to_id[$storage_type];
				$last_storage_master_id++;
				$storage_master_data = array(
					"code" => $last_storage_master_id,
					"short_label" => $box_data[$storage_type],
					"selection_label" => $parent_selection_label,
					"storage_control_id" => $storage_controls_data[0],
					"parent_id" => $parent_storage_master_id);
				$parent_storage_master_id = customInsertRecord($storage_master_data, 'storage_masters', false, true);
				customInsertRecord(array('storage_master_id' => $parent_storage_master_id), $storage_controls_data[1], true, true);
				$created_storages[$storage_key] = array($parent_storage_master_id, $parent_selection_label);
			}
		}
	}
	if(!$parent_storage_master_id) die('ERR 7326 76 73262');
	foreach($box_data['aliquot_positions'] as $storage_coord_x => $aliquot_data) {
		if(!preg_match('/^([1-9])|([1-7][0-9])|(8[01])$/', $storage_coord_x)) die('ERRR 327 6237 67632 '.$storage_coord_x);
		$aliquot_label = preg_replace('/(\ )+/', '', str_replace("\n", ' ', $aliquot_data));
		$storage_datetime = '';
		$storage_datetime_accuracy = '';
		if(!isset($aliquot_label_to_storage_data[$aliquot_label])) {
			$aliquot_label_to_storage_data[$aliquot_label] = array('storage_master_id' => $parent_storage_master_id, 'storage_coord_x' => $storage_coord_x, 'storage_datetime' => $storage_datetime, 'storage_datetime_accuracy' => $storage_datetime_accuracy, 'box_name' => $box_data['box81']);
		} else {
			$summary_msg['Aliquot Position Definition']['@@ERROR@@']['Aliquot Label assigned to 2 different positions'][] = "See aliquot $aliquot_label in box [".$box_data['box81']."] position $storage_coord_x in worksheet [".$box_data['worksheet']."]. Aliquot was already defined as stored in box [".$aliquot_label_to_storage_data[$aliquot_label]['box_name']."] at positon [".$aliquot_label_to_storage_data[$aliquot_label]['storage_coord_x']."]. New position won't be imported.";
		}
	}
}

function addIschemiaTime() {
	global $db_connection;
	global $summary_msg;
	global $modified;
	global $modified_by;
	
	$query = "SELECT id, sample_type, detail_tablename FROM sample_controls WHERE sample_type IN ('serum', 'plasma');";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$controls = array();
	while($row = $results->fetch_assoc()) {
		$controls[$row['sample_type']] = array('id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}

	foreach($controls as $sample_type => $sample_control_data) {
		$query = "SELECT Collection.participant_id, SampleMaster.id as sample_master_id, SampleMaster.sample_code, '$sample_type' sample_type, SampleMaster.notes, ovcare_ischemia_time_mn
			FROM collections Collection
			INNEr JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
			INNER JOIN ".$sample_control_data['detail_tablename']." SampleDetail ON SampleMaster.id = SampleDetail.sample_master_id
			WHERE SampleMaster.notes LIKE '%Isch#%#%' AND SampleMaster.deleted <> 1;";
		$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		$updated_sample_master_ids = array();
		while($row = $results->fetch_assoc()) {
			if(preg_match('/Isch#([0-9]+)#/', $row['notes'], $matches)) {
				$new_ovcare_ischemia_time_mn = $matches[1];
				$ischemia_note = 'Isch#'.$new_ovcare_ischemia_time_mn.'#';
				$update = false;
				if(strlen($row['ovcare_ischemia_time_mn'])) {
					if($row['ovcare_ischemia_time_mn'] != $new_ovcare_ischemia_time_mn) {
						$update = true;
						$summary_msg['Ischemia Time']['@@WARNING@@']['Ischemia Time Conflict'][] = "The current ischemia time [".$row['ovcare_ischemia_time_mn']."] of the $sample_type with Sample System Code = ".$row['sample_code']." will be replaced by value [".$new_ovcare_ischemia_time_mn."] based on notes.";
					}
				} else {
					$update = true;
				}
				if($update) {
					$query = "UPDATE sample_masters SET notes = REPLACE(notes, 'Isch#".$new_ovcare_ischemia_time_mn."#', ''), modified = '$modified', modified_by = '$modified_by' WHERE id = ".$row['sample_master_id'];
 					mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
					$query = "UPDATE ".$sample_control_data['detail_tablename']." SET ovcare_ischemia_time_mn = '$new_ovcare_ischemia_time_mn' WHERE sample_master_id =  ".$row['sample_master_id'];
					mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
					$updated_sample_master_ids[] = $row['sample_master_id'];
					$summary_msg['Data Creation/Update Summary'][$row['participant_id']]["Updated $sample_type ischemia time"][] = "Set ischemia time to [$new_ovcare_ischemia_time_mn] for the $sample_type with Sample System Code = ".$row['sample_code'];						
				}
			}
		}
	}
	if($updated_sample_master_ids) {
		$query = "INSERT INTO sample_masters_revs (id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,sop_master_id,product_code,is_problematic,notes,
			modified_by,version_created)
			(SELECT id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,sop_master_id,product_code,is_problematic,notes,
			modified_by,modified FROM sample_masters WHERE id IN (".implode(',',$updated_sample_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		$query = "INSERT INTO derivative_details_revs (sample_master_id,creation_site,creation_by,creation_datetime,creation_datetime_accuracy,lab_book_master_id,sync_with_lab_book,version_created)
			(SELECT sample_master_id,creation_site,creation_by,creation_datetime,creation_datetime_accuracy,lab_book_master_id,sync_with_lab_book, '$modified' FROM derivative_details WHERE sample_master_id IN (".implode(',',$updated_sample_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));	
		$query = "INSERT INTO sd_der_plasmas_revs (sample_master_id,ovcare_ischemia_time_mn,version_created) (SELECT sample_master_id,ovcare_ischemia_time_mn, '$modified' FROM sd_der_plasmas WHERE sample_master_id IN (".implode(',',$updated_sample_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));	
		$query = "INSERT INTO sd_der_serums_revs (sample_master_id,ovcare_ischemia_time_mn,version_created) (SELECT sample_master_id,ovcare_ischemia_time_mn, '$modified' FROM sd_der_serums WHERE sample_master_id IN (".implode(',',$updated_sample_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	}
}

function updateMFPEBlocks(&$wroksheetcells, $sheets_keys, $worksheet_name, $updated_aliquot_master_ids) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	
	$query = "SELECT id FROM study_summaries WHERE deleted <> 1 AND title = 'Endometriosis';";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$row = $results->fetch_assoc();
	$study_summary_id = $row['id'];
	
	$query = "SELECT AliquotControl.id
	FROM aliquot_controls AliquotControl
	INNER JOIN sample_controls SampleControl ON SampleControl.id = AliquotControl.sample_control_id
	WHERE AliquotControl.aliquot_type = 'block'
	AND SampleControl.sample_type = 'tissue';";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$row = $results->fetch_assoc();
	$aliquot_control_id = $row['id'];
	
	$headers = array();
	if(!isset($sheets_keys[$worksheet_name])) die('ERR 2387 3287 32 '.$worksheet_name);
	foreach($wroksheetcells[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers  = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$query = "SELECT participant_id, AliquotMaster.id AS aliquot_master_id, AliquotMaster.aliquot_label, AliquotMaster.study_summary_id, Study.title, AliquotDetail.block_type
				FROM collections Collection
				INNER JOIN aliquot_masters AliquotMaster ON AliquotMaster.collection_id = Collection.id
				INNER JOIN ad_blocks AliquotDetail ON AliquotDetail.aliquot_master_id = AliquotMaster.id
				LEFT JOIN study_summaries Study ON Study.id = AliquotMaster.study_summary_id
				WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = $aliquot_control_id
				AND Collection.ovcare_collection_voa_nbr = '".$new_line_data['VOA#']."';";
			$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
			$block_found = false;
			while($row = $results->fetch_assoc()) {
				$aliquot_master_id = $row['aliquot_master_id'];
				if($row['study_summary_id'] && $row['study_summary_id'] != $study_summary_id) {
					$summary_msg['MFPE blocks update']['@@WARNING@@']['Block already linked to a study'][] = "A MFPE block is already linked to a study '".$row['title']."'. Study will be updated to 'Endometriosis'. See block with sample identifier ".$row['aliquot_label']." && aliquot_master_id = $aliquot_master_id.";
				}
				$query = "UPDATE aliquot_masters SET study_summary_id = $study_summary_id, modified = '$modified', modified_by = '$modified_by' WHERE id = $aliquot_master_id;";
				mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				$query = "UPDATE ad_blocks SET block_type = 'MFPE' WHERE aliquot_master_id = $aliquot_master_id;";
				mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				$previously_defined_as_msg = strlen($row['block_type'])? "(previously defined as '".$row['block_type']."' block)" : '';
				$summary_msg['Data Creation/Update Summary'][$row['participant_id']]["Updated MFPE blocks of 'Endometriosis' project"][] = "Set block type to ['MFPE'] and study to 'Endometriosis' for block $previously_defined_as_msg with sample identifier ".$row['aliquot_label']." (aliquot_master_id = $aliquot_master_id).";
				$updated_aliquot_master_ids[$aliquot_master_id] = $aliquot_master_id;
				$block_found = true;
			}
			if(!$block_found) {
				$summary_msg['MFPE blocks update']['@@WARNING@@']['No block'][] = "No tissue block has been found for VOA# '".$new_line_data['VOA#']."'";
			} 
		}
	}
	
	return $updated_aliquot_master_ids;
}

function updateNormalTissues(&$wroksheetcells, $sheets_keys, $worksheet_name) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;

	$query = "SELECT SampleControl.id FROM sample_controls SampleControl WHERE SampleControl.sample_type = 'tissue';";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$row = $results->fetch_assoc();
	$sample_control_id = $row['id'];
	
	$updated_sample_master_ids = array();
	
	// ** Set tumoral tissue by default **
	
	$query = "SELECT SampleMaster.id
		FROM sample_controls SampleControl, sample_masters SampleMaster, sd_spe_tissues SampleDetail
		WHERE SampleControl.sample_type = 'tissue'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND (SampleDetail.ovcare_tissue_type = '' OR SampleDetail.ovcare_tissue_type IS NULL);";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	if($results->num_rows) $summary_msg['Default Aliquot Data Update']['@@MESSAGE@@']['Tissue type set to tumour by default'][] = $results->num_rows." records updated.";
	while($row = $results->fetch_assoc()) { $updated_sample_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE sample_controls SampleControl, sample_masters SampleMaster, sd_spe_tissues SampleDetail
		SET SampleDetail.ovcare_tissue_type = 'tumour', SampleMaster.modified = '$modified', SampleMaster.modified_by = '$modified_by'
		WHERE SampleControl.sample_type = 'tissue'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND (SampleDetail.ovcare_tissue_type = '' OR SampleDetail.ovcare_tissue_type IS NULL);";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		
	// Then update normal tissue
	
	$headers = array();
	if(!isset($sheets_keys[$worksheet_name])) die('ERR 2387 3287 32 '.$worksheet_name);
	foreach($wroksheetcells[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers  = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$query = "SELECT participant_id, SampleMaster.id AS sample_master_id
				FROM collections Collection
				INNER JOIN sample_masters SampleMaster ON SampleMaster.collection_id = Collection.id
				INNER JOIN sd_spe_tissues SampleDetail ON SampleDetail.sample_master_id = SampleMaster.id
				WHERE SampleMaster.deleted <> 1 AND SampleMaster.sample_control_id = $sample_control_id
				AND Collection.ovcare_collection_voa_nbr = '".$new_line_data['VOA Number']."';";
			$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
			$tissue_found = false;
			while($row = $results->fetch_assoc()) {
				$sample_master_id = $row['sample_master_id'];
				$query = "UPDATE sample_masters SET modified = '$modified', modified_by = '$modified_by' WHERE id = $sample_master_id;";
				mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				$query = "UPDATE sd_spe_tissues SET ovcare_tissue_type = 'normal' WHERE sample_master_id = $sample_master_id;";
				mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				$summary_msg['Data Creation/Update Summary'][$row['participant_id']]["Set tisue to 'Normal'"][] = "See sample_master_id = $sample_master_id).";
				$updated_sample_master_ids[$sample_master_id] = $sample_master_id;
				$tissue_found = true;
			}
			if(!$tissue_found) {
				$summary_msg['Normal Tissue update']['@@WARNING@@']['No Tissue'][] = "No tissue has been found for VOA# '".$new_line_data['VOA Number']."'. Tissue won't be set to 'Normal'.";
			}
		}
	}
	if($updated_sample_master_ids) {
		$query = "INSERT INTO sample_masters_revs (id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,sop_master_id,product_code,is_problematic,notes,
			modified_by,version_created)
			(SELECT id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,sop_master_id,product_code,is_problematic,notes,
			modified_by,modified FROM sample_masters WHERE id IN (".implode(',',$updated_sample_master_ids)."))";	
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		$query = "INSERT INTO specimen_details_revs (sample_master_id, supplier_dept, time_at_room_temp_mn, reception_by, reception_datetime, reception_datetime_accuracy, version_created)
			(SELECT sample_master_id, supplier_dept, time_at_room_temp_mn, reception_by, reception_datetime, reception_datetime_accuracy, '$modified' FROM specimen_details WHERE sample_master_id IN (".implode(',',$updated_sample_master_ids)."))";	
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));	
		$query = "INSERT INTO sd_spe_tissues_revs (sample_master_id, tissue_source, ovcare_tissue_source_precision, tissue_nature, tissue_laterality, pathology_reception_datetime, pathology_reception_datetime_accuracy, tissue_size,
			tissue_size_unit, tissue_weight, tissue_weight_unit, ovcare_ischemia_time_mn, ovcare_tissue_type, ovcare_xenograft_collected, ovcare_cell_culture_collected, version_created) 
			(SELECT sample_master_id, tissue_source, ovcare_tissue_source_precision, tissue_nature, tissue_laterality, pathology_reception_datetime, pathology_reception_datetime_accuracy, tissue_size,
			tissue_size_unit, tissue_weight, tissue_weight_unit, ovcare_ischemia_time_mn, ovcare_tissue_type, ovcare_xenograft_collected, ovcare_cell_culture_collected, '$modified' FROM sd_spe_tissues WHERE sample_master_id IN (".implode(',',$updated_sample_master_ids)."))";		
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));	
	}
}

function updatePathReviews(&$wroksheetcells, $sheets_keys, $worksheet_name) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;

	$query = "SELECT id, controls_type FROM diagnosis_controls WHERE controls_type IN ('other' ,'ovary or endometrium tumor') AND category = 'primary' AND flag_active = 1;";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$sample_controls = array();
	while($row = $results->fetch_assoc()) $sample_controls[$row['controls_type']] = $row['id'];
	
	$headers = array();
	$updated_diagnosis_master_ids = array();
	if(!isset($sheets_keys[$worksheet_name])) die('ERR 2387 3287 32 '.$worksheet_name);
	foreach($wroksheetcells[$sheets_keys[$worksheet_name]]['cells'] as $excel_line_counter => $new_line) {
		if($excel_line_counter == 1) {
			$headers  = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$pathologist = strtolower($new_line_data['Pathologist ']);
			$new_line_data['Date Re-Reviewed Accuracy'] = 'c';
			$review_date = getDateAndAccuracy($worksheet_name, $new_line_data, $worksheet_name, 'Date Re-Reviewed', 'Date Re-Reviewed Accuracy', $excel_line_counter);
			$date_sql_satement = $review_date? "ovcare_date_reviewed = '".$review_date['date']."', ovcare_date_reviewed_accuracy = '".$review_date['accuracy']."'," : '';
			$query = "SELECT Collection.participant_id, DiagnosisMaster.id AS diagnosis_master_id
				FROM collections Collection
				INNER JOIN diagnosis_masters DiagnosisMaster ON DiagnosisMaster.participant_id = Collection.participant_id
				WHERE DiagnosisMaster.deleted <> 1 AND DiagnosisMaster.diagnosis_control_id IN (".implode(',',$sample_controls).")
				AND Collection.deleted <> 1 AND Collection.ovcare_collection_voa_nbr = '".$new_line_data['VOA Number']."';";
			$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
			$dx_found = false;
			while($row = $results->fetch_assoc()) {
				$diagnosis_master_id = $row['diagnosis_master_id'];
				$query = "UPDATE diagnosis_masters SET ovcare_pathologist_reviewed = '$pathologist', $date_sql_satement modified = '$modified', modified_by = '$modified_by' WHERE id = $diagnosis_master_id;";
				mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
				$summary_msg['Data Creation/Update Summary'][$row['participant_id']]["Diagnosis Review Update"][] = "See diagnosis_master_id = $diagnosis_master_id).";
				$updated_diagnosis_master_ids[] = $diagnosis_master_id;
				$dx_found = true;
			}
			if(!$dx_found) {
				$summary_msg['Diagnosis Review Data']['@@WARNING@@']['No Diagnosis To Update'][] = "No diagnosis to update has been found for VOA# '".$new_line_data['VOA Number']."'. Path Review won't be recorded.";
			}
		}
	}
	if($updated_diagnosis_master_ids) {
		$query = "INSERT INTO diagnosis_masters_revs (id, participant_id, primary_id , parent_id, diagnosis_control_id, dx_date, dx_date_accuracy, tumour_grade, notes, ovcare_clinical_history, ovcare_clinical_diagnosis, ovcare_tumor_site, survival_time_months_precision, ovcare_path_review_type, modified_by, version_created)
			(SELECT id, participant_id, primary_id , parent_id, diagnosis_control_id, dx_date, dx_date_accuracy, tumour_grade, notes, ovcare_clinical_history, ovcare_clinical_diagnosis, ovcare_tumor_site, survival_time_months_precision, ovcare_path_review_type, modified_by, modified
			FROM diagnosis_masters WHERE id IN (".implode(',',$updated_diagnosis_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		$query = "INSERT INTO ovcare_dxd_ovaries_endometriums_revs (diagnosis_master_id, initial_surgery_date_accuracy, initial_recurrence_date_accuracy, figo, laterality, censor, ovarian_histology, uterine_histology, histopathology, benign_lesions_precursor_presence, fallopian_tube_lesions, progression_status, version_created)
			(SELECT diagnosis_master_id, initial_surgery_date_accuracy, initial_recurrence_date_accuracy, figo, laterality, censor, ovarian_histology, uterine_histology, histopathology, benign_lesions_precursor_presence, fallopian_tube_lesions, progression_status, '$modified'
			FROM ovcare_dxd_ovaries_endometriums WHERE diagnosis_master_id IN (".implode(',',$updated_diagnosis_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		$query = "INSERT INTO ovcare_dxd_others_revs (diagnosis_master_id, laterality, stage, histopathology, version_created)
			(SELECT diagnosis_master_id, laterality, stage, histopathology, '$modified'
			FROM ovcare_dxd_others WHERE diagnosis_master_id IN (".implode(',',$updated_diagnosis_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	}
}

function updateFinalAliquotData($updated_aliquot_master_ids) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	
	// ** Set hemolysis Sign to no Set storage method to snap frozen for tissue tube Set inital storage datetime **

	$query = "SELECT AliquotMaster.id
		FROM aliquot_masters AliquotMaster, ad_tubes AliquotDetail, aliquot_controls AliquotControl
		WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = AliquotControl.id
		AND AliquotControl.detail_form_alias LIKE '%ad_hemolysis%'
		AND AliquotMaster.id = AliquotDetail.aliquot_master_id AND (AliquotDetail.hemolysis_signs = '' OR AliquotDetail.hemolysis_signs IS NULL);";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	if($results->num_rows) $summary_msg['Default Aliquot Data Update']['@@MESSAGE@@']["Hemolysis signs set to 'no' by default"][] = $results->num_rows." records updated.";
	while($row = $results->fetch_assoc()) { $updated_aliquot_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail, aliquot_controls AliquotControl
		SET AliquotDetail.hemolysis_signs = 'n', AliquotMaster.modified = '$modified', AliquotMaster.modified_by = '$modified_by'
		WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = AliquotControl.id
		AND AliquotControl.detail_form_alias LIKE '%ad_hemolysis%'
		AND AliquotMaster.id = AliquotDetail.aliquot_master_id AND (AliquotDetail.hemolysis_signs = '' OR AliquotDetail.hemolysis_signs IS NULL);";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	// ** Set storage method to snap frozen for tissue tube Set inital storage datetime **
	
	$query = "SELECT AliquotMaster.id
		FROM aliquot_masters AliquotMaster, ad_tubes AliquotDetail, aliquot_controls AliquotControl, sample_controls SampleControl
		WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = AliquotControl.id
		AND SampleControl.sample_type = 'tissue'
		AND AliquotControl.aliquot_type = 'tube' AND AliquotControl.sample_control_id = SampleControl.id
		AND AliquotMaster.id = AliquotDetail.aliquot_master_id
		AND (AliquotDetail.ovcare_storage_method = '' OR AliquotDetail.ovcare_storage_method IS NULL);";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	if($results->num_rows) $summary_msg['Default Aliquot Data Update']['@@MESSAGE@@']["Tissue tubes storage method set to 'snap frozen' by default"][] = $results->num_rows." records updated.";
	while($row = $results->fetch_assoc()) { $updated_aliquot_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail, aliquot_controls AliquotControl, sample_controls SampleControl
		SET AliquotDetail.ovcare_storage_method = 'snap frozen', AliquotMaster.modified = '$modified', AliquotMaster.modified_by = '$modified_by'
		WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = AliquotControl.id
		AND SampleControl.sample_type = 'tissue'
		AND AliquotControl.aliquot_type = 'tube' AND AliquotControl.sample_control_id = SampleControl.id
		AND AliquotMaster.id = AliquotDetail.aliquot_master_id
		AND (AliquotDetail.ovcare_storage_method = '' OR AliquotDetail.ovcare_storage_method IS NULL);";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	// ** Set inital storage datetime **
	
	$query = "SELECT AliquotMaster.id
		FROM aliquot_controls AliquotControl, sample_controls SampleControl, aliquot_masters AliquotMaster, collections Collection
		WHERE SampleControl.sample_type IN ('ascite','blood cell','plasma','saliva','serum','tissue')
		AND SampleControl.id = AliquotControl.sample_control_id
		AND AliquotMaster.aliquot_control_id = AliquotControl.id AND AliquotMaster.deleted <> 1
		AND Collection.id = AliquotMaster.collection_id
		AND (AliquotMaster.storage_datetime IS NULL OR AliquotMaster.storage_datetime = '')
		AND Collection.collection_datetime IS NOT NULL AND Collection.collection_datetime != ''
		AND Collection.collection_datetime_accuracy IN ('i', 'c');";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$upated_records_count = $results->num_rows;
	while($row = $results->fetch_assoc()) { $updated_aliquot_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE aliquot_controls AliquotControl, sample_controls SampleControl, aliquot_masters AliquotMaster, collections Collection
		SET AliquotMaster.storage_datetime = Collection.collection_datetime, AliquotMaster.storage_datetime_accuracy = 'h', AliquotMaster.modified = '$modified', AliquotMaster.modified_by = '$modified_by'
		WHERE SampleControl.sample_type IN ('ascite','blood cell','plasma','saliva','serum','tissue')
		AND SampleControl.id = AliquotControl.sample_control_id
		AND AliquotMaster.aliquot_control_id = AliquotControl.id AND AliquotMaster.deleted <> 1
		AND Collection.id = AliquotMaster.collection_id
		AND (AliquotMaster.storage_datetime IS NULL OR AliquotMaster.storage_datetime = '')
		AND Collection.collection_datetime IS NOT NULL AND Collection.collection_datetime != ''
		AND Collection.collection_datetime_accuracy IN ('i', 'c');";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$query = "SELECT AliquotMaster.id
		FROM aliquot_controls AliquotControl, sample_controls SampleControl, aliquot_masters AliquotMaster, collections Collection
		WHERE SampleControl.sample_type IN ('ascite','blood cell','plasma','saliva','serum','tissue')
		AND SampleControl.id = AliquotControl.sample_control_id
		AND AliquotMaster.aliquot_control_id = AliquotControl.id AND AliquotMaster.deleted <> 1
		AND Collection.id = AliquotMaster.collection_id
		AND (AliquotMaster.storage_datetime IS NULL OR AliquotMaster.storage_datetime = '')
		AND Collection.collection_datetime IS NOT NULL AND Collection.collection_datetime != ''
		AND Collection.collection_datetime_accuracy NOT IN ('i', 'c');";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$upated_records_count += $results->num_rows;
	while($row = $results->fetch_assoc()) { $updated_aliquot_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE aliquot_controls AliquotControl, sample_controls SampleControl, aliquot_masters AliquotMaster, collections Collection
		SET AliquotMaster.storage_datetime = Collection.collection_datetime, AliquotMaster.storage_datetime_accuracy = Collection.collection_datetime_accuracy
		WHERE SampleControl.sample_type IN ('ascite','blood cell','plasma','saliva','serum','tissue')
		AND SampleControl.id = AliquotControl.sample_control_id
		AND AliquotMaster.aliquot_control_id = AliquotControl.id AND AliquotMaster.deleted <> 1
		AND Collection.id = AliquotMaster.collection_id
		AND (AliquotMaster.storage_datetime IS NULL OR AliquotMaster.storage_datetime = '')
		AND Collection.collection_datetime IS NOT NULL AND Collection.collection_datetime != ''
		AND Collection.collection_datetime_accuracy NOT IN ('i', 'c');";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	if($upated_records_count) $summary_msg['Default Aliquot Data Update']['@@MESSAGE@@']["Set default storage date to collection date"][] = $upated_records_count." records updated.";
	
	return $updated_aliquot_master_ids;
}

function updateTissueSection($updated_aliquot_master_ids) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	
	// Tissue Tube
	
	$query = "SELECT AliquotMaster.id, Collection.ovcare_collection_voa_nbr, AliquotMaster.aliquot_label
		FROM aliquot_masters AliquotMaster, ad_tubes AliquotDetail, aliquot_controls AliquotControl, sample_controls SampleControl, collections Collection
		WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = AliquotControl.id
		AND SampleControl.sample_type = 'tissue'
		AND AliquotControl.aliquot_type = 'tube' AND AliquotControl.sample_control_id = SampleControl.id
		AND AliquotMaster.id = AliquotDetail.aliquot_master_id
		AND Collection.id = AliquotMaster.collection_id
		AND (AliquotDetail.ocvare_tissue_section = '' OR AliquotDetail.ocvare_tissue_section IS NULL) AND AliquotMaster.aliquot_label NOT REGEXP('^VOA[0-9]+[a-zA-Z]+$')";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) $summary_msg['Tissue Section Update']['@@WARNING@@']["Unable to extract tissue section from tube sample identifier"][] = "See tissue tube Sample Identifier [".$row['aliquot_label']."]. Tissue section won' be updated";

	$query = "SELECT AliquotMaster.id, Collection.ovcare_collection_voa_nbr, AliquotMaster.aliquot_label
		FROM aliquot_masters AliquotMaster, ad_tubes AliquotDetail, aliquot_controls AliquotControl, sample_controls SampleControl, collections Collection
		WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = AliquotControl.id
		AND SampleControl.sample_type = 'tissue'
		AND AliquotControl.aliquot_type = 'tube' AND AliquotControl.sample_control_id = SampleControl.id
		AND AliquotMaster.id = AliquotDetail.aliquot_master_id
		AND Collection.id = AliquotMaster.collection_id
		AND (AliquotDetail.ocvare_tissue_section = '' OR AliquotDetail.ocvare_tissue_section IS NULL) AND AliquotMaster.aliquot_label REGEXP('^VOA[0-9]+[a-zA-Z]+$')";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$upated_records_count = 0;
	while($row = $results->fetch_assoc()) {
		$aliquot_master_id = $row['id'];
		$ovcare_collection_voa_nbr = $row['ovcare_collection_voa_nbr'];
		$aliquot_label = $row['aliquot_label'];
		if(preg_match('/^VOA[0]*'.$ovcare_collection_voa_nbr.'([A-Za-z]+)$/', $aliquot_label, $matches)) {
			$query = "UPDATE aliquot_masters AliquotMaster, ad_tubes AliquotDetail
				SET AliquotDetail.ocvare_tissue_section = '".$matches[1]."', AliquotMaster.modified = '$modified', AliquotMaster.modified_by = '$modified_by'
				WHERE AliquotMaster.id = AliquotDetail.aliquot_master_id
				AND AliquotMaster.id = $aliquot_master_id";
			mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
			$upated_records_count++;
			$updated_aliquot_master_ids[$aliquot_master_id] = $aliquot_master_id;
		} else {
			$summary_msg['Tissue Section Update']['@@ERROR@@']["Wrong Sample Identifier"][] = "The sample identifier [$aliquot_label] does not match the VOA# [$ovcare_collection_voa_nbr]. Tissue section won't be updated.";
		}
	}
	$summary_msg['Tissue Section Update']['@@MESSAGE@@']["Set tissue tube section"][] = $upated_records_count." records updated.";
	
	// Tissue Block
	
	$query = "SELECT AliquotMaster.id, Collection.ovcare_collection_voa_nbr, AliquotMaster.aliquot_label
		FROM aliquot_masters AliquotMaster, ad_blocks AliquotDetail, aliquot_controls AliquotControl, sample_controls SampleControl, collections Collection
		WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = AliquotControl.id
		AND SampleControl.sample_type = 'tissue'
		AND AliquotControl.aliquot_type = 'block' AND AliquotControl.sample_control_id = SampleControl.id
		AND AliquotMaster.id = AliquotDetail.aliquot_master_id
		AND Collection.id = AliquotMaster.collection_id
		AND (AliquotDetail.ocvare_tissue_section = '' OR AliquotDetail.ocvare_tissue_section IS NULL) AND AliquotMaster.aliquot_label NOT REGEXP('^VOA[0-9]+[a-zA-Z]+[0-9]{0,5}[\ ]{0,1}$')";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) $summary_msg['Tissue Section Update']['@@WARNING@@']["Unable to extract tissue section from block sample identifier"][] = "See tissue block Sample Identifier [".$row['aliquot_label']."]. Tissue section won' be updated";
	
	$query = "SELECT AliquotMaster.id, Collection.ovcare_collection_voa_nbr, AliquotMaster.aliquot_label
		FROM aliquot_masters AliquotMaster, ad_blocks AliquotDetail, aliquot_controls AliquotControl, sample_controls SampleControl, collections Collection
		WHERE AliquotMaster.deleted <> 1 AND AliquotMaster.aliquot_control_id = AliquotControl.id
		AND SampleControl.sample_type = 'tissue'
		AND AliquotControl.aliquot_type = 'block' AND AliquotControl.sample_control_id = SampleControl.id
		AND AliquotMaster.id = AliquotDetail.aliquot_master_id
		AND Collection.id = AliquotMaster.collection_id
		AND (AliquotDetail.ocvare_tissue_section = '' OR AliquotDetail.ocvare_tissue_section IS NULL) AND AliquotMaster.aliquot_label REGEXP('^VOA[0-9]+[a-zA-Z]+[0-9]{0,5}[\ ]{0,1}$')";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$upated_records_count = 0;
	while($row = $results->fetch_assoc()) {
		$aliquot_master_id = $row['id'];
		$ovcare_collection_voa_nbr = $row['ovcare_collection_voa_nbr'];
		$aliquot_label = $row['aliquot_label'];
		if(preg_match('/^VOA[0]*'.$ovcare_collection_voa_nbr.'([A-Za-z]+[0-9]{0,5})[\ ]{0,1}$/', $aliquot_label, $matches)) {
			$query = "UPDATE aliquot_masters AliquotMaster, ad_blocks AliquotDetail
				SET AliquotDetail.ocvare_tissue_section = '".$matches[1]."', AliquotMaster.modified = '$modified', AliquotMaster.modified_by = '$modified_by'
				WHERE AliquotMaster.id = AliquotDetail.aliquot_master_id
				AND AliquotMaster.id = $aliquot_master_id";
			mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
			$upated_records_count++;
			$updated_aliquot_master_ids[$aliquot_master_id] = $aliquot_master_id;
		} else {
			$summary_msg['Tissue Section Update']['@@ERROR@@']["Wrong Sample Identifier"][] = "The sample identifier [$aliquot_label] does not match the VOA# [$ovcare_collection_voa_nbr]. Tissue section won't be updated.";
		}
	}
	$summary_msg['Tissue Section Update']['@@MESSAGE@@']["Set tissue block section"][] = $upated_records_count." records updated.";
	
	return $updated_aliquot_master_ids;	
}

function finalAliquotMasterRevsInsert($updated_aliquot_master_ids) {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	
	$query = "INSERT INTO aliquot_masters_revs (id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
		study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes, modified_by,version_created) (
		SELECT id,barcode,aliquot_label,aliquot_control_id,collection_id,sample_master_id,sop_master_id,initial_volume,current_volume,in_stock,in_stock_detail,use_counter,
		study_summary_id,storage_datetime,storage_datetime_accuracy,storage_master_id,storage_coord_x,storage_coord_y,product_code,notes, modified_by,modified FROM aliquot_masters WHERE id IN (".implode(',',$updated_aliquot_master_ids)."));";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$query = "INSERT INTO ad_tubes_revs (aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,ovcare_storage_method,ocvare_tissue_section,version_created)
		(SELECT aliquot_master_id,lot_number,concentration,concentration_unit,cell_count,cell_count_unit,cell_viability,hemolysis_signs,ovcare_storage_method,ocvare_tissue_section,'$modified' FROM ad_tubes WHERE aliquot_master_id IN (".implode(',',$updated_aliquot_master_ids)."));";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$query = "INSERT INTO ad_blocks_revs (aliquot_master_id,block_type,patho_dpt_block_code,ocvare_tissue_section,version_created)
		(SELECT aliquot_master_id,block_type,patho_dpt_block_code,ocvare_tissue_section,'$modified' FROM ad_blocks WHERE aliquot_master_id IN (".implode(',',$updated_aliquot_master_ids)."));";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
}

function updateCollectedBloodTubeInfo() {
	global $db_connection;
	global $modified_by;
	global $modified;
	global $summary_msg;
	
	$updated_sample_master_ids = array();
	
	//VOA509-2301:  for samples which we received blood:  1 tube of EDTA (6.0mL)
	
	$query = "SELECT SampleMaster.id
		FROM sample_controls SampleControl, sample_masters SampleMaster, sd_spe_bloods SampleDetail, collections Collection
		WHERE SampleControl.sample_type = 'blood'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND Collection.id = SampleMaster.collection_id
	 	AND (SampleDetail.collected_volume = '' OR SampleDetail.collected_volume IS NULL)
	 	AND (SampleDetail.collected_tube_nbr = '' OR SampleDetail.collected_tube_nbr IS NULL)
		AND SampleDetail.blood_type = 'EDTA' AND Collection.ovcare_collection_voa_nbr >= 509 AND Collection.ovcare_collection_voa_nbr <= 2301;";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$upated_records_count = $results->num_rows;
	while($row = $results->fetch_assoc()) { $updated_sample_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE sample_controls SampleControl, sample_masters SampleMaster, sd_spe_bloods SampleDetail, collections Collection
		SET SampleDetail.collected_volume = '6.0', SampleDetail.collected_volume_unit = 'ml', SampleDetail.collected_tube_nbr = '1', SampleMaster.modified = '$modified', SampleMaster.modified_by = '$modified_by'
		WHERE SampleControl.sample_type = 'blood'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND Collection.id = SampleMaster.collection_id
	 	AND (SampleDetail.collected_volume = '' OR SampleDetail.collected_volume IS NULL)
	 	AND (SampleDetail.collected_tube_nbr = '' OR SampleDetail.collected_tube_nbr IS NULL)
		AND SampleDetail.blood_type = 'EDTA' AND Collection.ovcare_collection_voa_nbr >= 509 AND Collection.ovcare_collection_voa_nbr <= 2301;";	
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	if($upated_records_count) $summary_msg['Blood tubes: Collected volume and tube nbr update']['@@MESSAGE@@']["EDTA of VOA# 509-2301 (1 tube / 6ml)"][] = $upated_records_count." records updated.";
	
	//VOA509-2301:  for samples which we received blood:  1 tube of serum (6.0mL)
	
	$query = "SELECT SampleMaster.id
		FROM sample_controls SampleControl, sample_masters SampleMaster, sd_spe_bloods SampleDetail, collections Collection
		WHERE SampleControl.sample_type = 'blood'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND Collection.id = SampleMaster.collection_id
	 	AND (SampleDetail.collected_volume = '' OR SampleDetail.collected_volume IS NULL)
	 	AND (SampleDetail.collected_tube_nbr = '' OR SampleDetail.collected_tube_nbr IS NULL)
		AND SampleDetail.blood_type = 'serum' AND Collection.ovcare_collection_voa_nbr >= 509 AND Collection.ovcare_collection_voa_nbr <= 2301;";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$upated_records_count = $results->num_rows;
	while($row = $results->fetch_assoc()) { $updated_sample_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE sample_controls SampleControl, sample_masters SampleMaster, sd_spe_bloods SampleDetail, collections Collection
		SET SampleDetail.collected_volume = '6.0', SampleDetail.collected_volume_unit = 'ml', SampleDetail.collected_tube_nbr = '1', SampleMaster.modified = '$modified', SampleMaster.modified_by = '$modified_by'
		WHERE SampleControl.sample_type = 'blood'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND Collection.id = SampleMaster.collection_id
		AND (SampleDetail.collected_volume = '' OR SampleDetail.collected_volume IS NULL)
		AND (SampleDetail.collected_tube_nbr = '' OR SampleDetail.collected_tube_nbr IS NULL)
		AND SampleDetail.blood_type = 'serum' AND Collection.ovcare_collection_voa_nbr >= 509 AND Collection.ovcare_collection_voa_nbr <= 2301;";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	if($upated_records_count) $summary_msg['Blood tubes: Collected volume and tube nbr update']['@@MESSAGE@@']["Serum of VOA# 509-2301 (1 tube / 6ml)"][] = $upated_records_count." records updated.";
	
	// VOA2303 to 4939:  for samples which we received blood:  2 tubes of EDTA (12.0mL)
	
	$query = "SELECT SampleMaster.id
		FROM sample_controls SampleControl, sample_masters SampleMaster, sd_spe_bloods SampleDetail, collections Collection
		WHERE SampleControl.sample_type = 'blood'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND Collection.id = SampleMaster.collection_id
		AND SampleDetail.blood_type = 'EDTA' AND Collection.ovcare_collection_voa_nbr >= 2303 AND Collection.ovcare_collection_voa_nbr <= 4939
	 	AND (SampleDetail.collected_volume = '' OR SampleDetail.collected_volume IS NULL)
	 	AND (SampleDetail.collected_tube_nbr = '' OR SampleDetail.collected_tube_nbr IS NULL);";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$upated_records_count = $results->num_rows;
	while($row = $results->fetch_assoc()) { $updated_sample_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE sample_controls SampleControl, sample_masters SampleMaster, sd_spe_bloods SampleDetail, collections Collection
		SET SampleDetail.collected_volume = '12.0', SampleDetail.collected_volume_unit = 'ml', SampleDetail.collected_tube_nbr = '2', SampleMaster.modified = '$modified', SampleMaster.modified_by = '$modified_by'
		WHERE SampleControl.sample_type = 'blood'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND Collection.id = SampleMaster.collection_id
		AND (SampleDetail.collected_volume = '' OR SampleDetail.collected_volume IS NULL)
		AND (SampleDetail.collected_tube_nbr = '' OR SampleDetail.collected_tube_nbr IS NULL)
		AND SampleDetail.blood_type = 'EDTA' AND Collection.ovcare_collection_voa_nbr >= 2303 AND Collection.ovcare_collection_voa_nbr <= 4939;";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	if($upated_records_count) $summary_msg['Blood tubes: Collected volume and tube nbr update']['@@MESSAGE@@']["EDTA of VOA# 2303-4939 (2 tubes / 12ml)"][] = $upated_records_count." records updated.";
	
	// VOA2303 to 4939:  for samples which we received blood:  1 tube of serum (6.0mL)
	
	$query = "SELECT SampleMaster.id
		FROM sample_controls SampleControl, sample_masters SampleMaster, sd_spe_bloods SampleDetail, collections Collection
		WHERE SampleControl.sample_type = 'blood'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND Collection.id = SampleMaster.collection_id
		AND SampleDetail.blood_type = 'serum' AND Collection.ovcare_collection_voa_nbr >= 2303 AND Collection.ovcare_collection_voa_nbr <= 4939
	 	AND (SampleDetail.collected_volume = '' OR SampleDetail.collected_volume IS NULL)
	 	AND (SampleDetail.collected_tube_nbr = '' OR SampleDetail.collected_tube_nbr IS NULL);";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	$upated_records_count = $results->num_rows;
	while($row = $results->fetch_assoc()) { $updated_sample_master_ids[$row['id']] = $row['id']; }
	$query = "UPDATE sample_controls SampleControl, sample_masters SampleMaster, sd_spe_bloods SampleDetail, collections Collection
		SET SampleDetail.collected_volume = '6.0', SampleDetail.collected_volume_unit = 'ml', SampleDetail.collected_tube_nbr = '1', SampleMaster.modified = '$modified', SampleMaster.modified_by = '$modified_by'
		WHERE SampleControl.sample_type = 'blood'
		AND SampleControl.id = SampleMaster.sample_control_id AND SampleMaster.deleted <> 1
		AND SampleDetail.sample_master_id = SampleMaster.id
		AND Collection.id = SampleMaster.collection_id
		AND (SampleDetail.collected_volume = '' OR SampleDetail.collected_volume IS NULL)
		AND (SampleDetail.collected_tube_nbr = '' OR SampleDetail.collected_tube_nbr IS NULL)
		AND SampleDetail.blood_type = 'serum' AND Collection.ovcare_collection_voa_nbr >= 2303 AND Collection.ovcare_collection_voa_nbr <= 4939;";
	mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	if($upated_records_count) $summary_msg['Blood tubes: Collected volume and tube nbr update']['@@MESSAGE@@']["Serum of VOA# 2303-4939 (1 tube / 6ml)"][] = $upated_records_count." records updated.";
		
	if($updated_sample_master_ids) {
		$query = "INSERT INTO sample_masters_revs (id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,sop_master_id,product_code,is_problematic,notes,
			modified_by,version_created)
			(SELECT id,sample_code,sample_control_id,initial_specimen_sample_id,initial_specimen_sample_type,collection_id,parent_id,parent_sample_type,sop_master_id,product_code,is_problematic,notes,
			modified_by,modified FROM sample_masters WHERE id IN (".implode(',',$updated_sample_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		$query = "INSERT INTO specimen_details_revs (sample_master_id, supplier_dept, time_at_room_temp_mn, reception_by, reception_datetime, reception_datetime_accuracy, version_created)
			(SELECT sample_master_id, supplier_dept, time_at_room_temp_mn, reception_by, reception_datetime, reception_datetime_accuracy, '$modified' FROM specimen_details WHERE sample_master_id IN (".implode(',',$updated_sample_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
		$query = "INSERT INTO sd_spe_bloods_revs (sample_master_id, blood_type, collected_tube_nbr, collected_volume, collected_volume_unit, version_created)
			(SELECT sample_master_id, blood_type, collected_tube_nbr, collected_volume, collected_volume_unit, '$modified' FROM sd_spe_bloods WHERE sample_master_id IN (".implode(',',$updated_sample_master_ids)."))";
		mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	}
}
				
//===========================================================================================================================================================
// Other functions
//===========================================================================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function customInsertRecord($data_arr, $table_name, $is_detail_table, $insert_into_revs) {
	global $db_connection;
	global $modified_by;
	global $modified;
	
	$tmp_set_id_for_check = array_key_exists('id', $data_arr)? $data_arr['id'] : null;
	
	$created = $is_detail_table? array() : array(
		"created"		=> "'$modified'", 
		"created_by"	=> $modified_by, 
		"modified"		=> "'$modified'",
		"modified_by"	=> $modified_by
	);
	
	$data_to_insert = array();
	foreach($data_arr as $key => $value) {
		if(strlen($value)) {
			$data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
		}
	}
	
	$insert_arr = array_merge($data_to_insert, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	
	$record_id = mysqli_insert_id($db_connection);
	
	if($insert_into_revs) {
		$additional_fields = $is_detail_table? array('version_created' => "'$modified'") : array('id' => "$record_id", 'version_created' => "'$modified'");
		$rev_insert_arr = array_merge($data_to_insert, $additional_fields);
		$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
		mysqli_query($db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	}
	
	if(!is_null($tmp_set_id_for_check) && $tmp_set_id_for_check != $record_id) die('ERR 2332872872');//Not really usefull
	
	return $record_id;	
}

function getDateAndAccuracy($data_type, $data, $worksheet, $field, $accuracy_field, $line) {
	global $summary_msg;
	$result = null;
	if(!array_key_exists($field, $data)) {
		pr("getDateAndAccuracy: Missing field [$field]");
		pr($data);
		die('ERR36100833');
	}
	$date = $data[$field];
	if(empty($date) || (strtoupper($date) == 'N/A')) {
		return null;
	} else if(preg_match('/^([0-9]+)$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date - $xls_offset) * 86400));
		$result = array('date' => $date, 'accuracy' => 'c');	
	} else if(preg_match('/^(19|20)([0-9]{2})\-((0[1-9])|(1[0-2]))\-((0[1-9])|([12][0-9])|(3[0-1]))$/',$date,$matches)) {
		$result = array('date' => $date, 'accuracy' => 'c');
	} else if(preg_match('/^(19|20)([0-9]{2})\-((0[1-9])|(1[0-2]))$/',$date,$matches)) {
		$result = array('date' => $date.'-01', 'accuracy' => 'd');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		$result = array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^((0[1-9])|([12][0-9])|(3[0-1]))[\/\-]((0[1-9])|(1[0-2]))[\/\-](19|20)([0-9]{2})$/',$date,$matches)) {
		$result = array('date' => $matches[8].$matches[9].'-'.$matches[5].'-'.$matches[1], 'accuracy' => 'c');
	} else if(preg_match('/^,[\ ]{0,1}(19|20)([0-9]{2})$/',$date,$matches)) {
		$result = array('date' => $matches[1].$matches[2].'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^,\ ((January)|(February)|(March)|(April)|(May)|(June)|(July)|(August)|(September)|(October)|(November)|(December))\ (19|20)([0-9]{2})$/',$date,$matches)) {
		$month = str_replace(array('January','February','March','April','May','June','July','August','September','October','November','December'),
			array('01','02','03','04','05','06','07','08','09','10','11','12'), 
			$matches[1]);
		$result = array('date' => $matches[14].$matches[15]."-$month-01", 'accuracy' => 'd');
	} else {
		$summary_msg[$data_type]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [worksheet $worksheet - field '$field' - line: $line]";
		return null;
	}
	if($data[$accuracy_field] && in_array($data[$accuracy_field], array('y','m'))) {
		$result['accuracy'] = str_replace(array('m','y'), array('d','m'), $data[$accuracy_field]);
	}
	return $result;
}

function customArrayCombineAndUtf8Encode($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[utf8_encode($field)] = utf8_encode($data[$key]);
		} else {
			$line_data[utf8_encode($field)] = '';
		}
	}
	return $line_data;
}

function displayErrorAndMessage() {
	global $db_connection;
	global $summary_msg;
	
	$creation_summary = $summary_msg['Data Creation/Update Summary'];
	unset($summary_msg['Data Creation/Update Summary']);
	
	$commit = true;
	foreach($summary_msg as $data_type => $msg_arr) {

		echo "<br><br><FONT COLOR=\"blue\" >
		=====================================================================<br><br>
		PROCESS SUMMARY: $data_type
		<br><br>=====================================================================
		</FONT><br>";
			
		if(!empty($msg_arr['@@ERROR@@'])) {
			echo "<br><FONT COLOR=\"red\" ><b> ** Errors summary ** </b> </FONT><br>";
			foreach($msg_arr['@@ERROR@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"red\" >". utf8_decode($type) . "</FONT><br>";
				$counter = 0;
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
				$commit = false;
			}
		}
		unset($msg_arr['@@ERROR@@']);

		if(!empty($msg_arr['@@WARNING@@'])) {
			echo "<br><FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> </FONT><br>";
			foreach($msg_arr['@@WARNING@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"orange\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
			}
		}
		unset($msg_arr['@@WARNING@@']);

		if(!empty($msg_arr['@@MESSAGE@@'])) {
			echo "<br><FONT COLOR=\"green\" ><b> ** Message ** </b> </FONT><br>";
			foreach($msg_arr['@@MESSAGE@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
			}
		}
		unset($msg_arr['@@MESSAGE@@']);
		
		if(!empty($msg_arr)) {
			pr($msg_arr);die('ERR327327732');
		}
	}
	
	$participant_id_to_patient_id = array();
	$query = "SELECT id, participant_identifier FROM participants WHERE deleted <> 1;";
	$results = mysqli_query($db_connection, $query) or die(__FILE__."[line:".__LINE__."] qry failed [".$query."] ".mysqli_error($db_connection));
	while($row = $results->fetch_assoc()) $participant_id_to_patient_id[$row['id']] = $row['participant_identifier'];
	echo "<br><br><FONT COLOR=\"blue\" >
	=====================================================================<br><br>
	PROCESS SUMMARY: DATA CREATION and UPDATE
	<br><br>=====================================================================
	</FONT><br>";
	echo "<i>";
	$displayed_changes = array();
	foreach($creation_summary as $participant_id => $data) {
		$patient_id = array_key_exists($participant_id, $participant_id_to_patient_id)? $participant_id_to_patient_id[$participant_id] : '???';
		echo "<br><FONT COLOR=\"orange\" ><b> ATiM Patient Id $patient_id (participant_id = $participant_id) </b> </FONT><br>";
		foreach($data as $type => $msgs) {
			if(!isset($displayed_changes[$type])) $displayed_changes[$type] = 0;
			$displayed_changes[$type]++;
			echo " --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT><br>";
			foreach($msgs as $msg) echo utf8_decode($msg)."<br>";
		}
	}
	
	echo "<br><br><FONT COLOR=\"red\" ><b> ***** List of patiend data creation/update messages ***** </b> </FONT><br>";
	foreach($displayed_changes as $type => $nbr) echo "<FONT COLOR=\"green\" >". utf8_decode($type)."</FONT> ($nbr) <br>";

	echo "</i>";
	//return $commit;
	return true;
}

?> 