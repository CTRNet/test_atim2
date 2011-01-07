<?php
$diagnoses["app_data"]["file"] = "1";
$diagnoses["app_data"]["pkey"] = "Patient Biobank Number
(required)";

$diagnoses["master"]["diagnosis_control_id"] = "@14";
$diagnoses["master"]["dx_date"] = "Date of EOC Diagnosis Date";
$diagnoses["master"]["dx_date_accuracy"] = "Date of EOC Diagnosis Accuracy";
$diagnoses["master"]["age_at_dx"] = "Age at Time of Diagnosis (yr)";

$diagnoses["detail"]["date_of_progression_recurrence"] = "Date of Progression/Recurrence Date";
$diagnoses["detail"]["date_of_progression_recurrence_accuracy"] = "Date of Progression/Recurrence Accuracy";
$diagnoses["detail"]["date_of_ca125_progression"] = "Date of Progression of CA125 Date";
$diagnoses["detail"]["date_of_ca125_progression_aacu"] = "Date of Progression of CA125 Accuracy";
$diagnoses["detail"]["ca125_progression_time_in_months"] = "???";
$diagnoses["detail"]["presence_of_precursor_of_benign_lesions"] = "Presence of precursor of benign lesions";
$diagnoses["detail"]["fallopian_tube_lesion"] = "fallopian tube lesions";
$diagnoses["detail"]["laterality"] = "Laterality";
$diagnoses["detail"]["histopathology"] = "Histopathology";
$diagnoses["detail"]["tumor_grade"] = "Grade";
$diagnoses["detail"]["figo"] = "FIGO";
$diagnoses["detail"]["residual_disease"] = "Residual Disease";
$diagnoses["detail"]["site_1_of_tumor_progression"] = "Site 1 of Primary Tumor Progression (metastasis)  If Applicable";
$diagnoses["detail"]["site_2_of_tumor_progression"] = "Site 2 of Primary Tumor Progression (metastasis)  If applicable";
$diagnoses["detail"]["progression_time_in_months"] = "progression time (months)";
$diagnoses["detail"]["follow_up_from_ovarectomy_in_months"] = "Follow-up from ovarectomy (months)";
$diagnoses["detail"]["survival_from_ovarectomy_in_months"] = "Survival from ovarectomy (months)";

//do not modify this section
$diagnoses["app_data"]['parent_key'] = "participant_id";
$diagnoses["app_data"]['child'] = array();
$diagnoses["app_data"]['master_table_name'] = "diagnosis_masters";
$diagnoses["app_data"]['save_id'] = true;
$tables['qc_tf_dxd_eocs'] = $diagnoses;
//-------------------------------


