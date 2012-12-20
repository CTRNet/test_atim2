<?php
$pkey = "Patient Biobank Number (required)";

$fields = array(
	"participant_id" => $pkey,
	"diagnosis_control_id" => "@14",
	"dx_date" => "Date of EOC Diagnosis Date",
	"dx_date_accuracy" => array("Date of EOC Diagnosis Accuracy" => Config::$coeur_accuracy_def),
	"age_at_dx" => "Age at Time of Diagnosis (yr)",
	"tumour_grade" => array("Grade" => new ValueDomain('qc_tf_grade', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"qc_tf_tumor_site" => "@Female Genital-Ovary",
	"qc_tf_dx_origin" => "@primary",
	"qc_tf_progression_detection_method" => "@not applicable"
);

$detail_fields = array(
	"ca125_progression_time_in_months" => "CA125 progression time (months)",
	"presence_of_precursor_of_benign_lesions" => array("Presence of precursor of benign lesions" => new ValueDomain('qc_tf_presence_of_precursor_of_benign_lesions', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"fallopian_tube_lesion" => array("fallopian tube lesions" => new ValueDomain('qc_tf_fallopian_tube_lesion', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"laterality" => array("Laterality" => new ValueDomain('qc_tf_laterality', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"histopathology" => array("Histopathology" => new ValueDomain('qc_tf_histopathology', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"figo" => array("FIGO " => new ValueDomain('qc_tf_figo', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"residual_disease" => array("Residual Disease" => new ValueDomain('qc_tf_residual_disease', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)),
	"progression_time_in_months" => "progression time (months)",
	"follow_up_from_ovarectomy_in_months" => "Follow-up from ovarectomy (months)",
	"survival_from_ovarectomy_in_months" => "Survival from diagnosis (months)",
	"progression_status" => array("Progression status" => new ValueDomain('qc_tf_progression_status', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE))
);

$child = array(
	'dxd_eoc_progression_no_site', 
	'dxd_eoc_progression_site1', 
	'dxd_eoc_progression_site2', 
	'dxd_eoc_progression_ca125' 
);

$model = new MasterDetailModel(1, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_eocs', 'diagnosis_master_id', $detail_fields);

$model->custom_data = array("date_fields" => array(
	$fields["dx_date"] => current(array_keys($fields["dx_date_accuracy"])))
); 
$model->custom_data['last_csv_pkey'] = null;
$model->custom_data['last_dx_values'] = null;

$model->post_read_function = 'dxdEocPostRead';
$model->insert_condition_function = 'dxdEocPreWrite';
$model->post_write_function = 'dxdEocPostWrite';

Config::$models['dxd_eoc'] = $model;

function dxdEocPostRead(Model $m){
	excelDateFix($m);
		
	if($m->custom_data['last_csv_pkey'] == $m->values[$m->csv_pkey]) {
		checkSameEocDxData($m->values, $m->custom_data['last_dx_values'], $m);
		return false;
	} else {
		$m->custom_data['last_csv_pkey'] = $m->values[$m->csv_pkey];
		$m->custom_data['last_dx_values'] = $m->values;
	}
	
	return true;
}


function dxdEocPreWrite(Model $m) {
	
	if(!strlen($m->values['Survival from diagnosis (months)'])) {
		$qc_tf_last_contact = $m->parent_model->values['Date of Last Contact Date'];
		$qc_tf_last_contact_accuracy = $m->parent_model->values['Date of Last Contact date accuracy'];
		$eoc_dx_date = $m->values['Date of EOC Diagnosis Date'];
		$eoc_dx_date_accuracy = $m->values['Date of EOC Diagnosis Accuracy'];
		if(!$qc_tf_last_contact) {
			Config::$summary_msg['EOC Diagnosis']['@@WARNING@@']['Survival: Last contact missing'][] = "Date is missing. Unable to calculate 'Survival'. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
		} else if(!in_array($qc_tf_last_contact_accuracy, array('','c'))) {
			Config::$summary_msg['EOC Diagnosis']['@@WARNING@@']['Survival: Last contact accuracy issue'][] = "Date accuracy != c (=$qc_tf_last_contact_accuracy). Unable to calculate 'Survival'. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
		} else if(!$eoc_dx_date) {
			Config::$summary_msg['EOC Diagnosis']['@@WARNING@@']['Survival: Diagnosis date missing'][] = "Date is missing. Unable to calculate 'Survival'. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
		} else if(!in_array($eoc_dx_date_accuracy, array('','c'))) {
			Config::$summary_msg['EOC Diagnosis']['@@WARNING@@']['Survival: Diagnosis date accuracy issue'][] = "Date accuracy != c (=$eoc_dx_date_accuracy). Unable to calculate 'Survival'. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
		} else if($qc_tf_last_contact < $eoc_dx_date) {
			Config::$summary_msg['EOC Diagnosis']['@@ERROR@@']['Survival: Dates error'][] = "Last Contact Date < EOC date. Unable to calculate 'Survival'. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
		} else {
			$datetime1 = new DateTime($eoc_dx_date);
			$datetime2 = new DateTime($qc_tf_last_contact);
			$interval = $datetime1->diff($datetime2);
			$m->values['Survival from diagnosis (months)'] = (($interval->format('%y')*12) + $interval->format('%m'));
			Config::$summary_msg['EOC Diagnosis']['@@MESSAGE@@']['Survival: Calculate'][] = "Survival value has been calculated (=".$m->values['Survival from diagnosis (months)']." ). See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
		}
	}
	
	foreach(array('Age at Time of Diagnosis (yr)','progression time (months)', 'CA125 progression time (months)', 'Follow-up from ovarectomy (months)', 'Survival from diagnosis (months)') as $new_header) {
		if(!empty($m->values[$new_header])) {
			if(!is_numeric($m->values[$new_header])) {
				Config::$summary_msg['EOC Diagnosis']['@@ERROR@@']['Wrong numeric value'][] = "$new_header should be numeric. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
				$m->values[$new_header] = '';
			} else if($m->values[$new_header] < 0) {
				Config::$summary_msg['EOC Diagnosis']['@@ERROR@@']['Wrong numeric value'][] = "$new_header should be > 0. See patient ".$m->values["Patient Biobank Number (required)"]." line ". $m->line;
				$m->values[$new_header] = '';
			}
			$m->values[$new_header] = substr($m->values[$new_header], 0 , strpos($m->values[$new_header], '.'));
		}
	}
	
	return true;
}

function checkSameEocDxData($m_current, $m_reference, $m) {
	if(empty($m_reference) || empty($m_current)) die("Wrong call to isSameEocDxData() function, one model is empty in file [".$m->file."] at line [". $m->line."]");
	
	$field_to_keys = array_flip($m->keys);
	
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
	
	$diff_fields = array();
	$all_current_fields_empty = true;
	foreach($eoc_fields as $field) {
		if(!array_key_exists($field, $m_current) || !array_key_exists($field, $m_reference)) die ("ERROR #1: checkSameEocDxData() file [".$m->file."] at line [".$m->line."]\n");
		$tmp_current_field = str_replace(' ', '', $m_current[$field]);
		if(strlen($tmp_current_field)) {
			$all_current_fields_empty = false;
			if(!array_key_exists($field, $field_to_keys)) die ("ERROR #2: checkSameEocDxData() file [".$m->file."] at line [".$m->line."]\n");
			$studied_key = $field_to_keys[$field];	// To be sure to work on real data
			if(!(array_key_exists($studied_key, $m_current) && array_key_exists($studied_key, $m_reference) && $m_current[$studied_key] == $m_reference[$studied_key])) {
				$diff_fields[] = $field;
			}
		}
	}
	if(!$all_current_fields_empty && !empty($diff_fields)) Config::$summary_msg['EOC Diagnosis']['@@ERROR@@']['Inconsistent EOC data'][] = "An EOC diagnosis is displayed on many rows but data are inconsistent for fields '".implode("', '" , $diff_fields)."'. See patient ".$m->values["Patient Biobank Number (required)"]." line [". $m->line."]";
}

function dxdEocPostWrite(Model $m){
	Config::$studied_participant_ids['eoc_diagnosis_master_id'] = $m->last_id;
}

function eocProgressionInsertNow(Model $m) {
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	$m->values['primary_id'] = $m->parent_model->last_id;
	
	return (Config::$studied_participant_ids['qc_tf_bank_identifier'] == $m->values['Patient Biobank Number (required)'])? true : false;
}



