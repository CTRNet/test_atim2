<?php

$pkey = "Patient Biobank Number (required & unique)";
$child = array(
	"qc_tf_dxd_eocs", 
	"qc_tf_dxd_other_primary_cancers", 
	"qc_tf_ed_eocs",
	"qc_tf_tx_eocs",
	"qc_tf_ed_other",
	"qc_tf_tx_other",
	"collection"
);
$fields = array(
//	"title" => "",
//	"first_name" => "",
//	"middle_name" => "",
//	"last_name" => "",
	"qc_tf_bank_identifier" => "Patient Biobank Number (required & unique)",
	"date_of_birth" => "Date of Birth Date",
	"date_of_birth_accuracy" => array("Date of Birth date accuracy" => Config::$coeur_accuracy_def),
//	"marital_status" => "",
//	"language_preferred" => "",
//	"sex" => "",
//	"race" => "",
	"vital_status" => array("Death Death" => array("alive" => "alive", "dead" => "deceased", "unknown" => "unknown", "" => "unknown", "deceased" => "deceased")),
	"date_of_death" => "Registered Date of Death Date",
	"date_of_death_accuracy" => array("Registered Date of Death date accuracy" => Config::$coeur_accuracy_def),
//	"cod_icd10_code" => "",
//	"secondary_cod_icd10_code" => "",
//	"cod_confirmation_source" => "",
	"participant_identifier" => "@tmp_id",
//	"last_chart_checked_date" => "",
	"qc_tf_suspected_date_of_death" => "Suspected Date of Death Date",
	"qc_tf_suspected_date_of_death_accuracy" => array("Suspected Date of Death date accuracy" => Config::$coeur_accuracy_def),
	"qc_tf_family_history" => array("family history" => new ValueDomain("qc_tf_fam_hist", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),


	"qc_tf_brca_status" => array("BRCA status" => new ValueDomain("qc_tf_brca", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_last_contact" => "Date of Last Contact Date",
	"qc_tf_last_contact_accuracy" => array("Date of Last Contact date accuracy" => Config::$coeur_accuracy_def),
	"qc_tf_bank_id"				=> "#qc_tf_bank_id",
	"notes" => "notes"
);

function postParticipantRead(Model $m){
	excelDateFix($m);
		
	if(array_key_exists($m->values['Bank'], Config::$banks)) {
		$m->values['qc_tf_bank_id'] = Config::$banks[$m->values['Bank']]['id'];
		return checkAndAddBankIdentifier($m->values['qc_tf_bank_id'], $m->values['Patient Biobank Number (required & unique)'], ' New value will be duplaicted');
	} else {
		die ("ERROR: Bank '".$m->values['Bank']."' is unknown [".$m->file."] at line [". $m->line."]\n");
	}

	return true;
}

function postParticipantWrite(Model $m){
	$query = "UPDATE participants SET participant_identifier=id WHERE id=".$m->last_id;
	mysqli_query(Config::$db_connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
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

