<?php
$pkey = "Patient Biobank Number (required)";
$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@14",
	"primary_number" => "#primary_number",
	"dx_date" => "Date of EOC Diagnosis Date",
	"dx_date_accuracy" => array("Date of EOC Diagnosis Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"age_at_dx" => "Age at Time of Diagnosis (yr)",
	"tumour_grade" => array("Grade" => new ValueDomain('qc_tf_grade', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_tumor_site" => "@Female Genital-Ovary",
	"qc_tf_dx_origin" => "@primary",
	"qc_tf_progression_detection_method" => "@not applicable"
);

$detail_fields = array(
	//"date_of_progression_recurrence" => "Date of Progression/Recurrence Date",
	//"date_of_progression_recurrence_accuracy" => array("Date of Progression/Recurrence Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	//"date_of_ca125_progression" => "Date of Progression of CA125 Date",
	//"date_of_ca125_progression_accu" => array("Date of Progression of CA125 Accuracy"=> array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"ca125_progression_time_in_months" => "CA125 progression time (months)",
	"presence_of_precursor_of_benign_lesions" => array("Presence of precursor of benign lesions" => new ValueDomain('qc_tf_presence_of_precursor_of_benign_lesions', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"fallopian_tube_lesion" => array("fallopian tube lesions" => new ValueDomain('qc_tf_fallopian_tube_lesion', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"laterality" => array("Laterality" => new ValueDomain('qc_tf_laterality', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"histopathology" => array("Histopathology" => new ValueDomain('qc_tf_histopathology', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"figo" => array("FIGO " => new ValueDomain('qc_tf_figo', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"residual_disease" => array("Residual Disease" => new ValueDomain('qc_tf_residual_disease', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	//"site_1_of_tumor_progression" => array("Site 1 of Primary Tumor Progression (metastasis)  If Applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	//"site_2_of_tumor_progression" => array("Site 2 of Primary Tumor Progression (metastasis)  If applicable" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"progression_time_in_months" => "progression time (months)",
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
$model->custom_data['last_dx_values'] = null;

$model->post_read_function = 'dxdEocsPostRead';
$model->insert_condition_function = 'mainDxCondition';

Config::$models['qc_tf_dxd_eocs'] = $model;

function dxdEocsPostRead(Model $m){
	excelDateFix($m);
	
	if($m->custom_data['last_csv_pkey'] == $m->values[$m->csv_pkey] && isSameEocDxData($m->values, $m->custom_data['last_dx_values'], $m)){
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
	
	foreach(array('progression time (months)', 'CA125 progression time (months)', 'Follow-up from ovarectomy (months)', 'Survival from diagnosis (months)') as $new_header) {
		if(!empty($m->values[$new_header]) && !is_numeric($m->values[$new_header])) {
			echo "ERROR: $new_header should be numeric [",$m->file,"] at line [", $m->line,"]\n";
		}
	}	
	
	$m->custom_data['last_csv_pkey'] = $m->values[$m->csv_pkey];
	$m->custom_data['last_dx_values'] = $m->values;
	
	return true;
}

function progressionSiteInsertNow(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['primary_number'] = $m->parent_model->values['primary_number'];

	return isSameEocDxData($m->values, $m->parent_model->values, $m);
}

function isSameEocDxData($m_current, $m_reference, $m) {
	if(empty($m_reference) || empty($m_current)) {
		echo "ERROR: Wrong call to isSameEocDxData() function, one model is empty in file [",$m->file,"] at line [", $m->line,"]\n";
		exit;
	}	
	$eoc_fields = array(
		'Date of EOC Diagnosis Date',
		'Date of EOC Diagnosis Accuracy',
		'Presence of precursor of benign lesions',
		'fallopian tube lesions',
		'Age at Time of Diagnosis (yr)',
		'Laterality',
		'Histopathology',
		'Grade',
		'FIGO ',
		'Residual Disease',
		'Progression status',
		'progression time (months)',
		'CA125 progression time (months)',
		'Follow-up from ovarectomy (months)',
		'Survival from diagnosis (months)');
	
	$diff_nbr = 0;
	$diff_field = '';
	$all_current_fields_empty = true;
	foreach($eoc_fields as $field) {
		if(!array_key_exists($field, $m_current) || !array_key_exists($field, $m_reference)) die ("ERROR: isSameEocDxData() file [".$m->file."] at line [".$m->line."]\n");
		if($m_current[$field] != $m_reference[$field])  { $diff_nbr++; $diff_field = $field; }
		$tmp_current_field = str_replace(' ', '', $m_current[$field]);
		if(!empty($tmp_current_field) && $field!= 'Progression status') $all_current_fields_empty = false;
	}
	if($all_current_fields_empty) return true;
	if($diff_nbr == 1) echo "WARNING: 2 EOC dx for same patient are defined as different because only values for field $diff_field are different [",$m->file,"] at line [", $m->line,"]\n";
	
	return ($diff_nbr == 0)? true : false;
}