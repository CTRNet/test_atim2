<?php
//progression recurrence EOC - DX for site 2
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"participant_id" => "#participant_id",
	"primary_id" => "#primary_id",
	"parent_id" => "#parent_id",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression of CA125 Date",
	"dx_date_accuracy" => array("Date of Progression of CA125 Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"qc_tf_tumor_site" => "@unknown",
	"qc_tf_dx_origin" => "@progression",
	"qc_tf_progression_detection_method" => "@ca125"
);

$detail_fields = array(
//	'progression_time_in_month' => 'CA125 progression time (months)'
);

$model = new MasterDetailModel(1, $pkey, array(), false, null, $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"])),
	'Date of Progression/Recurrence Date'						=> null,
	'Date of EOC Diagnosis Date' => 'Date of EOC Diagnosis Accuracy')
);

$model->post_read_function = 'progressionSiteCa125PostRead';
$model->insert_condition_function = 'progressionSiteInsertNow';

Config::addModel($model, 'qc_tf_dxd_progression_site_ca125');

function progressionSiteCa125PostRead(Model $m){
	excelDateFix($m);
	
	if(empty($m->values['Date of Progression of CA125 Date'])){
		return false;
	}else if(strtoupper($m->values['Site 1 of Primary Tumor Progression (metastasis)  If Applicable']) == 'CA125' || strtoupper($m->values['Site 2 of Primary Tumor Progression (metastasis)  If applicable']) == 'CA125'){
		if($m->values['Date of Progression of CA125 Date'] != $m->values['Date of Progression/Recurrence Date']){
			//Already inserted, skip
			echo "ERROR: Different [Date of Progression of CA125 Date] AND [Date of Progression/Recurrence Date] found in file [",$m->file,"] at line [",$m->line,"]\n";
			global $insert;
			$insert = false;
		}
		//already inserted
		return false;
	}
	
	return true;
}