<?php

require_once 'Files/ClinicalAnnotation.php';
require_once 'Files/Inventory.php';

set_time_limit('3600');

//==============================================================================================
// Variables
//==============================================================================================

$files_name = array(
	'patient' => 'Patients_short.xls',
	'patient_status' => utf8_decode('décès_short.xls'),
	'consent' => 'consentement_short.xls',
	'psa' => 'ReqPSAPatientProcure_short.xls',
	'treatment' => 'Procure Patient Traitements_short.xls',
	
	'inventory' => utf8_decode('inventaire procure CHU Québec_20141202_short.xls'),
	'tissue' => 'taille tissus_short.xls'
);
$files_path = 'C:\\_Perso\\Server\\procure_chuq\\data\\';
require_once 'Excel/reader.php';

global $import_summary;
$import_summary = array();

global $db_schema;

$db_ip			= "127.0.0.1";
$db_port 		= "";
$db_user 		= "root";
$db_pwd			= "";
$db_charset		= "utf8";
$db_schema	= "procurechuq";

global $db_connection;
$db_connection = @mysqli_connect(
		$db_ip.(!empty($db_port)? ":".$db_port : ''),
		$db_user,
		$db_pwd
) or die("Could not connect to MySQL");
if(!mysqli_set_charset($db_connection, $db_charset)){
	die("Invalid charset");
}
@mysqli_select_db($db_connection, $db_schema) or die("db selection failed 2 $db_user $db_schema ");

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE id = '1';", __FILE__, __LINE__);
if($query_res->num_rows != 1) importDie('ERR : No user Migration!');
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

global $controls;
$controls = loadATiMControlData();

global $sample_code;
$sample_code = 0;

global $sample_storage_types;
$sample_storage_types = array(
	'tissue' => 'box27 1A-9C',
	'serum' => 'box81',
	'plasma' => 'box81',
	'pbmc' => 'box81',
	'whatman' => 'box',
	'urine' => 'box49'
);

global $storage_master_ids;
$storage_master_ids = array();

global $last_storage_code;
$last_storage_code = 0;

echo "<br><br><FONT COLOR=\"blue\" >
=====================================================================<br>
PROCURE - Data Migration to ATiM<br>
$import_date<br>
=====================================================================</FONT><br>";

echo "<br><FONT COLOR=\"red\" ><b>Check all dates in excel have been formated to date format 2000-00-00 (including treatment worksheet)</b></FONT><br><br>";

truncate();

//==============================================================================================
//Clinical Annotation
//==============================================================================================

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Patient - File(s) : ".$files_name['patient']." && ".$files_name['patient_status']."***</FONT><br>";
/*TODO
$XlsReader = new Spreadsheet_Excel_Reader();
$patients_status = loadVitalStatus($XlsReader, $files_path, $files_name['patient_status']);
$XlsReader = new Spreadsheet_Excel_Reader();
$psp_nbr_to_participant_id_and_patho = loadPatients($XlsReader, $files_path, $files_name['patient'], $patients_status);
*/
//TODO delete ************
if(true) {
	$psp_nbr_to_participant_id_and_patho = array();
	$query = "select id, participant_identifier FROM participants;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$psp_nbr_to_participant_id_and_patho[$row['participant_identifier']] = array(
			'participant_id' => $row['id'], 
			'patho#' => null,
			'prostate_weight_gr' => null);
	}
}
//TODO end delete ************
/*TODO
echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Consent & Questionnaire - File(s) : ".$files_name['consent']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadConsents($XlsReader, $files_path, $files_name['consent'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - PSA - File(s) : ".$files_name['psa']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadPSAs($XlsReader, $files_path, $files_name['psa'], $psp_nbr_to_participant_id_and_patho);

echo "<br><FONT COLOR=\"green\" >*** Clinical Annotation - Treatment - File(s) : ".$files_name['treatment']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadTreatments($XlsReader, $files_path, $files_name['treatment'], $psp_nbr_to_participant_id_and_patho);
*/
//==============================================================================================
//Inventory
//==============================================================================================


echo "<br><FONT COLOR=\"green\" >*** Inventory (Tissue) - File(s) : ".$files_name['tissue']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
$psp_nbr_to_blocks_data = loadBlock($XlsReader, $files_path, $files_name['tissue']);

echo "<br><FONT COLOR=\"green\" >*** Inventory - File(s) : ".$files_name['inventory']."***</FONT><br>";

$XlsReader = new Spreadsheet_Excel_Reader();
loadInventory($XlsReader, $files_path, $files_name['inventory'], $psp_nbr_to_blocks_data, $psp_nbr_to_participant_id_and_patho);
unset($psp_nbr_to_blocks_data);





$query = "UPDATE sample_masters SET sample_code = id;";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE sample_masters SET initial_specimen_sample_id = id WHERE sample_control_id IN (SELECT id FROM sample_controls WHERE sample_category = 'specimen');";
customQuery($query, __FILE__, __LINE__);
$query = "UPDATE storage_masters SET code = id;";
customQuery($query, __FILE__, __LINE__);

//==============================================================================================
//Pathology report
//==============================================================================================

loadPathologyReprot($psp_nbr_to_participant_id_and_patho);

//==============================================================================================
//End of the process
//==============================================================================================

dislayErrorAndMessage($import_summary);

insertIntoRevs();

//TODO $query = "UPDATE versions SET permissions_regenerated = 0;";
customQuery($query, __FILE__, __LINE__);





if(true) {
//TODO remove view insert
	$query = "TRUNCATE view_collections;";
	customQuery($query, __FILE__, __LINE__);
	$query = "REPLACE INTO view_collections (SELECT 
			Collection.id AS collection_id,
			Collection.bank_id AS bank_id,
			Collection.sop_master_id AS sop_master_id,
			Collection.participant_id AS participant_id,
			Collection.diagnosis_master_id AS diagnosis_master_id,
			Collection.consent_master_id AS consent_master_id,
			Collection.treatment_master_id AS treatment_master_id,
			Collection.event_master_id AS event_master_id,
	Collection.procure_patient_identity_verified AS procure_patient_identity_verified,
	Collection.procure_visit AS procure_visit,
			Participant.participant_identifier AS participant_identifier,
			Collection.acquisition_label AS acquisition_label,
			Collection.collection_site AS collection_site,
			Collection.collection_datetime AS collection_datetime,
			Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
			Collection.collection_property AS collection_property,
			Collection.collection_notes AS collection_notes,
			Collection.created AS created 
			FROM collections AS Collection 
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1 
			WHERE Collection.deleted <> 1)";
	customQuery($query, __FILE__, __LINE__);
	
	$query = "TRUNCATE view_samples;";
	customQuery($query, __FILE__, __LINE__);
	$query = 'REPLACE INTO view_samples (SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
		
		Collection.bank_id,
		Collection.sop_master_id,
		Collection.participant_id,
		
		Participant.participant_identifier,
		
		Collection.acquisition_label,
		Collection.procure_visit AS procure_visit,
		
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
		
		IF(SpecimenDetail.reception_datetime IS NULL, NULL,
		IF(Collection.collection_datetime IS NULL, -1,
		IF(Collection.collection_datetime_accuracy != "c" OR SpecimenDetail.reception_datetime_accuracy != "c", -2,
		IF(Collection.collection_datetime > SpecimenDetail.reception_datetime, -3,
		TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, SpecimenDetail.reception_datetime))))) AS coll_to_rec_spent_time_msg,
			
		IF(DerivativeDetail.creation_datetime IS NULL, NULL,
		IF(Collection.collection_datetime IS NULL, -1,
		IF(Collection.collection_datetime_accuracy != "c" OR DerivativeDetail.creation_datetime_accuracy != "c", -2,
		IF(Collection.collection_datetime > DerivativeDetail.creation_datetime, -3,
		TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg
		
		FROM sample_masters AS SampleMaster
		INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON SpecimenDetail.sample_master_id=SampleMaster.id
		LEFT JOIN derivative_details AS DerivativeDetail ON DerivativeDetail.sample_master_id=SampleMaster.id
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
		WHERE SampleMaster.deleted != 1)';
	customQuery($query, __FILE__, __LINE__);
	
	$query = "TRUNCATE view_aliquots;";
	customQuery($query, __FILE__, __LINE__);
	$query = 'REPLACE INTO view_aliquots (SELECT
			AliquotMaster.id AS aliquot_master_id,
			AliquotMaster.sample_master_id AS sample_master_id,
			AliquotMaster.collection_id AS collection_id,
			Collection.bank_id,
			AliquotMaster.storage_master_id AS storage_master_id,
			Collection.participant_id,
		
			Participant.participant_identifier,
		
			Collection.acquisition_label,
Collection.procure_visit AS procure_visit,
		
			SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
			SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
			ParentSampleControl.sample_type AS parent_sample_type,
			ParentSampleMaster.sample_control_id AS parent_sample_control_id,
			SampleControl.sample_type,
			SampleMaster.sample_control_id,
		
			AliquotMaster.barcode,
			AliquotMaster.aliquot_label,
			AliquotControl.aliquot_type,
			AliquotMaster.aliquot_control_id,
			AliquotMaster.in_stock,
		
			StorageMaster.code,
			StorageMaster.selection_label,
			AliquotMaster.storage_coord_x,
			AliquotMaster.storage_coord_y,
		
			StorageMaster.temperature,
			StorageMaster.temp_unit,
		
			AliquotMaster.created,
		
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(Collection.collection_datetime IS NULL, -1,
			 IF(Collection.collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(SpecimenDetail.reception_datetime IS NULL, -1,
			 IF(SpecimenDetail.reception_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
			IF(AliquotMaster.storage_datetime IS NULL, NULL,
			 IF(DerivativeDetail.creation_datetime IS NULL, -1,
			 IF(DerivativeDetail.creation_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
			 IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
			 TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,
	
			IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes
		
			FROM aliquot_masters AS AliquotMaster
			INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
			INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
			INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
			INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
			LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
			LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
			LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
			LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
			LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
			LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
			WHERE AliquotMaster.deleted != 1)';
	customQuery($query, __FILE__, __LINE__);
	//rebuild left right
	$left_rght_nxt = 1;
	$results = customQuery("SELECT id FROM storage_masters WHERE parent_id IS NULL;", __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		updateLftRgt($row['id'],$left_rght_nxt);
	}

}
function updateLftRgt($storage_master_id,&$left_rght_nxt) {
	$lft = $left_rght_nxt;
	$left_rght_nxt++;
	$results = customQuery("SELECT id FROM storage_masters WHERE parent_id = $storage_master_id;", __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		updateLftRgt($row['id'],$left_rght_nxt);
	}
	$rght = $left_rght_nxt;
	$left_rght_nxt++;
	customQuery("UPDATE storage_masters SET lft = '$lft', rght = '$rght' WHERE id = $storage_master_id;", __FILE__, __LINE__);
}

//==============================================================================================
// Functions
//==============================================================================================

function truncate() {
	$truncate_queries = array(
		'TRUNCATE ad_blocks;', 'TRUNCATE ad_blocks_revs;',	
		'TRUNCATE ad_whatman_papers;', 'TRUNCATE ad_whatman_papers_revs;',
		'TRUNCATE ad_tubes;', 'TRUNCATE ad_blocks_revs;',	
		'DELETE FROM aliquot_masters;', 'DELETE FROM aliquot_masters_revs;',
		
		'TRUNCATE sd_der_plasmas;', 'TRUNCATE sd_der_plasmas_revs;',
		'TRUNCATE sd_der_pbmcs;', 'TRUNCATE sd_der_pbmcs_revs;',
		'TRUNCATE sd_der_serums;', 'TRUNCATE sd_der_serums_revs;',
		'TRUNCATE sd_spe_tissues;', 'TRUNCATE sd_spe_tissues_revs;',
		'TRUNCATE sd_spe_bloods;', 'TRUNCATE sd_spe_bloods_revs;',
		'TRUNCATE specimen_details;', 'TRUNCATE specimen_details_revs;',
		'TRUNCATE derivative_details;', 'TRUNCATE derivative_details_revs;',
		'UPDATE sample_masters SET parent_id = null, initial_specimen_sample_id = null;',
		'DELETE FROM sample_masters;', 'DELETE FROM sample_masters_revs;',	
				
		'DELETE FROM collections;', 'DELETE FROM collections_revs;',	
			
		'TRUNCATE std_nitro_locates;', 'TRUNCATE std_nitro_locates_revs;',
		'TRUNCATE std_fridges;', 'TRUNCATE std_fridges_revs;',
		'TRUNCATE std_freezers;', 'TRUNCATE std_freezers_revs;',
		'TRUNCATE std_boxs;', 'TRUNCATE std_boxs_revs;',
		'TRUNCATE std_racks;', 'TRUNCATE std_racks_revs;',
		'UPDATE storage_masters SET parent_id = null;',
		'DELETE FROM storage_masters;', 'DELETE FROM storage_masters_revs;',
		
"DELETE FROM procure_txd_followup_worksheet_treatments WHERE treatment_type = 'prostatectomy';", "DELETE FROM procure_txd_followup_worksheet_treatments_revs WHERE treatment_type = 'prostatectomy';",
'DELETE FROM treatment_masters WHERE treatment_control_id = 6 AND id NOT IN (SELECT treatment_master_id FROM procure_txd_followup_worksheet_treatments);', 
'DELETE FROM treatment_masters_revs WHERE treatment_control_id = 6 AND id NOT IN (SELECT treatment_master_id FROM procure_txd_followup_worksheet_treatments);', 		
			
/* 		'TRUNCATE procure_txd_medication_drugs;', 'TRUNCATE procure_txd_medication_drugs_revs;',
// 		'TRUNCATE procure_txd_followup_worksheet_treatments;', 'TRUNCATE procure_txd_followup_worksheet_treatments_revs;',
// 		'DELETE FROM treatment_masters;', 'DELETE FROM treatment_masters_revs;',
			
// 		'TRUNCATE procure_ed_lab_pathologies;', 'TRUNCATE procure_ed_lab_pathologies_revs;',
// 		'TRUNCATE procure_ed_clinical_followup_worksheet_aps;', 'TRUNCATE procure_ed_clinical_followup_worksheet_aps_revs;',
// 		'TRUNCATE procure_ed_lifestyle_quest_admin_worksheets;', 'TRUNCATE procure_ed_lifestyle_quest_admin_worksheets_revs;',
// 		'DELETE FROM event_masters;', 'DELETE FROM event_masters_revs;',
// 		'DELETE FROM event_masters WHERE event_control_id = 54;', 'DELETE FROM event_masters_revs WHERE event_control_id = 54;',
		
// 		'TRUNCATE procure_cd_sigantures;', 'TRUNCATE procure_cd_sigantures_revs;',
// 		'DELETE FROM consent_masters;', 'DELETE FROM consent_masters_revs;',
		
// 		'TRUNCATE misc_identifiers;', 'TRUNCATE misc_identifiers_revs;',
// 		'DELETE FROM participants;','DELETE FROM participants_revs;'*/
	
	);
	foreach($truncate_queries as $query) customQuery($query, __FILE__, __LINE__);
}

function insertIntoRevs() {
	global $import_date;
	global $import_by;
		
	$tables = array(
		'participants' => 0,
		'misc_identifiers' => 0,
			
		'consent_masters' => 0,
		'procure_cd_sigantures' => 1,
		
		'event_masters' => 0,
		'procure_ed_lifestyle_quest_admin_worksheets' => 1,
		'procure_ed_clinical_followup_worksheet_aps' => 1,

		'treatment_masters' => 0,
		'procure_txd_medication_drugs' => 1,
		'procure_txd_followup_worksheet_treatments' => 1,
		
		'collections' => 0,
		'sample_masters' => 0,
		'specimen_details' => 1,
		'derivative_details' => 1,
		'sd_spe_tissues' => 1
			
	);
	
	foreach($tables as $table_name => $is_detail_table) {
		$fields = array();
		$results = customQuery("DESC $table_name;", __FILE__, __LINE__);
		while($row = $results->fetch_assoc()) {
			$field = $row['Field'];
			if(!in_array($field, array('created', 'created_by','modified', 'modified_by','deleted'))) $fields[$row['Field']] = $row['Field'];
		}
		$fields = implode(',', $fields);
		if(!$is_detail_table) {
			$query = "INSERT INTO ".$table_name."_revs ($fields, modified_by, version_created) (SELECT $fields, $import_by, '$import_date' FROM $table_name)";
		} else {
			$query = "INSERT INTO ".$table_name."_revs ($fields, version_created) (SELECT $fields, '$import_date' FROM $table_name)";
		}
		customQuery($query, __FILE__, __LINE__);
	}
}

function loadATiMControlData(){
	$controls = array();
	// MiscIdentifierControl
	$query = "select id, misc_identifier_name, flag_unique FROM misc_identifier_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['MiscIdentifierControl'][$row['misc_identifier_name']] = array('id' => $row['id'], 'flag_unique' => $row['flag_unique']);
	}
	// ConsentControl
	$query = "SELECT id, controls_type, detail_tablename FROM consent_controls WHERE flag_active = 1;";
	$results =customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$controls['ConsentControl'][$row['controls_type']] = array('id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	// EventControl
	$query = "select id,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['EventControl'][$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	// TreatmentControl
	$query = "select tc.id, tc.tx_method, tc.detail_tablename, te.id as te_id, te.detail_tablename as te_detail_tablename
		from treatment_controls tc
		LEFT JOIN treatment_extend_controls te ON tc.treatment_extend_control_id = te.id AND te.flag_active = '1'
		where tc.flag_active = '1';";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['TreatmentControl'][$row['tx_method']] = array(
				'treatment_control_id' => $row['id'],
				'detail_tablename' => $row['detail_tablename'],
				'te_treatment_control_id' => $row['te_id'],
				'te_detail_tablename' => $row['te_detail_tablename'],
		);
	}
	//SampleControl
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue', 'blood', 'serum', 'plasma', 'pbmc','dna','rna','urine','centrifuged urine')";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()){
		$controls['sample_aliquot_controls'][$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}
	foreach($controls['sample_aliquot_controls'] as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = customQuery($query, __FILE__, __LINE__);
		while($row = $results->fetch_assoc()){
			$controls['sample_aliquot_controls'][$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}
	}
	//StorageControl
	$query = "SELECT id as storage_control_id, storage_type, detail_tablename, coord_x_type,coord_x_size,coord_y_type,coord_y_size FROM storage_controls WHERE flag_active = 1;";
	$results = customQuery($query, __FILE__, __LINE__);
	while($row = $results->fetch_assoc()) {
		$controls['storage_controls'][$row['storage_type']] = $row;
	}
	return $controls;
}

//=================================================================================================================================
// System Functions
//=================================================================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function formatNewLineData($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[trim(utf8_encode($field))] = trim(utf8_encode($data[$key]));
		} else {
			$line_data[trim(utf8_encode($field))] = '';
		}
	}
	return $line_data;
}

function importDie($msg, $rollbak = true) {
	if($rollbak) {
		//TODO manage commit rollback
	}
	die($msg);
}

function customQuery($query, $file, $line, $insert = false) {
	global $db_connection;
	$query_res = mysqli_query($db_connection, $query) or importDie("QUERY ERROR: file $file line $line [".mysqli_error($db_connection)."] : $query");
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}
	
function customInsert($data, $table_name, $file, $line, $is_detail_table = false, $insert_into_revs = false) {
	global $import_date;
	global $import_by;
	
	$data_to_insert = array();
	foreach($data as $key => $value) {
		if(strlen(str_replace(array(' ', "\n"), array('', ''), $value))) $data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
	}
	// Insert into table
	$table_system_data = $is_detail_table? array() : array("created" => "'$import_date'", "created_by" => "'$import_by'", "modified" => "'$import_date'", "modified_by" => "'$import_by'");
	$insert_arr = array_merge($data_to_insert, $table_system_data);
	$record_id = customQuery("INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $file, $line, true);
	// Insert into revs table
	if($insert_into_revs) {
		$revs_table_system_data = $is_detail_table? array('version_created' => "'$import_date'") : array('id' => "$record_id", 'version_created' => "'$import_date'", "modified_by" => "'$import_by'");
		$insert_arr = array_merge($data_to_insert, $revs_table_system_data);
		customQuery("INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $file, $line, true);
	}
	
	return $record_id;
}

function getDateAndAccuracy($data, $field, $data_type, $file, $line) {
	global $import_summary;
	if(!array_key_exists($field, $data)) die("ERR 238729873298 732 $field $file, $line");
	$date = str_replace(array(' ', 'N/A', 'n/a', '-', 'x', '??'), array('', '', '', '', '', ''), $data[$field]);
	if(empty($date)) {
		return array('date' => null, 'accuracy' =>null);
	} else if(preg_match('/^([0-9]+)$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date - $xls_offset) * 86400));
		return array('date' => $date, 'accuracy' => 'c');	
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/',$date,$matches)) {
		return array('date' => $date, 'accuracy' => 'c');
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])$/',$date,$matches)) {
		return array('date' => $date.'-01', 'accuracy' => 'd');
	} else if(preg_match('/^((19|20)([0-9]{2})\-([01][0-9]))\-unk$/',$date,$matches)) {
		return array('date' => $matches[1].'-01', 'accuracy' => 'd');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^([0-3][0-9])\/([01][0-9])\/(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else if(preg_match('/^([0-3][0-9])\-([01][0-9])\-(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else {
		$import_summary[$data_type]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [field '$field' - file '$file' - line: $line]";
		return array('date' => null, 'accuracy' =>null);
	}	
}


function getDateTimeAndAccuracy($data, $field_date, $field_time, $data_type, $file, $line) {
	global $import_summary;
	if(!array_key_exists($field_time, $data)) die("ERR 238729873298 732 $field $file, $line");
	$time = str_replace(array(' ', 'N/A', 'n/a', '-', 'x', '??'), array('', '', '', '', '', ''), $data[$field_time]);
	//Get Date
	$tmp_date = getDateAndAccuracy($data, $field_date, $data_type, $file, $line);
	if(!$tmp_date['date']) {
		if(!empty($time)) $import_summary[$data_type]['@@ERROR@@']['DateTime: Only time is set'][] = "See following fields details. [fields '$field_date' & '$field_time' - file '$file' - line: $line]";
		return array('datetime' => null, 'accuracy' =>null);
	} else {
		$formatted_date = $tmp_date['date'];
		$formatted_date_accuracy = $tmp_date['accuracy'];
		//Combine date and time
		if(empty($time)) {
			return array('datetime' => $formatted_date.' 00:00', 'accuracy' => str_replace('c', 'h', $formatted_date_accuracy));
		} else {
			if($formatted_date_accuracy != 'c') {
				$import_summary[$data_type]['@@ERROR@@']['Time set for an unaccuracy date'][] = "Date and time are set but date is unaccuracy. No datetime will be set! [fields '$field_date' & '$field_time' - file '$file' - line: $line]";
				return array('datetime' => null, 'accuracy' =>null);
			} else if(preg_match('/^(0{0,1}[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/',$time, $matches)) {
				return array('datetime' => $formatted_date.' '.((strlen($time) == 5)? $time : '0'.$time), 'accuracy' => 'c');
			} else if(preg_match('/^0\.[0-9]+$/', $time)) {
				$hour = floor(24*$time);
				$mn = round((24*$time - $hour)*60);
				$mn = (strlen($mn) == 1)? '0'.$mn  : $mn ;
				if($mn == '60') {
					$mn = '00';
					$hour += 1;
				}
				if($hour > 23) die('ERR time >= 24 79904044--4-44');
				$time=$hour.':'.$mn;				
				return array('datetime' => $formatted_date.' '.((strlen($time) == 5)? $time : '0'.$time), 'accuracy' => 'c');
			} else {
				die("ERR time format should be h:mm see value $time for field $field_time' line '$line' [$file] - Be sure cell format = personalisé hh:mm");
			}
		}
	}
}

function getTime($data, $field_time, $data_type, $file, $line) {
	global $import_summary;
	if(!array_key_exists($field_time, $data)) die("ERR 238729873298 732 $field $file, $line");
	$time = str_replace(array(' ', 'N/A', 'n/a', '-', 'x', '??'), array('', '', '', '', '', ''), $data[$field_time]);
	if(empty($time)) {
		return null;
	} else {
		if(preg_match('/^(0{0,1}[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/',$time, $matches)) {
			return (strlen($time) == 5)? $time : '0'.$time;
		} else if(preg_match('/^0\.[0-9]+$/', $time)) {
			$hour = floor(24*$time);
			$mn = round((24*$time - $hour)*60);
			$mn = (strlen($mn) == 1)? '0'.$mn  : $mn ;
			if($mn == '60') {
				$mn = '00';
				$hour += 1;
			}
			if($hour > 23) die('ERR time >= 24 79904044--4-44');
			$time=$hour.':'.$mn;
			return (strlen($time) == 5)? $time : '0'.$time;
		} else {
			die("ERR time format should be h:mm see value $time for field $field_time' line '$line' [$file] - Be sure cell format = personalisé hh:mm");
		}
	}
}

function getDecimal($data, $field, $data_type, $file_name, $line_counter) {
	global $import_summary;
	if(!array_key_exists($field, $data)) die("ERR 238729873298 7eeee $field $file_name, $line_counter");
	$decimal_value = str_replace('x', '', $data[$field]);
	if(strlen($decimal_value)) {
		if(preg_match('/^[0-9]+([\.,][0-9]+){0,1}$/', $decimal_value)) {
			return str_replace(',', '.', $decimal_value);
		} else {
			$import_summary[$data_type]['@@ERROR@@']["Wrong decimal format for field '$field'"][] = "See value [$decimal_value]. [field '$field' - file '$file_name' - line: $line_counter]";
		}
	} else {
		return null;
	}	
}

function dislayErrorAndMessage($import_summary) {
	$err_counter = 0;
	foreach($import_summary as $worksheet => $data1) {
		echo "<br><br><FONT COLOR=\"blue\" >
			=====================================================================<br>
			Errors on $worksheet<br>
			=====================================================================</FONT><br>";
		foreach($data1 as $message_type => $data2) {
			$color = 'black';
			switch($message_type) {
				case '@@ERROR@@':
					$color = 'red';
					break;
				case '@@WARNING@@':
					$color = 'orange';
					break;
				case '@@MESSAGE@@':
					$color = 'green';
					break;
				default:
					echo '<br><br><br>UNSUPORTED message_type : '.$message_type.'<br><br><br>';
			}
			foreach($data2 as $error => $details) {
				$err_counter++;
				$error = str_replace("\n", ' ', utf8_decode("[ER#$err_counter] $error"));
				echo "<br><br><FONT COLOR=\"$color\" ><b>$error</b></FONT><br>";
				foreach($details as $detail) {
					$detail = str_replace("\n", ' ', $detail);
					echo ' - '.utf8_decode($detail)."<br>";	
				}
			}
		}
	}	
}

?>