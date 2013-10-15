<?php
//OVCARE
$pkey = "VOA Number";

$child = array();

//Date of Procedure

$fields = array(
	"collection_voa_nbr" => $pkey, 
	"bank_id" => "@1",
	"collection_datetime" => "Date of Procedure",
	"ovcare_collection_type" => "#ovcare_collection_type",
	"collection_property" => "@participant collection",
	"collection_notes" => "#collection_notes",
	"participant_id" => "#participant_id",
	"diagnosis_master_id" => "#diagnosis_master_id",
	"consent_master_id" => "#consent_master_id",
	"treatment_master_id" => "#treatment_master_id");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'collections', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postParticipantRead';
$model->insert_condition_function = 'preParticipantWrite';
$model->post_write_function = 'postParticipantWrite';

$model->custom_data = array(
	"date_fields" => array(
		$fields["collection_datetime"] => null
	) 
);

//adding this model to the config
Config::$models['Collection'] = $model;

function postParticipantRead(Model $m){
	excelDateFix($m);
	return true;
}

function preParticipantWrite(Model $m){
	$voa_nbr = $m->values['VOA Number'];
	if(!isset(Config::$voas_to_ids[$voa_nbr])) die('ERR 66437437743438');
	if(!isset(Config::$voas_to_ids[$voa_nbr]['participant_id'])) die('ERR 664374377434332');
	$m->values['participant_id'] = Config::$voas_to_ids[$voa_nbr]['participant_id'];
	$m->values['diagnosis_master_id'] = Config::$voas_to_ids[$voa_nbr]['diagnosis_master_id'];
	$m->values['consent_master_id'] = Config::$voas_to_ids[$voa_nbr]['consent_master_id'];;
	$m->values['treatment_master_id'] = Config::$voas_to_ids[$voa_nbr]['surgery_treatment_master_id'];;
	$m->values['collection_notes'] = '';
	$m->values['ovcare_collection_type'] = '';
	return true;
}

function postParticipantWrite(Model $m){
	$voa_nbr = $m->values['VOA Number'];
	Config::$voas_to_ids[$voa_nbr] = array(
		'collection_id' => $m->last_id, 
		'participant_id' => Config::$voas_to_ids[$voa_nbr]['participant_id']);
}
