<?php
$pkey = "VOA Number";
$child = array();
$fields = array(
	"participant_id" => $pkey,
	"collection_id" => "#collection_id",
	"diagnosis_master_id" => "#diagnosis_master_id",
	"consent_master_id" => "#consent_master_id");

//see the Model class definition for more info
$model = new Model(1, $pkey, $child, false, "participant_id", $pkey, 'clinical_collection_links', $fields);

//we can then attach post read/write functions
$model->custom_data = array();

//adding this model to the config
Config::$models['PreSurgicalCollection'] = $model;

$model->post_read_function = 'postPreSurgicalCollectionRead';
$model->insert_condition_function = 'prePreSurgicalCollectionWrite';

function postPreSurgicalCollectionRead(Model $m){
	return true;

}
function prePreSurgicalCollectionWrite(Model $m){
	$m->values['collection_id'] = createCollection($m, 'pre-surgical');
	$m->values['diagnosis_master_id'] = Config::$record_ids_from_voa[Config::$current_voa_nbr]['collection_diagnosis_id'];;
	$m->values['consent_master_id'] = Config::$record_ids_from_voa[Config::$current_voa_nbr]['consent_id'];
	
	return true;
}
