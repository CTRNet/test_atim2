<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => array("Event Type" => array("radiology" => 40, "biopsy" => 41)),
	"event_date" => "Date of event (beginning) Date",
	"event_date_accuracy" => array("Date of event (beginning) Accuracy" => Config::$coeur_accuracy_def)
);

$model = new Model(4, $pkey, array(), false, "participant_id", $pkey, 'event_masters', $fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["event_date"] => current(array_keys($fields["event_date_accuracy"]))),
	'disease' => 'Other'
); 

$model->post_read_function = 'edAfterRead';
$model->post_write_function = 'edPostWrite';

$model->file_event_types = Config::$opc_file_event_types;
$model->event_types_to_import = array_keys($fields['event_control_id']['Event Type']);

Config::addModel($model, 'other_ed');
