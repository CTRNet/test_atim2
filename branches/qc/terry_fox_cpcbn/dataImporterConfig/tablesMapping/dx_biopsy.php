<?php
$pkey = "Patient # in biobank";
$child = array(
	
);
$fields = array(
	"participant_id" => $pkey,
	'event_date'	=> 'Surgery/Biopsy Date of surgery/biopsy',
	'event_date_accuracy' => array('Surgery/Biopsy Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'event_control_id' => '@51', //biopsy
	'diagnosis_master_id' => '#dx_master_id'	
);

function postDxBiopsyRead(Model $m){
	global $connection;
	if($m->values['Surgery/Biopsy Type of surgery'] != 'biopsy'){
		return false;
	}
	excelDateFix($m);
	
	return true;
}

function postDxBiopsyInsertCondition(Model $m){
	$m->values['dx_master_id'] = $m->parent_model->custom_data['diagnosis_master_id'];
	if($m->parent_model->custom_data['diagnosis_master_id'] == null){
		echo 'WARNING: dx_biopsy at line ['.$m->line."] has no associated primary dx\n";
	} 
	
	return true;
}

$model = new MasterDetailModel(1, $pkey, $child, false, 'participant_id', $pkey, 'event_masters', $fields, 'qc_tf_ed_biopsy', 'event_master_id', array());
$model->custom_data = array(
	'date_fields' => array(
		$fields["event_date"]		=> key($fields["event_date_accuracy"])
	)
);

$model->post_read_function = 'postDxBiopsyRead';
$model->insert_condition_function = 'postDxBiopsyInsertCondition';
Config::addModel($model, 'dx_biopsy');
