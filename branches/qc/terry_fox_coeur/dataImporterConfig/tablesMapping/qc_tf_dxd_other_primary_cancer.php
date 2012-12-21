<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@15",
	"dx_date" => "Date of Diagnosis Date",
	"dx_date_accuracy" => array("Date of Diagnosis Accuracy" => Config::$coeur_accuracy_def),
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

$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"]))),
	'last_other_dx_values' => null
); 

$model->post_read_function = 'dxdOtherPostRead';
$model->insert_condition_function = 'dxdOtherPreWrite';

Config::$models['dxd_other'] = $model;

function dxdOtherPostRead(Model $m){
	excelDateFix($m);
	
	if(!empty($m->custom_data['last_other_dx_values']) && isSameOtherDxData($m->values, $m->custom_data['last_other_dx_values'], $m)) return false;
	$m->custom_data['last_other_dx_values'] = $m->values;
	
	$field = key($m->fields['qc_tf_tumor_site']);
	if(isset($m->values[$field]) && $m->values[$field] == 'ascite'){
		$m->values[$field] = 'Ascites';
	}
	
	return true;
}

function dxdOtherPreWrite(Model $m) {
	foreach(array('Age at Time of Diagnosis (yr)', 'Survival (months)') as $new_header) {
		if(!empty($m->values[$new_header])) {
			if(!is_numeric($m->values[$new_header])) {
				Config::$summary_msg['Other Diagnosis']['@@ERROR@@']['Wrong numeric value'][] = "$new_header should be numeric. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
				$m->values[$new_header] = '';
			} else if($m->values[$new_header] < 0) {
				Config::$summary_msg['Other Diagnosis']['@@ERROR@@']['Wrong numeric value'][] = "$new_header should be > 0. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
				$m->values[$new_header] = '';
			}
			if(strpos($m->values[$new_header], '.') != false) $m->values[$new_header] = substr($m->values[$new_header], 0 , strpos($m->values[$new_header], '.'));
		}
	}
	return true;
}

function isSameOtherDxData($m_current, $m_reference, $m) {
	if(empty($m_reference) || empty($m_current)) die("Wrong call to isSameOtherDxData() function, one model is empty in file [".$m->file."] at line [". $m->line."]");

	$field_to_keys = array_flip($m->keys);
	
	// Test Patient
	$field = "Patient Biobank Number (required)";
	if(!array_key_exists($field, $m_current) || !array_key_exists($field, $m_reference) || !array_key_exists($field, $field_to_keys) || !array_key_exists($field_to_keys[$field], $m_current) || !array_key_exists($field_to_keys[$field], $m_reference)) die ("ERROR #0: isSameOtherDxData() file [".$m->file."] at line [".$m->line."]\n");
	if($m_current[$field_to_keys[$field]] != $m_reference[$field_to_keys[$field]]) {	
		return false;
	}
	
	// Test on Dx Data
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
	
	$diff_fields = array();
	$all_current_fields_empty = true;
	foreach($other_dx_fields as $field) {
		if(!array_key_exists($field, $m_current) || !array_key_exists($field, $m_reference)) die ("ERROR #1: isSameOtherDxData() file [".$m->file."] at line [".$m->line."]\n");
		$tmp_current_field = str_replace(' ', '', $m_current[$field]);
		if(strlen($tmp_current_field)) {
			$all_current_fields_empty = false;
			if(!array_key_exists($field, $field_to_keys)) die ("ERROR #2: isSameOtherDxData() file [".$m->file."] at line [".$m->line."]\n");
			$studied_key = $field_to_keys[$field];	// To be sure to work on real data
			if(!(array_key_exists($studied_key, $m_current) && array_key_exists($studied_key, $m_reference) && $m_current[$studied_key] == $m_reference[$studied_key])) {
				$diff_fields[] = $field;
			}
		}
	}
	if($all_current_fields_empty) return true;
	if(sizeof($diff_fields) == 1) Config::$summary_msg['Other Diagnosis']['@@WARNING@@']['Wrong numeric value'][$m->line] = "2 other primary dx for same patient are defined as different because only 1 field '".$diff_fields[0]."' is different. See [".$m->file."] at line [". $m->line."]";
			
	return (sizeof($diff_fields) == 0)? true : false;
}
