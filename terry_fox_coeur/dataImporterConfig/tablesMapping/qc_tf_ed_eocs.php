<?php
$pkey = "Patient Biobank Number
(required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => "@35",
	"event_date" => "Date of event (beginning) Date",
	"event_type" => "@eoc",
	"event_group" => "@clinical"
);

$detail_fields = array(
	"date_accuracy" => "Date of event (beginning) Accuracy",
	"event_date_end" => "Date of event (end) Date",
	"event_date_end_accuracy" => "Date of event (end) Accuracy",
	"drug1" => "Chimiotherapy Precision Drug1",
	"drug2" => "Chimiotherapy Precision Drug2",
	"drug3" => "Chimiotherapy Precision Drug3",
	"drug4" => "Chimiotherapy Precision Drug4",
	"ca125_precision" => "CA125  Precision (U)",
	"ct_scan_precision" => "CT Scan Precision",
	"m_event_type" => "Event Type"
);


$tables['qc_tf_ed_eocs'] = new MasterDetailModel(2, $pkey, array(), false, "participant_id", 'event_masters', $fields, 'qc_tf_ed_eocs', 'event_master_id', $detail_fields);
$tables['qc_tf_ed_eocs']->custom_data = array("date_fields" => array(
	$fields["event_date"]				=> $detail_fields["date_accuracy"], 
	$detail_fields["event_date_end"]	=> $detail_fields["event_date_end_accuracy"]));
$tables['qc_tf_ed_eocs']->post_read_function = 'postRead';