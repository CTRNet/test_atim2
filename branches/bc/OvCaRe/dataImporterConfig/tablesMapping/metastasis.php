<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "@16",
	"participant_id" => $pkey,
	"primary_id" => "#primary_id",
	"parent_id" => "#parent_id",
	"notes" => "Metastisis");

$detail_fields = array();
	
//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $master_fields, 'dxd_secondaries', 'diagnosis_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postMetastasisRead';
$model->insert_condition_function = 'preMetastasisWrite';

//adding this model to the config
Config::$models['Metastasis'] = $model;
	
function postMetastasisRead(Model $m){	
	
	if(in_array(strtolower($m->values['Metastisis']), array('no','no ','unable to determine','unknown'))) $m->values['Metastisis'] = '';
	if(empty($m->values['Metastisis'])) return false;
	
	return true;
}

function preMetastasisWrite(Model $m){
	$m->values['Metastisis'] = (strtolower($m->values['Metastisis']) == 'yes')? '': 'Metastisis : '.$m->values['Metastisis'].'.';
	
	$m->values['primary_id'] = Config::$participant_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_master_id'];
	$m->values['parent_id'] = Config::$participant_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_master_id'];
	
	return true;
}



