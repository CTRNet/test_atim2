<?php
$participants["app_data"]["pkey"] = "Patient Biobank Number
(required & unique)";
$participants["app_data"]["file"] = "0";

$participants["master"]["title"] = "";
$participants["master"]["first_name"] = "@MDEIE";
$participants["master"]["middle_name"] = "";
$participants["master"]["last_name"] = "MDEIE";
$participants["master"]["date_of_birth"] = "Date of Births Date";
$participants["master"]["dob_date_accuracy"] = "Date of Births date accuracy";
$participants["master"]["marital_status"] = "";
$participants["master"]["language_preferred"] = "";
$participants["master"]["sex"] = "";
$participants["master"]["race"] = "";
$participants["master"]["vital_status"] = "Death Death";
$participants["master"]["notes"] = "";
$participants["master"]["date_of_death"] = "Registered Date of Death Date";
$participants["master"]["dod_date_accuracy"] = "Registered Date of Death date accuracy";
$participants["master"]["cod_icd10_code"] = "";
$participants["master"]["secondary_cod_icd10_code"] = "";
$participants["master"]["cod_confirmation_source"] = "";
$participants["master"]["participant_identifier"] = "";
$participants["master"]["last_chart_checked_date"] = "";
$participants["master"]["qc_tf_suspected_date_of_death"] = "Suspected Date of Death Date";
$participants["master"]["qc_tf_sdod_accuracy"] = "Suspected Date of Death date accuracy";
$participants["master"]["qc_tf_family_history"] = "family history";
$participants["master"]["qc_tf_brca_status"] = "BRCA status";
$participants["master"]["qc_tf_last_contact"] = "Date of Last Contact Date";
$participants["master"]["qc_tf_last_contact_acc"] = "Date of Last Contact date accuracy";

//do not modify this section
$participants["app_data"]['child'][] = "consent_masters";
$participants["app_data"]['child'][] = "identifiers";
$participants["app_data"]['child'][] = "identifiers2";
$participants["app_data"]['child'][] = "diagnoses";
$participants["app_data"]['child'][] = "ed_lab_blood_report";
$participants["app_data"]['save_id'] = true;
$participants["app_data"]['master_table_name'] = "participants";
$tables['participants'] = $participants;
//-------------------------------
?>

