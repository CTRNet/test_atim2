<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> $pkey,
	'start_date' 			=> 'Dates of event Date of event (beginning)',
	'start_date_accuracy' 	=> array('Dates of event Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'finish_date' 			=> 'Dates of event Date of event (end)',
	'finish_date_accuracy'	=> array('Dates of event Accuracy End' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_master_id' 	=> '#diagnosis_master_id',
	'tx_control_id' 		=> '@5'//hormonotherapy
);
$detail_fields = array(
);

function txHormonotherapyPostRead(Model $m){
	global $connection;
	if(in_array($m->values['hormonotherapy'], array('no', 'unknown', ''))){
		return false;
	}
	if($m->values['hormonotherapy'] != 'yes'){
		echo 'WARNING: Unknwon value ['.$m->values['hormonotherapy'].'] for hormonotherapy in event at line ['.$m->line."]\n";
	}
	
	excelDateFix($m);
	return true;
}

function txHormonotherapyInsertCondition(Model $m){
	$m->values['diagnosis_master_id'] = $m->parent_model->custom_data['diagnosis_master_id'];
	if($m->parent_model->custom_data['diagnosis_master_id'] == null){
		echo 'WARNING: tx hormonotherapy at line ['.$m->line."] has no associated primary dx\n";
	}
	
	return true;
}

$model = new MasterDetailModel(2, $pkey, $child, false, 'participant_id', $pkey, 'tx_masters', $fields, 'qc_tf_txd_hormonotherapy', 'tx_master_id', $detail_fields);
	$model->custom_data = array(
		"date_fields" => array(
			$fields["start_date"]	=> key($fields["start_date_accuracy"]),
			$fields['finish_date']	=> key($fields['finish_date_accuracy'])
	)
);

$model->post_read_function = 'txHormonotherapyPostRead';
$model->insert_condition_function = 'txHormonotherapyInsertCondition';
Config::addModel($model, 'tx_hormonotherapy');
