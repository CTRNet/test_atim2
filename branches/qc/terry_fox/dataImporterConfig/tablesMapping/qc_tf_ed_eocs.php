<?php
$qc_tf_ed_eocs["app_data"]["file"] = "2";
$qc_tf_ed_eocs["app_data"]["pkey"] = "Patient Biobank Number
(required)";

$qc_tf_ed_eocs["master"]["event_control_id"] = "@35";
$qc_tf_ed_eocs["master"]["event_date"] = "Date of event (beginning) Date";
$qc_tf_ed_eocs["master"]["event_type"] = "Event Type";

$qc_tf_ed_eocs["detail"]["date_accuracy"] = "Date of event (beginning) Accuracy";
$qc_tf_ed_eocs["detail"]["event_date_end"] = "Date of event (end) Date";
$qc_tf_ed_eocs["detail"]["event_date_end_accuracy"] = "Date of event (end) Accuracy";
$qc_tf_ed_eocs["detail"]["drug1"] = "Chimiotherapy Precision Drug1";
$qc_tf_ed_eocs["detail"]["drug2"] = "Chimiotherapy Precision Drug2";
$qc_tf_ed_eocs["detail"]["drug3"] = "Chimiotherapy Precision Drug3";
$qc_tf_ed_eocs["detail"]["drug4"] = "Chimiotherapy Precision Drug4";
$qc_tf_ed_eocs["detail"]["ca125_precision"] = "CA125  Precision (U)";
$qc_tf_ed_eocs["detail"]["ct_scan_precision"] = "CT Scan Precision";


//do not modify this section
$qc_tf_ed_eocs["app_data"]['parent_key'] = "participant_id";
$qc_tf_ed_eocs["app_data"]['child'] = array();
$qc_tf_ed_eocs["app_data"]['master_table_name'] = "event_masters";
$qc_tf_ed_eocs["app_data"]['save_id'] = true;
$tables['qc_tf_ed_eocs'] = $qc_tf_ed_eocs;
//-------------------------------


