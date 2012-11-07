<?php
$pkey = "Code du Patient";

$child = array();

$master_fields = array(
	"event_control_id" => "#event_control_id",
	"participant_id" => $pkey,
		
	"procure_form_identification" => "#procure_form_identification"
);
$detail_fields = array(
	"patient_identity_verified" => "@1",
	"id_confirmation_date" => "#id_confirmation_date",             

);

//see the Model class definition for more info
$model = new MasterDetailModel(1, $pkey, $child, false, "participant_id", $pkey, 'event_masters', $master_fields, 'procure_ed_clinical_followup_worksheets', 'event_master_id', $detail_fields);

//we can then attach post read/write functions
$model->post_read_function = 'postTreatmentRead';
$model->post_write_function = 'postTreatmentWrite';

$model->custom_data = array();

//adding this model to the config
Config::$models['Treatment'] = $model;
	
function postTreatmentRead(Model $m){
	$data_to_record = false;
	$path_report_excel_fields = array(
		"Traitements antérieurs pour la prostate::Inhibiteurs de 5a-Réductase (Avodart, Proscar)",
		"Traitements antérieurs pour la prostate::Rx BPH (Flomax, Xatral)",
		"Traitements antérieurs pour la prostate::Antibiotiques (Cipro)",
		"Traitements antérieurs pour la prostate::Chirurgie (RTUP)",
		"Médicaments pour autres problèmes de santé (prescrits et en vente libre)  (nom et posologie)",
		"Produits naturels"
	);
	foreach($path_report_excel_fields as $field_to_test) {
		$field_to_test = utf8_decode($field_to_test);
		if(array_key_exists($field_to_test, $m->values) && strlen($m->values[$field_to_test])) {
			$data_to_record = true;
		}
	}	
	if(!$data_to_record) {
//		Config::$summary_msg['Treatment']['@@MESSAGE@@']['No Treatment data recorded'][] = "For partient '".$m->values['Code du Patient']."'. See line: ".$m->line;
		return false;
	} 
	
	die("ERR Treatment data exists. See line: ".$m->line);

	$m->values['event_control_id'] = Config::$event_controls['procure follow-up worksheet']['event_control_id'];
	$m->values['procure_form_identification'] = $m->values['Code du Patient']. ' V01 -FSP1';
	
	//TODO
	
	return true;
}

function postTreatmentWrite(Model $m){

}
