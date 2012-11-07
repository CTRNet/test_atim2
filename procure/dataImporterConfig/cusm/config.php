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
	static $db_schema		= "procure";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $bank = 'CUSM';
	static $xls_file_path	= "C:/_My_Directory/Local_Server/ATiM/procure/data/cusm/Donnees_cusm_2012.xls";
	
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
	
	static $consent_control_id = null;
	static $event_controls = array();	
	static $sample_aliquot_controls = array();
	
	static $participant_collections = array();
	static $next_sample_code = 0;
	static $storage_controls = array();
	
// 	static $diagnosis_controls = array();
// 	static $treatment_controls = array();
// 	static $event_controls = array();
// 	
	
// 	static $cytoreduction_values = array();
	
// 	static $ids_from_frsq_nbr = array();
// 	static $participant_id_from_ov_nbr = array();
// 	static $ovary_surgery_id_from_participant_id = array();
	
//	static $data_for_import_from_participant_id = array();
	
	static $summary_msg = array();	
	
}

//add you start queries here
//Config::$addon_queries_start[] = "..."

//add your end queries here
//Config::$addon_queries_end[] = "..."

//add some value domains names that you want to use in post read/write functions
//Config::$value_domains['health_status']= new ValueDomain("health_status", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "Participant";

//add your configs
Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/procure/dataImporterConfig/cusm/tablesMapping/participants.php';
Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/procure/dataImporterConfig/cusm/tablesMapping/consents.php'; 
Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/procure/dataImporterConfig/cusm/tablesMapping/questionnaires.php';
Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/procure/dataImporterConfig/cusm/tablesMapping/path_reports.php';
Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/procure/dataImporterConfig/cusm/tablesMapping/diagnostics.php'; 
Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/procure/dataImporterConfig/cusm/tablesMapping/treatments.php'; 
Config::$config_files[] = 'C:/_My_Directory/Local_Server/ATiM/procure/dataImporterConfig/cusm/tablesMapping/collections.php'; 

//=========================================================================================================
// START functions
//=========================================================================================================
	
function addonFunctionStart(){
	$file_path = Config::$xls_file_path;
	$bank = Config::$bank;
	
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS : PROCURE<br>
	Bank : $bank<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";		
	
	// GET CONTROL DATA
	
	$query = "SELECT id FROM consent_controls WHERE controls_type = 'procure consent form signature';";
	$results = mysqli_query(Config::$db_connection, $query) or die("Consent Control Id [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
	$row = $results->fetch_assoc();
	if(empty($row)) {
		die("No consent contol id");
	}
	Config::$consent_control_id = $row['id'];
	
	$query = "select id,disease_site,event_type,detail_tablename from event_controls where flag_active = '1';";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$event_controls[$row['event_type']] = array('event_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue','blood', 'ascite', 'peritoneal wash', 'ascite cell', 'ascite supernatant', 'cell culture', 'serum', 'plasma', 'dna', 'rna', 'blood cell')";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}
	if(sizeof(Config::$sample_aliquot_controls) != 12) die("get sample controls failed");
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}
	}	
	
	// GET VALUE DOMAIN DATA
	
	Config::$value_domains['procure_questionnaire_version'] = new ValueDomain("procure_questionnaire_version", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);
	Config::$value_domains['procure_questionnaire_version_date'] = new ValueDomain("procure_questionnaire_version_date", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

	// LOAD COLLECTIONS
	
	$query = "select id,storage_type,detail_tablename from storage_controls where flag_active = '1';";
	$results = mysqli_query(Config::$db_connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$storage_controls[$row['storage_type']] = array('storage_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
	
	loadCollections();
	
	return;
}

//=========================================================================================================
// END functions
//=========================================================================================================
	
function addonFunctionEnd(){
	
	// Empty date clean up 
	
	$date_times_to_check = array(
		'consent_masters.consent_signed_date',
		'procure_cd_sigantures.revised_date',
		'event_masters.event_date',
		'procure_ed_lifestyle_quest_admin_worksheets.delivery_date',
		'procure_ed_lifestyle_quest_admin_worksheets.recovery_date',
		'procure_ed_lifestyle_quest_admin_worksheets.verification_date',
		'procure_ed_lifestyle_quest_admin_worksheets.revision_date',
		'procure_ed_lab_diagnostic_information_worksheets.id_confirmation_date',
		'procure_ed_lab_diagnostic_information_worksheets.biopsy_pre_surgery_date',
		'procure_ed_lab_diagnostic_information_worksheets.aps_pre_surgery_date',
		'procure_ed_lab_diagnostic_information_worksheets.biopsy_date',
		'collections.collection_datetime',
		'specimen_details.reception_datetime'		
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
	
   	// INVENTORY COMPLETION
		
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
	
	
// //	$query = "UPDATE aliquot_masters SET barcode=id;";
// //	mysqli_query(Config::$db_connection, $query) or die("barcode update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));
// //	$query = "UPDATE aliquot_masters_revs SET barcode=id;";
// //	mysqli_query(Config::$db_connection, $query) or die("barcode update [".__LINE__."] qry failed [".$query."] ".mysqli_error(Config::$db_connection));


	
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
				foreach($msgs as $msg) echo "$msg<br>";
			}
		}	
		
		if(!empty($msg_arr['@@WARNING@@'])) {
			echo "<br><FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> </FONT><br>";
			foreach($msg_arr['@@WARNING@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"orange\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo "$msg<br>";
			}
		}	
		
		if(!empty($msg_arr['@@MESSAGE@@'])) {
			echo "<br><FONT COLOR=\"green\" ><b> ** Message ** </b> </FONT><br>";
			foreach($msg_arr['@@MESSAGE@@'] as $type => $msgs) {
				echo "<br> --> <FONT COLOR=\"green\" >". utf8_decode($type) . "</FONT><br>";
				foreach($msgs as $msg) echo "$msg<br>";
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

function customInsertRecord($data_arr, $table_name, $is_detail_table = false/*, $flush_empty_fields = false*/) {
	$created = $is_detail_table? array() : array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
	);
	
	//if($flush_empty_fields) {
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
	if(empty($date)) {
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
	} else if(preg_match('/^(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $date.'-01-01', 'accuracy' => 'm');
	} else if(preg_match('/^([0-3][0-9])\/([01][0-9])\/(19|20)([0-9]{2})$/',$date,$matches)) {
		return array('date' => $matches[3].$matches[4].'-'.$matches[2].'-'.$matches[1], 'accuracy' => 'c');
	} else {
		Config::$summary_msg[$data_type]['@@ERROR@@']['Date Format Error'][] = "Format of date '$date' is not supported! [field '$field' - line: $line]";
		return null;
	}	
}

?>
