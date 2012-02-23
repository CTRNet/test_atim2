<?php
$pkey = "VOA Number";

$child = array(
	'PersonalHealthMiscIdentfier',
	'MedicalRecordMiscIdentfier',
	'ConsentMaster',
	'DiagnosisMaster',
	'Recurrence',
	'Metastasis',
	'Chemotherapy',
	'Surgery',
//	'ExperimentalResuls',
	'ExperimentalTests',
	'SurgicalCollection',
	'PreSurgicalCollection',
	'PostSurgicalCollection'
);
$fields = array(
	"participant_identifier" => $pkey, 
	"first_name" => "First Name",
	"last_name" => "Last Name",
	"date_of_birth" => "Date of Birth",
	"ovcare_last_followup_date" => "Date of Last Follow Up",
	"vital_status" => array("Status At Last Follow Up" => 
		array(
			"" => "",
			"Dead/Disease" => "dead/disease",
			"Alive/Well" => "alive/well",
			"Dead/Other" => "dead/other",
			"Unknown" => "unknown",
			"Alive/Disease" => "alive/disease",
			"Alive/Intercurrent Disease" => "alive/intercurrent disease",
			"Alive/Intercurrent Disease " => "alive/intercurrent disease",
			"Alive/Unknown" => "alive/unknown")),
	"notes" => "Notes on Outcome");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'participants', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postParticipantRead';
$model->post_write_function = 'postParticipantWrite';

$model->custom_data = array(
	"date_fields" => array(
		$fields["date_of_birth"] => null,
		$fields["ovcare_last_followup_date"] => null
	) 
);

//adding this model to the config
Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	Config::$current_voa_nbr = $m->values['VOA Number'];
	Config::$record_ids_from_voa[Config::$current_voa_nbr] = array();
	Config::$current_patient_session_data = array();
	
	Config::$current_patient_session_data['collection_additional_notes'] = $m->values['Comments'];
	
	excelDateFix($m);
	
	return true;
}

function postParticipantWrite(Model $m){
	Config::$record_ids_from_voa[Config::$current_voa_nbr]['participant_id'] = $m->last_id;
}