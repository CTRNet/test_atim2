<?php
$pkey = "PatienteNbr";

$child = array();
$fields = array(
	"misc_identifier_control_id" => "@4",
	"participant_id" => $pkey,
	"identifier_value" => "No Dossier CHUS");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, "participant_id", $pkey, 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postNoDossierRead';
$model->post_write_function = 'postNoDossierWrite';

//adding this model to the config
Config::$models['ChusMiscIdentfier'] = $model;

function postNoDossierRead(Model $m){
	if(empty($m->values['No Dossier CHUS']) || isset(Config::$participant_ids_from['Chus#'][$m->values['No Dossier CHUS']])) return false;
	return true;
}

function postNoDossierWrite(Model $m) {
	Config::$participant_ids_from['Chus#'][$m->values['No Dossier CHUS']] = $m->values['PatienteNbr'];
}
