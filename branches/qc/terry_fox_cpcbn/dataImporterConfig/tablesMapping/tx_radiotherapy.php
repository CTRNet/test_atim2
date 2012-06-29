<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'treatment_control_id'	=> '#treatment_control_id', //biopsy
	'diagnosis_master_id'	=> $pkey,
				
	'start_date' 			=> 'Dates of event Date of event (beginning)',
	'start_date_accuracy' 	=> array('Dates of event Accuracy (beginning)' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'finish_date' 			=> 'Dates of event Date of event (end)',
	'finish_date_accuracy'	=> array('Dates of event Accuracy (end)' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
		
	'notes' 				=> 'note'
);
$detail_fields = array(
	'qc_tf_dose_cg' => 'radiotherapy dose'
);

$model = new MasterDetailModel(2, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'treatment_masters', $fields, 'txd_radiations', 'treatment_master_id', $detail_fields);
	$model->custom_data = array(
		"date_fields" => array(
			$fields["start_date"]	=> key($fields["start_date_accuracy"]),
			$fields['finish_date']	=> key($fields['finish_date_accuracy'])),
		'previous_line' => null,
);

$model->post_read_function = 'txRadiotherapyPostRead';
$model->insert_condition_function = 'txRadiotherapyInsertCondition';
Config::addModel($model, 'tx_radiotherapy');

function txRadiotherapyPostRead(Model $m){
	if(!is_null($m->custom_data['previous_line']) && $m->custom_data['previous_line'] != ($m->line - 1)) {
		Config::$summary_msg['event']['@@ERROR@@']['Missing Patient # in biobank'][] = "Check patient # is set or data exists. See line ".($m->line-1).".";
	}
	$m->custom_data['previous_line'] = $m->line;
	if($m->values['Radiotherapy'] != 'yes' && $m->values['hormonotherapy'] != 'yes' && $m->values['chemiotherapy'] != 'yes' && !preg_match('/^[0-9\.]+$/', $m->values['PSA (ng/ml)'],$matches)) {
		Config::$summary_msg['event']['@@WARNING@@']['No data to import'][] = "No data will be imported because no event is defined. See line ".$m->line.".";
		return false;
	}

	if(in_array($m->values['Radiotherapy'], array('no', 'unknown', ''))){
		return false;
	}
	if($m->values['Radiotherapy'] != 'yes'){
		echo 'WARNING: Unknwon value ['.$m->values['radiotherapy'].'] for radiotherapy in event at line ['.$m->line."]".Config::$line_break_tag;
	}
	if(!preg_match('/^([0-9]*)$/', $m->values['radiotherapy dose'], $matches)) {
		Config::$summary_msg['event: radiotherapy']['@@WARNING@@']['value error'][] = "Integer expected. See value [".$m->values['radiotherapy dose']."] at line ".$m->line.".";
		$m->values['radiotherapy dose'] = '';
	}	
	if(empty($m->values['Dates of event Date of event (beginning)'])) Config::$summary_msg['event: radiotherapy']['@@ERROR@@']['date missing'][] = "Date is missing. See line ".$m->line.".";
	excelDateFix($m);
	
	return true;
}

function txRadiotherapyInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['treatment_control_id'] = Config::$tx_controls['radiation']['general']['id'];
	return true;
}
