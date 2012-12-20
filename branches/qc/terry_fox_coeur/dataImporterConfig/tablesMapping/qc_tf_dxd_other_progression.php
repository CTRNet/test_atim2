<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"parent_id" => $pkey,
	"participant_id" => '#participant_id',
	"primary_id" => "#primary_id",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression/Recurrence Date",
	"dx_date_accuracy" => array("Date of Progression/Recurrence Accuracy" => Config::$coeur_accuracy_def),
	"qc_tf_tumor_site" => array("Site of Tumor Progression (metastasis)  If Applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_dx_origin" => '@progression',
	"qc_tf_progression_detection_method" => "@site detection"
);

$model = new MasterDetailModel(3, $pkey, array(), false, 'parent_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());

$model->post_read_function = 'otherProgressionPostRead';
$model->insert_condition_function = 'otherProgressionSiteInsertNow';

$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"])))
); 
				 
Config::addModel($model, 'qc_tf_dxd_other_progression_site');

function otherProgressionPostRead(Model $m){
	excelDateFix($m);
	
	if(empty($m->values['Date of Progression/Recurrence Date']) && empty($m->values['Site of Tumor Progression (metastasis)  If Applicable'])){
		return false;
	} else if(empty($m->values['Site of Tumor Progression (metastasis)  If Applicable'])){
		$m->values['Site of Tumor Progression (metastasis)  If Applicable'] = 'unknown';
		Config::$summary_msg['Other Diagnosis Progression']['@@WARNING@@']['Unknown Progression'][] = "An other diagnosis progression date is set but no site has been defined. Unknown progression has been created. See line [". $m->line."]";
	}
	
	$field = key($m->fields['qc_tf_tumor_site']);
	if(isset($m->values[$field]) && $m->values[$field] == 'ascite'){
		$m->values[$field] = 'Ascites';
	}
	
	return true;
}

function otherProgressionSiteInsertNow(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['primary_id'] = $m->parent_model->last_id;
	return isSameOtherDxData($m->values, $m->parent_model->values, $m)? true : false;
}




