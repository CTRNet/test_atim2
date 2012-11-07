<?php
$pkey = "Code du Patient";

$child = array();

$fields = array(
	"participant_id" => $pkey,
	"procure_visit" => "@V01",
	"procure_patient_identity_verified" => "@1",
	"collection_datetime" => "#collection_datetime",
	"collection_datetime_accuracy" => "#collection_datetime_accuracy",
	"collection_notes" => "Commentaires du pathologiste"
);

//see the Model class definition for more info
$model = new Model(1, $pkey, $child, false, "participant_id", $pkey, 'collections', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postSurgeryRead';
$model->post_write_function = 'postSurgeryWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['Surgery'] = $model;
	
function postSurgeryRead(Model $m){
	$data_to_record = false;
	$path_report_excel_fields = array(
		"Date de la chirurgie",
		"Chirurgien",
		"Prostate::poids (g)"
	);
	foreach($path_report_excel_fields as $field_to_test) {
		$field_to_test = utf8_decode($field_to_test);
		if(array_key_exists($field_to_test, $m->values) && strlen($m->values[$field_to_test])) {
			$data_to_record = true;
		}
	}	
	if(!$data_to_record) {
		Config::$summary_msg['Surgery']['@@MESSAGE@@']['No Surgery data recorded'][] = "For partient '".$m->values['Code du Patient']."'. See line: ".$m->line;
		return false;
	} 
	
	$m->values['Commentaires du pathologiste'] = utf8_encode($m->values['Commentaires du pathologiste']);
	
	$tmp_event_date = getDateAndAccuracy($m->values[utf8_decode("Date de la chirurgie")], 'Surgery', "Date de la chirurgie", $m->line);
	if($tmp_event_date) {
		$m->values['collection_datetime'] = $tmp_event_date['date'];
		$m->values['collection_datetime_accuracy'] = str_replace('c','h',$tmp_event_date['accuracy']);
	} else {
		$m->values['collection_datetime'] = "''";
		$m->values['collection_datetime_accuracy'] = "''";
	}	
		
	return true;
}

function postSurgeryWrite(Model $m){
	Config::$next_sample_code++;
	
	$sample_master_data = array(
		'sample_code' => Config::$next_sample_code,
		'sample_control_id' => Config::$sample_aliquot_controls['tissue']['sample_control_id'],
		'collection_id' => $m->last_id,
		'initial_specimen_sample_type' => 'tissue');
	$sample_master_id = customInsertRecord($sample_master_data, 'sample_masters', false);
	
	$specimen_detail_data = array(
		'sample_master_id' => $sample_master_id,
		'reception_datetime' => $m->values['collection_datetime'],
		'reception_datetime_accuracy' => $m->values['collection_datetime_accuracy']);
	customInsertRecord($specimen_detail_data, 'specimen_details', true);
	
	$sample_detail_data = array(
		'sample_master_id' => $sample_master_id,
		'procure_surgeon_name' => utf8_encode($m->values['Chirurgien']));
	customInsertRecord($sample_detail_data, Config::$sample_aliquot_controls['tissue']['detail_tablename'], true);

}
