<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'treatment_control_id'	=> '#treatment_control_id',
	'diagnosis_master_id'	=> $pkey,
		
	'start_date' 			=> 'Dates of event Date of event (beginning)',
	'start_date_accuracy' 	=> array('Dates of event Accuracy (beginning)' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'finish_date' 			=> 'Dates of event Date of event (end)',
	'finish_date_accuracy'	=> array('Dates of event Accuracy (end)' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
		
	'notes' 				=> 'note'
);
$detail_fields = array();

$model = new MasterDetailModel(2, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'treatment_masters', $fields, 'txd_chemos', 'treatment_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["start_date"]	=> key($fields["start_date_accuracy"]),
		$fields['finish_date']	=> key($fields['finish_date_accuracy'])
	)
);

$model->post_read_function = 'txChemotherapyPostRead';
$model->post_write_function = 'txChemotherapyPostWrite';
$model->insert_condition_function = 'txChemotherapyInsertCondition';
Config::addModel($model, 'tx_chemotherapy');

function txChemotherapyPostRead(Model $m){
	if(in_array($m->values['chemiotherapy'], array('no', 'unknown', ''))){
		$drug_defined = false;
		for($i = 1; $i < 5; $i ++) if(strlen($m->values['treatment Precision drug '.$i])) $drug_defined = true;
		if($drug_defined) Config::$summary_msg['event: chemotherapy']['@@WARNING@@']['Drug defined without chemo'][] = "No chemo will be imported but drugs are defined. See line ".$m->line.".";
		return false;
	}
	if($m->values['chemiotherapy'] != 'yes'){
		echo 'WARNING: Unknwon value ['.$m->values['chemiotherapy'].'] for chemiotherapy in event at line ['.$m->line."]".Config::$line_break_tag;
	}
	if(empty($m->values['Dates of event Date of event (beginning)'])) Config::$summary_msg['event: chemotherapy']['@@ERROR@@']['date missing'][] = "Date is missing. See line ".$m->line.".";
	
	excelDateFix($m);
	
	return true;
}

function txChemotherapyInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['treatment_control_id'] = Config::$tx_controls['chemotherapy']['general']['id'];
	return true;
}

function txChemotherapyPostWrite(Model $m){
	for($i = 1; $i < 5; $i ++){
		$key = 'treatment Precision drug '.$i;
		if(!array_key_exists($key, $m->values)){
			die('FATAL ERROR: Missing key ['.$key."] FROM event".Config::$line_break_tag);
		}
		if(!in_array($m->values[$key], array('', 'no', 'unknown'))){			
			$drug_id = getDrugId($m->values[$key]);
			
			$query = "INSERT INTO txe_chemos (drug_id, treatment_master_id, created, created_by, modified, modified_by) VALUES ($drug_id, ".$m->last_id.", NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.");";
			if(Config::$print_queries) echo $query.Config::$line_break_tag;
			mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
			$id = mysqli_insert_id(Config::$db_connection);
			
			$query = "INSERT INTO txe_chemos_revs (id, drug_id, treatment_master_id, version_created, modified_by) VALUES ($id, $drug_id, ".$m->last_id.", NOW(), ".Config::$db_created_id.")";
			if(Config::$print_queries) echo $query.Config::$line_break_tag;
			mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
		}
	}
}

function getDrugId($drug_name) {
	if(array_key_exists(strtolower($drug_name), Config::$drugs)) return Config::$drugs[strtolower($drug_name)];
		
	$query = "INSERT INTO drugs (generic_name, type, created, created_by, modified, modified_by) VALUES ('$drug_name', 'chemotherapy', NOW(), ".Config::$db_created_id.", NOW(), ".Config::$db_created_id.");";
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	
	$id = mysqli_insert_id(Config::$db_connection);
	$query = "INSERT INTO drugs_revs (id, generic_name, type, version_created, modified_by) VALUES ($id, '$drug_name', 'chemotherapy', NOW(), ".Config::$db_created_id.");";
	if(Config::$print_queries) echo $query.Config::$line_break_tag;
	mysqli_query(Config::$db_connection, $query) or die("[$query] ".__FUNCTION__." ".__LINE__);
	
	Config::$drugs[strtolower($drug_name)] = $id;
	
	return $id;
}


