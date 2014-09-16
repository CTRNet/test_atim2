<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'diagnosis_control_id'	=> '#diagnosis_control_id', //Secondary - Metastasis
	'parent_id'				=> $pkey,
	'dx_date' 				=> 'Development of metastasis Date',
	'dx_date_accuracy'		=> array('Development of metastasis Accuracy' => array("c" => "c", "y" => "m", "m" => "d", "" => "")),
);
$detail_fields = array(
	'site'	=> array((Config::$active_surveillance_project? 'Development of metastasis Site' : 'Development of metastasis Type of metastasis') => new ValueDomain('qc_tf_metastasis_type', ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);

$model = new MasterDetailModel(1, $pkey, $child, false, 'parent_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_metastasis', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array($fields["dx_date"]	=> key($fields["dx_date_accuracy"])));

$model->post_read_function = 'dxMetastasisPostRead';
$model->insert_condition_function = 'dxMetastasisInsertCondition';
Config::addModel($model, 'dx_metastasis');

function dxMetastasisPostRead(Model $m){
	if(empty($m->values['Development of metastasis Type of metastasis']) || in_array($m->values['Development of metastasis Type of metastasis'], array('no ', 'no'))) {
		return false;
	} 
	
	$m->values['diagnosis_control_id'] = Config::$dx_controls['secondary']['other']['id'];
	
	excelDateFix($m);
	
	if(checkDuplicatedMetastasis($m->values, $m->line)) return false;
	
	return true;
}

function dxMetastasisInsertCondition(Model $m){

	
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	return true;
}

function checkDuplicatedMetastasis($values, $line) {
	$key = $values['Patient # in biobank'].'/'.
		$values['Development of metastasis Type of metastasis'].'/'.
		$values['Development of metastasis Date'].'/'.
		$values['Development of metastasis Accuracy'];
	if(in_array($key, Config::$metastatsis_controls)) {
		Config::$summary_msg['diagnosis: metastasis']['@@WARNING@@']['Duplicated metastasis'][] = "See metastasis [".$values['Development of metastasis Type of metastasis']."] for patient [".$values['Patient # in biobank']."] at line $line.";
		return true;
	} else {
		Config::$metastatsis_controls[] = $key;
		return false;
	}
}