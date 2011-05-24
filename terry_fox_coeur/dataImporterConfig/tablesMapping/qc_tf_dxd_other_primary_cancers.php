<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@15",
	"dx_date" => "Date of Diagnosis Date",
	"dx_date_accuracy" => array("Date of Diagnosis Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"age_at_dx" => "Age at Time of Diagnosis (yr)",
	"tumour_grade" => array("Grade" => new ValueDomain('0_to_3', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"path_stage_summary" => array("Stage" => new ValueDomain('qc_tf_stage', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
);

$detail_fields = array(
	"date_of_progression_recurrence" => "Date of Progression/Recurrence	Date",
	"date_of_progression_recurrence_accuracy" => array("Date of Progression/Recurrence Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"tumor_site" => array("Tumor Site" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"laterality" => array("Laterality" => new ValueDomain('qc_tf_laterality', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"histopathology" => array("Histopathology" => new ValueDomain('qc_tf_histopathology_opc', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"site_of_tumor_progression" => array("Site of Tumor Progression (metastasis)  If Applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"survival_in_months" => "Survival (months)"
);


$model = new MasterDetailModel(3, $pkey, array(), false, "participant_id", 'diagnosis_masters', $fields, 'qc_tf_dxd_other_primary_cancers', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> $fields["dx_date_accuracy"], 
	$detail_fields["date_of_progression_recurrence"]	=> $detail_fields["date_of_progression_recurrence_accuracy"]));
$model->post_read_function = 'excelDateFix';

Config::$models['qc_tf_dxd_other_primary_cancers'] = $model;