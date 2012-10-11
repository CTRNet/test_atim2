<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id'		=> '#participant_id',
	'dx_date'				=> 'Date of biochemical recurrence Date',
	'dx_date_accuracy'		=> array('Date of biochemical recurrence Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_control_id'	=> '@22', //Recurrence - Biochemical
	'parent_id'				=> $pkey
);

$detail_fields = array(
	'type'	=> array('Date of biochemical recurrence Definition' => new ValueDomain('qc_tf_date_biochemical_recurrence_definition', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE))
);

$model = new MasterDetailModel(1, $pkey, $child, false, 'parent_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_recurrence_bio', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array(
	'date_fields' => array(
		$fields["dx_date"]		=> key($fields['dx_date_accuracy'])
	)
);

$model->post_read_function = 'dxRecurrencePostRead';
$model->insert_condition_function = 'dxRecurrenceInsertCondition';
Config::addModel($model, 'dx_recurrence');

function dxRecurrencePostRead(Model $m){
	$tmp_biochemicar_rec_test = str_replace(' ','', $m->values['Date of biochemical recurrence Date']);
	if(in_array($m->values['Date of biochemical recurrence Date'], array('', 'none', 'unknown')) || empty($tmp_biochemicar_rec_test)){		
		if(!empty($m->values['Date of biochemical recurrence Definition'])) Config::$summary_msg['diagnosis: BCR']['@@WARNING@@']['no date'][] = "A BCR definition has been recorded without a date`data won't be imported. See line ".$m->line.".";
		return false;
	}
	
	$m->values['Date of biochemical recurrence Definition'] = str_replace(
		array('first PSA of at least 0.2 and rising','PSA follow by a  treatment','failed RP'),
		array('qc_tf_first_psa_2','PSA follow by a treatment','failed rp'),
		$m->values['Date of biochemical recurrence Definition']);
	$m->values['diagnosis_control_id'] = Config::$dx_controls['recurrence']['biochemical recurrence']['id'];
	excelDateFix($m);
	
	return true;
}

function dxRecurrenceInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	return true;
}