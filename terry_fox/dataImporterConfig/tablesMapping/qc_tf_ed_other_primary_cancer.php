<?php
$pkey = "Patient Biobank Number
(required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => "@36",
	"event_date" => "Date of event (beginning) Date",
	"event_type" => "Event Type"
);

$detail_fields = array(
	"date_accuracy" => "Date of event (beginning) Accuracy",
	"end_date" => "Date of event (end) Date",
	"end_date_accuracy" => "Date of event (end) Accuracy",
	"drug1" => "Chimiotherapy Precision Drug1",
	"drug2" => "Chimiotherapy Precision Drug2",
	"drug3" => "Chimiotherapy Precision Drug3",
	"drug4" => "Chimiotherapy Precision Drug4"
);



$tables['qc_tf_ed_other_primary_cancers'] = new MasterDetailModel(4, $pkey, array(), false, "participant_id", 'event_masters', $fields, 'qc_tf_ed_other_primary_cancers', 'event_master_id', $detail_fields);
$tables['qc_tf_ed_other_primary_cancers']->custom_data = array("date_fields" => array(
	$fields["event_date"], 
	$detail_fields["end_date"]));
$tables['qc_tf_ed_other_primary_cancers']->post_read_function = 'postRead';
