<?php
$pkey = "NS";
$child = array();
$fields = array(
	"misc_identifier_control_id" => "@4",
	"participant_id" => $pkey,

	"identifier_name" => "@MDEIE",
	"identifier_abrv" => "@MDEIE",
	"identifier_value" => "MDEIE");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, "participant_id", 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_write_function = 'postMedieWrite';

//adding this model to the config
Config::$models['MdeieMiscIdentfier'] = $model;

function postMedieWrite(Model $m, $participant_id){
	global $connection;
	$query = "DELETE FROM misc_identifiers WHERE identifier_value LIKE ''"; 
	mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}
