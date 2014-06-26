<?php

//==============================================================================================
// Variables
//==============================================================================================

$is_server = true;

$file_path = "C:/_Perso/Server/icm/data/Export_CRCHUM_deno.XML";
$file_path = "C:/_Perso/Server/icm/data/Export_CRCHUM_short_deno_20140610.XML";
if($is_server) $file_path = "/ch06chuma6134/Export_CRCHUM.XML";


//TODO set to false after first import
$is_initial_import = true;

global $import_summary;
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
	$db_pwd			= "";
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
//TODO fair un dump base de données avant chaque process

//==============================================================================================
//XML file
//==============================================================================================

if(!file_exists($file_path)) importDie("ERR_XML00001 : The file $file_path does not exist!"); 
$xml = new SimpleXMLElement($file_path, Null, True);

global $next_patient_xml_id;
$next_patient_xml_id = 0;

global $next_diagnosis_xml_id;
$next_diagnosis_xml_id = 0;
global $unparsed_diagnosis_xml_data;
$unparsed_diagnosis_xml_data = null;

global $next_labo_xml_id;
$next_labo_xml_id = 0;
global $unparsed_labo_xml_data;
$unparsed_labo_xml_data = null;

global $next_treatment_xml_id;
$next_treatment_xml_id = 0;
global $unparsed_treatment_xml_data;
$unparsed_treatment_xml_data = null;

global $next_rapport_xml_id;
$next_rapport_xml_id = 0;
global $unparsed_rapport_xml_data;
$unparsed_rapport_xml_data = null;

function getNextPatientDataFromXml(&$xml) {
	global $next_patient_xml_id;
	global $next_diagnosis_xml_id;
	global $next_labo_xml_id;
	global $next_treatment_xml_id;
	global $next_rapport_xml_id;
	
	global $unparsed_diagnosis_xml_data;
	global $unparsed_labo_xml_data;
	global $unparsed_treatment_xml_data;
	global $unparsed_rapport_xml_data;
	
	$patient_xml_data = false;
		
	$patient_xml_data = $xml->Patient[$next_patient_xml_id];
	if($patient_xml_data) {
		$patient_rec_nbr = getValueFromXml($patient_xml_data, 'RecNumber');
		$patient_xml_data = array('no_labos' => array(), 'last_visit_date' => array(), 'censure' => false, 'xml' => $patient_xml_data, 'diagnosis' => array());
		//Diagnosis
		$diagnosis_xml_data = null;
		if($unparsed_diagnosis_xml_data) {		
			$diagnosis_xml_data = $unparsed_diagnosis_xml_data;
			$unparsed_diagnosis_xml_data = null;
		} else {
			$diagnosis_xml_data = $xml->Diagnostic[$next_diagnosis_xml_id];
			$next_diagnosis_xml_id++;
		}			
		while($diagnosis_xml_data) {
			if($patient_rec_nbr == getValueFromXml($diagnosis_xml_data, 'ParentRecNumber')) {
				$diagnosis_rec_nbr = getValueFromXml($diagnosis_xml_data, 'RecNumber');
				$diagnosis_data = array('xml' => $diagnosis_xml_data, 'treatments' => array(), 'labos' => array());
				//Treatment
				$treatment_xml_data = null;
				if($unparsed_treatment_xml_data) {
					$treatment_xml_data = $unparsed_treatment_xml_data;
					$unparsed_treatment_xml_data = null;
				} else {
					$treatment_xml_data = $xml->Traitement[$next_treatment_xml_id];
					$next_treatment_xml_id++;
				}
				while($treatment_xml_data) {
					if($diagnosis_rec_nbr == getValueFromXml($treatment_xml_data, 'ParentRecNumber')) {
						$treatment_rec_nbr = getValueFromXml($treatment_xml_data, 'RecNumber');
						$treatment_data = array('xml' => $treatment_xml_data, 'reports' => array());
						//Rapport
						$rapport_xml_data = null;
						if($unparsed_rapport_xml_data) {
							$rapport_xml_data = $unparsed_rapport_xml_data;
							$unparsed_rapport_xml_data = null;
						} else {
							$rapport_xml_data = $xml->Rapport[$next_rapport_xml_id];
							$next_rapport_xml_id++;
						}
						while($rapport_xml_data) {
							if($treatment_rec_nbr == getValueFromXml($rapport_xml_data, 'ParentRecNumber')) {
								$treatment_data['reports'][] = array('xml' => $rapport_xml_data);
								$rapport_xml_data = $xml->Rapport[$next_rapport_xml_id];
								$next_rapport_xml_id++;
							} else {
								$unparsed_rapport_xml_data = $rapport_xml_data;
								$rapport_xml_data = null;
							}
						}
						//End Rapport
						$diagnosis_data['treatments'][] = $treatment_data;
						$treatment_xml_data = $xml->Traitement[$next_treatment_xml_id];
						$next_treatment_xml_id++;
					} else {
						$unparsed_treatment_xml_data = $treatment_xml_data;
						$treatment_xml_data = null;
					}
				}	
				//End Treatment
				//Labo
				$labo_xml_data = null;
				if($unparsed_labo_xml_data) {
					$labo_xml_data = $unparsed_labo_xml_data;
					$unparsed_labo_xml_data = null;
				} else {
					$labo_xml_data = $xml->Labo[$next_labo_xml_id];
					$next_labo_xml_id++;
				}
				while($labo_xml_data) {
					if($diagnosis_rec_nbr == getValueFromXml($labo_xml_data, 'ParentRecNumber')) {
						$diagnosis_data['labos'][] = array('xml' => $labo_xml_data);
						$labo_xml_data = $xml->Labo[$next_labo_xml_id];
						$next_labo_xml_id++;
					} else {
						$unparsed_labo_xml_data = $labo_xml_data;
						$labo_xml_data = null;
					}
				}
				//End Labo
				$no_labo = getValueFromXml($diagnosis_xml_data, 'NoBANQUE');
				if(strlen($no_labo)) $patient_xml_data['no_labos'][] = $no_labo;
				$censure = getValueFromXml($diagnosis_xml_data, 'Censure');
				if($censure) $patient_xml_data['censure'] = true;
				list($last_visit_date, $last_visit_date_accuracy) = getDateFromXml($diagnosis_xml_data, 'DateDerniereVisite', 'Diagnosis', implode(',',$patient_xml_data['no_labos']));
				$patient_xml_data['last_visit_date'][$last_visit_date] = array('last_visit_date' => $last_visit_date, 'last_visit_date_accuracy' => $last_visit_date_accuracy);
				$patient_xml_data['diagnosis'][] = $diagnosis_data;				
				$diagnosis_xml_data = $xml->Diagnostic[$next_diagnosis_xml_id];
				$next_diagnosis_xml_id++;
			} else {
				$unparsed_diagnosis_xml_data = $diagnosis_xml_data;
				$diagnosis_xml_data = null;
			}
		}
		//END Diagnosis
	} 
	$next_patient_xml_id++;
	
	return $patient_xml_data;
}

/*function getNextPatientDataFromXml(&$xml) {
	die('Deprecated');	//Too time consuming
	
	global $next_patient_xml_id;
	global $next_diagnosis_xml_id;
	global $next_labo_xml_id;
	global $next_treatment_xml_id;
	global $next_rapport_xml_id;
	
	$patient_xml_data = false;
	
	if(isset($xml->Patient[$next_patient_xml_id])) {
		$patient_rec_nbr = getValueFromXml($xml->Patient[$next_patient_xml_id], 'RecNumber');
		$patient_xml_data = array('no_labos' => array(), 'last_visit_date' => array(), 'censure' => false, 'xml' => $xml->Patient[$next_patient_xml_id], 'diagnosis' => array());
		//Diagnosis
		while(isset($xml->Diagnostic[$next_diagnosis_xml_id]) && $patient_rec_nbr == getValueFromXml($xml->Diagnostic[$next_diagnosis_xml_id], 'ParentRecNumber')) {
			$diagnosis_rec_nbr = getValueFromXml($xml->Diagnostic[$next_diagnosis_xml_id], 'RecNumber');
			$diagnosis_data = array('xml' => $xml->Diagnostic[$next_diagnosis_xml_id], 'treatments' => array(), 'labos' => array());
			//Treatment
			while(isset($xml->Traitement[$next_treatment_xml_id]) && $diagnosis_rec_nbr == getValueFromXml($xml->Traitement[$next_treatment_xml_id], 'ParentRecNumber')) {
				$treatment_rec_nbr = getValueFromXml($xml->Traitement[$next_treatment_xml_id], 'RecNumber');
				$treatment_data = array('xml' => $xml->Traitement[$next_treatment_xml_id], 'reports' => array());
				//Rapport
				while(isset($xml->Rapport[$next_rapport_xml_id]) && $treatment_rec_nbr == getValueFromXml($xml->Rapport[$next_rapport_xml_id], 'ParentRecNumber')) {
					$treatment_data['reports'][] = array('xml' => $xml->Rapport[$next_rapport_xml_id]);
					$next_rapport_xml_id++;
				}
				$diagnosis_data['treatments'][] = $treatment_data;
				$next_treatment_xml_id++;
			}	
			//Labo
			while(isset($xml->Labo[$next_labo_xml_id]) && $diagnosis_rec_nbr == getValueFromXml($xml->Labo[$next_labo_xml_id], 'ParentRecNumber')) {
				$diagnosis_data['labos'][] = array('xml' => $xml->Labo[$next_labo_xml_id]);
				$next_labo_xml_id++;
			}
			$no_labo = getValueFromXml($xml->Diagnostic[$next_diagnosis_xml_id], 'NoBANQUE');
			if(strlen($no_labo)) $patient_xml_data['no_labos'][] = $no_labo;
			$censure = getValueFromXml($xml->Diagnostic[$next_diagnosis_xml_id], 'Censure');
			if($censure) $patient_xml_data['censure'] = true;
			list($last_visit_date, $last_visit_date_accuracy) = getDateFromXml($xml->Diagnostic[$next_diagnosis_xml_id], 'DateDerniereVisite');
			$patient_xml_data['last_visit_date'][$last_visit_date] = array('last_visit_date' => $last_visit_date, 'last_visit_date_accuracy' => $last_visit_date_accuracy);
			$patient_xml_data['diagnosis'][] = $diagnosis_data;
			$next_diagnosis_xml_id++;
		}
	} 
	$next_patient_xml_id++;
	
	return $patient_xml_data;
} */

function getValueFromXml(&$new_record, $field) { 
	if(!isset($new_record->{$field})) importDie("ERR_XML00003 : XML field [".$field."] does not exists!"); 
	$val = (string) $new_record->{$field};
	$val = preg_replace("/\n$/", '', $val);
	return $val;
	//return utf8_decode((string) $new_record->{$field}); 
}

function getDateFromXml(&$new_record, $field, $data_type, $no_labos = null) {
	$date_from_file = getValueFromXml($new_record, $field);
	$date = '';
	$date_accuracy = '';
	if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))99/', $date_from_file, $matches)) {
		$date = $matches[1].'-01-01';
		$date_accuracy = 'm';
	}  else if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))((0[1-9])|(1[0-2]))99$/', $date_from_file, $matches)) {
		$date = $matches[1].'-'.$matches[4].'-01';
		$date_accuracy = 'd';
	} else if(preg_match('/^((19[0-9]{2})|(20[0-9]{2}))((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[01]))$/', $date_from_file, $matches)) {
		$date = $matches[1].'-'.$matches[4].'-'.$matches[7];
		$date_accuracy = 'c';
	}  else if($date_from_file != '99999999' && !empty($date_from_file) && !preg_match('/^9999/', $date_from_file)){
		$import_summary[$data_type]['ERROR']["Date Format Error"][] = "Date '$date_from_file' is not supported for field [$field]!".(is_null($no_labos)? '' : "See NoLabos: $no_labos");
	}
	return array($date, $date_accuracy);
}

//==============================================================================================
// Table Clean Up and get controls data
//==============================================================================================

// Treatment

global $treatment_controls;
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

global $rapport_event_controls;
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

// Event (PSA/CA125)

global $ca125_psa_event_controls;
$ca125_psa_event_controls = array();
if($is_initial_import) {
	$query_res = customQuery("SELECT id, detail_tablename, event_type FROM event_controls WHERE event_type IN ('ca125', 'psa') AND flag_active = 1;", __LINE__);
	if($query_res->num_rows != 2) importDie('ERR_LAB00001 : CA125 and PAS Lab unknown!');
	while($res =  mysqli_fetch_assoc($query_res)) {
		$ca125_psa_event_controls[$res['event_type']] = $res;
		customQuery("DELETE FROM ".$res['detail_tablename'].";", __LINE__);
		customQuery("DELETE FROM event_masters WHERE event_control_id = ".$res['id'].";", __LINE__);
		customQuery("DELETE FROM ".$res['detail_tablename']."_revs;", __LINE__);
		customQuery("DELETE FROM event_masters_revs WHERE event_control_id = ".$res['id'].";", __LINE__);
	}
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

// Participant

if($is_initial_import)  {
	$query = "UPDATE participants SET 
		qc_nd_sardo_rec_number = '',
		qc_nd_sardo_last_import = null,
		qc_nd_sardo_cause_of_death = '',
		qc_nd_sardo_diff_first_name = '',
		qc_nd_sardo_diff_last_name = '',
		qc_nd_sardo_diff_date_of_birth = '',
		qc_nd_sardo_diff_sex = '',
		qc_nd_sardo_diff_ramq = '',
		qc_nd_sardo_diff_hospital_nbr = '',
		qc_nd_sardo_diff_date_of_death = '',
		qc_nd_sardo_diff_vital_status = '',
		qc_nd_sardo_diff_reproductive_history = '';";
	customQuery($query, __LINE__);
	$query = "UPDATE participants_revs SET
		qc_nd_sardo_rec_number = '',
		qc_nd_sardo_last_import = null,
		qc_nd_sardo_cause_of_death = '',
		qc_nd_sardo_diff_first_name = '',
		qc_nd_sardo_diff_last_name = '',
		qc_nd_sardo_diff_date_of_birth = '',
		qc_nd_sardo_diff_sex = '',
		qc_nd_sardo_diff_ramq = '',
		qc_nd_sardo_diff_hospital_nbr = '',
		qc_nd_sardo_diff_date_of_death = '',
		qc_nd_sardo_diff_vital_status = '',
		qc_nd_sardo_diff_reproductive_history = '';";
	customQuery($query, __LINE__);
}

// Identifiers

global $misc_identifier_controls;
$misc_identifier_controls = array();
$query_res = customQuery("SELECT id, misc_identifier_name FROM misc_identifier_controls WHERE misc_identifier_name IN ('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr', 'ramq nbr') AND flag_active = 1;", __LINE__);
if($query_res->num_rows != 4) importDie('ERR_PAT00001 : Misc identifier controls error!');
while($res =  mysqli_fetch_assoc($query_res)) {
	$misc_identifier_controls[$res['id']] = $res['misc_identifier_name'];
}

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
	$fr_value = $value;
	$arr_matches = array('á'=>'a','à'=>'a','â'=>'a','ä'=>'a','ã'=>'a','å'=>'a','ç'=>'c','é'=>'e','è'=>'e','ê'=>'e','ë'=>'e','í'=>'i','ì'=>'i','î'=>'i','ï'=>'i','ñ'=>'n','ó'=>'o','ò'=>'o','ô'=>'o','ö'=>'o','õ'=>'o','ú'=>'u','ù'=>'u','û'=>'u','ü'=>'u','ý'=>'y','ÿ'=>'y');
	$value = str_replace(array_keys($arr_matches), $arr_matches, strtolower($value));
	$values_max_length = $structure_permissible_values_custom_controls[$control_name]['values_max_length'];
	if(strlen($value) > $values_max_length) {
		$import_summary['Custom List']['WARNING']["Value(s) for '$control_name' custom list is too long (> $values_max_length characters)!"][] = $value;
		$value = substr($value, 0, $values_max_length);
	}
	$structure_permissible_values_custom_controls[$control_name]['new_values'][$value] = $fr_value;
	return $value;
}

function loadCustomLists() {
	global $structure_permissible_values_custom_controls;
	foreach($structure_permissible_values_custom_controls as $new_custom_list) {
		$control_id = $new_custom_list['id'];
		customQuery("DELETE FROM structure_permissible_values_customs WHERE control_id = $control_id;", __LINE__);
		customQuery("DELETE FROM structure_permissible_values_customs_revs WHERE control_id = $control_id;", __LINE__);		
		foreach($new_custom_list['new_values'] as $new_value => $fr_value) {
			customInsert(array('value' => $new_value, 'fr' => $fr_value, 'control_id' => $control_id, 'use_as_input' => '1'), 'structure_permissible_values_customs', __LINE__);
		}
		customQuery("UPDATE structure_permissible_values_custom_controls SET values_counter = ".sizeof($new_custom_list['new_values']).", values_used_as_input_counter = ".sizeof($new_custom_list['new_values'])." WHERE id = $control_id;", __LINE__);
	}
}

//==============================================================================================
// Manage Data Import
//==============================================================================================

$participant_ids_check = array();
$updated_participants_counter = 0;
while($xml_patient_data = getNextPatientDataFromXml($xml)) {
	if(!empty($xml_patient_data['no_labos'])) {
		$query = "SELECT DISTINCT mi.participant_id FROM misc_identifier_controls mic INNER JOIN misc_identifiers mi
				WHERE mi.misc_identifier_control_id = mic.id AND mic.misc_identifier_name LIKE '%bank no lab' AND mic.flag_active = 1
				AND mi.identifier_value IN ('".implode("','",$xml_patient_data['no_labos'])."');";
		$query_res = customQuery($query, __LINE__);
		if($query_res->num_rows != 1) {
			$import_summary['Diagnosis']['ERROR']["SARDO patient(s) linked to more than one ATiM patients"][] = "See NoLabos : ".implode(', ',$xml_patient_data['no_labos']);
		} else {
			$res = mysqli_fetch_assoc($query_res);
			$pariticpant_id = $res['participant_id'];	
			if(isset($participant_ids_check[$pariticpant_id])) {
				$import_summary['Diagnosis']['ERROR']["ATiM patient(s) linked to more than one SARDO patients"][] = "See NoLabos: ".implode(', ',$xml_patient_data['no_labos']);
			} else {
				if(updatePatientData($pariticpant_id, $xml_patient_data['xml'], $xml_patient_data['last_visit_date'], $xml_patient_data['censure'], implode("','",$xml_patient_data['no_labos']))) {
					importDiagnosisData($pariticpant_id, $xml_patient_data['diagnosis'], implode("','",$xml_patient_data['no_labos']));
					$updated_participants_counter++;
				}
				$participant_ids_check[$pariticpant_id] = '-';
			}
		}
	}
}

finalizePatientUpdate($db_schema);
finalizeDiagnosisCreation();
loadCustomLists();


//TODO manage commit rollback
echo "Import Summary : <br>";

$import_summary['Process']['Message']["Updated participants counter"][] = $updated_participants_counter;

pr($import_summary);
echo "done";

//==============================================================================================
// *** Patient ***
//==============================================================================================

function updatePatientData($participant_id, $patient_xml_data, $last_visit_dates, $censure, $no_labos) {
	global $import_summary;
	global $misc_identifier_controls;
	global $import_date;
	global $import_by;
	
	$misc_identifier_controls_rev = array_flip($misc_identifier_controls);

	// Get ATiM patient data
	
	$query_res = customQuery("SELECT first_name, last_name, date_of_birth, date_of_birth_accuracy, sex, vital_status, date_of_death, date_of_death_accuracy, qc_nd_last_contact, qc_nd_last_contact_accuracy, reproductive_histories.id AS reproductive_history_id, lnmp_date, lnmp_date_accuracy, menopause_status
			FROM participants
			LEFT JOIN reproductive_histories ON reproductive_histories.participant_id = participants.id AND reproductive_histories.deleted <> 1
			WHERE participants.id = $participant_id AND participants.deleted <> 1;", __LINE__);
	if(!$query_res->num_rows) importDie("ERR_PAT00001 : Patient does not exist (participant id = $participant_id)!");
	$atim_patient_data =  mysqli_fetch_assoc($query_res);
	$atim_patient_data_to_update = array(
		'qc_nd_sardo_rec_number' => getValueFromXml($patient_xml_data, 'RecNumber'), 
		'qc_nd_sardo_last_import' => $import_date,
		'modified' => $import_date,
		'modified_by' => $import_by);
	
	$atim_patient_identifiers = array();
	$query = "SELECT misc_identifier_control_id, identifier_value FROM misc_identifiers WHERE deleted <> 1 AND participant_id = $participant_id AND misc_identifier_control_id IN (".implode(',',array_keys($misc_identifier_controls)).");";
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) $atim_patient_identifiers[$misc_identifier_controls[$res['misc_identifier_control_id']]] = $res['identifier_value'];
	$atim_patient_identifiers_to_create = array();
	
	//Get Sardo patient data and validate selected patient based on RAMQ, etc
	
	$is_patient_identifier_validated = false;	// One match will validate patient
	
	//   --> RAMQ 
	$sardo_ramq = getValueFromXml($patient_xml_data, 'RAMQ');
	if($sardo_ramq) {
		if(isset($atim_patient_identifiers['ramq nbr'])) {
			if($atim_patient_identifiers['ramq nbr'] != $sardo_ramq) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_ramq'] = 'y';
			} else {
				$is_patient_identifier_validated = true;
			}
		} else {
			$atim_patient_identifiers_to_create[] = array('participant_id' => $participant_id, 'misc_identifier_control_id' => $misc_identifier_controls_rev['ramq nbr'], 'identifier_value' => $sardo_ramq);
		}	
	}
	
	//   --> Hospital number
	$hospital_nbr = getValueFromXml($patient_xml_data, 'NoDossier');
	if($hospital_nbr) {
		if(preg_match('/^([HSN])[0-9]+/', $hospital_nbr, $matches)) {
			$misc_identifier_control_name = str_replace(array('H', 'S', 'N'), array('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr'), $matches[1]);
			if(isset($atim_patient_identifiers[$misc_identifier_control_name])) {
				if($atim_patient_identifiers[$misc_identifier_control_name] != $hospital_nbr) {
					$atim_patient_data_to_update['qc_nd_sardo_diff_hospital_nbr'] = 'y';
				} else {
					$is_patient_identifier_validated = true;
				}
			} else {
				$atim_patient_identifiers_to_create[] = array('participant_id' => $participant_id, 'misc_identifier_control_id' => $misc_identifier_controls_rev[$misc_identifier_control_name], 'identifier_value' => $hospital_nbr);
			}
		} else {
			$import_summary['Patient']['WARNING']["Wrong SARDO hopsital number format"][] = "See [$hospital_nbr] for patient with NoLabo(s) : $no_labos";
		}		
	}
	
	//   --> first name
	$is_first_name_validated = false;
	$sardo_first_name = getValueFromXml($patient_xml_data, 'Prenom');
	if($sardo_first_name) {
		if(empty($atim_patient_data['first_name'])) {
			$atim_patient_data_to_update['first_name'] = $sardo_first_name;
		} else if(strtolower($sardo_first_name) != strtolower($atim_patient_data['first_name'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_first_name'] = 'y';
		} else {
			$is_first_name_validated = true;
		}
	} else if(!empty($atim_patient_data['first_name'])) {
		$atim_patient_data_to_update['qc_nd_sardo_diff_first_name'] = 'y';
	}
	
	//   --> last name
	$is_last_name_validated = false;
	$sardo_last_name = getValueFromXml($patient_xml_data, 'Nom');
	if($sardo_last_name) {
		if(empty($atim_patient_data['last_name'])) {
			$atim_patient_data_to_update['last_name'] = $sardo_last_name;
		} else if(strtolower($sardo_last_name) != strtolower($atim_patient_data['last_name'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_last_name'] = 'y';
		} else {
			$is_last_name_validated = true;
		}
	} else if(!empty($atim_patient_data['last_name'])) {
		$atim_patient_data_to_update['qc_nd_sardo_diff_last_name'] = 'y';
	}
		
	if(($is_last_name_validated && $is_first_name_validated) || $is_patient_identifier_validated ) {
		//Patient has been validated : update can go ahead
		
		//   --> sex
		$sardo_sex = '';
		switch(getValueFromXml($patient_xml_data, 'Sexe')) {
			case '';
				break;
			case 'F':
				$sardo_sex = 'f';
				break;
			case 'M':
				$sardo_sex = 'm';
				break;
			default;
				$sardo_sex = 'other';
				break;
		}
		if($sardo_sex) {
			if(empty($atim_patient_data['sex'])) {
				$atim_patient_data_to_update['sex'] = $sardo_sex;
			} else if($sardo_sex != $atim_patient_data['sex']) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_sex'] = 'y';
			}
		} else if(!empty($atim_patient_data['sex'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_sex'] = 'y';
		}
		
		//   --> date of birth
		list($sardo_date_of_birth, $sardo_date_of_birth_accuracy) = getDateFromXml($patient_xml_data, 'DateNaissance', 'Patient', $no_labos);
		if($sardo_date_of_birth) {
			if(empty($atim_patient_data['date_of_birth'])) {
				$atim_patient_data_to_update['date_of_birth'] = $sardo_date_of_birth;
				$atim_patient_data_to_update['date_of_birth_accuracy'] = $sardo_date_of_birth_accuracy;
			} else if($sardo_date_of_birth != $atim_patient_data['date_of_birth'] || $sardo_date_of_birth_accuracy != $atim_patient_data['date_of_birth_accuracy']) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_date_of_birth'] = 'y';
			}
		} else if(!empty($atim_patient_data['date_of_birth'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_date_of_birth'] = 'y';
		}
		
		//   --> death	
		$atim_patient_data_to_update['qc_nd_sardo_cause_of_death'] = addValuesToCustomList("SARDO : Cause of death", getValueFromXml($patient_xml_data, 'CauseDeces'));
		list($sardo_date_of_death, $sardo_date_of_death_accuracy) = getDateFromXml($patient_xml_data, 'DateDeces', 'Patient', $no_labos);
		$sardo_vital_status = ($censure != '1' && (strlen(str_replace(' ', '', $atim_patient_data_to_update['qc_nd_sardo_cause_of_death'])) == 0) && $sardo_date_of_death == '')? '' : 'deceased';
		if($sardo_vital_status) {
			if(empty($atim_patient_data['vital_status'])) {
				$atim_patient_data_to_update['vital_status'] = $sardo_vital_status;
			} else if($sardo_vital_status != $atim_patient_data['vital_status']) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_vital_status'] = 'y';
			}
		} else if(!empty($atim_patient_data['vital_status'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_vital_status'] = 'y';
		}
		if($sardo_date_of_death) {
			if(empty($atim_patient_data['date_of_death'])) {
				$atim_patient_data_to_update['date_of_death'] = $sardo_date_of_death;
				$atim_patient_data_to_update['date_of_death_accuracy'] = $sardo_date_of_death_accuracy;
			} else if($sardo_date_of_death != $atim_patient_data['date_of_death'] || $sardo_date_of_death_accuracy == $atim_patient_data['date_of_death_accuracy']) {
				$atim_patient_data_to_update['qc_nd_sardo_diff_date_of_death'] = 'y';
			}
		} else if(!empty($atim_patient_data['date_of_death'])) {
			$atim_patient_data_to_update['qc_nd_sardo_diff_date_of_death'] = 'y';
		}
		
		//   --> last Contact
		if(sizeof($last_visit_dates)) {
			if(sizeof($last_visit_dates) > 1) $import_summary['Diagnosis']['WARNING']["2 different SARDO last visit dates"][] = "See patient with NoLabo(s) : $no_labos";
			list($sardo_last_visit_date, $sardo_last_visit_date_accuracy) = array_values(array_shift($last_visit_dates));
			if(empty($atim_patient_data['qc_nd_last_contact']) || $atim_patient_data['qc_nd_last_contact'] < $sardo_last_visit_date) {
				$atim_patient_data_to_update['qc_nd_last_contact'] = $sardo_last_visit_date;
				$atim_patient_data_to_update['qc_nd_last_contact_accuracy'] = $sardo_last_visit_date_accuracy;
			}
		}
		
		//   --> Reporductive History
		$sardo_lnmp = str_replace('9999', '', getValueFromXml($patient_xml_data, 'AnneeMenopause'));
		if($sardo_lnmp) {
			if(!$atim_patient_data['reproductive_history_id']) {
				//Create a new reproductive history
				customInsert(array('participant_id' => $participant_id, 'lnmp_date' => $sardo_lnmp.'-01-01', 'lnmp_date_accuracy' => 'm', 'menopause_status' => 'post'), 'reproductive_histories', __LINE__);
				//$atim_patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'n';
			} else {
				$atim_reporductive_history_data_to_update = array();
				//   -> (menopause_status)
				if(empty($atim_patient_data['menopause_status'])) {
					$atim_reporductive_history_data_to_update['menopause_status'] = 'post';
				} else if($atim_patient_data['menopause_status'] != 'post') {
					$atim_patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'y';
				}
				//   -> (menopause date)
				if(empty($atim_patient_data['lnmp_date'])) {
					$atim_reporductive_history_data_to_update['lnmp_date'] = $sardo_lnmp.'-01-01';
					$atim_reporductive_history_data_to_update['lnmp_date_accuracy'] = 'm';
				} else if($atim_patient_data['lnmp_date'] != substr($atim_patient_data['lnmp_date'], 0, 4)) {
					$atim_patient_data_to_update['qc_nd_sardo_diff_reproductive_history'] = 'y';
				}
				if($atim_reporductive_history_data_to_update) {
					$atim_reporductive_history_data_to_update = array_merge($atim_reporductive_history_data_to_update, array('modified' => $import_date, 'modified_by' => $import_by));
					//Update Reproductive History
					$query = "UPDATE reproductive_histories SET ";
					$coma = '';
					foreach($atim_reporductive_history_data_to_update as $field => $value ) {
						if(strlen($value)) $query .= $coma." $field = '".str_replace("'", "''", $value)."'";
						$coma = ', ';
					}
					$query .= " WHERE id = ".$atim_patient_data['reproductive_history_id'].";";
					customQuery($query, __LINE__);
				}
			}
		}	
		
		// Update participant data
		$query = "UPDATE participants SET ";
		$coma = '';
		foreach($atim_patient_data_to_update as $field => $value ) {
			if(strlen($value)) $query .= $coma." $field = '".str_replace("'", "''", $value)."'";
			$coma = ', ';
		}
		$query .= " WHERE id = $participant_id;";
		customQuery($query, __LINE__);
		
		return true;

	} else {
		$import_summary['Patient']['WARNING']["Patient selection can not be validated based on identifiers (RAMQ, hospital Nbr) or names"][] = "See patient with NoLabo(s) : $no_labos";
		return false;
	}
}

function finalizePatientUpdate($db_schema) {
	global $import_date;
	global $import_by;
		
	// Revs table update
	foreach(array('participants', 'reproductive_histories') as $tablename) {
		$query = "SELECT COLUMN_NAME 
			FROM information_schema.COLUMNS
			WHERE TABLE_SCHEMA='$db_schema' AND COLUMN_NAME NOT IN('created','created_by','modified','modified_by','deleted') AND TABLE_NAME LIKE '$tablename'";
		$query_res = customQuery($query, __LINE__);
		$table_fields = array();
		while($res =  mysqli_fetch_assoc($query_res)) $table_fields[] = $res['COLUMN_NAME'];
		$table_fields = implode(',',$table_fields);
		customQuery("INSERT INTO ".$tablename."_revs ($table_fields, modified_by, version_created) (SELECT $table_fields, modified_by, modified FROM $tablename WHERE modified_by = $import_by AND modified = '$import_date');", __LINE__);
	}
	
	// Tracks patients matching SARDO patient in th epast but matching no sardo patient anymore
	$query = "SELECT id, qc_nd_sardo_rec_number FROM participants WHERE deleted <> 1 AND (qc_nd_sardo_rec_number IS NOT NULL AND qc_nd_sardo_rec_number NOT LIKE '') AND qc_nd_sardo_last_import != '".substr($import_date, 0, 10)."';";
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) {
		$import_summary['Patient']['WARNING']['SARDO patient (previously synchronized) and not synchronized anymore'][] = "See patient RecNumber (of ATiM Profile form) ".$res['qc_nd_sardo_rec_number'];
	}
	
	// Check identifiers
	$query = "
		SELECT * FROM (
			SELECT count(*) as nbr, mic.misc_identifier_name, mi.identifier_value
			FROM misc_identifiers mi INNER JOIN misc_identifier_controls mic ON mic.id = mi.misc_identifier_control_id
			WHERE mi.deleted <> 1 AND mic.misc_identifier_name IN ('hotel-dieu id nbr', 'saint-luc id nbr', 'notre-dame id nbr', 'ramq nbr')
			GROUP BY mic.misc_identifier_name, mi.identifier_value
		) res WHERE res.nbr > 1;";
	$query_res = customQuery($query, __LINE__);
	while($res =  mysqli_fetch_assoc($query_res)) {
		$import_summary['Patient']['ERROR']['Duplicated RAMQ or Hopsital Number'][] = "See ".$res['misc_identifier_name']." ".$res['identifier_value'];
	}
}

//==============================================================================================
// *** Diagnosis ***
//==============================================================================================
	
function importDiagnosisData($pariticpant_id, $all_diagnosis_xml_data, $no_labos) {	
	global $diagnosis_controls;
	
	foreach($all_diagnosis_xml_data as $diagnosis_xml_data) {
		$patient_rec_number = getValueFromXml($diagnosis_xml_data['xml'], 'ParentRecNumber');
		
		//Create diagnosis data set
		$atim_diagnosis_data_to_create = array('DiagnosisMaster' => array('diagnosis_control_id' => $diagnosis_controls['id'], 'participant_id' => $pariticpant_id, 'qc_nd_sardo_id' => getValueFromXml($diagnosis_xml_data['xml'], 'RecNumber')), 'DiagnosisDetail' => array());
		list($atim_diagnosis_data_to_create['DiagnosisMaster']['dx_date'], $atim_diagnosis_data_to_create['DiagnosisMaster']['dx_date_accuracy'])  = getDateFromXml($diagnosis_xml_data['xml'], 'DateDiagnostic', 'Diagnosis', $no_labos);
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
				$atim_diagnosis_data_to_create[$model][$atim_field] = getValueFromXml($diagnosis_xml_data['xml'], $xml_field);
				if($custom_list_control_name) {
					$atim_diagnosis_data_to_create[$model][$atim_field] = addValuesToCustomList($custom_list_control_name, $atim_diagnosis_data_to_create[$model][$atim_field]);		
				}
			}
		}
		
		//Record diagnosis
		$diagnosis_master_id = customInsert($atim_diagnosis_data_to_create['DiagnosisMaster'], 'diagnosis_masters', __LINE__);
		$atim_diagnosis_data_to_create['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
		customInsert($atim_diagnosis_data_to_create['DiagnosisDetail'], $diagnosis_controls['detail_tablename'], __LINE__, true);
		
		//Load Treatment
		importTreatmentData($patient_rec_number, $pariticpant_id, $diagnosis_master_id, $diagnosis_xml_data['treatments'], $no_labos);
		
		//Load Labos
		importLaboData($patient_rec_number, $pariticpant_id, $diagnosis_master_id, $diagnosis_xml_data['labos'], $no_labos);
	}
}

function finalizeDiagnosisCreation() {
	global $diagnosis_controls;
	
	customQuery("UPDATE diagnosis_masters SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
	customQuery("UPDATE diagnosis_masters_revs SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
}

//==============================================================================================
// *** Treatment ***
//==============================================================================================

function importTreatmentData($patient_rec_number, $pariticpant_id, $diagnosis_master_id, $all_treatment_xml_data, $no_labos) {
	global $treatment_controls;
	
	$atim_treatments_data_to_create = array();
	foreach($all_treatment_xml_data as $treatment_and_reports_xml_data) {
		//Set treatment data
		$treatment_xml_data = $treatment_and_reports_xml_data['xml'];
		$trt_type = getValueFromXml($treatment_xml_data, 'TypeTX');
		$tx_method = 'sardo treatment - '.strtolower($trt_type);
		$start_date = null;
		$start_date_accuracy = null;
		if(!isset($treatment_controls[$tx_method])) {
			$import_summary['Treatment']['ERROR']["SARDO treatment [".$tx_method."] is unknow"][] = "See patient with NoLabo(s) : $no_labos";
		} else {
			//Create treatment data set
			list($start_date, $start_date_accuracy)  = getDateFromXml($treatment_xml_data, 'DateDebutTraitement', 'Traitement', $no_labos);
			list($finish_date, $finish_date_accuracy)  = getDateFromXml($treatment_xml_data, 'DateFinTraitement', 'Traitement', $no_labos);
			$NoPatho = getValueFromXml($treatment_xml_data, 'NoPatho');
			$results = addValuesToCustomList("SARDO : $trt_type Results", getValueFromXml($treatment_xml_data, 'Resultat_Alpha'));
			$objectifs = addValuesToCustomList("SARDO : $trt_type Objectifs", getValueFromXml($treatment_xml_data, 'ObjectifTX'));
			//Build the treatment key
			$treatment_key = md5($trt_type.$start_date.$finish_date.$NoPatho.$results.$objectifs);
			if(!isset($atim_treatments_data_to_create[$treatment_key])) {
				$atim_treatments_data_to_create[$treatment_key] = array(
					'TreatmentMaster' => array(
						'treatment_control_id' => $treatment_controls[$tx_method]['treatment_control_id'],
						'participant_id' => $pariticpant_id,
						'diagnosis_master_id' => $diagnosis_master_id,
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
			$treatment_extend_data = addValuesToCustomList("SARDO : $trt_type Treatments", getValueFromXml($treatment_xml_data, 'Traitement'));
			if(strlen($treatment_extend_data)) {		
				$atim_treatments_data_to_create[$treatment_key]['TreatmentExtends'][] = array(
					'TreatmentExtendMaster' => array('treatment_extend_control_id' => $treatment_controls[$tx_method]['treatment_extend_control_id']),
					'TreatmentExtendDetail' => array('treatment' => $treatment_extend_data));
			}
		}
		//Launch report creation
		if($treatment_and_reports_xml_data['reports']) {
			importReportData($patient_rec_number, $pariticpant_id, $diagnosis_master_id, $treatment_and_reports_xml_data['reports'], $start_date, $start_date_accuracy);
		}
	}

	//Record treatment
	foreach($atim_treatments_data_to_create as $new_treatment_to_create) {
		$treatment_master_id = customInsert($new_treatment_to_create['TreatmentMaster'], 'treatment_masters', __LINE__);
		$new_treatment_to_create['TreatmentDetail']['treatment_master_id'] = $treatment_master_id;
		customInsert($new_treatment_to_create['TreatmentDetail'], 'qc_nd_txd_sardos', __LINE__, true);
		foreach($new_treatment_to_create['TreatmentExtends'] as $new_extend) {
			$new_extend['TreatmentExtendMaster']['treatment_master_id'] = $treatment_master_id;
			$treatment_extend_master_id = customInsert($new_extend['TreatmentExtendMaster'], 'treatment_extend_masters', __LINE__);
			$new_extend['TreatmentExtendDetail']['treatment_extend_master_id'] = $treatment_extend_master_id;
			customInsert($new_extend['TreatmentExtendDetail'], 'qc_nd_txe_sardos', __LINE__, true);
		}
	}	
}

//==============================================================================================
// *** Report ***
//==============================================================================================

function importReportData($patient_rec_number, $pariticpant_id, $diagnosis_master_id, $all_reports_xml_data, $event_date, $event_date_accuracy) {
	global $rapport_event_controls;

	foreach($all_reports_xml_data as $report_xml_data) {
		$report_xml_data = $report_xml_data['xml'];
		$control = array();
		$fish = false;
		switch(getValueFromXml($report_xml_data, 'ElementRapport')) {
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
			$atim_event_data_to_create= array(
					'EventMaster' => array(
							'event_control_id' => $control['id'],
							'participant_id' => $pariticpant_id,
							'diagnosis_master_id' => $diagnosis_master_id,
							'event_date' => $event_date,
							'event_date_accuracy' => $event_date_accuracy),
					'EventDetail' => array());
			if(in_array($control['detail_tablename'], array('qc_nd_ed_estrogen_receptor_reports', 'qc_nd_ed_progestin_receptor_reports'))) {
				$results = getValueFromXml($report_xml_data, 'Resultat');
				$atim_event_data_to_create['EventMaster']['event_summary'] = $results;
				if(preg_match('/((,\ ){0,1}(\++))$/', $results, $matches)) {
					$atim_event_data_to_create['EventDetail']['intensity'] = addValuesToCustomList('SARDO : Estrogen/Progestin Receptor Intensities', $matches[3]);
					$results = str_replace($matches[1], '', $results);
				}
				if(preg_match('/((,\ ){0,1}(([0-9]+)([\.,][0-9]+){0,1})\ %)$/', $results, $matches)) {
					$atim_event_data_to_create['EventDetail']['percentage'] = str_Replace(',', '.', $matches[3]);
					$results = str_replace($matches[1], '', $results);
				}
				$atim_event_data_to_create['EventDetail']['result'] = addValuesToCustomList('SARDO : Estrogen/Progestin Receptor Results', $results);
			} else if($control['detail_tablename'] == 'qc_nd_ed_her2_neu') {
				$results = getValueFromXml($report_xml_data, 'Resultat');
				$atim_event_data_to_create['EventMaster']['event_summary'] = $results;
				if(preg_match('/((,\ ){0,1}(\++))$/', $results, $matches)) {
					$atim_event_data_to_create['EventDetail']['intensity'] = addValuesToCustomList('SARDO : HER2/NEU Intensities', $matches[3]);
					$results = str_replace($matches[1], '', $results);
				}
				$atim_event_data_to_create['EventDetail']['result'] = addValuesToCustomList('SARDO : HER2/NEU Results', $results);
				$atim_event_data_to_create['EventDetail']['fish'] = $fish? 'y' : 'n';
			} else {
				importDie("ERR_LAB00003 : Unsupported detail tablename [".$control['detail_tablename']."]!");
			}
			$event_master_id = customInsert($atim_event_data_to_create['EventMaster'], 'event_masters', __LINE__, false);
			$atim_event_data_to_create['EventDetail']['event_master_id'] = $event_master_id;
			customInsert($atim_event_data_to_create['EventDetail'], $control['detail_tablename'], __LINE__, true);
		}
	}
}

//==============================================================================================
// *** APS & CA-125 (once) ***
//==============================================================================================

function importLaboData($patient_rec_number, $pariticpant_id, $diagnosis_master_id, $all_labos_xml_data, $no_labos) {
	global $is_initial_import;
	global $ca125_psa_event_controls;
	
	if(!$is_initial_import) return;

	foreach($all_labos_xml_data as $labo_xml_data) {
		$labo_xml_data = $labo_xml_data['xml'];
		$diagnosis_rec_number = getValueFromXml($labo_xml_data, 'ParentRecNumber');
		$test = getValueFromXml($labo_xml_data, 'NomLabo');
		if(in_array($test, array('APS pré-op', 'APS', 'CA-125'))) {
			$atim_event_data_to_create= array(
				'EventMaster' => array(
					'event_control_id' => $ca125_psa_event_controls[(($test == 'CA-125')? 'ca125' : 'psa')]['id'], 
					'participant_id' => $pariticpant_id), 
				'EventDetail' => array(
					'value' => getValueFromXml($labo_xml_data, 'Resultat')));
			if($atim_event_data_to_create['EventDetail']['value'] == '-99') $atim_event_data_to_create['EventDetail']['value'] = '';
			list($atim_event_data_to_create['EventMaster']['event_date'], $atim_event_data_to_create['EventMaster']['event_date_accuracy'])  = getDateFromXml($labo_xml_data, 'Date', 'Labo', $no_labos);
			
			$event_master_id = customInsert($atim_event_data_to_create['EventMaster'], 'event_masters', __LINE__, false, true);
			$atim_event_data_to_create['EventDetail']['event_master_id'] = $event_master_id;
			customInsert($atim_event_data_to_create['EventDetail'],  $ca125_psa_event_controls[(($test == 'CA-125')? 'ca125' : 'psa')]['detail_tablename'], __LINE__, true, true);				
		}
	}
}

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