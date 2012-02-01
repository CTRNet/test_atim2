<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "@19",
	"participant_id" => $pkey,
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
$model->post_write_function = 'postRecurrenceWrite';

//adding this model to the config
Config::$models['Recurrence'] = $model;
	
function postRecurrenceRead(Model $m){	
	if(empty($m->values['Recurrent Disease']) && empty($m->values['Date of Recurrence'])) return false;
	
	excelDateFix($m);
	
	if(!empty($m->values['Recurrent Disease'])) {
		if(strtolower($m->values['Recurrent Disease']) != 'yes') die('ERR Recurrence Flag : '.$m->values['Recurrent Disease'] .'!');
		$m->values['Recurrent Disease'] = '';
	}
		
	return true;
}
function postRecurrenceWrite(Model $m){
	global $connection;
	
	$voa_nbr = Config::$participant_master_ids_from_voa['current_voa_nbr'];
	$primary_diagnosis_master_id = Config::$participant_master_ids_from_voa['data'][$voa_nbr]['primary_diagnosis_master_id'];
	$recurrence_diagnosis_master_id = $m->last_id;
	
	$query = "UPDATE diagnosis_masters SET primary_id = $primary_diagnosis_master_id, parent_id = $primary_diagnosis_master_id WHERE id = $recurrence_diagnosis_master_id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE diagnosis_masters_revs SET primary_id = $primary_diagnosis_master_id, parent_id = $primary_diagnosis_master_id WHERE id = $recurrence_diagnosis_master_id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}


