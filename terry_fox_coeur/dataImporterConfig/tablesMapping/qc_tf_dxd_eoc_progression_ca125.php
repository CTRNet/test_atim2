<?php
//progression recurrence EOC - DX for site 2
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"parent_id" => $pkey,
	"participant_id" => '#participant_id',
	"primary_id" => "#primary_id",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression of CA125 Date",
	"dx_date_accuracy" => array("Date of Progression of CA125 Accuracy" => Config::$coeur_accuracy_def),
	"qc_tf_tumor_site" => "@unknown",
	"qc_tf_dx_origin" => "@progression",
	"qc_tf_progression_detection_method" => "@ca125"
);

$model = new MasterDetailModel(1, $pkey, array(), false, 'parent_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());

$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"])))
);

$model->post_read_function = 'progressionSiteCa125PostRead';
$model->insert_condition_function = 'eocProgressionInsertNow';

Config::addModel($model, 'dxd_eoc_progression_ca125');

function progressionSiteCa125PostRead(Model $m){
	if(empty($m->values['Date of Progression of CA125 Date'])){
		return false;
	}
	
	excelDateFix($m);
	
	return true;
}