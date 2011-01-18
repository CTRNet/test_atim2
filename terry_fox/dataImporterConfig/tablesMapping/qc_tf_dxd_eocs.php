<?php
$pkey = "Patient Biobank Number
(required)";
$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@14",
	"dx_date" => "Date of EOC Diagnosis Date",
	"dx_date_accuracy" => "Date of EOC Diagnosis Accuracy",
	"age_at_dx" => "Age at Time of Diagnosis (yr)"
);

$detail_fields = array(
	"date_of_progression_recurrence" => "Date of Progression/Recurrence Date",
	"date_of_progression_recurrence_accuracy" => "Date of Progression/Recurrence Accuracy",
	"date_of_ca125_progression" => "Date of Progression of CA125 Date",
	"date_of_ca125_progression_accu" => "Date of Progression of CA125 Accuracy",
	"ca125_progression_time_in_months" => "CA125 progression time (months)",
	"presence_of_precursor_of_benign_lesions" => "Presence of precursor of benign lesions",
	"fallopian_tube_lesion" => "fallopian tube lesions",
	"laterality" => "Laterality",
	"histopathology" => "Histopathology",
	"tumor_grade" => "Grade",
	"figo" => "FIGO ",
	"residual_disease" => "Residual Disease",
	"site_1_of_tumor_progression" => "Site 1 of Primary Tumor Progression (metastasis)  If Applicable",
	"site_2_of_tumor_progression" => "Site 2 of Primary Tumor Progression (metastasis)  If applicable",
	"progression_time_in_months" => "progression time (months)",
	"follow_up_from_ovarectomy_in_months" => "Follow-up from ovarectomy (months)",
	"survival_from_ovarectomy_in_months" => "Survival from diagnosis (months)",
);

$tables['qc_tf_dxd_eocs'] = new MasterDetailModel(1, $pkey, array(), false, "participant_id", 'diagnosis_masters', $fields, 'qc_tf_dxd_eocs', 'diagnosis_master_id', $detail_fields);
$tables['qc_tf_dxd_eocs']->custom_data = array("date_fields" => array(
	$fields["dx_date"], 
	$detail_fields["date_of_progression_recurrence"], 
	$detail_fields["date_of_ca125_progression"]));
$tables['qc_tf_dxd_eocs']->post_read_function = 'postRead';

