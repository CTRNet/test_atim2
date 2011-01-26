<?php
$pkey = "Patient Biobank Number
(required)";

$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@15",
	"dx_date" => "Date of Diagnosis Date",
	"dx_date_accuracy" => "Date of Diagnosis Accuracy",
	"age_at_dx" => "Age at Time of Diagnosis (yr)",
	"tumour_grade" => "Grade",
	"path_stage_summary" => "Stage"
);

$detail_fields = array(
	"date_of_progression_recurrence" => "Date of Progression/Recurrence Date",
	"date_of_progression_recurrence_accuracy" => "Date of Progression/Recurrence Accuracy",
	"tumor_site" => "Tumor Site",
	"laterality" => "Laterality",
	"histopathology" => "Histopathology",
	"site_of_tumor_progression" => "Site of Tumor Progression (metastasis)  If Applicable",
	"survival_in_months" => "Survival (months)"
);


$tables['qc_tf_dxd_other_primary_cancers'] = new MasterDetailModel(3, $pkey, array(), false, "participant_id", 'diagnosis_masters', $fields, 'qc_tf_dxd_other_primary_cancers', 'diagnosis_master_id', $detail_fields);
$tables['qc_tf_dxd_other_primary_cancers']->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> $fields["dx_date_accuracy"], 
	$detail_fields["date_of_progression_recurrence"]	=> $detail_fields["date_of_progression_recurrence_accuracy"]));
$tables['qc_tf_dxd_other_primary_cancers']->post_read_function = 'postRead';