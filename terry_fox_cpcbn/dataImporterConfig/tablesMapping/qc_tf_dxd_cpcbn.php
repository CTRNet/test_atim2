<?php

$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	"participant_id" 		=> $pkey,
	"diagnosis_control_id" 	=> "@14",
	"dx_date"				=> "Date of diagnostics Date",
	"dx_date_accuracy"		=> "Date of diagnostics Accuracy",
	"age_at_dx"				=> "Age at Time of Diagnosis (yr)"
);

$detail_fields = array(
	"diagnosis_tool"						=> "Date of diagnostics  diagnostic tool",
	"gleason_score_at_biopsy"				=> "Gleason score at biopsy",
	"number_of_biopsies"					=> "number of biospies (optional)",
	"ptnm"									=> "pTNM",
	"gleason_sum_rp"						=> "Gleason sum RP",
	"presence_lymph_node_invasion"			=> "Presence of lymph node invasion",
	"presence_capsular_penetration"			=> "Presence of capsular penetration",
	"presence_seminal_invasion"				=> "Presence of seminal vesicle invasion",
	"margin"								=> "Margin",
	"date_biochemical_recurrence"			=> "Date of biochemical recurrence Date",
	"date_biochemical_recurrence_accuracy"	=> "Date of biochemical recurrence Accuracy",
	"date_biochemical_recurrence_definition"=> "Date of biochemical recurrence Definition",
	"type_of_metastasis"					=> "Development of metastasis Type of metastasis",
	"date_of_metastasis_dx"					=> "Development of metastasis date of diagnosis of metastasis",
	"hormonorefractory_status"				=> "hormonorefractory status status",
	"date_of_hormonorefractory_status_dx"	=> "hormonorefractory status date of HR status diagnosis"
);


$tables['qc_tf_cpcbn'] = new MasterDetailModel(1, $pkey, $child, true, "participant_id", 'diagnosis_masters', $fields, 'qc_tf_dxd_cpcbn', 'diagnosis_master_id', $detail_fields);
$tables['qc_tf_cpcbn']->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"]										=> $fields["dx_date_accuracy"],
		$detail_fields["date_biochemical_recurrence"]			=> $detail_fields["date_biochemical_recurrence_accuracy"],
		$detail_fields["date_of_metastasis_dx"]					=> null,
		$detail_fields["date_of_hormonorefractory_status_dx"]	=> null
	)
);
$tables['qc_tf_cpcbn']->post_read_function = 'postRead';
?>
