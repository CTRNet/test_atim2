<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'treatment_control_id'	=> '#treatment_control_id', //TURP or RP
	'diagnosis_master_id'	=> $pkey,
		
	'start_date' 			=> 'Surgery/Biopsy Date of surgery/biopsy',
	'start_date_accuracy'	=> array('Surgery/Biopsy Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
);
$detail_fields = array();

$model = new MasterDetailModel(1, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'treatment_masters', $fields, 'txd_surgeries', 'treatment_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array($fields["start_date"]	=> key($fields["start_date_accuracy"])));

$model->post_read_function = 'txSurgeryPostRead';
$model->insert_condition_function = 'txSurgeryInsertCondition';
Config::addModel($model, 'tx_surgery');

function txSurgeryPostRead(Model $m){
	switch($m->values['Surgery/Biopsy Type of surgery']) {
		case '':
		case 'biopsy':
			return false;
		case 'TURP':
			$m->values['treatment_control_id'] = Config::$tx_controls['surgery']['TURP']['id'];
			break;
		case 'RP':
			$m->values['treatment_control_id'] = Config::$tx_controls['surgery']['RP']['id'];
			break;
		default:
			printf("WARNING: Invalid Surgery/Biopsy Type of surgery value [%s] for dx at line [%d]".Config::$line_break_tag, $m->values['Surgery/Biopsy Type of surgery'], $m->line);
			return false;
	}
	if(empty($m->values['Surgery/Biopsy Date of surgery/biopsy'])) Config::$summary_msg['diagnosis: biopsy/surgery']['@@ERROR@@']['date missing'][] = "Date is missing. See line ".$m->line.".";
	excelDateFix($m);
	
	return true;
}

function txSurgeryInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	return true;
}














