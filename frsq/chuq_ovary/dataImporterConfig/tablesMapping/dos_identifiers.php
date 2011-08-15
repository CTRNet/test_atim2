<?php
$pkey = "NS";
$child = array();
$fields = array(
	"misc_identifier_control_id" => "@2",
	"participant_id" => $pkey,

	"identifier_name" => "@NO DOS",
	"identifier_abrv" => "@NO DOS",
	"identifier_value" => "NO DOS");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, "participant_id", 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postDosNbrRead';
$model->custom_data = array();

//adding this model to the config
Config::$models['DosMiscIdentfier'] = $model;

function postDosNbrRead(Model $m){
	if(empty($m->values['NO DOS'])) {
		echo "<br><FONT COLOR=\"red\" >Line ".$m->line.": NO DOS is empty!</FONT><br>";
	}
}
