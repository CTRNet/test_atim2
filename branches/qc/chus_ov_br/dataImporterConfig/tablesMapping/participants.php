<?php
$pkey = "PatienteNbr";

$child = array(
	'ChusMiscIdentfier',
	'BreastBankMiscIdentfier',
	'OvaryBankMiscIdentfier',

);

$fields = array(	
	"participant_identifier" => $pkey, 
	"first_name" => utf8_encode("Prenom"),
	"last_name" => utf8_encode("Nom"));

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'participants', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postParticipantRead';
$model->post_write_function = 'postParticipantWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	
	// Check no CHUS not assigned to 2 different patients
	
	if(isset(Config::$patient_profile_data_for_checks['no_chus'][$m->values['No Dossier CHUS']]) 
	&& (Config::$patient_profile_data_for_checks['no_chus'][$m->values['No Dossier CHUS']] != $m->values['PatienteNbr'])) {
		// 2 patients have the same chus number but identification data are differents: Warning
		Config::$summary_msg['@@ERROR@@']['No Dossier CHUS #1'][] = "A same 'No Dossier CHUS' [".$m->values['No Dossier CHUS']."] is assigned to 2 different 'PatienteNbr' [".Config::$patient_profile_data_for_checks['no_chus'][$m->values['No Dossier CHUS']]."/".$m->values['PatienteNbr']."]! [line: ".$m->line.']';
	}
	Config::$patient_profile_data_for_checks['no_chus'][$m->values['No Dossier CHUS']] = $m->values['PatienteNbr'];
	
	// Check duplicated row content for a same patient
	
	$tmp_patient_data_to_check = array(
		'line' => $m->line,
		'no_patient' => $m->values['PatienteNbr'],
		'first_name' => $m->values['Prenom'],
		'last_name' => $m->values['Nom'],
		'no_chus' => $m->values['No Dossier CHUS']);
	if(isset(Config::$patient_profile_data_for_checks['no_patient'][$m->values['PatienteNbr']])) {
		$res = array_diff_assoc(Config::$patient_profile_data_for_checks['no_patient'][$m->values['PatienteNbr']], $tmp_patient_data_to_check);
		if((sizeof($res)-1)) {
			// 2 patients have the same chus number but identification data are differents: Warning
			if(isset($res['no_chus'])) {
				Config::$summary_msg['@@ERROR@@']['No Dossier CHUS #2'][] = "A same 'PatienteNbr'  [".$tmp_patient_data_to_check['no_patient']."] is assigned to 2 different 'No Dossier CHUS' [".Config::$patient_profile_data_for_checks['no_patient'][$m->values['PatienteNbr']]['no_chus']."/".$tmp_patient_data_to_check['no_chus']."]! [line: ".$m->line.']';
			} else {
				$string_diff = '';
				foreach($res as $key => $val) $string_diff .= "$key: ".Config::$patient_profile_data_for_checks['no_patient'][$m->values['PatienteNbr']][$key]." <=> ".$tmp_patient_data_to_check[$key]." // ";
				Config::$summary_msg['@@WARNING@@']['No Dossier CHUS #2'][] = "A same 'PatienteNbr'  [".$tmp_patient_data_to_check['no_patient']."] don't have the same first/last [$string_diff]! [line: ".$m->line.']';
			}
		}
		// Return fals, patient has already be created
		return false;	
	}
	Config::$patient_profile_data_for_checks['no_patient'][$m->values['PatienteNbr']] = $tmp_patient_data_to_check;
	
	return true;
}

function postParticipantWrite(Model $m) {
	Config::$participant_ids_from['Patient#'][$m->values['PatienteNbr']] = $m->last_id;
}