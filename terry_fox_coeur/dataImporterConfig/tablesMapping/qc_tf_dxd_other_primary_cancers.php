<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@15",
	"dx_date" => "Date of Diagnosis Date",
	"dx_date_accuracy" => array("Date of Diagnosis Accuracy" => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	"age_at_dx" => "Age at Time of Diagnosis (yr)",
	"tumour_grade" => array("Grade" => new ValueDomain('qc_tf_grade', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"path_stage_summary" => array("Stage" => new ValueDomain('qc_tf_stage', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_tumor_site" => array("Tumor Site" => new ValueDomain('qc_tf_tumor_site', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_dx_origin" => "@primary",
	"qc_tf_progression_detection_method" => "@not applicable"
);

$detail_fields = array(
	"laterality" => array("Laterality" => new ValueDomain('qc_tf_laterality', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"histopathology" => array("Histopathology" => new ValueDomain('qc_tf_histopathology', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"survival_in_months" => "Survival (months)"
);

$child = array('qc_tf_dxd_other_progression_site');
$model = new MasterDetailModel(3, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_other_primary_cancers', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array(
	$fields["dx_date"]									=> current(array_keys($fields["dx_date_accuracy"])))
); 
$model->post_read_function = 'otherDxPostRead';
$model->insert_condition_function = 'mainDxCondition';
$model->post_write_function = 'mainDxPostWrite';

$model->custom_data['last_csv_key'] = null;
$model->custom_data['last_other_dx_values'] = null;

Config::$models['qc_tf_dxd_other_primary_cancers'] = $model;

function otherDxPostRead(Model $m){
	excelDateFix($m);
	if($m->custom_data['last_csv_key'] == $m->values[$m->csv_pkey] && isSameOtherDxData($m->values, $m->custom_data['last_other_dx_values'], $m)
	){
		//ignore main insert, it's a child reinsertion
		return false;
	}
	
	$m->custom_data['last_csv_key'] = $m->values[$m->csv_pkey]; 
	$m->custom_data['last_other_dx_values'] = $m->values;
	
	foreach(array('Age at Time of Diagnosis (yr)', 'Survival (months)') as $new_header) {
		if(!empty($m->values[$new_header]) && !is_numeric($m->values[$new_header])) {
			echo "ERROR: $new_header should be numeric [",$m->file,"] at line [", $m->line,"]\n";
		}
	}	
		
	return true;
}

function otherProgressionSiteInsertNow(Model $m){
	if(!isSameOtherDxData($m->values, $m->parent_model->values, $m)) {
		//different date OR different site -> whole new entry	
		return false;
	}
	
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['parent_id'] = $m->parent_model->last_id;
	$m->values['primary_id'] = $m->parent_model->last_id;
		
	return true;
}

function isSameOtherDxData($m_current, $m_reference, $m) {
	if(empty($m_reference) || empty($m_current)) {
		echo "ERROR: Wrong call to isSameOtherDxData() function, one model is empty in file [",$m->file,"] at line [", $m->line,"]\n";
		exit;
	}

	$other_dx_fields = array(
		'Date of Diagnosis Date',
		'Date of Diagnosis Accuracy',	
		'Tumor Site',	
		'Age at Time of Diagnosis (yr)',	
		'Laterality',	
		'Histopathology',		
		'Grade',	
		'Stage',	
		'Survival (months)');
	
	$diff_nbr = 0;
	$diff_field = '';
	$all_current_fields_empty = true;
	foreach($other_dx_fields as $field) {
		if(!array_key_exists($field, $m_current) || !array_key_exists($field, $m_reference)) die ("ERROR: isSameOtherDxData() file [".$m->file."] at line [".$m->line."]\n");
		if($m_current[$field] != $m_reference[$field])  { $diff_nbr++; $diff_field = $field; }
		$tmp_current_field = str_replace(' ', '', $m_current[$field]);
		if(!empty($tmp_current_field)) $all_current_fields_empty = false;
	}

	if($all_current_fields_empty) return true;
	if($diff_nbr == 1) echo "WARNING: 2 Other dx for same patient are defined as different because only values for field $diff_field are different [",$m->file,"] at line [", $m->line,"]\n";
	
	return ($diff_nbr == 0)? true : false;
}