<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => "@36",
	"event_date" => "Date of event (beginning) Date",
	"event_type" => "@other primary cancer",
	"event_group" => "@clinical"
);

$detail_fields = array(
	"date_accuracy" => array("Date of event (beginning) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"end_date" => "Date of event (end) Date",
	"end_date_accuracy" => array("Date of event (end) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"drug1" => array("Chimiotherapy Precision Drug1" => new ValueDomain('qc_tf_other_primary_cancer_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"drug2" => array("Chimiotherapy Precision Drug2" => new ValueDomain('qc_tf_other_primary_cancer_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"drug3" => array("Chimiotherapy Precision Drug3" => new ValueDomain('qc_tf_other_primary_cancer_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"drug4" => array("Chimiotherapy Precision Drug4" => new ValueDomain('qc_tf_other_primary_cancer_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"m_event_type" => array("Event Type" => new ValueDomain('qc_tf_other_primary_cancer_event_type', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);



$model = new MasterDetailModel(4, $pkey, array(), false, "participant_id", 'event_masters', $fields, 'qc_tf_ed_other_primary_cancers', 'event_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array(
	$fields["event_date"]		=> $detail_fields["date_accuracy"], 
	$detail_fields["end_date"]	=> $detail_fields["end_date_accuracy"]));
$model->post_read_function = 'excelDateFix';

Config::$models['qc_tf_ed_other_primary_cancers'] = $model;