<?php
//progression recurrence EOC - DX for no site
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"participant_id" => "#participant_id",
	"primary_id" => "#primary_id",
	"parent_id" => "#parent_id",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression/Recurrence Date",
	"dx_date_accuracy" => array("Date of Progression/Recurrence Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_tumor_site" => "@unknown",
	"qc_tf_dx_origin" => "@progression",
	"qc_tf_progression_detection_method" => "@unknown"
);

$model = new MasterDetailModel(1, $pkey, array(), false, null, $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> current(array_keys($fields["dx_date_accuracy"])),
	'Date of EOC Diagnosis Date'						=> null) 
); 
$model->post_read_function = 'progressionNoSitePostRead';
$model->insert_condition_function = 'progressionSiteInsertNow';

Config::$models['qc_tf_dxd_progression_no_site'] = $model;

function progressionNoSitePostRead(Model $m){
	if(!empty($m->values['Date of Progression/Recurrence Date']) 
		&& empty($m->values['Site 1 of Primary Tumor Progression (metastasis)  If Applicable'])
		&& empty($m->values['Site 2 of Primary Tumor Progression (metastasis)  If applicable'])
	){
		excelDateFix($m);
		return true;
	}
	return false;
}

