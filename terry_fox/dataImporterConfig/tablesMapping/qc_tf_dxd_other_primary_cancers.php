<?php
$qc_tf_dxd_other_primary_cancers["app_data"]["file"] = "3";
$qc_tf_dxd_other_primary_cancers["app_data"]["pkey"] = "Patient Biobank Number
(required)";

$qc_tf_dxd_other_primary_cancers["master"]["diagnosis_control_id"] = "@15";
$qc_tf_dxd_other_primary_cancers["master"]["dx_date"] = "Date of Diagnosis Date";
$qc_tf_dxd_other_primary_cancers["master"]["dx_date_accuracy"] = "Date of Diagnosis Date Accuracy";
$qc_tf_dxd_other_primary_cancers["master"]["age_at_dx"] = "Age at Time of Diagnosis (yr)";
$qc_tf_dxd_other_primary_cancers["master"]["tumour_grade"] = "Grade";
$qc_tf_dxd_other_primary_cancers["master"]["path_stage_summary"] = "Stage";

$qc_tf_dxd_other_primary_cancers["detail"]["date_of_progression_recurrence"] = "Date of Progression/Recurrence Date";
$qc_tf_dxd_other_primary_cancers["detail"]["date_of_progression_recurrence_accuracy"] = "Date of Progression/Recurrence Accuracy";
$qc_tf_dxd_other_primary_cancers["detail"]["tumor_site"] = "Tumor Site";
$qc_tf_dxd_other_primary_cancers["detail"]["laterality"] = "Laterality";
$qc_tf_dxd_other_primary_cancers["detail"]["histopathology"] = "Histopathology";
$qc_tf_dxd_other_primary_cancers["detail"]["site_of_tumor_progression"] = "Site of Tumor Progression (metastasis)  If Applicable";
$qc_tf_dxd_other_primary_cancers["detail"]["survival_in_months"] = "Survival (months)";

//do not modify this section
$qc_tf_dxd_other_primary_cancers["app_data"]['parent_key'] = "participant_id";
$qc_tf_dxd_other_primary_cancers["app_data"]['child'] = array();
$qc_tf_dxd_other_primary_cancers["app_data"]['master_table_name'] = "diagnosis_masters";
$qc_tf_dxd_other_primary_cancers["app_data"]['save_id'] = true;
$tables['qc_tf_dxd_other_primary_cancers'] = $qc_tf_dxd_other_primary_cancers;
//-------------------------------


