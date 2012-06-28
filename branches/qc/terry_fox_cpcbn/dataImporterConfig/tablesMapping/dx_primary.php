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
 	'event_psa'
);
$fields = array(
	'participant_id' 		=> $pkey,
	'dx_date' 				=> 'Date of diagnostics Date',
	'dx_date_accuracy'		=> array('Date of diagnostics Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_control_id'	=> '#diagnosis_control_id', //CPCBN dx
	'age_at_dx' 			=> 'Age at Time of Diagnosis (yr)'
);

$detail_fields = array(
	'tool'									=> array('Date of diagnostics  diagnostic tool' => new ValueDomain("qc_tf_dx_tool", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)), 
	'gleason_score_biopsy' 					=> array('Gleason score at biopsy' => new ValueDomain('qc_tf_gleason_values', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'ptnm' 									=> array('pTNM' => new ValueDomain('qc_tf_ptnm', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'gleason_score_rp' 						=> array('Gleason sum RP' => new ValueDomain('qc_tf_gleason_values', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'presence_of_lymph_node_invasion' 		=> array('Presence of lymph node invasion' => array('yes' => 'y', 'no' => 'n', 'unknown' => '', '' => '')),
	'presence_of_capsular_penetration' 		=> array('Presence of capsular penetration' => array('yes' => 'y', 'no' => 'n', 'unknown' => '', '' => '')),
	'presence_of_seminal_vesicle_invasion'	=> array('Presence of seminal vesicle invasion' => array('yes' => 'y', 'no' => 'n', 'unknown' => '', '' => '')),
	'margin' 								=> array('Margin' => array('yes' => 'y', 'no' => 'n', 'unknown' => '', '' => '')),
	'hormonorefractory_status' 				=> array('hormonorefractory status status' => new ValueDomain('qc_tf_hormonorefractory_status', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE))
);

$model = new MasterDetailModel(1, $pkey, $child, false, 'participant_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_cpcbn', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"]	=> key($fields["dx_date_accuracy"])
	), 
	'last_pkey' => null,
	'previous_data' => null,
	'previous_line' => null,
	'prostate_dx_fields' => array(
		'dx_date' => 'Date of diagnostics Date',
		'dx_date_accuracy' => 'Date of diagnostics Accuracy',
		'age_at_dx' => 'Age at Time of Diagnosis (yr)',

		'tool' => 'Date of diagnostics  diagnostic tool',
		'gleason_score_biopsy' => 'Gleason score at biopsy',
		'ptnm' => 'pTNM',
		'gleason_score_rp' => 'Gleason sum RP',
		'presence_of_lymph_node_invasion' => 'Presence of lymph node invasion',
		'presence_of_capsular_penetration' => 'Presence of capsular penetration',
		'presence_of_seminal_vesicle_invasion' => 'Presence of seminal vesicle invasion',
		'margin' => 'Margin',

		'hormonorefractory_status' => 'hormonorefractory status status')
);

$model->post_read_function = 'postDxRead';
$model->post_write_function = 'postDxWrite';
Config::addModel($model, 'dx_primary');

function postDxRead(Model $m){
	global $connection;
	
	if(!is_null($m->custom_data['previous_line']) && $m->custom_data['previous_line'] != ($m->line - 1)) {
		pr($m->values);
		pr($m->line - 1);
		exit;
		Config::$summary_msg['diagnosis']['@@ERROR@@']['Missing Patient # in biobank'][] = "Check patient # is set or data exists. See line ".($m->line-1).".";
	}
	$m->custom_data['previous_line'] = $m->line;
	
	$m->values['diagnosis_control_id'] = Config::$dx_controls['primary']['prostate']['id'];
	excelDateFix($m);
	
	if(!preg_match('/^([0-9]*)(\.[0-9]+){0,1}$/', $m->values['Age at Time of Diagnosis (yr)'], $matches)) {
		Config::$summary_msg['diagnosis: primary']['@@WARNING@@']['Age at Time of Diagnosis: wrong format'][] = "See value [".$m->values['Age at Time of Diagnosis (yr)']."] at line ".$m->line.".";
		$m->values['Age at Time of Diagnosis (yr)'] = '';
	} else if(isset($matches[2])) {
		Config::$summary_msg['diagnosis: primary']['@@MESSAGE@@']['Age at Time of Diagnosis: decimal'][] = "See value [".$m->values['Age at Time of Diagnosis (yr)']."] changed to [".$matches[1]."] at line ".$m->line.".";
		$m->values['Age at Time of Diagnosis (yr)'] = $matches[1];
	}
	$m->values['pTNM'] =str_replace(array('III','II','I'), array('3','2','1'),$m->values['pTNM']);
	
	if($m->values['Patient # in biobank'] == $m->custom_data['last_pkey']){
		//only one primary dx per participant
		//Config::$summary_msg['diagnosis: primary']['@@MESSAGE@@']['More than one line per participant'][] = "Primary dx already created for patient [".$m->values['Patient # in biobank']."] but a new dx line is being defined. Please validate data! [see line ".$m->line."].";
		manageManyRows($m);
		return false;
	} else {
		$m->custom_data['dx_data_already_recorded'] = array();
		foreach($m->custom_data['prostate_dx_fields'] as $field) {
			if(strlen($m->values[$field])) $m->custom_data['dx_data_already_recorded'][$field] = $m->values[$field];
		} 
	}
	
	$m->custom_data['last_pkey'] = $m->values['Patient # in biobank'];
		
	return true;
}

function postDxWrite(Model $m){
	return true;
}

function manageManyRows(Model $m){
	global $connection;
	
	$db_participant_id = $m->parent_model->last_id;
	
	$value_to_add = array('diagnsosis_masters' => array(), 'qc_tf_dxd_cpcbn' => array());
	$value_already_set = array();
	foreach($m->custom_data['prostate_dx_fields'] as $db_field => $new_field) {
		if(strlen($m->values[$new_field])) {
			if(array_key_exists($new_field, $m->custom_data['dx_data_already_recorded'])) {
				// already set
				$value_already_set[] = $new_field;
				
			} else {
				// New value to add to prostate dx
				$m->custom_data['dx_data_already_recorded'][$new_field] = $m->values[$new_field];
				
				switch($new_field) {				
					case 'Date of diagnostics  diagnostic tool':
					case 'Gleason score at biopsy':
					case 'pTNM':
					case 'Gleason sum RP':
					case 'hormonorefractory status status':
						$value_domain = current($m->detail_fields[$db_field]);
						$m->values[$new_field] = $value_domain->isValidValue($m->values[$new_field]);
						if(is_null($m->values[$new_field])){
							printf("WARNING: Invalid [$new_field] value [%s] for dx at line [%d]".Config::$line_break_tag, $m->values[$new_field], $m->line);
						} else {
							$value_to_add['qc_tf_dxd_cpcbn'][] = $db_field.'="'.$m->values[$new_field].'"';
						}
						break;
						
					case 'Presence of lymph node invasion':
					case 'Presence of capsular penetration':
					case 'Presence of seminal vesicle invasion':
					case 'Margin':				
						$convert_ynu = current($m->detail_fields[$db_field]);
						if(array_key_exists($m->values[$new_field], $convert_ynu)){
							$value_to_add['qc_tf_dxd_cpcbn'][] = $db_field.'="'.$convert_ynu[$m->values[$new_field]].'"';
						}else{
							printf("WARNING: Invalid %s value [%s] for dx at line [%d]".Config::$line_break_tag, $new_field, $m->values[$new_field], $m->line);
						}
						break;
						
					case 'Date of diagnostics Date':
					case 'Date of diagnostics Accuracy':
					case 'Age at Time of Diagnosis (yr)':
						$value_to_add['diagnosis_masters'][] = $db_field.'="'.$m->values[$new_field].'"';	
						break;
						
					default:
						$value_to_add['qc_tf_dxd_cpcbn'][] = $db_field.'="'.$m->values[$new_field].'"';	
				}
			}
		}
	}
	
	if(!empty($value_already_set)) {
		Config::$summary_msg['diagnosis: primary']['@@WARNING@@']['Duplicated information'][] = "Following fields (".implode(', ', $value_already_set).") values are duplicated for patient # [".$m->values['Patient # in biobank']."] see line [".$m->line."].";
	}	
	foreach($value_to_add as $table => $data) {	
		if(!empty($data)) {
			$query = "UPDATE $table SET ".implode(', ', $data)." WHERE ".
				(($table == 'diagnosis_masters')? 
					"participant_id = $db_participant_id AND diagnosis_control_id = 14;" :
					"diagnosis_master_id=(SELECT id FROM diagnosis_masters WHERE participant_id = $db_participant_id AND diagnosis_control_id = ".Config::$dx_controls['primary']['prostate']['id'].");");		
			mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			if(Config::$print_queries) echo $query.Config::$line_break_tag;
			$query = str_replace($table, $table.'_revs',$query);
			mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			if(Config::$print_queries) echo $query.Config::$line_break_tag;
		}
	}
}