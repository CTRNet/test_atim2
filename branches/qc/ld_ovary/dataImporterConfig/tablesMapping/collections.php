<?php
$pkey = "id";
$child = array();
$fields = array();

//see the Model class definition for more info
$model = new Model(0, $pkey, $child, false, NULL, NULL, 'collections', $fields);

//we can then attach post read/write functions
$model->post_read_function = 'postLineRead';
$model->post_write_function = null;
$model->custom_data = array();

//adding this model to the config
Config::$models['Collection'] = $model;

function postLineRead(Model $m){
	
	global $connection;
	
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
	$id = $m->values['id'];
	$new_box = array_key_exists('location', $m->values)? $m->values['location'] : null;
	$new_patient = array_key_exists('patient ID', $m->values)? $m->values['patient ID'] : null;
	$sample_label = array_key_exists('samples', $m->values)? $m->values['samples'] : null;
	
	if(!empty($sample_label)) {
	
		// ** 1 ** Manage Box
		
		if(!empty($new_box)) {
			
			$new_box = strtoupper($new_box);
			$new_box_formated = str_replace(array(' ', '"', 'BOX'), array('','', ''), strtoupper($new_box));
			if(strlen($new_box_formated) > 10) echo "<br>STORAGE NAME: Too Long : ...[$new_box]<br>";
			$new_box_formated = substr($new_box_formated, 0, 10);
			
			$insert = array(
				"code" => "'-1'",
				"storage_type"			=> "'box'",
				"storage_control_id"	=> "8",
				"short_label"			=> "'".$new_box_formated."'",
				"selection_label"		=> "'".$new_box_formated."'",
				"lft"		=> "'".(Config::$storages['next_left'])."'",
				"rght"		=> "'".(Config::$storages['next_left'] + 1)."'",
				"set_temperature"	=> "'FALSE'"
			);
			$insert = array_merge($insert, $created);
			$query = "INSERT INTO storage_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query($connection, $query) or die("STORAGE INSERT [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$storage_master_id = mysqli_insert_id($connection);
			$query = "UPDATE storage_masters SET code=CONCAT('B - ', id) WHERE id=".$storage_master_id;
			mysqli_query($connection, $query) or die("STORAGE INSERT [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			
			$insert = array(
				"storage_master_id"	=> $storage_master_id,
			);
			$query = "INSERT INTO std_boxs (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query($connection, $query) or die("STORAGE INSERT [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
					
			Config::$storages['next_left'] = Config::$storages['next_left'] + 2;
			Config::$storages['current_id'] = $storage_master_id;
		}
		
		// ** 2 ** Manage participant and collection data
		
		$new_collection_label = '';
		if(!empty($new_patient)) {
			$new_patient = str_replace(' ','', strtoupper($new_patient));			
			preg_match('/^([A-Z\-]{2,6}[0-9]{2,6})/', $new_patient, $matches);
			if(isset($matches[1])) {
				$new_collection_label = $matches[1];
			} else {
				echo "<br>GET COLLECTION LABEL: The following patient id [$new_patient] has not been considered as a new patient  (Line ".__LINE__.")<br>";		
			}
		}

		if(!empty($new_collection_label)) {
			if(!is_null(Config::$current_participant['collection_label'])) {
				// Record previous participant data
				//recordParticipantAndCollection($m);		
			} 
			
			// Reset data
			
			preg_match('/^([A-Z\-]{2,6})([0-9]{2,6})$/', $new_collection_label, $matches);
			if(!isset($matches[1]) || !isset($matches[2])) die("ERR 993773");
			
			Config::$current_participant['initial'] = $matches[1];
			Config::$current_participant['collection_label'] = $new_collection_label;
			Config::$current_participant['collection_date'] = null;
			Config::$current_participant['samples'] = array();

			//Validate date
			$collection_date = $matches[2];
			if(strlen($collection_date) == 6) {
				$fomatted_collection_date = substr($collection_date, 0, 2).'-'.substr($collection_date, 2, 2).'-'.substr($collection_date, 4, 2);
				if(DateTime::createFromFormat('y-m-d', $fomatted_collection_date) === FALSE) {
					echo "<br>GET COLLECTION DATE: Wrong collection date [$collection_date] (Line ".$m->line.")<br>";
				} else {
					Config::$current_participant['collection_date'] = $fomatted_collection_date;
				}
			} else if(strlen($collection_date) == 5) {
				$fomatted_collection_date = '0'.substr($collection_date, 0, 1).'-'.substr($collection_date, 1, 2).'-'.substr($collection_date, 3, 2);
				if(DateTime::createFromFormat('y-m-d', $fomatted_collection_date) === FALSE) {
					echo "<br>GET COLLECTION DATE: Wrong collection date [$collection_date] (Line ".$m->line.")<br>";
				} else {
					Config::$current_participant['collection_date'] = $fomatted_collection_date;
				}
			} else if(strlen($collection_date) == 4) {
				$fomatted_collection_date = '0'.substr($collection_date, 0, 1).'-0'.substr($collection_date, 1, 1).'-'.substr($collection_date, 2, 2);
				if(DateTime::createFromFormat('y-m-d', $fomatted_collection_date) === FALSE) {
					echo "<br>GET COLLECTION DATE: Wrong collection date [$collection_date] (Line ".$m->line.")<br>";
				} else {
					Config::$current_participant['collection_date'] = $fomatted_collection_date;
				}
			} else if(strlen($collection_date) == 3) {
				$fomatted_collection_date = '0'.substr($collection_date, 0, 1).'-0'.substr($collection_date, 1, 1).'-0'.substr($collection_date, 2, 1);
				if(DateTime::createFromFormat('y-m-d', $fomatted_collection_date) === FALSE) {
					echo "<br>GET COLLECTION DATE: Wrong collection date [$collection_date] (Line ".$m->line.")<br>";
				} else {
					Config::$current_participant['collection_date'] = $fomatted_collection_date;
				}
			} else {
				echo "<br>GET COLLECTION DATE: Wrong collection date [$collection_date] (Line ".$m->line.")<br>";
			}
		}
		
		// ** 3 ** Manage samples
		
		buildParticipantCollection($m, $sample_label);

	}
	
	return false;
}

function buildParticipantCollection(Model $m, $sample_label){
	$formatted_sample_label = '';
	if($sample_label == utf8_decode('cervical tu (-20˚c overnight in o.r)'))  {
		exit;
		$formatted_sample_label = 'cervical tu';
		$sample_label = 'cervical tu (-20˚c overnight in o.r)';
	} else {
		$formatted_sample_label = strtolower(preg_replace(array('/\ $/', '/^\ /', '/\ [0-9A-Ea-e]$/', '/\ [12][0-9]$/', '/[0-9]$/'), array('', '', '', '', ''), $sample_label));
	}
			
	if(!array_key_exists($formatted_sample_label, Config::$label_2_sample_description)) {
		echo "<br><FONT COLOR=\"red\" >FUNCTION buildParticipantCollection : The label [$sample_label]($formatted_sample_label) is not defined into the Match Table Worksheet (Line ".$m->line.")</FONT><br>";
Config::$missing[$formatted_sample_label] = '-';
	} else {
		// Set sample and aliquot information
		$sample_and_aliquot_data = Config::$label_2_sample_description[$formatted_sample_label];
		
		$aliquot_data = array(
			'type' => (array_key_exists('is_clot', $sample_and_aliquot_data) && $sample_and_aliquot_data['is_clot'])? 'clot tube' : 'tube', 
			'aliquot_label' => Config::$current_participant['collection_label'].' '.$sample_label, 
			'storage_master_id' => Config::$storages['current_id']);
		
		$sample_type = $sample_and_aliquot_data['sample_type'];
		switch($sample_type) {
			
			// TISSUE
			
			case 'tissue':
				$tissue_key = 'tissue ['.$sample_and_aliquot_data['tissue_source'].'/'.$sample_and_aliquot_data['tissue_type'].'/'.$sample_and_aliquot_data['tissue_laterality'].']';
				if(!isset(Config::$current_participant['samples'][$tissue_key])) {
					Config::$current_participant['samples'][$tissue_key] = array(
						'type' => 'tissue', 
						'details' => $sample_and_aliquot_data, 
						'aliquots' => array(), 
						'derivatives' => array());
					unset(Config::$current_participant['samples'][$tissue_key]['details']['sample_type']);
				}
				Config::$current_participant['samples'][$tissue_key]['aliquots'][] = $aliquot_data;
				break;
				
			// ASCITE
				
			case 'ascite':
				if(!isset(Config::$current_participant['samples']['ascite'])) {
					Config::$current_participant['samples']['ascite'] = array('type' => 'ascite', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				Config::$current_participant['samples']['ascite']['aliquots'][] = $aliquot_data;
				break;
			case 'ascite supernatant':	
			case 'ascite cell':
				if(!isset(Config::$current_participant['samples']['ascite'])) {
					Config::$current_participant['samples']['ascite'] = array('type' => 'ascite', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				if(!isset(Config::$current_participant['samples']['ascite']['derivatives'][$sample_type])) {
					Config::$current_participant['samples']['ascite']['derivatives'][$sample_type] = array('type' => $sample_type, 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				Config::$current_participant['samples']['ascite']['derivatives'][$sample_type]['aliquots'][] = $aliquot_data;
				break;
				
				
			// BLOOD
			
			case 'blood':
				if(!isset(Config::$current_participant['samples']['blood'])) {
					Config::$current_participant['samples']['blood'] = array('type' => 'blood', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				Config::$current_participant['samples']['blood']['aliquots'][] = $aliquot_data;
				break;						
			case 'serum':			
			case 'plasma':			
			case 'blood cell':
				if(!isset(Config::$current_participant['samples']['blood'])) {
					Config::$current_participant['samples']['blood'] = array('type' => 'blood', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				if(!isset(Config::$current_participant['samples']['blood']['derivatives'][$sample_type])) {
					Config::$current_participant['samples']['blood']['derivatives'][$sample_type] = array('type' => $sample_type, 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				Config::$current_participant['samples']['blood']['derivatives'][$sample_type]['aliquots'][] = $aliquot_data;
				break;					
				
			// CYSTIC FLUID
			
			case 'cystic fluid':
				if(!isset(Config::$current_participant['samples']['cystic fluid'])) {
					Config::$current_participant['samples']['cystic fluid'] = array('type' => 'cystic fluid', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				Config::$current_participant['samples']['cystic fluid']['aliquots'][] = $aliquot_data;
				break;	
			case 'cystic fluid supernatant':			
			case 'cystic fluid cell':
				if(!isset(Config::$current_participant['samples']['cystic fluid'])) {
					Config::$current_participant['samples']['cystic fluid'] = array('type' => 'cystic fluid', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				if(!isset(Config::$current_participant['samples']['cystic fluid']['derivatives'][$sample_type])) {
					Config::$current_participant['samples']['cystic fluid']['derivatives'][$sample_type] = array('type' => $sample_type, 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				Config::$current_participant['samples']['cystic fluid']['derivatives'][$sample_type]['aliquots'][] = $aliquot_data;
				break;
				
			// PERITONEAL WASH

			case 'peritoneal wash':
				if(!isset(Config::$current_participant['samples']['peritoneal wash'])) {
					Config::$current_participant['samples']['peritoneal wash'] = array('type' => 'peritoneal wash', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}				
				Config::$current_participant['samples']['peritoneal wash']['aliquots'][] = $aliquot_data;
				break;	
			case 'peritoneal wash supernatant':			
			case 'peritoneal wash cell':
				if(!isset(Config::$current_participant['samples']['peritoneal wash'])) {
					Config::$current_participant['samples']['peritoneal wash'] = array('type' => 'peritoneal wash', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				if(!isset(Config::$current_participant['samples']['peritoneal wash']['derivatives'][$sample_type])) {
					Config::$current_participant['samples']['peritoneal wash']['derivatives'][$sample_type] = array('type' => $sample_type, 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				Config::$current_participant['samples']['peritoneal wash']['derivatives'][$sample_type]['aliquots'][] = $aliquot_data;
				break;

			// PLEURAL FLUID

			case 'pleural fluid':
				if(!isset(Config::$current_participant['samples']['pleural fluid'])) {
					Config::$current_participant['samples']['pleural fluid'] = array('type' => 'pleural fluid', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}				
				Config::$current_participant['samples']['pleural fluid']['aliquots'][] = $aliquot_data;
				break;	
			case 'pleural fluid supernatant':			
			case 'pleural fluid cell':
				if(!isset(Config::$current_participant['samples']['pleural fluid'])) {
					Config::$current_participant['samples']['pleural fluid'] = array('type' => 'pleural fluid', 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				if(!isset(Config::$current_participant['samples']['pleural fluid']['derivatives'][$sample_type])) {
					Config::$current_participant['samples']['pleural fluid']['derivatives'][$sample_type] = array('type' => $sample_type, 'details' => array(), 'aliquots' => array(), 'derivatives' => array());
				}
				Config::$current_participant['samples']['pleural fluid']['derivatives'][$sample_type]['aliquots'][] = $aliquot_data;
				break;
				
			default:
				die ("ERR: 98723492394 sample type [".$sample_type."] is not supported!") ;
		}
	}
}

function recordParticipantAndCollection(Model $m) {

	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);

	// Create participant
	
	$insert = array(
		"participant_identifier" => "'-1'",
		"qc_ldov_initals"	=> "'".Config::$current_participant['initial']."'"
	);
	$insert = array_merge($insert, $created);
	$query = "INSERT INTO participants (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query($connection, $query) or die("participant insert [".$m->line."] qry failed [".$query."] ".mysqli_error($connection));
	$participant_id = mysqli_insert_id($connection);
	$query = "UPDATE participants SET participant_identifier=CONCAT(qc_ldov_initals, ' (', id, ')') WHERE id=".$participant_id;
	mysqli_query($connection, $query) or die("participant insert [".$m->line."] qry failed [".$query."] ".mysqli_error($connection));
	
	// Create collection

	$insert = array(
		"acquisition_label" => "'".Config::$current_participant['collection_label']."'",
		"bank_id" => "1", 
		"collection_datetime" => "'".Config::$current_participant['collection_date']."'",
		"collection_property" => "'participant collection'"
	);
	$insert = array_merge($insert, $created);
	$query = "INSERT INTO collections (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$collection_id = mysqli_insert_id($connection);
	
	// Create link
	
	$insert = array(
		"collection_id" => $collection_id,
		"participant_id" => $participant_id
	);
	$insert = array_merge($insert, $created);
	$query = "INSERT INTO clinical_collection_links (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
	mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

	foreach(Config::$current_participant['samples'] as $tmp => $specimen_data) {
		$sample_master_id = null;
		
		$sample_type = $specimen_data['type'];
		if(!array_key_exists($sample_type, Config::$sample_aliquot_controls)) die("ERR: 98983q.".$sample_type);
		$sample_control_data = Config::$sample_aliquot_controls[$sample_type];
		
		// Create Specimen
		
		$insert = array(
			"sample_type"					=> "'".$sample_type."'",  
			"sample_category"				=> "'specimen'", 
			"collection_id"					=> "'".$collection_id."'", 
			"sample_control_id"				=> $sample_control_data['sample_control_id'], 
			"sample_code" 					=> "'tmp'", 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'".$sample_type."'",  
			"parent_id"						=> "NULL" 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('". $sample_control_data['sample_type_code']." - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
		
		$insert = null;
		switch($sample_type) {
			case 'tissue':
				$insert = array(
					"sample_master_id"	=> $sample_master_id,
					"tissue_nature" => "'".$specimen_data['details']['tissue_type']."'",
					"tissue_source" => "'".$specimen_data['details']['tissue_source']."'",
					"tissue_laterality" => "'".$specimen_data['details']['tissue_laterality']."'"
				);
				break;	
			
			default :
				if(!empty($specimen_data['details'])) die("ERR: 9s3cacacq.".$sample_type);
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);	
		}
		
		$query = "INSERT INTO ".$sample_control_data['detail_tablename']." (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

		// Create Derivative
		createDerivative($participant_id, $collection_id, $sample_master_id, $sample_type, $sample_master_id, $sample_type, $specimen_data['derivatives']);
		
		// Create Aliquot
		createAliquot($participant_id, $collection_id, $sample_master_id, $sample_type, $specimen_data['aliquots']);			
	}
}

function createDerivative($participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $parent_sample_master_id,  $parent_sample_type,  $derivative_data) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
	if(empty($derivative_data)) return;
	
	foreach($derivative_data as $tmp => $new_derivative_data) {
		$sample_master_id = null;
		
		$sample_type = $new_derivative_data['type'];
		if(!array_key_exists($sample_type, Config::$sample_aliquot_controls)) die("ERR: 989sasa83q.".$sample_type);
		$sample_control_data = Config::$sample_aliquot_controls[$sample_type];
		
		// Create Derivative
		
		$insert = array(
			"sample_type"					=> "'".$sample_type."'",  
			"sample_category"				=> "'derivative'", 
			"collection_id"					=> "'".$collection_id."'", 
			"sample_control_id"				=> $sample_control_data['sample_control_id'], 
			"sample_code" 					=> "'tmp'", 
			"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
			"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
			"parent_id"						=> "'".$parent_sample_master_id."'", 
			"parent_sample_type"			=> "'".$parent_sample_type."'"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('". $sample_control_data['sample_type_code']." - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
		
		$insert = array(
				"sample_master_id"	=> $sample_master_id
			);	
		$query = "INSERT INTO ".$sample_control_data['detail_tablename']." (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

		// Create Derivative
		createDerivative($participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, $sample_type, $new_derivative_data['derivatives']);
		
		// Create Aliquot
		createAliquot($participant_id, $collection_id, $sample_master_id, $sample_type, $new_derivative_data['aliquots']);
	}
}
	
function createAliquot($participant_id, $collection_id, $sample_master_id, $sample_type, $aliquot_data) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
	if(empty($aliquot_data)) return;
	
	foreach($aliquot_data as $new_aliquot) {
		$aliquot_type = $new_aliquot['type'];
		if(empty(Config::$sample_aliquot_controls[$sample_type]['aliquots']) || !array_key_exists($aliquot_type, Config::$sample_aliquot_controls[$sample_type]['aliquots'])) die("ERR: sdacacacq.".$sample_type.'-'.$aliquot_type);
		$aliquot_control_data =  Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type];
		
		$master_insert = array(
			"aliquot_type" => "'".$aliquot_type."'",
			"aliquot_control_id" => $aliquot_control_data['aliquot_control_id'],
			"in_stock" => "'yes - available'",
			"collection_id" => $collection_id,
			"sample_master_id" => $sample_master_id,
			"aliquot_label" => "'".$new_aliquot['aliquot_label']."'",
			"aliquot_volume_unit" => "'".$aliquot_control_data['volume_unit']."'",
			"storage_master_id" => $new_aliquot['storage_master_id']
		);
		
		$master_insert = array_merge($master_insert, $created);
		$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($master_insert)).") VALUES (".implode(", ", array_values($master_insert)).")";
		mysqli_query($connection, $query) or die("createAliquot [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$aliquot_master_id = mysqli_insert_id($connection);
		$query = "UPDATE aliquot_masters SET barcode= '".$aliquot_master_id."' WHERE id=".$aliquot_master_id;
		mysqli_query($connection, $query) or die("createAliquot [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$detail_insert = array(
			'aliquot_master_id' => $aliquot_master_id
		);
		
		$query = "INSERT INTO ".$aliquot_control_data['detail_tablename']." (".implode(", ", array_keys($detail_insert)).") VALUES (".implode(", ", array_values($detail_insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	}
}
