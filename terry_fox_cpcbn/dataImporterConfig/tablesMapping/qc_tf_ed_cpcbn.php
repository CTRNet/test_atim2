<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	"participant_id" 		=> $pkey,
	"event_control_id" 		=> "@35",
	"event_date"			=> "Dates of event Date of event (beginning)",
	"event_date_accuracy"	=> "Dates of event Accuracy",
);

$detail_fields = array(
	"event_end_date"			=> "Dates of event Date of event (end)",
	"event_end_date_accuracy"	=> "Dates of event Accuracy end",
	"psa_ng_on_ml"				=> "PSA (ng/ml)",
	"radiotherapy"				=> "Radiotherapy",
	"radiotherapy_dose"			=> "radiotherapy dose",
	"tx_precision1"				=> "treatment Precision Drug 1",
	"tx_precision2"				=> "treatment Precision drug 2",
	"tx_precision3"				=> "treatment Precision drug 3",
	"tx_precision4"				=> "treatment Precision drug 4",
	"hormonotherapy"			=> "hormonotherapy",
	"chemiotherapy"				=> "chemiotherapy",
	"notes"						=> "note"
);

$tables['qc_tf_ed_cpcbn'] = new MasterDetailModel(2, $pkey, $child, true, "participant_id", 'event_masters', $fields, 'qc_tf_ed_cpcbn', 'event_master_id', $detail_fields);
$tables['qc_tf_ed_cpcbn']->custom_data = array(
	"date_fields" => array(
		$fields["event_date"]				=> $fields["event_date_accuracy"],
		$detail_fields["event_end_date"]	=> $detail_fields["event_end_date"],
	)
);
$tables['qc_tf_cpcbn']->post_read_function = 'postRead';
