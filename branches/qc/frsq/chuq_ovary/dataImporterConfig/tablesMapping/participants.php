<?php
$pkey = "NS";
$child = array('ConsentMaster','DiagnosisMaster','PathoMiscIdentfier','DosMiscIdentfier');
$fields = array(
	"participant_identifier" => "NS", 
	"date_of_birth" => "DN",
	"vital_status" => array("CT" => 
		array(
			"O" => "alive",
			"*DCD" => "deceased",
			"DCD" => "deceased",
			"*O" => "alive",
			"N" => "",
			"O*" => "alive",
			"O                       O" => "alive")));

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, true, NULL, 'participants', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postParticipantRead';
$model->post_write_function = 'postParticipantWrite';
$model->custom_data = array(
	"date_fields" => array(
		$fields["date_of_birth"] => null
	) 
);

//adding this model to the config
Config::$models['Participant'] = $model;

function postParticipantRead(Model $m){
	excelDateFix($m);
}


function postParticipantWrite(Model $m, $participant_id){
	$line =  $m->line;
	$invantory_data_from_file =  $m->values;
	$collections = array('ascite' => array(), 'blood' => array(), 'tissue' => array());
	
	print_r($invantory_data_from_file);

	exit;
	
	
}