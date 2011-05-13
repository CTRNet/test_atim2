<?php

$pkey = "Patient # in biobank";
$child = array("qc_tf_cpcbn", 'qc_tf_ed_cpcbn');
$fields = array(
	"title" => "",
	"first_name" => "",
	"middle_name" => "",
	"last_name" => "",
	"date_of_birth" => "Date of Birth Date",
	"dob_date_accuracy" => "Date of Birth Accuracy",
	"marital_status" => "",
	"language_preferred" => "",
	"sex" => "@m",
	"race" => "",
	"vital_status" => array("Death status" => array("alive" => "alive", "dead" => "deceased", "unknown" => "unknown")),
	"notes" => "",
	"date_of_death" => "Registered Date of Death Date",
	"dod_date_accuracy" => "Registered Date of Death Accuracy",
	"cod_icd10_code" => "",
	"secondary_cod_icd10_code" => "",
	"cod_confirmation_source" => "",
	"participant_identifier" => "@tmp_id",
	"last_chart_checked_date" => "",
	"qc_tf_suspected_date_of_death" => "Suspected Date of Death Date",
	"qc_tf_suspected_date_of_death_accuracy" => "Suspected Date of Death Accuracy",
	"qc_tf_family_history" => "Family History (prostatite/cancer)",
	"qc_tf_last_contact" => "Date of last contact Date",
	"qc_tf_last_contact_accuracy" => "Date of last contact Accuracy",
	"qc_tf_bank_id"				=> "identifier_id",
	"qc_tf_death_from_cancer"	=> array("Death from prostate cancer" => array("no" => "n", "yes" => "y", "unknown" => "", "" => "")),
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
		$fields["date_of_birth"]					=> $fields["dob_date_accuracy"], 
		$fields["date_of_death"]					=> $fields["dod_date_accuracy"], 
		$fields["qc_tf_suspected_date_of_death"]	=> $fields["qc_tf_suspected_date_of_death_accuracy"], 
		$fields["qc_tf_last_contact"]				=> $fields["qc_tf_last_contact_accuracy"])
);
$tables['participants']->post_read_function = 'postRead';
$tables['participants']->post_write_function = 'postParticipantWrite';
?>
