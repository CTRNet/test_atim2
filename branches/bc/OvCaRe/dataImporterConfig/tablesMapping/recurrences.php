<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "@19",
	"participant_id" => $pkey,
	"primary_id" => "#primary_id",
	"parent_id" => "#parent_id",
	"dx_date" => "Date of Recurrence",
	"notes" => "Recurrent Disease");

$detail_fields = array();
	
//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $master_fields, 'dxd_recurrences', 'diagnosis_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array(
	"date_fields" => array(
		$master_fields["dx_date"] => null
	)
);
$model->post_read_function = 'postRecurrenceRead';
$model->insert_condition_function = 'preRecurrenceWrite';
$model->post_write_function = 'postRecurrenceWrite';

//adding this model to the config
Config::$models['Recurrence'] = $model;
	
function postRecurrenceRead(Model $m){	
	if(empty($m->values['Recurrent Disease']) && empty($m->values['Date of Recurrence'])) return false;
	
	excelDateFix($m);
	
	return true;
}

function preRecurrenceWrite(Model $m){
	if(!empty($m->values['Recurrent Disease'])) {
		if(strtolower($m->values['Recurrent Disease']) != 'yes') die('ERR Recurrence Flag : '.$m->values['Recurrent Disease'] .'!');
		$m->values['Recurrent Disease'] = '';
	}
	
	$m->values['primary_id'] = Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'];
	$m->values['parent_id'] = Config::$record_ids_from_voa[Config::$current_voa_nbr]['ovcare_diagnosis_id'];
	
	return true;
}

function postRecurrenceWrite(Model $m){
	Config::$record_ids_from_voa[Config::$current_voa_nbr]['recurrence_diagnosis_id'] = $m->last_id;
	Config::$current_patient_session_data['date_of_reccurrence'] = $m->values['Date of Recurrence'];
}


