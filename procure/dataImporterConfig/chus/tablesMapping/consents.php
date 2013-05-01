<?php
$pkey = "Identification";

$child = array();

$master_fields = array(
	"consent_control_id" => "#consent_control_id",
	"participant_id" => $pkey,
		
	"procure_form_identification" => "#procure_form_identification",
	"form_version" => array("Version du consentement" => array(""=>""," "=>"","Anglais"=>"english", utf8_decode("Français")=>"french")),
	"consent_signed_date" => "#consent_signed_date",
	"consent_signed_date_accuracy" => "#consent_signed_date_accuracy"
);
$detail_fields = array(
	"patient_identity_verified" => "@1",
	"revised_date" => "#revised_date",
	"revised_date_accuracy" => "#revised_date_accuracy",
	
	"procure_chus_contact_for_more_info" =>	array(utf8_decode("Contacter si besoin d'informations supplémentaires") => array(""=>""," "=>"","Oui"=>"y","Non"=>"n")),
	"procure_chus_contact_if_scientific_discovery" =>	array(utf8_decode("Contacter si découverte scientifique") => array(""=>""," "=>"","Oui"=>"y","Non"=>"n")),
	"procure_chus_study_on_other_diseases" =>	array(utf8_decode("Étude sur d'autre maladie") => array(""=>""," "=>"","Oui"=>"y","Non"=>"n")),
	"procure_chus_contact_if_discovery_on_other_diseases" =>	array(utf8_decode("Contacter si découvertes sur d'autres maladies") => array(""=>""," "=>"","Oui"=>"y","Non"=>"n")),
	"procure_chus_other_contacts_in_case_of_death" =>	array(utf8_decode("Autres contacts en cas de décès") => array(""=>""," "=>"","Oui"=>"y","Non"=>"n"))
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
		Config::$summary_msg['Consent <br>  File: '.substr(Config::$xls_file_path, (strrpos(Config::$xls_file_path,'/')+1))]['@@WARNING@@']['No consent recorded'][] = "For partient '".$m->values['Identification']."'. See line: ".$m->line;
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
