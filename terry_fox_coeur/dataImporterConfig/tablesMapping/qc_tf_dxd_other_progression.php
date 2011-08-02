<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => "#participant_id",
	"primary_number" => "#primary_number",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression/Recurrence Date",
	"dx_date_accuracy" => array("Date of Progression/Recurrence Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_tumor_site" => array("Site of Tumor Progression (metastasis)  If Applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_dx_origin" => '@progression',
	"qc_tf_progression_detection_method" => "@site detection"
);

$model = new MasterDetailModel(3, $pkey, array(), false, null, $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());
$model->custom_data['last_participant_id'] = null;
$model->post_read_function = 'otherProgressionPostRead';
$model->insert_condition_function = 'otherProgressionSiteInsertNow';
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> current(array_keys($fields["dx_date_accuracy"])),
	'Date of Diagnosis Date'							=> 'Date of Diagnosis Accuracy')
); 
				 
Config::addModel($model, 'qc_tf_dxd_other_progression_site');


function otherProgressionPostRead(Model $m){
	excelDateFix($m);
	if(empty($m->values['Date of Progression/Recurrence Date'])){
		return false;
	}
	
	if(empty($m->values['Site of Tumor Progression (metastasis)  If Applicable'])){
		$m->values['Site of Tumor Progression (metastasis)  If Applicable'] = 'unknown';
	}else{
		if(strtoupper($m->values['Site of Tumor Progression (metastasis)  If Applicable']) == 'CA125'){
			echo "ERROR: [Site of Tumor Progression (metastasis)  If Applicable] value is [CA125] in file [",$m->file,"] at line [", $m->line,"]\n";
			global $insert;
			$insert = false;
		}
	}
	return true;
}

function otherProgressionSiteInsertNow(Model $m){
	if($m->values['Date of Diagnosis Date'] != $m->parent_model->values['Date of Diagnosis Date']
		|| $m->values['Tumor Site'] != $m->parent_model->values['Tumor Site']
	){
		//different date OR different site -> whole new entry	
		return false;
	}
	
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['primary_number'] = $m->parent_model->values['primary_number'];
		
	return true;
}