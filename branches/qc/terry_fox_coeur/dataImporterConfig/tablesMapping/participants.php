<?php

$pkey = "Patient Biobank Number (required & unique)";
$child = array(
	"qc_tf_dxd_eocs", 
	"qc_tf_dxd_other_primary_cancers", 
	"qc_tf_ed_eocs",
	"qc_tf_tx_eocs",
	"qc_tf_ed_other",
	"qc_tf_tx_other"
);
$fields = array(
//	"title" => "",
//	"first_name" => "",
//	"middle_name" => "",
//	"last_name" => "",
	"date_of_birth" => "Date of Birth Date",
	"date_of_birth_accuracy" => array("Date of Birth date accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
//	"marital_status" => "",
//	"language_preferred" => "",
//	"sex" => "",
//	"race" => "",
	"vital_status" => array("Death Death" => array("alive" => "alive", "dead" => "deceased", "unknown" => "unknown", "" => "unknown", "deceased" => "deceased")),
	"date_of_death" => "Registered Date of Death Date",
	"date_of_death_accuracy" => array("Registered Date of Death date accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
//	"cod_icd10_code" => "",
//	"secondary_cod_icd10_code" => "",
//	"cod_confirmation_source" => "",
	"participant_identifier" => "@tmp_id",
//	"last_chart_checked_date" => "",
	"qc_tf_suspected_date_of_death" => "Suspected Date of Death Date",
	"qc_tf_suspected_date_of_death_accuracy" => array("Suspected Date of Death date accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_family_history" => array("family history" => new ValueDomain("qc_tf_fam_hist", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),


	"qc_tf_brca_status" => array("BRCA status" => new ValueDomain("qc_tf_brca", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_last_contact" => "Date of Last Contact Date",
	"qc_tf_last_contact_accuracy" => array("Date of Last Contact date accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_bank_id"				=> "#qc_tf_bank_id",
	"notes" => "notes"
);

function postParticipantRead(Model $m){
	excelDateFix($m);
		
	if(array_key_exists($m->values['Bank'], Config::$banks)) {
		$m->values['qc_tf_bank_id'] = Config::$banks[$m->values['Bank']]['id'];
		$m->values['misc_identifier_control_id'] = Config::$banks[$m->values['Bank']]['misc_identifier_control_id'];
	} else {
		die ("ERROR: Bank '".$m->values['Bank']."' is unknown [".$m->file."] at line [". $m->line."]\n");
	}

	return true;
}

function postParticipantWrite(Model $m){
	global $connection;
	global $primary_number;
	$primary_number = 1;
	$query = "UPDATE participants SET participant_identifier=id WHERE id=".$m->last_id;
	mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	if(!isset($m->values['misc_identifier_control_id'])){
		die("Participant misc_identifier_control_id is required");
	}
	
	checkAndAddIdentifier($m->values[$m->csv_pkey], $m->values['misc_identifier_control_id']);
	
	$insert = array(
		"identifier_value"				=> "'".$m->values[$m->csv_pkey]."'",
		"misc_identifier_control_id"	=> $m->values['misc_identifier_control_id'],
		"participant_id"				=> $m->last_id,
		"created"						=> "NOW()", 
		"created_by"					=> "1", 
		"modified"						=> "NOW()",
		"modified_by"					=> "1"
	);
	$query = "INSERT INTO misc_identifiers (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	if(Config::$insert_revs){
		$query = "INSERT INTO misc_identifiers_revs (id, identifier_value, misc_identifier_control_id, effective_date, expiry_date, participant_id, notes, modified_by, version_created) "
			."(SELECT id, identifier_value, misc_identifier_control_id, effective_date, expiry_date, participant_id, notes, modified_by, NOW() FROM misc_identifiers WHERE id='".mysqli_insert_id($connection)."')";
		mysqli_query($connection, $query) or die("postParticipantWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	}
}

$model = new Model(0, $pkey, $child, true, NULL, NULL, 'participants', $fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["date_of_birth"]					=> current(array_keys($fields["date_of_birth_accuracy"])), 
		$fields["date_of_death"]					=> current(array_keys($fields["date_of_death_accuracy"])), 
		$fields["qc_tf_suspected_date_of_death"]	=> current(array_keys($fields["qc_tf_suspected_date_of_death_accuracy"])), 
		$fields["qc_tf_last_contact"]				=> current(array_keys($fields["qc_tf_last_contact_accuracy"])))
);

$model->post_read_function = 'postParticipantRead';
$model->post_write_function = 'postParticipantWrite';

Config::$models['participants'] = $model;

