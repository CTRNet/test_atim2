<?php
$pkey = "VOA Number";
$child = array();
$fields = array(
	"misc_identifier_control_id" => "@2",
	"participant_id" => $pkey,
	"identifier_value" => "Personal Health Number");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, "participant_id", $pkey, 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->custom_data = array();

//adding this model to the config
Config::$models['PersonalHealthMiscIdentfier'] = $model;
