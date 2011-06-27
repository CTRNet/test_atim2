<?php
//progression recurrence EOC - DX for site 2
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"participant_id" => "#participant_id",
	"primary_number" => "#primary_number",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression of CA125 Date",
	"dx_date_accuracy" => array("Date of Progression of CA125 Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_tumor_site" => "@",
	"qc_tf_progression_recurrence" => "@CA125 progression"
);

$detail_fields = array(
	'progression_time_in_month' => 'CA125 progression time (months)'
);

$model = new MasterDetailModel(1, $pkey, array(), false, null, $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"])),
	'Date of EOC Diagnosis Date'						=> null) 
); 

$model->post_read_function = 'progressionSiteCa125PostRead';
$model->insert_condition_function = 'progressionSiteInsertNow';

Config::$models['qc_tf_dxd_progression_site_ca125'] = $model;

function progressionSiteCa125PostRead(Model $m){
	if(empty($m->values['Date of Progression of CA125 Date'])){
		return false;
	}
	excelDateFix($m);
	
	return true;
}