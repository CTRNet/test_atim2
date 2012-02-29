<?php
$pkey = "PatienteNbr";

$child = array(
	'ChusMiscIdentfier',
	'BankMiscIdentfier',

);

$fields = array(	
	"participant_identifier" => $pkey, 
	"first_name" => utf8_encode("Prenom"),
	"last_name" => utf8_encode("Nom"));

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'participants', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postParticipantRead';

$model->custom_data = array();

//adding this model to the config
Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	if(!preg_match('/^([0-9]+)(\.[0-9]+){0,1}$/', $m->values['PatienteNbr'], $matches)) die('ERR 9983933');
	
	// Check no CHUS not assigned to 2 different patients
	
	if(isset(Config::$pateint_nbr_from_chus_nbr[$m->values['No Dossier CHUS']]) 
	&& (Config::$pateint_nbr_from_chus_nbr[$m->values['No Dossier CHUS']] != $m->values['PatienteNbr'])) {
		// 2 patients have the same chus number but identification data are differents: Warning
		Config::$summary_msg['@@ERROR@@']['No Dossier CHUS #1'][] = "A same 'No Dossier CHUS' [".$m->values['No Dossier CHUS']."] is assigned to 2 different 'PatienteNbr' [".Config::$pateint_nbr_from_chus_nbr[$m->values['No Dossier CHUS']]."/".$m->values['PatienteNbr']."]! [line: ".$m->line.']';
	}
	Config::$pateint_nbr_from_chus_nbr[$m->values['No Dossier CHUS']] = $m->values['PatienteNbr'];
	
	// Check duplicated row content for a same patient
	
	$patient_profile_data = array(
		'line' => $m->line,
		'no_patient' => $m->values['PatienteNbr'],
		'first_name' => $m->values['Prenom'],
		'last_name' => $m->values['Nom'],
		'no_chus' => $m->values['No Dossier CHUS']);
	if(isset(Config::$patient_profile_data_from_patient_nbr[$m->values['PatienteNbr']])) {
		$res = array_diff_assoc(Config::$patient_profile_data_from_patient_nbr[$m->values['PatienteNbr']], $patient_profile_data);
		if((sizeof($res)-1)) {
			$lines = 'Lines :'.Config::$patient_profile_data_from_patient_nbr[$m->values['PatienteNbr']]['line'].' & '.$m->line;
			unset($res['line']);
			if(isset($res['no_chus'])) {
				Config::$summary_msg['@@ERROR@@']['No Dossier CHUS #2'][] = "A same 'PatienteNbr'  [".$patient_profile_data['no_patient']."] is assigned to 2 different 'No Dossier CHUS' [".Config::$patient_profile_data_from_patient_nbr[$m->values['PatienteNbr']]['no_chus']."/".$patient_profile_data['no_chus']."]! [$lines]";
				unset($res['no_chus']);
			} 
			if((sizeof($res)-1)) {
				$string_diff = '';
				$separator = '';
				foreach($res as $key => $val) {
					$string_diff .= $separator. "$key: ".Config::$patient_profile_data_from_patient_nbr[$m->values['PatienteNbr']][$key]." <=> ".$patient_profile_data[$key];
					$separator = " // " ;
				}
				Config::$summary_msg['@@WARNING@@']['Profile Data #1'][] = "A same 'PatienteNbr'  [".$patient_profile_data['no_patient']."] don't have the same profile data on 2 different lines [$string_diff]! [$lines]";
			}
		}
		
		// Return fals, patient has already be created
		return false;	
	}
	Config::$patient_profile_data_from_patient_nbr[$m->values['PatienteNbr']] = $patient_profile_data;
	
	return true;
}