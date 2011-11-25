<?php
$pkey = "Patient # in biobank";
$child = array(
	'dx_metastasis',
	'dx_recurrence'
);
$fields = array(
	'participant_id' 		=> $pkey,
	'dx_date' 				=> 'Date of diagnostics Date',
	'dx_date_accuracy'		=> array('Date of diagnostics Accuracy' => array("c" => "c", "y" => "y", "m" => "m", "" => "")),
	'diagnosis_control_id'	=> '@14', //CPCBN dx
	'age_at_dx' 			=> 'Age at Time of Diagnosis (yr)'
);

$detail_fields = array(
	'tool'									=> array('Date of diagnostics  diagnostic tool' => new ValueDomain("qc_tf_dx_tool", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE)), 
	'gleason_score' 						=> 'Gleason score at biopsy',
	'number_of_biopsies' 					=> 'number of biospies (optional)',
	'ptnm' 									=> array('pTNM' => new ValueDomain('qc_tf_ptnm', ValueDomain::DONT_ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'gleason_score_rp' 						=> array('Gleason sum RP' => new ValueDomain('qc_tf_gleason_sum_rp', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'presence_of_lymph_node_invasion' 		=> array('Presence of lymph node invasion' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'presence_of_capsular_penetration' 		=> array('Presence of capsular penetration' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'presence_of_seminal_vesicle_invasion'	=> array('Presence of seminal vesicle invasion' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'margin' 								=> array('Margin' => array('yes' => 'y', 'no' => 'n', 'unknown' => 'u', '' => '')),
	'hormonorefractory_status' 				=> array('hormonorefractory status status' => new ValueDomain('qc_tf_hormonorefractory_status', ValueDomain::ALLOW_BLANK, ValueDomain::CASE_SENSITIVE)),
	'hormonorefractory_date_hr' 			=> 'hormonorefractory status date of HR status diagnosis'
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
		.'FROM qc_tf_dxd_cpcbn WHERE diagnosis_master_id IN (SELECT id FROM diagnosis_masters WHERE participant_id='.$m->parent_model->last_id.' AND parent_id IS NULL)';
		$result = mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$row = mysqli_fetch_all($result);
		if(count($row) > 1){
			echo 'ERROR: More than one dx is associated to the participant found in dx at line ['.$m->line."]. Cannot update.\n";
			$insert = false;
		}else if(count($row) == 1){
			//check if the dx values are empty
			$got_stuff = false;
			foreach($row[0] as $row_value){
				if(!Database::sqlEmpty($row_value)){
					$got_stuff = true;
					break;
				}
			}
	
			if($got_stuff){
				echo 'ERROR: The dx associated to participant found in dx at line ['.$m->line."] already contains values for data defined on the current line. Cannot update. (checkBatch1Fields)\n";
				$insert = false;
			}else{
				$ptnm_value_domain = current($m->detail_fields['ptnm']); 
				if(!$ptnm_value_domain->isValidValue($m->values['pTNM'])){
					printf("WARNING: Invalid pTNM value [%s] for dx at line [%d]\n", $m->values['pTNM'], $m->line);
					$m->values['pTNM'] = '';
				}
				$gleason_score_biopsy_value_domain = current($m->detail_fields['gleason_score_rp']); 
				if(!$gleason_score_biopsy_value_domain->isValidValue($m->values['Gleason sum RP'])){
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
				$query = sprintf('UPDATE qc_tf_dxd_cpcbn SET ptnm="%s", gleason_score_rp="%s", presence_of_lymph_node_invasion="%s", presence_of_capsular_penetration="%s", presence_of_seminal_vesicle_invasion="%s", margin="%s" WHERE diagnosis_master_id=(SELECT id FROM diagnosis_masters WHERE participant_id='.$m->parent_model->last_id.' AND parent_id IS NULL)',
					$m->values['pTNM'],
					$m->values['Gleason sum RP'],
					$m->values['Presence of lymph node invasion'],
					$m->values['Presence of capsular penetration'],
					$m->values['Presence of seminal vesicle invasion'],
					$m->values['Margin']
				);
				mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				Database::insertRevForLastRow('qc_tf_dxd_cpcbn');
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
		$query = 'SELECT hormonorefractory_status, hormonorefractory_date_hr '
		.'FROM qc_tf_dxd_cpcbn WHERE diagnosis_master_id IN (SELECT id FROM diagnosis_masters WHERE participant_id='.$m->parent_model->last_id.' AND parent_id IS NULL)';
		$result = mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$row = mysqli_fetch_all($result);
		if(count($row) > 1){
			echo 'ERROR: More than one dx is associated to the participant found in dx at line ['.$m->line."]. Cannot update.\n";
			$insert = false;
		}else if(count($row) == 1){
			//check if the dx values are empty
			$got_stuff = false;
			foreach($row[0] as $row_value){
				if(!Database::sqlEmpty($row_value)){
					$got_stuff = true;
					break;
				}
			}
		
			if($got_stuff){
				echo 'ERROR: The dx associated to participant found in dx at line ['.$m->line."] already contains values for data defined on the current line. Cannot update. (checkBatch2Fields)\n";
				print_r($row);
				die('d');
				$insert = false;
			}else{
				$hormono_status_value_domain = current($m->detail_fields['hormonorefractory_status']);
				if(!$hormono_status_value_domain->isValidValue($m->values['hormonorefractory status status'])){
					printf("WARNING: Invalid hormonorefractory status status value [%s] for dx at line [%d]\n", $m->values['hormonorefractory status status'], $m->line);
				}
					
				//update
				$query = sprintf('UPDATE qc_tf_dxd_cpcbn SET hormonorefractory_status="%s", hormonorefractory_date_hr=%s WHERE diagnosis_master_id=(SELECT id FROM diagnosis_masters WHERE participant_id='.$m->parent_model->last_id.' AND parent_id IS NULL)',
					$m->values['hormonorefractory status status'],
					empty($m->values['hormonorefractory status date of HR status diagnosis']) ? 'NULL' : '"'.$m->values['hormonorefractory status date of HR status diagnosis'].'"'
				);
				mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			}
		}
	}
}

function postDxRead(Model $m){
	global $connection;
	excelDateFix($m);
	
	if($m->values['Patient # in biobank'] == $m->custom_data['last_pkey']){
		//only one primary dx per participant
		if(!empty($m->values['Date of diagnostics Date'])){
			echo 'WARNING: Primary dx already created but a new one is being defined at dx line ['.$m->line."]\n";
		}
		checkBatch1Fields($m);
		checkBatch2Fields($m);
		return false;
	}
	$m->custom_data['last_pkey'] = $m->values['Patient # in biobank']; 
	
	$m->values['Age at Time of Diagnosis (yr)'] = (int)$m->values['Age at Time of Diagnosis (yr)'];
	return true;
}

function postDxWrite(Model $m){
	global $connection;
	$query = 'UPDATE diagnosis_masters SET primary_id=id WHERE id='.$m->last_id;
	mysqli_query($connection, $query) or die(__FUNCTION__." [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	if($m->parent_model->custom_data['diagnosis_master_id'] != null){
		echo 'WARNING: More than one primary dx exists for participant having a Dx at line ['.$m->line."]\n";
	}
	$m->parent_model->custom_data['diagnosis_master_id'] = $m->last_id;
}

$model = new MasterDetailModel(1, $pkey, $child, false, 'participant_id', $pkey, 'diagnosis_masters', $fields, 'qc_tf_dxd_cpcbn', 'diagnosis_master_id', $detail_fields);
$model->custom_data = array(
	"date_fields" => array(
		$fields["dx_date"]							=> key($fields["dx_date_accuracy"]),
		$detail_fields['hormonorefractory_date_hr']	=> NULL
	), 'last_pkey' => null
);

$model->post_read_function = 'postDxRead';
$model->post_write_function = 'postDxWrite';
Config::addModel($model, 'dx_primary');
