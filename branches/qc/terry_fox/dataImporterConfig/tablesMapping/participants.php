<?php

$pkey = "Patient Biobank Number
(required & unique)";
$child = array("qc_tf_dxd_eocs", "qc_tf_dxd_other_primary_cancers", "qc_tf_ed_eocs", "qc_tf_ed_other_primary_cancers");
$fields = array(
	"title" => "",
	"first_name" => "@MDEIE",
	"middle_name" => "",
	"last_name" => "@MDEIE",
	"date_of_birth" => "Date of Births Date",
	"dob_date_accuracy" => "Date of Births date accuracy",
	"marital_status" => "",
	"language_preferred" => "",
	"sex" => "",
	"race" => "",
	"vital_status" => "Death Death",
	"notes" => "",
	"date_of_death" => "Registered Date of Death Date",
	"dod_date_accuracy" => "Registered Date of Death date accuracy",
	"cod_icd10_code" => "",
	"secondary_cod_icd10_code" => "",
	"cod_confirmation_source" => "",
	"participant_identifier" => $pkey,
	"last_chart_checked_date" => "",
	"qc_tf_suspected_date_of_death" => "Suspected Date of Death Date",
	"qc_tf_sdod_accuracy" => "Suspected Date of Death date accuracy",
	"qc_tf_family_history" => "family history",
	"qc_tf_brca_status" => "BRCA status",
	"qc_tf_last_contact" => "Date of Last Contact Date",
	"qc_tf_last_contact_acc" => "Date of Last Contact date accuracy",
);


$tables['participants'] = new Model(0, $pkey, $child, true, NULL, 'participants', $fields);
$tables['participants']->custom_data = array("date_fields" => array(
	$fields["date_of_birth"], 
	$fields["date_of_death"], 
	$fields["qc_tf_suspected_date_of_death"], 
	$fields["qc_tf_last_contact"]));
$tables['participants']->post_read_function = 'postRead';
?>
