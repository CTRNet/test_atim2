<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'treatment_control_id'	=> '@8', //TURP or RP
	'diagnosis_master_id'	=> $pkey,
	'start_date' 			=> 'Surgery/Biopsy Date of surgery/biopsy',
	'start_date_accuracy'	=> array('Surgery/Biopsy Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
);
$detail_fields = array(		
	'samples_number'	=> 'number of biospies (optional)'
);

$model = new MasterDetailModel(1, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'treatment_masters', $fields, 'qc_tf_txd_biopsies', 'treatment_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array($fields["start_date"]	=> key($fields["start_date_accuracy"])));

$model->post_read_function = 'txBiopsyPostRead';
$model->insert_condition_function = 'txBiopsyInsertCondition';
Config::addModel($model, 'tx_biopsy');

function txBiopsyPostRead(Model $m){
	switch($m->values['Surgery/Biopsy Type of surgery']) {
		case '':
			if(!empty($m->values['Surgery/Biopsy Date of surgery/biopsy'])) Config::$summary_msg['diagnosis: biopsy/surgery']['@@WARNING@@']['Unknown Type of Surgery'][] = "See line ".$m->line.".";
		case 'TURP':
		case 'RP':
			return false;
		case 'biopsy':
			break;
		default:
			printf("WARNING: Invalid Surgery/Biopsy Type of surgery value [%s] for dx at line [%d]\n", $m->values['Surgery/Biopsy Type of surgery'], $m->line);
			return false;
	}

	excelDateFix($m);
	
	if(!preg_match('/^[0-9]*$/', $m->values['number of biospies (optional)'], $matches)) {
		Config::$summary_msg['diagnosis: biopsy']['@@WARNING@@']['Number of biospies: wrong format'][] = "See value [".$m->values['number of biospies (optional)']."] at line ".$m->line.".";
		$m->values['number of biospies (optional)'] = '';
	}
	
	return true;
}

function txBiopsyInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	return true;
}














