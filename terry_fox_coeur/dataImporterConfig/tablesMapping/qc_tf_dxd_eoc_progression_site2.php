<?php
//progression recurrence EOC - DX for site 2
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"parent_id" => $pkey,
	"participant_id" => '#participant_id',
	"primary_id" => "#primary_id",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression/Recurrence Date",
	"dx_date_accuracy" => array("Date of Progression/Recurrence Accuracy" => Config::$coeur_accuracy_def),
	"qc_tf_tumor_site" => array("Site 2 of Primary Tumor Progression (metastasis)  If applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_dx_origin" => '@progression',
	'qc_tf_progression_detection_method' => '@site detection'
);

$model = new MasterDetailModel(1, $pkey, array(), false, 'parent_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());

$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"]))),
	'site_label' => 'Site 2 of Primary Tumor Progression (metastasis)  If applicable'
); 

$model->post_read_function = 'progressionSiteNumPostRead';
$model->insert_condition_function = 'eocProgressionInsertNow';

Config::$models['dxd_eoc_progression_site2'] = $model;
