<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"treatment_control_id" => "@7",
	"participant_id" => $pkey,
	"diagnosis_master_id" => "#diagnosis_master_id",
	"start_date" => "Date of Surgery");
$detail_fields = array(
	"ovcare_macroscopic_residual" => array("Macroscopic Residual" => array(
		"" => "",
		"y" => "y",
		"n" => "n")),
	"path_num" => "Surgical Pathology Number",
	"ovcare_procedure_performed" => "Procedure Performed");

//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'treatment_masters', $master_fields, 'txd_surgeries', 'treatment_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array(
	"date_fields" => array(
		$master_fields["start_date"] => null
	) 
);
$model->post_read_function = 'postSurgeryRead';
$model->insert_condition_function = 'preSurgeryWrite';

//adding this model to the config
Config::$models['Surgery'] = $model;
	
function postSurgeryRead(Model $m){	
	$m->values['Macroscopic Residual'] = str_replace('n/a', '', $m->values['Macroscopic Residual']);
	if(empty($m->values['Date of Surgery']) && empty($m->values['Macroscopic Residual']) && empty($m->values['Surgical Pathology Number']) && empty($m->values['Procedure Performed'])) {
		return false;
	}

	excelDateFix($m);	
	
	return true;
}

function preSurgeryWrite(Model $m){
	switch(strtolower($m->values['Macroscopic Residual'])) {
		case 'yes':
			$m->values['Macroscopic Residual'] = 'y';
			break;
		case 'no':
			$m->values['Macroscopic Residual'] = 'n';
			break;
		default:
			$m->values['Macroscopic Residual'] = '';
	}
	
	$surgery_diagnosis_master_id = Config::$record_ids_from_voa[Config::$current_voa_nbr]['ovcare_diagnosis_id'];
	if(isset(Config::$record_ids_from_voa[Config::$current_voa_nbr]['recurrence_diagnosis_id'])) {
		if(!empty(Config::$current_patient_session_data['date_of_reccurrence']) && !empty($m->values['Date of Surgery'])) {
			$date_of_reccurrence = Config::$current_patient_session_data['date_of_reccurrence'];
			$date_of_surgery = $m->values['Date of Surgery'];
			
			if(str_replace('-','',$date_of_reccurrence) < str_replace('-','',$date_of_surgery)) {
				Config::$summary_msg['@@WARNING@@']['Reccurence Surgery #1'][] = "Surgery done after recurrence. Both collection and surgery will be linked to recurrence. Progression free time, survival won't probably be calculated! [VOA#: ".Config::$current_voa_nbr.' / line: '.$m->line.']';
				$surgery_diagnosis_master_id = Config::$record_ids_from_voa[Config::$current_voa_nbr]['recurrence_diagnosis_id'];
				Config::$record_ids_from_voa[Config::$current_voa_nbr]['collection_diagnosis_id'] = Config::$record_ids_from_voa[Config::$current_voa_nbr]['recurrence_diagnosis_id'];
			}
		}
	}
	
	$m->values['diagnosis_master_id'] = $surgery_diagnosis_master_id;
	
	return true;	
}


