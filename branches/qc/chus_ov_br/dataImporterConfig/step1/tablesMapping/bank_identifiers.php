<?php
$pkey = "PatienteNbr";
$child = array();
$fields = array(
	"misc_identifier_control_id" => "#misc_identifier_control_id",
	"participant_id" => $pkey,
	"identifier_value" => "FRSQNbr");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, "participant_id", $pkey, 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postBankNbrRead';
$model->post_write_function = 'postBankNbrWrite';


//adding this model to the config
Config::$models['BankMiscIdentfier'] = $model;


function postBankNbrRead(Model $m){
	$m->values['FRSQNbr'] = utf8_encode($m->values['FRSQNbr']);
	if(preg_match('/(sein)/i', $m->values['Ov / Sein'], $matches)) {
		$m->values['misc_identifier_control_id'] = '1';
	} else if(preg_match('/(ovaire)/i', $m->values['Ov / Sein'], $matches)){	
		$m->values['misc_identifier_control_id'] = '2';
	} else {
		die("ERR Participant 001: Bank unknown ".$m->values['Ov / Sein']."!");
	}
	
	if(empty($m->values['FRSQNbr'])) die('ERR 9983783 Line '.$m->line);
	if(in_array($m->values['FRSQNbr'],Config::$bank_nbr_already_recorded)) {
		Config::$summary_msg['@@WARNING@@']['Bank Number #1'][] = "A same '#FRSQ' is defined twice [".$m->values['FRSQNbr'].']! [Line : '.$m->line.']';
		return false;
	}
	return true;
}

function postBankNbrWrite(Model $m) {
	Config::$bank_nbr_already_recorded[] = $m->values['FRSQNbr'];
}
