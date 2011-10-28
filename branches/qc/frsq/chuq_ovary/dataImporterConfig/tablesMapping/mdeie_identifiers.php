<?php
$pkey = "NS";
$child = array();
$fields = array(
	"misc_identifier_control_id" => "@4",
	"participant_id" => $pkey,
	"identifier_value" => "MDEIE");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, "participant_id", $pkey, 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->custom_data = array();

//adding this model to the config
Config::$models['MdeieMiscIdentfier'] = $model;
