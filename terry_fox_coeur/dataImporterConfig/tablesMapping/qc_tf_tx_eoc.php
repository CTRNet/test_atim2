<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"treatment_control_id" => array("Event Type" => array("surgery(ovarectomy)" => 20, "surgery(other)" => 15, "chemotherapy" => 14, "radiotherapy" => 21)),
	"start_date" => "Date of event (beginning) Date",
	"start_date_accuracy" => array("Date of event (beginning) Accuracy" => Config::$coeur_accuracy_def),
	"finish_date" => "Date of event (end) Date",
	"finish_date_accuracy" => array("Date of event (end) Accuracy" => Config::$coeur_accuracy_def)
);

$model = new Model(2, $pkey, array(), false, "participant_id", $pkey, 'treatment_masters', $fields);

$model->custom_data = array(
	"date_fields" => array(
		$fields["start_date"] => current(array_keys($fields["start_date_accuracy"])),
		$fields["finish_date"] => current(array_keys($fields["finish_date_accuracy"]))),
	'disease' => 'EOC'
);

$model->post_read_function = 'txPostRead';
$model->post_write_function = 'txPostWrite';

$model->file_event_types = Config::$eoc_file_event_types;
$model->event_types_to_import = array_keys($fields['treatment_control_id']['Event Type']);

Config::addModel($model, 'eoc_tx');
