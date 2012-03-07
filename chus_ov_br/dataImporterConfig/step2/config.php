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
	static $db_schema		= "chusovbr";
	static $db_charset		= "utf8";
	static $db_created_id	= 1;//the user id to use in created_by/modified_by fields
	
	static $timezone		= "America/Montreal";
	
	static $input_type		= Config::INPUT_TYPE_XLS;
	
	//if reading excel file
	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/data/DONNEES CLINIQUES et BIOLOGIQUES-OVAIRE_2012_formated.xls";

	static $xls_header_rows = 1;
	
	static $print_queries	= false;//wheter to output the dataImporter generated queries
	static $insert_revs		= true;//wheter to insert generated queries data in revs as well

	static $addon_function_start= 'addonFunctionStart';//function to run at the end of the import process
	static $addon_function_end	= 'addonFunctionEnd';//function to run at the start of the import process
	
	//--------------------------------------

	static $db_connection	= null;
	
	static $addon_queries_end	= array();//queries to run at the start of the import process
	static $addon_queries_start	= array();//queries to run at the end of the import process
	
	static $parent_models	= array();//models to read as parent
	
	static $models			= array();
	
	static $value_domains	= array();
	
	static $config_files	= array();
	
	//--------------------------------------

	static $sample_aliquot_controls = array();
	static $diagnosis_controls = array();
	
	static $participant_id_from_frsq_nbr = array();
	static $data_for_import_from_participant_id = array();
	
	static $summary_msg = array(
		'@@ERROR@@' => array(),  
		'@@WARNING@@' => array(),  
		'@@MESSAGE@@' => array());	
}

//add you start queries here
//Config::$addon_queries_start[] = "..."

//add your end queries here
//Config::$addon_queries_end[] = "..."

//add some value domains names that you want to use in post read/write functions
//Config::$value_domains['health_status']= new ValueDomain("health_status", ValueDomain::ALLOW_BLANK, ValueDomain::CASE_INSENSITIVE);

//add the parent models here
Config::$parent_models[] = "OvaryDiagnosisMaster";

//add your configs
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step2/tablesMapping/ovary_diagnoses.php'; 

//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/no_dossier_chus_identifiers.php'; 
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/ovary_bank_identifiers.php'; 
//Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/breast_bank_identifiers.php'; 

function addonFunctionStart(){
	global $connection;
	
	$file_path = Config::$xls_file_path;
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS Step 2 : CHUS OVBR<br>
	Ovary Data Import<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";		
	
	echo "ALL Consent will be defined as obtained!<br>";
	// ** Data check ** 
	
	$query = "SELECT COUNT(*) FROM participants;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step2: Participant table should be completed");
	}
	
	$query = "SELECT COUNT(*) FROM misc_identifiers;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] < 1) {
		die("Step2: Identifiers table should be completed");
	}	
	
	$query = "SELECT COUNT(*) FROM diagnosis_masters;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] > 0) {
		die("Step2: Diagnoses table should be empty");
	}	

	$query = "SELECT COUNT(*) FROM collections;";
	$results = mysqli_query($connection, $query) or die("addonFunctionStart [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] > 0) {
		die("Step2: Collections table should be empty");
	}	
	
	// ** Set sample aliquot controls **
	
	$query = "select id,sample_type,detail_tablename from sample_controls where sample_type in ('tissue','blood', 'ascite', 'peritoneal wash', 'ascite cell', 'ascite supernatant', 'cell culture', 'serum', 'plasma', 'dna', 'rna', 'blood cell')";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$sample_aliquot_controls[$row['sample_type']] = array('sample_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'aliquots' => array());
	}	
	if(sizeof(Config::$sample_aliquot_controls) != 12) die("get sample controls failed");
	
	foreach(Config::$sample_aliquot_controls as $sample_type => $data) {
		$query = "select id,aliquot_type,detail_tablename,volume_unit from aliquot_controls where flag_active = '1' AND sample_control_id = '".$data['sample_control_id']."'";
		$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
		while($row = $results->fetch_assoc()){
			Config::$sample_aliquot_controls[$sample_type]['aliquots'][$row['aliquot_type']] = array('aliquot_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename'], 'volume_unit' => $row['volume_unit']);
		}	
	}	
	
	
	// ** Set diagnosis controls **
	
	$query = "select id,category,controls_type,detail_tablename from diagnosis_controls where flag_active = '1' AND category IN ('primary','secondary');";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		Config::$diagnosis_controls[$row['category']][$row['controls_type']] = array('diagnosis_control_id' => $row['id'], 'detail_tablename' => $row['detail_tablename']);
	}
		
	// ** Set participant_id / identifier values links array **
	
	$query = "SELECT ctrl.misc_identifier_name, ident.identifier_value, ident.participant_id
	FROM misc_identifier_controls AS ctrl INNER JOIN misc_identifiers AS ident ON ident.misc_identifier_control_id = ctrl.id
	WHERE ctrl.misc_identifier_name LIKE '%FRSQ%' AND ident.deleted != 1";
	$results = mysqli_query($connection, $query) or die(__FUNCTION__." ".__LINE__);
	while($row = $results->fetch_assoc()){
		if(isset(Config::$participant_id_from_frsq_nbr[$row['identifier_value']])) {
			pr($row);
			die('ERR 99887399.1');
		}
		Config::$participant_id_from_frsq_nbr[$row['identifier_value']] = $row['participant_id'];
		
		if(!isset(Config::$data_for_import_from_participant_id[$row['participant_id']])) Config::$data_for_import_from_participant_id[$row['participant_id']] = array('data_imported_from_ov_file' => false, 'data_imported_from_br_file' => false);
		Config::$data_for_import_from_participant_id[$row['participant_id']][$row['misc_identifier_name']][] = $row['identifier_value'];
	}

}

function addonFunctionEnd(){
	global $connection;

	// DIAGNOSIS UPDATE
	
	$query = "UPDATE diagnosis_masters SET primary_id = id WHERE parent_id IS NULL;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = str_replace('diagnosis_masters','diagnosis_masters_revs',$query);
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$query = "UPDATE diagnosis_masters parent, diagnosis_masters child SET child.primary_id = parent.primary_id WHERE child.primary_id IS NULL AND child.parent_id IS NOT NULL AND child.parent_id = parent.id;";
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$query = str_replace('diagnosis_masters','diagnosis_masters_revs',$query);
	mysqli_query($connection, $query) or die("primary_id update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));

	// WARNING DISPLAY
	
	echo "<br><FONT COLOR=\"red\" >
	=====================================================================<br>
	addonFunctionEnd: CCL
	<br>=====================================================================
	</FONT><br>";
	
	if(!empty(Config::$summary_msg['@@ERROR@@'])) {
		echo "<br><FONT COLOR=\"red\" ><b> ** Errors summary ** </b> (".sizeof(Config::$summary_msg['@@ERROR@@'])."):</FONT><br>";
		foreach(Config::$summary_msg['@@ERROR@@'] as $type => $msgs) {
			echo "<br> --> <FONT COLOR=\"red\" >". $type . "</FONT><br>";
			foreach($msgs as $msg) echo "$msg<br>";
		}
	}	
	
	if(!empty(Config::$summary_msg['@@WARNING@@'])) {
		echo "<br><FONT COLOR=\"orange\" ><b> ** Warnings summary ** </b> (".sizeof(Config::$summary_msg['@@WARNING@@'])."):</FONT><br>";
		foreach(Config::$summary_msg['@@WARNING@@'] as $type => $msgs) {
			echo "<br> --> <FONT COLOR=\"orange\" >". $type . "</FONT><br>";
			foreach($msgs as $msg) echo "$msg<br>";
		}
	}	
	
	if(!empty(Config::$summary_msg['@@MESSAGE@@'])) {
		echo "<br><FONT COLOR=\"green\" ><b> ** Message ** </b> (".sizeof(Config::$summary_msg['@@MESSAGE@@'])."):</FONT><br>";
		foreach(Config::$summary_msg['@@MESSAGE@@'] as $type => $msgs) {
			echo "<br> --> <FONT COLOR=\"green\" >". $type . "</FONT><br>";
			foreach($msgs as $msg) echo "$msg<br>";
		}
	}
	
	echo "<br>";
		
}

//=========================================================================================================
// Additional functions
//=========================================================================================================

function pr($arr) {
	echo "<pre>";
	print_r($arr);
}

function customInsertChusRecord($data_arr, $table_name, $is_detail_table = false) {
	global $connection;
	$created = $is_detail_table? array() : array(
		"created"		=> "NOW()", 
		"created_by"	=> Config::$db_created_id, 
		"modified"		=> "NOW()",
		"modified_by"	=> Config::$db_created_id
	);
	
	$insert_arr = array_merge($data_arr, $created);
	$query = "INSERT INTO $table_name (".implode(", ", array_keys($insert_arr)).") VALUES (".implode(", ", array_values($insert_arr)).")";
	mysqli_query($connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	$record_id = mysqli_insert_id($connection);
	
	$rev_insert_arr = array_merge($data_arr, array('id' => "$record_id", 'version_created' => "NOW()"));
	$query = "INSERT INTO ".$table_name."_revs (".implode(", ", array_keys($rev_insert_arr)).") VALUES (".implode(", ", array_values($rev_insert_arr)).")";
	mysqli_query($connection, $query) or die("$table_name record [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	
	return $record_id;	
}

function customGetFormatedDate($date_strg) {
	$date = null;
	if(!empty($date_strg)) {
		//format excel date integer representation
		$php_offset = 946746000;//2000-01-01 (12h00 to avoid daylight problems)
		$xls_offset = 36526;//2000-01-01
		$date = date("Y-m-d", $php_offset + (($date_strg - $xls_offset) * 86400));
		
		if(!preg_match('/^(19|20)([0-9]{2})\-([01][0-9])\-([0-3][0-9])$/', $date, $matches)) die('ERR Wrong date format: '.$date);
	}

	return $date;
}

?>
