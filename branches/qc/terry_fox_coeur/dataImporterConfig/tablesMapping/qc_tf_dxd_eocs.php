<?php
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@14",
	"dx_date" => "Date of EOC Diagnosis Date",
	"dx_date_accuracy" => array("Date of EOC Diagnosis Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"age_at_dx" => "Age at Time of Diagnosis (yr)",
	"tumour_grade" => array("Grade" => new ValueDomain('0_to_3', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);

$detail_fields = array(
	"date_of_progression_recurrence" => "Date of Progression/Recurrence Date",
	"date_of_progression_recurrence_accuracy" => array("Date of Progression/Recurrence Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"date_of_ca125_progression" => "Date of Progression of CA125 Date",
	"date_of_ca125_progression_accu" => array("Date of Progression of CA125 Accuracy"=> array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"ca125_progression_time_in_months" => "CA125 progression time (months)",
	"presence_of_precursor_of_benign_lesions" => array("Presence of precursor of benign lesions" => new ValueDomain('qc_tf_presence_of_precursor_of_benign_lesions', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"fallopian_tube_lesion" => array("fallopian tube lesions" => new ValueDomain('qc_tf_fallopian_tube_lesion', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"laterality" => array("Laterality" => new ValueDomain('qc_tf_laterality', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"histopathology" => array("Histopathology" => new ValueDomain('qc_tf_histopathology', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"figo" => array("FIGO " => new ValueDomain('qc_tf_figo', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"residual_disease" => array("Residual Disease" => new ValueDomain('qc_tf_residual_disease', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"site_1_of_tumor_progression" => array("Site 1 of Primary Tumor Progression (metastasis)  If Applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"site_2_of_tumor_progression" => array("Site 2 of Primary Tumor Progression (metastasis)  If applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"progression_time_in_months" => "progression time (months)",
	"follow_up_from_ovarectomy_in_months" => "Follow-up from ovarectomy (months)",
	"survival_from_ovarectomy_in_months" => "Survival from diagnosis (months)",
	"progression_status" => array("Progression status" => new ValueDomain('qc_tf_progression_status', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);

$model = new MasterDetailModel(1, $pkey, array(), false, "participant_id", 'diagnosis_masters', $fields, 'qc_tf_dxd_eocs', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> $fields["dx_date_accuracy"], 
	$detail_fields["date_of_progression_recurrence"]	=> $detail_fields["date_of_progression_recurrence_accuracy"], 
	$detail_fields["date_of_ca125_progression"]			=> $detail_fields["date_of_ca125_progression_accu"]));
$model->post_read_function = 'excelDateFix';

Config::$models['qc_tf_dxd_eocs'] = $model;