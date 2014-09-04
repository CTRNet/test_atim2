<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'treatment_control_id'	=> '#treatment_control_id',
	'diagnosis_master_id'	=> $pkey,

	'start_date' 			=> 'Dates of event Date of event (beginning)',
	'start_date_accuracy' 	=> array('Dates of event Accuracy (beginning)' => array("c" => "c", "y" => "m", "m" => "d", "" => "")),
	'finish_date' 			=> 'Dates of event Date of event (end)',
	'finish_date_accuracy'	=> array('Dates of event Accuracy (end)' => array("c" => "c", "y" => "m", "m" => "d", "" => "")),
		
	'notes' 				=> 'note'
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
$model->post_write_function = 'txHormonoPostWrite';
Config::addModel($model, 'tx_hormonotherapy');

function txHormonotherapyPostRead(Model $m){
	if(in_array($m->values['hormonotherapy'], array('no', 'unknown', ''))){
		return false;
	}
	if($m->values['hormonotherapy'] != 'yes'){
		echo 'WARNING: Unknwon value ['.$m->values['hormonotherapy'].'] for hormonotherapy in event at line ['.$m->line."]".Config::$line_break_tag;
	}
	if(empty($m->values['Dates of event Date of event (beginning)'])) Config::$summary_msg['event: hormonotherapy']['@@ERROR@@']['date missing'][] = "Date is missing. See line ".$m->line.".";
	
	$m->values['note'] = utf8_encode($m->values['note']);
	
	excelDateFix($m);

	return true;
}

function txHormonotherapyInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['treatment_control_id'] = Config::$tx_controls['hormonotherapy']['id'];
	return true;
}

function txHormonoPostWrite(Model $m){
	for($i = 1; $i < 5; $i ++){
		$key = 'treatment Precision drug '.$i;
		if(!array_key_exists($key, $m->values)){
			die('FATAL ERROR: Missing key ['.$key."] FROM event".Config::$line_break_tag);
		}
		if(!in_array($m->values[$key], array('', 'no', 'unknown'))){
			if(!in_array($m->values['chemiotherapy'], array('no', 'unknown', ''))){
				Config::$summary_msg['event: chimio & horm & HR & bone']['@@WARNING@@']['Drug & more than one trt'][] = "Drugs are defined and both chemo and radio are defined. Drugs will be assigned to chemo. See line ".$m->line.".";
				break;
			}
			$drug_id = getDrugId($m->values[$key], 'hormonal');
			$data = array('treatment_master_id' => $m->last_id, 'treatment_extend_control_id' => Config::$tx_controls['hormonotherapy']['treatment_extend_control_id']);
			$treatment_extend_master_id = customInsert($data, 'treatment_extend_masters', __FUNCTION__, __LINE__, false);
			$data = array('treatment_extend_master_id' => $treatment_extend_master_id, 'drug_id' => $drug_id);
			customInsert($data, 'txe_chemos', __FUNCTION__, __LINE__, true);
		}
	}
}





