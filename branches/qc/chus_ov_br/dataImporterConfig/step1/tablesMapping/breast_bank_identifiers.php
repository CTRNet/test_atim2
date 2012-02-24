<?php
$pkey = "PatienteNbr";
$child = array();
$fields = array(
	"misc_identifier_control_id" => "@1",
	"participant_id" => $pkey,
	"identifier_value" => "FRSQNbr");

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, "participant_id", $pkey, 'misc_identifiers', $fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postBreastBankNbrRead';
$model->post_write_function = 'postBreastBankNbrWrite';


//adding this model to the config
Config::$models['BreastBankMiscIdentfier'] = $model;


function postBreastBankNbrRead(Model $m){
	$m->values['FRSQNbr'] = utf8_encode($m->values['FRSQNbr']);
	if(preg_match('/(sein)/i', $m->values['Ov / Sein'], $matches)) {
		return true;
	} else if(!preg_match('/(ovaire)/i', $m->values['Ov / Sein'], $matches)){
		die("ERR Participant 001: Bank unknown ".$m->values['Ov / Sein']."!");
	}
	return false;
}

function postBreastBankNbrWrite(Model $m) {
	global $connection;
	
	Config::$participant_ids_from['BrFrsq#'][$m->values['FRSQNbr']] = $m->values['PatienteNbr'];
	
	$breast_recruitment_date = customGetFormatedDate($m->values['Date']);
	if(!empty($breast_recruitment_date)) {
		$query = "UPDATE participants SET date_of_recruitment_breast = '$breast_recruitment_date' WHERE id = ".$m->values['PatienteNbr'].";";
		mysqli_query($connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$query = str_replace('UPDATE participants', 'UPDATE participants_revs', $query);
		mysqli_query($connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));	
	}
}
