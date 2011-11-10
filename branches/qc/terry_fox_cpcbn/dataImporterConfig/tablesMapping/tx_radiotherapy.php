<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' => $pkey,
	'start_date' => 'Dates of event Date of event (beginning)',
	'start_date_accuracy' => array('Dates of event Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'finish_date' => 'Dates of event Date of event (end)',
	'finish_date_accuracy' => array('Dates of event Accuracy End' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_master_id' => '#diagnosis_master_id',
	'tx_control_id' => '@2',//radiotherapy
	'notes'	=> 'note'
);
$detail_fields = array(
	'qc_tf_dose' => 'radiotherapy dose'
);

function txRadiotherapyPostRead(Model $m){
	global $connection;
	if(in_array($m->values['Radiotherapy'], array('no', 'unknown', ''))){
		return false;
	}
	
	if($m->values['Radiotherapy'] != 'yes'){
		echo 'WARNING: Unknwon value ['.$m->values['radiotherapy'].'] for radiotherapy in event at line ['.$m->line."]\n";
	}
	
	excelDateFix($m);
	if($m->parent_model->custom_data['diagnosis_master_id'] == null){
		$m->values['diagnosis_master_id'] = null;
		echo 'WARNING: tx radiotherapy at line ['.$m->line."] has no associated primary dx\n";
	}else{
		$m->values['diagnosis_master_id'] = $m->parent_model->custom_data['diagnosis_master_id'];
	}
	
	return true;
}

$model = new MasterDetailModel(2, $pkey, $child, false, 'participant_id', $pkey, 'tx_masters', $fields, 'txd_radiations', 'tx_master_id', $detail_fields);
	$model->custom_data = array(
		"date_fields" => array(
			$fields["start_date"]	=> key($fields["start_date_accuracy"]),
			$fields['finish_date']	=> key($fields['finish_date_accuracy'])
	)
);

$model->post_read_function = 'txRadiotherapyPostRead';
Config::addModel($model, 'tx_radiotherapy');
