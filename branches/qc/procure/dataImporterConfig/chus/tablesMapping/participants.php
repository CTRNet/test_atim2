<?php
$pkey = "Identification";

$child = array('Consent','Questionnaire');

$fields = array(	
	"participant_identifier" => $pkey,
	"first_name" => "#first_name",
	"last_name" => "#last_name",
	"date_of_birth" => "#date_of_birth",
	"date_of_birth_accuracy" => "#date_of_birth_accuracy",
	"procure_chus_abort" =>  "#procure_chus_abort",
	"procure_chus_aborting_date" =>  "#procure_chus_aborting_date",
	"procure_chus_aborting_date_accuracy" =>  "#procure_chus_aborting_date_accuracy",
	"vital_status" =>  "#vital_status",
	"date_of_death" =>  "#date_of_death",
	"date_of_death_accuracy" =>  "#date_of_death_accuracy",
	"procure_cause_of_death" =>  "#procure_cause_of_death");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'participants', $fields);

$model->custom_data = array();
$model->post_read_function = 'postParticipantRead';
$model->insert_condition_function = 'preParticipantWrite';
$model->post_write_function = 'postParticipantWrite';

Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	if($m->values['Visite'] != 'V01') {
		Config::$summary_msg['Visit <br>  File: '.substr(Config::$xls_file_path, (strrpos(Config::$xls_file_path,'/')+1))]['@@ERROR@@']['Wrong visite'][] = "Should be V01. No data will be imported. See line: ".$m->line;
		return false;
	}
	return true;
}

function preParticipantWrite(Model $m){
	$participant_identification = $m->values['Identification'];
	$nominal_data = array(
		'first_name' =>  '',
		'last_name' =>  '',
		'date_of_birth' =>  '',
		'date_of_birth_accuracy' =>  'c',
		'procure_chus_abort' =>  '',
		'procure_chus_aborting_date' =>  '',
		'procure_chus_aborting_date_accuracy' =>  'c',
		'vital_status' =>  '',
		'date_of_death' =>  '',
		'date_of_death_accuracy' =>  'c',
		'procure_cause_of_death' =>  '');
	if(isset(Config::$participant_nominal_data[$participant_identification])) $nominal_data = Config::$participant_nominal_data[$participant_identification]['Participant'];
	$m->values = array_merge($m->values, $nominal_data);	

	return true;
}
	
function postParticipantWrite(Model $m){
 	recordParticipantCollection($m->values['Identification'], $m->last_id);
 	recordParticipantPathReport($m->values['Identification'], $m->last_id);
 	recordParticipantDiagnosisForm($m->values['Identification'], $m->last_id);
 	recordFollowUpForm($m->values['Identification'], $m->last_id);
 	recordAdditionalNominalData($m->values['Identification'], $m->last_id);
}

function loadParticipantNominalData() {
	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path_nominal_data);
	$filename = substr(Config::$xls_file_path_nominal_data, (strrpos(Config::$xls_file_path_nominal_data,'/')+1));
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	$work_sheet_name = "Donnees Nominales";
	$summary_msg_title = 'Nominal Data';
	if(!isset($tmp_xls_reader->sheets[$sheets_nbr[$work_sheet_name]])) die('ERR Nominal Data 3222222');
	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr[$work_sheet_name]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Code Patient'];
			if(isset(Config::$participant_nominal_data[$patient_identification])) die('ERR 32176328763232');
			//Profile Information
			Config::$participant_nominal_data[$patient_identification]['Participant'] = array(
				'first_name' =>  str_replace("'","''", $new_line_data['Prénom']),
				'last_name' =>  str_replace("'","''", $new_line_data['Nom']),
				'date_of_birth' =>  '',
				'date_of_birth_accuracy' =>  'c',
				'procure_chus_abort' =>  '',
				'procure_chus_aborting_date' =>  '',
				'procure_chus_aborting_date_accuracy' =>  'c',
				'vital_status' =>  '',
				'date_of_death' =>  '',
				'date_of_death_accuracy' =>  'c',
				'procure_cause_of_death' =>  '');
			$tmp_date = getDateAndAccuracy($new_line_data['Date de naissance'], $summary_msg_title, 'Date de naissance', $line_counter);
			if($tmp_date) {
				Config::$participant_nominal_data[$patient_identification]['Participant']['date_of_birth'] = $tmp_date['date'];
				Config::$participant_nominal_data[$patient_identification]['Participant']['date_of_birth_accuracy'] = $tmp_date['accuracy'];
			}
			if(strlen($new_line_data['Notes au dossier'])) Config::$participant_notes[$patient_identification][] = str_replace("'","''", $new_line_data['Notes au dossier']);
			if($new_line_data['Statut Participant (actif vs abandon/décédé)']) {
				if($new_line_data['Statut Participant (actif vs abandon/décédé)'] == 'Abandon') {
					if(strlen($new_line_data['Statut Vital (vivant vs décédé)'].$new_line_data['Date Décès'].$new_line_data['Cause du décès'])) die('ERRR 23 28763287 23');
					Config::$participant_nominal_data[$patient_identification]['Participant']['procure_chus_abort'] = 'y';
					if($new_line_data['Date Abandon']) {
						if(preg_match('/^([0-9]{4})\-unk\-unk$/', $new_line_data['Date Abandon'], $matches)) {
							Config::$participant_nominal_data[$patient_identification]['Participant']['procure_chus_aborting_date'] = $matches[1].'-01-01';
							Config::$participant_nominal_data[$patient_identification]['Participant']['procure_chus_aborting_date_accuracy'] = 'm';
						} else if(preg_match('/^([0-9]{4})\-([0-9]{2})\-unk$/', $new_line_data['Date Abandon'], $matches)) {
							Config::$participant_nominal_data[$patient_identification]['Participant']['procure_chus_aborting_date'] = $matches[1].'-'.$matches[2].'-01';
							Config::$participant_nominal_data[$patient_identification]['Participant']['procure_chus_aborting_date_accuracy'] = 'd';
						} else {
							$tmp_date = getDateAndAccuracy($new_line_data['Date Abandon'], $summary_msg_title, 'Date Abandon', $line_counter);
							if($tmp_date) {
								Config::$participant_nominal_data[$patient_identification]['Participant']['procure_chus_aborting_date'] = $tmp_date['date'];
								Config::$participant_nominal_data[$patient_identification]['Participant']['procure_chus_aborting_date_accuracy'] = $tmp_date['accuracy'];
							}
						}
					}
				} else if($new_line_data['Statut Participant (actif vs abandon/décédé)'] == 'Décédé') {
					if(strlen($new_line_data['Date Abandon'])) die('ERR 23 287 63287632');
					Config::$participant_nominal_data[$patient_identification]['Participant']['vital_status'] = 'deceased';
					if(!in_array($new_line_data['Statut Vital (vivant vs décédé)'], array('', 'Décédé'))) die('ERR 2387 627628762 8723');
					$tmp_date = getDateAndAccuracy($new_line_data['Date Décès'], $summary_msg_title, 'Date Décès', $line_counter);
					if($tmp_date) {
						Config::$participant_nominal_data[$patient_identification]['Participant']['date_of_death'] = $tmp_date['date'];
						Config::$participant_nominal_data[$patient_identification]['Participant']['date_of_death_accuracy'] = $tmp_date['accuracy'];
					}
					if($new_line_data['Cause du décès']) {
						if($new_line_data['Cause du décès'] != 'Indépendant') die('ERR 23 628736 32876238 ');
						Config::$participant_nominal_data[$patient_identification]['Participant']['procure_cause_of_death'] = "independent of prostate cancer";
					}
				} else {
					die('ERR 32632876 87632');
				}
			} else if(strlen($new_line_data['Date Abandon'].$new_line_data['Statut Vital (vivant vs décédé)'].$new_line_data['Date Décès'].$new_line_data['Cause du décès'])) {
				die('ERR23423423234234234');
			}
			//Misc Identifier
			if($new_line_data['Dossier CHUS']) {
				Config::$participant_nominal_data[$patient_identification]['MiscIdentifer']['hospital_number'] = $new_line_data['Dossier CHUS'];
			}
			//Contact
			for($id_phone = 1; $id_phone < 4; $id_phone++) {
				if(strlen($new_line_data["Téléphone $id_phone::Numéro"].$new_line_data["Téléphone $id_phone::Détails"])) {
					if(empty($new_line_data["Téléphone $id_phone::Numéro"]) || empty($new_line_data["Téléphone $id_phone::Détails"])) die('ERR 2376 28763287632');
					Config::$participant_nominal_data[$patient_identification]['Contact'][] = array(
						'contact_type' => $new_line_data["Téléphone $id_phone::Détails"],
						'phone' => $new_line_data["Téléphone $id_phone::Numéro"]);
				}
			}
		}
	}

}
	
function recordAdditionalNominalData($patient_identification, $participant_id) {
	if(isset(Config::$participant_nominal_data[$patient_identification]['MiscIdentifer'])) {	
	 	$query = "INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, flag_unique) VALUES ('".Config::$participant_nominal_data[$patient_identification]['MiscIdentifer']['hospital_number']."', 2, $participant_id, 1);";
	 	mysqli_query(Config::$db_connection, $query) or die("Error hosptal number record. [$query] ");
	 	if(Config::$insert_revs){
	 		$query = str_replace('misc_identifiers', 'misc_identifiers_revs', $query);
	 		mysqli_query(Config::$db_connection, $query) or die("Error hosptal number record. [$query] ");
	 	}
	}
	if(isset(Config::$participant_nominal_data[$patient_identification]['Contact'])) {	
		foreach(Config::$participant_nominal_data[$patient_identification]['Contact'] as $new_contact) {
			customInsertRecord(array_merge($new_contact, array('participant_id' => $participant_id)), 'participant_contacts');
		}
	}
}	
