<?php
error_reporting(E_ALL | E_STRICT);
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
	static $censure = null;
	
	static $connection = null;
	
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
		if(array_key_exists('Prénom', self::$columns)){
			self::$first_name = 'Prénom';
		}
		if(array_key_exists('Nom', self::$columns)){
			self::$last_name = 'Nom';
		}
		if(array_key_exists('Date de naissance', self::$columns)){
			self::$birth_date = 'Date de naissance';
		}
		if(array_key_exists('RAMQ', self::$columns)){
			self::$ramq = 'RAMQ';
		}
		if(array_key_exists('Date dernier contact', self::$columns)){
			self::$last_contact_date = 'Date dernier contact';
		}
		if(array_key_exists('Date du décès', self::$columns)){
			self::$date_of_death = 'Date du décès';
		}
		if(array_key_exists('Cause de décès', self::$columns)){
			self::$cause_of_death = 'Cause de décès';
		}
		if(array_key_exists('Censure (0 = vivant, 1 = mort)', self::$columns)){
			self::$censure = 'Censure (0 = vivant, 1 = mort)';
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
		$to_update = array();
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
		if(self::$birth_date != null && $xls_row[self::$columns[self::$birth_date]] != $sql_row['date_of_birth']){
			if(empty($sql_row['date_of_birth'])){
				printf("UPDATE: Participant at line [%d]. Birth date from [%s] to [%s]\n", $line, $sql_row['date_of_birth'], $xls_row[self::$columns[self::$birth_date]]);
				$to_update['date_of_birth'] = $xls_row[self::$columns[self::$birth_date]];
				$to_update['date_of_birth_accuracy'] = 'c';
			}else{
				printf("WARNING: Date of birth difference for participant at line [%d]. File [%s]. ATiM [%s].\n", $line, $xls_row[self::$columns[self::$birth_date]], $sql_row['date_of_birth']);
			}
		}
		if(self::$last_contact_date != null && $xls_row[self::$columns[self::$last_contact_date]] != $sql_row['qc_nd_last_contact']){
			if(empty($sql_row['qc_nd_last_contact'])){
				printf("UPDATE: Participant at line [%d]. Last contact from [%s] to [%s]\n", $line, $sql_row['qc_nd_last_contact'], $xls_row[self::$columns[self::$last_contact_date]]);
				$to_update['qc_nd_last_contact'] = $xls_row[self::$columns[self::$last_contact_date]];
			}
		}
		if(self::$censure != null){
			if($xls_row[self::$columns[self::$censure]] == 1 && $sql_row['vital_status'] != 'deceased'){
				printf("UPDATE: Participant at line [%d]. Vital status from [%s] to [%s]\n", $line, $sql_row['vital_status'], 'deceased');
				$to_update['vital_status'] = 'deceased';
				if(self::$date_of_death != null && $xls_row[self::$columns[self::$date_of_death]] != $sql_row['date_of_death']){
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
			}else if($xls_row[self::$columns[self::$censure]] == 0 && $sql_row['vital_status'] != 'alive'){
				printf("UPDATE: Participant at line [%d]. Vital status from [%s] to [%s]\n", $line, $sql_row['vital_status'], 'alive');
				$to_update['vital_status'] = 'alive';
			}
		}else{
			die("ERROR: Censure not defined\n");
		}
	}
	
	/**
	 * Validates that each participant is found with the proper ids, first name
	 * and last name.
	 * @param array $cells
	 */
	static function validateParticipantEntry(array $cells){
		$errors = false;
		reset($cells);
		next($cells);//skip the first line
		
		$query = "INSERT INTO misc_identifiers (identifier_value, misc_identifier_control_id, participant_id, created, created_by, modified, modified_by, deleted) VALUES (?, ?, ?, NOW(), 1, NOW(), 1, 0)";
		$stmt = self::$connection->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".self::$connection->error."\n");
		
		$query = "SELECT * FROM misc_identifiers AS mi
			INNER JOIN participants AS p ON mi.participant_id=p.id
			WHERE mi.misc_identifier_control_id IN(".implode(', ', self::$bank_identifier_ctrl_ids).") AND mi.identifier_value=?";
		$connection1 = self::getNewConnection();
		$stmt1 = $connection1->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n");
		$sql_row1 = bindRow($stmt1);
		
		$query = "SELECT participant_id FROM misc_identifiers WHERE (identifier_value=? OR identifier_value=?) AND misc_identifier_control_id IN(".implode(',', self::$hospital_identifier_ctrl_ids).")";
		$connection2 = self::getNewConnection();
		$stmt2 = $connection2->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$connection2->error."\n");
		$sql_row2 = bindRow($stmt2);
		
		$query = "SELECT identifier_value FROM misc_identifiers WHERE participant_id=? AND misc_identifier_control_id IN(".implode(',', self::$hospital_identifier_ctrl_ids).")";
		$connection3 = self::getNewConnection();
		$stmt3 = $connection3->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$connection3->error."\n");
		$sql_row3 = bindRow($stmt3);
		
		$query = "SELECT identifier_value FROM misc_identifiers WHERE participant_id=? AND misc_identifier_control_id=".self::$ramq_ctrl_id;
		$connection4 = self::getNewConnection();
		$stmt4 = $connection4->prepare($query) or die('Prep failed in function ['.__FUNCTION__.'] in file ['.__FILE__.'] at line ['.__LINE__."]\n----".$connection4->error."\n");
		$sql_row4 = bindRow($stmt4);
		
		while($row = next($cells)){
			$stmt1->bind_param("s", $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]]);
			$stmt1->execute();
			if(!$stmt1->fetch()){
				$errors = true;
				printf("ERROR: No participant matches bank id [%s] at line [%d]\n", $row[self::$columns[self::$bank_identifier_ctrl_ids_column_name]], key($cells));
				continue; 
			}
			
			//quand différent: ne rien faire (ou warning)
			//si y'en a pas, ajouter dans ATiM
			$short_hospital_number = substr($row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]], 1);
			$stmt2->bind_param("ss", $short_hospital_number, $row[self::$columns[self::$hospital_identifier_ctrl_ids_column_name]]);
			$stmt2->execute();
			if(!$stmt2->fetch()){
				//Unmatched hospital number
				$stmt3->bind_param("i", $sql_row1['participant_id']);
				$stmt3->execute();
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
			
			self::validateParticipantData($row, $sql_row1, key($cells));
			if(self::$ramq != null){
				$stmt4->bind_param("i", $sql_row2['participant_id']);
				$stmt4->execute();
				if($stmt4->fetch() && $sql_row4['identifier_value'] != $row[self::$columns[self::$ramq]]){
					printf("WARNING: RAMQ for participant at line [%d] differs from the database.\n", key($cells)); 
				}
			}
			
			
			if($stmt1->fetch()){
				$errors = true;
				printf("ERROR: More than one participant matches bank id [%s] at line [%d]\n", $row[self::$columns[self::$bank_identifier_ctrl_id_column_name]], key($cells));
			}
		}
		
		$stmt4->close();
		$stmt3->close();
		$stmt2->close();
		$stmt1->close();
		$stmt->close();
		$connection4->close();
		$connection3->close();
		$connection2->close();
		$connection1->close();
		
		if($errors){
			die("Participant validation failed\n");
		}
	}
	
	static function basicChecks(&$cells){
		//put all indexes in all rows
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
		self::validateParticipantEntry($cells);
	}
}

SardoToAtim::$connection = SardoToAtim::getNewConnection(); 
mysqli_autocommit(SardoToAtim::$connection, false);

// $result = SardoToAtim::$connection->query("SELECT last_name FROM participants WHERE id=5960") or die(SardoToAtim::$connection->error);
// $row = $result->fetch_assoc();
// print_r($row);
// $row['last_name'] = strtr($row['last_name'], SardoToAtim::$accents_equivalent);
// printf("TEST [%s]\n", $row['last_name']);
// die('end'); 