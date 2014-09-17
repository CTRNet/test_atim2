<?php
$pkey = "Patient # in biobank";
$child = array(
 	'dx_metastasis',
	'tx_surgery',
	'tx_biopsy',
 	'dx_recurrence',
  	'tx_radiotherapy',
  	'tx_hormonotherapy',
  	'tx_chemotherapy',
 	'tx_other_trt',
  	'event_psa',
 	'collection'
);

$fields = array(
	'participant_id' 		=> $pkey,
	'dx_date' 				=> 'Date of diagnostics Date',
	'dx_date_accuracy'		=> array('Date of diagnostics Accuracy' => array("c" => "c", "y" => "m", "m" => "d", "" => "")),
	'diagnosis_control_id'	=> '#diagnosis_control_id', //CPCBN dx
	'age_at_dx' 			=> '#age_at_dx'	
);
$detail_fields = array(
	'tool'									=> array('Date of diagnostics  diagnostic tool' => new ValueDomain("qc_tf_dx_tool", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)), 
	'ptnm' 									=> array((Config::$active_surveillance_project? 'RP pTNM' : 'pTNM RP') => new ValueDomain('qc_tf_ptnm', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'hormonorefractory_status' 				=> array('hormonorefractory status status' => new ValueDomain('qc_tf_hormonorefractory_status', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'active_surveillance' 					=> array('Active Surveillance' => new ValueDomain('qc_tf_active_surveillance', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE))
//Note: gleason_score_biopsy set in addonFunctionEnd()
//Note: gleason_score_rp set in addonFunctionEnd()
);
$prostate_dx_fields_to_check = array(
	'dx_date' => 'Date of diagnostics Date',
	'dx_date_accuracy' => 'Date of diagnostics Accuracy',
	'tool' => 'Date of diagnostics  diagnostic tool',
	'ptnm' => (Config::$active_surveillance_project? 'RP pTNM' : 'pTNM RP'),
	'hormonorefractory_status' => 'hormonorefractory status status',
	'active_surveillance' => 'Active Surveillance');

$model = new MasterDetailModel(1, $pkey, $child, false, 'participant_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_cpcbn', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array($fields["dx_date"]	=> key($fields["dx_date_accuracy"])), 
	'last_pkey' => null,
	'previous_data' => null,
	'previous_line' => null,
	'prostate_dx_fields_to_check' => $prostate_dx_fields_to_check);

$model->post_read_function = 'postDxRead';
$model->insert_condition_function = 'preDxWrite';
$model->post_write_function = 'postDxWrite';
Config::addModel($model, 'dx_primary');

function postDxRead(Model $m){
	if(!is_null($m->custom_data['previous_line']) && $m->custom_data['previous_line'] != ($m->line - 1)) {
		pr("postDxRead: Check patient # is set or data exists. See line ".($m->line-1).".");
		pr($m->values);
		pr($m->line - 1);
		exit;
		Config::$summary_msg['diagnosis']['@@ERROR@@']['Missing Patient # in biobank'][] = "Check patient # is set or data exists. See line ".($m->line-1).".";
	}
	$m->custom_data['previous_line'] = $m->line;
	
	checkTypeOfBiopsySurgeryValue($m->values, $m->line);
	
	excelDateFix($m);
	
	$m->values['diagnosis_control_id'] = Config::$dx_controls['primary']['prostate']['id'];
	$m->values[(Config::$active_surveillance_project? 'RP pTNM' : 'pTNM RP') ] =str_replace(array('IV','III','II','I'), array('4','3','2','1'),$m->values[(Config::$active_surveillance_project? 'RP pTNM' : 'pTNM RP') ]);
	$m->values['Active Surveillance'] =str_replace(array('no','unknown'), array('',''),$m->values['Active Surveillance']);
	//Tool: "biopsy","TRUS-guided biopsy","TURP","PSA+DRE","RP","unknown"
	if(strtoupper($m->values['Date of diagnostics  diagnostic tool']) == 'TRUS') {
		$m->values['Date of diagnostics  diagnostic tool'] = 'TRUS-guided biopsy';
	}
	
	if($m->values['Patient # in biobank'] == $m->custom_data['last_pkey']){
		//Only one primary dx to create per participant 
		manageDxValuesOnManyRows($m);
		return false;
	} else {
		$m->custom_data['dx_data_already_recorded'] = array();
		foreach($m->custom_data['prostate_dx_fields_to_check'] as $field) {
			if(strlen($m->values[$field])) $m->custom_data['dx_data_already_recorded'][$field] = $m->values[$field];
		} 
	}
	
	$m->custom_data['last_pkey'] = $m->values['Patient # in biobank'];
	
	return true;
}

function preDxWrite(Model $m){
	$m->values['age_at_dx'] = getAgeAtDx($m->parent_model->values['Date of Birth Date'], $m->parent_model->values['Date of Birth Accuracy'], $m->values['Date of diagnostics Date'], $m->values['Date of diagnostics Accuracy'], 'diagnosis: primary', $m->line);
	return true;
}

function postDxWrite(Model $m){
	return true;
}

function manageDxValuesOnManyRows(Model $m){
	//Create Dx value empty in previous row or display discordance
	$db_participant_id = $m->parent_model->last_id;
	
	$value_to_add = array('diagnsosis_masters' => array(), 'qc_tf_dxd_cpcbn' => array());
	$value_already_set_and_diff = array();
	foreach($m->custom_data['prostate_dx_fields_to_check'] as $db_field => $new_field) {
		if(strlen($m->values[$new_field])) {
			if(array_key_exists($new_field, $m->custom_data['dx_data_already_recorded'])) {
				if($m->values[$new_field] != $m->custom_data['dx_data_already_recorded'][$new_field]) {
					// already set and different
					$value_already_set_and_diff[] = $new_field;
				}
			} else {
				// New value to add to prostate dx
				$m->custom_data['dx_data_already_recorded'][$new_field] = $m->values[$new_field];
				
				switch($new_field) {				
					case 'Date of diagnostics  diagnostic tool':
					case 'pTNM RP':
					case 'RP pTNM':
					case 'hormonorefractory status status':
						$value_domain = current($m->detail_fields[$db_field]);
						$m->values[$new_field] = $value_domain->isValidValue($m->values[$new_field]);
						if(is_null($m->values[$new_field])){
							printf("WARNING: Invalid [$new_field] value [%s] for dx at line [%d]".Config::$line_break_tag, $m->values[$new_field], $m->line);
						} else {
							$value_to_add['qc_tf_dxd_cpcbn'][] = $db_field.'="'.$m->values[$new_field].'"';
						}
						break;
					case 'Date of diagnostics Date':
					case 'Date of diagnostics Accuracy':
						$value_to_add['diagnosis_masters'][] = $db_field.'="'.$m->values[$new_field].'"';	
						break;
					default:
						die('ERR 2 2876832768762 '.$new_field);	
				}
			}
		}
	}
	
	if(!empty($value_already_set_and_diff)) {
		Config::$summary_msg['diagnosis: primary']['@@WARNING@@']['Duplicated information'][] = "Following fields (".implode(', ', $value_already_set_and_diff).") values are duplicated and different for patient # [".$m->values['Patient # in biobank']."] see line [".$m->line."].";
	}	
	foreach($value_to_add as $table => $data) {	
		if(!empty($data)) {
			$query = "UPDATE $table SET ".implode(', ', $data)." WHERE ".
				(($table == 'diagnosis_masters')? 
					"participant_id = $db_participant_id AND diagnosis_control_id = 14;" :
					"diagnosis_master_id=(SELECT id FROM diagnosis_masters WHERE participant_id = $db_participant_id AND diagnosis_control_id = ".Config::$dx_controls['primary']['prostate']['id'].");");		
			mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
			if(Config::$print_queries) echo $query.Config::$line_break_tag;
			$query = str_replace($table, $table.'_revs',$query);
			if(Config::$insert_revs) mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		}
	}
}

function getAgeAtDx($date_of_birth, $date_of_birth_accuracy, $dx_date, $dx_date_accuracy, $summary_title, $line) {
	$age_at_dx = '';
	if(empty($date_of_birth) || empty($dx_date)) {
		Config::$summary_msg[$summary_title]['@@WARNING@@']['No Age At Dx (empty date)'][] = "Unable to calculate age at dx on empty date. See line $line";
	} else {
		if(!preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/',$date_of_birth)) die('ERR 998389393 '.$summary_title.' [' .$date_of_birth. '] line '.$line);
		if(!preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/',$dx_date)) die('ERR 999222999222 '.$summary_title.' [' .$dx_date. '] line '.$line);
		
		if(!(in_array($date_of_birth_accuracy, array('','c')) && in_array($dx_date_accuracy, array('','c')))) Config::$summary_msg[$summary_title]['@@WARNING@@']['Age At Dx on unaccuracy date'][] = "Age at dx has been calculated on unaccuracy date. See line $line";
		
		$start_date = $date_of_birth.' 00:00:00';
		$end_date = $dx_date.' 00:00:00';
		$start = getTimeStamp($start_date);
		$end = getTimeStamp($end_date);
		$spent_time = $end - $start;
			
		if(($start === false)||($end === false)){
			die('ERR 007008700 '.$summary_title ."$start_date $end_date  line : $line  ");
		} else if($spent_time < 0){
			// Error in the date
			Config::$summary_msg[$summary_title]['@@ERROR@@']['Age At Dx : date defintion error'][] = "Dx Date < Birth date. See line $line";
		} else if($spent_time == 0){
			// Nothing to change to $arr_spent_time
			$age_at_dx = '0';
		} else {
			// Return spend time
			$age_at_dx = substr($end_date, 0, 4)  - substr($start_date, 0, 4);
			if(strtotime($end_date) < strtotime(substr($end_date, 0, 4).substr($start_date, 4))) $age_at_dx --;
		}
	}
	
	return $age_at_dx;
}

function getTimeStamp($date_string){
	list($date, $time) = explode(' ', $date_string);
	list($year, $month, $day) = explode('-', $date);
	list($hour, $minute, $second) = explode(':',$time);

	return mktime($hour, $minute, $second, $month, $day, $year);
}

function checkTypeOfBiopsySurgeryValue($values, $lines) {
	//Check Biopsy&TURP/Surgery Type and also fields are correctly completed
	$RP_fields = Config::$active_surveillance_project?
		array('RP Gleason Grade RP (X+Y)',
			'RP Gleason Score RP',
			'RP Presence of lymph node invasion',
			'RP Presence of capsular penetration',
			'RP Presence of seminal vesicle invasion',
			'RP Margin') :	
		array('Gleason RP (X+Y)',
			'Gleason sum RP',
			'Presence of lymph node invasion',
			'Presence of capsular penetration',
			'Presence of seminal vesicle invasion',
			'Margin');
	$Bx_TURP_fields = Config::$active_surveillance_project?
		array('Biopsy information Total number taken',
			'Biopsy information Gleason Grade (X+Y)',
			'Biopsy information Gleason Score',
			'Biopsy information Total positive',
			'Biopsy information Greatest Percent of cancer',
			'cTNM'):
		array('Gleason Grade at biopsy (X+Y)',
			'Gleason score at biopsy',
			'number of biospies (optional)',
			'cTNM RT');
	$type_field = (Config::$active_surveillance_project? 'Biopsy/Surgery Specification' : 'Surgery/Biopsy Type of surgery');
	$date_field = (Config::$active_surveillance_project? 'Biopsy/Surgery' : 'Surgery/Biopsy').' Date of surgery/biopsy';
	switch($values[$type_field]) {
		case 'Bx sent to CHUM':
		case 'Bx prior to Tx':
		case 'Dx Bx':
		case 'TRUS':
		case 'trus':
		case 'TURP':
		case 'biopsy':
			$error = false;
			foreach($RP_fields as $new_field) if(strlen($values[$new_field])) $error = true;
			if($error) Config::$summary_msg['diagnosis: biopsy/surgery']['@@ERROR@@']['RP data set for Surgery/Biopsy Specification different than RP'][] = "See line $lines.";
			break;
		case 'RP':
			$error = false;
			foreach($Bx_TURP_fields as $new_field) if(strlen($values[$new_field])) $error = true;
			if($error) Config::$summary_msg['diagnosis: biopsy/surgery']['@@ERROR@@']['Biopsy data set for Surgery/Biopsy Specification different than Biopsy or turp'][] = "See line $lines.";
			break;
		case '':
			$error = false;
			foreach($Bx_TURP_fields as $new_field) if(strlen($values[$new_field])) $error = true;
			if($error) Config::$summary_msg['diagnosis: biopsy/surgery']['@@ERROR@@']['Biopsy data set for undefined Surgery/Biopsy Specification'][] = "See line $lines.";
			$error = false;
			foreach($RP_fields as $new_field) if(strlen($values[$new_field])) $error = true;
			if($error) Config::$summary_msg['diagnosis: biopsy/surgery']['@@ERROR@@']['RP data set for undefined Surgery/Biopsy Specification'][] = "See line $lines.";
			break;			
		default:
			die("ERROR: Invalid $type_field value [".$values[$type_field]."] for dx at line [$lines]".Config::$line_break_tag);
	}
	if(!empty($m->values[$type_field]) && empty($m->values[$date_field])) Config::$summary_msg['diagnosis: biopsy/surgery']['@@ERROR@@']['Date missing'][] = "Date is missing. See line $lines.";
	if(empty($m->values[$type_field]) && !empty($m->values[$date_field])) Config::$summary_msg['diagnosis: biopsy/surgery']['@@ERROR@@']['Unknown Type of Surgery'][] = "See line $lines.";
}
