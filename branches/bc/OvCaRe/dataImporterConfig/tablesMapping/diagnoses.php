<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "@20",
	"participant_id" => $pkey,
	"morphology" => "Clinical WHO Code",
	"notes" => "@");

$detail_fields = array(
	"stage" => array("Stage" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3",
		"4"=>"4")),
	"substage" => array("Substage" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3")),

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
	
	$m->values['Clinical WHO Code'] = str_replace('/', '', str_replace(' ', ',', $m->values['Clinical WHO Code']));
	if(strpos($m->values['Clinical WHO Code'],',')) {
		$m->values['notes'] = 'Additional WHO codes : '.substr($m->values['Clinical WHO Code'], (strpos($morpho,',')+1));
		$m->values['Clinical WHO Code'] = substr($m->values['Clinical WHO Code'], 0, strpos($morpho,','));
	}
	if(!empty($m->values['Clinical WHO Code'])) {
		if(in_array()) {
			
			
			INFECTIOUS 
			INFECTIOUS 
			Normal 
		}
		if(!isset(Config::$dx_who_codes[$m->values['Clinical WHO Code']])) {
			Config::$summary_msg['@@ERROR@@'][] = 'WHO code '.$m->values['Clinical WHO Code'].' does not exist [VOA#: '.$m->values['VOA Number'].'/line: '.$m->line.']';
			$m->values['Clinical WHO Code'] = '';
		}
	}	
	
	return true;
}




