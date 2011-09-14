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
				recordParticipantAndCollection($m);
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
	
	if(!array_key_exists(strtolower($sample_label), Config::$label_2_sample_description)) {
		echo "<br><FONT COLOR=\"red\" >FUNCTION buildParticipantCollection : The label [$sample_label] is not defined into the Match Table Worksheet (Line ".$m->line.")</FONT><br>";
	
	} else {
		// Set sample and aliquot information
		$sample_and_aliquot_data = Config::$label_2_sample_description[strtolower($sample_label)];
		
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


				
			default:
				die ("ERR: 98723492394 sample type [".$sample_type." is not supported!") ;
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
	mysqli_query($connection, $query) or die("PARTICIPANT INSERT [".$m->line."] qry failed [".$query."] ".mysqli_error($connection));
	$storage_master_id = mysqli_insert_id($connection);
	$query = "UPDATE storage_masters SET code=CONCAT('B - ', id) WHERE id=".$storage_master_id;

//TODO continue
		
		INSERT INTO `participants` (`qc_ldov_initals`,`modified`, `created`, `created_by`, `modified_by`) VALUES ('RS', NULL, '', '', NULL, NULL, NULL, '', '', '', '2011-09-14 20:24:47', '2011-09-14 20:24:47', 1, 1)
		
		UPDATE `participants` SET `participant_identifier` = 'RS (1)', `date_of_birth` = NULL, `date_of_birth_accuracy` = '', `date_of_death` = NULL, `date_of_death_accuracy` = '', `last_chart_checked_date` = NULL, `last_chart_checked_date_accuracy` = '', `modified` = '2011-09-14 20:24:48', `modified_by` = 1 WHERE `participants`.`id` = 1
		
		
	pr(Config::$current_participant);	
	exit;
		
		
		
		
	$collection_notes = $collections['NOTES'];
	unset($collections['NOTES']);
	
	// Create Blood Collection
	if(isset($collections['blood'])) {
		
		// Create collection
		$insert = array(
			"acquisition_label" => "'".$ns." Sang (00-00-0000)'",
			"bank_id" => "1", 
			"collection_notes" => "'".$collection_notes."'",
			"collection_property" => "'participant collection'"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO collections (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$blood_collection_id = mysqli_insert_id($connection);

		// Create link
		$insert = array(
			"collection_id" => $blood_collection_id,
			"participant_id" => $participant_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO clinical_collection_links (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		// Create sample
		$insert = array(
			"sample_code" 					=> "'tmp_tissue'", 
			"sample_category"				=> "'specimen'", 
			"sample_control_id"				=> Config::$sample_aliquot_controls['blood']['sample_control_id'], 
			"sample_type"					=> "'blood'", 
			"initial_specimen_sample_id"	=> "NULL", 
			"initial_specimen_sample_type"	=> "'blood'", 
			"collection_id"					=> "'".$blood_collection_id."'", 
			"parent_id"						=> "NULL" 
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$sample_master_id = mysqli_insert_id($connection);
		$query = "UPDATE sample_masters SET sample_code=CONCAT('B - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$query = "INSERT INTO sd_spe_bloods (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

		$insert = array(
			"sample_master_id"	=> $sample_master_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
		
		// Create Derivative
		createDerivative($ns, $participant_id, $blood_collection_id, $sample_master_id, 'blood', $sample_master_id, 'blood', $collections['blood']['derivatives'], 'Sang');
	
		// Create Aliquot
		createAliquot($ns, $participant_id, $blood_collection_id, $sample_master_id, 'blood', $collections['blood']['aliquots'], 'Sang');
		
		unset($collections['blood']);
	}
	
	// Create Tissue Collection
	$tissue_collection_id = null;
	if(!empty($collections)) {
		
		$collection_type = '';
		if((sizeof($collections) == 1) && (array_key_exists('ascite', $collections)))  {
			$collection_type = 'ASC';
		} else if((sizeof($collections) > 1) && (array_key_exists('ascite', $collections)))  {
			$collection_type = 'Tissu/ASC';
		} else {
			$collection_type = 'Tissu';
		}
		
		$insert = array(
			"acquisition_label" => "'".$ns." $collection_type 00-00-0000'",
			"bank_id" => "1", 
			"collection_notes" => "'".$collection_notes."'",
			"collection_property" => "'participant collection'"
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO collections (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$tissue_collection_id = mysqli_insert_id($connection);

		// link
		$insert = array(
			"collection_id" => $tissue_collection_id,
			"participant_id" => $participant_id
		);
		$insert = array_merge($insert, $created);
		$query = "INSERT INTO clinical_collection_links (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
		mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	}
	
	foreach($collections as $specimen_key => $data) {
		if(empty($tissue_collection_id)) die ('cascasc');
		
		$sample_master_id = null;
		$specimen_code = null;
		
		// Create Specimen
		switch($specimen_key) {
			case 'blood':
				die('23234234');
				break;
			
			case 'ascite':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'specimen'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['ascite']['sample_control_id'], 
					"sample_type"					=> "'ascite'", 
					"initial_specimen_sample_id"	=> "NULL", 
					"initial_specimen_sample_type"	=> "'ascite'", 
					"collection_id"					=> "'".$tissue_collection_id."'", 
					"parent_id"						=> "NULL" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('A - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO sd_spe_ascites (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				if(isset($spent_time['details']['ASC'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['details']['ASC']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['details']['ASC']['unit']."'";
				} else if(isset($spent_time['default']['value'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] ="'".$spent_time['default']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['default']['unit']."'";
				}					
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		

				$specimen_code = 'ASC';
				break;
			
			case 'peritoneal wash':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'specimen'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['peritoneal wash']['sample_control_id'], 
					"sample_type"					=> "'peritoneal wash'", 
					"initial_specimen_sample_id"	=> "NULL", 
					"initial_specimen_sample_type"	=> "'peritoneal wash'", 
					"collection_id"					=> "'".$tissue_collection_id."'", 
					"parent_id"						=> "NULL" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('PW - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO sd_spe_peritoneal_washes (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				if(isset($spent_time['details']['LP'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['details']['LP']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['details']['LP']['unit']."'";
				} else if(isset($spent_time['default']['value'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] ="'".$spent_time['default']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['default']['unit']."'";
				}					
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));		

				$specimen_code = 'PW';
				break;
							
			default:
				if($data['type'] != 'tissue') {
					echo "<pre>";
					print_r($collections);
					die ('ERR: 9973671812cacacasc');
				}
				
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'specimen'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['tissue']['sample_control_id'], 
					"sample_type"					=> "'tissue'", 
					"initial_specimen_sample_id"	=> "NULL", 
					"initial_specimen_sample_type"	=> "'tissue'", 
					"collection_id"					=> "'".$tissue_collection_id."'", 
					"parent_id"						=> "NULL" 
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('T - ', id), initial_specimen_sample_id=id WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"sample_master_id"	=> $sample_master_id,
					"chuq_tissue_code" => "'".$data['details']['code']."'",
					"tissue_nature" => "'".$data['details']['type']."'",
					"tissue_source" => "'".$data['details']['source']."'",
					"tissue_laterality" => "'".$data['details']['laterality']."'"
				);
				
				$query = "INSERT INTO sd_spe_tissues (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				if(isset($spent_time['details'][$data['details']['code']])) {
					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['details'][$data['details']['code']]['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['details'][$data['details']['code']]['unit']."'";
				} else if(isset($spent_time['default']['value'])) {
					$insert['chuq_evaluated_spent_time_from_coll'] = "'".$spent_time['default']['value']."'";
					$insert['chuq_evaluated_spent_time_from_coll_unit'] = "'".$spent_time['default']['unit']."'";
				}					
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO specimen_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				$specimen_code = $data['details']['code'];
				break;				
		}
		
		// Create Derivative
		createDerivative($ns, $participant_id, $tissue_collection_id, $sample_master_id, $data['type'], $sample_master_id, $specimen_key, $data['derivatives'], $specimen_code);
		
		// Create Aliquot
		createAliquot($ns, $participant_id, $tissue_collection_id, $sample_master_id, $data['type'], $data['aliquots'], $specimen_code);
				
	}
}
function createDerivative($ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $parent_sample_master_id,  $parent_sample_type,  $derivative_data, $specimen_code = null) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
	if(empty($derivative_data)) return;
	
	foreach($derivative_data as $der_type => $new_derivative) {
		
		switch($der_type) {
			case 'plasma':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=>  Config::$sample_aliquot_controls['plasma']['sample_control_id'], 
					"sample_type"					=> "'plasma'", 
					"initial_specimen_sample_id"	=> $initial_specimen_sample_id, 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> $collection_id, 
					"parent_id"						=> $parent_sample_master_id,
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);	
		
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('PLS - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO sd_der_plasmas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				

				// Manage Derivative
				if(!empty($derivative_data['derivatives'])) die('ascasc');
				break;

				
			case 'serum':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['serum']['sample_control_id'], 
					"sample_type"					=> "'serum'", 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('SER - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_serums (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				// Manage Derivative
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				
				break;	
	
			case 'blood cell':
			case 'blood cell (arlt)':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['blood cell']['sample_control_id'], 
					"sample_type"					=> "'blood cell'", 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
							
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('BLD-C - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				if($der_type == 'blood cell (arlt)') $insert['chuq_is_erythrocyte'] = "'y'";
				$query = "INSERT INTO 	sd_der_blood_cells (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				break;	
				
				
			case 'dna':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['dna']['sample_control_id'], 
					"sample_type"					=> "'dna'", 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('DNA - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_dnas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				// Manage Derivative
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				
				break;						
					

			case 'rna':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['rna']['sample_control_id'], 
					"sample_type"					=> "'rna'", 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('RNA - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_rnas (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				// Manage Derivative
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				
				break;						
	
	
			case 'ascite supernatant':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['ascite supernatant']['sample_control_id'], 
					"sample_type"					=> "'ascite supernatant'", 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
				
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('ASC-S - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_ascite_sups (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				// Manage Derivative
				if(!empty($new_derivative['derivatives'])) die('ascasc');
				
				break;
				
				
			case 'ascite cell':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['ascite cell']['sample_control_id'], 
					"sample_type"					=> "'ascite cell'", 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
							
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('ASC-C - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO 	sd_der_ascite_cells (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				break;		
						

			case 'cell culture':
				$insert = array(
					"sample_code" 					=> "'tmp_tissue'", 
					"sample_category"				=> "'derivative'", 
					"sample_control_id"				=> Config::$sample_aliquot_controls['cell culture']['sample_control_id'], 
					"sample_type"					=> "'cell culture'", 
					"initial_specimen_sample_id"	=> "'".$initial_specimen_sample_id."'", 
					"initial_specimen_sample_type"	=> "'".$initial_specimen_sample_type."'", 
					"collection_id"					=> "'".$collection_id."'", 
					"parent_id"						=> "'".$parent_sample_master_id."'",
					"parent_sample_type"			=> "'".$parent_sample_type."'"
				);				
							
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO sample_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$sample_master_id = mysqli_insert_id($connection);
				$query = "UPDATE sample_masters SET sample_code=CONCAT('C-CULT - ', id) WHERE id=".$sample_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$query = "INSERT INTO sd_der_cell_cultures (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

				$insert = array(
					"sample_master_id"	=> $sample_master_id
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO derivative_details (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));				
				
				break;		
				
			default:
				die('ERR 9998377 : '.$der_type);
		}
		
		// Create Derivative
		createDerivative($ns, $participant_id, $collection_id, $initial_specimen_sample_id, $initial_specimen_sample_type, $sample_master_id, $der_type, $new_derivative['derivatives'], $specimen_code);
		
		// Create Aliquot
		createAliquot($ns, $participant_id, $collection_id, $sample_master_id, $der_type, $new_derivative['aliquots'], $specimen_code);
	}
}
	
function createAliquot($ns, $participant_id, $collection_id, $sample_master_id, $sample_type, $aliquot_data, $specimen_code) {
	global $connection;
	$created = array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
		);
	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	if(empty($aliquot_data)) return;
	
	foreach($aliquot_data as $new_aliquot) {
		
		// MANAGE STORAGE
		
		//get storage prefix
		$box_number = null;
		if(!empty($new_aliquot['storage'])) {
			switch($sample_type.'-'.$new_aliquot['type']) {
				case 'blood-tube':
				case 'blood-RNALater tube':	
				case 'plasma-tube':
				case 'serum-tube':
				case 'blood cell-tube':
				case 'blood cell (arlt)-tube':
					$box_number = 'Sang '.$new_aliquot['storage'];
					break;
				case 'dna-tube':
					$box_number = 'DNA '.$new_aliquot['storage'];
					break;
				case 'rna-tube':
					$box_number = 'RNA '.$new_aliquot['storage'];
					break;
				case 'cell culture-tube':
					$box_number = 'VC '.$new_aliquot['storage'];
					break;
				case 'tissue-oct block':
					$box_number = 'OCT '.$new_aliquot['storage'];
					break;
				case 'tissue-frozen tube':
					$box_number = 'Tissu '.$new_aliquot['storage'];
					break;
				case 'tissue-paraffin block':
					$box_number = 'FFPE '.$new_aliquot['storage'];
					break;
				case 'ascite-tube':
				case 'ascite supernatant-tube':
				case 'ascite cell-tube':
					$box_number = 'ASC '.$new_aliquot['storage'];
					break;
				case 'peritoneal wash-tube':
					$box_number = 'PW '.$new_aliquot['storage'];
					break;
				default:
					die ('ERR_9849983 '.$sample_type.'-'.$new_aliquot['type']);
			}
		}
				
		//get storage master id
		$storage_master_id = null;
		if(!empty($box_number)) {
			if(isset(Config::$storages['storages'][$box_number])) {
				$storage_master_id = Config::$storages['storages'][$box_number]['id'];
			} else {
			
				$insert = array(
					"code" => "'-1'",
					"storage_type"			=> "'box'",
					"storage_control_id"	=> "8",
					"short_label"			=> "'".$box_number."'",
					"selection_label"		=> "'".$box_number."'",
					"lft"		=> "'".(Config::$storages['next_left'])."'",
					"rght"		=> "'".(Config::$storages['next_left'] + 1)."'",
					"set_temperature"	=> "'FALSE'"
				);
				$insert = array_merge($insert, $created);
				$query = "INSERT INTO storage_masters (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				$storage_master_id = mysqli_insert_id($connection);
				$query = "UPDATE storage_masters SET code=CONCAT('B - ', id) WHERE id=".$storage_master_id;
				mysqli_query($connection, $query) or die("collection insert [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
				
				$insert = array(
					"storage_master_id"	=> $storage_master_id,
				);
				$query = "INSERT INTO std_boxs (".implode(", ", array_keys($insert)).") VALUES (".implode(", ", array_values($insert)).")";
				mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
						
				Config::$storages['next_left'] = Config::$storages['next_left'] + 2;
				Config::$storages['storages'][$box_number] = array('id' => $storage_master_id);
			} 
		}		
		
		// CREATE ALIQUOT
		
		$master_insert = array(
			"aliquot_type" => null,
			"aliquot_control_id" => null,
			"in_stock" => "'yes - available'",
			"collection_id" => $collection_id,
			"sample_master_id" => $sample_master_id,
			"aliquot_label" => null
		);
		if(!empty($storage_master_id)) $master_insert['storage_master_id'] = $storage_master_id;

		$detail_insert = array();
		$detail_table = 'ad_tubes';
		
		$real_aliquot_type = str_replace(array('oct ','RNALater ','paraffin ', 'frozen '), array('','','', ''), $new_aliquot['type']);
		$real_sample_type = str_replace(array(' (arlt)'), array(''), $sample_type);
		if(!isset(Config::$sample_aliquot_controls[$real_sample_type]) 
		&& !isset(Config::$sample_aliquot_controls[$real_sample_type]['aliquots'][$real_aliquot_type])) {
			die('ERR 993883 : '.$sample_type.'-'.$new_aliquot['type']);
		}
		$aliquot_control_id = Config::$sample_aliquot_controls[$real_sample_type]['aliquots'][$real_aliquot_type]['aliquot_control_id'];

		$prefix = '';
		switch($sample_type.'-'.$new_aliquot['type']) {
			case 'blood-tube':
				$prefix = "'Sang $ns 00-00-0000'";
			case 'blood-RNALater tube':	
				if(empty($prefix)) {
					$prefix = "'RL $ns 00-00-0000'";
					$detail_insert['chuq_blood_solution'] = "'RNA later'";
				}
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = $prefix;				
				break;
				
			case 'plasma-tube':
				$prefix = 'P';
			case 'ascite supernatant-tube':
				if(empty($prefix)) $prefix = 'SASC';
			case 'serum-tube':
				if(empty($prefix)) $prefix = 'SE';
			case 'ascite cell-tube':
				if(empty($prefix)) $prefix = 'NC';
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$prefix $ns 00-00-0000'";							
				break;				
				
			case 'tissue-frozen tube':
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";						
				break;	

			case 'tissue-paraffin block':
				$prefix = 'FFPE';
			case 'tissue-oct block':
				if(empty($prefix)) $prefix = 'OCT';
				$master_insert['aliquot_type'] = "'block'";
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$prefix $specimen_code $ns 00-00-0000'";	
				$detail_insert['block_type'] = ($prefix == 'OCT')? "'OCT'" : "'paraffin'";		
				$detail_table = 'ad_blocks';			
				break;	

			case 'dna-tube':
			case 'rna-tube':
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";					
				break;	

			case 'blood cell-tube':
				$prefix = 'BC';
			case 'blood cell (arlt)-tube':
				if(empty($prefix)) $prefix = 'ARLT';
			case 'cell culture-tube':
				if(empty($prefix)) $prefix = 'VC '.$specimen_code;
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$prefix $ns 00-00-0000'";				
				break;	
				
			case 'ascite-tube':
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";						
				break;

			case 'peritoneal wash-tube':
				$master_insert['aliquot_type'] = "'tube'";
				$master_insert['aliquot_control_id'] = $aliquot_control_id;
				$master_insert['aliquot_label'] = "'$specimen_code $ns 00-00-0000'";						
				break;
					
			default:
				die('ERR 99628');
		}
		
		$master_insert = array_merge($master_insert, $created);
		$query = "INSERT INTO aliquot_masters (".implode(", ", array_keys($master_insert)).") VALUES (".implode(", ", array_values($master_insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		$aliquot_master_id = mysqli_insert_id($connection);
		$query = "UPDATE aliquot_masters SET barcode= CONCAT('tmp_','".$sample_master_id."','_','".$aliquot_master_id."') WHERE id=".$aliquot_master_id;
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
		
		$detail_insert['aliquot_master_id'] = $aliquot_master_id;
		$query = "INSERT INTO $detail_table (".implode(", ", array_keys($detail_insert)).") VALUES (".implode(", ", array_values($detail_insert)).")";
		mysqli_query($connection, $query) or die("postCollectionWrite [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

	}
}
