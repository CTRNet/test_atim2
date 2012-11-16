<?php
$pkey = "Code du Patient";

$child = array();

$master_fields = array(
	"event_control_id" => "#event_control_id",
	"participant_id" => $pkey,
		
	"procure_form_identification" => "#procure_form_identification",
	"event_summary" => "Commentaires du pathologiste",
);
$detail_fields = array(
	"patient_identity_verified" => "@1",
	"id_confirmation_date" => "#id_confirmation_date",             
	"id_confirmation_date_accuracy" => "#id_confirmation_date_accuracy",
		
	"biopsy_pre_surgery_date" => "#biopsy_pre_surgery_date",  
	"biopsy_pre_surgery_date_accuracy" => "#biopsy_pre_surgery_date_accuracy",

	"aps_pre_surgery_total_ng_ml" => utf8_decode("APS pré-chirurgie (ng/mL)::Total"),
	"aps_pre_surgery_free_ng_ml" => utf8_decode("APS pré-chirurgie (ng/mL)::Libre"),	
	"aps_pre_surgery_date" => "#aps_pre_surgery_date",     
	"aps_pre_surgery_date_accuracy" => "#aps_pre_surgery_date_accuracy",
	
	"biopsies_before" => "#biopsies_before",            
	"biopsy_date" => "#biopsy_date",            
	"biopsy_date_accuracy" => "#biopsy_date_accuracy",
	
	"collected_cores_nbr" => "#collected_cores_nbr",     
	"nbr_of_cores_with_cancer" => "#nbr_of_cores_with_cancer",     
	"affected_core_localisation" => utf8_decode("Localisation des zones atteintes"),    
	"affected_core_total_percentage" => utf8_decode("% total atteint"),
	"highest_gleason_score_observed" => utf8_decode("Gleason le plus élevé"),
	"highest_gleason_score_percentage" => utf8_decode("% d'atteinte du Gleason le plus élevé"),       
	
	"histologic_grade_primary_pattern" => array(utf8_decode("Gleason::primaire") => array(""=>"","1"=>"1","2"=>"2","3"=>"3","4"=>"4","5"=>"5")),
	"histologic_grade_secondary_pattern" => array(utf8_decode("Gleason::secondaire") => array(""=>"","1"=>"1","2"=>"2","3"=>"3","4"=>"4","5"=>"5")),
	"histologic_grade_gleason_total" => array(utf8_decode("Gleason::Total") => array(""=>"","6"=>"6","7"=>"7","8"=>"8","9"=>"9","10"=>"10"))
);

//see the Model class definition for more info
$model = new MasterDetailModel(1, $pkey, $child, false, "participant_id", $pkey, 'event_masters', $master_fields, 'procure_ed_lab_diagnostic_information_worksheets', 'event_master_id', $detail_fields);

//we can then attach post read/write functions
$model->post_read_function = 'postDiagnosticRead';
$model->post_write_function = 'postDiagnosticWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['Diagnostic'] = $model;
	
function postDiagnosticRead(Model $m){
	$data_to_record = false;
	$path_report_excel_fields = array(
		"Biopsie pré-chirurgie::Date",
			
		"APS pré-chirurgie (ng/mL)::Date",
		"APS pré-chirurgie (ng/mL)::Total",
		"APS pré-chirurgie (ng/mL)::Libre",
		
		"Biopsie antérieure::non; oui",
		"Biopsie antérieure::Si oui; Date",
		
		"Nombre total de fragments reçus",
		"Nombre de fragments atteints",
		"Nombre total de zones prélevées",
		"Nombre de zones atteintes",
		"Localisation des zones atteintes",
		"% total atteint",
		"Gleason le plus élevé",
		"% d'atteinte du Gleason le plus élevé",
		
		"Gleason::primaire",
		"Gleason::secondaire",
		"Gleason::Total"	
	);
	foreach($path_report_excel_fields as $field_to_test) {
		$field_to_test = utf8_decode($field_to_test);
		if(array_key_exists($field_to_test, $m->values) && strlen($m->values[$field_to_test])) {
			$data_to_record = true;
		}
	}
	if(!$data_to_record) {
		Config::$summary_msg['Diagnostic']['@@MESSAGE@@']['No diagnostic data recorded'][] = "For partient '".$m->values['Code du Patient']."'. See line: ".$m->line;
		return false;
	}	
	
	$float_field_to_validate = array(
		"APS pré-chirurgie (ng/mL)::Total",
		"APS pré-chirurgie (ng/mL)::Libre",
		"% total atteint",
		"% d'atteinte du Gleason le plus élevé"
	);
	foreach($float_field_to_validate as $field_to_test) {
		$val_to_test = $m->values[utf8_decode($field_to_test)];
		if(strlen($val_to_test) && $val_to_test != 'non') {
			if(!preg_match('/^([0-9]+)([\.\,][0-9]+){0,1}$/', $val_to_test)) {
				Config::$summary_msg['Diagnostic']['@@ERROR@@']['Wrong float value'][] = "Value '$val_to_test' for field '$field_to_test' is not a float. See line: ".$m->line;
				$m->values[utf8_decode($field_to_test)] = '';
			}
		} else {
			$m->values[utf8_decode($field_to_test)] = '';
		}
	}
		
	$m->values['event_control_id'] = Config::$event_controls['procure diagnostic information worksheet']['event_control_id'];
	$m->values['procure_form_identification'] = $m->values['Code du Patient']. ' V01 -FBP1';
	
	$m->values['Commentaires du pathologiste'] = utf8_encode($m->values['Commentaires du pathologiste']);
	
	$tmp_event_date = getDateAndAccuracy($m->values[utf8_decode("Date de relevé des données (jj/mm/aaaa)")], 'Diagnostic', "Date de relevé des données (jj/mm/aaaa)", $m->line);
	if($tmp_event_date) {
		$m->values['id_confirmation_date'] = $tmp_event_date['date'];
		$m->values['id_confirmation_date_accuracy'] = $tmp_event_date['accuracy'];
	} else {
		$m->values['id_confirmation_date'] = "''";
		$m->values['id_confirmation_date_accuracy'] = "''";
	}
	
	$tmp_event_date = getDateAndAccuracy($m->values[utf8_decode("Biopsie pré-chirurgie::Date")], 'Diagnostic', "Biopsie pré-chirurgie::Date", $m->line);
	if($tmp_event_date) {
		$m->values['biopsy_pre_surgery_date'] = $tmp_event_date['date'];
		$m->values['biopsy_pre_surgery_date_accuracy'] = $tmp_event_date['accuracy'];
	} else {
		$m->values['biopsy_pre_surgery_date'] = "''";
		$m->values['biopsy_pre_surgery_date_accuracy'] = "''";
	}	
	
	$tmp_event_date = getDateAndAccuracy($m->values[utf8_decode("APS pré-chirurgie (ng/mL)::Date")], 'Diagnostic', "APS pré-chirurgie (ng/mL)::Date", $m->line);
	if($tmp_event_date) {
		$m->values['aps_pre_surgery_date'] = $tmp_event_date['date'];
		$m->values['aps_pre_surgery_date_accuracy'] = $tmp_event_date['accuracy'];
	} else {
		$m->values['aps_pre_surgery_date'] = "''";
		$m->values['aps_pre_surgery_date_accuracy'] = "''";
	}	
	
	$m->values["biopsies_before"] = '';
	$m->values["biopsy_date"] ="''";
	$m->values["biopsy_date_accuracy"] ="''";
	$previous_biopsies = strtolower($m->values[utf8_decode("Biopsie antérieure::non; oui")]);
	if(strlen($previous_biopsies)) {
		if($previous_biopsies != 'x') Config::$summary_msg['Diagnostic']['@@WARNING@@']['Previous biopsies value'][] = "Previous biopsies value '$previous_biopsies' different than 'x'. See line: ".$m->line;
		$m->values["biopsies_before"] = 'y';
	}
	if(strlen($m->values[utf8_decode("Biopsie antérieure::Si oui; Date")])) {
		if(empty($m->values["biopsies_before"])) {
			Config::$summary_msg['Diagnostic']['@@MESSAGE@@']['Previous biopsies field empty && completed date'][] = "Previous biopsies field is empty but a biopsy date is defined: Previous biopsies will be flagged to 'yes'. See line: ".$m->line;
			$m->values["biopsies_before"] = 'y';
		}
		$tmp_event_date = getDateAndAccuracy($m->values[utf8_decode("Biopsie antérieure::Si oui; Date")], 'Diagnostic', "Biopsie antérieure::Si oui; Date", $m->line);
		if($tmp_event_date) {
			$m->values['biopsy_date'] = $tmp_event_date['date'];
			$m->values['biopsy_date_accuracy'] = $tmp_event_date['accuracy'];
		} else {
			$m->values['biopsy_date'] = "''";
			$m->values['biopsy_date_accuracy'] = "''";
		}
	}
	
	$m->values[utf8_decode("Gleason le plus élevé")] = utf8_encode($m->values[utf8_decode("Gleason le plus élevé")]);
	$m->values[utf8_decode("Localisation des zones atteintes")] = utf8_encode($m->values[utf8_decode("Localisation des zones atteintes")]);
	$m->values['collected_cores_nbr'] = '';
	$m->values['nbr_of_cores_with_cancer'] = '';
	$col_nbr = $m->values[utf8_decode("Nombre total de zones prélevées")];
	$received_nbr = $m->values[utf8_decode("Nombre total de fragments reçus")];
	$col_nbr_with_cancer = $m->values[utf8_decode("Nombre de zones atteintes")];
	$received_nbr_with_cancer = $m->values[utf8_decode("Nombre de fragments atteints")];
	if(strlen($col_nbr)) {
		$m->values['collected_cores_nbr'] = $col_nbr;
	} else if(strlen($received_nbr)) {
		$m->values['collected_cores_nbr'] = $received_nbr;
		Config::$summary_msg['Diagnostic']['@@MESSAGE@@']['Used cores received instead cores collected'][] = "Field 'Nombre total de zones prélevées' was empty so used field 'Nombre total de fragments reçus' to define number of collected core in db. See line: ".$m->line;
	}
	if(strlen($col_nbr_with_cancer)) {
		$m->values['nbr_of_cores_with_cancer'] = $col_nbr_with_cancer;
	} else if(strlen($received_nbr_with_cancer)) {
		$m->values['nbr_of_cores_with_cancer'] = $received_nbr_with_cancer;
		Config::$summary_msg['Diagnostic']['@@MESSAGE@@']['Used affected cores received instead affected cores collected'][] = "Field 'Nombre de zones atteintes' was empty so used field 'Nombre de fragments atteints' to define number of affected core in db. See line: ".$m->line;
	}
	if(!preg_match('/^([0-9]*)$/', ($m->values['collected_cores_nbr'].$m->values['nbr_of_cores_with_cancer']))) {
		Config::$summary_msg['Diagnostic']['@@ERROR@@']['Nbr of cores'][] = "Either nomber of collected cores or affected collected cores is not an integer value. See line: ".$m->line;
	}
	
	return true;
}

function postDiagnosticWrite(Model $m){

}
