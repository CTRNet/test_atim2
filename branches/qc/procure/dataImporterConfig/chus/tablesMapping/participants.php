<?php
$pkey = "Identification";

$child = array('Consent','Questionnaire'/*,'PathReport','Diagnostic','Treatment'*/);

$fields = array(	
	"participant_identifier" => $pkey/*,
	"first_name" => "#first_name",
	"last_name" => "#last_name",
	"date_of_birth" => "#date_of_birth",
	"date_of_birth_accuracy" => "#date_of_birth_accuracy",*/
);

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'participants', $fields);

$model->custom_data = array();
$model->post_read_function = 'postParticipantRead';
$model->insert_condition_function = 'preParticipantWrite';
$model->post_write_function = 'postParticipantWrite';

Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	if($m->values['Visite'] != 'V01') {
		Config::$summary_msg['Visit']['@@ERROR@@']['Wrong visite'][] = "Should be V01. No data will be imported. See line: ".$m->line;
		return false;
	}
	return true;
}

function preParticipantWrite(Model $m){
	$participant_identification = $m->values['Identification'];
	if(isset(Config::$participant_nominal_data[$participant_identification])) {
// 		$m->values['first_name'] = Config::$participant_nominal_data[$participant_identification]['first_name'];
// 		$m->values['last_name'] = Config::$participant_nominal_data[$participant_identification]['last_name'];
// 		$m->values['date_of_birth'] = Config::$participant_nominal_data[$participant_identification]['date_of_birth'];
// 		$m->values['date_of_birth_accuracy'] = Config::$participant_nominal_data[$participant_identification]['date_of_birth_accuracy'];
	}
	return true;
}
	
function postParticipantWrite(Model $m){
// 	$participant_identification = $m->values['Identification'];
// 	if(isset(Config::$participant_nominal_data[$participant_identification]) && Config::$participant_nominal_data[$participant_identification]['hospital_number']) {
// 		recordHospitalNumber(Config::$participant_nominal_data[$participant_identification]['hospital_number'], $m->last_id);
// 	}
// 	recordParticipantCollection($m->values['Identification'], $m->last_id);
}

function loadParticipantNominalData() {
//TODO
die('TODO : loadParticipantNominalData()');	
	$tmp_xls_reader = new Spreadsheet_Excel_Reader();
	$tmp_xls_reader->read( Config::$xls_file_path);
	
	$sheets_nbr = array();
	foreach($tmp_xls_reader->boundsheets as $key => $tmp) $sheets_nbr[$tmp['name']] = $key;
	
	Config::$participant_nominal_data = array();
	
	// Load data from : Données clinico-pathologiques
	
	if(!array_key_exists(utf8_decode('Patients'), $sheets_nbr)) die("ERROR: Worksheet Tissus Disponible is missing!\n");
	
	$headers = array();
	$line_counter = 0;
	foreach($tmp_xls_reader->sheets[$sheets_nbr[utf8_decode('Patients')]]['cells'] as $line => $new_line) {
		$line_counter++;
		if($line_counter == 1) {
			$headers = $new_line;
		} else {
			$new_line_data = customArrayCombineAndUtf8Encode($headers, $new_line);
			$patient_identification = $new_line_data['Code du Patient'];
			if(isset(Config::$participant_nominal_data[$patient_identification])) die('ERR 9300029993 Patient already exists '.$patient_identification);
			$tmp_name = $new_line_data['Name  (last name, name)'];
			$first_name = '';
			$last_name = '';
			if(preg_match('/^(.*)(,)(\ ){0,1}(.*)$/', $tmp_name, $matches)) {
				$first_name = $matches[1];
				$last_name = $matches[4];
			}	
			$date_of_birth = "''";
			$date_of_birth_accuracy = "''";
			$date_of_birth_tmp = getDateAndAccuracy($new_line_data['Date Of Birth'], 'Participant', "Date Of Birth", $line_counter);
			if($date_of_birth_tmp) {
				$date_of_birth = $date_of_birth_tmp['date'];
				$date_of_birth_accuracy = $date_of_birth_tmp['accuracy'];
			}		
			$hopital_nbr = $new_line_data['MGH N'];
			$patho_nbr = $new_line_data['Path.No.'];
			Config::$participant_nominal_data[$patient_identification] = array(
				'first_name' => $first_name,
				'last_name' => $last_name,
				'date_of_birth' => $date_of_birth,
				'date_of_birth_accuracy' => $date_of_birth_accuracy,
				'hospital_number' => $hopital_nbr,
				'path_number' => $patho_nbr);
		}
	}
}

function recordHospitalNumber($hospital_number, $participant_id){
//TODO
die('TODO : recordHospitalNumber()');	
	$query = "INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id) VALUES ('$hospital_number', 2, $participant_id);";
	mysqli_query(Config::$db_connection, $query) or die("Error hosptal number record. [$query] ");
	if(Config::$insert_revs){
		$query = str_replace('misc_identifiers', 'misc_identifiers_revs', $query);
		mysqli_query(Config::$db_connection, $query) or die("Error hosptal number record. [$query] ");
	}
}
