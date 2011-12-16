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
		"created"		=> Config::$migration_date, 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> Config::$migration_date,
		"modified_by"	=> Config::$db_created_id
		);
	
	$id = $m->values['id'];
	$new_box = array_key_exists('location', $m->values)? $m->values['location'] : null;
	$new_patient = array_key_exists('patient ID', $m->values)? $m->values['patient ID'] : null;
	$sample_label = array_key_exists('samples', $m->values)? utf8_encode($m->values['samples']) : null;
	
	$collection_notes = array_key_exists('collection notes', $m->values)? str_replace("'", "''", utf8_encode($m->values['collection notes'])) : null;	
	$aliquot_notes = array_key_exists('aliquot notes', $m->values)? str_replace("'", "''", utf8_encode($m->values['aliquot notes'])) : null;	
	$collection_site = array_key_exists('source', $m->values)? (($m->values['source'] == 'clinic')? 'clinic': 'surgery room') : null;	
	$u_number = array_key_exists('U Number', $m->values)? strtoupper(str_replace('-', '', $m->values['U Number'])) : null;

	if(!empty($sample_label)) {
	
		// ** 1 ** Manage Box
		
		if(!empty($new_box)) {
			
			$new_box = strtoupper($new_box);
			$new_box_formated = str_replace(array(' ', '"', 'BOX'), array('','', ''), strtoupper($new_box));
			if(strlen($new_box_formated) > 10) echo "<br>STORAGE NAME: Too Long : ...[$new_box]<br>";
			$new_box_formated = substr($new_box_formated, 0, 10);
			
			$insert = array(
				"code" => "'-1'",
				"storage_control_id"	=> "8",
				"short_label"			=> "'".$new_box_formated."'",
				"selection_label"		=> "'".$new_box_formated."'",
				"lft"		=> "'".(Config::$storages['next_left'])."'",
				"rght"		=> "'".(Config::$storages['next_left'] + 1)."'"
			);
			$insert = array_merge($insert, $created);
			$query = "INSERT INTO storage_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
			mysqli_query($connection, $query) or die("STORAGE INSERT [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
			$storage_master_id = mysqli_insert_id($connection);
			$query = "UPDATE storage_masters SET code=id WHERE id=".$storage_master_id;
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
			if($new_patient == 'TJ0502030') {
				//Specific case
				$new_collection_label = 'TJ0502??';
			} else {
				$new_patient = str_replace(' ','', strtoupper($new_patient));			
				preg_match('/^([A-Z\-]{1,6}[0-9]{2,6})$/', $new_patient, $matches);
				if(isset($matches[1])) {
					$new_collection_label = $matches[1];
				} else {
					preg_match('/^([A-Z\-]{1,6})$/', $new_patient, $matches);
					if(isset($matches[1])) {
					 $new_collection_label = $matches[1].'??????';	
					} else {
						echo "<br>GET COLLECTION LABEL: The following patient id [$new_patient] has not been considered as a new patient  (Line ".__LINE__.")<br>";		
					}
				}
			}
		}
		
		if(!empty($new_collection_label)) {
			if(!is_null(Config::$current_participant['collection_label'])) {
				// Record previous participant data
				recordParticipantAndCollection($m);		
			} 
			
			// Reset data
			
			preg_match('/^([A-Z\-]{1,6})([0-9]{2,6}|\?{6}|[0-9]{4}\?\?)$/', $new_collection_label, $matches);
			if(!isset($matches[1]) || !isset($matches[2])) die("ERR 993773");
						
			Config::$current_participant['initial'] = $matches[1];
			Config::$current_participant['u_number'] = $u_number;
			Config::$current_participant['collection_label'] = $new_collection_label;
			Config::$current_participant['collection_date'] = '';
			Config::$current_participant['collection_site'] = $collection_site;
			Config::$current_participant['collection_notes'] = $collection_notes;
			Config::$current_participant['samples'] = array();

			//Validate date
			$collection_date = '';
			if(($matches[2] != '??????') && ($matches[2] != '0502??')) {
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
				if(!empty(Config::$current_participant['collection_date'])) {
					Config::$current_participant['collection_date'] = (preg_match('/^([0-1][0-9]\-)/', Config::$current_participant['collection_date']))? ('20'. Config::$current_participant['collection_date']) : ('19'. Config::$current_participant['collection_date']);	
				}
			}
		} else if(!empty($u_number)) {
			echo "<br><FONT COLOR=\"red\" >U Number alone!(Line ".$m->line.")!</FONT><br>";
		}
		
		// ** 3 ** Manage samples
		
		buildParticipantCollection($m, $sample_label, $aliquot_notes);

	} else if($new_patient == 'END OF FILE') {
		// Record previous participant data
		recordParticipantAndCollection($m);	
		Config::$end_of_file_detected = true;	
	} else {
		die("<br><FONT COLOR=\"red\" >Sample Label Is Missing (Line ".$m->line.")!</FONT><br>");
	}
	
	return false;
}

function buildParticipantCollection(Model $m, $sample_label, $aliquot_notes){
	$formatted_sample_label = '';
	if($sample_label == 'cervical tu (-20C overnight in O.R)')  {	 
		$formatted_sample_label = 'cervical tu';
		$sample_label = 'cervical tu (-20˚c overnight in O.R)';
	} else {
		$formatted_sample_label = strtolower(preg_replace(array('/\s\s+/','/\ $/', '/^\ /', '/\ [0-9A-Ea-e]$/', '/\ [12][0-9]$/', '/[0-9]$/'), array(' ', '', '', '', '', ''), $sample_label));
	}
	
	if(!array_key_exists($formatted_sample_label, Config::$label_2_sample_description)) {
		echo "<br><FONT COLOR=\"red\" >FUNCTION buildParticipantCollection : The label [$sample_label]($formatted_sample_label) is not defined into the Match Table Worksheet (Line ".$m->line.")! Sample won't be created!</FONT><br>";
	} else {
		// Set sample and aliquot information
		$sample_and_aliquot_data = Config::$label_2_sample_description[$formatted_sample_label];
		$sample_type = $sample_and_aliquot_data['sample_type'];
		
		$hemolysis_signs = false;
		if(preg_match('/hemolysis/', $aliquot_notes)) {
			$aliquot_notes = '';
			if($sample_type != 'plasma') {
				echo "<br><FONT COLOR=\"red\" >hemolysis issue (Line ".$m->line.")!</FONT><br>";
			} else {
				$hemolysis_signs = true;
			}
		}
		
		$aliquot_data = array(
			'Master' => array(
				'type' => (array_key_exists('is_clot', $sample_and_aliquot_data) && $sample_and_aliquot_data['is_clot'])? 'clot tube' : 'tube', 
				'aliquot_label' => Config::$current_participant['collection_label'].' '.$sample_label, 
				'storage_master_id' => Config::$storages['current_id'],
				'notes' => $aliquot_notes),
			'Detail' => $hemolysis_signs? array('hemolysis_signs' => "'y'") : array());

		switch($sample_type) {
			
			// TISSUE
			
			case 'tissue':
				$tissue_key = 'tissue ['.$sample_and_aliquot_data['tissue_source'].'/'.$sample_and_aliquot_data['tissue_type'].'/'.$sample_and_aliquot_data['tissue_laterality'].']';
				if($formatted_sample_label == '2nd ovary') $tissue_key .= ' 2nd';
				
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
		"created"		=> Config::$migration_date, 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> Config::$migration_date,
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
	
	// Create U Number
	if(!empty(Config::$current_participant['u_number'])) {
		$insert = array(
			"identifier_value" => "'".Config::$current_participant['u_number']."'",
			"participant_id" => $participant_id, 
			"misc_identifier_control_id" => "2"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO misc_identifiers (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("misc identfier insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	}	
	
	// Create collection
	
	$insert = array(
		"acquisition_label" => "'".Config::$current_participant['collection_label']."'",
		"bank_id" => "1", 
		"collection_datetime" => empty(Config::$current_participant['collection_date'])? "''" : "'".Config::$current_participant['collection_date']." 00:00:00'",
		"collection_datetime_accuracy" => empty(Config::$current_participant['collection_date'])? "''" : "'h'",
		"collection_site" => "'".Config::$current_participant['collection_site']."'",
		"collection_property" => "'participant collection'",
		"collection_notes" => "'".Config::$current_participant['collection_notes']."'"
	);
	
	if(empty($insert['collection_datetime'])) {
		unset($insert['collection_datetime']);
		unset($insert['collection_datetime_accuracy']);
	}	
	
	if("'TJ0502??'" == $insert['acquisition_label']) {
		$insert['collection_datetime'] = "'2005-02-01 00:00:00'";
		$insert['collection_datetime_accuracy'] = "'d'";
	}
	
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
//			"sample_type"					=> "'".$sample_type."'",  
//			"sample_category"				=> "'specimen'", 
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
		$query = "UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE id=".$sample_master_id;
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
		"created"		=> Config::$migration_date, 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> Config::$migration_date,
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
//			"sample_type"					=> "'".$sample_type."'",  
//			"sample_category"				=> "'derivative'", 
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
		$query = "UPDATE sample_masters SET sample_code=id, initial_specimen_sample_id=id WHERE id=".$sample_master_id;
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
		"created"		=> Config::$migration_date, 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> Config::$migration_date,
		"modified_by"	=> Config::$db_created_id
		);
	
	if(empty($aliquot_data)) return;
	
	foreach($aliquot_data as $new_aliquot_master_and_details) {
		
		// MASTER
		
		$new_aliquot_master = $new_aliquot_master_and_details['Master'];
	
		$aliquot_type = $new_aliquot_master['type'];
		if(empty(Config::$sample_aliquot_controls[$sample_type]['aliquots']) || !array_key_exists($aliquot_type, Config::$sample_aliquot_controls[$sample_type]['aliquots'])) echo("ERR: 56784 - [".$sample_type.'-'.$aliquot_type.']');
		$aliquot_control_data =  Config::$sample_aliquot_controls[$sample_type]['aliquots'][$aliquot_type];
				
		$master_insert = array(
//			"aliquot_type" => "'".$aliquot_type."'",
			"aliquot_control_id" => $aliquot_control_data['aliquot_control_id'],
			"in_stock" => "'yes - available'",
			"collection_id" => $collection_id,
			"sample_master_id" => $sample_master_id,
			"aliquot_label" => "'".$new_aliquot_master['aliquot_label']."'",
//			"aliquot_volume_unit" => "'".$aliquot_control_data['volume_unit']."'",
			"storage_master_id" => $new_aliquot_master['storage_master_id'],
			"notes" => "'".$new_aliquot_master['notes']."'"
		);
		
		$master_insert = array_merge($master_insert, $created);
		$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($master_insert)).") VALUES (".implode(", ", array_values($master_insert)).")";
		mysqli_query($connection, $query) or die("createAliquot [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$aliquot_master_id = mysqli_insert_id($connection);
		$query = "UPDATE aliquot_masters SET barcode= '".$aliquot_master_id."' WHERE id=".$aliquot_master_id;
		mysqli_query($connection, $query) or die("createAliquot [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		// DETAIL
		
		$detail_insert = $new_aliquot_master_and_details['Detail'];
		$detail_insert['aliquot_master_id'] = $aliquot_master_id;
		
		$query = "INSERT INTO ".$aliquot_control_data['detail_tablename']." (".implode(", ", array_keys($detail_insert)).") VALUES (".implode(", ", array_values($detail_insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	}
}
