<?php

class Config{
	const	INPUT_TYPE_CSV = 1;
	const	INPUT_TYPE_XLS = 2;
	
	//Configure as needed-------------------
	//db config
	static $db_ip			= "127.0.0.1";
	static $db_port 		= "3306";
	static $db_user 		= "root";
	static $db_pwd			= "";
	static $db_schema		= "ovcare";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	static $migration_date = null;
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $xls_file_path = "C:/_Perso/Server/ovcare/data/OvCaRe_dev.xls";	
	static $use_windows_xls_offset = false;	
	
	static $xls_header_rows = 1;
	
	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= true;//wheter to insert generated queries data in revs as well

	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	static $line_break_tag = '<br>';
	
	//--------------------------------------

	static $db_connection	= null;
	
	static $addon_queries_end	= array();//queries to run at the start of the import process
	static $addon_queries_start	= array();//queries to run at the end of the import process
	
	static $parent_models	= array();//models to read as parent
	
	static $models			= array();
	
	static $value_domains	= array();
	
	static $config_files	= array();
	
	//--------------------------------------	
	
	static $limit_warning_display = true;
	static $summary_msg = array();	
		
	static $misc_identifier_controls = array();
	static $consent_control_id = null;
	static $diagnosis_control_id = null;
	static $event_controls = array();	
	static $sample_aliquot_controls = array();
	static $recorded_studies = array();
	static $treatment_controls = array();
	
	static $voas_to_ids = array();
	
	/*
	static $participant_collections = array();
	static $next_sample_code = 0;
	
	static $storage_controls = array();
	static $storages = array();
	static $previous_storage_master_id = 0;
	static $previous_left_right = 0;
	static $storage_data_from_sample_type_and_label = array();
	static $additional_dna_miR_from_storage = array();
	
	
	static $extra_prostatic_extension_unkw_value = array();
	static $extensive_margin_unkw_value = array();
	
	static $participant_nominal_data = array();
	static $participant_notes = array();
	*/
}

//add the parent models here
Config::$parent_models[] = "Collection";

//add your configs
$table_mapping_path = 'C:/_Perso/Server/ovcare/dataImporterConfig/tablesMapping/';
Config::$config_files[] = $table_mapping_path.'clinical_annotations.php'; 
Config::$config_files[] = $table_mapping_path.'collections.php'; 

//=========================================================================================================
// START functions
//=========================================================================================================
	
function addonFunctionStart(){
	$file_path = Config::$xls_file_path;
	
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS : OVCARE<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>
	TODO: Excel clean up should be done first<br>
	 - Copy 'Patient ID', 'VOA Number', 'Duplicate Patients::VOA Number' of Profile worksheet to a new work sheet (at the end) you will rename to VOA Control<br>
	 - Order Profile worksheet on VOA#<br>
	 - Then check all lines with no VOA# are empty excepted field Duplicate Patients::VOA Number<br>
	 - Then delete these lines having no VOa#<br><br>";	
	
	$query = "select NOW() AS migration_date;";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	$row = $results->fetch_assoc();
	Config::$migration_date = $row['migration_date'];
	
	// GET CONTROL DATA
	
	// MiscIdentifier
	$query = "select id, misc_identifier_name, flag_unique FROM misc_identifier_controls WHERE flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$misc_identifier_controls[$row['misc_identifier_name']] = array('id' => $row['id'], 'flag_unique' => $row['flag_unique']);
	}
	
	//consent table => cd_nationals
	$query = "SELECT id FROM consent_controls WHERE controls_type = 'OvCaRe' AND flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("Consent Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$row = $results->fetch_assoc();
	if(empty($row)) {
		die("No consent contol id");
	}
	Config::$consent_control_id = $row['id'];
	
	//dx => table ovcare_dxd_ovaries 
	$query = "SELECT id FROM diagnosis_controls WHERE category = 'primary' AND controls_type = 'ovary' AND flag_active = 1;";
	$results = mysqli_query(Config::$db_connection, $query) or die("Dx Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$row = $results->fetch_assoc();
	if(empty($row)) {
		die("No dx contol id");
	}
	Config::$diagnosis_control_id = $row['id'];
	
    //event => tables ed_all_clinical_followups, ovcare_ed_study_inclusions, ovcare_ed_ca125s, ovcare_ed_brcas
    $query = "select id,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$event_controls[$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	//trt => txd_surgeries ovcare_txd_biopsies
	$query = "select id,tx_method,detail_tablename from treatment_controls where flag_active = '1' AND tx_method IN ('procedure - surgery','procedure - biopsy');";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$treatment_controls[$row['tx_method']] = array('treatment_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}	
	
	//sample
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue', 'blood', 'urine', 'serum', 'plasma', 'pbmc','centrifuged urine','concentrated urine','rna','dna')";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}
	if(sizeof(Config::$sample_aliquot_controls) != 10) die("get sample controls failed");
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}
	}
	
	// GET VALUE DOMAIN DATA
	
	$query = "SELECT id, title FROM study_summaries";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$recorded_studies[strtolower($row['title'])] = $row['id'];
	}
	
	
	
	
//	Config::$value_domains['procure_questionnaire_version'] = new ValueDomain("procure_questionnaire_version", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
//	Config::$value_domains['procure_questionnaire_version_date'] = new ValueDomain("procure_questionnaire_version_date", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

	// LOAD STORAGE CONTROL
/*	
	$query = "select id,storage_type,detail_tablename from storage_controls where flag_active = '1';";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$storage_controls[$row['storage_type']] = array('storage_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
*/
	
	//Launch clinical annotation creation

	loadClinicalAnnotation();
	
	return;
}

//=========================================================================================================
// END functions
//=========================================================================================================
	
function addonFunctionEnd(){

	// Empty date clean up 
	
	$date_times_to_check = array(
		'consent_masters.consent_signed_date',
		'event_masters.event_date',
		'treatment_masters.start_date',
		'treatment_masters.finish_date',
		'collections.collection_datetime',
		'specimen_details.reception_datetime',
		'derivative_details.creation_datetime',
		'aliquot_masters.storage_datetime'			
	);
	foreach($date_times_to_check as $table_field) {
		$names = explode(".", $table_field);
		$query = "UPDATE ".$names[0]." SET ".$names[1]." = null,".$names[1]."_accuracy = null WHERE ".$names[1]." LIKE '0000-00-00%'";
		mysqli_query(Config::$db_connection, $query) or die("Error on addonFunctionEnd : Set field $table_field 0000-00-00 to null. [$query] ");
		if(Config::$insert_revs){
			$query = "UPDATE ".$names[0]."_revs SET ".$names[1]." = null,".$names[1]."_accuracy = null WHERE ".$names[1]." LIKE '0000-00-00%'";
			mysqli_query(Config::$db_connection, $query) or die("Error on addonFunctionEnd :Set field $table_field 0000-00-00 to null (revs). [$query] ");
		}
	}
	
	// PROFILE CLEAN UP
	
	$query = "UPDATE participants SET last_modification = created WHERE last_modification LIKE '0000-00-00%'";
	mysqli_query(Config::$db_connection, $query) or die("Error on addonFunctionEnd :Update field participants.last_modification. [$query] ");
	if(Config::$insert_revs){
		$query = "UPDATE participants_revs rev, participants part SET rev.last_modification = part.last_modification WHERE rev.last_modification LIKE '0000-00-00%' AND rev.id = part.id";
		mysqli_query(Config::$db_connection, $query) or die("Error on addonFunctionEnd :Update field participants.last_modification. [$query] ");
	}	
	
	// Dx CLEAN UP
	
	$query = "UPDATE diagnosis_masters SET primary_id = id WHERE diagnosis_control_id = ".Config::$diagnosis_control_id;
	mysqli_query(Config::$db_connection, $query) or die("Error $query] ");
	if(Config::$insert_revs){
		$query = str_replace('diagnosis_masters', 'diagnosis_masters_revs', $query);
		mysqli_query(Config::$db_connection, $query) or die("Error [$query] ");
	}
	// INVENTORY COMPLETION
	
	$query = "UPDATE collections SET collection_datetime_accuracy = 'm' WHERE collection_datetime_accuracy = 'c';";
	if(Config::$insert_revs) {
		mysqli_query(Config::$db_connection, str_replace('collections', 'collections_revs', $query)) or die("initial_specimen_sample_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	}
	$query = "UPDATE sample_masters SET sample_code=id;";
	mysqli_query(Config::$db_connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$query = "UPDATE sample_masters SET initial_specimen_sample_id=id WHERE parent_id IS NULL;";
 	mysqli_query(Config::$db_connection, $query) or die("initial_specimen_sample_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
	if(Config::$insert_revs) {
		$query = "UPDATE sample_masters_revs SET sample_code=id;";
		mysqli_query(Config::$db_connection, $query) or die("SampleCode update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));	
 		$query = "UPDATE sample_masters_revs SET initial_specimen_sample_id=id WHERE parent_id IS NULL;";
 		mysqli_query(Config::$db_connection, $query) or die("initial_specimen_sample_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));	
	}
	
	// TO PERMISSIONS REGENERATE
	
	$query = "UPDATE versions SET permissions_regenerated = 0;";
	mysqli_query(Config::$db_connection, $query) or die("versions update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
		
	dislayErrorAndMessage();
	
	return;
}

function dislayErrorAndMessage() {
	$max_nbr_of_msg_displayed = (Config::$limit_warning_display)? '2000' : '';
	foreach(Config::$summary_msg as $data_type => $msg_arr) {
		
		echo "<br><br><FONT COLOR=\"blue\" >
		=====================================================================<br><br>
		PROCESS SUMMARY: $data_type
		<br><br>=====================================================================
		</FONT><br>";
			
		if(!empty($msg_arr['@@ERROR@@'])) {
			echo "<br><FONT COLOR=\"red\" ><b> ** Errors summary ** </b> </FONT><br>";
			foreach($msg_arr['@@ERROR@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"red\" >". utf8_decode($type) . "</FONT><br>";
				$counter = 0;
				foreach($msgs as $msg) {
					$counter++;
					if($max_nbr_of_msg_displayed && $counter > $max_nbr_of_msg_displayed) {
						echo "...<br>";
						echo "...<br>";
						break;
					}
					echo utf8_decode($msg)."<br>";
				}
			}
		}	
		
		if(!empty($msg_arr['@@WARNING@@'])) {
			echo "<br><FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> </FONT><br>";
			foreach($msg_arr['@@WARNING@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"orange\" >". utf8_decode($type) . "</FONT><br>";
				$counter = 0;
				foreach($msgs as $msg) {
					$counter++;
					if($max_nbr_of_msg_displayed && $counter > $max_nbr_of_msg_displayed) {
						echo "...<br>";
						echo "...<br>";
						break;
					}
					echo utf8_decode($msg)."<br>";
				}
			}
		}	
		
		if(!empty($msg_arr['@@MESSAGE@@'])) {
			echo "<br><FONT COLOR=\"green\" ><b> ** Message ** </b> </FONT><br>";
			foreach($msg_arr['@@MESSAGE@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT><br>";
				$counter = 0;
				foreach($msgs as $msg) {
					$counter++;
					if($max_nbr_of_msg_displayed && $counter > $max_nbr_of_msg_displayed) {
						echo "...<br>";
						echo "...<br>";
						break;
					}
					echo utf8_decode($msg)."<br>";
				}
			}
		}
	}
}


//=========================================================================================================
// Additional functions
//=========================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function customInsertRecord($data_arr, $table_name, $is_detail_table = false) {
	$created = $is_detail_table? array() : array(
		"created"		=> "'".Config::$migration_date."'", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "'".Config::$migration_date."'",
		"modified_by"	=> Config::$db_created_id
	);
	
	$data_to_insert = array();
	foreach($data_arr as $key => $value) {
		if(strlen($value)) {
			$data_to_insert[$key] = "'".$value."'";
		}
	}
	//}
	
	$insert_arr = array_merge($data_to_insert, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query(Config::$db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	
	$record_id = mysqli_insert_id(Config::$db_connection);
	$additional_fields = $is_detail_table? array('version_created' => "NOW()") : array('id' => "$record_id", 'version_created' => "NOW()");
	if(Config::$insert_revs) {
		$rev_insert_arr = array_merge($data_to_insert, $additional_fields);
		$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
		mysqli_query(Config::$db_connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	}
	
	return $record_id;	
}

function getDateAndAccuracy($date, $data_type, $field, $line) {
	if(empty($date) || (strtoupper($date) == 'N/A')) {
		return null;
	
	} else if(preg_match('/^([0-9]+)$/', $date, $matches)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date - $xls_offset) * 86400));
		return array('date' => $date, 'accuracy' => 'c');
		
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/',$date,$matches)) {
		return array('date' => $date, 'accuracy' => 'c');
	} else if(preg_match('/^(19|20)([0-9]{2})\-([01][0-9])$/',$date,$matches)) {
		return array('date' => $date.'-01', 'accuracy' => 'd');
	} else if(preg_match('/^((19|20)([0-9]{2})\-([01][0-9]))\-unk$/',$date,$matches)) {
		return array('date' => $matches[1].'-01', 'accuracy' => 'd');
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^([0-3][0-9])\/([01][0-9])\/(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else if(preg_match('/^([0-3][0-9])\-([01][0-9])\-(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else {
		Config::$summary_msg[$data_type]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [field '$field' - line: $line]";
		return null;
	}	
}

function getDateTimeAndAccuracy($date, $time, $data_type, $field_date, $field_time, $line, $worksheetname = '') {
	$time = str_replace('N/A','',$time);
	$formatted_date = "''";
	$formatted_date_accuracy = "''";
	$tmp_date = getDateAndAccuracy($date, $data_type, $field_date, $line);
	if($tmp_date) {
		$formatted_date = $tmp_date['date'];
		$formatted_date_accuracy = $tmp_date['accuracy'];
	} else {
		if(!empty($time)) Config::$summary_msg[$data_type]['@@ERROR@@']['DateTime: Only time is set'][] = "Format of datetime '$date $time' is not supported. No datetime will be set! [fields '$field_date' & '$field_time' - line: $line - worksheet: $worksheetname]";
		return null;
	}
	
	if(empty($time)) {
		return array('datetime' => $formatted_date.' 00:00', 'accuracy' => str_replace('c', 'h', $formatted_date_accuracy));
	} else {
		if($formatted_date_accuracy != 'c') {
			Config::$summary_msg[$data_type]['@@ERROR@@']['Time set for an unaccuracy date'][] = "Format of datetime '$date $time' is not supported. No datetime will be set! [fields '$field_date' & '$field_time' - line: $line - worksheet: $worksheetname]";
			return null;
		} else if(preg_match('/^(0{0,1}[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/',$time, $matches)) {
			return array('datetime' => $formatted_date.' '.((strlen($time) == 5)? $time : '0'.$time), 'accuracy' => 'c');
		} else if(preg_match('/^0\.[0-9]+$/', $time)) {			
			$hour = floor(24*$time);
			$mn = round((24*$time - $hour)*60);
			if($mn == '60') {
				$mn = '00';
				$hour += 1;
			}
			if($hour > 23) die('ERR time >= 24 79904044--4-44');	
			$time=$hour.':'.$mn;		
			return array('datetime' => $formatted_date.' '.((strlen($time) == 5)? $time : '0'.$time), 'accuracy' => 'c');
		} else {		
			//Config::$summary_msg[$data_type]['@@ERROR@@']['Time Format Error'][] = "Format of time '$time' is not supported! [fields '$field_date' & '$field_time' - line: $line]";
			die("ERR time format should be h:mm see value $time for field $field_time' line '$line' [$worksheetname] - Be sure cell format = personalisé hh:mm");
			//return null;
		}
	}
}

function customArrayCombineAndUtf8Encode($headers, $data) {
	$line_data = array();
	foreach($headers as $key => $field) {
		if(isset($data[$key])) {
			$line_data[utf8_encode($field)] = utf8_encode($data[$key]);
		} else {
			$line_data[utf8_encode($field)] = '';
		}
	}
	return $line_data;
}

?>
