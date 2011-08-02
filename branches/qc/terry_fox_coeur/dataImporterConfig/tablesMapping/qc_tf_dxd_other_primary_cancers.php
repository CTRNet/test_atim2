<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"primary_number" => "#primary_number",
	"diagnosis_control_id" => "@15",
	"dx_date" => "Date of Diagnosis Date",
	"dx_date_accuracy" => array("Date of Diagnosis Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"age_at_dx" => "Age at Time of Diagnosis (yr)",
	"tumour_grade" => array("Grade" => new ValueDomain('0_to_3', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"path_stage_summary" => array("Stage" => new ValueDomain('qc_tf_stage', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_tumor_site" => array("Tumor Site" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_dx_origin" => "@primary",
	"qc_tf_progression_detection_method" => "@not applicable"
);

$detail_fields = array(
	"laterality" => array("Laterality" => new ValueDomain('qc_tf_laterality', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"histopathology" => array("Histopathology" => new ValueDomain('qc_tf_histopathology_opc', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"survival_in_months" => "Survival (months)"
);

$child = array('qc_tf_dxd_other_progression_site');
$model = new MasterDetailModel(3, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_other_primary_cancers', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> current(array_keys($fields["dx_date_accuracy"])))
); 
$model->post_read_function = 'otherDxPostRead';
$model->insert_condition_function = 'mainDxCondition';

$model->custom_data['last_csv_key'] = null;
$model->custom_data['last_date'] = null;
$model->custom_data['last_site'] = null;

Config::$models['qc_tf_dxd_other_primary_cancers'] = $model;

function otherDxPostRead(Model $m){
	excelDateFix($m);
	if($m->custom_data['last_csv_key'] == $m->values[$m->csv_pkey] 
		&& $m->custom_data['last_date'] == $m->values['Date of Diagnosis Date']
		&& $m->custom_data['last_site'] == $m->values['Tumor Site']
	){
		//ignore main insert, it's a child reinsertion
		return false;
	}
	$m->custom_data['last_csv_key'] = $m->values[$m->csv_pkey]; 
	$m->custom_data['last_date'] = $m->values['Date of Diagnosis Date'];
	$m->custom_data['last_site'] = $m->values['Tumor Site'];
	
	foreach(array('Age at Time of Diagnosis (yr)', 'Survival (months)') as $new_header) {
		if(!empty($m->values[$new_header]) && !is_numeric($m->values[$new_header])) {
			echo "ERROR: $new_header should be numeric [",$m->file,"] at line [", $m->line,"]\n";
		}
	}	
		
	return true;
}