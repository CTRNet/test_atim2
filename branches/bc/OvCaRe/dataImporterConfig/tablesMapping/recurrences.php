<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "@19",
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

//adding this model to the config
Config::$models['Recurrence'] = $model;
	
function postRecurrenceRead(Model $m){
	$m->values['notes'] = '';
	excelDateFix($m);
	if(!empty($m->values['Date of Recurrence']) || !empty($m->values['Recurrent Disease'])) {
	pr($m->values);
	exit;
	return true;
	}
	
	return false;
}




