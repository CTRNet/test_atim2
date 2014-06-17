<?php

//==============================================================================================
// Variables
//==============================================================================================

$file_path = "C:/_Perso/Server/icm/data/Export_CRCHUM_deno.XML";
$file_path = "C:/_Perso/Server/icm/data/Export_CRCHUM_short_deno_20140610.XML";

$is_server = false;

//TODO set to false after first import
$is_initial_import = true;

$import_summary = array();

//==============================================================================================
//Database
//==============================================================================================

global $db_connection;

$db_ip			= "127.0.0.1";
$db_user 		= "root";
$db_pwd			= "";
$db_schema		= "icm";
$db_charset		= "utf8";

if($is_server) {
	$db_ip			= "localhost";
	$db_user 		= "root";
	$db_pwd			= "xxx";
	$db_schema		= "icmtmp";
}

$db_connection = @mysqli_connect(
	$db_ip.(!empty($db_port)? ":".$db_port : ''),
	$db_user,
	$db_pwd
) or importDie("Could not connect to MySQL", false);
if(!mysqli_set_charset($db_connection, $db_charset)){
	importDie("Invalid charset", false);
}
@mysqli_select_db($db_connection, $db_schema) or importDie("db selection failed", false);

global $import_date;
global $import_by;
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE username = 'SardoMigration';", __LINE__);
if($query_res->num_rows != 1) importDie('ERR : No user SardoMigration!');
list($import_date, $import_by) = array_values(mysqli_fetch_assoc($query_res));

//TODO manage commit rollback

//==============================================================================================
//XML file
//==============================================================================================

if(!file_exists($file_path)) importDie("ERR_XML00001 : The file $file_path does not exist!"); 
$xml = new SimpleXMLElement($file_path, Null, True);

function getValueFromXml(&$new_record, $field) { 
	if(!isset($new_record->{$field})) importDie("ERR_XML00003 : XML field [".$field."] does not exists!"); 
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

// Treatment

$treatment_controls = array();
$query_res = customQuery("SELECT tc.id as treatment_control_id, tc.detail_tablename as treatment_detail_tablename, tc.tx_method, tc.treatment_extend_control_id, tec.detail_tablename treatment_extend_detail_tablename
		FROM treatment_controls tc LEFT JOIN treatment_extend_controls tec ON tec.id = tc.treatment_extend_control_id  
		WHERE tc.flag_active = 1;", __LINE__);
while($res =  mysqli_fetch_assoc($query_res)) {
	$treatment_controls[$res['tx_method']] = $res;
	if($res['treatment_detail_tablename'] != 'qc_nd_txd_sardos') importDie("ERR_TX00002 : Treatment deail table error!");
	if($res['treatment_extend_detail_tablename'] != 'qc_nd_txe_sardos') importDie("ERR_TX00003 : Treatment extend deail table error!");
}
customQuery("DELETE FROM qc_nd_txe_sardos;", __LINE__);
customQuery("DELETE FROM treatment_extend_masters;", __LINE__);
customQuery("DELETE FROM qc_nd_txe_sardos_revs;", __LINE__);
customQuery("DELETE FROM treatment_extend_masters_revs;", __LINE__);
customQuery("DELETE FROM qc_nd_txd_sardos;", __LINE__);
customQuery("DELETE FROM treatment_masters;", __LINE__);
customQuery("DELETE FROM qc_nd_txd_sardos_revs;", __LINE__);
customQuery("DELETE FROM treatment_masters_revs;", __LINE__);

// Event (rapport)

$rapport_event_controls = array();
$query_res = customQuery("SELECT id, detail_tablename, event_type FROM event_controls WHERE event_type IN ('estrogen receptor report (RE)', 'progestin receptor report (RP)', 'her2/neu') AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 3) importDie('ERR_LAB00002 : Rapports unknown!');
while($res =  mysqli_fetch_assoc($query_res)) {
	$rapport_event_controls[$res['event_type']] = $res;
	customQuery("DELETE FROM ".$res['detail_tablename'].";", __LINE__);
	customQuery("DELETE FROM event_masters WHERE event_control_id = ".$res['id'].";", __LINE__);
	customQuery("DELETE FROM ".$res['detail_tablename']."_revs;", __LINE__);
	customQuery("DELETE FROM event_masters_revs WHERE event_control_id = ".$res['id'].";", __LINE__);
}

// Diagnosis

global $diagnosis_controls;
$query_res = customQuery("SELECT id, detail_tablename FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'sardo' AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 1) importDie('ERR_DX00002 : SARDO Primary diagnosis unknown!');
$diagnosis_controls = mysqli_fetch_assoc($query_res);

customQuery("DELETE FROM ".$diagnosis_controls['detail_tablename'].";", __LINE__);
customQuery("UPDATE diagnosis_masters SET parent_id = null, primary_id = null WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
customQuery("DELETE FROM diagnosis_masters WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
customQuery("DELETE FROM ".$diagnosis_controls['detail_tablename']."_revs;", __LINE__);
customQuery("UPDATE diagnosis_masters_revs SET parent_id = null, primary_id = null WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
customQuery("DELETE FROM diagnosis_masters_revs WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);

//==============================================================================================
//Load structure_permissible_values_custom_controls
//==============================================================================================

global $structure_permissible_values_custom_controls;
$structure_permissible_values_custom_controls = array();
$query_res = customQuery("SELECT id, name, flag_active, values_max_length, category, values_used_as_input_counter, values_counter FROM structure_permissible_values_custom_controls WHERE name LIKE 'SARDO%';", __LINE__);
While($res = mysqli_fetch_assoc($query_res)) {
	$structure_permissible_values_custom_controls[$res['name']] = array_merge($res, array('new_values' => array()));
}

function addValuesToCustomList($control_name, $value) {
	global $structure_permissible_values_custom_controls;
	if(!strlen($value)) return '';
	if(!isset($structure_permissible_values_custom_controls[$control_name])) importDie("ERR_CUSTOMLIST00001 : The custom list $control_name does not exist!"); 
	$values_max_length = $structure_permissible_values_custom_controls[$control_name]['values_max_length'];
	if(strlen($value) > $values_max_length) {
		$import_summary['Custom List']['WARNING']["Value(s) for '$control_name' custom list is too long (> $values_max_length characters)!"][] = $value;
		$value = substr($value, 0, $values_max_length);
	}
	$structure_permissible_values_custom_controls[$control_name]['new_values'][$value] = $value;
	return $value;
}

function loadCustomLists() {
	global $structure_permissible_values_custom_controls;
	foreach($structure_permissible_values_custom_controls as $new_custom_list) {
		$control_id = $new_custom_list['id'];
		customQuery("DELETE FROM structure_permissible_values_customs WHERE control_id = $control_id;", __LINE__);
		customQuery("DELETE FROM structure_permissible_values_customs_revs WHERE control_id = $control_id;", __LINE__);
		foreach($new_custom_list['new_values'] as $new_value) {
			customInsert(array('value' => $new_value, 'control_id' => $control_id, 'use_as_input' => '1'), 'structure_permissible_values_customs', __LINE__);
		}
		customQuery("UPDATE structure_permissible_values_custom_controls SET values_counter = ".sizeof($new_custom_list['new_values']).", values_used_as_input_counter = ".sizeof($new_custom_list['new_values'])." WHERE id = $control_id;", __LINE__);
	}
}

//==============================================================================================
//Load diagnosis
//==============================================================================================

global $patient_recNbr_to_participant_id_and_profile_info;
global $dx_recNbr_to_ids;
$patient_recNbr_to_participant_id_and_profile_info = array();
$dx_recNbr_to_ids = array();

$last_patient_rec_number = null;
$patient_rec_number = null;
$patient_diagnosis = array();
foreach($xml->Diagnostic as $new_diagnosis) {
	$patient_rec_number = getValueFromXml($new_diagnosis, 'ParentRecNumber');
	if(!$patient_rec_number) importDie("ERR_DX00001 : Empty Patient Rec Number!"); 
	//New Patient
	if($last_patient_rec_number != $patient_rec_number) {
		recordPatientDiagnosis($patient_diagnosis);	
		$last_patient_rec_number = $patient_rec_number;
		$patient_diagnosis = array(
			'PatientRecNumber' => $patient_rec_number,
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
	//Add patient visite date
	list($last_visit_date, $last_visit_date_accuracy) = getDateFromXml($new_diagnosis, 'DateDerniereVisite');
	if($last_visit_date) {
		if(isset($patient_diagnosis['last_visit'])) {
			if($patient_diagnosis['last_visit']['last_visit_date'] != $last_visit_date || $patient_diagnosis['last_visit']['last_visit_date_accuracy'] != $last_visit_date_accuracy) {
				$import_summary['Diagnosis']['ERROR']["2 different visit dates for the same patient"][] = "Patient RecNumber $patient_rec_number.";
			}			
		} else {
			$patient_diagnosis['last_visit'] = array('last_visit_date' => $last_visit_date, 'last_visit_date_accuracy' => $last_visit_date_accuracy);
		}
	}
	//Add censure	
	if(getValueFromXml($new_diagnosis, 'Censure')) {
		$patient_diagnosis['censure_equals_1']  = true;
	} else if(!isset($patient_diagnosis['censure_equals_1'])) {
		$patient_diagnosis['censure_equals_1']  = false;
	}
}
recordPatientDiagnosis($patient_diagnosis);	//The last patient
customQuery("UPDATE diagnosis_masters SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
customQuery("UPDATE diagnosis_masters_revs SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);

function recordPatientDiagnosis($patient_diagnosis) {
	global $diagnosis_controls;
	global $patient_recNbr_to_participant_id_and_profile_info;
	global $dx_recNbr_to_ids;
	
//TODO remove data creation limit
if(sizeof($patient_recNbr_to_participant_id_and_profile_info) > 10) return;	
	if(!empty($patient_diagnosis)) {
		if(empty($patient_diagnosis['NoLabos'])) {
			//Nothing to do: Not a Bank Patient
		} else {
			$query = "SELECT DISTINCT mi.participant_id FROM misc_identifier_controls mic INNER JOIN misc_identifiers mi 
				WHERE mi.misc_identifier_control_id = mic.id AND mic.misc_identifier_name LIKE '%bank no lab' AND mic.flag_active = 1
				AND mi.identifier_value IN ('".implode("','",$patient_diagnosis['NoLabos'])."');";
			$query_res = customQuery($query, __LINE__);
			if($query_res->num_rows != 1) {
				$import_summary['Diagnosis']['ERROR']["SARDO patient(s) linked to more than one ATiM patients"][] = "RecNumber ".$patient_diagnosis['PatientRecNumber']." (NoLabos: ".implode(', ',$patient_diagnosis['NoLabos']).")";
			} else {
				$res = mysqli_fetch_assoc($query_res);
				$pariticpant_id = $res['participant_id'];
				if(isset($patient_recNbr_to_participant_id_and_profile_info[$patient_diagnosis['PatientRecNumber']])) {
					$import_summary['Diagnosis']['ERROR']["ATiM patient(s) linked to more than one SARDO patients"][] = "NoLabos: ".implode(', ',$patient_diagnosis['NoLabos']);
				}
				$patient_recNbr_to_participant_id_and_profile_info[$patient_diagnosis['PatientRecNumber']]['participant_id'] = $pariticpant_id;
				$patient_recNbr_to_participant_id_and_profile_info[$patient_diagnosis['PatientRecNumber']]['profile'] = isset($patient_diagnosis['last_visit'])? $patient_diagnosis['last_visit'] : array();
				$patient_recNbr_to_participant_id_and_profile_info[$patient_diagnosis['PatientRecNumber']]['profile']['censure_equals_1'] = $patient_diagnosis['censure_equals_1'];
				foreach($patient_diagnosis['Diagnosis'] as $diagnosis_rec_number => $new_diagnosis) {
					$new_diagnosis['DiagnosisMaster'] = array_merge($new_diagnosis['DiagnosisMaster'], array('diagnosis_control_id' => $diagnosis_controls['id'], 'participant_id' => $pariticpant_id, 'qc_nd_sardo_id' => $diagnosis_rec_number));
					$diagnosis_master_id = customInsert($new_diagnosis['DiagnosisMaster'], 'diagnosis_masters', __LINE__);
					$new_diagnosis['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
					customInsert($new_diagnosis['DiagnosisDetail'], $diagnosis_controls['detail_tablename'], __LINE__, true);
					$dx_recNbr_to_ids[$diagnosis_rec_number] = array('participant_id' => $pariticpant_id, 'diagnosis_master_id' => $diagnosis_master_id);
				}
			}
		}
	}
}

//==============================================================================================
//Update patient
//==============================================================================================

//Get identifier Controls
$query_res = customQuery("SELECT id, misc_identifier_name FROM misc_identifier_controls WHERE misc_identifier_name IN ('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr', 'ramq nbr') AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 4) importDie('ERR_PAT00001 : Misc identifier controls error!');
$misc_identifier_controls = array();
while($res =  mysqli_fetch_assoc($query_res)) {
	$misc_identifier_controls[$res['id']] = $res['misc_identifier_name'];
}
//Update patient data
$updated_reproductive_history_ids = array();
foreach($xml->Patient as $new_patient) {
	$patient_rec_number = getValueFromXml($new_patient, 'RecNumber');
	if(!isset($patient_recNbr_to_participant_id_and_profile_info[$patient_rec_number])) {
		//Nothing to do: Not a Bank Patient
	} else {
		$participant_id = $patient_recNbr_to_participant_id_and_profile_info[$patient_rec_number]['participant_id'];
		$patient_data_to_update = array('qc_nd_sardo_rec_number' => $patient_rec_number, 'qc_nd_sardo_last_import' => $import_date, 'modified' => $import_date, 'modified_by' => $import_by);
		//Check Patient Identfiers
		$hospital_nbr = getValueFromXml($new_patient, 'NoDossier');
		$ramq = getValueFromXml($new_patient, 'RAMQ');
		$query = "SELECT misc_identifier_control_id FROM misc_identifiers WHERE deleted <> 1 AND participant_id = $participant_id AND misc_identifier_control_id IN (".implode(',',array_keys($misc_identifier_controls)).") AND identifier_value IN ('$ramq', '$hospital_nbr');";
		$query_res = customQuery($query, __LINE__);
		if(!$query_res->num_rows) $import_summary['Patient']['WARNING']["No SARDO patient identifiers (RAMQ, hospital Nbr) matches patient identifiers in ATiM"][] = "Patient RecNumber $patient_rec_number (ATiM participant id = $participant_id)";
		$patient_data_to_update['qc_nd_sardo_diff_ramq'] = 'y';
		$patient_data_to_update['qc_nd_sardo_diff_hd_nbr'] = 'y';
		$patient_data_to_update['qc_nd_sardo_diff_sl_nbr'] = 'y';
		$patient_data_to_update['qc_nd_sardo_diff_nd_nbr'] = 'y';
		while($res =  mysqli_fetch_assoc($query_res)) {
			switch($misc_identifier_controls[$res[misc_identifier_control_id]]) {
				case 'hotel-dieu id nbr':
					$patient_data_to_update['qc_nd_sardo_diff_hd_nbr'] = 'n';
					break;
				case 'saint-luc id nbr':
					$patient_data_to_update['qc_nd_sardo_diff_sl_nbr'] = 'n';
					break;
				case 'notre-dame id nbr':
					$patient_data_to_update['qc_nd_sardo_diff_nd_nbr'] = 'n';
					break;
				case 'ramq nbr':
					$patient_data_to_update['qc_nd_sardo_diff_ramq'] = 'n';
					break;
			}
		}
		//Check patient data
		$query_res = customQuery("SELECT first_name, last_name, date_of_birth, date_of_birth_accuracy, sex, vital_status, date_of_death, date_of_death_accuracy, qc_nd_last_contact, qc_nd_last_contact_accuracy, reproductive_histories.id AS reproductive_history_id, lnmp_date, lnmp_date_accuracy, menopause_status 
				FROM participants 
				LEFT JOIN reproductive_histories ON reproductive_histories.participant_id = participants.id AND reproductive_histories.deleted <> 1
				WHERE participants.id = $participant_id AND participants.deleted <> 1;", __LINE__);
		if(!$query_res->num_rows) importDie("ERR_PAT00001 : Patient does not exist (participant id = $participant_id)!"); 
		$atim_patient_data =  mysqli_fetch_assoc($query_res);
		//   -> first name
		$sardo_first_name = getValueFromXml($new_patient, 'Prenom');
		$patient_data_to_update['qc_nd_sardo_diff_first_name'] = 'y';
		if(empty($atim_patient_data['first_name'])) {
			$patient_data_to_update['first_name'] = $sardo_first_name;
			$patient_data_to_update['qc_nd_sardo_diff_first_name'] = 'n';
		} else if(strtolower($sardo_first_name) == strtolower($atim_patient_data['first_name'])) {
			$patient_data_to_update['qc_nd_sardo_diff_first_name'] = 'n';
		}
		//   -> last name
		$sardo_last_name = getValueFromXml($new_patient, 'Nom');
		$patient_data_to_update['qc_nd_sardo_diff_last_name'] = 'y';
		if(empty($atim_patient_data['last_name'])) {
			$patient_data_to_update['last_name'] = $sardo_last_name;
			$patient_data_to_update['qc_nd_sardo_diff_last_name'] = 'n';
		} else if(strtolower($sardo_last_name) == strtolower($atim_patient_data['last_name'])) {
			$patient_data_to_update['qc_nd_sardo_diff_last_name'] = 'n';
		}
		//   -> sex
		$sardo_sex = '';
		switch(getValueFromXml($new_patient, 'Sexe')) {
			case '';
				break;
			case 'F':
				$sardo_sex = 'f';
			case 'M':
				$sardo_sex = 'm';
			default;
				$sardo_sex = 'other';	
		}
		$patient_data_to_update['qc_nd_sardo_diff_sex'] = 'y';
		if(empty($atim_patient_data['sex'])) {
			$patient_data_to_update['sex'] = $sardo_sex;
			$patient_data_to_update['qc_nd_sardo_diff_sex'] = 'n';
		} else if($sardo_sex == $atim_patient_data['sex']) {
			$patient_data_to_update['qc_nd_sardo_diff_sex'] = 'n';
		}
		//   -> date of birth		
		list($sardo_date_of_birth, $sardo_date_of_birth_accuracy) = getDateFromXml($new_patient, 'DateNaissance');
		$patient_data_to_update['qc_nd_sardo_diff_date_of_birth'] = 'y';
		if(empty($atim_patient_data['date_of_birth'])) {
			$patient_data_to_update['date_of_birth'] = $sardo_date_of_birth;
			$patient_data_to_update['date_of_birth_accuracy'] = $sardo_date_of_birth_accuracy;
			$patient_data_to_update['qc_nd_sardo_diff_date_of_birth'] = 'n';
		} else if($sardo_date_of_birth == $atim_patient_data['date_of_birth'] && $sardo_date_of_birth_accuracy == $atim_patient_data['date_of_birth_accuracy']) {
			$patient_data_to_update['qc_nd_sardo_diff_date_of_birth'] = 'n';
		}
		//   -> death
		$patient_data_to_update['qc_nd_sardo_cause_of_death'] = addValuesToCustomList("SARDO : Cause of death", getValueFromXml($new_patient, 'CauseDeces'));
		list($sardo_date_of_death, $sardo_date_of_death_accuracy) = getDateFromXml($new_patient, 'DateDeces');
		$sardo_censure_equals_1 = $patient_recNbr_to_participant_id_and_profile_info[$patient_rec_number]['profile']['censure_equals_1'];
		$sardo_vital_status = ($sardo_censure_equals_1 || strlen($patient_data_to_update['qc_nd_sardo_cause_of_death']) || $sardo_date_of_death)? '' : 'deceased';
		$patient_data_to_update['qc_nd_sardo_diff_vital_status'] = 'y';
		if(empty($atim_patient_data['vital_status'])) {
			$patient_data_to_update['vital_status'] = $sardo_vital_status;
			$patient_data_to_update['qc_nd_sardo_diff_vital_status'] = 'n';
		} else if($sardo_vital_status == $atim_patient_data['vital_status']) {
			$patient_data_to_update['qc_nd_sardo_diff_vital_status'] = 'n';
		}
		$patient_data_to_update['qc_nd_sardo_diff_date_of_death'] = 'y';
		if(empty($atim_patient_data['date_of_death'])) {
			$patient_data_to_update['date_of_death'] = $sardo_date_of_death;
			$patient_data_to_update['date_of_death_accuracy'] = $sardo_date_of_death_accuracy;
			$patient_data_to_update['qc_nd_sardo_diff_date_of_death'] = 'n';
		} else if($sardo_date_of_death == $atim_patient_data['date_of_death'] && $sardo_date_of_death_accuracy == $atim_patient_data['date_of_death_accuracy']) {
			$patient_data_to_update['qc_nd_sardo_diff_date_of_death'] = 'n';
		}
		//   -> Last Contact
		$sardo_last_visit_date = $patient_recNbr_to_participant_id_and_profile_info[$patient_rec_number]['profile']['last_visit_date'];
		$sardo_last_visit_date_accuracy = $patient_recNbr_to_participant_id_and_profile_info[$patient_rec_number]['profile']['last_visit_date_accuracy'];
		if(empty($atim_patient_data['qc_nd_last_contact']) || ($sardo_last_visit_date && $atim_patient_data['qc_nd_last_contact'] < $sardo_last_visit_date)) {
			$patient_data_to_update['qc_nd_last_contact'] = $sardo_last_visit_date;
			$patient_data_to_update['qc_nd_last_contact_accuracy'] = $sardo_last_visit_date_accuracy;
		}
		//   -> Reporductive History
		$repro_data_to_update = array();
		$sardo_lnmp = str_replace('9999', '', getValueFromXml($new_patient, 'AnneeMenopause'));
		if($sardo_lnmp) {
			if(!$atim_patient_data['reproductive_history_id']) {
				//Create a new one
				customInsert(array('participant_id' => $participant_id, 'lnmp_date' => $sardo_lnmp.'-01-01', 'lnmp_date_accuracy' => 'm', 'menopause_status' => 'post'), 'reproductive_histories', __LINE__);
				$patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'n';
			} else {
				$repro_data_to_update = array();
				$patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'n';
				//   -> (menopause_status)
				if(empty($atim_patient_data['menopause_status'])) {
					$repro_data_to_update['menopause_status'] = 'post';
				} else if($atim_patient_data['menopause_status'] != 'post') {
					$patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'y';
				}
				//   -> (menopause date)
				if(empty($atim_patient_data['lnmp_date'])) {
					$repro_data_to_update['lnmp_date'] = $sardo_lnmp.'-01-01';
					$repro_data_to_update['lnmp_date_accuracy'] = 'm';
				} else if($atim_patient_data['lnmp_date'] != substr($atim_patient_data['lnmp_date'], 0, 4)) {
					$patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'y';
				}	
				//Update reporductive history
				if($repro_data_to_update) {
					$query = "UPDATE reproductive_histories SET ";
					$coma = '';
					foreach($repro_data_to_update as $field => $value ) {
						if(strlen($value)) $query .= $coma." $field = '".str_replace("'", "''", $value)."'";
						$coma = ', ';
					}
					$query .= " WHERE id = ".$atim_patient_data['reproductive_history_id'].";";
					customQuery($query, __LINE__);
					$updated_reproductive_history_ids[] = $atim_patient_data['reproductive_history_id'];
				}
			}				
		}
		//Update patient
		$query = "UPDATE participants SET ";
		$coma = '';
		foreach($patient_data_to_update as $field => $value ) {
			if(strlen($value)) $query .= $coma." $field = '".str_replace("'", "''", $value)."'";
			$coma = ', ';
		}
		$query .= " WHERE id = $participant_id;";
		customQuery($query, __LINE__);	
	}
}
// Tracks patients matching SARDO patient in th epast but matching no sardo patient anymore
$query = "SELECT id, qc_nd_sardo_rec_number FROM participants WHERE deleted <> 1 AND (qc_nd_sardo_rec_number IS NOT NULL AND qc_nd_sardo_rec_number NOT LIKE '') AND qc_nd_sardo_last_import < '$import_date';";
$query_res = customQuery($query, __LINE__);
while($res =  mysqli_fetch_assoc($query_res)) {	
	$import_summary['Patient']['WARNING']['SARDO patient not synchronized anymore'][] = "Patient RecNumber ".$res['qc_nd_sardo_rec_number']." (ATiM participant id = ".$res['id']." )";
}
//Insert Into Participants Revs Table
$query = "SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='$db_schema' AND COLUMN_NAME NOT IN('created','created_by','modified','modified_by','deleted') AND TABLE_NAME LIKE 'participants'";
$query_res = customQuery($query, __LINE__);
$participants_fields = array();
while($res =  mysqli_fetch_assoc($query_res)) {
	$participants_fields[] = $res['COLUMN_NAME'];
}
$participants_fields = implode(',',$participants_fields);
customQuery("INSERT INTO participants_revs ($participants_fields, modified_by, version_created) (SELECT $participants_fields, modified_by, modified FROM participants WHERE qc_nd_sardo_last_import = '".substr($import_date, 0, strpos($import_date, ' '))."');", __LINE__);
//Insert Into Reproductive Histories Revs Table
if($updated_reproductive_history_ids) {
	$query = "SELECT COLUMN_NAME FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='$db_schema' AND COLUMN_NAME NOT IN('created','created_by','modified','modified_by','deleted') AND TABLE_NAME LIKE 'reproductive_histories'";
	$query_res = customQuery($query, __LINE__);
	$reproductive_history_fields = array();
	while($res =  mysqli_fetch_assoc($query_res)) {
		$reproductive_history_fields[] = $res['COLUMN_NAME'];
	}
	$reproductive_history_fields = implode(',',$reproductive_history_fields);
	customQuery("INSERT INTO reproductive_histories_revs ($reproductive_history_fields, modified_by, version_created) (SELECT $reproductive_history_fields, modified_by, modified FROM reproductive_histories WHERE id IN (".implode(',',$updated_reproductive_history_ids).");", __LINE__);	
}

//==============================================================================================
//Load Treatment
//==============================================================================================

$tx_recNbr_to_tx_dates_and_dx_recNbr = array();
$previous_treatment_key = null;
$treatment_data = array();
foreach($xml->Traitement as $new_treatment) {
	$treatment_rec_number = getValueFromXml($new_treatment, 'RecNumber');
	$diagnosis_rec_number = getValueFromXml($new_treatment, 'ParentRecNumber');
	if(!isset($dx_recNbr_to_ids[$diagnosis_rec_number])) {
		//Nothing to do: Not a Bank Patient	
	} else {
		$tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]['dxRecNbr'] = $diagnosis_rec_number;
		$trt_type = getValueFromXml($new_treatment, 'TypeTX');
		$tx_method = 'sardo treatment - '.strtolower($trt_type);
		if(!isset($treatment_controls[$tx_method])) importDie("ERR_TX00001 : Treatment [".$tx_method."] unknown!");
		list($start_date, $start_date_accuracy)  = getDateFromXml($new_treatment, 'DateDebutTraitement');
		$tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]['dates'] = array($start_date, $start_date_accuracy);
		if(in_array($trt_type, array('RADIO','CHIR','IMAGE','BIOP','HORM','CHIMIO','PAL','AUTRE','CYTO','PROTOC','BILAN','REVISION','IMMUNO','MEDIC','EXAM','OBS','VISITE','SYMPT','RESUME'))) {
			list($finish_date, $finish_date_accuracy)  = getDateFromXml($new_treatment, 'DateFinTraitement');
			$NoPatho = getValueFromXml($new_treatment, 'NoPatho');
			$results = addValuesToCustomList("SARDO : $trt_type Results", getValueFromXml($new_treatment, 'Resultat_Alpha'));
			$objectifs = addValuesToCustomList("SARDO : $trt_type Objectifs", getValueFromXml($new_treatment, 'ObjectifTX'));
			//Build the treatment key
			$treatment_key = md5($diagnosis_rec_number.$trt_type.$start_date.$finish_date.$NoPatho.$results.$objectifs);
			if($treatment_key != $previous_treatment_key) {
				//Record previous treatment then create new treatment		
				recordPatientTreatment($treatment_data);
				$treatment_data = array(
					'TreatmentMaster' => array(
						'treatment_control_id' => $treatment_controls[$tx_method]['treatment_control_id'],
						'participant_id' => $dx_recNbr_to_ids[$diagnosis_rec_number]['participant_id'],
						'diagnosis_master_id' => $dx_recNbr_to_ids[$diagnosis_rec_number]['diagnosis_master_id'],
						'start_date' => $start_date,
						'start_date_accuracy' => $start_date_accuracy,
						'finish_date' => $finish_date,
						'finish_date_accuracy' => $finish_date_accuracy),
					'TreatmentDetail' => array(
						'patho_nbr' => $NoPatho,
						'results' => $results,
						'objectifs' => $objectifs),
					'TreatmentExtends' => array());			
			}
			$previous_treatment_key = $treatment_key;
			$treatment_extend_data = addValuesToCustomList("SARDO : $trt_type Treatments", getValueFromXml($new_treatment, 'Traitement'));
			if(strlen($treatment_extend_data)) {		
				$treatment_data['TreatmentExtends'][] = array(
					'TreatmentExtendMaster' => array('treatment_extend_control_id' => $treatment_controls[$tx_method]['treatment_extend_control_id']),
					'TreatmentExtendDetail' => array('treatment' => $treatment_extend_data));
			}
		}
	}
}
recordPatientTreatment($treatment_data);

function recordPatientTreatment($treatment_data) {
	if(!empty($treatment_data)) {
		$treatment_master_id = customInsert($treatment_data['TreatmentMaster'], 'treatment_masters', __LINE__);
		$treatment_data['TreatmentDetail']['treatment_master_id'] = $treatment_master_id;
		customInsert($treatment_data['TreatmentDetail'], 'qc_nd_txd_sardos', __LINE__, true);	
		foreach($treatment_data['TreatmentExtends'] as $new_extend) {	
			$new_extend['TreatmentExtendMaster']['treatment_master_id'] = $treatment_master_id;
			$treatment_extend_master_id = customInsert($new_extend['TreatmentExtendMaster'], 'treatment_extend_masters', __LINE__);
			$new_extend['TreatmentExtendDetail']['treatment_extend_master_id'] = $treatment_extend_master_id;
			customInsert($new_extend['TreatmentExtendDetail'], 'qc_nd_txe_sardos', __LINE__, true);	
		}
	}
}

//==============================================================================================
//LOAD APS & CA-125 (once)
//==============================================================================================

if($is_initial_import) {
	$ca125_psa_event_controls = array();
	$query_res = customQuery("SELECT id, detail_tablename, event_type FROM event_controls WHERE event_type IN ('ca125', 'psa') AND flag_active = 1;", __LINE__);
	if($query_res->num_rows != 2) importDie('ERR_LAB00001 : CA125 and PAS Lab unknown!');
	while($res =  mysqli_fetch_assoc($query_res)) {		
		$ca125_psa_event_controls[$res['event_type']] = $res;
		customQuery("DELETE FROM ".$res['detail_tablename'].";", __LINE__);
		customQuery("DELETE FROM event_masters WHERE event_control_id = ".$res['id'].";", __LINE__);
		customQuery("DELETE FROM ".$res['detail_tablename']."_revs;", __LINE__);
		customQuery("DELETE FROM event_masters_revs WHERE event_control_id = ".$res['id'].";", __LINE__);
	}
	foreach($xml->Labo as $new_labo) {	
		$diagnosis_rec_number = getValueFromXml($new_labo, 'ParentRecNumber');
		if(!isset($dx_recNbr_to_ids[$diagnosis_rec_number])) {
			//Nothing to do: Not a Bank Patient	
		} else {
			$test = getValueFromXml($new_labo, 'NomLabo');
			if(in_array($test, array('APS pré-op', 'APS', 'CA-125'))) {
				$event_data= array(
					'EventMaster' => array(
						'event_control_id' => $ca125_psa_event_controls[(($test == 'CA-125')? 'ca125' : 'psa')]['id'], 
						'participant_id' => $dx_recNbr_to_ids[$diagnosis_rec_number]['participant_id']), 
					'EventDetail' => array(
						'value' => getValueFromXml($new_labo, 'Resultat')));
				if($event_data['EventDetail']['value'] == '-99') $event_data['EventDetail']['value'] = '';
				list($event_data['EventMaster']['event_date'], $event_data['EventMaster']['event_date_accuracy'])  = getDateFromXml($new_labo, 'Date');
				
				$event_master_id = customInsert($event_data['EventMaster'], 'event_masters', __LINE__, false, true);
				$event_data['EventDetail']['event_master_id'] = $event_master_id;
				customInsert($event_data['EventDetail'],  $ca125_psa_event_controls[(($test == 'CA-125')? 'ca125' : 'psa')]['detail_tablename'], __LINE__, true, true);				
			}
		}
	}
}

//==============================================================================================
//LOAD Rapport
//==============================================================================================

foreach($xml->Rapport as $new_report) {
	$treatment_rec_number = getValueFromXml($new_report, 'ParentRecNumber');
	if(!isset($tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]) || !isset($dx_recNbr_to_ids[$tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]['dxRecNbr']])) {
		//Nothing to do: Not a Bank Patient
	} else {		
		$control = array();
		$fish = false;
		switch(getValueFromXml($new_report, 'ElementRapport')) {
			case 'Récepteurs aux oestrogènes (RE)':
				$control = $rapport_event_controls['estrogen receptor report (RE)'];
			 	break;
			case 'Récepteurs aux progestatifs (RP)':
				$control = $rapport_event_controls['progestin receptor report (RP)'];
			 	break;
			case 'HER-2/NEU par FISH':
				$fish = true;
			case 'HER-2/NEU':
				$control = $rapport_event_controls['her2/neu'];
			 	break;
		}
		if($control) {
			$event_data= array(
				'EventMaster' => array(
					'event_control_id' => $control['id'],
					'participant_id' => $dx_recNbr_to_ids[$tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]['dxRecNbr']]['participant_id'],
					'diagnosis_master_id' => $dx_recNbr_to_ids[$tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]['dxRecNbr']]['diagnosis_master_id']),
				'EventDetail' => array());
			list($event_data['EventMaster']['event_date'], $event_data['EventMaster']['event_date_accuracy']) = $tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]['dates'];
			if(in_array($control['detail_tablename'], array('qc_nd_ed_estrogen_receptor_reports', 'qc_nd_ed_progestin_receptor_reports'))) {
				$results = getValueFromXml($new_report, 'Resultat');
				$event_data['EventMaster']['event_summary'] = $results;
				if(preg_match('/((,\ ){0,1}(\++))$/', $results, $matches)) {
					$event_data['EventDetail']['intensity'] = addValuesToCustomList('SARDO : Estrogen/Progestin Receptor Intensities', $matches[3]);
					$results = str_replace($matches[1], '', $results);
				}
				if(preg_match('/((,\ ){0,1}(([0-9]+)([\.,][0-9]+){0,1})\ %)$/', $results, $matches)) {
					$event_data['EventDetail']['percentage'] = str_Replace(',', '.', $matches[3]);
					$results = str_replace($matches[1], '', $results);
				}
				$event_data['EventDetail']['result'] = addValuesToCustomList('SARDO : Estrogen/Progestin Receptor Results', $results);
			} else if($control['detail_tablename'] == 'qc_nd_ed_her2_neu') {
				$results = getValueFromXml($new_report, 'Resultat');
				$event_data['EventMaster']['event_summary'] = $results;
				if(preg_match('/((,\ ){0,1}(\++))$/', $results, $matches)) {
					$event_data['EventDetail']['intensity'] = addValuesToCustomList('SARDO : HER2/NEU Intensities', $matches[3]);
					$results = str_replace($matches[1], '', $results);
				}
				$event_data['EventDetail']['result'] = addValuesToCustomList('SARDO : HER2/NEU Results', $results);
				$event_data['EventDetail']['fish'] = $fish? 'y' : 'n';
			} else {
				importDie("ERR_LAB00003 : Unsupported detail tablename [".$control['detail_tablename']."]!");
			}
			$event_master_id = customInsert($event_data['EventMaster'], 'event_masters', __LINE__, false);
			$event_data['EventDetail']['event_master_id'] = $event_master_id;
			customInsert($event_data['EventDetail'], $control['detail_tablename'], __LINE__, true);	
		}
	}
}

//==============================================================================================
//Load custom list
//==============================================================================================

loadCustomLists();


//TODO manage commit rollback
echo "Import Summary : <br>";
pr($import_summary);
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

function customQuery($query, $line, $insert = false) {
	global $db_connection;
	$query_res = mysqli_query($db_connection, $query) or importDie("QUERY ERROR line $line [".mysqli_error($db_connection)."] : $query");
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}
	
function customInsert($data, $table_name, $line, $is_detail_table = false, $insert_into_revs = false) {
	global $import_date;
	global $import_by;
	
	$data_to_insert = array();
	foreach($data as $key => $value) {
		if(strlen($value)) $data_to_insert[$key] = "'".str_replace("'", "''", $value)."'";
	}
	// Insert into table
	$table_system_data = $is_detail_table? array() : array("created" => "'$import_date'", "created_by" => "'$import_by'", "modified" => "'$import_date'", "modified_by" => "'$import_by'");
	$insert_arr = array_merge($data_to_insert, $table_system_data);
	$record_id = customQuery("INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $line, true);
	// Insert into revs table
	if($insert_into_revs) {
		$revs_table_system_data = $is_detail_table? array('version_created' => "'$import_date'") : array('id' => "$record_id", 'version_created' => "'$import_date'");
		$insert_arr = array_merge($data_to_insert, $revs_table_system_data);
		customQuery("INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")", $line, true);
	}
	
	return $record_id;
}	

?>