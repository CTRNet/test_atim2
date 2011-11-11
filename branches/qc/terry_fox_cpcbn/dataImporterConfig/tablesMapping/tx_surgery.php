<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' => $pkey,
	'start_date' => 'Surgery/Biopsy Date of surgery/biopsy',
	'start_date_accuracy' => array('Surgery/Biopsy Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_master_id' => '#diagnosis_master_id',
	'tx_control_id' => '@3'//radiotherapy
);
$detail_fields = array(
	'qc_tf_type' => array('Surgery/Biopsy Type of surgery' => new ValueDomain('qc_tf_surgery_type', ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);

function txSurgeryPostRead(Model $m){
	global $connection;
	if(in_array($m->values['Surgery/Biopsy Type of surgery'], array('biopsy', ''))){
		return false;
	}
	
	excelDateFix($m);
	return true;
}

function txSurgeryInsertCondition(Model $m){
	$m->values['diagnosis_master_id'] = $m->parent_model->custom_data['diagnosis_master_id'];
	if($m->parent_model->custom_data['diagnosis_master_id'] == null){
		echo 'WARNING: tx surgery at line ['.$m->line."] has no associated primary dx\n";
	}
	
	return true;
}

$model = new MasterDetailModel(1, $pkey, $child, false, 'participant_id', $pkey, 'tx_masters', $fields, 'txd_surgeries', 'tx_master_id', $detail_fields);
	$model->custom_data = array(
		"date_fields" => array(
			$fields["start_date"]	=> key($fields["start_date_accuracy"]),
	)
);

$model->post_read_function = 'txSurgeryPostRead';
$model->insert_condition_function = 'txSurgeryInsertCondition';
Config::addModel($model, 'tx_surgery');
