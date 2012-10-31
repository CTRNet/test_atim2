<?php
$pkey = "Identification";

$child = array();

$master_fields = array(
	"event_control_id" => "#event_control_id",
	"participant_id" => $pkey,
		
	"procure_form_identification" => "#procure_form_identification",
);
$detail_fields = array(
	"patient_identity_verified" => "@1",
		
	"delivery_date" => "#delivery_date",
	"delivery_date_accuracy" => "#delivery_date_accuracy",	
	"recovery_date" => "#recovery_date",
	"recovery_date_accuracy" => "#recovery_date_accuracy",
	"verification_date" => "#verification_date",
	"verification_date_accuracy" => "#verification_date_accuracy",
	"revision_date" => "#revision_date",
	"revision_date_accuracy" => "#revision_date_accuracy",
	
	"version" => "#version",
	"version_date" => "#version_date",

	"spent_time_delivery_to_recovery" => utf8_decode('Temps écoulé entre remise et récupération du questionnaire (jour)')
);

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'event_masters', $master_fields, 'procure_ed_lifestyle_quest_admin_worksheets', 'event_master_id', $detail_fields);

//we can then attach post read/write functions
$model->post_read_function = 'postQuestionnaireRead';
$model->post_write_function = 'postQuestionnaireWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['Questionnaire'] = $model;
	
function postQuestionnaireRead(Model $m){
	if(empty($m->values['Date de remise du questionnaire au participant']) &&
	empty($m->values[utf8_decode('Date de réception du questionnaire')]) &&
	empty($m->values[utf8_decode('Date de vérification du questionnaire')]) &&
	empty($m->values[utf8_decode('Date de révision du questionnaire')]) &&
	empty($m->values[utf8_decode('Version du questionnaire')]) &&
	empty($m->values[utf8_decode('Temps écoulé entre remise et récupération du questionnaire (jour)')])) {
		Config::$summary_msg['Questionnaire']['@@MESSAGE@@']['No questionnaire recorded'][] = "For partient '".$m->values['Identification']."'. See line: ".$m->line;
		return false;
	}

	$m->values['event_control_id'] = Config::$event_controls['procure questionnaire administration worksheet']['event_control_id'];
	$m->values['procure_form_identification'] = $m->values['Identification']. ' V01 -QUE1';
	
	$working_array = array(
		'delivery_date' => 'Date de remise du questionnaire au participant', 
		'recovery_date' => 'Date de réception du questionnaire',
		'verification_date' => 'Date de vérification du questionnaire',
		'revision_date' => 'Date de révision du questionnaire'
	);
	foreach($working_array as $db_field => $file_field) {
		$tmp_date_data = getDateAndAccuracy($m->values[utf8_decode($file_field)], 'Questionnaire', $file_field, $m->line);
		if($tmp_date_data) {
			$m->values[$db_field] = $tmp_date_data['date'];
			$m->values[$db_field.'_accuracy'] = $tmp_date_data['accuracy'];
		} else {
			$m->values[$db_field] = "''";
			$m->values[$db_field.'_accuracy'] = "''";
		}
	}		
	
	$version_values = $m->values[utf8_decode('Version du questionnaire')];
	$version_language = null;
	$version_date = null;
	if(!empty($version_values)) {	
		if(preg_match('/^(eng|fr) (20[0-9][0-9])$/', $version_values, $matches)) {
			$version_language = $matches[1];
			$version_date = $matches[2];
		} else if(preg_match('/^(eng|fr)$/', $version_values, $matches)) {
			$version_language = $matches[1];
		} else if(preg_match('/^(20[0-9][0-9])$/', $version_values, $matches)) {
			$version_date = $matches[1];
		}
		if($version_language || $version_date) {
			$version_language = str_replace(array('eng','fr'), array('english','french'), $version_language);
			if($version_language && !array_key_exists($version_language, Config::$value_domains['procure_questionnaire_version']->values)) {
				Config::$summary_msg['Questionnaire']['@@ERROR@@']['Wrong version values (language)'][] = "The year ($version_language) of the questionnaire version '$version_values' is not supported. See line: ".$m->line;
				$version_language = null;
			}
			$old_version_date = $version_date;
			if(in_array($version_date, array('2007','2008'))) {
				$version_date = '2006';
			} else if(in_array($version_date, array('2010','2011'))) {
				$version_date = '2009';
			}
			if($old_version_date != $version_date) Config::$summary_msg['Questionnaire']['@@MESSAGE@@']['Version values updated (date)'][] = "The date ($old_version_date) of the questionnaire version '$version_values' has been changed to '$version_date'. See line: ".$m->line;
			if($version_date && !array_key_exists($version_date, Config::$value_domains['procure_questionnaire_version_date']->values)) {
				Config::$summary_msg['Questionnaire']['@@ERROR@@']['Wrong version values (date)'][] = "The date ($version_date) of the questionnaire version '$version_values' is not supported. See line: ".$m->line;
				$version_date = null;
			}
		} else {
			Config::$summary_msg['Questionnaire']['@@ERROR@@']['Wrong version values'][] = "The format of the questionnaire version '$version_values' is not supported. See line: ".$m->line;
		}
	}
	$m->values['version'] = $version_language? $version_language  :"";
	$m->values['version_date'] =$version_date? $version_date  :"";
	
	if(preg_match('/^([0-9]*)$/', $m->values[utf8_decode('Temps écoulé entre remise et récupération du questionnaire (jour)')], $matches)) {
		$m->values['spent_time_delivery_to_recovery'] = "'".$matches[1]."'";
	} else {
		Config::$summary_msg['Questionnaire']['@@ERROR@@']['Wrong spent time'][] = "The format of the spent time from delivery to recovery is wrong : '".$m->values[utf8_decode('Temps écoulé entre remise et récupération du questionnaire (jour)')]."'.See line: ".$m->line;
		$m->values['spent_time_delivery_to_recovery'] = "''";
	}
	
	return true;
}

function postQuestionnaireWrite(Model $m){

}
