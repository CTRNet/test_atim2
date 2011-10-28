<?php
$pkey = "NS";
$child = array();
$fields = array(
	"misc_identifier_control_id" => "@2",
	"participant_id" => $pkey,
	"identifier_value" => "NO DOS");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, "participant_id", $pkey, 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postDosNbrRead';
$model->custom_data = array();

//adding this model to the config
Config::$models['DosMiscIdentfier'] = $model;

function postDosNbrRead(Model $m){
	if(empty($m->values['NO DOS'])) Config::$summary_msg['NS without NO DOS'][] = $m->values['NS'];
	return true;
}
