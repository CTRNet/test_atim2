<?php

echo "<pre>";
$line_break = "<br>";
$errors = array();

//==============================================================================================
//Database
//==============================================================================================

$is_server = false;

global $db_icm_connection;

$db_icm_ip			= "127.0.0.1";
$db_icm_user 		= "root";
$db_icm_pwd			= "";
$db_icm_schema		= "icm";
$db_icm_charset		= "utf8";

if($is_server) {
	$db_icm_ip			= "localhost";
	$db_icm_user 		= "root";
	$db_icm_pwd			= "xxx";
	$db_icm_schema		= "icmtmp";
}

$db_icm_connection = @mysqli_connect(
	$db_icm_ip.(!empty($db_icm_port)? ":".$db_icm_port : ''),
	$db_icm_user,
	$db_icm_pwd
) or importDie("Could not connect to MySQL", false);
if(!mysqli_set_charset($db_icm_connection, $db_icm_charset)){
	importDie("Invalid charset", false);
}
@mysqli_select_db($db_icm_connection, $db_icm_schema) or importDie("db selection failed", false);

global $import_date;
global $import_by;
$query_res = query("SELECT NOW() AS import_date, id FROM users WHERE username = 'SardoMigration';", __LINE__);
if($query_res->num_rows != 1) importDie('ERR : No user SardoMigration!');
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

//TODO manage commit rollback

//==============================================================================================
//XML file
//==============================================================================================

$file_path = "C:/_Perso/Server/icm/data/Export_CRCHUM_deno.XML";
$file_path = "C:/_Perso/Server/icm/data/Export_CRCHUM_short_deno_20140610.XML";

if(!file_exists($file_path)) importDie("ERR_XML00001 : The file $file_path does not exist!"); 
$xml = new SimpleXMLElement($file_path, Null, True);

function getValueFromXml(&$new_record, $field) { 
	return (string) $new_record->{$field};
	//return utf8_decode((string) $new_record->{$field}); 
}

function getDateFromXml(&$new_record, $field) {
	$date_from_file = getValueFromXml($new_record, $field);
	$date = '';
	$date_accuracy = '';
	if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))9999$/', $date_from_file, $matches)) {
		$date = $matches[1].'-01-01';
		$date_accuracy = 'm';
	}  else if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))((0[1-9])|(1[0-2]))99$/', $date_from_file, $matches)) {
		$date = $matches[1].'-'.$matches[4].'-01';
		$date_accuracy = 'd';
	} else if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[01]))$/', $date_from_file, $matches)) {
		$date = $matches[1].'-'.$matches[4].'-'.$matches[7];
		$date_accuracy = 'c';
	}  else if($date_from_file != '99999999' && !empty($date_from_file)){
		importDie("ERR_XML00002 : Date '$date_from_file' is not supported for field <$field>!"); 
	}
	return array($date, $date_accuracy);
}

//==============================================================================================
//Table Clean Up
//==============================================================================================

// Diagnosis

global $diagnosis_controls;
$query_res = query("SELECT id, detail_tablename FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'sardo' AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 1) importDie('ERR_DX00002 : SARDO Primary diagnosis unknown!');
$diagnosis_controls = mysqli_fetch_assoc($query_res);

query("DELETE FROM ".$diagnosis_controls['detail_tablename'].";", __LINE__);
query("UPDATE diagnosis_masters SET parent_id = null, primary_id = null WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
query("DELETE FROM diagnosis_masters WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
query("DELETE FROM ".$diagnosis_controls['detail_tablename']."_revs;", __LINE__);
query("UPDATE diagnosis_masters_revs SET parent_id = null, primary_id = null WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
query("DELETE FROM diagnosis_masters_revs WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);

//TODO other table delete

//==============================================================================================
//Load structure_permissible_values_custom_controls
//==============================================================================================

global $structure_permissible_values_custom_controls;
$structure_permissible_values_custom_controls = array();
$query_res = query("SELECT id, name, flag_active, values_max_length, category, values_used_as_input_counter, values_counter FROM structure_permissible_values_custom_controls WHERE name LIKE 'SARDO%';", __LINE__);
While($res = mysqli_fetch_assoc($query_res)) {
	$structure_permissible_values_custom_controls[$res['name']] = array_merge($res, array('new_values' => array()));
}

function addValuesToCustomList($control_name, $value) {
	global $structure_permissible_values_custom_controls;
	if(!isset($structure_permissible_values_custom_controls[$control_name])) importDie("ERR_CUSTOMLIST00001 : The custom list $control_name does not exist!"); 
	$values_max_length = $structure_permissible_values_custom_controls[$control_name]['values_max_length'];
	if(strlen($value) > $values_max_length) {
		$errors['ERR_CUSTOMLIST00002'][$control_name.$value] = "Value [$value] for '$control_name' custom list is too long (> $values_max_length characters)!";
		$value = substr($value, 0, $values_max_length);
	}
	$structure_permissible_values_custom_controls[$control_name]['new_values'][$value] = $value;
	return $value;
}

function loadCustomLists() {
	global $structure_permissible_values_custom_controls;
	foreach($structure_permissible_values_custom_controls as $new_custom_list) {
		$control_id = $new_custom_list['id'];
		query("DELETE FROM structure_permissible_values_customs WHERE control_id = $control_id;", __LINE__);
		query("DELETE FROM structure_permissible_values_customs_revs WHERE control_id = $control_id;", __LINE__);
		foreach($new_custom_list['new_values'] as $new_value) {
			insert(array('value' => $new_value, 'control_id' => $control_id, 'use_as_input' => '0'), 'structure_permissible_values_customs', __LINE__);
		}
	}
}

//==============================================================================================
//Load diagnosis
//==============================================================================================

global $patient_rec_number_to_participant_id;
global $diagnosis_rec_number_to_diagnosis_master_id;
$patient_rec_number_to_participant_id = array();
$diagnosis_rec_number_to_diagnosis_master_id = array();

$last_patient_rec_number = null;
$studied_patient_rec_number = null;
$patient_diagnosis = array();
foreach($xml->Diagnostic as $new_diagnosis) {
	$studied_patient_rec_number = getValueFromXml($new_diagnosis, 'ParentRecNumber');
	if(!$studied_patient_rec_number) importDie("ERR_DX00001 : Empty Patient Rec Number!"); 
	//New Patient
	if($last_patient_rec_number != $studied_patient_rec_number) {
		recordPatientDiagnosis($patient_diagnosis);	
		$last_patient_rec_number = $studied_patient_rec_number;
		$patient_diagnosis = array(
			'PatientRecNumber' => $studied_patient_rec_number,
			'NoLabos' => array(),
			'Diagnosis' => array()
		);
	}
	$dianosis_rec_number = getValueFromXml($new_diagnosis, 'RecNumber');
	$no_labo = getValueFromXml($new_diagnosis, 'NoBANQUE');
	if($no_labo) $patient_diagnosis['NoLabos'][] = $no_labo;
	//Set diagnosis data
	$diagnosis_data = array();
	list($diagnosis_data['DiagnosisMaster']['dx_date'], $diagnosis_data['DiagnosisMaster']['dx_date_accuracy'])  = getDateFromXml($new_diagnosis, 'DateDiagnostic');
	$tmp_array= array(
		'DiagnosisMaster' => array(
			array('CodeICDOMorpho', 'morphology', 'SARDO : Morpho Codes'),
			array('DescICDOMorpho', 'qc_nd_sardo_morphology_desc', 'SARDO : Morpho Descriptions'),
			array('CodeICDOTopo', 'topography', 'SARDO : Topo Codes'),
			array('DescICDOTopo', 'qc_nd_sardo_topography_desc', 'SARDO : Topo Descriptions'),
			array('CodeTNMcT' ,'clinical_tstage', 'SARDO : TNMcT'),
			array('CodeTNMcN' ,'clinical_nstage', 'SARDO : TNMcN'),
			array('CodeTNMcM' ,'clinical_mstage', 'SARDO : TNMcM'),
			array('StadeTNMc' ,'clinical_stage_summary', 'SARDO : TNMc Summary'),
			array('CodeTNMpT' ,'path_tstage', 'SARDO : TNMpT'),
			array('CodeTNMpN' ,'path_nstage', 'SARDO : TNMpN'),
			array('CodeTNMpM' ,'path_mstage', 'SARDO : TNMpM'),
			array('StadeTNMp' ,'path_stage_summary', 'SARDO : TNMp Summary'),
			array('GradeICDO' ,'tumour_grade', 'SARDO : Grade'),
			array('Duree' ,'survival_time_months', '')),
		'DiagnosisDetail' => array(
				array('Lateralite', 'laterality', 'SARDO : Laterality'),
				array('FIGO', 'figo', 'SARDO : FIGO'),
				array('CodeTNMG', 'codetnmg', 'SARDO : TNMg')));
	foreach($tmp_array as $model => $table_fields) {
		foreach($table_fields as $fields_info) {
			list($xml_field, $atim_field, $custom_list_control_name) = $fields_info;
			$diagnosis_data[$model][$atim_field] = getValueFromXml($new_diagnosis, $xml_field);
			if($custom_list_control_name) {
				$diagnosis_data[$model][$atim_field] = addValuesToCustomList($custom_list_control_name, $diagnosis_data[$model][$atim_field]);		
			}
		}
	}
	$patient_diagnosis['Diagnosis'][$dianosis_rec_number] = $diagnosis_data;
}
recordPatientDiagnosis($patient_diagnosis);	//The last patient
query("UPDATE diagnosis_masters SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
query("UPDATE diagnosis_masters_revs SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);

function recordPatientDiagnosis($patient_diagnosis) {
	global $diagnosis_controls;
	global $patient_rec_number_to_participant_id;
	global $diagnosis_rec_number_to_diagnosis_master_id;

	if(!empty($patient_diagnosis) && !empty($patient_diagnosis['NoLabos'])) {
		$query = "SELECT DISTINCT mi.participant_id FROM misc_identifier_controls mic INNER JOIN misc_identifiers mi 
			WHERE mi.misc_identifier_control_id = mic.id AND mic.misc_identifier_name LIKE '%bank no lab' AND mic.flag_active = 1
			AND mi.identifier_value IN ('".implode("','",$patient_diagnosis['NoLabos'])."');";
		$query_res = query($query, __LINE__);
		if($query_res->num_rows != 1) {
//TODO message: same SARDO patient - > Many ATiM patients
pr('TODO message: same SARDO patient - > Many ATiM patients : PatientRecNumber = '.$patient_diagnosis['PatientRecNumber']);
		} else {
			$res = mysqli_fetch_assoc($query_res);
			$pariticpant_id = $res['participant_id'];
			if(isset($patient_rec_number_to_participant_id[$patient_diagnosis['PatientRecNumber']])) {
//TODO message: same ATim patient - > Many SARDO patients	
pr('TODO message: same ATim patient - > Many SARDO patients : PatientRecNumber = '.$patient_diagnosis['PatientRecNumber']);
			}
			$patient_rec_number_to_participant_id[$patient_diagnosis['PatientRecNumber']] = $pariticpant_id;
			foreach($patient_diagnosis['Diagnosis'] as $diagnosis_rec_number => $new_diagnosis) {
				$new_diagnosis['DiagnosisMaster'] = array_merge($new_diagnosis['DiagnosisMaster'], array('diagnosis_control_id' => $diagnosis_controls['id'], 'participant_id' => $pariticpant_id, 'qc_nd_sardo_id' => $diagnosis_rec_number));
				$diagnosis_master_id = insert($new_diagnosis['DiagnosisMaster'], 'diagnosis_masters', __LINE__);
				$new_diagnosis['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
				insert($new_diagnosis['DiagnosisDetail'], $diagnosis_controls['detail_tablename'], __LINE__, true);
				$diagnosis_rec_number_to_diagnosis_master_id[$diagnosis_rec_number] = $diagnosis_master_id;
			}
		}
	}
}
	









/*
 //TODO
diagnosis_masters.

<DateDerniereVisite>20130715</DateDerniereVisite>
<Censure>1</Censure>

 * SARDO : Cause of death                 |
SARDO : Estrogen Receptor Intensities  |
SARDO : Estrogen Receptor Results      |
                        |
                          |
SARDO : HER2/NEU Intensities           |
SARDO : HER2/NEU Results               |
         |
SARDO : Progestin Receptor Intensities |
SARDO : Progestin Receptor Results     |



*/





//TODO load ca125 et psa just once.... add code. Should not be linked to diagnosis_master_id. Add code in hook too

//==============================================================================================
//Load custom list
//==============================================================================================

loadCustomLists();

//TODO manage commit rollback

echo "done";

//==============================================================================================
//Load structure_permissible_values_custom_controls
//==============================================================================================

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function importDie($msg, $rollbak = true) {
	if($rollbak) {
//TODO manage commit rollback
	}
	die($msg);
}

function query($query, $line, $insert = false) {
	global $db_icm_connection;
	$query_res = mysqli_query($db_icm_connection, $query) or importDie("QUERY ERROR line $line [".mysqli_error($db_icm_connection)."] : $query");
	return ($insert)? mysqli_insert_id($db_icm_connection) : $query_res;
}
	
function insert($data, $table_name, $line, $is_detail_table = false) {
	global $import_date;
	global $import_by;
	
	$data_to_insert = array();
	foreach($data as $key => $value) {
		if(strlen($value)) $data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
	}
	// Insert into table
	$table_system_data = $is_detail_table? array() : array("created" => "'$import_date'", "created_by" => "'$import_by'", "modified" => "'$import_date'", "modified_by" => "'$import_by'");
	$insert_arr = array_merge($data_to_insert, $table_system_data);
	$record_id = query("INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $line, true);
	// Insert into revs table
	$revs_table_system_data = $is_detail_table? array('version_created' => "'$import_date'") : array('id' => "$record_id", 'version_created' => "'$import_date'");
	$insert_arr = array_merge($data_to_insert, $revs_table_system_data);
	query("INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $line, true);
	
	return $record_id;
}	

?>