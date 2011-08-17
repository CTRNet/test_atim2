<?php
$pkey = "NS";
$child = array();
$fields = array(
	"misc_identifier_control_id" => "@3",
	"participant_id" => $pkey,
	"identifier_value" => "NO PATHO");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, "participant_id", $pkey, 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postPathoNbrRead';
$model->custom_data = array();

//adding this model to the config
Config::$models['PathoMiscIdentfier'] = $model;

function postPathoNbrRead(Model $m){
	if(empty($m->values['NO PATHO'])) {
		echo "<br><FONT COLOR=\"red\" >Line ".$m->line.": NO PATHO is empty!</FONT><br>";
	}
	
	return true;
}
