<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"tx_control_id" => array("Event Type" => array("surgery" => 3, "surgery (ovarectomy)" => 3, "surgery (other)" => 3, "chimiotherapy" => 1, "radiology" => "", "radiotherapy" => 10, "hormonal therapy" => 11)),
	"start_date" => "Date of event (beginning) Date",
	"start_date_accuracy" => array("Date of event (beginning) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"finish_date" => "Date of event (end) Date",
	"finish_date_accuracy" => array("Date of event (end) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => ""))
);

$model = new Model(2, $pkey, array(), false, "participant_id", $pkey, 'tx_masters', $fields);
$model->custom_data = array("date_fields" => array(
	$fields["start_date"]				=> 'Date of event (beginning) Accuracy',
	$fields["finish_date"]				=> 'Date of event (end) Accuracy'
));
$model->custom_data['value_domains']['drug'] = new ValueDomain('qc_tf_eoc_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
$model->custom_data['value_domains']['surgery'] = new ValueDomain('qc_tf_surgery_type', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

$model->post_read_function = 'txPostRead';
$model->post_write_function = 'txPostWrite';

Config::addModel($model, 'qc_tf_tx_eocs');

