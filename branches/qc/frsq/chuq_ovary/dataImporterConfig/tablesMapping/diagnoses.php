<?php
$pkey = "NS";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "@14",
	"participant_id" => $pkey,
	
	"tumour_grade" => array("GR" => array(
		"X"=>"",
		"2/3"=>"2",
		"3/3"=>"3",
		"1/3"=>"1",
		"1-2/3"=>"1-2",
		"H"=>"",
		"2"=>"2",
		"1"=>"1",
		"2-3/3"=>"2-3",
		"3"=>"3")));
$detail_fields = array(
	"pathology_diagnosis" => "Diagnostic",
	"figo" => array("FIGO" => array(
		"IA"=>"Ia",
		"IC"=>"Ic",
		"IIIC"=>"IIIc",
		"T3c"=>"IIIc",
		"T4"=>"IV",
		"T1a"=>"Ia",
		"IV"=>"IV",
		"X"=>"",
		"III"=>"III",
		"IIA"=>"IIa",
		"IIIA"=>"IIIa",
		"IIC"=>"IIc",
		"IIIB"=>"IIIb",
		"IC vs IIC"=>"Ic",
		"IB?"=>"Ib",
		"IIB"=>"IIb",
		"IB"=>"Ib",
		"IIIB?"=>"IIIb",
		"?"=>"",
		"1A"=>"1a")),
	);

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $master_fields, 'chuq_dx_all_sites', 'diagnosis_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postDiagnosisRead';

//adding this model to the config
Config::$models['DiagnosisMaster'] = $model;

		
function postDiagnosisRead(Model $m){
	$m->values['Diagnostic'] = utf8_encode($m->values['Diagnostic']);
}




