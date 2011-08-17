<?php
$pkey = "NS";
$child = array();
$master_fields = array(
	"consent_control_id" => "@2",
	"participant_id" => $pkey,
	"consent_status" => array("CT" => array(
		"O" => "obtained",
		"*DCD" => "obtained",
		"DCD" => "obtained",
		"*O" => "obtained",
		"N" => "denied",
		"O*" => "obtained",
		"O                       O" => "obtained")));
$detail_fields = array();

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'consent_masters', $master_fields, 'cd_nationals', 'consent_master_id', $detail_fields);

//we can then attach post read/write functions
$model->post_read_function = 'postConsentRead';
$model->custom_data = array();

//adding this model to the config
Config::$models['ConsentMaster'] = $model;

function postConsentRead(Model $m){
	if(empty($m->values['CT'])) {
		echo "<br><FONT COLOR=\"red\" >Line ".$m->line.": Consent status is empty!</FONT><br>";
		$m->values['CT'] = "O";
	}
	
	return true;
}
