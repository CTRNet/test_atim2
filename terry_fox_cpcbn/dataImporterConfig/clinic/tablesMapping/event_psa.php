<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'event_control_id'		=> '#event_control_id',
	'diagnosis_master_id'	=> $pkey,

	'event_date' 			=> 'Dates of event Date of event (beginning)',
	'event_date_accuracy' 	=> array('Dates of event Accuracy (beginning)' => array("c" => "c", "y" => "m", "m" => "d", "" => "")),
		
	'event_summary'			=> 'note'
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
	if(!strlen($m->values['PSA (ng/ml)'])){
		return false;
	}
	$m->values['PSA (ng/ml)'] = str_replace(',', '.', $m->values['PSA (ng/ml)']);
	if(preg_match('/^<([0-9]*)(\.[0-9]+){0,1}$/', $m->values['PSA (ng/ml)'], $matches)) {
		$new_psa = str_replace('<', '', $m->values['PSA (ng/ml)']);
		Config::$summary_msg['event: PSA']['@@WARNING@@']['value defined as inferior than a value'][] = "Will change value [".$m->values['PSA (ng/ml)']."] to  [$new_psa] at line ".$m->line.".";
		$m->values['PSA (ng/ml)'] = str_replace('<', '', $m->values['PSA (ng/ml)']);
	} else if(!preg_match('/^([0-9]*)(\.[0-9]+){0,1}$/', $m->values['PSA (ng/ml)'], $matches)) {
		Config::$summary_msg['event: PSA']['@@WARNING@@']['value error'][] = "Decimal expected. See value [".$m->values['PSA (ng/ml)']."] at line ".$m->line.".";
		$m->values['PSA (ng/ml)'] = '';
	}
	if(empty($m->values['Dates of event Date of event (beginning)'])) Config::$summary_msg['event: PSA']['@@WARNING@@']['date missing'][] = "PSA date is missing. See line ".$m->line.".";
	
	$m->values['note'] = utf8_encode($m->values['note']);
	
	excelDateFix($m);
	
	return true;
}

function eventPsaInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['event_control_id'] = Config::$event_controls['lab']['psa']['id'];
	return true;
}
