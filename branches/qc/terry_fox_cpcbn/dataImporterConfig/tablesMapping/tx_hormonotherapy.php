<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'treatment_control_id'	=> '#treatment_control_id',
	'diagnosis_master_id'	=> $pkey,

	'start_date' 			=> 'Dates of event Date of event (beginning)',
	'start_date_accuracy' 	=> array('Dates of event Accuracy (beginning)' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'finish_date' 			=> 'Dates of event Date of event (end)',
	'finish_date_accuracy'	=> array('Dates of event Accuracy (end)' => array("c" => "c", "y" => "y", "m" => "m", "" => ""))
);
$detail_fields = array();

$model = new MasterDetailModel(2, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'treatment_masters', $fields, 'qc_tf_txd_hormonotherapies', 'treatment_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["start_date"]	=> key($fields["start_date_accuracy"]),
		$fields['finish_date']	=> key($fields['finish_date_accuracy']))
);

$model->post_read_function = 'txHormonotherapyPostRead';
$model->insert_condition_function = 'txHormonotherapyInsertCondition';
Config::addModel($model, 'tx_hormonotherapy');

function txHormonotherapyPostRead(Model $m){
	if(in_array($m->values['hormonotherapy'], array('no', 'unknown', ''))){
		return false;
	}
	if($m->values['hormonotherapy'] != 'yes'){
		echo 'WARNING: Unknwon value ['.$m->values['hormonotherapy'].'] for hormonotherapy in event at line ['.$m->line."]".Config::$line_break_tag;
	}
	
	excelDateFix($m);

	return true;
}

function txHormonotherapyInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['treatment_control_id'] = Config::$tx_controls['hormonotherapy']['general']['id'];
	return true;
}









