<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'treatment_control_id'	=> '#treatment_control_id', //RP
	'diagnosis_master_id'	=> $pkey,
	'start_date' 			=> (Config::$active_surveillance_project? 'Biopsy/Surgery Date of surgery/biopsy' : 'Surgery/Biopsy Date of surgery/biopsy'),
	'start_date_accuracy'	=> array((Config::$active_surveillance_project? 'Biopsy/Surgery Accuracy' : 'Surgery/Biopsy Accuracy') => array("c" => "c", "y" => "m", "m" => "d", "" => "", " " => "")),
);
$detail_fields = array(	
	'qc_tf_gleason_score'				=> array((Config::$active_surveillance_project? 'RP Gleason Score RP' : 'Gleason sum RP') => new ValueDomain('qc_tf_gleason_values', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'qc_tf_gleason_grade'				=> array((Config::$active_surveillance_project? 'RP Gleason Grade RP (X+Y)' : 'Gleason RP (X+Y)') => new ValueDomain('qc_tf_gleason_grades', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'qc_tf_lymph_node_invasion'			=> ((Config::$active_surveillance_project? 'RP ': '').'Presence of lymph node invasion'),
	'qc_tf_capsular_penetration'		=> ((Config::$active_surveillance_project? 'RP ': '').'Presence of capsular penetration'),
	'qc_tf_seminal_vesicle_invasion' 	=> ((Config::$active_surveillance_project? 'RP ': '').'Presence of seminal vesicle invasion'),
	'qc_tf_margin'						=> ((Config::$active_surveillance_project? 'RP ': '').'Margin')
);		

$model = new MasterDetailModel(1, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'treatment_masters', $fields, 'txd_surgeries', 'treatment_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array($fields["start_date"]	=> key($fields["start_date_accuracy"])));

$model->post_read_function = 'txSurgeryPostRead';
$model->insert_condition_function = 'txSurgeryInsertCondition';
Config::addModel($model, 'tx_surgery');

function txSurgeryPostRead(Model $m){
	$type_field = (Config::$active_surveillance_project? 'Biopsy/Surgery Specification' : 'Surgery/Biopsy Type of surgery');
	switch($m->values[$type_field]) {
		case 'RP':
			$m->values['treatment_control_id'] = Config::$tx_controls['RP']['id'];
			break;
		default:
			return false;
//Note: The other type check and data integrity will be done in checkTypeOfBiopsySurgeryValue()
	}

	excelDateFix($m);
	
	foreach(array('RP Gleason Score RP', 'Gleason sum RP') as $xls_field) {
		if(array_key_exists($xls_field, $m->values)) {
			$m->values[$xls_field] =str_replace(array('.00', ' '), array('', ''),$m->values[$xls_field]);
			if(strlen($m->values[$xls_field]) && !preg_match('/^[0-9]+$/', $m->values[$xls_field])) {
				Config::$summary_msg['diagnosis: RP']['@@WARNING@@']["$xls_field: wrong format"][] = "Integer expected. See value [".$m->values[$xls_field]."] at line ".$m->line.".";
				$m->values[$xls_field] = '';
			}
		}
	}
	
	foreach(array('Presence of lymph node invasion','Presence of capsular penetration', 'Presence of seminal vesicle invasion', 'Margin') as $xls_field) {
		$xls_field = (Config::$active_surveillance_project? 'RP ': '').$xls_field;
		if(array_key_exists($xls_field, $m->values)) {
			$m->values[$xls_field] =str_replace(array('unknown', ' '), array('', ''),$m->values[$xls_field]);
			if(strlen($m->values[$xls_field]) && !in_array($m->values[$xls_field], array('yes','no'))) {
				Config::$summary_msg['diagnosis: RP']['@@WARNING@@']["$xls_field: wrong format"][] = "Integer expected. See value [".$m->values[$xls_field]."] at line ".$m->line.".";
				$m->values[$xls_field] = '';
			}
			$m->values[$xls_field] =str_replace(array('yes', 'no'), array('y', 'n'),$m->values[$xls_field]);
		}
	}
	
	return true;
}

function txSurgeryInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	return true;
}