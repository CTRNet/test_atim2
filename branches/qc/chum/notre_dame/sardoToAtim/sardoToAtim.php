<?php
error_reporting(E_ALL | E_STRICT);
date_default_timezone_set('America/New_York');
require_once 'Excel/reader.php';
$xls_reader = new Spreadsheet_Excel_Reader();

function bindRow($stmt){
	$meta = $stmt->result_metadata();
	while ($field = $meta->fetch_field()){
		$params[] = &$row[$field->name];
	}
	call_user_func_array(array($stmt, 'bind_result'), $params);
	return $row;
}

class SardoToAtim{
	static $columns = array();
	static $date_columns = array();
	static $bank_identifier_ctrl_ids = array(1,2,5);
	static $bank_identifier_ctrl_ids_column_name = null;
	static $hospital_identifier_ctrl_ids = array(8, 9, 10);
	static $hospital_identifier_ctrl_ids_column_name = null;
	static $first_name = null;
	static $last_name = null;
	static $birth_date = null;
	static $ramq = null;
	static $ramq_ctrl_id = 7;
	static $last_contact_date = null;
	static $date_of_death = null;
	static $cause_of_death = null;
	
	static $connection = null;
	
	static $db_user_id = 12;//SardoMigration
	
	static $accents_equivalent = array(
		'é'	=> 'e',
		'É'	=> 'E',
		'è' => 'e',
		'È'	=> 'E',
		'ê'	=> 'e',
		'Ê'	=> 'E',
		'ë'	=> 'e',
		'ç'	=> 'c',
		'à'	=> 'a',
		'ô' => 'o'
	);
	
	static private $table_fields_cache = array();//table fields cache
	static private $table_fields_revs_cache = array();//the compatible fields between x and x_revs
	static $commit = true;
	
	
	static function getNewConnection(){
		$connection = @mysqli_connect(
			'127.0.0.1',
			'root',
			'root',
			'atim_qc_nd',
			'8889'
		) or die("Could not connect to MySQL");
		
		if(!mysqli_set_charset($connection, 'utf8')){
			die("Invalid charset");
		}
		
		return $connection;
	}
	
	/**
	 * Validates that each columns exists and is where it's supposed to be.
	 * Prints ERROR messages and dies if one or more errors exist.
	 * @param array $header_cells
	 */
	static function validateColumns(array $header_cells){
		$errors = false;
		foreach($header_cells as $column_number => $column_name){
			if(!array_key_exists($column_name, self::$columns)){
				$errors = true;
				echo 'ERROR: Missing column ['.$column_name."]\n";
				print_r($header_cells);
				die('d');
				continue;
			}
			if(self::$columns[$column_name] != $column_number){
				$errors = true;
				printf("ERROR: Column [%s] is supposed to be at position [%d] but was found at position [%d]\n", $column_name, self::$columns[$column_name], $column_number); 
			}
		}
		
		if($errors){
			die("Columns validation failed\n");
		}
	}
	
	/**
	 * Based on the columns array, will auto assign values to the static columns
	 */
	static private function autoAssignColumns(){
		$errors = false;
		if(array_key_exists('Prénom', self::$columns)){
			self::$first_name = 'Prénom';
		}else{
			$errors = true;
			echo "ERROR: First name not found\n";
		}
		if(array_key_exists('Nom', self::$columns)){
			self::$last_name = 'Nom';
		}else{
			$errors = true;
			echo "ERROR: Last name not found\n";
		}
		if(array_key_exists('Date de naissance', self::$columns)){
			self::$birth_date = 'Date de naissance';
		}
		if(array_key_exists('RAMQ', self::$columns)){
			self::$ramq = 'RAMQ';
		}
		if(array_key_exists('Date dernier contact', self::$columns)){
			self::$last_contact_date = 'Date dernier contact';
		}else{
			$errors = true;
			echo "ERROR: Last contact date not found\n";
		}
		if(array_key_exists('Date du décès', self::$columns)){
			self::$date_of_death = 'Date du décès';
		}else{
			$errors = true;
			echo "ERROR: Date of death not found\n";
		}
		if(array_key_exists('Cause de décès', self::$columns)){
			self::$cause_of_death = 'Cause de décès';
		}
		if($errors){
			die("Stoping process. See previous errors\n");
		}
	}
	
	static private function getHospitalIdentifierInfo($identifier_value){
		$ctrl_id = null;
		$ctrl_name = null;
		switch(substr($identifier_value, 0, 1)){
			case 'N':
				$ctrl_id = 9;
				$ctrl_name = 'Notre-Dame';
				break;
			case 'S':
				$ctrl_id = 10;
				$ctrl_name = 'Saint-Luc';
				break;
			case 'H':
				$ctrl_id = 8;
				$ctrl_name = 'Hotel-Dieu';
				break;
			default:
		}
		
		return array('ctrl_id' => $ctrl_id, 'ctrl_name' => $ctrl_name);
	}

	private static function validateParticipantData($xls_row, $sql_row, $line){
		$errors = false;
		$to_update = array();
		
		//first name
		if(self::$first_name != null && $xls_row[self::$columns[self::$first_name]] && $xls_row[self::$columns[self::$first_name]] != $sql_row['first_name']){
			if(empty($sql_row['first_name'])){
				printf("UPDATE: Participant at line [%d]. First name from [%s] to [%s]\n", $line, $sql_row['first_name'], $xls_row[self::$columns[self::$first_name]]);
				$to_update['first_name'] = $xls_row[self::$columns[self::$first_name]];
			}else{
				$xls_row[self::$columns[self::$first_name]] = strtr($xls_row[self::$columns[self::$first_name]], self::$accents_equivalent);
				$sql_row['first_name'] = strtr($sql_row['first_name'], self::$accents_equivalent);
				if($xls_row[self::$columns[self::$first_name]] != $sql_row['first_name']
					&& $xls_row[self::$columns[self::$first_name]] != utf8_encode(strtr(utf8_decode($sql_row['first_name']), "'-", "  "))
				){
					if(strtoupper($xls_row[self::$columns[self::$first_name]]) == $sql_row['first_name']){
						printf("UPDATE: Participant at line [%d]. First name from [%s] to [%s]\n", $line, $sql_row['first_name'], $xls_row[self::$columns[self::$first_name]]);
						$to_update['first_name'] = $xls_row[self::$columns[self::$first_name]];						
					}else{
						printf("WARNING: First name difference for participant at line [%d]. File [%s]. ATiM [%s].\n", $line, $xls_row[self::$columns[self::$first_name]], $sql_row['first_name']);
					}
				}
			}
		}
		
		//last name
		if(self::$last_name != null && $xls_row[self::$columns[self::$last_name]] && $xls_row[self::$columns[self::$last_name]] != $sql_row['last_name']){
			if(empty($sql_row['last_name'])){
				printf("UPDATE: Participant at line [%d]. Last name from [%s] to [%s]\n", $line, $sql_row['last_name'], $xls_row[self::$columns[self::$last_name]]);
				$to_update['last_name'] = $xls_row[self::$columns[self::$last_name]];
			}else{
				$xls_row[self::$columns[self::$last_name]] = strtr($xls_row[self::$columns[self::$last_name]], self::$accents_equivalent);
				$sql_row['last_name'] = strtr($sql_row['last_name'], self::$accents_equivalent);
				if($xls_row[self::$columns[self::$last_name]] != $sql_row['last_name']
					&& $xls_row[self::$columns[self::$last_name]] != utf8_encode(strtr(utf8_decode($sql_row['last_name']), "'-", "  "))
				){
					if(strtoupper($xls_row[self::$columns[self::$last_name]]) == $sql_row['last_name']){
						printf("UPDATE: Participant at line [%d]. Last name from [%s] to [%s]\n", $line, $sql_row['last_name'], $xls_row[self::$columns[self::$last_name]]);
						$to_update['last_name'] = $xls_row[self::$columns[self::$last_name]];
					}else{
						printf("WARNING: Last name difference for participant at line [%d]. File [%s]. ATiM [%s].\n", $line, $xls_row[self::$columns[self::$last_name]], $sql_row['last_name']);
					}
				}
			}
		}
		
		//birth date
		if(self::$birth_date != null && $xls_row[self::$columns[self::$birth_date]] && $xls_row[self::$columns[self::$birth_date]] != $sql_row['date_of_birth']){
			if(empty($sql_row['date_of_birth'])){
				printf("UPDATE: Participant at line [%d]. Birth date from [%s] to [%s]\n", $line, $sql_row['date_of_birth'], $xls_row[self::$columns[self::$birth_date]]);
				$to_update['date_of_birth'] = $xls_row[self::$columns[self::$birth_date]];
				$to_update['date_of_birth_accuracy'] = 'c';
			}else{
				printf("WARNING: Date of birth difference for participant at line [%d]. File [%s]. ATiM [%s].\n", $line, $xls_row[self::$columns[self::$birth_date]], $sql_row['date_of_birth']);
			}
		}
		
		//last contact date
		if(self::$last_contact_date != null && $xls_row[self::$columns[self::$last_contact_date]] && $xls_row[self::$columns[self::$last_contact_date]] != $sql_row['qc_nd_last_contact']){
			$update = false;
			if(empty($sql_row['qc_nd_last_contact'])){
				$update = true;
			}else if(!empty($xls_row[self::$columns[self::$last_contact_date]])){
				//see if the XLS date > DB date
				$sql_date = DateTime::createFromFormat('Y-m-d', $sql_row['qc_nd_last_contact']);
				$xls_date = DateTime::createFromFormat('Y-m-d', $xls_row[self::$columns[self::$last_contact_date]]);
				if($xls_date === false){
					$errors = true;
					printf("ERROR: Invalid last contact date [%s] for participant at line [%d]\n", $xls_row[self::$columns[self::$last_contact_date]], $line);
				}else if($xls_date->getTimeStamp() > $sql_date->getTimeStamp()){
					$update = true;
				} 
			}
			if($update){
				printf("UPDATE: Participant at line [%d]. Last contact from [%s] to [%s]\n", $line, $sql_row['qc_nd_last_contact'], $xls_row[self::$columns[self::$last_contact_date]]);
				$to_update['qc_nd_last_contact'] = $xls_row[self::$columns[self::$last_contact_date]];
			}
		}
		
		//death related data
		if(!empty($xls_row[self::$columns[self::$date_of_death]]) || (self::$cause_of_death != null && !empty($xls_row[self::$columns[self::$cause_of_death]]))){
			if($sql_row['vital_status'] != 'deceased'){
				printf("UPDATE: Participant at line [%d]. Vital status from [%s] to [%s]\n", $line, $sql_row['vital_status'], 'deceased');
				$to_update['vital_status'] = 'deceased';
				if($xls_row[self::$columns[self::$date_of_death]] != $sql_row['date_of_death']){
					if(empty($sql_row['date_of_death'])){
						printf("UPDATE: Participant at line [%d]. Date of death from [%s] to [%s]\n", $line, $sql_row['date_of_death'], $xls_row[self::$columns[self::$date_of_death]]);
						$to_update['date_of_death'] = $xls_row[self::$columns[self::$date_of_death]];
					}else{
						printf("WARNING: Date of death difference for participant at line [%d]. File [%s]. ATiM [%s].\n", $line, $xls_row[self::$columns[self::$date_of_death]], $sql_row['date_of_death']);
					}
				}
				if(self::$cause_of_death != null){
					//TODO: Cause of death with codes
				}
			}
		}else if($sql_row['vital_status'] != 'alive'){
			printf("%s: Participant at line [%d]. Vital status from [%s] to [%s]\n", empty($sql_row['vital_status']) ? "UPDATE" : "WARNING", $line, $sql_row['vital_status'], 'alive');
			$to_update['vital_status'] = 'alive';
		}
		
		return array('participant_id' => $sql_row['participant_id'], 'data' => $to_update, 'errors' => $errors);
	}
	
	/**
	 * Validates that each participant is found with the proper ids, first name
	 * and last name.
	 * @param array $cells
	 */
	static function validateParticipantEntry(array &$cells){
		$errors = false;
		reset($cells);
		
		$to_update = array();
		
		$query = "INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, created, created_by, modified, modified_by, deleted) VALUES (?, ?, ?, NOW(), 1, NOW(), 1, 0)";
		$stmt = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		//bank number
		$query = "SELECT * FROM misc_identifiers AS mi 
			INNER JOIN participants AS p ON mi.participant_id=p.id
			WHERE mi.misc_identifier_control_id IN(".implode(', ', self::$bank_identifier_ctrl_ids).") AND mi.identifier_value=? 
			GROUP BY participant_id";
		$stmt1 = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		//hospital number
		$query = "SELECT * FROM misc_identifiers AS mi
			INNER JOIN participants AS p ON mi.participant_id=p.id
			WHERE identifier_value=? AND misc_identifier_control_id=?
			GROUP BY participant_id";		
		$stmt2 = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		$query = "SELECT identifier_value FROM misc_identifiers WHERE participant_id=? AND misc_identifier_control_id=".self::$ramq_ctrl_id;
		$stmt4 = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		while($row = next($cells)){//the first call skips the first line
			$error_here = false;
			$valid_hospital = false;
			$valid_dob = false;
			$valid_bank = false;
			$sql_row1 = null;
			$sql_row2 = null;
			$hospital_mi = self::getHospitalIdentifierInfo($row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]]);
			if($hospital_mi['ctrl_id'] == null){
				$errors = true;
				printf("ERROR: The hospital number [%s] at line [%d] cannot be associated to an hospital.\n", $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], key($cells));
				continue;
			}
			
			//bank id check
			if($row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]]){
				$stmt1->bind_param("s", $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]]);
				$stmt1->execute() or die('Execute failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$stmt1->error."\n");
				$stmt1->store_result();
				$sql_row1 = bindRow($stmt1);
				if(!$stmt1->fetch()){
					$error_here = true;
					printf("ERROR: No participant matches bank id [%s] at line [%d]\n", $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]], key($cells));
					$stmt1->free_result();
					
				}else if($stmt1->num_rows > 1){
					$error_here = true;
					printf("ERROR: The bank id [%s] at line [%d] belongs to more than one participant.\n", $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]], $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], key($cells));
				}else{
					$valid_bank = true;
				}
				
				$stmt1->free_result();
				if($error_here){
					$errors = true;
					continue;
				}
			}
			
			if($row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]]){
				//hospital id check
				$stmt2->bind_param("si", $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], $hospital_mi['ctrl_id']);
				$stmt2->execute() or die('Execute failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$stmt2->error."\n");
				$stmt2->store_result();
				$sql_row2 = bindRow($stmt2);
				$stmt2->fetch();
				if($stmt2->num_rows ==  1){
					$valid_hospital = true;
				}else if($stmt2->num_rows > 1){
					$error_here = true;
					printf("ERROR: The hospital number [%s] at line [%d] belongs to more than one participant.\n", $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], key($cells));
				}
				$stmt2->free_result();
				if($error_here){
					$errors = true;
					continue;
				}
			}
			
			if($valid_bank && $valid_hospital){
				if($sql_row1['participant_id'] != $sql_row2['participant_id']){
					printf("ERROR: The hospital number [%s] and the bank number [%s] do not belong to the same participant on line [%d].\n", $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]], key($cells));
					$errors = true;
					continue;
				}
				$cells[key($cells)]['participant_id'] = $sql_row1['participant_id'];
				$cells[key($cells)]['date_of_birth'] = $sql_row1['date_of_birth'];
				
			}else if($valid_bank){
				//match the date of birth
				if($sql_row1['date_of_birth'] && $sql_row1['date_of_birth'] != $row[self::$columns[self::$birth_date]]){
					printf("ERROR: The date of birth [%s] does not match participant with bank number [%s] at line [%d].\n", $sql_row1['date_of_birth'], $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]], key($cells));
					$errors = true;
					continue;
				}
				
				$cells[key($cells)]['participant_id'] = $sql_row1['participant_id'];
					$cells[key($cells)]['date_of_birth'] = $sql_row1['date_of_birth'];
				
				//create the hospital number
				$query = "INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, created, created_by, modified, modified_by, deleted) VALUES (?, ?, ?, NOW(), 1, NOW(), 1, 0)";
				$stmt->bind_param('sii', $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], $hospital_mi['ctrl_id'], $sql_row1['participant_id']);
				$stmt->execute();
			}else if($valid_hospital){
				//match the date of birth
				if($sql_row2['date_of_birth'] && $sql_row2['date_of_birth'] != $row[self::$columns[self::$birth_date]]){
					printf("ERROR: The date of birth [%s] does no match participant with bank hospital [%s] at line [%d].\n", $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], key($cells));
					$errors = true;
					continue;
				}
				
				$cells[key($cells)]['participant_id'] = $sql_row2['participant_id'];
				$cells[key($cells)]['date_of_birth'] = $sql_row2['date_of_birth'];
				
			}else{
				printf("ERROR: Neither the hospital number nor the bank number can be found for participant at line [%d].\n", $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]], key($cells));
				$errors = true;
				continue;
			}
			
			
			$to_update = self::validateParticipantData($row, $sql_row1 == null ? $sql_row2 : $sql_row1, key($cells));
			$errors = $errors ?: $to_update['errors'];
			
			if(self::$ramq != null){
				$stmt4->bind_param("i", $sql_row2['participant_id']);
				$stmt4->execute() or die('Execute failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$stmt4->error."\n");
				$stmt4->store_result();
				$sql_row4 = bindRow($stmt4);
				if($stmt4->fetch() && $sql_row4['identifier_value'] != $row[self::$columns[self::$ramq]]){
					printf("WARNING: RAMQ for participant at line [%d] differs from the database.\n", key($cells)); 
				}
			}
			
			$stmt4->free_result();
			
			if(!empty($to_update['data'])){
				$fields_values = $to_update['data'];
				$fields = array_keys($fields_values);
				$query = "UPDATE participants SET ".implode('=?, ', $fields)."=?, modified_by=".self::$db_user_id.", modified=NOW() WHERE id=".$to_update['participant_id'];
				$stmt5 = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
				$params = array(str_repeat('s', count($fields)));
				foreach($fields_values as &$value){
					$params[] = &$value;
				}
				call_user_func_array(array($stmt5, 'bind_param'), $params);
				$stmt5->execute();
				$stmt5->close();
				
				self::insertRev('participants', $to_update['participant_id']);
			}
		}
		
		$stmt4->close();
		$stmt2->close();
		$stmt1->close();
		$stmt->close();

		if($errors){
			die("Participant validation failed\n");
		}
	}
	
	static function updateFieldsCache($tablename){
		$query = "DESC ".$tablename;
		$result = self::$connection->query($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		$fields = array();
		while($row = $result->fetch_assoc()){
			$fields[$row['Field']] = $row;
		}
		$result->free();
		self::$table_fields_cache[$tablename] = $fields;
	}
	
	static function insertRev($src_tablename, $id, $key = 'id'){
		if(!array_key_exists($src_tablename, self::$table_fields_revs_cache)){
			if(!array_key_exists($src_tablename, self::$table_fields_cache)){
				self::updateFieldsCache($src_tablename);
			}
			
			$query = "DESC ".$src_tablename."_revs";
			$result = self::$connection->query($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
			$fields = array();
			while($row = $result->fetch_assoc()){
				$fields[] = $row['Field'];
			}
			$result->free();
			self::$table_fields_revs_cache[$src_tablename] = array_intersect(array_keys(self::$table_fields_cache[$src_tablename]), $fields);
		}
		$imploded_str = '`'.implode('`, `', self::$table_fields_revs_cache[$src_tablename]).'`';
		$query = "INSERT INTO ".$src_tablename."_revs (".$imploded_str.") (SELECT ".$imploded_str." FROM ".$src_tablename." WHERE ".$key."=".$id.")";
		self::$connection->query($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
	}
	
	static function formatWithAccuracy($date_str){
		$accuracy = null;
		if($date_str == 'AAAA-MM-JJ' || empty($date_str)){
			$date_str = null;
			$accuracy = '';
		}else if(strpos($date_str, '-MM-JJ') !== false){
			$date_str = substr($date_str, 0, 5)."01-01";
			$accuracy = 'm';
		}else if(strpos($date_str, '-JJ') !== false){
			$date_str = substr($date_str, 0, 8)."01";
			$accuracy = 'd';
		}else{
			$accuracy = 'c';
		}
		return array('val' => $date_str, 'accuracy' => $accuracy);
	}
	
	static function basicChecks(array &$cells){
		//put all indexes in all rows
		//formats dates
		//convert all entries to UTF-8
		$length = count(self::$columns);
		$range_array = array();
		
		for($i = 1; $i <= $length; ++ $i){
			$range_array[$i] = null;
		}
		foreach($cells as &$row){
			foreach($row as &$cell){
				$cell = utf8_encode($cell);
			}
			$row = array_replace($range_array, $row);
		}
		self::validateColumns($cells[1]);
		self::autoAssignColumns();
		reset($cells);
		while(next($cells)){
			$row = &$cells[key($cells)];
			foreach(self::$date_columns as $date_column){
				$accuracy_result = self::formatWithAccuracy($row[self::$columns[$date_column]]);
				$row[self::$columns[$date_column]] = $accuracy_result['val'];
				$row[$date_column.'_accuracy'] = $accuracy_result['accuracy'];
			}
		}
		
		self::validateParticipantEntry($cells);
	}
	
	/**
	 * Updates values to match a table schema. NULL text becomes an empty string. Empty date strings become NULL.
	 * @param string $table_name
	 * @param array $fields
	 */
	static function updateValuesToMatchTableDesc($table_name, array &$fields){
		if(!array_key_exists($table_name, self::$table_fields_cache)){
			self::updateFieldsCache($table_name);
		}
		$current_table = self::$table_fields_cache[$table_name];
		foreach($fields as $field_name => &$value){
			if($value == null && (strpos($current_table[$field_name]['Type'], 'char') !== false || strpos($current_table[$field_name]['Type'], 'text') != false)){
				$value = '';
			}else if($value == '' && strpos($current_table[$field_name]['Type'], 'date') !== false){
				$value = null;
			}
		}
	}
	
	/**
	 * Enter description here ...
	 * @param string $table_name
	 * @param string $detail_table_name
	 * @param string $primary_key_name
	 * @param array $data array('master' => array('field' => 'value'), 'detail' => array('field' => 'value'))
	 * @param string $required A key that must be equal in the process and in the database. Acts as a security safeguard. Must be in master.
	 */
	static function update($table_name, $detail_table_name, array $primary_keys, array $data, $required = null){
		$query = null;
		$fields = array();
		assert($primary_keys) or die("update primary_keys missing in ".__FUNCTION__." at line ".__LINE__."\n");
		
		self::updateValuesToMatchTableDesc($table_name, $data['master']);
		if($detail_table_name){
			self::updateValuesToMatchTableDesc($detail_table_name, $data['detail']);
		}
		foreach($data['master'] as $key => $val){
			$fields[] = $table_name.".".$key." AS `".$table_name.".".$key."`"; 
		}
		foreach($data['detail'] as $key => $val){
			$fields[] = $detail_table_name.".".$key." AS `".$table_name.".".$key."`";
		}
		
		if($detail_table_name == null){
			$query = sprintf('SELECT %s.id, '.implode(', ', $fields).' FROM %s WHERE '.implode('=? AND ', $primary_keys).'=?', $table_name, $table_name);
		}else{
			$query = sprintf('SELECT %s.id, '.implode(', ', $fields).' FROM %s INNER JOIN %s ON %s.id=%s.%s WHERE '.implode('=? AND ', $primary_keys).'=?', $table_name, $table_name, $detail_table_name, $table_name, $detail_table_name, substr($table_name, 0, -1)."_id");
		}
		
		$stmt = SardoToAtim::$connection->prepare($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		$bind_params = array();
		$bind_params[] = str_repeat('s', count($primary_keys));
		foreach($primary_keys as $primary_key){
			$bind_params[] = &$data['master'][$primary_key];
		}
		call_user_func_array(array($stmt, 'bind_param'), $bind_params);
		$row = bindRow($stmt);
		$stmt->execute();
		$stmt->store_result();
		$last_id = null;
		$keys_values = array();
		foreach($primary_keys as $primary_key){
			$keys_values[] = '['.$table_name.'.'.$primary_key.' = '.$data['master'][$primary_key].']';
		}
		if($stmt->num_rows > 1){
			
			die('ERROR: There is more than one entry having primary key(s) '.explode(', ', $keys_values)."]\n");
		}else if($stmt->fetch()){
			die('update!');
			//update where empty, warn where diff
			$to_update = array();
			if($data['master']['master'][$required] != $row[$required]){
				die('ERROR: Required field ['.$table_name.'.'.$field_name."] doesn't match. Found [".$row[$required]."] Expected [".$data['master'][$required]."]\n");
			}
			
			foreach($new_data as $field_name => $value){
				if(!array_key_exists($field_name, $row)){
					die("Field [".$field_name."] doesn't exists in table [".$table_name."]\n");
				}
				if(!empty($row[$field_name]) && $value != $row[$field_name]){
					echo 'WARNING: Conflict on table [',$table_name,'] field [',$field_name,']. File [',$value,'] Db [',$row[$field_name],"\n";
				}else if(!empty($value)){
					$to_update[$field_name] = $value;
				}
			}
			$last_id = $row['id'];
			$stmt->close();
			
			if(!empty($to_update)){
				$to_update[$table_name.".modified_by"] = self::$db_user_id;
				if($detail_table_name == null){
					$query = sprintf("UPDATE %s SET ".implode('=?, ', array_keys($to_update))."=?, modified=NOW() WHERE id=?", $table_name);
				}else{
					$query = sprintf("UPDATE %s INNER JOIN %s ON %s.id=%s.%s SET ".implode('=?, ', array_keys($to_update))."=?, modified=NOW() WHERE id=?", $table_name, $detail_table_name, $table_name, $detail_tablename, substr($table_name, 0, -1)."_id");
				}
				$param = array_merge(array(str_repeat('s', count($to_update).'i')), array_merge($to_update, array($id)));
				call_user_func_array(array($stmt, 'bind_param'), $param);
				$stmt->execute();
				$stmt->close();
				echo 'UPDATED pkey base ['.$table_name.'.'.$field_name."]\n";
			}else{
				echo 'WARNING: Nothing to do for pkey base ['.$table_name.'.'.$field_name."]\n";
			}
			
		}else{
			//insert
			$stmt->close();
			$data['master']['created_by'] = self::$db_user_id;
			$data['master']['modified_by'] = self::$db_user_id;
			$query = sprintf('INSERT INTO %s ('.implode(', ', array_keys($data['master'])).', created, modified) VALUES('.str_repeat('?, ', count($data['master']) - 1).'?, NOW(), NOW())', $table_name);
			$param = array(str_repeat('s', count($data['master'])));
			foreach($data['master'] as &$data_unit){
				$param[] = &$data_unit;
			}
			$stmt = SardoToAtim::$connection->prepare($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
			call_user_func_array(array($stmt, 'bind_param'), $param);
			$stmt->execute() or die('Execute failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$stmt->error."\n");
			$last_id = $stmt->insert_id;
			$stmt->close();
			if($detail_table_name != null){
				$data['detail'][substr($table_name, 0, -1)."_id"] = $last_id;
				$query = sprintf('INSERT INTO %s ('.implode(', ', array_keys($data['detail'])).') VALUES('.str_repeat('?, ', count($data['detail']) - 1).'?)', $detail_table_name);
				$param = array(str_repeat('s', count($data['detail'])));
				foreach($data['detail'] as &$data_unit){
					$param[] = &$data_unit;
				}
				$stmt = SardoToAtim::$connection->prepare($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
				call_user_func_array(array($stmt, 'bind_param'), $param);
				$stmt->execute() or die('Execute failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$stmt->error."\n");
			}
			printf("INSERT made in table %s for keys %s\n", $table_name, implode(', ', $keys_values));			
		}
		self::insertRev($table_name, $last_id);
		if($detail_table_name != null){
			self::insertRev($detail_table_name, $last_id, substr($table_name, 0, -1)."_id");
		}
		
		return $last_id;
	}
	
	
	static function endChecks(){
		//TODO: update value domains with missing values
		if(self::$commit){
// 			self::$connection->commit();
			self::$connection->rollback();
			echo "\nProcess complete. Changes were COMMITED (but not for debug).\n";
		}else{
			self::$connection->rollback();
			echo "\nProcess complete. Changes were NOT commited.\n";
		}
	}
}

SardoToAtim::$connection = SardoToAtim::getNewConnection(); 
mysqli_autocommit(SardoToAtim::$connection, false);
