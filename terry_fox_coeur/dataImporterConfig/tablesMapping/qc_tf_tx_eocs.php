<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"tx_control_id" => array("Event Type" => array("surgery(ovarectomy)" => 20, "surgery(other)" => 15, "chimiotherapy" => 14, "radiotherapy" => 21)),
	"tx_method " => array("Event Type" => array("surgery(ovarectomy)" => 'ovarectomy', "surgery(other)" => 'surgery', "chimiotherapy" => 'chemotherapy', "radiotherapy" => 'radiotherapy')),
	"disease_site" => "@EOC",
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

$model->post_read_function = 'txPostRead';
$model->post_write_function = 'txPostWrite';

$model->file_event_types = Config::$eoc_file_event_types;
$model->event_types_to_import = array_keys($fields['tx_control_id']['Event Type']);

Config::addModel($model, 'qc_tf_tx_eocs');
