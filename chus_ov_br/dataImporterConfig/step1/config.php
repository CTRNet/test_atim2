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
	static $xls_file_path	= "C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/data/BTD cancer ovaire et sein Sherbrooke Recrutement-2012-03-14_revised.xls";
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

	static $patient_profile_data_from_patient_nbr = array();
	static $pateint_nbr_from_chus_nbr = array();
	static $chus_nbr_already_recorded = array();
	static $bank_nbr_already_recorded = array();
	
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
Config::$parent_models[] = "Participant";

//add your configs
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/participants.php'; 

Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/no_dossier_chus_identifiers.php'; 
Config::$config_files[] = 'C:/NicolasLucDir/LocalServer/ATiM/chus_ovbr/dataImporterConfig/step1/tablesMapping/bank_identifiers.php'; 

function addonFunctionStart(){
	global $connection;
	
	$file_path = Config::$xls_file_path;
	echo "<br><FONT COLOR=\"green\" >
	=====================================================================<br>
	DATA EXPORT PROCESS Step 1 : CHUS OVBR<br>
	Patient Identifier Import<br>
	source_file = $file_path<br>
	<br>=====================================================================
	</FONT><br>";		
	
	$query = "SELECT COUNT(*) FROM participants;";
	$results = mysqli_query($connection, $query) or die("participant_identifier update [".__LINE__."] qry failed [".$query."] ".mysqli_error($connection));
	$row = $results->fetch_assoc();
	if($row['COUNT(*)'] > 0) {
		die("Step1: Participant table should be empty");
	}
	
	flush();
}

function addonFunctionEnd(){
	global $connection;

	// WARNING DISPLAY
	
	echo "<br><FONT COLOR=\"red\" >
	=====================================================================<br>
	PROCESS SUMMARY
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

?>
