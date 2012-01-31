<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "@20",
	"participant_id" => $pkey,
	"morphology" => "Clinical WHO Code",
	"notes" => "#notes");

$detail_fields = array(
	"stage" => array("Stage" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3",
		"4"=>"4")),
	"substage" => array("Substage" => array(
		""=>"",
		"A"=>"A",
		"B"=>"B",
		"C"=>"C")),

	"clinical_diagnosis" => "Clinical Diagnosis",
	"clinical_history" => "Clinical History",

	"review_diagnosis" => "Review Diagnosis",
	"review_comment" => "Review Comment",
	"review_grade" => array("Review Grade" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3"))
	);
	
//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $master_fields, 'ovcare_dxd_primaries', 'diagnosis_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postDiagnosisRead';

//adding this model to the config
Config::$models['DiagnosisMaster'] = $model;
	
function postDiagnosisRead(Model $m){
	$m->values['notes'] = '';
	
	// Substage
	$m->values['Substage'] = strtoupper($m->values['Substage']);
	
	// Manage WHO Codes
	
	if(!empty($m->values['Clinical WHO Code'])) {
		$tmp_who_code = $m->values['Clinical WHO Code'];
		$m->values['Clinical WHO Code'] = '';
		
		preg_match_all('/([0-9]{4}\/[0-9])/', $tmp_who_code, $matches);
		if(!empty($matches[0])) {
			$m->values['Clinical WHO Code'] = str_replace('/','',$matches[0][0]);
			unset($matches[0][0]);
			if(!empty($matches[0])) {
				Config::$summary_msg['@@MESSAGE@@'][] = 'WHO code Msg#1: Many values are defined into cell ['.$tmp_who_code.']. Only first one will be recorded into WHO field, the other one will be added to notes. [VOA#: '.$m->values['VOA Number'].' / line: '.$m->line.']';
				$m->values['notes'] = 'Additional WHO codes : '.implode(", ", $matches[0]);	
			}
			$tmp_who_code = str_replace(array(' ',',',CHR(10),CHR(13)), array('','','',''), preg_replace('/([0-9]{4}\/[0-9])/', '', $tmp_who_code));
			if(!empty($tmp_who_code)) {
				Config::$summary_msg['@@WARNING@@'][] = 'WHO code Warn#1:  Both WHO code and text were defined into the source file. Add value ['.$tmp_who_code.'] as WHO comment. [VOA#: '.$m->values['VOA Number'].' / line: '.$m->line.']';
				$m->values['notes'] .= ' Additional WHO code comments : '.$tmp_who_code;	
			}
			if(!array_key_exists($m->values['Clinical WHO Code'], Config::$dx_who_codes)) {
				Config::$summary_msg['@@ERROR@@'][] = 'WHO code Err#1:  WHO code value ['.$m->values['Clinical WHO Code'].'] not supported into ATiM. [VOA#: '.$m->values['VOA Number'].' / line: '.$m->line.']';
				$m->values['notes'] .= ' WHO code not supported : '.$m->values['Clinical WHO Code'];					
				$m->values['Clinical WHO Code'] = '';
			}			
			
		} else {
			if(in_array($tmp_who_code, array('NA','Normal','N/A'))) {
				Config::$summary_msg['@@MESSAGE@@'][] = 'WHO code Msg#2: NA or Normal are not migrated. [VOA#: '.$m->values['VOA Number'].' / line: '.$m->line.']';
			
			} else {
				Config::$summary_msg['@@WARNING@@'][] = 'WHO code Warn#2: File values does not match the expected format ['.$tmp_who_code.']. Value will be added to the notes. [VOA#: '.$m->values['VOA Number'].' / line: '.$m->line.']';
				$m->values['notes'] = 'Wrong WHO codes migrated from source file: '.$tmp_who_code;
			}
		}
	}
	
	return true;
}




