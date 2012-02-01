<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "@16",
	"participant_id" => $pkey,
	"notes" => "Metastisis");

$detail_fields = array();
	
//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $master_fields, 'dxd_secondaries', 'diagnosis_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postMetastasisRead';
$model->post_write_function = 'postMetastasisWrite';

//adding this model to the config
Config::$models['Metastasis'] = $model;
	
function postMetastasisRead(Model $m){	
	
	$m->values['Metastisis'] = str_replace(array('no','no ','unable to determine','unknown'), array('','','',''), strtolower($m->values['Metastisis']));
	if(empty($m->values['Metastisis'])) return false;
	
	return true;
}
function postMetastasisWrite(Model $m){
	global $connection;
	
	$voa_nbr = Config::$participant_master_ids_from_voa['current_voa_nbr'];
	$primary_diagnosis_master_id = Config::$participant_master_ids_from_voa['data'][$voa_nbr]['primary_diagnosis_master_id'];
	$metastasis_diagnosis_master_id = $m->last_id;
	
	$query = "UPDATE diagnosis_masters SET primary_id = $primary_diagnosis_master_id, parent_id = $primary_diagnosis_master_id WHERE id = $metastasis_diagnosis_master_id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE diagnosis_masters_revs SET primary_id = $primary_diagnosis_master_id, parent_id = $primary_diagnosis_master_id WHERE id = $metastasis_diagnosis_master_id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}


