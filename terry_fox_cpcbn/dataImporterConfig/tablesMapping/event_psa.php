<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' => $pkey,
	'event_date' => 'Dates of event Date of event (beginning)',
	'event_date_accuracy' => array('Dates of event Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_master_id' => '#diagnosis_master_id',
	'event_control_id' => '@52'//psa
);
$detail_fields = array(
	'event_date_end' => 'Dates of event Date of event (end)',
	'event_date_end_accuracy' => array('Dates of event Accuracy End' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'psa_ng_per_ml' => 'PSA (ng/ml)'
);

function eventPsaPostRead(Model $m){
	global $connection;
	if(empty($m->values['PSA (ng/ml)'])){
		return false;
	}
	
	excelDateFix($m);
	
	return true;
}

function eventPsaInsertCondition(Model $m){
	$m->values['diagnosis_master_id'] = $m->parent_model->custom_data['diagnosis_master_id'];
	if($m->parent_model->custom_data['diagnosis_master_id'] == null){
		echo 'WARNING: event psa at line ['.$m->line."] has no associated primary dx\n";
	}
	
	return true;
}

$model = new MasterDetailModel(2, $pkey, $child, false, 'participant_id', $pkey, 'event_masters', $fields, 'qc_tf_ed_psa', 'event_master_id', $detail_fields);
	$model->custom_data = array(
		"date_fields" => array(
			$fields["event_date"]				=> key($fields["event_date_accuracy"]),
			$detail_fields['event_date_end']	=> key($detail_fields['event_date_end_accuracy'])
	)
);

$model->post_read_function = 'eventPsaPostRead';
$model->insert_condition_function = 'eventPsaInsertCondition';
Config::addModel($model, 'event_psa');
