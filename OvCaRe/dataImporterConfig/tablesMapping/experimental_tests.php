<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"event_control_id" => "@52",
	"participant_id" => $pkey);

$detail_fields = array(
	"test" => "#test",
	"result" => "#result");
	
//see the Model class definition for more info
$model = new MasterDetailModel(3, $pkey, $child, false, "participant_id", $pkey, 'event_masters', $master_fields, 'ovcare_ed_lab_experimental_tests', 'event_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postExperimentalTestRead';
$model->insert_condition_function = 'preExperimentalTestWrite';
//adding this model to the config
Config::$models['ExperimentalTests'] = $model;

function postExperimentalTestRead(Model $m){
	$patient_experimental_tests = getExperimentalTests($m);
	if(empty($patient_experimental_tests)) return false;
	return true;
}

function preExperimentalTestWrite(Model $m) {
	$participant_id = Config::$record_ids_from_voa[Config::$current_voa_nbr]['participant_id'];
	$detail_table_name = 'ovcare_ed_lab_experimental_tests';
	$event_control_id = '52';
	
	$patient_experimental_tests = getExperimentalTests($m);
	if(empty($patient_experimental_tests)) die('ERR 88932022');
	
	$test_counter = 0;
	foreach($patient_experimental_tests as $test_name => $value) {
		$test_counter++;
		if(strlen($value) > 250) Config::$summary_msg['@@WARNING@@']['Experiment Data #2'][] = "The value [$field] of the field [$val] is too big (more than >250). String will be cutted. [VOA#: ".Config::$current_voa_nbr.' / line: '.$m->line.']';
		if($test_counter != sizeof($patient_experimental_tests)) {
			$event_master_id = insertCustomOvcareRecord(array("event_control_id" => $event_control_id, "participant_id" => $participant_id), 'event_masters');
			insertCustomOvcareRecord(array("event_master_id"	=> $event_master_id, "test" => "'".$test_name."'", "result" => "'".$value."'"), $detail_table_name, true);
		} else {
			// Last record
			$m->values['test'] = $test_name;
			$m->values['result'] = $value;
		}
	}
		
	return true;
}

function getExperimentalTests(Model $m) {
	$patient_experimental_tests = array();
	foreach($m->values as $field => $val) {
		if(preg_match('/(Experimental Data::)/', $field, $matches) && strlen(str_replace(' ', '', $val))) {
			$formatted_field = strtolower(preg_replace('/(Experimental Data::)/', '', $field));
			if(!in_array($formatted_field, Config::$experimental_tests_list)) {
				pr(Config::$experimental_tests_list);
				die("The experimental field [$field ($formatted_field)] is not created into ATiM.");
			}
			$patient_experimental_tests[$formatted_field] = utf8_encode($val);
		}
	}
	
	return $patient_experimental_tests;
}



