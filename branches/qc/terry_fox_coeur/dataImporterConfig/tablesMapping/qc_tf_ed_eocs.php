<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"event_control_id" => "@35",
	"event_date" => "Date of event (beginning) Date",
	"event_type" => "@eoc",
	"event_group" => "@clinical"
);

$detail_fields = array(
	"date_accuracy" => array("Date of event (beginning) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"event_date_end" => "Date of event (end) Date",
	"event_date_end_accuracy" => array("Date of event (end) Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"drug1" => array("Chimiotherapy Precision Drug1" => new ValueDomain('qc_tf_eoc_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"drug2" => array("Chimiotherapy Precision Drug2" => new ValueDomain('qc_tf_eoc_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"drug3" => array("Chimiotherapy Precision Drug3" => new ValueDomain('qc_tf_eoc_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"drug4" => array("Chimiotherapy Precision Drug4" => new ValueDomain('qc_tf_eoc_event_drug', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"ca125_precision" => "CA125  Precision (U)",
	"ct_scan_precision" => array("CT Scan Precision" => new ValueDomain('qc_tf_ct_scan_precision', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"m_event_type" => array("Event Type" => new ValueDomain('qc_tf_eoc_event_type', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);


$model = new MasterDetailModel(2, $pkey, array(), false, "participant_id", 'event_masters', $fields, 'qc_tf_ed_eocs', 'event_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array(
	$fields["event_date"]				=> current(array_keys($detail_fields["date_accuracy"])), 
	$detail_fields["event_date_end"]	=> current(array_keys($detail_fields["event_date_end_accuracy"]))));
$model->post_read_function = 'edEocsAfterRead';

Config::$models['qc_tf_ed_eocs'] = $model;

function edEocsAfterRead(Model $m){
	for($i = 1; $i <= 4; $i ++){
		if($m->values['Chimiotherapy Precision Drug'.$i] == 'Carboplatin'){
			$m->values['Chimiotherapy Precision Drug'.$i] = 'carboplatinum';
		}
	}
	
	excelDateFix($m);
}