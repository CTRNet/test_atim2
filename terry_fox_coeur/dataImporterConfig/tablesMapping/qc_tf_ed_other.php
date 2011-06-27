<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => array("Event Type" => array("CT Scan" => 38, "CA125" => 37, "biopsy" => 39)),
	"event_date" => "Date of event (beginning) Date",
	"event_date_accuracy" => array("Date of event (beginning) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"event_type" => array("Event Type" => new ValueDomain('qc_tf_eoc_event_type', ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"event_group" => "#event group"
);

$model = new Model(4, $pkey, array(), false, "participant_id", $pkey, 'event_masters', $fields);
$model->custom_data = array("date_fields" => array(
	$fields["event_date"]				=> 'Date of event (beginning) Accuracy'
)); 
$model->custom_data['value_domains']['ct_scan'] = new ValueDomain('qc_tf_ct_scan_precision', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
$model->post_read_function = 'edAfterRead';
$model->post_write_function = 'edPostWrite';

Config::addModel($model, 'qc_tf_ed_other');
