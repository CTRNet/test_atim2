<?php
//progression recurrence EOC - DX for no site
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"parent_id" => $pkey,
	"participant_id" => '#participant_id',
	"primary_id" => "#primary_id",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression/Recurrence Date",
	"dx_date_accuracy" => array("Date of Progression/Recurrence Accuracy" => Config::$coeur_accuracy_def),
	"qc_tf_tumor_site" => "@unknown",
	"qc_tf_dx_origin" => "@progression",
	"qc_tf_progression_detection_method" => "@unknown"
);

$model = new MasterDetailModel(1, $pkey, array(), false, 'parent_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());

$model->custom_data = array("date_fields" => array(
	$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"])))
); 

$model->post_read_function = 'progressionNoSitePostRead';
$model->insert_condition_function = 'eocProgressionInsertNow';

Config::$models['dxd_eoc_progression_no_site'] = $model;

function progressionNoSitePostRead(Model $m){
	if(!empty($m->values['Date of Progression/Recurrence Date']) 
	&& empty($m->values['Site 1 of Primary Tumor Progression (metastasis)  If Applicable'])
	&& empty($m->values['Site 2 of Primary Tumor Progression (metastasis)  If applicable'])){
		Config::$summary_msg['EOC Diagnosis']['@@WARNING@@']['Unknown Progression'][] = "An EOC progression date is set but no site has been defined. Unknown progression has been created. See patient ".$m->values['Patient Biobank Number (required)']." line [". $m->line."]";
		excelDateFix($m);
		return true;
	}
	return false;
}

