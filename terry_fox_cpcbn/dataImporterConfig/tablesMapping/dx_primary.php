<?php
$pkey = "Patient # in biobank";
$child = array(
);
$fields = array(
	'participant_id' => $pkey,
	'dx_date' => 'Date of diagnostics Date',
	'dx_date_accuracy'	=> array('Date of diagnostics Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_control_id' => '@14', //CPCBN dx
	'age_at_dx' => 'Age at Time of Diagnosis (yr)'
);

$detail_fields = array(
	'tool'	=> array('Date of diagnostics  diagnostic tool' => new ValueDomain("qc_tf_dx_tool", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)), 
	'gleason_score' => 'Gleason score at biopsy',
	'number_of_biopsies' => 'number of biospies (optional)',
	'ptnm' => 'pTNM',
	'gleason_score_rp' => array('Gleason sum RP' => new ValueDomain('qc_tf_gleason_sum_rp', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'presence_of_lymph_node_invasion' => array('Presence of lymph node invasion' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'presence_of_capsular_penetration' => array('Presence of capsular penetration' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'presence_of_seminal_vesicle_invasion' => array('Presence of seminal vesicle invasion' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'margin' => array('Margin' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'hormonorefractory_status' => array('hormonorefractory status status' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'hormonorefractory_date' => 'hormonorefractory status date of HR status diagnosis'
);

function checkBatch1Fields(Model $m){
	global $connection;
	global $insert;
	
	//might not be a dx, but dx stuff might be there
	$stuff = array('pTNM', 'Gleason sum RP', 'Presence of lymph node invasion', 'Presence of capsular penetration', 'Presence of seminal vesicle invasion', 'Margin');
	$got_stuff = false;
	foreach($stuff as $column){
		if(!empty($m->values[$column])){
			$got_stuff = true;
			break;
		}
	}
	
	if($got_stuff){
		$query = 'SELECT ptnm, gleason_score_rp, presence_of_lymph_node_invasion, presence_of_capsular_penetration, presence_of_seminal_vesicle_invasion, margin '
		.'FROM qc_tf_dxd_cpcbn WHERE diagnosis_master_id IN (SELECT id FROM diagnosis_masters WHERE participant_id='.$m->parent_model->last_id.')';
		$result = mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$row = mysqli_fetch_all($result);
		if(count($row) > 1){
			echo 'ERROR: More than one dx is associated to the participant found in dx at line ['.$m->line."]. Cannot update.\n";
			$insert = false;
		}else if(count($row) == 1){
			//check if the dx values are empty
			$got_stuff = false;
			foreach($row[0] as $row_value){
				if(!empty($row_value)){
					$got_stuff = true;
					break;
				}
			}
	
			if($got_stuff){
				echo 'ERROR: The dx associated to participant found in dx at line ['.$m->line."] already contains values for data defined on the current line. Cannot update.\n";
				$insert = false;
			}else{
				if(!$m->custom_data['qc_tf_ptnm']->isValidValue($m->values['pTNM'])){
					printf("WARNING: Invalid pTNM value [%s] for dx at line [%d]\n", $m->values['pTNM'], $m->line);
					$m->values['pTNM'] = '';
				}
				if(!$m->custom_data['qc_tf_gleason_score_biopsy']->isValidValue($m->values['Gleason sum RP'])){
					printf("WARNING: Invalid Gleason sum RP value [%s] for dx at line [%d]\n", $m->values['Gleason sum RP'], $m->line);
					$m->values['Gleason sum RP'] = '';
				}
					
				$convert_ynu = array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '');
				foreach(array('Presence of lymph node invasion', 'Presence of capsular penetration', 'Presence of seminal vesicle invasion', 'Margin') as $field_name){
					if(array_key_exists($m->values[$field_name], $convert_ynu)){
						$m->values[$field_name] = $convert_ynu[$m->values[$field_name]];
					}else{
						printf("WARNING: Invalid %s value [%s] for dx at line [%d]\n", $field_name, $m->values[$field_name], $m->line);
						$m->values[$field_name] = '';
					}
				}
					
				//update
				$query = sprintf('UPDATE qc_tf_dxd_cpcbn SET ptnm="%s", gleason_score_rp="%s", presence_of_lymph_node_invasion="%s", presence_of_capsular_penetration="%s", presence_of_seminal_vesicle_invasion="%s", margin="%s" WHERE diagnosis_master_id=(SELECT id FROM diagnosis_masters WHERE participant_id='.$m->parent_model->last_id.')',
					$m->values['pTNM'],
					$m->values['Gleason sum RP'],
					$m->values['Presence of lymph node invasion'],
					$m->values['Presence of capsular penetration'],
					$m->values['Presence of seminal vesicle invasion'],
					$m->values['Margin']
				);
				mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}
		}
	}
}

function checkBatch2Fields(Model $m){
	global $connection;
	global $insert;
	
	//might not be a dx, but dx stuff might be there
	$stuff = array('hormonorefractory status status', 'hormonorefractory status date of HR status diagnosis');
	$got_stuff = false;
	foreach($stuff as $column){
		if(!empty($m->values[$column])){
			$got_stuff = true;
			break;
		}
	}
	
	if($got_stuff){
		$query = 'SELECT hormonorefractory_status, hormonorefractory_date '
		.'FROM qc_tf_dxd_cpcbn WHERE diagnosis_master_id IN (SELECT id FROM diagnosis_masters WHERE participant_id='.$m->parent_model->last_id.')';
		$result = mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$row = mysqli_fetch_all($result);
		if(count($row) > 1){
			echo 'ERROR: More than one dx is associated to the participant found in dx at line ['.$m->line."]. Cannot update.\n";
			$insert = false;
		}else if(count($row) == 1){
			//check if the dx values are empty
			$got_stuff = false;
			foreach($row[0] as $row_value){
				if(!empty($row_value)){
					$got_stuff = true;
					break;
				}
			}
		
			if($got_stuff){
				echo 'ERROR: The dx associated to participant found in dx at line ['.$m->line."] already contains values for data defined on the current line. Cannot update.\n";
				$insert = false;
			}else{
				$convert_ynu = array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '');
				if(array_key_exists($m->values['hormonorefractory status status'], $convert_ynu)){
					$m->values['hormonorefractory status status'] = $convert_ynu[$m->values['hormonorefractory status status']];
				}else{
					printf("WARNING: Invalid %s value [%s] for dx at line [%d]\n", $field_name, $m->values['hormonorefractory status status'], $m->line);
					$m->values['hormonorefractory status status'] = '';
				}
					
				//update
				$query = sprintf('UPDATE qc_tf_dxd_cpcbn SET hormonorefractory_status="%s", hormonorefractory_date="%s" WHERE diagnosis_master_id=(SELECT id FROM diagnosis_masters WHERE participant_id='.$m->parent_model->last_id.')',
					$m->values['hormonorefractory status status'],
					$m->values['hormonorefractory status date of HR status diagnosis']
				);
				mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}
		}
	}
}

function postDxRead(Model $m){
	excelDateFix($m);
	
	if(empty($m->values['Date of diagnostics Date'])){
		checkBatch1Fields($m);
		
		return false;
	}
	
	$m->values['Age at Time of Diagnosis (yr)'] = (int)$m->values['Age at Time of Diagnosis (yr)'];
	return true;
}

function postDxWrite(Model $m){
	global $connection;
	$query = 'UPDATE diagnosis_masters SET primary_id=id WHERE id='.$m->last_id;
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}

$model = new MasterDetailModel(1, $pkey, $child, false, 'participant_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_cpcbn', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"]							=> key($fields["dx_date_accuracy"]),
		$fields['hormonorefractory_date']			=> NULL
	), 'qc_tf_ptnm' => new ValueDomain('qc_tf_ptnm', ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_SENSITIVE),
	'qc_tf_gleason_score_biopsy' => new ValueDomain('qc_tf_gleason_sum_rp', ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)
);

$model->post_read_function = 'postDxRead';
$model->post_write_function = 'postDxWrite';
Config::addModel($model, 'dx_primary');
