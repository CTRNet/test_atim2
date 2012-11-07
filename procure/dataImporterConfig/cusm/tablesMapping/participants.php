<?php
$pkey = "Identification";

$child = array('Consent','Questionnaire','PathReport','Diagnostic','Treatment');

$fields = array(	
	"participant_identifier" => $pkey
);

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'participants', $fields);

$model->custom_data = array();
$model->post_read_function = 'postParticipantRead';

Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	if($m->values['Visite'] != 'V01') {
		Config::$summary_msg['Visit']['@@ERROR@@']['Wrong visite'][] = "Should be V01. No data will be imported. See line: ".$m->line;
		return false;
	}
	return true;
}