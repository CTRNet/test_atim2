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
	
	static private $table_fields_cache = array();
	
	
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
		if(self::$first_name != null && $xls_row[self::$columns[self::$first_name]] != $sql_row['first_name']){
			if(empty($sql_row['first_name'])){
				printf("UPDATE: Participant at line [%d]. First name from [%s] to [%s]\n", $line, $sql_row['first_name'], $xls_row[self::$columns[self::$first_name]]);
				$to_update['first_name'] = $xls_row[self::$columns[self::$first_name]];
			}else{
				$xls_row[self::$columns[self::$first_name]] = strtr($xls_row[self::$columns[self::$first_name]], self::$accents_equivalent);
				$sql_row['first_name'] = strtr($sql_row['first_name'], self::$accents_equivalent);
				if($xls_row[self::$columns[self::$first_name]] != $sql_row['first_name']){
					printf("WARNING: First name difference for participant at line [%d]. File [%s]. ATiM [%s].\n", $line, $xls_row[self::$columns[self::$first_name]], $sql_row['first_name']);
				}
			}
		}
		
		//last name
		if(self::$last_name != null && $xls_row[self::$columns[self::$last_name]] != $sql_row['last_name']){
			if(empty($sql_row['last_name'])){
				printf("UPDATE: Participant at line [%d]. Last name from [%s] to [%s]\n", $line, $sql_row['last_name'], $xls_row[self::$columns[self::$last_name]]);
				$to_update['last_name'] = $xls_row[self::$columns[self::$last_name]];
			}else{
				$xls_row[self::$columns[self::$last_name]] = strtr($xls_row[self::$columns[self::$last_name]], self::$accents_equivalent);
				$sql_row['last_name'] = strtr($sql_row['last_name'], self::$accents_equivalent);
				if($xls_row[self::$columns[self::$last_name]] != $sql_row['last_name']){
					printf("WARNING: Last name difference for participant at line [%d]. File [%s]. ATiM [%s].\n", $line, $xls_row[self::$columns[self::$last_name]], $sql_row['last_name']);
				}
			}
		}
		
		//birth date
		if(self::$birth_date != null && $xls_row[self::$columns[self::$birth_date]] != $sql_row['date_of_birth']){
			if(empty($sql_row['date_of_birth'])){
				printf("UPDATE: Participant at line [%d]. Birth date from [%s] to [%s]\n", $line, $sql_row['date_of_birth'], $xls_row[self::$columns[self::$birth_date]]);
				$to_update['date_of_birth'] = $xls_row[self::$columns[self::$birth_date]];
				$to_update['date_of_birth_accuracy'] = 'c';
			}else{
				printf("WARNING: Date of birth difference for participant at line [%d]. File [%s]. ATiM [%s].\n", $line, $xls_row[self::$columns[self::$birth_date]], $sql_row['date_of_birth']);
			}
		}
		
		//last contact date
		if(self::$last_contact_date != null && $xls_row[self::$columns[self::$last_contact_date]] != $sql_row['qc_nd_last_contact']){
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
	static function validateParticipantEntry(array $cells){
		$errors = false;
		reset($cells);
		
		$to_update = array();
		
		$query = "INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, created, created_by, modified, modified_by, deleted) VALUES (?, ?, ?, NOW(), 1, NOW(), 1, 0)";
		$stmt = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		$query = "SELECT * FROM misc_identifiers AS mi
			INNER JOIN participants AS p ON mi.participant_id=p.id
			WHERE mi.misc_identifier_control_id IN(".implode(', ', self::$bank_identifier_ctrl_ids).") AND mi.identifier_value=?";
		//$connection1 = self::getNewConnection();
		$stmt1 = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		$query = "SELECT participant_id FROM misc_identifiers WHERE (identifier_value=? OR identifier_value=?) AND misc_identifier_control_id IN(".implode(',', self::$hospital_identifier_ctrl_ids).")";
		$stmt2 = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		$query = "SELECT identifier_value FROM misc_identifiers WHERE participant_id=? AND misc_identifier_control_id IN(".implode(',', self::$hospital_identifier_ctrl_ids).")";
		$stmt3 = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		$query = "SELECT identifier_value FROM misc_identifiers WHERE participant_id=? AND misc_identifier_control_id=".self::$ramq_ctrl_id;
		$stmt4 = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		while($row = next($cells)){//the first call skips the first line
			$stmt1->free_result();
			$stmt1->bind_param("s", $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]]);
			$stmt1->execute() or die('Execute failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$stmt1->error."\n");
			$stmt1->store_result();
			$sql_row1 = bindRow($stmt1);
			if(!$stmt1->fetch()){
				$errors = true;
				printf("ERROR: No participant matches bank id [%s] at line [%d]\n", $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]], key($cells));
				continue; 
			}

			//quand différent: ne rien faire (ou warning)
			//si y'en a pas, ajouter dans ATiM
			$short_hospital_number = substr($row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], 1);
			$stmt2->bind_param("ss", $short_hospital_number, $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]]);
			$stmt2->execute() or die('Execute failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$stmt2->error."\n");
			$stmt2->store_result();
			$sql_row2 = bindRow($stmt2);
			if(!$stmt2->fetch()){
				//Unmatched hospital number
				$stmt3->bind_param("i", $sql_row1['participant_id']);
				$stmt3->execute() or die('Execute failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$stmt3->error."\n");
				$stmt3->store_result();
				$sql_row3 = bindRow($stmt3);
				$hospital_identifiers = array();
				while($stmt3->fetch()){
					$hospital_identifiers[] = $sql_row3['identifier_value'];
				}
				if(empty($hospital_identifiers)){
					//create the hospital identifier
					$hospital_id = self::getHospitalIdentifierInfo($row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]]);
					if($hospital_id['ctrl_id'] == null){
						printf("ERROR: Failed to recognize prefix for hospital number [%s] at line [%d]. Cannot create hospital number\n", $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], key($cells));
					}else{
						$stmt->bind_param('sii', $short_hospital_number, $hospital_id['ctrl_id'], $sql_row1['participant_id']);
						$stmt->execute();
						printf("Created hospital number [%s] for [%s] for participant with bank id [%d]\n", $short_hospital_number, $hospital_id['ctrl_name'], $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]]); 
					}
				}else{
					//an hospital identifier already exists
					printf("WARNING: The participant at line [%d] has a different identifier in the file [%s] than in the database [%s]\n", key($cells), $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], implode(', ', $hospital_identifiers)); 
				}
			}else{
				do{
					if($sql_row2['participant_id'] != $sql_row1['participant_id']){
						$errors = true;
						printf("ERROR: The hospital number [%s] at line [%d] belongs to a different participant than the bank id [%s]\n", $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], key($cells), $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]]);
					}
				}while($stmt2->fetch());
			}
			
			$to_update = self::validateParticipantData($row, $sql_row1, key($cells));
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
			
			if($stmt1->fetch()){
				$errors = true;
				printf("ERROR: More than one participant matches bank id [%s] at line [%d]\n", $row[self::$columns[self::$bank_identifier_ctrl_id_column_name]], key($cells));
			}
			
			$stmt1->free_result();
			$stmt2->free_result();
			$stmt3->free_result();
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
		$stmt3->close();
		$stmt2->close();
		$stmt1->close();
		$stmt->close();

		if($errors){
			die("Participant validation failed\n");
		}
	}
	
	static function insertRev($src_tablename, $id){
		if(!array_key_exists($src_tablename, self::$table_fields_cache)){
			$query = "DESC ".$src_tablename;
			$result = self::$connection->query($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
			$fields = array();
			while($row = $result->fetch_assoc()){
				$fields[] = $row['Field'];
			}
			$result->free();
			self::$table_fields_cache[$src_tablename] = $fields;
			
			$query = "DESC ".$src_tablename."_revs";
			$result = self::$connection->query($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
			$fields = array();
			while($row = $result->fetch_assoc()){
				$fields[] = $row['Field'];
			}
			$result->free();
			self::$table_fields_cache[$src_tablename] = array_intersect(self::$table_fields_cache[$src_tablename], $fields);
		}
		$imploded_str = implode(', ', self::$table_fields_cache[$src_tablename]);
		$query = "INSERT INTO ".$src_tablename."_revs (".$imploded_str.") (SELECT ".$imploded_str." FROM ".$src_tablename." WHERE id=".$id.")";
		self::$connection->query($query) or die('Query failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
	}
	
	static function basicChecks(&$cells){
		//put all indexes in all rows
		//convert all entries to UTF-8
		//Remove bogus dates "AAAA-MM-JJ"
		$length = count(self::$columns);
		$range_array = array();
		
		for($i = 1; $i <= $length; ++ $i){
			$range_array[$i] = null;
		}
		foreach($cells as &$row){
			foreach($row as &$cell){
				if($cell == "AAAA-MM-JJ"){
					$cell = "";
				}else{
					$cell = utf8_encode($cell);
				}
			}
			$row = array_replace($range_array, $row);
		}
		
		self::validateColumns($cells[1]);
		self::autoAssignColumns();
		self::validateParticipantEntry($cells);
	}
}

SardoToAtim::$connection = SardoToAtim::getNewConnection(); 
mysqli_autocommit(SardoToAtim::$connection, false);
