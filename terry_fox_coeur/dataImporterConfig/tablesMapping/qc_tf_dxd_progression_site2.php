<?php
//progression recurrence EOC - DX for site 2
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"participant_id" => "#participant_id",
	"primary_number" => "#primary_number",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression/Recurrence Date",
	"dx_date_accuracy" => array("Date of Progression/Recurrence Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_tumor_site" => array("Site 2 of Primary Tumor Progression (metastasis)  If applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_dx_origin" => '@progression',
	'qc_tf_progression_detection_method' => '#qc_tf_progression_detection_method'
);

$model = new MasterDetailModel(1, $pkey, array(), false, null, $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> current(array_keys($fields["dx_date_accuracy"])),
	'Date of EOC Diagnosis Date'						=> null) 
); 

$model->post_read_function = 'progressionSiteNumPostRead';
$model->insert_condition_function = 'progressionSiteInsertNow';
$model->custom_data['site_label'] = 'Site 2 of Primary Tumor Progression (metastasis)  If applicable';

Config::$models['qc_tf_dxd_progression_site2'] = $model;
