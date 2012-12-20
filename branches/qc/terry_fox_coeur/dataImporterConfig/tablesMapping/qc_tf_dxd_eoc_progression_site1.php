<?php
//progression recurrence EOC - DX for site 1
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"parent_id" => $pkey,
	"participant_id" => '#participant_id',
	"primary_id" => "#primary_id",
	"diagnosis_control_id" => "@16",
	"dx_date" => "Date of Progression/Recurrence Date",
	"dx_date_accuracy" => array("Date of Progression/Recurrence Accuracy" => Config::$coeur_accuracy_def),
	"qc_tf_tumor_site" => array("Site 1 of Primary Tumor Progression (metastasis)  If Applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_dx_origin" => '@progression',
	'qc_tf_progression_detection_method' => '@site detection'
);

$model = new MasterDetailModel(1, $pkey, array(), false, 'parent_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_progression_and_recurrences', 'diagnosis_master_id', array());

$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"]))),
	'site_label' => 'Site 1 of Primary Tumor Progression (metastasis)  If Applicable'
); 

$model->post_read_function = 'progressionSiteNumPostRead';
$model->insert_condition_function = 'eocProgressionInsertNow';

Config::$models['dxd_eoc_progression_site1'] = $model;

function progressionSiteNumPostRead(Model $m){
	if(empty($m->values[$m->custom_data['site_label']])){
		return false;
	} else if(strtoupper($m->values[$m->custom_data['site_label']]) == 'CA125'){
		Config::$summary_msg['EOC Diagnosis']['@@ERROR@@']['Wrong progression site'][] = "CA125 is not a eoc progression site. See patient ".$m->values['Patient Biobank Number (required)']." line [". $m->line."]";
		return false;
	}
	
	excelDateFix($m);
	
	$field = key($m->fields['qc_tf_tumor_site']);
	if(isset($m->values[$field]) && $m->values[$field] == 'ascite'){
		$m->values[$field] = 'Ascites';
	}

	return true;
}
