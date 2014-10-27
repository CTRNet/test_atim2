<?php
$pkey = "Patient # in biobank";
$child = array();
$fields = array(
	'participant_id' 		=> '#participant_id',
	'treatment_control_id'	=> '#treatment_control_id', //biopsy
	'diagnosis_master_id'	=> $pkey,
	'start_date' 			=> (Config::$active_surveillance_project? 'Biopsy/Surgery Date of surgery/biopsy' : 'Surgery/Biopsy Date of surgery/biopsy'),
	'start_date_accuracy'	=> array((Config::$active_surveillance_project? 'Biopsy/Surgery Accuracy' : 'Surgery/Biopsy Accuracy') => array("c" => "c", "y" => "m", "m" => "d", "" => "", " " => "")),
);
$detail_fields = array(	
	'type' 				=>  '#type',
	'total_number_taken'	=> 	Config::$active_surveillance_project? 'Biopsy information Total number taken' : 'number of biospies (optional)',
	'gleason_score'		=> 	array((Config::$active_surveillance_project? 'Biopsy information Gleason Score' : 'Gleason score at biopsy') => new ValueDomain('qc_tf_gleason_values', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'gleason_grade'		=> array((Config::$active_surveillance_project? 'Biopsy information Gleason Grade (X+Y)' : 'Gleason Grade at biopsy (X+Y)') => new ValueDomain('qc_tf_gleason_grades', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'ctnm' 				=> array((Config::$active_surveillance_project? 'cTNM' : 'cTNM RT') => new ValueDomain('qc_tf_ctnm', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE))
);		
if(Config::$active_surveillance_project) {
	$detail_fields['total_positive'] = 'Biopsy information Total positive';
	$detail_fields['greatest_percent_of_cancer'] = 'Biopsy information Greatest Percent of cancer';
	$detail_fields['perineural_invasion'] = 'Biopsy information Perineural invasion';
}	

$model = new MasterDetailModel(1, $pkey, $child, false, 'diagnosis_master_id', $pkey, 'treatment_masters', $fields, 'qc_tf_txd_biopsies_and_turps', 'treatment_master_id', $detail_fields);
$model->custom_data = array("date_fields" => array($fields["start_date"]	=> key($fields["start_date_accuracy"])));

$model->post_read_function = 'txBiopsyPostRead';
$model->insert_condition_function = 'txBiopsyInsertCondition';
Config::addModel($model, 'tx_biopsy');

function txBiopsyPostRead(Model $m){
	
	//Set Types "Bx","Bx CHUM","Bx Dx","Bx Dx TRUS-Guided","Bx TRUS-Guided","Bx prior to Tx","TURP","TURP Dx"
	$type_field = (Config::$active_surveillance_project? 'Biopsy/Surgery Bx Specification' : 'Surgery/Biopsy Type of surgery');
	switch($m->values[$type_field]) {
		case 'Bx sent to CHUM':
			$m->values['type'] = "CHUM Bx";
			break;
		case 'Dx Bx':
			$m->values['type'] = "Bx Dx";		
			break;
		case 'biopsy':
			$m->values['type'] = "Bx";		
			break;
		case 'TRUS':
			$m->values['type'] = "Bx TRUS-Guided";
			break;
		case 'TURP':
			$m->values['type'] = "TURP";
			break;
		case 'Bx prior to Tx':
			$m->values['type'] = "Bx prior to Tx";
			break;
		default;
			return false;
//Note: The other type check and data integrity will be done in checkTypeOfBiopsySurgeryValue()
	}
	
	$m->values['treatment_control_id'] = Config::$tx_controls['biopsy and turp']['id'];
	
	$m->values[(Config::$active_surveillance_project? 'cTNM' : 'cTNM RT')] =str_replace(array('IV','III','II','I'), array('4','3','2','1'),$m->values[(Config::$active_surveillance_project? 'cTNM' : 'cTNM RT')]);
	
	foreach(array('Biopsy information Greatest Percent of cancer','Biopsy information Total number taken','number of biospies (optional)','Biopsy information Total positive') as $xls_field) {
		if(array_key_exists($xls_field, $m->values)) {
			$m->values[$xls_field] =str_replace(array('.00', ' '), array('', ''),$m->values[$xls_field]);
			if(strlen($m->values[$xls_field]) && !preg_match('/^[0-9]+$/', $m->values[$xls_field])) {
				Config::$summary_msg['diagnosis: biopsy']['@@WARNING@@']["$xls_field: wrong format"][] = "Integer expected. See value [".$m->values[$xls_field]."] at line ".$m->line.".";
				$m->values[$xls_field] = '';
			}
		}
	}
	
	if(Config::$active_surveillance_project && array_key_exists('Biopsy Perineural invasion', $m->values)) {
		$m->values['Biopsy Perineural invasion'] =str_replace(array('unknown', ' '), array('', ''),$m->values['Biopsy Perineural invasion']);
		if(strlen($m->values['Biopsy Perineural invasion']) && !in_array($m->values['Biopsy Perineural invasion'], array('yes','no'))) {
			Config::$summary_msg['diagnosis: RP']['@@WARNING@@']["'Biopsy Perineural invasion': wrong format"][] = "Yes or no expected. See value [".$m->values['Biopsy Perineural invasion']."] at line ".$m->line.".";
			$m->values['Biopsy Perineural invasion'] = '';
		}
		$m->values['Biopsy Perineural invasion'] =str_replace(array('yes', 'no'), array('y', 'n'),$m->values['Biopsy Perineural invasion']);
	}
	
	excelDateFix($m);
	
	return true;
}

function txBiopsyInsertCondition(Model $m){
	$m->values['participant_id'] = $m->parent_model->parent_model->last_id;
	return true;
}
