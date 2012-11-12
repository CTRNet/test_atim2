<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> $pkey,
	'dx_date' 				=> 'Date of diagnostics Date',
	'dx_date_accuracy'		=> array('Date of diagnostics Accuracy' => array("c" => "c", "y" => "m", "m" => "d", "" => "")),
	'diagnosis_control_id'	=> '#diagnosis_control_id', 
//	'age_at_dx' 			=> 'Age at Time of Diagnosis (yr)'
	'age_at_dx' 			=> '#age_at_dx'	
);

$detail_fields = array(
	'type' => array('cancer type' => new ValueDomain('ctrnet_submission_disease_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE))
);

$model = new MasterDetailModel(4, $pkey, $child, false, 'participant_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_others', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"]	=> key($fields["dx_date_accuracy"])
	), 
	'previous_line' => null
);

$model->post_read_function = 'postOtherDxRead';
$model->insert_condition_function = 'preOtherDxWrite';
$model->post_write_function = 'postOtherDxWrite';
Config::addModel($model, 'dx_other_primary');

function postOtherDxRead(Model $m){
	if(!is_null($m->custom_data['previous_line']) && $m->custom_data['previous_line'] != ($m->line - 1)) {
		pr("postOtherDxRead: Check patient # is set or data exists. See line ".($m->line-1).".");
		pr($m->values);
		pr($m->line - 1);
		exit;
		Config::$summary_msg['other cancer']['@@ERROR@@']['Missing Patient # in biobank'][] = "Check patient # is set or data exists. See line ".($m->line-1).".";
	}
	$m->custom_data['previous_line'] = $m->line;
	
	if($m->values['cancer type'] == 'Other-Primary Unknown') return false;
	
	excelDateFix($m);
	
// 	if(!preg_match('/^([0-9]*)(\.[0-9]+){0,1}$/', $m->values['Age at Time of Diagnosis (yr)'], $matches)) {
// 		Config::$summary_msg['other cancer']['@@WARNING@@']['Age at Time of Diagnosis: wrong format'][] = "Decimal expected. See value [".$m->values['Age at Time of Diagnosis (yr)']."] at line ".$m->line.".";
// 		$m->values['Age at Time of Diagnosis (yr)'] = '';
// 	} else if(isset($matches[2])) {
// 		Config::$summary_msg['other cancer']['@@MESSAGE@@']['Age at Time of Diagnosis: decimal'][] = "See value [".$m->values['Age at Time of Diagnosis (yr)']."] changed to [".$matches[1]."] at line ".$m->line.".";
// 		$m->values['Age at Time of Diagnosis (yr)'] = $matches[1];
// 	}
	
	if(in_array($m->values['cancer type'], array('prostate'))) {
		die("TODO: to support other cancer like 'prostate','Other-Primary Unknown'.");
	} else {
		$m->values['diagnosis_control_id'] = Config::$dx_controls['primary']['other']['id'];
		$m->values['cancer type'] = strtolower(str_replace('-',' - ', $m->values['cancer type']));
	}
	
	return true;
}

function preOtherDxWrite(Model $m){
	$m->values['age_at_dx'] = getAgeAtDx($m->parent_model->values['Date of Birth Date'], $m->parent_model->values['Date of Birth Accuracy'], $m->values['Date of diagnostics Date'], $m->values['Date of diagnostics Accuracy'], 'other cancer', $m->line);
	return true;
}

function postOtherDxWrite(Model $m){
	return true;
}