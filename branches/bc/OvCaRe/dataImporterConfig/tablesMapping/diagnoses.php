<?php
$pkey = "VOA Number";
$child = array();
$master_fields = array(
	"diagnosis_control_id" => "#diagnosis_control_id",
	"participant_id" => $pkey,
	"morphology" => "Clinical WHO Code",
	"notes" => "#notes");

$detail_fields = array(
	"stage" => array("Stage" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3",
		"4"=>"4")),
	"substage" => array("Substage" => array(
		""=>"",
		"A"=>"A",
		"B"=>"B",
		"C"=>"C")),

	"clinical_diagnosis" => "Clinical Diagnosis",
	"clinical_history" => "Clinical History",

	"review_diagnosis" => "Review Diagnosis",
	"review_comment" => "Review Comment",
	"review_grade" => array("Review Grade" => array(
		""=>"",
		"1"=>"1",
		"2"=>"2",
		"3"=>"3"))
	);
	
//see the Model class definition for more info
$model = new MasterDetailModel(0, $pkey, $child, false, "participant_id", $pkey, 'diagnosis_masters', $master_fields, 'ovcare_dxd_ovaries', 'diagnosis_master_id', $detail_fields);

//we can then attach post read/write functions
$model->custom_data = array();
$model->post_read_function = 'postDiagnosisRead';
$model->insert_condition_function = 'preDiagnosisWrite';
$model->post_write_function = 'postDiagnosisWrite';

//adding this model to the config
Config::$models['DiagnosisMaster'] = $model;
	
function postDiagnosisRead(Model $m){
	$m->values['Clinical Diagnosis'] = utf8_encode($m->values['Clinical Diagnosis']);
	$m->values['Clinical History'] = utf8_encode($m->values['Clinical History']);
	
	return true;
}

function preDiagnosisWrite(Model $m){
	Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'] = null;
	Config::$record_ids_from_voa[Config::$current_voa_nbr]['ovcare_diagnosis_id'] = null;	
	
	$m->values['notes'] = '';
	
	// Substage
	$m->values['Substage'] = strtoupper($m->values['Substage']);
	
	// Manage WHO Codes
	
	if(!empty($m->values['Clinical WHO Code'])) {
		$tmp_who_code = $m->values['Clinical WHO Code'];
		$m->values['Clinical WHO Code'] = '';
		
		preg_match_all('/([0-9]{4}\/[0-9])/', $tmp_who_code, $matches);
		if(!empty($matches[0])) {
			$m->values['Clinical WHO Code'] = str_replace('/','',$matches[0][0]);
			unset($matches[0][0]);
			if(!empty($matches[0])) {
				Config::$summary_msg['@@MESSAGE@@']['WHO code #1'][] = 'Many values are defined into cell ['.$tmp_who_code.']. Only first one will be recorded into WHO field, the other one will be added to notes. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
				$m->values['notes'] = 'Additional WHO codes : '.implode(", ", $matches[0]);	
			}
			$tmp_who_code = str_replace(array(' ',',',CHR(10),CHR(13)), array('','','',''), preg_replace('/([0-9]{4}\/[0-9])/', '', $tmp_who_code));
			if(!empty($tmp_who_code)) {
				Config::$summary_msg['@@WARNING@@']['WHO code #1'][] = 'Both WHO code and text were defined into the source file. Add value ['.$tmp_who_code.'] as WHO comment. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
				$m->values['notes'] .= ' Additional WHO code comments : '.$tmp_who_code;	
			}
			if(!array_key_exists($m->values['Clinical WHO Code'], Config::$dx_who_codes)) {
				Config::$summary_msg['@@ERROR@@']['WHO code #1'][] = 'WHO code value ['.$m->values['Clinical WHO Code'].'] not supported into ATiM. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
				$m->values['notes'] .= ' WHO code not supported : '.$m->values['Clinical WHO Code'];					
				$m->values['Clinical WHO Code'] = '';
			}			
			
		} else {
			if(in_array($tmp_who_code, array('NA','Normal','N/A'))) {
				Config::$summary_msg['@@MESSAGE@@']['WHO code #2'][] = 'NA or Normal are not migrated. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
			
			} else {
				Config::$summary_msg['@@WARNING@@']['WHO code #2'][] = 'File values does not match the expected format ['.$tmp_who_code.']. Value will be added to the notes. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
				$m->values['notes'] = 'Wrong WHO codes migrated from source file: '.$tmp_who_code;
			}
		}
	}
	
	// Check data are recorded
	
	if(empty($m->values['morphology']) &&
	empty($m->values['notes']) &&
	empty($m->values['stage']) &&
	empty($m->values['substage']) &&
	empty($m->values['Clinical Diagnosis']) &&
	empty($m->values['Clinical History']) &&
	empty($m->values['Review Diagnosis']) &&
	empty($m->values['Review Comment']) &&
	empty($m->values['Review Grade'])) {
		Config::$summary_msg['@@WARNING@@']['OVCARE Primary Diagnosis #1'][] = 'Created an empty Primary Diagnosis. [VOA#: '.Config::$current_voa_nbr.' / line: '.$m->line.']';
	}
	
	// Primary vs Secondary
	
	preg_match('/(metastasis|metastatic)/', strtolower($m->values['Review Diagnosis']), $matches);
	if($matches) {
		
		// SECONDARY-OVCARE
		
		global $connection;
		
		//1- Unknown Primary: master
		
		$created = array(
			"created"		=> "NOW()", 
			"created_by"	=> Config::$db_created_id, 
			"modified"		=> "NOW()",
			"modified_by"	=> Config::$db_created_id
		);
		
		$insert_arr = array(
			"icd10_code" 			=> "'D489'", 
			"participant_id"		=> Config::$record_ids_from_voa[Config::$current_voa_nbr]['participant_id'], 
			"diagnosis_control_id"	=> "15"
		);
		$main_insert_arr = array_merge($insert_arr, $created);
		$query = "INSERT INTO diagnosis_masters (".implode(", ", array_keys($main_insert_arr)).") VALUES (".implode(", ", array_values($main_insert_arr)).")";
		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$unknown_primary_id = mysqli_insert_id($connection);
		$query = "UPDATE diagnosis_masters SET primary_id = $unknown_primary_id WHERE id = $unknown_primary_id;";
		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$rev_insert_arr = array_merge($insert_arr, array('id' => "$unknown_primary_id", 'primary_id' => "$unknown_primary_id", 'version_created' => "NOW()"));
		$query = "INSERT INTO diagnosis_masters_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		//2- Unknown Primary: detail
		
		$insert_arr = array(
			"diagnosis_master_id"	=> "$unknown_primary_id"
		);
		$query = "INSERT INTO dxd_primaries (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$detail_id = mysqli_insert_id($connection);
		$rev_insert_arr = array_merge($insert_arr, array('id' => "$detail_id", 'version_created' => "NOW()"));
		$query = "INSERT INTO dxd_primaries_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
		mysqli_query($connection, $query) or die("unknown primary insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		Config::$summary_msg['@@MESSAGE@@']['Unknown primary #1'][] = "A review defined ovcare diagnosis as secondary (see 'Review Diagnosis'): created an unknown primary. [VOA#: ".Config::$current_voa_nbr.' / line: '.$m->line.']';
		
		//2- Set data for scondary
		
		$m->values['diagnosis_control_id'] = "22";
		
		Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'] = $unknown_primary_id;
	
	} else {
		
		// PRIMARY-OVCARE
		
		$m->values['diagnosis_control_id'] = "20";
	}
	
	return true;
}

function postDiagnosisWrite(Model $m){
	global $connection;
	
	$ovcare_diagnosis_id = $m->last_id;
	Config::$record_ids_from_voa[Config::$current_voa_nbr]['ovcare_diagnosis_id'] = $ovcare_diagnosis_id;
	Config::$record_ids_from_voa[Config::$current_voa_nbr]['collection_diagnosis_id'] = $ovcare_diagnosis_id;
	
	$update_strg = "";
	if(empty(Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'])) {
		// OVCARE Diagnosis is a primary
		Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'] = $ovcare_diagnosis_id;	
	} else {
		// OVCARE Diagnosis is a secondary
		$update_strg .= 'parent_id = '.Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'].', ';
	}
	
	$update_strg .= "primary_id = ".Config::$record_ids_from_voa[Config::$current_voa_nbr]['primary_diagnosis_id'];
	
	$query = "UPDATE diagnosis_masters SET $update_strg WHERE id = $ovcare_diagnosis_id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = "UPDATE diagnosis_masters_revs SET $update_strg WHERE id = $ovcare_diagnosis_id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
}
