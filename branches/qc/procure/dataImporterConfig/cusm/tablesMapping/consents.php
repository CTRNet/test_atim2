<?php
$pkey = "Identification";

$child = array();

$master_fields = array(
	"consent_control_id" => "#consent_control_id",
	"participant_id" => $pkey,
		
	"procure_form_identification" => "#procure_form_identification",
	"form_version" => array("Version du consentement" => array(""=>""," "=>"","eng"=>"english","fr"=>"french")),
	"consent_signed_date" => "#consent_signed_date",
	"consent_signed_date_accuracy" => "#consent_signed_date_accuracy"
);
$detail_fields = array(
	"patient_identity_verified" => "@1",
	"revised_date" => "#revised_date",
	"revised_date_accuracy" => "#revised_date_accuracy"	
);

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'consent_masters', $master_fields, 'procure_cd_sigantures', 'consent_master_id', $detail_fields);

//we can then attach post read/write functions
$model->post_read_function = 'postConsentRead';
$model->post_write_function = 'postConsentWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['Consent'] = $model;
	
function postConsentRead(Model $m){
	if(empty($m->values['Date de signature']) && empty($m->values['Version du consentement']) && empty($m->values[utf8_decode("Date de révision du consentement")])) {
		Config::$summary_msg['Consent']['@@WARNING@@']['No consent recorded'][] = "For partient '".$m->values['Identification']."'. See line: ".$m->line;
		return false;
	}
		
	// Set master data
	
	$m->values['consent_control_id'] = Config::$consent_control_id;
	$m->values['procure_form_identification'] = $m->values['Identification']. ' V01 -CSF1';

	$tmp_consent_signed_date = getDateTimeAndAccuracy($m->values['Date de signature'], $m->values['Heure'], 'Consent', 'Date de signature', 'Heure', $m->line);
	if($tmp_consent_signed_date) {
		$m->values['consent_signed_date'] = $tmp_consent_signed_date['datetime'];
		$m->values['consent_signed_date_accuracy'] = $tmp_consent_signed_date['accuracy'];
	} else {
		$m->values['consent_signed_date'] = "''";
		$m->values['consent_signed_date_accuracy'] = "''";
	}
	
	// Set detail data
	
	$tmp_consent_signed_date = getDateAndAccuracy($m->values[utf8_decode('Date de révision du consentement')], 'Consent', 'Date de révision du consentement', $m->line);
	if($tmp_consent_signed_date) {
		$m->values['revised_date'] = $tmp_consent_signed_date['date'];
		$m->values['revised_date_accuracy'] = $tmp_consent_signed_date['accuracy'];
	} else {
		$m->values['revised_date'] = "''";
		$m->values['revised_date_accuracy'] = "''";
	}
	
	return true;
}

function postConsentWrite(Model $m){

}
