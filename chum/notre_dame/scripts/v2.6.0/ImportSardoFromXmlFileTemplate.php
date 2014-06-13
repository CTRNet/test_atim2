<?php

$import_summary = array();

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
$query_res = customQuery("SELECT NOW() AS import_date, id FROM users WHERE username = 'SardoMigration';", __LINE__);
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


// Treatment

$treatment_controls = array();
$query_res = customQuery("SELECT id, detail_tablename, tx_method, treatment_extend_control_id FROM treatment_controls WHERE flag_active = 1;", __LINE__);
while($res =  mysqli_fetch_assoc($query_res)) {
	$treatment_controls[$res['tx_method']] = $res;
	//TODO verifier que les tables sont bien les tables sardo dans les controls
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

//TODO other table delete

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
	}
	
 //TODO: Mettre a jour le counter
}

//==============================================================================================
//Load diagnosis
//==============================================================================================

global $patient_recNbr_to_participant_id;
global $dx_recNbr_to_ids;
$patient_recNbr_to_participant_id = array();
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
}
recordPatientDiagnosis($patient_diagnosis);	//The last patient
customQuery("UPDATE diagnosis_masters SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);
customQuery("UPDATE diagnosis_masters_revs SET primary_id = id WHERE diagnosis_control_id = ".$diagnosis_controls['id'].";", __LINE__);

function recordPatientDiagnosis($patient_diagnosis) {
	global $diagnosis_controls;
	global $patient_recNbr_to_participant_id;
	global $dx_recNbr_to_ids;

	if(!empty($patient_diagnosis)) {
		if(!empty($patient_diagnosis['NoLabos'])) {
			$query = "SELECT DISTINCT mi.participant_id FROM misc_identifier_controls mic INNER JOIN misc_identifiers mi 
				WHERE mi.misc_identifier_control_id = mic.id AND mic.misc_identifier_name LIKE '%bank no lab' AND mic.flag_active = 1
				AND mi.identifier_value IN ('".implode("','",$patient_diagnosis['NoLabos'])."');";
			$query_res = customQuery($query, __LINE__);
			if($query_res->num_rows != 1) {
				$import_summary['Diagnosis']['ERROR']["SARDO patient(s) linked to more than one ATiM patients"][] = "RecNumber ".$patient_diagnosis['PatientRecNumber']." (NoLabos: ".implode(', ',$patient_diagnosis['NoLabos']).")";
			} else {
				$res = mysqli_fetch_assoc($query_res);
				$pariticpant_id = $res['participant_id'];
				if(isset($patient_recNbr_to_participant_id[$patient_diagnosis['PatientRecNumber']])) {
					$import_summary['Diagnosis']['ERROR']["ATiM patient(s) linked to more than one SARDO patients"][] = "NoLabos: ".implode(', ',$patient_diagnosis['NoLabos']);
				}
				$patient_recNbr_to_participant_id[$patient_diagnosis['PatientRecNumber']] = $pariticpant_id;
				foreach($patient_diagnosis['Diagnosis'] as $diagnosis_rec_number => $new_diagnosis) {
					$new_diagnosis['DiagnosisMaster'] = array_merge($new_diagnosis['DiagnosisMaster'], array('diagnosis_control_id' => $diagnosis_controls['id'], 'participant_id' => $pariticpant_id, 'qc_nd_sardo_id' => $diagnosis_rec_number));
					$diagnosis_master_id = customInsert($new_diagnosis['DiagnosisMaster'], 'diagnosis_masters', __LINE__);
					$new_diagnosis['DiagnosisDetail']['diagnosis_master_id'] = $diagnosis_master_id;
					customInsert($new_diagnosis['DiagnosisDetail'], $diagnosis_controls['detail_tablename'], __LINE__, true);
					$dx_recNbr_to_ids[$diagnosis_rec_number] = array('participant_id' => $pariticpant_id, 'diagnosis_master_id' => $diagnosis_master_id);
				}
			}
		} else {
			//Nothing to do: Not a Bank Patient
		}
	}
}

//==============================================================================================
//Update patient
//==============================================================================================

/*
 //TODO
<DateDerniereVisite>20130715</DateDerniereVisite>
<Censure>1</Censure>

+ record SARDO patient Rec Number and ... data import
*/

//TODO SARDO : Cause of death

//==============================================================================================
//Load Treatment
//==============================================================================================

$tx_recNbr_to_tx_dates_and_dx_recNbr = array();
$previous_treatment_key = null;
$treatment_data = array();
foreach($xml->Traitement as $new_treatment) {
	$treatment_rec_number = getValueFromXml($new_treatment, 'RecNumber');
	$diagnosis_rec_number = getValueFromXml($new_treatment, 'ParentRecNumber');
	$tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]['dxRecNbr'] = $diagnosis_rec_number;
	$trt_type = getValueFromXml($new_treatment, 'TypeTX');
	list($start_date, $start_date_accuracy)  = getDateFromXml($new_treatment, 'DateDebutTraitement');
	$tx_recNbr_to_tx_dates_and_dx_recNbr[$treatment_rec_number]['dates'] = array($start_date, $start_date_accuracy);
	if(in_array($trt_type, array('RADIO','CHIR','IMAGE','BIOP','HORM','CHIMIO','PAL','AUTRE','CYTO','PROTOC','BILAN','REVISION','IMMUNO','MEDIC','EXAM','OBS','VISITE','SYMPT','RESUME'))) {
		list($finish_date, $finish_date_accuracy)  = getDateFromXml($new_treatment, 'DateFinTraitement');
		$NoPatho = getValueFromXml($new_treatment, 'NoPatho');
		$results = addValuesToCustomList("SARDO : $trt_type Results", getValueFromXml($new_treatment, 'Resultat_Alph'));
		$objectifs = addValuesToCustomList("SARDO : $trt_type Objectifs", getValueFromXml($new_treatment, 'ObjectifTX'));
		$treatment_key = md5($diagnosis_rec_number.$trt_type.$start_date.$finish_date.$NoPatho.$results.$objectifs);
		if($previous_treatment_key && $treatment_key != $previous_treatment_key) {
			recordPatientTreatment($treatment_data);
			$treatment_data = array();
		}		
		$previous_treatment_key = $treatment_key;
		$tx_method = 'sardo treatment - '.strtolower($trt_type);
		if(!isset($treatment_controls[$tx_method])) importDie("ERR_TX00001 : Treatment <".$tx_method."> unknown!");
		if(!isset($treatments[$treatment_key])) {
			$treatment_data = array(
				'TreatmentMaster' => array(
					'treatment_control_id' => $treatment_controls[$tx_method]['id'],
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
		$treatment = addValuesToCustomList("SARDO : $trt_type Treatments", getValueFromXml($new_treatment, 'Traitement'));
		if(strlen($treatment)) {
			$treatment_data['TreatmentExtends'][] = array(
				'TreatmentExtendMaster' => array('treatment_extend_control_id' => $treatment_controls[$tx_method]['treatment_extend_control_id']),
				'TreatmentExtendDetail' => array('treatment' => $treatment));
		}
	}
}
recordPatientTreatment($treatment_data);

function recordPatientTreatment($treatment_data) {
	if(!empty($treatment_data)) {
		$treatment_master_id = customInsert($treatment_data['TreatmentMaster'], 'treatment_masters', __LINE__);
		$treatment_data['TreatmentDetail']['treatment_master_id'] = $treatment_master_id;
		customInsert($treatment_data['TreatmentDetail'], 'qc_nd_txd_sardos', __LINE__, true);
pr($treatment_data);		
		foreach($treatment_data['TreatmentExtends'] as $new_extend) {	
			$new_extend['TreatmentExtendMaster']['treatment_master_id'] = $treatment_master_id;
			$treatment_extend_master_id = customInsert($new_extend['TreatmentExtendMaster'], 'treatment_extend_masters', __LINE__);
			$new_extend['TreatmentExtendDetail']['treatment_extend_master_id'] = $treatment_extend_master_id;
			customInsert($new_extend['TreatmentExtendDetail'], 'qc_nd_txe_sardos', __LINE__, true);
pr($new_extend);		
		}
	}
}

//==============================================================================================
//LOAD APS & CA-125 (once)
//==============================================================================================
//TODO set to false after first import

if(true) {
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
				importDie("ERR_LAB00003 : Unsupported detail tablename <".$control['detail_tablename'].">!");
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
	global $db_icm_connection;
	$query_res = mysqli_query($db_icm_connection, $query) or importDie("QUERY ERROR line $line [".mysqli_error($db_icm_connection)."] : $query");
	return ($insert)? mysqli_insert_id($db_icm_connection) : $query_res;
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