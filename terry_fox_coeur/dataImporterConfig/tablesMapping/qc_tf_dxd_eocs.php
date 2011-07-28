<?php
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@14",
	"primary_number" => "#primary_number",
	"dx_date" => "Date of EOC Diagnosis Date",
	"dx_date_accuracy" => array("Date of EOC Diagnosis Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"age_at_dx" => "Age at Time of Diagnosis (yr)",
	"tumour_grade" => array("Grade" => new ValueDomain('0_to_3', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_tumor_site" => "@Female Genital-Ovary",
	"qc_tf_dx_origin" => "@primary",
	"qc_tf_progression_detection_method" => "@not applicable"
);

$detail_fields = array(
	//"date_of_progression_recurrence" => "Date of Progression/Recurrence Date",
	//"date_of_progression_recurrence_accuracy" => array("Date of Progression/Recurrence Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	//"date_of_ca125_progression" => "Date of Progression of CA125 Date",
	//"date_of_ca125_progression_accu" => array("Date of Progression of CA125 Accuracy"=> array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	//"ca125_progression_time_in_months" => "CA125 progression time (months)",
	"presence_of_precursor_of_benign_lesions" => array("Presence of precursor of benign lesions" => new ValueDomain('qc_tf_presence_of_precursor_of_benign_lesions', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"fallopian_tube_lesion" => array("fallopian tube lesions" => new ValueDomain('qc_tf_fallopian_tube_lesion', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"laterality" => array("Laterality" => new ValueDomain('qc_tf_laterality', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"histopathology" => array("Histopathology" => new ValueDomain('qc_tf_histopathology', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"figo" => array("FIGO " => new ValueDomain('qc_tf_figo', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"residual_disease" => array("Residual Disease" => new ValueDomain('qc_tf_residual_disease', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	//"site_1_of_tumor_progression" => array("Site 1 of Primary Tumor Progression (metastasis)  If Applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	//"site_2_of_tumor_progression" => array("Site 2 of Primary Tumor Progression (metastasis)  If applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	//"progression_time_in_months" => "progression time (months)",
	"follow_up_from_ovarectomy_in_months" => "Follow-up from ovarectomy (months)",
	"survival_from_ovarectomy_in_months" => "Survival from diagnosis (months)",
	"progression_status" => array("Progression status" => new ValueDomain('qc_tf_progression_status', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);
$child = array(
	'qc_tf_dxd_progression_no_site', 
	'qc_tf_dxd_progression_site1', 
	'qc_tf_dxd_progression_site2', 
	'qc_tf_dxd_progression_site_ca125' 
);

$model = new MasterDetailModel(1, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_eocs', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> current(array_keys($fields["dx_date_accuracy"])))
); 
$model->custom_data['last_csv_pkey'] = null;
$model->custom_data['last_dx_date'] = null;
$model->post_read_function = 'dxdEocsPostRead';
$model->insert_condition_function = 'mainDxCondition';

Config::$models['qc_tf_dxd_eocs'] = $model;

function dxdEocsPostRead(Model $m){
	excelDateFix($m);
	if($m->custom_data['last_csv_pkey'] == $m->values[$m->csv_pkey] && $m->values['Date of EOC Diagnosis Date'] == $m->custom_data['last_dx_date']){
		//multiple sites case is already handled in children, skip
		return false;
	}
	
	if(strtoupper($m->values['Site 1 of Primary Tumor Progression (metastasis)  If Applicable']) == 'CA125'
		&& strtoupper($m->values['Site 2 of Primary Tumor Progression (metastasis)  If applicable']) == 'CA125'
	){
		echo "ERROR: both sites are CA125 in file [",$m->file,"] at line [", $m->line,"]\n";
		global $insert;
		$insert = false;
	}
	
	$m->custom_data['last_csv_pkey'] = $m->values[$m->csv_pkey];
	$m->custom_data['last_dx_date'] = $m->values['Date of EOC Diagnosis Date'];
	return true;
}

function progressionSiteInsertNow(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['primary_number'] = $m->parent_model->values['primary_number'];
		
	return $m->parent_model->values['Date of EOC Diagnosis Date'] == $m->values['Date of EOC Diagnosis Date'];
}