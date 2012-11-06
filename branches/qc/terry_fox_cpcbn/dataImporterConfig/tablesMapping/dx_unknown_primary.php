<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> $pkey,
	'dx_date' 				=> 'Date of diagnostics Date',
	'dx_date_accuracy'		=> array('Date of diagnostics Accuracy' => array("c" => "c", "y" => "m", "m" => "d", "" => "")),
	'diagnosis_control_id'	=> '#diagnosis_control_id', 
	'age_at_dx' 			=> 'Age at Time of Diagnosis (yr)'
);

$detail_fields = array();

$model = new MasterDetailModel(4, $pkey, $child, false, 'participant_id', $pkey, 'diagnosis_masters', $fields, 'dxd_primaries', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"]	=> key($fields["dx_date_accuracy"])
	), 
	'previous_line' => null
);

$model->post_read_function = 'postUnknownDxRead';
$model->post_write_function = 'postUnknownDxWrite';
Config::addModel($model, 'dx_unknown_primary');

function postUnknownDxRead(Model $m){
	if(!is_null($m->custom_data['previous_line']) && $m->custom_data['previous_line'] != ($m->line - 1)) {
		pr("postOtherDxRead: Check patient # is set or data exists. See line ".($m->line-1).".");
		pr($m->values);
		pr($m->line - 1);
		exit;
		Config::$summary_msg['other cancer']['@@ERROR@@']['Missing Patient # in biobank'][] = "Check patient # is set or data exists. See line ".($m->line-1).".";
	}
	$m->custom_data['previous_line'] = $m->line;
	
	if($m->values['cancer type'] != 'Other-Primary Unknown') return false;
	
	excelDateFix($m);
	
	$m->values['diagnosis_control_id'] = Config::$dx_controls['primary']['primary diagnosis unknown']['id'];
	
	if(!empty($m->values['Age at Time of Diagnosis (yr)'])) Config::$summary_msg['other cancer']['@@WARNING@@']['primary diagnosis unknown & Age at Time of Diagnosis'][] = "A value for field 'Age at Time of Diagnosis (yr)' is defined for an unknown primary. Value won't be imported.";
	$m->values['Age at Time of Diagnosis (yr)'] = '';
	
	return true;
}

function postUnknownDxWrite(Model $m){
	return true;
}