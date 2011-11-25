<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> $pkey,
	'start_date' 			=> 'Dates of event Date of event (beginning)',
	'start_date_accuracy' 	=> array('Dates of event Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'finish_date' 			=> 'Dates of event Date of event (end)',
	'finish_date_accuracy' 	=> array('Dates of event Accuracy End' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_master_id'	=> '#diagnosis_master_id',
	'tx_control_id' 		=> '@1',//radiotherapy
	'notes'					=> 'note'
);

function txChemotherapyPostRead(Model $m){
	if(in_array($m->values['chemiotherapy'], array('no', 'unknown', ''))){
		return false;
	}
	
	if($m->values['chemiotherapy'] != 'yes'){
		echo 'WARNING: Unknwon value ['.$m->values['chemiotherapy'].'] for chemiotherapy in event at line ['.$m->line."]\n";
	}
	
	excelDateFix($m);
	return true;
}

function txChemotherapyPostWrite(Model $m){
	for($i = 1; $i < 5; $i ++){
		$key = 'treatment Precision drug '.$i;
		if(!array_key_exists($key, $m->values)){
			die('FATAL ERROR: Missing key ['.$key."] FROM event\n");
		}
		if(!in_array($m->values[$key], array('', 'no', 'unknown'))){
			if(array_key_exists($m->values[$key], $m->custom_data['drugs'])){
				$query = sprintf("INSERT INTO txe_chemos (drug_id, tx_master_id, created, created_by, modified, modified_by, deleted) VALUES (%d, %d, NOW(), %d, NOW(), %d)",
					$m->custom_data['drugs'][$m->values[$key]],
					$m->last_id,
					Config::$db_created_id,
					Config::$db_created_id
				);
				if(Config::$print_queries){
					echo $query."\n";
				}
				Database::insertRevForLastRow('txe_chemos');
			}else{
				echo 'WARNING: Unknwon drug ['.$m->values[$key].'] at field ['.$key.'] in event at line ['.$m->line."]\n";
			}
		}
	}
}

function txChemotherapyInsertCondition(Model $m){
	$m->values['diagnosis_master_id'] = $m->parent_model->custom_data['diagnosis_master_id'];
	if($m->parent_model->custom_data['diagnosis_master_id'] == null){
		echo 'WARNING: tx chemiotherapy at line ['.$m->line."] has no associated primary dx\n";
	}
	
	return true;
}

$model = new MasterDetailModel(2, $pkey, $child, false, 'participant_id', $pkey, 'tx_masters', $fields, 'txd_chemos', 'tx_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["start_date"]	=> key($fields["start_date_accuracy"]),
		$fields['finish_date']	=> key($fields['finish_date_accuracy'])
	), 'drugs' => array('5-ARI' => 1, 'taxotere' => 2)
);

$model->post_read_function = 'txChemotherapyPostRead';
$model->post_write_function = 'txChemotherapyPostWrite';
$model->insert_condition_function = 'txChemotherapyInsertCondition';
Config::addModel($model, 'tx_chemotherapy');