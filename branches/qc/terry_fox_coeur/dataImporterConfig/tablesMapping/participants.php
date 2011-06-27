<?php

$pkey = "Patient Biobank Number (required & unique)";
$child = array(
	//"qc_tf_dxd_eocs", 
	"qc_tf_dxd_other_primary_cancers"/*, 
	"qc_tf_ed_eocs", 
	"qc_tf_ed_other_primary_cancers"*/
);
$fields = array(
	"title" => "",
	"first_name" => "",
	"middle_name" => "",
	"last_name" => "",
	"date_of_birth" => "Date of Birth Date",
	"dob_date_accuracy" => array("Date of Birth date accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"marital_status" => "",
	"language_preferred" => "",
	"sex" => "",
	"race" => "",
	"vital_status" => array("Death Death" => array("alive" => "alive", "dead" => "deceased", "unknown" => "unknown", "" => "unknown", "deceased" => "deceased")),
	"notes" => "",
	"date_of_death" => "Registered Date of Death Date",
	"dod_date_accuracy" => array("Registered Date of Death date accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"cod_icd10_code" => "",
	"secondary_cod_icd10_code" => "",
	"cod_confirmation_source" => "",
	"participant_identifier" => "@tmp_id",
	"last_chart_checked_date" => "",
	"qc_tf_suspected_date_of_death" => "Suspected Date of Death Date",
	"qc_tf_sdod_accuracy" => array("Suspected Date of Death date accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_family_history" => "family history",
	"qc_tf_brca_status" => array("BRCA status" => new ValueDomain("qc_tf_brca", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_last_contact" => "Date of Last Contact Date",
	"qc_tf_last_contact_acc" => array("Date of Last Contact date accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_bank_id"				=> "identifier_id",
	"notes" => "notes"
);

function postParticipantWrite(Model $m){
	global $connection;
	$query = "UPDATE participants SET participant_identifier=id WHERE id=".$m->last_id;
	mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	if(!isset($m->values['identifier_id'])){
		die("Participant identifier_id is required");
	}
	$insert = array(
		"identifier_value"				=> "'".$m->values[$m->csv_pkey]."'",
		"misc_identifier_control_id"	=> $m->values['identifier_id'],
		"participant_id"				=> $m->last_id,
		"created"						=> "NOW()", 
		"created_by"					=> "1", 
		"modified"						=> "NOW()",
		"modified_by"					=> "1"
	);
	$query = "INSERT INTO misc_identifiers (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}

$model = new Model(0, $pkey, $child, true, NULL, NULL, 'participants', $fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["date_of_birth"]					=> current(array_keys($fields["dob_date_accuracy"])), 
		$fields["date_of_death"]					=> current(array_keys($fields["dod_date_accuracy"])), 
		$fields["qc_tf_suspected_date_of_death"]	=> current(array_keys($fields["qc_tf_sdod_accuracy"])), 
		$fields["qc_tf_last_contact"]				=> current(array_keys($fields["qc_tf_last_contact_acc"])))
);
$model->post_read_function = 'excelDateFix';
$model->post_write_function = 'postParticipantWrite';

Config::$models['participants'] = $model;

