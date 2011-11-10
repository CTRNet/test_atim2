<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' => '#participant_id',
	'dx_date' => 'Date of biochemical recurrence Date',
	'dx_date_accuracy' => array('Date of biochemical recurrence Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_control_id' => '@22', //Recurrence - Biochemical
	'parent_id'	=> $pkey
);

$detail_fields = array(
	'type'	=> array('Date of biochemical recurrence Definition' => array(
		'Phoenix definition' => 'Phoenix definition', 
		'first PSA of at least 0.2 and rising' => 'qc_tf_first_psa_2',
		'first PSA of at least 0.3 followed by another increase' => 'qc_tf_first_psa_3',
		'PSA follow by a  treatment' => 'PSA follow by a treatment',
		'' => ''))
);



function dxRecurrencePostRead(Model $m){
	if(in_array($m->values['Date of biochemical recurrence Date'], array('', 'none', 'unknown'))){
		return false;
	}
	
	excelDateFix($m);
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	
	return true;
}

function dxRecurrencePostWrite(Model $m){
	die('DEAD');
}

$model = new MasterDetailModel(1, $pkey, $child, false, 'parent_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_recurrence_bio', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array(
	'date_fields' => array(
		$fields["dx_date"]		=> key($fields['dx_date_accuracy'])
	)
);

$model->post_read_function = 'dxRecurrencePostRead';
// $model->post_write_function = 'dxRecurrencePostWrite';
Config::addModel($model, 'dx_recurrence');
