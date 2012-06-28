<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'event_control_id'		=> '#event_control_id',
	'diagnosis_master_id'	=> $pkey,

	'event_date' 			=> 'Dates of event Date of event (beginning)',
	'event_date_accuracy' 	=> array('Dates of event Accuracy (beginning)' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
);
$detail_fields = array(
	'psa_ng_per_ml'	=> 'PSA (ng/ml)'
);

$model = new MasterDetailModel(2, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'event_masters', $fields, 'qc_tf_ed_psa', 'event_master_id', $detail_fields);
	$model->custom_data = array(
		"date_fields" => array(
			$fields["event_date"]	=> key($fields["event_date_accuracy"])
	)
);

$model->post_read_function = 'eventPsaPostRead';
$model->insert_condition_function = 'eventPsaInsertCondition';
Config::addModel($model, 'event_psa');

function eventPsaPostRead(Model $m){
	global $connection;
	if(empty($m->values['PSA (ng/ml)'])){
		return false;
	}
	if(!preg_match('/^([0-9]*)(\.[0-9]+){0,1}$/', $m->values['PSA (ng/ml)'], $matches)) {
		Config::$summary_msg['event: PSA']['@@WARNING@@']['value error'][] = "See value [".$m->values['PSA (ng/ml)']."] at line ".$m->line.".";
		$m->values['PSA (ng/ml)'] = '';
	}
	
	excelDateFix($m);
	
	return true;
}

function eventPsaInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['event_control_id'] = Config::$event_controls['lab']['psa']['general']['id'];
	return true;
}
