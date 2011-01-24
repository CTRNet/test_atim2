<?php

$pkey = "Patient Biobank Number
(required & unique)";
$child = array();
$fields = array(
	"title" 					=> "",
	"first_name" 				=> "",
	"middle_name" 				=> "",
	"last_name" 				=> "",
	"date_of_birth" 			=> "",
	"dob_date_accuracy" 		=> "",
	"marital_status" 			=> "",
	"language_preferred" 		=> "",
	"sex" 						=> "",
	"race" 						=> "",
	"vital_status" 				=> "",
	"notes" 					=> "",
	"date_of_death" 			=> "",
	"dod_date_accuracy" 		=> "",
	"cod_icd10_code" 			=> "",
	"secondary_cod_icd10_code" 	=> "",
	"cod_confirmation_source" 	=> "",
	"participant_identifier" 	=> "",
	"last_chart_checked_date"	=> "",
);

function postParticipantWrite(Model $m, $participant_id){
	global $connection;
	$query = "UPDATE participants SET participant_identifier=id WHERE id=".$participant_id;
	mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	if(!isset($m->values['identifier_id'])){
		die("Participant identifier_id is required");
	}
	$insert = array(
		"identifier_value"				=> "'".$m->values[$m->pkey]."'",
		"misc_identifier_control_id"	=> $m->values['identifier_id'],
		"participant_id"				=> $participant_id,
		"created"						=> "NOW()", 
		"created_by"					=> "1", 
		"modified"						=> "NOW()",
		"modified_by"					=> "1"
	);
	$query = "INSERT INTO misc_identifiers (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}

$tables['participants'] = new Model(0, $pkey, $child, true, NULL, 'participants', $fields);
$tables['participants']->custom_data = array(
	"date_fields" => array(
		$fields["date_of_birth"] => $fields["dob_date_accuracy"], 
		$fields["date_of_death"] => $fields["dod_date_accuracy"] 
);
$tables['participants']->post_read_function = 'postRead';
$tables['participants']->post_write_function = 'postParticipantWrite';
?>
