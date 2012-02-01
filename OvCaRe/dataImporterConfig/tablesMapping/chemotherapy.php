<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"treatment_control_id" => "@5",
	"participant_id" => $pkey,
	"start_date" => "Date Chemo Start",
	"finish_date" => "Date Chemo End",
	"notes" => "Chemotherapy");
$detail_fields = array();
	
//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'treatment_masters', $master_fields, 'txd_chemos', 'treatment_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array(
	"date_fields" => array(
		$master_fields["start_date"] => null,
		$master_fields["finish_date"] => null
	) 
);
$model->post_read_function = 'postChemotherapyRead';
$model->post_write_function = 'postChemotherapyWrite';

//adding this model to the config
Config::$models['Chemotherapy'] = $model;
	
function postChemotherapyRead(Model $m){	

	$m->values['Chemotherapy'] = str_replace(array('no','nbo','radiotherapy','unable to determine','unknown'), array('','','','',''), strtolower($m->values['Chemotherapy']));
	$m->values['Date Chemo Start'] = str_replace('none', '', $m->values['Date Chemo Start']);
	$m->values['Date Chemo End'] = str_replace('none', '', $m->values['Date Chemo End']);
	
	if(empty($m->values['Chemotherapy']) && empty($m->values['Date Chemo Start']) && (empty($m->values['Date Chemo End']))) {
		return false;
	}
	
	excelDateFix($m);	
	
	return true;
}
function postChemotherapyWrite(Model $m){
	global $connection;
	
	$voa_nbr = Config::$participant_master_ids_from_voa['current_voa_nbr'];
	$primary_diagnosis_master_id = Config::$participant_master_ids_from_voa['data'][$voa_nbr]['primary_diagnosis_master_id'];
	$treatment_master_id = $m->last_id;
	
	$query = "UPDATE treatment_masters SET diagnosis_master_id = $primary_diagnosis_master_id WHERE id = $treatment_master_id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE treatment_masters_revs SET diagnosis_master_id = $primary_diagnosis_master_id WHERE id = $treatment_master_id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}


